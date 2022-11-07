@isTest
public with sharing class ExternalCommentsLoaderTest {
    @TestSetup
    static void setup(){
        String postsJson = '[{"userId": 1, "id": 1, "title": "title 1", "body": "body 1"}, {"userId": 1, "id": 2, "title": "title 2","body": "body 2"}]';
        TestDataFactory.createPostsFromJSON(postsJson);
    }

    @isTest
    public static void getCommentsTest() { 
        Test.setMock(HttpCalloutMock.class, new CommentsHttpCalloutMock());
        
        Test.startTest();       
        System.enqueueJob(new ExternalCommentsLoader());
        Test.stopTest();

        PostComment__c comment = [SELECT Id, ExternalId__c FROM PostComment__c LIMIT 1];
        Integer expected = 1;
        Integer actual = Integer.valueOf(comment.ExternalId__c);

        System.assertEquals(expected, actual, 'External id must be equals ' + expected);
    }   
}
