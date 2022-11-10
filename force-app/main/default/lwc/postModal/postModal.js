import { api } from 'lwc';
import LightningModal from 'lightning/modal';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createPost from '@salesforce/apex/PostSaveController.createPost';

export default class PostModal extends LightningModal {
    //@api content;
    externalId;
    userld;
    title;
    body;

    handleCancel() {
        this.close('cancel');
    }

    externalIdChange(event) {
        this.externalId = event.target.value;
    }

    userIdChange(event) {
        this.userld = event.target.value;
    }

    titleChange(event) {
        this.title = event.target.value;
    }

    bodyChange(event) {
        this.body = event.target.value;
    }

    createPostClick() {
        const post = {
            externalId: this.externalId,
            userId: this.userld,
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
                        message: '',
                        variant: 'error',
                    }),
                );
            });
    }
}