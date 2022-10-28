public with sharing class TestQuestionAnswerTriggerHandler {
    public static void changeUpdatedEmployeeTestNumberAnswers(List<TestQuestionAnswer__c> questionAnswers, Map<Id, TestQuestionAnswer__c> oldQuestionAnswers) {
        List<TestQuestionAnswer__c> questionAnswersWithChangedActive = new List<TestQuestionAnswer__c>();
        
        for (TestQuestionAnswer__c answer : questionAnswers) {
            if (answer.Active__c != oldQuestionAnswers.get(answer.Id).Active__c) {
                questionAnswersWithChangedActive.add(answer);        
            }
        }
        
        if (!questionAnswersWithChangedActive.isEmpty()) {           
            changeEmployeeTestNumberAnswers(questionAnswersWithChangedActive);
        }
    }

    public static void changeEmployeeTestNumberAnswers(List<TestQuestionAnswer__c> questionAnswers) {
        List<EmployeeTest__c> testsToUpdate = new List<EmployeeTest__c>();
        Set<Id> testsIdsWithNumberAnswers = new Set<Id>();

        Set<Id> testsIds = getTestIdsForQuestionAnswers(questionAnswers);        
        List<AggregateResult> result = [SELECT TestQuestion__r.Employee_test__c TestId, 
                                            MIN(TestQuestion__r.Employee_test__r.NumberAnswers__c) OldNumberAnswers, 
                                            COUNT(Id) NumberAnswers
                                        FROM TestQuestionAnswer__c
                                        WHERE TestQuestion__r.Employee_test__c IN :testsIds
                                            AND Active__c = TRUE 
                                        GROUP BY TestQuestion__r.Employee_test__c];
        
        for (AggregateResult aggrResult : result) {
            Id testId = (Id)aggrResult.get('TestId');
            Integer OldNumberAnswers = Integer.valueOf(aggrResult.get('OldNumberAnswers'));
            Integer numAnswers = (Integer)aggrResult.get('NumberAnswers');

            if (OldNumberAnswers != numAnswers) {             
                testsToUpdate.add(new EmployeeTest__c(Id = testId, NumberAnswers__c = numAnswers));
            }

            testsIdsWithNumberAnswers.add(testId);
        }

        for (Id testId : testsIds) {
            if (!testsIdsWithNumberAnswers.contains(testId)) {
                testsToUpdate.add(new EmployeeTest__c(Id = testId, NumberAnswers__c = 0)); 
            }   
        }

        if (!testsToUpdate.isEmpty()) {          
            update testsToUpdate;
        }
    }

    public static void changeEmployeeTestNumberAnswersWithMap(List<TestQuestionAnswer__c> questionAnswers) {
        List<EmployeeTest__c> testsToUpdate = new List<EmployeeTest__c>();

        Set<Id> testsIds = getTestIdsForQuestionAnswers(questionAnswers);
        
        Map<Id, NumberTestQuestionAnswers> testsIdsWithNumberAnswers = new Map<Id, NumberTestQuestionAnswers>();
        for (TestQuestionAnswer__c answer : [SELECT Id, TestQuestion__r.Employee_test__c, TestQuestion__r.Employee_test__r.NumberAnswers__c
                                            FROM TestQuestionAnswer__c
                                            WHERE TestQuestion__r.Employee_test__c IN :testsIds 
                                                AND Active__c = TRUE]) {

            Id testId = answer.TestQuestion__r.Employee_test__c;
            Integer oldNumberAnswers = Integer.valueOf(answer.TestQuestion__r.Employee_test__r.NumberAnswers__c); 
            
            if (testsIdsWithNumberAnswers.containsKey(testId)) {
                testsIdsWithNumberAnswers.put(testId, 
                    new NumberTestQuestionAnswers(oldNumberAnswers, testsIdsWithNumberAnswers.get(testId).NewNumberAnswers + 1));        
            } else {
                testsIdsWithNumberAnswers.put(testId, 
                    new NumberTestQuestionAnswers(oldNumberAnswers, 1));    
            }
        }

        for (Id key : testsIdsWithNumberAnswers.keySet()) {            
            NumberTestQuestionAnswers mapValue = testsIdsWithNumberAnswers.get(key);
            Integer OldNumberAnswers = mapValue.OldNumberAnswers;
            Integer numAnswers = mapValue.NewNumberAnswers;

            if (mapValue.OldNumberAnswers != mapValue.NewNumberAnswers) {             
                testsToUpdate.add(new EmployeeTest__c(Id = key, NumberAnswers__c = mapValue.NewNumberAnswers));
            }       
        }

        if (!testsToUpdate.isEmpty()) {          
            update testsToUpdate;
        }
    }

    private static Set<Id> getTestIdsForQuestionAnswers(List<TestQuestionAnswer__c> questionAnswers) {
        Set<Id> questionsIds = new Set<Id>();
        for (TestQuestionAnswer__c answer : questionAnswers) {
            questionsIds.add(answer.TestQuestion__c);
        }

        Set<Id> testsIds = new Set<Id>();
        for (TestQuestion__c question : [SELECT Id, Employee_Test__c
                                        FROM TestQuestion__c
                                        WHERE Id IN :questionsIds]) {
            testsIds.add(question.Employee_Test__c);                               
        }

        return testsIds;
    }

    private class NumberTestQuestionAnswers {
        public Integer OldNumberAnswers {get; set;}
        public Integer NewNumberAnswers {get; set;}

        public NumberTestQuestionAnswers(Integer oldNumber, Integer newNumber) {
            OldNumberAnswers = oldNumber;
            NewNumberAnswers = newNumber;   
        }
    }
}