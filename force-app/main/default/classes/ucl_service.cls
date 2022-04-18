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

            if(response.getStatusCode() == 200) {
                List<Object> accounts = (List<Object>)JSON.deserializeUntyped(response.getBody());
                for (Object account : accounts){
                    //Assign a map for each legal advisor account
                    Map<String,Object> accountMap = (Map<String,Object>) account;

                    //Legal advisor record construciton
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

                //Avoid duplicates
                Legal_Advisor__c[] checkingAdvisors = 
                [SELECT Name,Account_Name__c,Account_Number__c,Account_Status__c,As_of_Date__c                                                        
                FROM Legal_Advisor__c];
                                                              
                if (checkingAdvisors.size() > 0){
                    for (Legal_Advisor__c checkingAdvisor : checkingAdvisors){
                        for (Legal_Advisor__c advisor : advisorsToSalesforce){
                            if (checkingAdvisor.Account_Number__c == advisor.Account_Number__c){
                                advisor.Id = checkingAdvisor.Id;
                            }
                        }
                    }
                }

                upsert advisorsToSalesforce; 
                
                //Upload those records with an enabled status in the org but disabled from the json file
                if (checkingAdvisors.size() > 0){
                    for (Legal_Advisor__c checkingAdvisor : checkingAdvisors){
                        for (Legal_Advisor__c advisor : advisors){
                            if ((advisor.id == checkingAdvisor.id) && 
                                (advisor.Account_Status__c == 'Disabled') && 
                                (checkingAdvisor.Account_Status__c == 'Enabled')){
                                    checkingAdvisor.Account_Status__c = 'Disabled';
                                    advisorsToUpdate.add(checkingAdvisor);                
                                }
                        }
                    }       
                }               
                
                update advisorsToUpdate;

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
                Client__c[] checkingClients = [SELECT Name,First_Name__c,Last_Name__c,Email__c,Phone__c,Address__c,Client_Number__c,
                                            Legal_Advisor__c FROM Client__c];
                if (checkingClients.size() > 0){
                    for (Client__c checkingClient : checkingClients){
                        for (Client__c client : clientsToSalesforce) {
                            if (checkingClient.Client_Number__c == client.Client_Number__c){
                                client.Id = checkingClient.Id;                    
                            }
                        }
                    }
                }
                
                upsert clientsToSalesforce;
                
                //We delete those records from the org if they are no longer coming from the JSON file
                if (checkingClients.size() > 0){
                    for (Client__c client : checkingClients){
                        if (!clientsToSalesforce.contains(client)){
                            clientsToDelete.add(client);
                        }
                    }
                }
                
                delete clientsToDelete;           
            }          
        }
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}