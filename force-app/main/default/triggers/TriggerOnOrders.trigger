/**
 * @description       : Trigger on Order
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-25-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger TriggerOnOrders on order (before Insert, before Update, after Delete, after Insert) 
{
    //Checking the related products on the order while changing the status
    if(Trigger.isUpdate) 
    {
        HandlerManagerOrders.checkStatusChange(Trigger.new);
        System.debug('ORDER Trigger.new :' +Trigger.new);
          
    }
    if(Trigger.isDelete ){
        HandlerManagerOrders.checkActiveAccount(Trigger.old);
        System.debug('ORDER Trigger.old :' +Trigger.old);
    }
    

}