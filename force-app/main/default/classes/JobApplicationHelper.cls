public with sharing class JobApplicationHelper {

    List<Job_Application__c> jobApps;
    Map<Id,Job_Application__c> jobAppsMap;
    List<Job_Application__c> oldJobApps;
    Map<Id,Job_Application__c> oldJobAppsMap;

    List<Task> tasks = new List<Task>();

    final Decimal SINGLE_MARRIED_SEPARATELY_STD_DED = 13850;
    final Decimal MARRIED_JOINTLY_STD_DED = 27700;
    final Decimal HEAD_HOUSEHOLD_STD_DED = 20800;

    public JobApplicationHelper(
        List<Job_Application__c> jobApps,
        Map<Id,Job_Application__c> jobAppsMap,
        List<Job_Application__c> oldjobApps,
        Map<Id,Job_Application__c> oldJobAppsMap) {

        this.jobApps = jobApps;
        this.jobAppsMap = jobAppsMap;
        this.oldJobApps = oldjobApps;
        this.oldJobAppsMap = oldJobAppsMap;
    }

    public void initializeTaskRecords() {

        for(Job_Application__c jobApp : jobApps) {
            if(!String.isEmpty(jobApp.Status__c)) {
                generateTasksByStatus(jobApp);
            }
        }

        insert tasks;
    }

    public void generateTaskRecords() {
        Boolean doExistingTasksForStatusExist = false;

        List<AggregateResult> taskSets = [SELECT WhatId, COUNT(Id) taskCount, Task_Set__c FROM Task WHERE WhatId IN :jobAppsMap.keyset() GROUP BY Task_Set__c, WhatId];

        for(Job_Application__c jobApp : jobAppsMap.values()) {
            if(!String.isEmpty(jobApp.Status__c)) {
                if(!jobApp.Status__c.equals(oldJobAppsMap.get(jobApp.Id).Status__c)) {

                    for(AggregateResult taskSet : taskSets) {

                        if(taskSet.get('WhatId') == jobApp.Id 
                            && taskSet.get('Task_Set__c') == jobApp.Status__c) {
                            
                            doExistingTasksForStatusExist = true;
                            break;
                        }
                    }

                    if(!doExistingTasksForStatusExist) {
                        generateTasksByStatus(jobApp);
                    }
                }
            }
        }

        insert tasks;     
    }

    private void generateTasksByStatus(Job_Application__c jobApp) {

        switch on jobApp.Status__c {
            when 'Saved' {
                List<String> subjects = new List<String> {
                    'Check if the job description aligns with your interests and values',
                    'Review the highlighted skills to see if the role is a good fit',
                    'Research the company or role and mark your excitement level'
                };

                createTasks(jobApp, subjects);
            }
            when 'Applying' {
                List<String> subjects = new List<String> {
                    'Find and research someone who works at the company and add them as a contact',
                    'Set up an informational interview to learn more about the role/company',
                    'Identify potential referrals to help get your application on the top of the pile',
                    'Customize your work achievements using the job description keywords',
                    'Submit your application on the company website if possible'
                };

                createTasks(jobApp, subjects);
            }
            when 'Applied' {

                if(jobApp.Application_Submitted__c != null) {
                    List<String> subjects = new List<String> {
                        'Reach out to the hiring manager or recruiter',
                        'Follow up on your application via email weekly',
                        'Continue identifying and saving similar job opportunities',
                        'Set up weekly networking calls to explore similar roles/companies'
                    };
    
                    createTasks(jobApp, subjects);
                } else {
                    jobApp.Application_Submitted__c.addError('Please enter when the application was submitted.');
                }

            }
            when 'Interviewing' {
                List<String> subjects = new List<String> {
                    'Prepare your blurb or “tell me about yourself” response',
                    'Practice answering behavioral interview questions',
                    'Research the company and your interviewers',
                    'Set up your virtual interview space and test your tech',
                    'Send thank you emails within 24 hours'
                };

                createTasks(jobApp, subjects);
            }
            when 'Negotiating' {
                List<String> subjects = new List<String> {
                    'Research your market value and know your numbers',
                    'Prepare your negotiation scripts',
                    'Evaluate your offer and decline or accept'
                };

                createTasks(jobApp, subjects);
            }
            when 'Accepted' {
                List<String> subjects = new List<String> {
                    'Plan your resignation if applicable',
                    'Take some time to relax and recharge',
                    'Prepare for your first day of onboarding'
                };

                createTasks(jobApp, subjects);
            }
            when 'Closed' {
                List<String> subjects = new List<String> {
                    'Send a follow-up email thanking the interviewer and asking for feedback',
                    'Review your notes and reflect on areas of improvement'
                };

                createTasks(jobApp, subjects);
            }
        }
    }

    private void createTasks(Job_Application__c jobApp, List<String> subjects) {

        for(String subject : subjects) {
            Task task = new Task();
            task.Subject = subject;
            task.WhatId = jobApp.Id;
            task.OwnerId = jobApp.OwnerId;
            task.ActivityDate = Date.today().addDays(2);
            task.Task_Set__c = jobApp.Status__c;
            tasks.add(task); 
        }
    }

    public void addPrimaryContact() {

        Map<Id,Job_Application__c> keyContacts = new Map<Id,Job_Application__c>(
            [SELECT Id, (SELECT Id, Contact__r.Id FROM Job_Application_Contacts__r) FROM Job_Application__c 
                WHERE Id IN :jobAppsMap.keyset()]);

        if(!keyContacts.isEmpty()) {

            for(Job_Application__c jobApp : jobAppsMap.values()) { 
                if(String.isEmpty(jobApp.Primary_Contact__c)) {
                    if(keyContacts.containsKey(jobApp.Id)) {
                        if(!keyContacts.get(jobApp.Id).Job_Application_Contacts__r.isEmpty()) {
                            jobApp.Primary_Contact__c = 
                                keyContacts.get(jobApp.Id).Job_Application_Contacts__r[0].Contact__r.Id;
                            break;
                        }
                    } 
                }
            }
        }

        checkForJobAppCompany();
    }

    public void checkForJobAppCompany() {
        Map<Id,Contact> companyContacts;
        Set<Id> jobAppCompanyIds = new Set<Id>();

        for(Job_Application__c jobApp : jobApps) {
            jobAppCompanyIds.add(jobApp.Company__c);
        }

        if(!jobAppCompanyIds.isEmpty()) {
            companyContacts = 
                new Map<Id,Contact>(
                    [SELECT AccountId FROM Contact WHERE AccountId IN :jobAppCompanyIds ORDER BY CreatedDate]
                );

            if(!companyContacts.isEmpty()) {

                for(Job_Application__c jobApp : jobApps) {
                    if(String.isEmpty(jobApp.Primary_Contact__c)) {
                        checkForCompanyContact(jobApp, companyContacts);   
                    }
                }
            }
        } 
    }

    public void initializeWithPrimaryContact() {
        checkForJobAppCompany();
    }

    public void checkForCompanyContact(Job_Application__c jobApp, Map<Id,Contact> companyContacts) {

        for(Contact contact : companyContacts.values()) {
            if(contact.AccountId != null) {
                if(contact.AccountId.equals(jobApp.Company__c)) {
                    jobApp.Primary_Contact__c = contact.Id;
                    break;
                }
            }
        }
    }

    public void estimateTakeHomePay() {
        for(Job_Application__c jobApp : jobApps) {
            if(jobApp.Salary__c != null) {
                calculateEstimatedFederalTaxes(jobApp);

                jobApp.Estimated_Social_Security_Tax__c = 
                    WithholdingsCalculator.calculateEstimatedSocialSecurityTax(jobApp.Salary__c);

                jobApp.Estimated_Medicare_Tax__c = 
                    WithholdingsCalculator.calculateEstimatedMedicareTax(jobApp.Salary__c);

                calculateEstimatedTakeHomePay(jobApp);
            }
        }
    }

    private void calculateEstimatedFederalTaxes(Job_Application__c jobApp) {

        switch on jobApp.Tax_Filing_Status__c {
            when 'Single' {
                jobApp.Taxable_Income__c = 
                    WithholdingsCalculator.calculateTaxableIncome(jobApp.Salary__c, SINGLE_MARRIED_SEPARATELY_STD_DED);
                
                jobApp.Estimated_Federal_Taxes__c = 
                    WithholdingsCalculator.calculateTaxForSingleFilingStatus(jobApp.Taxable_Income__c);
            }
            when 'Married, Filing Jointly' {
                jobApp.Taxable_Income__c = 
                    WithholdingsCalculator.calculateTaxableIncome(jobApp.Salary__c, MARRIED_JOINTLY_STD_DED);
                
                jobApp.Estimated_Federal_Taxes__c = 
                    WithholdingsCalculator.calculateTaxForMarriedJointlyFilingStatus(jobApp.Taxable_Income__c);
            }
            when 'Married, Filing Separately' {
                jobApp.Taxable_Income__c = 
                    WithholdingsCalculator.calculateTaxableIncome(jobApp.Salary__c, SINGLE_MARRIED_SEPARATELY_STD_DED);
                
                jobApp.Estimated_Federal_Taxes__c = 
                    WithholdingsCalculator.calculateTaxForMarriedSeparatelyFilingStatus(jobApp.Taxable_Income__c);
            }
            when 'Head of Household' {
                jobApp.Taxable_Income__c = 
                    WithholdingsCalculator.calculateTaxableIncome(jobApp.Salary__c, HEAD_HOUSEHOLD_STD_DED);
                
                jobApp.Estimated_Federal_Taxes__c = 
                    WithholdingsCalculator.calculateTaxForHeadOfHouseholdFilingStatus(jobApp.Taxable_Income__c);
            }
        }

        calculateEffectiveTaxRate(jobApp);
    }

    private void calculateEffectiveTaxRate(Job_Application__c jobApp) {
        if(jobApp.Estimated_Federal_Taxes__c > 0) {
            jobApp.Effective_Tax_Rate__c = 
                (jobApp.Estimated_Federal_Taxes__c / jobApp.Taxable_Income__c) * 100;
        } else {
            jobApp.Effective_Tax_Rate__c = 0;
        }
    }

    private void calculateEstimatedTakeHomePay(Job_Application__c jobApp) {
        jobApp.Estimated_Take_Home_Pay__c = 
            jobApp.Salary__c -
            jobApp.Estimated_Federal_Taxes__c -
            jobApp.Estimated_Social_Security_Tax__c -
            jobApp.Estimated_Medicare_Tax__c;
    }
}