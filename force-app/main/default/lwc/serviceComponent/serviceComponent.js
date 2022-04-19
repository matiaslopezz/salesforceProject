import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import  executeService  from '@salesforce/apex/ucl_service.executeService';
import clearDatabase from '@salesforce/apex/ucl_clearDatabase.clearDatabase';

export default class ServiceComponent extends LightningElement {
    handleClick(){
        executeService()
        .then(result => {
            const toastEvent = new ShowToastEvent({
                title: "Service successfully fired",
                message: "No errors",
                variant: "success"
            });
            this.dispatchEvent(toastEvent);
        })
        .catch(error => {
            const toastEvent = new ShowToastEvent({
                title: "Service did not run properly",
                message: "Errors",
                variant: "failure"
            });
            this.dispatchEvent(toastEvent);
        });        
    }

    clearClick(){
        clearDatabase()
        .then(result => {
            const toastEvent = new ShowToastEvent({
                title: "Database successfully cleared",
                message: "No errors",
                variant: "success"
            });
            this.dispatchEvent(toastEvent);
        })
        .catch(error => {
            const toastEvent = new ShowToastEvent({
                title: "Database still alive",
                message: "Errors",
                variant: "failure"
            });
            this.dispatchEvent(toastEvent);
        });
    }
}