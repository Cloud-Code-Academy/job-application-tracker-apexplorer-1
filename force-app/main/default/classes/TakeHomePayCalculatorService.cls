public with sharing class TakeHomePayCalculatorService {

    public static Map<String,Decimal> takeHomePayCalculations = new Map<String,Decimal>();

    final static Decimal SINGLE_MARRIED_SEPARATELY_STD_DED = 13850;
    final static Decimal MARRIED_JOINTLY_STD_DED = 27700;
    final static Decimal HEAD_HOUSEHOLD_STD_DED = 20800;

    @AuraEnabled(cacheable=true)
    public static Job_Application__c getJobApp(String jobAppId) {
        return [SELECT Id, Salary__c, Tax_Filing_Status__c FROM Job_Application__c WHERE Id = :jobAppId];
    }

    @AuraEnabled
    public static Map<String,Decimal> estimateTakeHomePay(Decimal salary, String filingStatus) {
        
        calculateEstimatedFederalTaxes(salary, filingStatus);

        takeHomePayCalculations.put(
            'socialSecurityTax', 
            WithholdingsCalculator.calculateEstimatedSocialSecurityTax(salary)
        );
        
        takeHomePayCalculations.put(
            'medicareTax', 
            WithholdingsCalculator.calculateEstimatedMedicareTax(salary)
        );

        calculateEstimatedTakeHomePay(salary);

        return takeHomePayCalculations;
    }

    private static void calculateEstimatedFederalTaxes(Decimal salary, String filingStatus) {

        switch on filingStatus {
            when 'Single' {
                takeHomePayCalculations.put(
                    'taxableIncome',
                    WithholdingsCalculator.calculateTaxableIncome(salary, SINGLE_MARRIED_SEPARATELY_STD_DED));

                takeHomePayCalculations.put(
                    'federalTax', 
                    WithholdingsCalculator.calculateTaxForSingleFilingStatus(takeHomePayCalculations.get('taxableIncome'))
                );
            }
            when 'Married, Filing Jointly' {
                takeHomePayCalculations.put(
                    'taxableIncome',
                    WithholdingsCalculator.calculateTaxableIncome(salary, MARRIED_JOINTLY_STD_DED));

                takeHomePayCalculations.put(
                    'federalTax', 
                    WithholdingsCalculator.calculateTaxForMarriedJointlyFilingStatus(takeHomePayCalculations.get('taxableIncome'))
                );
            }
            when 'Married, Filing Separately' {
                takeHomePayCalculations.put(
                    'taxableIncome',
                    WithholdingsCalculator.calculateTaxableIncome(salary, SINGLE_MARRIED_SEPARATELY_STD_DED));

                takeHomePayCalculations.put(
                    'federalTax', 
                    WithholdingsCalculator.calculateTaxForMarriedSeparatelyFilingStatus(takeHomePayCalculations.get('taxableIncome'))
                );
            }
            when 'Head of Household' {
                takeHomePayCalculations.put(
                    'taxableIncome',
                    WithholdingsCalculator.calculateTaxableIncome(salary, HEAD_HOUSEHOLD_STD_DED));
                    
                takeHomePayCalculations.put(
                    'federalTax', 
                    WithholdingsCalculator.calculateTaxForHeadOfHouseholdFilingStatus(takeHomePayCalculations.get('taxableIncome'))
                );
            }
        }
    }

    private static void calculateEstimatedTakeHomePay(Decimal salary) {
        Decimal takeHomePay = 
            salary -
            takeHomePayCalculations.get('federalTax') -
            takeHomePayCalculations.get('socialSecurityTax') -
            takeHomePayCalculations.get('medicareTax');

        takeHomePayCalculations.put('takeHomePay', takeHomePay);

        takeHomePayCalculations.put('monthly', Math.floor(takeHomePay / 12));
        takeHomePayCalculations.put('biWeekly', Math.floor(takeHomePay / 24));
    }
}