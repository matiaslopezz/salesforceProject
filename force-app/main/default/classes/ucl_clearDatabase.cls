public with sharing class ucl_clearDatabase {
    @AuraEnabled
    public static void clearDatabase(){
        try {
            Legal_Advisor__c[] advisors = 
            [SELECT Id, Name
            FROM Legal_Advisor__c];

            Client__c[] clients = 
            [SELECT Id, Name
            FROM Client__c];

            delete advisors;
            delete clients;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
