global with sharing class CreateReminderOnAccountBatch implements Database.Batchable<SObject>, Schedulable {

    global Database.QueryLocator start(Database.BatchableContext bc){

        return Database.getQueryLocator([
            SELECT Id, OwnerId
            FROM Account
            WHERE Active__c = false
        ]);
    }

    global void execute(Database.BatchableContext bc, List<Account> scope){
        
        List<Task> tasksList = new List<Task>();
        Set<Id> accountIdSet = (new Map<Id,SObject>(scope)).keySet();
        Map<Id,Order> mapAccountIdToOrder = AccountService.getAccountIdToOrderMap(accountIdSet);
        Map<Id,Task> mapAccountIdToTask = AccountService.getAccountIdToTaskMap(accountIdSet);

        for (Account account : scope){

            if (mapAccountIdToOrder.get(account.id) == null && mapAccountIdToTask.get(account.id) == null){
                Task task = new Task(
                    WhatId = account.Id,
                    OwnerId = account.OwnerId,
                    Subject = 'Call',
                    Status = 'Not Started',
                    Priority = 'Normal',
                    ReminderDateTime = Date.today()+5
                );
                tasksList.add(task);
            }
        }
        insert tasksList;
    }

    global void finish(Database.BatchableContext bc){

    }

    global void execute(SchedulableContext sc){
        CreateReminderOnAccountBatch scheduledBatch = new CreateReminderOnAccountBatch();
        Database.executeBatch(scheduledBatch);
    }

}