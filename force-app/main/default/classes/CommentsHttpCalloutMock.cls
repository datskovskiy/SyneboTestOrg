@isTest
global with sharing class CommentsHttpCalloutMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('[{"postId": 1, "id": 1, "name": "name 1", "email": "e1@g.com", "body": "body 1"}, {"postId": 1, "id": 2, "name": "name 2", "email": "e1@g.com", "body": "body 2"}]');
        response.setStatusCode(200);
        
        return response;
    }
}
