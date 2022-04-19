@isTest
public class ucl_TestServiceSchedule {
    @isTest static void test(){
        Test.startTest();
            
        // Schedule the test job        
        String jobId = ucl_serviceSchedule.doSchedule();
        
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                          FROM CronTrigger
                          WHERE id = :jobId];
        
        // Verify the expressions are the same
        System.assertEquals(ucl_serviceSchedule.CRON, ct.CronExpression);
        
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        
        // Verify the next time the job will run
        System.assertEquals('2022-04-19 21:00:00', String.valueOf(ct.NextFireTime));
        
        Test.stopTest();
    }
}