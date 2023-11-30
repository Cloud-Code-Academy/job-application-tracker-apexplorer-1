@isTest
public with sharing class JobFinderServiceTest {
    
    @isTest
    static void testGetJobsSuccess() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseSuccess());

        List<JobWrapper.Job> jobs = JobFinderService.getJobs('Software Developer', 'Washington DC');
        
        Assert.areEqual(2, jobs.size());
    }

    @isTest
    static void testGetJobsSuccessEmpty() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseSuccessEmpty());

        List<JobWrapper.Job> jobs = JobFinderService.getJobs('Senior Salesforce Engineer', 'Austin, TX');

        Assert.areEqual(null, jobs);
    }

    @isTest
    static void testGetJobsError() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseError());

        List<JobWrapper.Job> jobs = JobFinderService.getJobs('Junior Salesforce Developer', 'Hartford, CT');

        Assert.areEqual(null, jobs);
    }

    @isTest
    static void testGetJobsNull() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseNull());

        try {
            List<JobWrapper.Job> jobs = JobFinderService.getJobs('Junior Salesforce Developer', 'Hartford, CT');
        } catch (Exception e) {
            Assert.areEqual('Error encountered calling Jooble API service.', e.getMessage());
        }
    }

    @isTest
    static void testCreateJobApplicationsSucess() {
        List<Object> createJobs = new List<Object>();
       
        JobWrapper.Job jobOne = new JobWrapper.Job();
        jobOne.title = 'Salesforce Engineer';
        jobOne.location = 'New Jersey';
        jobOne.salary = '$110,000';
        jobOne.link = 'www.se.com';
        jobOne.company = 'ABC Consulting';

        JobWrapper.Job jobTwo = new JobWrapper.Job();
        jobTwo.title = 'Salesforce Admin/Developer';
        jobTwo.location = 'New York';
        jobTwo.salary = '$140,000';
        jobTwo.link = 'www.sad.com';
        jobTwo.company = 'XYZ Inc';

        createJobs.add(jobOne);
        createJobs.add(jobTwo);

        Test.startTest();

        JobFinderService.createJobApplications(createJobs);

        Test.stopTest();

        List<Job_Application__c> insertedJobApps = [SELECT Id FROM Job_Application__c];

        Assert.areEqual(2, insertedJobApps.size());
    }

    @isTest
    static void testCreateJobApplicationsError() {
        List<Object> createJobs = new List<Object>();

        createJobs.add(null);

        Test.startTest();

        try {
            JobFinderService.createJobApplications(createJobs);
        } catch (Exception e) {
            Assert.areEqual('Error creating Job Application!', e.getMessage());
        }

        Test.stopTest();
    }

    public class MockHttpResponseSuccess implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('OK');
            response.setBody('{"totalCount": 2, "jobs": [{"title": "Salesforce Engineer", "company": "ABC Consulting", "salary": "$125,000", "location": "San Francisco", "snippet": "Seeking Awesome Engineer!", "link": "www.se.com"}, {"title": "Junior Salesforce Engineer", "company": "XYZ Inc", "salary": "$80,000", "location": "New York", "snippet": "Calling All Salesforce Enthusiasts!", "link": "www.jse.com"}]}');
            return response;
        }
    }

    public class MockHttpResponseSuccessEmpty implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setStatus('OK');
            response.setBody('{"totalCount":0,"jobs":[]}');
            return response;
        }
    }

    public class MockHttpResponseError implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(500);
            response.setStatus('Internal Server Error');
            response.setBody('{"error": "Internal Server Error"}');
            return response;
        }
    }

    public class MockHttpResponseNull implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(null);
            response.setStatus(null);
            response.setBody(null);
            return response;
        }
    }
}