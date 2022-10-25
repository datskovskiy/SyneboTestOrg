public class UpdateTestNumberAnswersScheduledBatch implements Database.Batchable<sObject>, Schedulable {
    String Email;
    String query = 'SELECT Id FROM EmployeeTest__c WHERE Active__c = TRUE';
    
    public UpdateTestNumberAnswersScheduledBatch(String mail) {
    	Email = mail;    
    }
    
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new UpdateTestNumberAnswersScheduledBatch(query));
    }
    
    public Database.QueryLocator start(Database.BatchableContext bc){
      return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<EmployeeTest__c> scope) {
    	List<EmployeeTest__c> testsToUpdate = new List<EmployeeTest__c>();
        
        Set<Id> testsIds = (new Map<Id, EmployeeTest__c>(scope)).keySet(); 
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

            testsIds.remove(testId);
        }

        for (Id testId : testsIds) {
            testsToUpdate.add(new EmployeeTest__c(Id = testId, NumberAnswers__c = 0));    
        }

        if (!testsToUpdate.isEmpty()) {          
            update testsToUpdate;
        }
    }
    
    public void finish(Database.BatchableContext bc) {
    	Messaging.SingleEmailMessage singleEmail = new Messaging.SingleEmailMessage();

        singleEmail.setToAddresses(new String[] {Email});
        singleEmail.setSenderDisplayName('Batch Processing');
        singleEmail.setSubject('Batch Process for updating number answers of tests Completed');
        singleEmail.setPlainTextBody('Batch Process for updating number answers of tests has completed');
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { singleEmail });    
    } 
}