import { LightningElement } from 'lwc';
import  executeService  from '@salesforce/apex/ucl_service.executeService';

export default class ServiceComponent extends LightningElement {

    handleClick(){
        executeService()
        .then(result => {

        })
        .catch(error => {

        })
    }
}