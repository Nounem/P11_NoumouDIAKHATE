/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-18-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class TestHandlerManagerOrders {
    
    @TestSetup
    static void setupData() {
        List<Account> acct = TestDataFactory.createAccounts(5);
        List<Account> acctActive = TestDataFactory.createAccountsActive(3);

        Product2 productOne = TestDataFactory.createProduct('TestItem', 'Prestation');
        PricebookEntry priceBook = TestDataFactory.createPricebookEntry(productOne.Id, 1020);
        List<Order> ord = TestDataFactory.createOrders(5, acct, priceBook);
        List<Order> ord2 = TestDataFactory.createOrders(2, acctActive, priceBook);
        Order singleOrder = TestDataFactory.createSingleOrder(acct[0],priceBook);
        List<OrderItem> orderItems = TestDataFactory.createOrderItems(ord, priceBook);
        List<OrderItem> orderItems2 = TestDataFactory.createOrderItems(ord2, priceBook);

        // si le accountId associer à une commande 
    }

  
    @IsTest
    static void testErrorOnStatus() {

        Order order =[SELECT Id, Status FROM Order WHERE Id NOT IN (SELECT OrderId FROM OrderItem ) LIMIT 1  ];
        System.debug('liste orderTest '+order);
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

       List< Order> orders =[SELECT Id, Status, AccountId FROM Order 
                      WHERE Id IN (SELECT OrderId FROM OrderItem ) ];

        List<Order> ords = new List<Order>();
                      
        Test.startTest();

        for (Order ord : orders) {

            ord.Status = 'Activated';
            ords.add(ord);
           
            
        }
        update ords;
      
        Test.stopTest();

        System.assertEquals('Activated', ords[0].Status);
        System.assertEquals(31, ords.size());

    }

    @isTest
    static void inactiveAccWhereOrderDeleted() {

        List<Order> orders = [
            SELECT Id 
            FROM Order 
            WHERE Account.Name ='TestAccountActive_1'
        ];

        System.assertEquals(2, orders.size());
        Test.startTest();

        delete orders[0];
        delete orders[1]; 
        System.debug('liste orders avant  '+orders.size());
        Test.stopTest();

        Account result = [
                SELECT ID,Active__c,(SELECT ID FROM Orders) 
                FROM Account 
                WHERE Name = 'TestAccountActive_1'
        ];
        System.assertEquals(0,result.Orders.size());
        System.assertEquals(false,result.Active__c);
    }

    
}
