public with sharing class ucl_service {
    @AuraEnabled
    public static void executeService(){
        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://altimetrik-bootcamp.herokuapp.com/LegalAccounts');
            request.setMethod('GET');
            HttpResponse response = http.send(request);

            List<Legal_Advisor__c> advisors = new List<Legal_Advisor__c>();
            Map<String,List<Object>> clients = new Map<String,List<Object>>();

            List<Client__c> clientsToSalesforce = new List<Client__c>();
            List<Legal_Advisor__c> advisorsToSalesforce = new List<Legal_Advisor__c>();

            List<Legal_Advisor__c> advisorsToUpdate = new List<Legal_Advisor__c>();

            List<Client__c> clientsToDelete = new List<Client__c>();

            Legal_Advisor__c[] existingAdvisors = [SELECT Id, Name, Account_Number__c, Account_Status__c FROM Legal_Advisor__c];
            Client__c[] existingClients = [SELECT Id, Name, Client_Number__c, Legal_Advisor__c FROM Client__c];

            if(response.getStatusCode() == 200) {
                List<Object> accounts = (List<Object>)JSON.deserializeUntyped(response.getBody());
                for (Object account : accounts){
                    //Assign a map for each legal advisor account
                    Map<String,Object> accountMap = (Map<String,Object>) account;

                    //Legal advisor record construction
                    Legal_Advisor__c newAdvisor = new Legal_Advisor__c(
                        Name = (String) accountMap.get('AccountName'),
                        Account_Name__c = (String) accountMap.get('AccountName'),
                        Account_Number__c = (String) accountMap.get('AccountNumber'),
                        Account_Status__c = (String) accountMap.get('AccountStatus'),
                        As_of_Date__c = (Date) date.parse(accountMap.get('AsOfDate').toString())
                    );                    
                    advisors.add(newAdvisor);
                    
                    List<Object> accountClients = (List<Object>) accountMap.get('Clients');
                    //Add the list of clients from an specific advisor to a map
                    clients.put(newAdvisor.Account_Name__c, accountClients);       
                }         
                
                //Create an instance of the numberOfClient class
                ucl_numberOfClients numberOfClientsClass = new ucl_numberOfClients();

                //Build a map to access the number of clients per advisor
                Map<String,Integer> mapOfClients = numberOfClientsClass.numberOfClients(clients);
                
                for (Legal_Advisor__c advisor : advisors){
                    if (mapOfClients.keySet().contains(advisor.Account_Name__c)){
                        advisor.Number_of_Clients__c = mapOfClients.get(advisor.Account_Name__c);
                    }
                }    

                //We are interested only in those records with an enabled status field
                for (Legal_Advisor__c advisor : advisors){
                    if (advisor.Account_Status__c == 'Enabled'){
                        advisorsToSalesforce.add(advisor);
                    }
                }

                //Add those advisors with disabled status field that already are in the org
                for (Legal_Advisor__c advisor : advisors){
                    for (Legal_Advisor__c existingAdvisor : existingAdvisors){
                        if ((existingAdvisor.Account_Number__c == advisor.Account_Number__c) && 
                            (advisor.Account_Status__c == 'Disabled') && 
                            (existingAdvisor.Account_Status__c == 'Enabled')){
                            advisorsToSalesforce.add(advisor);
                        }
                    }
                }

                //Avoid duplicates                                                           
                if (existingAdvisors.size() > 0){
                    for (Legal_Advisor__c existingAdvisor : existingAdvisors){
                        for (Legal_Advisor__c advisor : advisorsToSalesforce){
                            if (existingAdvisor.Account_Number__c == advisor.Account_Number__c){
                                advisor.Id = existingAdvisor.Id;
                            }
                        }
                    }
                }

                upsert advisorsToSalesforce;

                // CLIENT SECTION   
                
                for (Legal_Advisor__c advisor : advisorsToSalesforce){
                    for (Object client : clients.get(advisor.Account_Name__c)){  
                        Map<String,Object> clientMap = (Map<String,Object>) client;
                        Client__c newClient = new Client__c(
                            Name = (String) clientMap.get('FirstName')+' '+clientMap.get('LastName'),
                            First_Name__c = (String) clientMap.get('FirstName'),
                            Last_Name__c = (String) clientMap.get('LastName'),
                            Email__c = (String) clientMap.get('Email'),
                            Phone__c = (String) clientMap.get('Phone'),
                            Address__c = (String) clientMap.get('Address'),
                            Client_Number__c = (String) clientMap.get('ClientNumber')
                        );
                        //Assign a field to relate the client with its advisor 
                        newClient.Legal_Advisor__c = advisor.id;
                        
                        //Add each client to the list to be inserted/updated into the salesforce org
                        clientsToSalesforce.add(newClient);
                    }
                } 
                    
                //Avoid duplicates
                if (existingClients.size() > 0){
                    for (Client__c existingClient : existingClients){            
                        Integer aux = 0;
                        for (Client__c client : clientsToSalesforce) {
                            if ((client.Legal_Advisor__c == existingClient.Legal_Advisor__c) &&
                                (client.Client_Number__c == existingClient.Client_Number__c)){
                                    client.Id = existingClient.Id; 
                                    aux++;
                                }
                        }
                        //We delete those records from the org if they are no longer coming from the JSON file
                        if (aux == 0){
                            clientsToDelete.add(existingClient);
                        }
                    }
                }
                
                delete clientsToDelete;                  
                upsert clientsToSalesforce;         
            }          
        }
        catch (Exception e) {
            //throw new AuraHandledException(e.getMessage());
            Error_Logs__c errors = new Error_Logs__c(Name = e.getTypeName(), Error_Message__c = e.getMessage());
        }
    }
}