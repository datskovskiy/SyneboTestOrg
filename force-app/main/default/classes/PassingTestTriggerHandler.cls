public class PassingTestTriggerHandler {
    public static void beforeIsert(List<PassingTest__c> newRecords) {
        for(PassingTest__c test : newRecords) {
        	if(test.EndDate__c <=  test.StartDate__c) {
            	test.StartDate__c = test.EndDate__c - 60;
            }    
        }      
    }  
}