public with sharing class ExternalCommentsLoader implements Queueable, Database.AllowsCallouts {
    private class CommentWrapper {
        public Integer id;
        public Integer postId;
        public String name;
        public String email;
        public string body;
    }

    public void execute(QueueableContext context) {
        List<PostComment__c> postCommentsToUpsert = new List<PostComment__c>();
        List<CommentWrapper> comments = new List<CommentWrapper>();

        Http http = new Http();

        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:JSONPlaceholder/comments');
        request.setMethod('GET');
        
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            comments = (List<CommentWrapper>) JSON.deserialize(response.getBody(), List<CommentWrapper>.class);
            
            for (CommentWrapper comment : comments) { 
                Post__c post = new Post__c(ExternalId__c = comment.postId);
                PostComment__c commentToupsert = new PostComment__c(ExternalId__c = comment.id,
                                                                    Post__r = post,
                                                                    Name__c = comment.name,
                                                                    Email__c = comment.email,
                                                                    Body__c = comment.body);                
                                                            
                postCommentsToUpsert.add(commentToupsert);
            }
        }

        if (!postCommentsToUpsert.isEmpty()) {
            upsert postCommentsToUpsert ExternalId__c;
        }

        System.enqueueJob(new ExternalPostUpdater());
    }
}
