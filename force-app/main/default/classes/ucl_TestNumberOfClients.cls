@isTest
public class ucl_TestNumberOfClients {
    @isTest static void test(){
        Map<String,List<Client__c>> advWithCli = ucl_TestDataFactory.createAdvisorsWithClients(1, 2);
        Test.startTest();
        ucl_numberOfClients ucl = new ucl_numberOfClients();
        Map<String,Integer> result = ucl.numberOfClients(advWithCli);
        Test.stopTest();
        
        System.assertEquals(result.get('Test Advisor 1'), 2);        
    }
}