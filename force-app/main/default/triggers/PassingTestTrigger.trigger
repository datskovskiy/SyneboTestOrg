trigger PassingTestTrigger on PassingTest__c (before insert) {
    if(Trigger.isInsert) {
    	PassingTestTriggerHandler.beforeIsert(Trigger.New);    
    }
}