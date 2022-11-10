public with sharing class PostSaveController {
  
    @AuraEnabled
    public static Response createPost(String externalId, String userId, String title, String body) {
        Post__c post = new Post__c();
        post.ExternalId__c = Integer.valueOf(externalId);
        post.UserId__c = Integer.valueOf(userId);
        post.Title__c = title;
        post.Body__c = body;

        Response resp;
        try {
            insert post;
        } catch (Exception e) {
            resp = new Response(e);
        }
        return resp;
    }
}
