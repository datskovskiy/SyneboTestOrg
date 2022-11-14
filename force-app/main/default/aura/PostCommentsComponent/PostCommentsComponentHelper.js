({
	fetchPostCommentsHelper : function(component, event, helper) {
        component.set('v.postCommentsColumns', [
            { label: 'Name', fieldName: 'Name__c' },
            { label: 'External Id', fieldName: 'ExternalId__c'},
            { label: 'Email', fieldName: 'Email__c', type: 'email'},
            { label: 'Body', fieldName: 'Body__c'}
        ]);
        
        var action = component.get('c.getPostComments');
        action.setParams({
            postId: component.get('v.recordId')
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if (result.isSuccess) {
                    component.set("v.postComments", result.responseObj);
                    component.set("v.error", undefined);  
                } else {
                    component.set("v.postComments", undefined);
                    component.set("v.error", result.responseObj);       
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})