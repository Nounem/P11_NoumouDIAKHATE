/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-14-2022
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
        System.assertEquals(25, ords.size());

    }

    @isTest
    static void inactiveAccWhereOrderDeleted() {
        List <Account> accts = [
            SELECT Id, Active__c, ( SELECT Id FROM Orders )
            FROM Account
            WHERE Name LIKE 'TestAccount_%'
        ];
        for (Account acc : accts) {
            System.assertEquals(False, acc.Active__c);
        }
        Test.startTest();
        for(Account acc : accts){
            for(Order ord : acc.Orders){
                delete ord;
            }}
        Test.stopTest();
        accts = [
            SELECT Id, Active__c
            FROM Account
            WHERE Name LIKE 'TestAccount_%'
        ];
        for (Account acc : accts) {
            System.assertEquals(false, acc.Active__c);
        }
    }

    
}
