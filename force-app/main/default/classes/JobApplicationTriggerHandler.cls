public with sharing class JobApplicationTriggerHandler {

    JobApplicationHelper helper;

    public JobApplicationTriggerHandler() {
        this.helper = new JobApplicationHelper(
            (List<Job_Application__c>) Trigger.new,
            (Map<Id,Job_Application__c>) Trigger.newMap,
            (List<Job_Application__c>) Trigger.old,
            (Map<Id,Job_Application__c>) Trigger.oldMap
        );
    }
    
    public void handleBeforeInsert() {
        helper.initializeWithPrimaryContact();
        helper.estimateTakeHomePay();
    }

    public void handleAfterInsert() {
        helper.initializeTaskRecords();
    }

    public void handleBeforeUpdate() {
        helper.generateTaskRecords();
        helper.addPrimaryContact();
        helper.estimateTakeHomePay();
    }
}