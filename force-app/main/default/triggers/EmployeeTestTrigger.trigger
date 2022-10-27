trigger EmployeeTestTrigger on EmployeeTest__c (after update) {
    if (Trigger.isAfter) {
        if (Trigger.isUpdate) {
            EmployeeTestTriggerHandler.updateExternalPostsWithComments(Trigger.new, Trigger.oldMap);
        }    
    }
}