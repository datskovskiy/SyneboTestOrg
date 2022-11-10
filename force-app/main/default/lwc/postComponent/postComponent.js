import { LightningElement } from 'lwc';
import PostModal from 'c/postModal';

export default class PostComponent extends LightningElement {

    async createPostClick() {
        const result = await PostModal.open({
            label: 'Post',
            size: 'small',
            description: 'Post record',
            onshowtoast: (e) => {
                e.stopPropagation();
                //this.handleSelectEvent(e.detail);
                // or proxy to be handled above by dispatching
                // another custom event to pass on the event
                // this.dispatchEvent(e);
              }
        });
    }
}