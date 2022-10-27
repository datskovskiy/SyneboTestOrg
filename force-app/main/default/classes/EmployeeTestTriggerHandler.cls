public with sharing class EmployeeTestTriggerHandler {
    public static void updateExternalPostsWithComments(List<EmployeeTest__c> tests, Map<Id, EmployeeTest__c> oldTests) {
        Boolean updateExternalPosts = false;
        
        for (EmployeeTest__c test : tests) {
            if (test.Active__c && test.Active__c != oldTests.get(test.Id).Active__c) {
                updateExternalPosts = true;
                break;        
            }
        }
        
        if (updateExternalPosts) {           
            System.enqueueJob(new ExternalPostsLoader());    
        }
    }
}
