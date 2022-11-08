import { LightningElement } from 'lwc';
import PostModal from 'c/postModal';

export default class PostComponent extends LightningElement {

    async createPostClick() {
        const result = await PostModal.open({
            size: 'medium'
        });
        // if modal closed with X button, promise returns result = 'undefined'
        // if modal closed with OK button, promise returns result = 'okay'
        console.log(result);
    }
}