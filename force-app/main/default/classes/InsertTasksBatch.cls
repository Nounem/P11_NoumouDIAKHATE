/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-18-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global class InsertTasksBatch implements Database.Batchable<sObject> 
{
    global Database.QueryLocator start(Database.BatchableContext info) 
    {
        //Select Account with no Order and Account Checkbox field not checked
        String accounts =  'SELECT Id, OwnerId, (SELECT Id FROM Tasks WHERE Subject = \'Call\') FROM Account WHERE Active__c = false';
        return Database.getQueryLocator(accounts);  
    }

    global void execute(Database.BatchableContext info, List<Account> listAccounts) {
        HandlerManagerOrders.insertTasks(listAccounts);
    
    }

    global void finish(Database.BatchableContext info) {
        System.debug('information InsertTasksBatch : '+info);
    }
    
}
