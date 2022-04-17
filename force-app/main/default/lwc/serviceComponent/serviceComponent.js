import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ServiceComponent extends LightningElement {
    handleClick(){
        const toastEvent = new ShowToastEvent({
            title: "Service invoked",
            message: " ",
            variant: "success"
        });
        this.dispatchEvent(toastEvent);
    }
}