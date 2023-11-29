public with sharing class JobFinderService {

    @AuraEnabled
    public static List<JobWrapper.Job> getJobs(String keywords, String location) {
        return JoobleAPI.getJobs(keywords, location);
    }

    @AuraEnabled
    public static void createJobApplications(List<Object> createJobs) {
        List<Job_Application__c> jobApps = new List<Job_Application__c>();

        try {
            String jobsJson = JSON.serialize(createJobs);

            List<JobWrapper.Job> jobs = 
                (List<JobWrapper.Job>) JSON.deserialize(jobsJson, List<JobWrapper.Job>.class);
    
            for(JobWrapper.Job job : jobs) {
                Job_Application__c jobApp = new Job_Application__c();
                jobApp.Position__c = job.title;
                jobApp.Notes__c = 'Company: ' + job.company + 
                                  '\n Salary: ' + job.salary;
                jobApp.Location__c = job.location;
                jobApp.Description__c = job.snippet;
                jobApp.Job_Posting__c = job.link;
    
                jobApps.add(jobApp);
            }
        } catch(Exception e) {
            e.setMessage('Error creating Job Application!');
            throw e;
        }

        insert jobApps;
    }
}