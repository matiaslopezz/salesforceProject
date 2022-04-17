import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import  executeService  from '@salesforce/apex/ucl_service.executeService';

export default class ServiceComponent extends LightningElement {
         
    handleClick(){
        executeService()
            .then(() => {
                this.ShowToastEvent("Success!", "Success", "No error!");
            })
            .catch(error =>{
                this.ShowToastEvent("Error!", "Error", "There is an error somewhere");
                this.error = error
            })
        }
}