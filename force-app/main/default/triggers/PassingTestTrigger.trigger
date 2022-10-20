trigger PassingTestTrigger on PassingTest__c (before insert) {
    if (Trigger.isBefore) {
        if(Trigger.isInsert || Trigger.isUpdate) {
            PassingTestTriggerHandler.changeInvalidStartDate(Trigger.New);    
        }        
    }
}