@isTest
public with sharing class ucl_TestClearDatabase {
    @isTest static void test1(){
        Legal_Advisor__c advisor = new Legal_Advisor__c(Name = 'Test Advisor');
        insert advisor;
        
        Test.startTest();
        ucl_clearDatabase.clearDatabase();
        List<Legal_Advisor__c> advisors = [SELECT Id, Name FROM Legal_Advisor__c];        
        Test.stopTest();
        
        System.assertEquals(0, advisors.size());
    }           
}
