@isTest
public with sharing class TestCreateReminderOnAccountBatch {

    @TestSetup
    static void makeData(){

        Account account = DataFactory.createAccount('testAccount1');
        insert account;

        DataFactory.createOrdersCompleteProcess('testAccount2', 'testProduct2', 100, 1, 1);
        
    }

    private static String CRON_EXP = '0 0 0 ? * 2#1'; // At midnight, the 1st Monday of the month, every month

    @isTest
    static void testBatchExecution(){
        
        List<Account> accountsList = [
            SELECT Id, Name
            FROM Account
            WHERE Name LIKE 'testAccount%'
        ];

        Test.startTest();
        CreateReminderOnAccountBatch testBatch = new CreateReminderOnAccountBatch();
        Database.executeBatch(testBatch);
        Test.stopTest();

        List<Task> tasksOnAccountsList = [
            SELECT Id
            FROM Task
            WHERE WhatId IN: accountsList
        ];

        System.assertEquals(1, tasksOnAccountsList.size());
    }

    @isTest
    static void testScheduler(){

        Test.startTest();
        CreateReminderOnAccountBatch scheduler = new CreateReminderOnAccountBatch();
        String jobId = System.schedule('Test Scheduler', CRON_EXP, scheduler);
        Test.stopTest();

        List<CronTrigger> cts = [
            SELECT Id, TimesTriggered, NextFireTime
            FROM CronTrigger
            WHERE ID = :jobId];
        System.debug('Next Fire Time' + cts[0].NextFireTime);

        System.assertNotEquals(null, jobId);

    }
}