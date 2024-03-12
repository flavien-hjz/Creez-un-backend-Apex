@isTest
public with sharing class TestAccountService{

    @TestSetup
    static void makeData(){

        Account account = DataFactory.createAccount('testAccount1');
        insert account;

        DataFactory.createOrdersCompleteProcess('testAccount2', 'testProduct2', 1000, 1, 1);

        Account testAccount2 = [
            SELECT Id, OwnerId
            FROM Account
            WHERE Name = 'testAccount2'
        ];
        Task testTask = new Task(
            WhatId = testAccount2.Id,
            OwnerId = testAccount2.OwnerId,
            Subject = 'Call',
            Status = 'Not Started',
            Priority = 'Normal',
            ReminderDateTime = Date.today()+5
        );
        insert testTask;
        
    }

    @isTest
    static void getAccoundIdToOrderMapWhenNoOrderTest(){
        
        List<Account> testAccountsList = [
            SELECT Id
            FROM Account
            WHERE Name = 'testAccount1'
        ];
        Set<Id> accountIdSet = (new Map<Id,SObject>(testAccountsList).keySet());

        Test.startTest();
        Map<Id,Order> mapAccountIdToOrder = AccountService.getAccountIdToOrderMap(accountIdSet);
        Test.stopTest();

        System.assertEquals(0, mapAccountIdToOrder.size());
    }

    @isTest
    static void getAccountIdToOrderMapWhenOrderTest(){

        List<Account> testAccountsList = [
            SELECT Id, OwnerId
            FROM Account
            WHERE Name = 'testAccount2'
        ];
        Set<Id> accountIdSet = (new Map<Id,SObject>(testAccountsList).keySet());

        Test.startTest();
        Map<Id,Order> mapAccountIdToOrder = AccountService.getAccountIdToOrderMap(accountIdSet);
        Test.stopTest();

        System.assertEquals(1, mapAccountIdToOrder.size());
    }

    @isTest
    static void getAccountIdToTaskWhenNoTaskTest(){

        List<Account> testAccountsList = [
            SELECT Id
            FROM Account
            WHERE Name = 'testAccount1'
        ];
        Set<Id> accountIdSet = (new Map<Id,SObject>(testAccountsList).keySet());

        Test.startTest();
        Map<Id,Task> mapAccountIdToTask = AccountService.getAccountIdToTaskMap(accountIdSet);
        Test.stopTest();

        System.assertEquals(0, mapAccountIdToTask.size());
    }

    @isTest
    static void getAccountIdToTaskWhenTask(){

        List<Account> testAccountsList = [
            SELECT Id, OwnerId
            FROM Account
            WHERE Name = 'testAccount2'
        ];
        Set<Id> accountIdSet = (new Map<Id,SObject>(testAccountsList).keySet());

        Test.startTest();
        Map<Id,Task> mapAccountIdToTask = AccountService.getAccountIdToTaskMap(accountIdSet);
        Test.stopTest();
        
        System.assertEquals(1, mapAccountIdToTask.size());
    }
}