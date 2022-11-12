@isTest
public with sharing class ExternalPostsLoaderTest {
    @isTest
    public static void getPostsTest() { 
        Test.setMock(HttpCalloutMock.class, new PostsHttpCalloutMock());
        
        Test.startTest();        
        System.enqueueJob(new ExternalPostsLoader());
        Test.stopTest();

        Post__c post = [SELECT Id, ExternalId__c FROM Post__c ORDER BY ExternalId__c LIMIT 1];
        Integer expected = 1;
        Integer actual = Integer.valueOf(post.ExternalId__c);

        System.assertEquals(expected, actual, 'External id must be equal to external id of first post');
    }   
}
