/**
 * @description       : Trigger on Order
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-11-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger TriggerOnOrders on order (before Insert, before Update, after Delete, after Insert) 
{
    //Checking the related products on the order while changing the status
    if(Trigger.isUpdate) 
    {
        HandlerManager.checkStatusChange(Trigger.new);
          
    }
    if(Trigger.isDelete){
        HandlerManager.checkActiveAccount(Trigger.old);
    }

}