public with sharing class OrderHandler {

    public static void checkIfProductsOnOrders(List<Order> ordersList) {

        for (Order order : ordersList) {

            /* Number_of_products__c (Roll-Up Summary COUNT) : Counts the number of Order Product records related to the Order. 
            FYI it is natively not possible to create an Order Product with 0 quantity */

            if (order.Status == 'Activated' && order.Number_of_products__c == 0) /* Tester avec = 0*/ {
                order.addError('Your Order must have at least one product to be activated');
            }
        }
    }
    
}