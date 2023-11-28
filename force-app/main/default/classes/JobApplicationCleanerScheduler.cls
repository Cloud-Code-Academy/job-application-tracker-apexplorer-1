public with sharing class JobApplicationCleanerScheduler implements Schedulable{
    
    public void execute(SchedulableContext context) {
        Database.executeBatch(new JobApplicationCleanerBatch());
    }
}