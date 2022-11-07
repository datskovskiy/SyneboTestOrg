@isTest
global with sharing class PostsHttpCalloutMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('[{"userId": 1, "id": 1, "title": "title 1", "body": "body 1"}, {"userId": 1, "id": 2, "title": "title 2","body": "body 2"}]');
        response.setStatusCode(200);
        
        return response;
    }
}
