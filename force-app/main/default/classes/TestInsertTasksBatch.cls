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
        
        List<Account> accounts = TestDataFactory.createAccounts(150);
        Task task = TestDataFactory.createReminderTaskForAccount(accounts[0]);
     
    }

    @isTest
    static void TestCheckAccountRelatedList(){
        List<Task> task = new List <Task>();
        
        Test.startTest();
        InsertTasksBatch batchOnTask = new InsertTasksBatch();
        Id batchId = Database.executeBatch(batchOnTask);
        Test.stopTest();
        
        task = [SELECT Id,WhatId 
                FROM Task 
                WHERE Subject='Call' AND OwnerId IN (SELECT Id FROM User WHERE isActive=true)
                ];
        
         //Vérifier que le nombre de tâches créées via le batch est le même
         // que le nombre de comptes sans tâches    
        System.assertEquals(151, task.size());   

    }

   
}
