import LightningModal from 'lightning/modal';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createPost from '@salesforce/apex/PostSaveController.createPost';

export default class PostModal extends LightningModal {
    externalId;
    userId;
    title;
    body;

    handleCancel() {
        this.close('cancel');
    }

    postHandleChange(event) {
        if (event.target.name == 'externalId') {
            this.externalId = event.target.value;    
        } else if (event.target.name == 'userId') {
            this.userId = event.target.value;    
        } else if (event.target.name == 'title') {
            this.title = event.target.value;    
        } else if (event.target.name == 'body') {
            this.body = event.target.value;    
        }      
    }

    createPostClick() {
        const post = {
            externalId: this.externalId,
            userId: this.userId,
            title: this.title,
            body: this.body
        };

        createPost(post)
            .then(() => {
                console.log('no errors');
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Post created',
                        variant: 'success',
                    }),
                );
            })
            .catch(error => {
                console.log(error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.message,
                        variant: 'error',
                    }),
                );
            });
    }
}