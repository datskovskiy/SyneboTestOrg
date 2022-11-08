import { api } from 'lwc';
import LightningModal from 'lightning/modal';

export default class PostModal extends LightningModal {
    @api content;

    handleCancel() {
        this.close('cancel');
    }
}