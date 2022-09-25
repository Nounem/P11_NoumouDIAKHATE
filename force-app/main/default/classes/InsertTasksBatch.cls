/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-25-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global class InsertTasksBatch implements Database.Batchable<sObject> 
{
    global Database.QueryLocator start(Database.BatchableContext info) 
    {
        Set<Id> taskIds = new Set<Id>();

        for ( Task tasks : [SELECT Id, WhatId FROM Task WHERE What.Type='Account' AND TaskSubtype = 'Call']){

            taskIds.add(tasks.WhatId);
        }

        Set<Id> orderIds = new Set<Id>();

        for(Order ord : [SELECT AccountId FROM Order ]){
            orderIds.add(ord.AccountId);
        }
    
        return Database.getQueryLocator('SELECT Id FROM Account WHERE (Id NOT IN:orderIds AND Id NOT IN:taskIds)');  
    }

    global void execute(Database.BatchableContext info, List<Account> listAccounts) {
        HandlerManagerTask.insertTasks(listAccounts);
    
    }

    global void finish(Database.BatchableContext info) {
        
        System.debug('information InsertTasksBatch : '+info);

    }
    
}
