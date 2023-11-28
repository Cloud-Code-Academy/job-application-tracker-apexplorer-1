@IsTest
public with sharing class JobApplicationTestDataFactory {

    public static void createJobApps() {
        List<Job_Application__c> jobApps = new List<Job_Application__c>();

        jobApps.add(
            new Job_Application__c(
                Position__c = 'Salesforce Admin',
                Job_Posting__c = 'www.sa.com',
                Status__c = 'Saved',
                Tax_Filing_Status__c = 'Single',
                Salary__c = 750000
            )
        );

        jobApps.add(
            new Job_Application__c(
                Position__c = 'Salesforce Developer',
                Job_Posting__c = 'www.sd.com',
                Status__c = 'Applying',
                Tax_Filing_Status__c = 'Married, Filing Jointly',
                Salary__c = 407200,
                Follow_Up__c = Date.today().addDays(-31)
            )
        );

        jobApps.add(
            new Job_Application__c(
                Position__c = 'Salesforce Lightning Developer',
                Job_Posting__c = 'www.sld.com',
                Status__c = 'Applied',
                Application_Submitted__c = Date.newInstance(2023, 11, 21),
                Tax_Filing_Status__c = 'Married, Filing Separately',
                Salary__c = 76400
            )
        );

        jobApps.add(
            new Job_Application__c(
                Position__c = 'Salesforce Senior Developer',
                Job_Posting__c = 'www.ssd.com',
                Status__c = 'Interviewing',
                Tax_Filing_Status__c = 'Head of Household',
                Salary__c = 14500,
                Follow_Up__c = Date.today().addDays(-45)
            )
        );

        jobApps.add(
            new Job_Application__c(
                Position__c = 'Salesforce Junior Developer',
                Job_Posting__c = 'www.sje.com',
                Status__c = 'Negotiating',
                Tax_Filing_Status__c = 'Single',
                Salary__c = 231251
            )
        );

        jobApps.add(
            new Job_Application__c(
                Position__c = 'Salesforce Engineer',
                Job_Posting__c = 'www.se.com',
                Status__c = 'Accepted',
                Tax_Filing_Status__c = 'Married, Filing Jointly',
                Salary__c = 19050
            )
        );

        jobApps.add(
            new Job_Application__c(
                Position__c = 'Salesforce Admin/Developer',
                Job_Posting__c = 'www.sad.com',
                Status__c = 'Closed',
                Tax_Filing_Status__c = 'Married, Filing Separately',
                Salary__c = 452876,
                Follow_Up__c = Date.today().addDays(-25)
            )
        );

        insert jobApps;
    }

    public static void createJobApp() {

        Job_Application__c jobApp = 
            new Job_Application__c(
                Position__c = 'Salesforce Admin',
                Job_Posting__c = 'www.sa.com',
                Status__c = 'Saved',
                Tax_Filing_Status__c = 'Head of Household',
                Salary__c = 59851
            );

        insert jobApp;
    }

    public static void createJobAppContacts() {
        List<Job_Application__c> jobApp = [SELECT Id FROM Job_Application__c LIMIT 1];
        List<Contact> contacts = [SELECT Id FROM Contact LIMIT 2];

        List<Job_Application_Contact__c> jobAppContacts = new List<Job_Application_Contact__c>();

        for(Contact contact : contacts) {
            Job_Application_Contact__c jobAppContact = new Job_Application_Contact__c();

            jobAppContact.Job_Application__c = jobApp[0].Id;
            jobAppContact.Contact__c = contact.Id;

            jobAppContacts.add(jobAppContact);
        }

        insert jobAppContacts;
    }

    public static void createCompany() {

        Account account =
            new Account(
                Name = 'Bob\'s Burgers'
            );

        insert account;

        createContacts(account);
    }

    static void createContacts(Account account) {
        List<Contact> contacts = new List<Contact>();

        contacts.add(
            new Contact(
                LastName = 'Bob',
                Email = 'belcher@bobsburgers.com',
                AccountId = account.Id
            )
        );

        contacts.add(
            new Contact(
                FirstName = 'Linda',
                LastName = 'Belcher',
                Email = 'belcher@bobsburgers.com',
                AccountId = account.Id
            )
        );

        contacts.add(
            new Contact(
                FirstName = 'Gene',
                LastName = 'Belcher',
                Email = 'belcher@bobsburgers.com',
                AccountId = account.Id
            )
        );

        insert contacts;
    }

    public static void createJobAppWithCompany() {

        List<Account> company = [SELECT Id FROM Account];

        Job_Application__c jobApp = 
            new Job_Application__c(
                Position__c = 'Salesforce Admin',
                Job_Posting__c = 'www.sa.com',
                Status__c = 'Saved',
                Salary__c = 554760,
                Tax_Filing_Status__c = 'Single',
                Company__c = company[0].Id
            );

        insert jobApp;
    }
}