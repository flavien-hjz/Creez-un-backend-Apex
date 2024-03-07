@isTest
public with sharing class TestOrderHandler {

    @TestSetup
    static void makeData(){
        DataFactory.createOrdersCompleteProcess('testAccount1', 'testProduct1', 100, 1, 1);
        DataFactory.createOrdersCompleteProcess('testAccount2', 'testProduct2', 100, 1, 0);   
    }

    @isTest
    static void updateStatusOrderWithProductTest(){
        List<Order> ordersList = [
            SELECT Id, OrderNumber, Order.Account.Name
            FROM Order
            WHERE Account.Name = 'testAccount1'
            ];
    

    List<Order> activatedOrders = new List<Order>();
    
    Test.startTest();

    for (Order order : ordersList){
        order.Status = 'Activated';
        activatedOrders.add(order);
    }
    update activatedOrders;

    Test.stopTest();

    List<Order> updatedOrdersList = [
        SELECT Id, OrderNumber
        FROM Order
        WHERE Status = 'Activated'
    ];

    System.assertEquals(1, updatedOrdersList.size());
    }

    @isTest
    static void updateStatusOrderWithNoProductTest(){
        List<Order> ordersList = [
            SELECT Id, OrderNumber, Order.Account.Name
            FROM Order
            WHERE Account.Name = 'testAccount2'
        ];

        List<Order> activatedOrders = new List<Order>();

        Test.startTest();

        for (Order order : ordersList){
            order.Status = 'Activated';
            activatedOrders.add(order);
        }

        try {
            update activatedOrders;    
        } catch (Exception e) {
            
        }

        Test.stopTest();

        List<Order> updatedOrdersList = [
            SELECT Id, OrderNumber
            FROM Order
            WHERE Status = 'Activated'
        ];

        System.assertEquals(0, updatedOrdersList.size());
    }

    @isTest
    static void checkAccountInactiveOnCreationTest(){
        Account account = DataFactory.createAccount('testAccount3');
        insert account;

        System.assertEquals(false, account.Active__c);
    }

    @isTest
    static void checkAccountIsActiveOnOrderCreationTest(){
        Account account = DataFactory.createAccount('testAccount4');
        insert account;

        Contract contract = DataFactory.createContract(account.Id);
        insert contract;

        List<Order> ordersList = DataFactory.createOrders(account.id, 1);
        insert ordersList;

        Account activatedAccount = [
            SELECT Id, Name, Active__c
            FROM Account
            WHERE Name = 'testAccount4'
        ];

        System.assertEquals(true, activatedAccount.Active__c);
    }

    @isTest
    static void checkAccountIsInactiveOnOrderDeletionTest(){
        Account account = DataFactory.createAccount('testAccount5');
        insert account;

        Contract contract = DataFactory.createContract(account.Id);
        insert contract;

        List<Order> ordersList = DataFactory.createOrders(account.Id, 1);
        insert ordersList;
        delete ordersList;

        Account deactivatedAccount = [
            SELECT Id, Name, Active__c
            FROM Account
            WHERE Name = 'testAccount5'
        ];

        System.assertEquals(false, deactivatedAccount.Active__c);
    }
}
