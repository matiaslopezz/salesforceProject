@isTest
public class ucl_TestDataFactory {
    public static Map<String,List<Client__c>> createAdvisorsWithClients(Integer numAdv, Integer numCliPerAdv){
        Map<String,List<Client__c>> result = new Map<String,List<Client__c>>();
        List<Legal_Advisor__c> advisors = new List<Legal_Advisor__c>();
        
        for (Integer i=0; i<numAdv; i++){
            Legal_Advisor__c advisor = new Legal_Advisor__c(Name = 'Test Advisor' + i);
            advisors.add(advisor);
            
            List<Client__c> clients = new List<Client__c>();
            for (Integer k=0; k<numCliPerAdv; k++){
                clients.add(new Client__c(Name = advisor.Name + 'Client' + k));
            }            
            result.put(advisor.Name, clients);
        }
        insert advisors;        
        return result;
    }  
}