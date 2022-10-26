public with sharing class UpdateTestNumberAnswersScheduledBatch implements Database.Batchable<sObject>, Schedulable {
    String Email;
    String query = 'SELECT Id FROM EmployeeTest__c WHERE Active__c = TRUE';
    
    public UpdateTestNumberAnswersScheduledBatch(String mail) {
    	Email = mail;    
    }
    
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new UpdateTestNumberAnswersScheduledBatch(Email));
    }
    
    public Database.QueryLocator start(Database.BatchableContext bc){
      return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<EmployeeTest__c> scope) {
    	List<EmployeeTest__c> testsToUpdate = new List<EmployeeTest__c>();
        
        List<AggregateResult> result = [SELECT TestQuestion__r.Employee_test__c TestId, 
                                            MIN(TestQuestion__r.Employee_test__r.NumberAnswers__c) OldNumberAnswers, 
                                            COUNT(Id) NumberAnswers
                                        FROM TestQuestionAnswer__c
                                        WHERE TestQuestion__r.Employee_test__c IN :scope
                                            AND Active__c = TRUE 
                                        GROUP BY TestQuestion__r.Employee_test__c];
        
        for (AggregateResult aggrResult : result) {
            Id testId = (Id)aggrResult.get('TestId');
            Integer OldNumberAnswers = Integer.valueOf(aggrResult.get('OldNumberAnswers'));
            Integer numAnswers = (Integer)aggrResult.get('NumberAnswers');

            if (OldNumberAnswers != numAnswers) {             
                testsToUpdate.add(new EmployeeTest__c(Id = testId, NumberAnswers__c = numAnswers));
            }

            scope.remove(scope.indexOf(new EmployeeTest__c(Id = testId)));
        }

        for (EmployeeTest__c scope_i : scope) {
            scope_i.NumberAnswers__c = 0;
            testsToUpdate.add(scope_i);    
        }

        if (!testsToUpdate.isEmpty()) {          
            update testsToUpdate;
        }
    }
    
    public void finish(Database.BatchableContext bc) {
    	Messaging.SingleEmailMessage singleEmail = new Messaging.SingleEmailMessage();

        singleEmail.setToAddresses(new List<String> {Email});
        singleEmail.setSenderDisplayName('Batch Processing');
        singleEmail.setSubject('Batch Process for updating number answers of tests Completed');
        singleEmail.setPlainTextBody('Batch Process for updating number answers of tests has completed');
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { singleEmail });    
    } 
}