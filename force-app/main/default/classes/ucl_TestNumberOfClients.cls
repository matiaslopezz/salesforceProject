@isTest
public class ucl_TestNumberOfClients {
    @isTest static void test(){
        Map<String,List<Client__c>> advWithCli = TestDataFactory.createAdvisorsWithClients(1, 2);
        Test.startTest();
        Map<String,Integer> result = ucl_numberOfClients.numberOfClients(advWithCli);
        Test.stopTest();
        
        System.assertEquals(result.get('Test Advisor 1'), 2);
        
    }
}