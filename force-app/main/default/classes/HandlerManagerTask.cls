/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-25-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class HandlerManagerTask {
     /**
     * List Account with no orders and no tasks and create task reminder
     */
    public static void insertTasks(List<Account> listAccounts)
    {           
            List<Task> tasksToCreate = new List<Task>();
            for (Account account : listAccounts) {
                tasksToCreate.add(
                    new Task(WhatId = account.Id, 
                             Subject = 'Call', 
                             Status = 'New', 
                             Priority = 'Normal',
                             TaskSubtype = 'Call',
                             IsReminderSet = true, 
                             ReminderDateTime = Date.today().addDays(5)));
            }
            if (tasksToCreate.size() > 0){
                insert tasksToCreate;
            } 
    }
}
