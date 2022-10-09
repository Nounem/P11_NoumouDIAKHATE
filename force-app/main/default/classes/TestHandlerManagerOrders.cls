/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-02-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class TestHandlerManagerOrders {
    
    @TestSetup
    static void setupData() {
        List<Account> acct = TestDataFactory.createAccounts(5);
        Product2 productOne = TestDataFactory.createProduct('TestItem', 'Prestation');
        PricebookEntry priceBook = TestDataFactory.createPricebookEntry(productOne.Id, 1020);
        List<Order> ord = TestDataFactory.createOrders(5, acct, priceBook);
        Order singleOrder = TestDataFactory.createSingleOrder(acct[0],priceBook);
        List<OrderItem> orderItems = TestDataFactory.createOrderItems(ord, priceBook);

        
    }

    @isTest
    static void inactiveAccWhereOrderDeleted(){
        Account  account = [SELECT Id, Active__c FROM Account WHERE Name LIKE 'TestAccount_0'];
        List <Order> orders = [SELECT AccountId FROM Order WHERE Account.Id = :account.Id ];
        //Delete all orders from the account
        Test.startTest();
        delete orders;
        
        Account result = [SELECT Id, Active__c, (SELECT Id FROM Orders)  FROM Account WHERE Name = 'TestAccount_0'];
        Test.stopTest();
        
        System.assertEquals(0, result.Orders.size());
        System.assertEquals(False, result.Active__c);
    }

   
// testvalidestatus order.status = status
    @IsTest
    static void testErrorOnStatus() {

        Order order =[SELECT Id, Status FROM Order WHERE Id NOT IN (SELECT OrderId FROM OrderItem ) LIMIT 1  ];
        System.debug('liste order'+order);
        Test.startTest();
        try {
            order.Status = 'Activated';
            update order;
            
        } catch (Exception e) {
            Boolean expectedExceptionThrown = e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION') ? true : false;
            Boolean expectedMessage = e.getMessage().contains('Merci d ajouter un produit avant d activer') ? true : false;
            
            System.assertEquals(expectedExceptionThrown, true);
            System.assertEquals(expectedMessage, true);
        }
        
        Test.stopTest();

    }

    @IsTest
    static void testValideStatus() {

        Order order =[SELECT Id, Status, AccountId FROM Order WHERE Id IN (SELECT OrderId FROM OrderItem ) LIMIT 1  ];
        Test.startTest();

        order.Status = 'Activated';
        update order;
        Test.stopTest();

        System.assertEquals('Activated', order.Status);

    }

    
}
