@RestResource(urlMapping='/EmployeeTests/*')
global with sharing class EmployeeTestManager {
    class EmployeeTestWrapper {
        String id;
        String name;
        Boolean active;
        String accessCode;
        DateTime startDate;
        Datetime endDate;
        Integer minimumPoints;
        Integer maximumPoints;

        public EmployeeTestWrapper(EmployeeTest__c test) {
            this.id = test.Id;
            this.name = test.Name;
            this.active = test.Active__c;
            this.accessCode = test.AccessCode__c;
            this.startDate = test.StartDate__c;
            this.endDate = test.EndDate__c;
            this.minimumPoints = Integer.valueOf(test.MinimumPoints__c);
            this.maximumPoints = Integer.valueOf(test.MaximumPoints__c);
        }

        public EmployeeTest__c getEmployeeTest() {
            EmployeeTest__c test = new EmployeeTest__c();

            test.Id = this.id;
            test.Name = this.name;
            test.Active__c = this.active;
            test.AccessCode__c = this.accessCode;
            test.StartDate__c = this.startDate;
            test.EndDate__c = this.endDate;
            test.MinimumPoints__c = this.minimumPoints;
            test.MaximumPoints__c = this.maximumPoints;

            return test;
        }
    }

    @HttpGet
    global static void getEmployeeTestById() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        
        String testId = request.requestURI.substring(request.requestURI.lastIndexOf('/') + 1);

        try {
            EmployeeTest__c test =  [SELECT Name, 
                                            AccessCode__c, 
                                            Active__c, 
                                            StartDate__c, 
                                            EndDate__c, 
                                            NumberAnswers__c,
                                            MinimumPoints__c, 
                                            MaximumPoints__c 
                                      FROM EmployeeTest__c
                                      WHERE Id = :testId];

            response.statusCode = 200;
            response.responseBody = Blob.valueOf(JSON.serialize(new EmployeeTestWrapper(test)));          
        } catch (Exception e) {
            response.statusCode = 412;
            response.responseBody = Blob.valueOf(e.getMessage());     
        }
    }

    @HttpDelete
    global static void deleteEmployeeTest() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;

        String testId = request.requestURI.substring(request.requestURI.lastIndexOf('/') + 1);

        try {
            EmployeeTest__c test =  [SELECT Id 
                                      FROM EmployeeTest__c
                                      WHERE Id = :testId];

            delete test;
            response.statusCode = 204;          
        } catch (Exception e) {
            response.statusCode = 412;
            response.responseBody = Blob.valueOf(e.getMessage());     
        }

    }
    
    @HttpPost
    global static void createEmployeeTest() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;

        EmployeeTestWrapper test = (EmployeeTestWrapper)JSON.deserialize(request.requestBody.toString(), EmployeeTestWrapper.class);
        test.id = null;

        EmployeeTest__c testToInsert = test.getEmployeeTest();

        try {
            insert testToInsert;

            response.statusCode = 201; 
            RestContext.response.responseBody = Blob.valueOf('{ "message" : "Added new test. Id: ' + testToInsert.Id 
                + ', Name: ' + test.Name + '"}');                    
        } catch (Exception e) {
            response.statusCode = 412;
            response.responseBody = Blob.valueOf(e.getMessage());     
        }
    }

    @HttpPut
    global static void upsertEmployeeTest() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;

        EmployeeTestWrapper test = (EmployeeTestWrapper)JSON.deserialize(request.requestBody.toString(), EmployeeTestWrapper.class);
        EmployeeTest__c testToUpdate = test.getEmployeeTest();

        try {
            upsert testToUpdate;

            response.statusCode = 200; 
            RestContext.response.responseBody = Blob.valueOf('{ "message" : "Update test. Id: ' + testToUpdate.Id 
                + ', Name: ' + test.Name + '"}');                    
        } catch (Exception e) {
            response.statusCode = 412;
            response.responseBody = Blob.valueOf(e.getMessage());     
        }
    }
}
