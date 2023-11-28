@isTest
public with sharing class JobApplicationHelperTest {

    @isTest
    static void testGenerateTaskRecordsInsert() {
        Test.startTest();

        JobApplicationTestDataFactory.createJobApps();

        Test.stopTest();

        Map<Id,Job_Application__c> jobApps = new Map<Id,Job_Application__c>([SELECT Id FROM Job_Application__c]);
        
        List<AggregateResult> aggResult = [SELECT WhatId, COUNT(Id) taskCount FROM Task WHERE WhatId IN :jobApps.keyset() GROUP BY WhatId];

        Assert.areEqual(3, aggResult[0].get('taskCount'));
        Assert.areEqual(5, aggResult[1].get('taskCount'));
        Assert.areEqual(4, aggResult[2].get('taskCount'));
        Assert.areEqual(5, aggResult[3].get('taskCount'));
        Assert.areEqual(3, aggResult[4].get('taskCount'));
        Assert.areEqual(3, aggResult[5].get('taskCount'));
        Assert.areEqual(2, aggResult[6].get('taskCount'));
    }

    @isTest
    static void testGenerateTaskRecordsUpdate_StatusNoChange() {
        Test.startTest();

        JobApplicationTestDataFactory.createJobApp();

        List<Job_Application__c> jobApps = new List<Job_Application__c>([SELECT Id FROM Job_Application__c LIMIT 1]);
        jobApps[0].Salary__c = 125000;
        jobApps[0].Tax_Filing_Status__c = 'Married, Filing Separately';

        update jobApps[0];

        Test.stopTest();

        List<AggregateResult> aggResult = [SELECT WhatId, COUNT(Id) taskCount FROM Task WHERE WhatId = :jobApps[0].Id GROUP BY WhatId];

        Assert.areEqual(3, aggResult[0].get('taskCount'));
    }

    @isTest
    static void testGenerateTaskRecordsUpdate_StatusChange() {
        Test.startTest();

        JobApplicationTestDataFactory.createJobApp();

        List<Job_Application__c> jobApps = new List<Job_Application__c>([SELECT Id FROM Job_Application__c LIMIT 1]);
        jobApps[0].Status__c = 'Applying';
        jobApps[0].Salary__c = 221650;

        update jobApps[0];
        
        Test.stopTest();

        List<AggregateResult> aggResult = [SELECT WhatId, COUNT(Id) taskCount FROM Task WHERE WhatId = :jobApps[0].Id GROUP BY WhatId];

        Assert.areEqual(8, aggResult[0].get('taskCount'));
    }

    @isTest
    static void testGenerateTaskRecordsUpdate_StatusChangeOldStatus() {
        Test.startTest();

        JobApplicationTestDataFactory.createJobApp();

        List<Job_Application__c> jobApps = new List<Job_Application__c>([SELECT Id FROM Job_Application__c LIMIT 1]);
        jobApps[0].Status__c = 'Applying';
        jobApps[0].Salary__c = 182400;
        jobApps[0].Tax_Filing_Status__c = 'Married, Filing Jointly';

        update jobApps[0];

        jobApps[0].Status__c = 'Saved';
        jobApps[0].Salary__c = 526700;

        update jobApps[0];
        
        Test.stopTest();

        List<AggregateResult> aggResult = [SELECT WhatId, COUNT(Id) taskCount FROM Task WHERE WhatId = :jobApps[0].Id GROUP BY WhatId];

        Assert.areEqual(8, aggResult[0].get('taskCount'));
    }

    @isTest
    static void testGenerateTaskRecordsUpdate_StatusAppliedNoSubmissionDate() {
        Test.startTest();

        JobApplicationTestDataFactory.createJobApp();

        List<Job_Application__c> jobApps = new List<Job_Application__c>([SELECT Id FROM Job_Application__c LIMIT 1]);
        jobApps[0].Status__c = 'Applied';

        Database.SaveResult result = Database.update(jobApps[0], false);

        Test.stopTest();

        Assert.isTrue(!result.isSuccess());
        Assert.isTrue(result.getErrors().size() > 0);
        Assert.areEqual('Please enter when the application was submitted.',
                             result.getErrors()[0].getMessage());
    }

    @isTest
    static void testAddPrimaryContact() {
        Test.startTest();

        JobApplicationTestDataFactory.createCompany();
        JobApplicationTestDataFactory.createJobApp();
        JobApplicationTestDataFactory.createJobAppContacts();

        List<Job_Application__c> jobApp = [SELECT Id, Primary_Contact__c FROM Job_Application__c LIMIT 1];

        jobApp[0].Salary__c = 152000;

        update jobApp[0];

        Test.stopTest();

        List<Job_Application__c> updatedJobApp = [SELECT Id, Primary_Contact__c FROM Job_Application__c LIMIT 1];

        Assert.isTrue(updatedJobApp[0].Primary_Contact__c != null);
    }

    @isTest
    static void testInitializeWithPrimaryContact() {
        Test.startTest();

        JobApplicationTestDataFactory.createCompany();
        JobApplicationTestDataFactory.createJobAppWithCompany();

        Test.stopTest();

        List<Job_Application__c> jobApp = [SELECT Id, Primary_Contact__c FROM Job_Application__c LIMIT 1];

        Assert.isTrue(jobApp[0].Primary_Contact__c != null);
    }
}