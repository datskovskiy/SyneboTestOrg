public with sharing class ExternalCommentsLoader implements Queueable, Database.AllowsCallouts {
    private class CommentDTO {
        public Integer Id;
        public Integer PostId;
        public String Name;
        public String Email;
        public string Body;
    }

    public void execute(QueueableContext context) {
        List<PostComment__c> postCommentsToUpsert = new List<PostComment__c>();
        List<CommentDTO> comments = new List<CommentDTO>();

        Http http = new Http();

        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://jsonplaceholder.typicode.com/comments');
        request.setMethod('GET');
        
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            comments = (List<CommentDTO>) JSON.deserialize(response.getBody(), List<CommentDTO>.class);
            
            for (CommentDTO comment : comments) { 
                Post__c post = new Post__c(ExternalId__c = comment.PostId);
                PostComment__c commentToupsert = new PostComment__c(ExternalId__c = comment.Id,
                                                                    Post__r = post,
                                                                    Name__c = comment.Name,
                                                                    Email__c = comment.Email,
                                                                    Body__c = comment.Body);                
                                                            
                postCommentsToUpsert.add(commentToupsert);
            }
        }

        if (!postCommentsToUpsert.isEmpty()) {
            upsert postCommentsToUpsert ExternalId__c;
        }

        System.enqueueJob(new ExternalPostUpdater());
    }
}
