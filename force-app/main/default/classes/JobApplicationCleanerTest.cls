@isTest
public with sharing class JobApplicationCleanerTest {

    @isTest
    static void testJobAppCleaner() {
        JobApplicationTestDataFactory.createJobApps();

        Test.startTest();

        JobApplicationCleanerScheduler scheduler = new JobApplicationCleanerScheduler();
        scheduler.execute(null);

        Test.stopTest();

        List<Job_Application__c> jobApps = [SELECT Id FROM Job_Application__c WHERE Status__c = 'Closed Stale'];

        Assert.areEqual(2, jobApps.size());
    }
}