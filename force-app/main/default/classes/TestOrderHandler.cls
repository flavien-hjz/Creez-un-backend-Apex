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
}
