public with sharing class UpdateTestNumberAnswersFutureMethod {
    
    @future
    public static void executeUpdateTestNumberAnswers(List<Id> testsIds) {
        List<EmployeeTest__c> testsToUpdate = new List<EmployeeTest__c>();

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

            testsIds.remove(testsIds.indexOf(testId));
        }

        for (Id testId : testsIds) {
            testsToUpdate.add(new EmployeeTest__c(Id = testId, NumberAnswers__c = 0));    
        }

        if (!testsToUpdate.isEmpty()) {          
            update testsToUpdate;
        }
    }
}
