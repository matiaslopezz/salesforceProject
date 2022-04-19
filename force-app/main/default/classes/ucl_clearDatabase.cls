public with sharing class ucl_clearDatabase {
    @AuraEnabled
    public static void clearDatabase(){
        try {
            Legal_Advisor__c[] advisors = 
            [SELECT Id, Name
            FROM Legal_Advisor__c];

            delete advisors;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
