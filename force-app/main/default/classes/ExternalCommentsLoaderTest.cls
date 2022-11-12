@isTest
public with sharing class ExternalCommentsLoaderTest {
    private class PostWrapper {
        public Integer id;
        public Integer userId;
        public String title;
        public string body;
    }

    @TestSetup
    static void setup(){
        String postsJson = '[{"userId": 1, "id": 1, "title": "title 1", "body": "body 1"}, {"userId": 1, "id": 2, "title": "title 2","body": "body 2"}]';

        List<Post__c> postsToUpsert = new List<Post__c>();
        List<PostWrapper> posts = (List<PostWrapper>) JSON.deserialize(postsJson, List<PostWrapper>.class);

        for (PostWrapper post : posts) { 
            Post__c postToupsert = new Post__c(ExternalId__c = post.id, 
                                                UserId__c = post.userId,
                                                Title__c = post.title,
                                                Body__c = post.body);                
            postsToUpsert.add(postToupsert);
        }

        upsert postsToUpsert ExternalId__c;
    }

    @isTest
    public static void getCommentsTest() { 
        Test.setMock(HttpCalloutMock.class, new CommentsHttpCalloutMock());
        
        Test.startTest();       
        System.enqueueJob(new ExternalCommentsLoader());
        Test.stopTest();

        PostComment__c comment = [SELECT Id, ExternalId__c FROM PostComment__c ORDER BY ExternalId__c LIMIT 1];
        Integer expected = 1;
        Integer actual = Integer.valueOf(comment.ExternalId__c);

        System.assertEquals(expected, actual, 'External id must be equal to external id of first post`s comment');
    }   
}
