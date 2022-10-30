public with sharing class ExternalPostsLoader implements Queueable, Database.AllowsCallouts {
    private class PostWrapper {
        public Integer id;
        public Integer userId;
        public String title;
        public string body;
    }

    public void execute(QueueableContext context) {
        List<Post__c> postsToUpsert = new List<Post__c>();
        List<PostWrapper> posts = new List<PostWrapper>();

        Http http = new Http();

        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:JSONPlaceholder/posts');
        request.setMethod('GET');
        
        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            posts = (List<PostWrapper>) JSON.deserialize(response.getBody(), List<PostWrapper>.class);
            for (PostWrapper post : posts) { 
                Post__c postToupsert = new Post__c(ExternalId__c = post.id, 
                                                    UserId__c = post.userId,
                                                    Title__c = post.title,
                                                    Body__c = post.body);                
                postsToUpsert.add(postToupsert);
            }
        }

        if (!postsToUpsert.isEmpty()) {
            upsert postsToUpsert ExternalId__c;
        }

        System.enqueueJob(new ExternalCommentsLoader()); 
    }
}
