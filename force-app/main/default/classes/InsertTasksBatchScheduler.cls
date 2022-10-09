/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-26-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
global without sharing class InsertTasksBatchScheduler implements Schedulable{
    
        //Scheduler to be run on the 1st Monday of every months
        //0 0 15 ? * * *  
        public static String CRON_EXP = '0 0 0 ? * 2#1';
        
        global void execute(SchedulableContext sc){ 
            //Action to be run with the batch with the related batch 
            InsertTasksBatch TasksBatch = new InsertTasksBatch();
            database.executeBatch(TasksBatch);
   
        }
}
