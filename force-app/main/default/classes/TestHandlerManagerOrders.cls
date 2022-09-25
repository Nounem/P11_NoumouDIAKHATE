/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-25-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class TestHandlerManagerOrders {
    
    @TestSetup
    static void setupData() {
        List<Account> acct = TestDataFactory.createAccounts(5);
        Product2 productOne = TestDataFactory.createProduct('TestItem', 'Prestation');
        PricebookEntry priceBook = TestDataFactory.createPricebookEntry(productOne.Id, 1020);
        List<Order> ord = TestDataFactory.createOrders(2, acct, priceBook);
        List<OrderItem> orderItems = TestDataFactory.createOrderItems(ord, priceBook);
        
    }

    @isTest
    static void testDeleteSeveralOrders(){
        Account  account = [SELECT Id, Active__c FROM Account WHERE Name LIKE 'TestAccount_1'];
        List <Order> orders = [SELECT AccountId FROM Order WHERE Account.Id = :account.Id ];
        //Delete all orders from the account
        Test.startTest();
        delete (orders);
        
        Account accVoid = [SELECT Id, Active__c  FROM Account WHERE Name = 'TestAccount_1'];
        Test.stopTest();
        
        
        System.assertEquals(False, accVoid.Active__c);
    }

    // creer deux class de test pour les triiger et le batch
}
