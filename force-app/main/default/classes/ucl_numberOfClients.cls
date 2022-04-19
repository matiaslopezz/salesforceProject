public with sharing class ucl_numberOfClients {
    public Map<String, Integer> numberOfClients(Map<String,List<Object>> clients){
        try {
            Map<String, Integer> mapOfNumbers = new Map<String,Integer>();
            for (String key : clients.keySet()){
                mapOfNumbers.put(key, clients.get(key).size());
            }    
            return mapOfNumbers;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
            Error_Logs__c errors = new Error_Logs__c(Name = e.toString(), Error_Message = e.getMessage());
        }
    }
}
