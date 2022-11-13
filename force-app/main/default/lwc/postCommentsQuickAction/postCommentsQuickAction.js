import { LightningElement, api, track } from 'lwc';
import getPostComments from '@salesforce/apex/PostController.getPostComments';

const columns = [
    { label: 'Name', fieldName: 'Name__c' },
    { label: 'External Id', fieldName: 'ExternalId__c'},
    { label: 'Email', fieldName: 'Email__c', type: 'email'},
    { label: 'Body', fieldName: 'Body__c'}
];

export default class PostCommentsQuickAction extends LightningElement {
    @api recordId;

    @track completedLoading;

    postComments;
    error;

    columns = columns;

    renderedCallback() {
        if (!this.completedLoading && this.recordId) {
            let params = { 
                postId: this.recordId 
            };
            getPostComments(params)
                .then((result) => {
                    if (result.isSuccess) {
                        this.postComments = result.responseObj;
                        this.error = undefined; 
                        this.completedLoading = true;   
                    } else {
                        this.postComments = undefined;
                        this.error = result.responseObj;        
                    }
                })
                .catch((error) => {
                    this.postComments = undefined;
                    this.error = error;
                });          
        }
    };
}