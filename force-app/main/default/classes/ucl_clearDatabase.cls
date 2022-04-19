public with sharing class ucl_clearDatabase {
    @AuraEnabled
    public static void clearDatabase(){
        try {
            Legal_Advisor__c[] advisors = 
            [SELECT Id, Name
            FROM Legal_Advisor__c];

            delete advisors;

        } catch (Exception e) {            
            Error_Logs__c errors = new Error_Logs__c(Name = e.getTypeName(), Error_Message__c = e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
}
