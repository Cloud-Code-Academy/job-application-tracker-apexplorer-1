public with sharing class JoobleAPI {

    public static List<JobWrapper.Job> getJobs(String keywords, String location) {
        List<JobWrapper.Job> jobs;

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint('callout:JoobleAPI');
        request.setMethod('POST');
        request.setBody('{ "keywords": "' + keywords + '", "location": "' + location + '"}');

        try {
            HttpResponse response = http.send(request);

            if(response.getStatusCode() == 200) {

                if(!String.isEmpty(response.getBody())) {
                    JobWrapper jobWrapper = (JobWrapper) JSON.deserialize(response.getBody(), JobWrapper.class);

                    if(jobWrapper.totalCount != 0) {
                        jobs = jobWrapper.jobs;
                    }   
                }
            }
        } catch(Exception e) {
            e.setMessage('Error encountered calling Jooble API service.');
            throw e;
        }

        return jobs;
    }
}