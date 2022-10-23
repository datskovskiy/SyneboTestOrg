public with sharing class TestQuestionAnswerTriggerHandler {
    public static void changeEmployeeTestNumberAnswers(List<TestQuestionAnswer__c> questionAnswers) {
        List<EmployeeTest__c> testsToUpdate = new List<EmployeeTest__c>();

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

            if (OldNumberAnswers <> numAnswers) {             
                testsToUpdate.add(new EmployeeTest__c(Id = testId, NumberAnswers__c = numAnswers));
            }
        }

        if (!testsToUpdate.isEmpty()) {          
            update testsToUpdate;
        }
    }

    public static void changeEmployeeTestNumberAnswersWithMap(List<TestQuestionAnswer__c> questionAnswers) {
        List<EmployeeTest__c> testsToUpdate = new List<EmployeeTest__c>();

        Set<Id> testsIds = getTestIdsForQuestionAnswers(questionAnswers);
        
        Map<Id, Integer> testsIdsWithNumberAnswers = new Map<Id, Integer>();
        for (TestQuestionAnswer__c answer : [SELECT Id, TestQuestion__r.Employee_test__c
                                            FROM TestQuestionAnswer__c
                                            WHERE TestQuestion__r.Employee_test__c IN :testsIds 
                                                AND Active__c = TRUE]) {
            Id testId = answer.TestQuestion__r.Employee_test__c; 
            
            if (testsIdsWithNumberAnswers.containsKey(testId)) {
                testsIdsWithNumberAnswers.put(testId, testsIdsWithNumberAnswers.get(testId) + 1);        
            } else {
                testsIdsWithNumberAnswers.put(testId, 1);    
            }
        }

        for (Id key : testsIdsWithNumberAnswers.keySet()) {
            Integer numAnswers = testsIdsWithNumberAnswers.get(key);

            testsToUpdate.add(new EmployeeTest__c(Id = key, NumberAnswers__c = testsIdsWithNumberAnswers.get(key)));        
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
}