public with sharing class Response {

    @AuraEnabled
    public Object responseObj { get; set; }
    @AuraEnabled
    public Boolean isSuccess { get; set; }

    public Response() {
        this.isSuccess = true;
    }

    public Response(Boolean status, String message) {
        this.isSuccess = status;
        this.responseObj = message;
    }

    public Response(Object pResponseObject) {
        this.isSuccess = true;
        this.responseObj = pResponseObject;
    }

    public Response(Exception e) {
        String respMessage = e.getMessage();
        if (e instanceof DmlException) {
            DmlException dmlExp = (DmlException)e;
            respMessage = dmlExp.getDmlMessage(0);
        }
        this.isSuccess = false;
        this.responseObj = respMessage;
    }
}
