import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import  executeService  from '@salesforce/apex/ucl_service.executeService';

export default class ServiceComponent extends LightningElement {

    handleClick(){
        executeService()
        .then(result => {
            const toastEvent = new ShowToastEvent({
                title: "Service successfully fired",
                message: "No errors",
                variant: "success"
            });
        })
        .catch(error => {
            const toastEvent = new ShowToastEvent({
                title: "Service did not run properly",
                message: "Errors",
                variant: "failure"
            });
        });
        this.dispatchEvent(toastEvent);
    }
}