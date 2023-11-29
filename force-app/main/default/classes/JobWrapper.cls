public with sharing class JobWrapper {

    @AuraEnabled public Integer totalCount;
    @AuraEnabled public Job[] jobs;

    public class Job {
        @AuraEnabled public String title;
        @AuraEnabled public String location;
        @AuraEnabled public String snippet;
        @AuraEnabled public String salary;
        @AuraEnabled public String source;
        @AuraEnabled public String type;
        @AuraEnabled public String link;
        @AuraEnabled public String company;
        @AuraEnabled public String updated;
        @AuraEnabled public String id;
    }
}