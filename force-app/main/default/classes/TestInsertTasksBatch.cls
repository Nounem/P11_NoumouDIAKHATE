/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-09-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class TestInsertTasksBatch {

    @TestSetup
    static void setup(){
        
        List<Account> acct = TestDataFactory.createAccounts(150);
        Task task = TestDataFactory.createTaskForAccount(acct[0]);

        Product2 productOne = TestDataFactory.createProduct('TestItem', 'Prestation');
        PricebookEntry priceBook = TestDataFactory.createPricebookEntry(productOne.Id, 1020);

        Order singleOrder = TestDataFactory.createSingleOrder(acct[0],priceBook);
     
    }

    @isTest
    static void TestCheckAccountRelatedList(){
        List<Task> task = new List <Task>();

       
        
        Test.startTest();
        InsertTasksBatchScheduler scheduleBatch = new InsertTasksBatchScheduler();

        Id batchId = System.schedule(
                                    'TaskJob',
                                    InsertTasksBatchScheduler.CRON_EXP,
                                    scheduleBatch
                                );
        scheduleBatch.execute(null);
        Test.stopTest();


        Set<Id> taskIds = new Set<Id>();

        for ( Task tasks : [SELECT Id, WhatId FROM Task])
            {

            taskIds.add(tasks.WhatId);
        }

        Set<Id> orderIds = new Set<Id>();

        for(Order ord : [SELECT AccountId FROM Order ]){
            orderIds.add(ord.AccountId);
        }

        List<Account> accResult = [SELECT Id 
                                   FROM Account 
                                   WHERE (Id NOT IN:orderIds AND Id NOT IN:taskIds)];
        

        // List<Account> accResult = [SELECT Id 
                                //   FROM Account WHERE (Id NOT IN:orderIds AND Id NOT IN:taskIds)];
        
        
        
         //Vérifier que le nombre de tâches créées via le batch est le même
         // que le nombre de comptes sans tâches    
        System.assertEquals(0, accResult.size());  

    }

   
}
