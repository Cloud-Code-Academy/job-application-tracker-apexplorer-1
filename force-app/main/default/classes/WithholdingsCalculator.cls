public with sharing class WithholdingsCalculator {

    final static Decimal TAX_RATE_10 = .10;
    final static Decimal TAX_RATE_12 = .12;
    final static Decimal TAX_RATE_22 = .22;
    final static Decimal TAX_RATE_24 = .24;
    final static Decimal TAX_RATE_32 = .32;
    final static Decimal TAX_RATE_35 = .35;
    final static Decimal TAX_RATE_37 = .37;

    public static Decimal calculateEstimatedSocialSecurityTax(Decimal salary) {
        Decimal socialSecurityTax = 0;

        if(salary > 160200) {
            socialSecurityTax = 160200 * .062;
        } else {
            socialSecurityTax = salary * .062;
        }
        
        return Math.floor(socialSecurityTax);
    }

    public static Decimal calculateEstimatedMedicareTax(Decimal salary) {
        return Math.floor(salary * .0145);
    }
    
    
    public static Decimal calculateTaxableIncome(Decimal salary, Decimal deduction) {
        Decimal taxableIncome = 0;

        if(salary > deduction) {
            taxableIncome = salary - deduction;
        }

        return Math.floor(taxableIncome);
    }
    
    public static Decimal calculateTaxForSingleFilingStatus(Decimal taxableIncome) {
        Decimal federalTaxes = 0;

        if(taxableIncome >= 578126) {
            federalTaxes = 
                174238.25 + ((taxableIncome - 578125) * TAX_RATE_37);
        } else if(taxableIncome >= 231251) {
            federalTaxes = 
                52832 + ((taxableIncome - 231250) * TAX_RATE_35);
        } else if(taxableIncome >= 182101) {
            federalTaxes = 
                37104 + ((taxableIncome - 182100) * TAX_RATE_32);
        } else if(taxableIncome >= 95376) {
            federalTaxes = 
                16290 + ((taxableIncome - 95375) * TAX_RATE_24);
        } else if(taxableIncome >= 44726) {
            federalTaxes = 
                5147 + ((taxableIncome - 44725) * TAX_RATE_22);
        } else if(taxableIncome >= 11001) {
            federalTaxes = 
                1100 + ((taxableIncome - 11000) * TAX_RATE_12);
        } else {
            federalTaxes = 
                taxableIncome * TAX_RATE_10;
        }

        return Math.floor(federalTaxes);
    }

    public static Decimal calculateTaxForMarriedJointlyFilingStatus(Decimal taxableIncome) {
        Decimal federalTaxes = 0;

        if(taxableIncome >= 693751) {
            federalTaxes = 
                186601.50 + ((taxableIncome - 693750) * TAX_RATE_37);
        } else if(taxableIncome >= 462501) {
            federalTaxes = 
                105664 + ((taxableIncome - 462500) * TAX_RATE_35);
        } else if(taxableIncome >= 364201) {
            federalTaxes = 
                74208 + ((taxableIncome - 364200) * TAX_RATE_32);
        } else if(taxableIncome >= 190751) {
            federalTaxes = 
                32580 + ((taxableIncome - 190750) * TAX_RATE_24);
        } else if(taxableIncome >= 89451) {
            federalTaxes = 
                10294 + ((taxableIncome - 89450) * TAX_RATE_22);
        } else if(taxableIncome >= 22001) {
            federalTaxes = 
                2200 + ((taxableIncome - 22000) * TAX_RATE_12);
        } else {
            federalTaxes = 
                taxableIncome * TAX_RATE_10;
        }

        return Math.floor(federalTaxes);
    }

    public static Decimal calculateTaxForMarriedSeparatelyFilingStatus(Decimal taxableIncome) {
        Decimal federalTaxes = 0;

        if(taxableIncome >= 346876) {
            federalTaxes = 
                93300.75 + ((taxableIncome - 346875) * TAX_RATE_37);
        } else if(taxableIncome >= 231251) {
            federalTaxes = 
                52832 + ((taxableIncome - 231250) * TAX_RATE_35);
        } else if(taxableIncome >= 182101) {
            federalTaxes = 
                37104 + ((taxableIncome - 182100) * TAX_RATE_32);
        } else if(taxableIncome >= 95376) {
            federalTaxes = 
                16290 + ((taxableIncome - 95375) * TAX_RATE_24);
        } else if(taxableIncome >= 44726) {
            federalTaxes = 
                5147 + ((taxableIncome - 44725) * TAX_RATE_22);
        } else if(taxableIncome >= 11001) {
            federalTaxes = 
                1100 + ((taxableIncome - 11000) * TAX_RATE_12);
        } else {
            federalTaxes = 
                taxableIncome * TAX_RATE_10;
        }

        return Math.floor(federalTaxes);
    }

    public static Decimal calculateTaxForHeadOfHouseholdFilingStatus(Decimal taxableIncome) {
        Decimal federalTaxes = 0;
        
        if(taxableIncome >= 578101) {
            federalTaxes = 
                172623.50 + ((taxableIncome - 578100) * TAX_RATE_37);
        } else if(taxableIncome >= 231251) {
            federalTaxes = 
                51226 + ((taxableIncome - 231250) * TAX_RATE_35);
        } else if(taxableIncome >= 182101) {
            federalTaxes = 
                35498 + ((taxableIncome - 182100) * TAX_RATE_32);
        } else if(taxableIncome >= 95351) {
            federalTaxes = 
                14678 + ((taxableIncome - 95350) * TAX_RATE_24);
        } else if(taxableIncome >= 59851) {
            federalTaxes = 
                6868 + ((taxableIncome - 59850) * TAX_RATE_22);
        } else if(taxableIncome >= 15701) {
            federalTaxes = 
                1570 + ((taxableIncome - 15700) * TAX_RATE_12);
        } else {
            federalTaxes = 
                taxableIncome * TAX_RATE_10;
        }

        return Math.floor(federalTaxes);
    }
}