public with sharing class JobApplicationCleanerBatch implements Database.Batchable<Job_Application__c> {

    public Iterable<Job_Application__c> start(Database.BatchableContext context) {
        return JobApplicationCleaner.getStaleJobApps();
    }

    public void execute(Database.BatchableContext context, List<Job_Application__c> staleJobApps) {
        JobApplicationCleaner.closeStaleJobApps(staleJobApps);
    }    

    public void finish(Database.BatchableContext context) {  
        JobApplicationCleaner.sendEmail(context);
    }
    
}