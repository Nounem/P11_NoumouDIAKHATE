/**
* Class checking the status of orders and accounts before updates 
* HandlerManagerOrders
*/
public with sharing class HandlerManager 
{
    /**
     * Check that there are products on the order
     */    
    public static void checkStatusChange(List<Order> orders)
    {
        List<Order> items =[ SELECT Id 
                             FROM Order
                             WHERE Id IN (SELECT orderId FROM OrderItem WHERE orderId IN :orders)
                            ];

        for(Order ord : orders)
        {
           
            if(ord.Status =='Activated' && items.isEmpty())
            {
                ord.addError('Merci d ajouter un produit avant d activer ');
            }
        }

    }

    /**
     *  Remove the tick from the active box when orders are deleted   
    */  
    public static void unCheckActiveAccount(List <Order> orders) 
    {
        List<Account> accountsToUpdate = new List<Account>();
        Set<Id> accIds = new Set<Id>();
        Set<Id> ordersOldAccountIds = new Set<Id>();

        for(Order ord :orders)
        {
            ordersOldAccountIds.add(ord.AccountId);
        }

        List<Order> nbOrders = [ SELECT Id 
                               FROM Order 
                               WHERE AccountId = :ordersOldAccountIds
                            ];
        

        if(nbOrders.size() == 0)
        {
            accIds.addAll(ordersOldAccountIds);
        }
        else
        {
            for(Order ord : orders){

                accIds.add(ord.AccountId);
            }
        }

        for(Account acc : [SELECT Id, Active__c FROM Account Where Id IN : accIds]){
            acc.Active__c = false;
            accountsToUpdate.add(acc);

        }
        if(accountsToUpdate.size() > 0){
            update accountsToUpdate;
        }
    }
}