/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-09-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public with sharing class TestInsertTasksScheduler {

    static testMethod void BatchTasksOnAccountsTest() {
        
        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('testBasicScheduledApex', InsertTasksBatchScheduler.CRON_EXP, 
                                       new InsertTasksBatchScheduler());

        InsertTasksBatchScheduler updateScheduler = new InsertTasksBatchScheduler();
        
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
                          NextFireTime FROM CronTrigger WHERE id = :jobId];
        
        System.assertEquals(InsertTasksBatchScheduler.CRON_EXP,  ct.CronExpression);
        
        Test.stopTest();
    }

   

}
