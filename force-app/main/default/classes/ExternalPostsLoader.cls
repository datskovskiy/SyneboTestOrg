public with sharing class ExternalPostsLoader implements Queueable, Database.AllowsCallouts {
    private class PostDTO {
        public Integer Id;
        public Integer UserId;
        public String Title;
        public string Body;
    }

    public void execute(QueueableContext context) {
        List<Post__c> postsToUpsert = new List<Post__c>();
        List<PostDTO> posts = new List<PostDTO>();

        Http http = new Http();

        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://jsonplaceholder.typicode.com/posts');
        request.setMethod('GET');
        
        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            posts = (List<PostDTO>) JSON.deserialize(response.getBody(), List<PostDTO>.class);
            for (PostDTO post : posts) { 
                Post__c postToupsert = new Post__c(ExternalId__c = post.Id, 
                                                    UserId__c = post.UserId,
                                                    Title__c = post.Title,
                                                    Body__c = post.Body);                
                postsToUpsert.add(postToupsert);
            }
        }

        if (!postsToUpsert.isEmpty()) {
            upsert postsToUpsert ExternalId__c;
        }

        System.enqueueJob(new ExternalCommentsLoader()); 
    }
}
