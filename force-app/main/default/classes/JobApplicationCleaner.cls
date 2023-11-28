public with sharing class JobApplicationCleaner {

    private static List<Job_Application__c> staleJobApps;
    
    public static List<Job_Application__c> getStaleJobApps() {
        staleJobApps = [Select Id, Notes__c FROM Job_Application__c 
                            WHERE Status__c NOT IN ('Accepted','Closed','Closed Stale') 
                            AND Follow_Up__c < N_DAYS_AGO:30];

        return staleJobApps;
    }

    public static void closeStaleJobApps(List<Job_Application__c> staleJobApps) {
        List<Job_Application__c> jobAppsToUpdate = new List<Job_Application__c>();

        for(Job_Application__c jobApp : staleJobApps) {
            jobApp.Status__c = 'Closed Stale';
            jobApp.Notes__c += '\n This job application has been closed on ' 
                                    + Date.today() + ' by the Job Application Cleaner asynchronous process.';
            jobAppsToUpdate.add(jobApp);
        } 
    
        update jobAppsToUpdate;
    } 

    public static void sendEmail(Database.BatchableContext context) {
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, TotalJobItems 
                                FROM AsyncApexJob WHERE Id = :context.getJobId()];
                                
        List<User> user = [SELECT Email FROM User WHERE Id = '005Ho000009zExUIAU'];
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] sendTo = new String[]{String.valueOf(user[0].Email)};

        mail.setToAddresses(sendTo);
        mail.setSubject('Job Application Cleaner Process ' + job.Status);
        mail.setPlainTextBody(
            'The Job Application Cleaner processed ' + job.TotalJobItems +
            ' batches with ' + job.NumberOfErrors + ' failures.');

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }
}