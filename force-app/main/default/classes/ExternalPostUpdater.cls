public with sharing class ExternalPostUpdater implements Queueable, Database.AllowsCallouts {
    private class PostDTO {
        public Integer UserId;
        public String Title;
        public string Body;
    }

    public void execute(QueueableContext context) {
        PostDTO newPost = new PostDTO();
        newPost.Body = 'bar';
        newPost.Title = 'foo';
        newPost.userId = 1;
        
        Http http = new Http();

        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://jsonplaceholder.typicode.com/posts');
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
