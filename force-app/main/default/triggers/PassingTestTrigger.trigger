trigger PassingTestTrigger on PassingTest__c (before insert) {
    if (Trigger.isBefore) {
        if(Trigger.isInsert) {
            PassingTestTriggerHandler.changeInvalidStartDate(Trigger.New);    
        }        
    }
}