public with sharing class TestQuestionAnswerTriggerHandler {
    public static void changeEmployeeTestNumberAnswers(List<TestQuestionAnswer__c> questionAnswers) {
        List<EmployeeTest__c> testsToUpdate = new List<EmployeeTest__c>();
        
        List<AggregateResult> aggrTests = [SELECT TestQuestion__r.Employee_test__c TestId 
                                           FROM TestQuestionAnswer__c 
                                           WHERE Id IN :questionAnswers 
                                           GROUP BY TestQuestion__r.Employee_test__c ];
        
        for(AggregateResult aggrResult : aggrTests) {
        	Id testId = (Id)aggrResult.get('TestId');
            testsToUpdate.add(new EmployeeTest__c(Id = testId));
        }
                
        List<AggregateResult> result = [SELECT TestQuestion__r.Employee_test__c TestId, Count(Id) NumberAnswers 
                                        FROM TestQuestionAnswer__c
                                        WHERE TestQuestion__r.Employee_test__c IN :testsToUpdate 
                                        GROUP BY TestQuestion__r.Employee_test__c];

        testsToUpdate.clear();
        
        for (AggregateResult aggrResult : result) {
            Id testId = (Id)aggrResult.get('TestId');
            Integer numAnswers = (Integer)aggrResult.get('NumberAnswers');
            
            testsToUpdate.add(new EmployeeTest__c(Id = testId, NumberAnswers__c = numAnswers));
        }

        update testsToUpdate;
    }
}