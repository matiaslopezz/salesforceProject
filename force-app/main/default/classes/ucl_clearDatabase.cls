public with sharing class ucl_clearDatabase {
    @AuraEnabled
    public static void clearDatabase(){
            Legal_Advisor__c[] advisors = [SELECT Id, Name FROM Legal_Advisor__c];

            delete advisors;
    }
}
