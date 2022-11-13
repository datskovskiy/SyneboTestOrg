public with sharing class PostController {
    
    @AuraEnabled
    public static Response getPostComments(String postId){
        Response resp;
        try {
            List<PostComment__c> comments = [SELECT Id, Name__c, ExternalId__c, Email__c, Body__c
                                            FROM PostComment__c
                                            WHERE Post__c =: postId];
            resp = new Response(comments);  
        } catch (Exception e) {
            resp = new Response(e);
        }

        return resp;
    }
}
