public with sharing class ExternalPostUpdater implements Queueable, Database.AllowsCallouts {
    private class PostWrapper {
        public Integer userId;
        public String title;
        public string body;
    }

    public void execute(QueueableContext context) {
        PostWrapper newPost = new PostWrapper();
        newPost.body = 'bar';
        newPost.title = 'foo';
        newPost.userId = 1;
        
        Http http = new Http();

        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:JSONPlaceholder/posts');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(JSON.serialize(newPost));

        HttpResponse response = http.send(request);
        if (response.getStatusCode() != 201) {
            System.debug('The status code returned was not expected: ' +
                        response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
    }
}
