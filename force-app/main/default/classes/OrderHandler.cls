public with sharing class OrderHandler {

    public static void updateOrderStatus(List<Order> ordersList){

        for (Order order : ordersList) {

            /* Number_of_products__c (Roll-Up Summary COUNT) : Counts the number of Order Product records related to the Order. 
            FYI it is natively not possible to create an Order Product with 0 quantity 
            If the condition is false, the update occurs. If not, an error message displays*/

            if (order.Status == 'Activated' && order.Number_of_products__c == 0){
                order.addError('Your Order must have at least one product to be activated');
            }
        }
    }

    public static void makeAccountActive(List<Order> ordersList){
        
        // First, we retrieve all accounts ids from the trigger
        
        List<Id> accountsFromTriggerList = new List<Id>();
        for (Order order : ordersList){
            accountsFromTriggerList.add(order.AccountId);
        }

        // Then, we search accounts than can be found in the trigger list and on the Order object as well

        List<Account> accountsToTurnOnList = [
            SELECT Id, Active__c, (SELECT Id, AccountId FROM Orders)
            FROM Account
            WHERE Id IN:accountsFromTriggerList
        ];

        // Finally, we make active the accounts found that are still inactive

        for (Account account : accountsToTurnOnList){
            if (account.Active__c == false){
                account.Active__c = true;
            }
        }
        update accountsToTurnOnList;
    }

    public static void makeAccountInactive(List<Order> ordersList){

        // First, we retrieve all accounts ids from the trigger

        List<Id> accountsFromTriggerList = new List<Id>();
        for (Order order : ordersList){
            accountsFromTriggerList.add(order.AccountId);
        }

        // Then, we search accounts than can be found in the trigger list but not on the Order object

        List<Account> accountsToTurnOffList = [
            SELECT Id, Active__c
            FROM Account
            WHERE Id IN:accountsFromTriggerList
            AND Id NOT IN (SELECT AccountId FROM Order)
        ];

        // Finally, we make the accounts found inactive

        for (Account account : accountsToTurnOffList){
            account.Active__c = false;
        }
        update accountsToTurnOffList;
    }

}