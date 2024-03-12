public with sharing class AccountService {

    public static Map<Id,Order> getAccountIdToOrderMap(Set<Id> accountIdSet){

        List<Order> ordersList = [
            SELECT Id, AccountId
            FROM Order
            WHERE AccountId IN: accountIdSet
        ];

        Map<Id,Order> mapAccountIdToOrder = new Map<Id,Order>();
        for (Order order : ordersList){
            mapAccountIdToOrder.put(order.AccountId, order);
        }
        return mapAccountIdToOrder;
    }

    public static Map<Id,Task> getAccountIdToTaskMap(Set<Id> accountIdSet){

        List<Task> tasksList = [
            SELECT Id, WhatId
            FROM Task
            WHERE WhatId IN: accountIdSet
        ];

        Map<Id,Task> mapAccountIdToTask = new Map<Id,Task>();
        for (Task task : tasksList){
            mapAccountIdToTask.put(task.WhatId, task);
        }
        return mapAccountIdToTask;
    }

}