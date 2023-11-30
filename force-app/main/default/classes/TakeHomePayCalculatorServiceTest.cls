@isTest
public with sharing class TakeHomePayCalculatorServiceTest {

    @isTest
    static void testEstimateTakeHomePay_SingleFilingStatus() {

        Map<String, Decimal> taxRate10 = TakeHomePayCalculatorService.estimateTakeHomePay(10700, 'Single');

        Assert.isTrue(!taxRate10.isEmpty());
        Assert.areEqual(0, taxRate10.get('taxableIncome'));
        Assert.areEqual(0, taxRate10.get('federalTax'));

        Map<String, Decimal> taxRate12 = TakeHomePayCalculatorService.estimateTakeHomePay(38600, 'Single');

        Assert.isTrue(!taxRate12.isEmpty());
        Assert.areEqual(24750, taxRate12.get('taxableIncome'));
        Assert.areEqual(2393, taxRate12.get('socialSecurityTax'));

        Map<String, Decimal> taxRate22 = TakeHomePayCalculatorService.estimateTakeHomePay(89432, 'Single');

        Assert.isTrue(!taxRate22.isEmpty());
        Assert.areEqual(75582, taxRate22.get('taxableIncome'));
        Assert.areEqual(70657, taxRate22.get('takeHomePay'));

        Map<String, Decimal> taxRate24 = TakeHomePayCalculatorService.estimateTakeHomePay(155870, 'Single');

        Assert.isTrue(!taxRate24.isEmpty());
        Assert.areEqual(142020, taxRate24.get('taxableIncome'));
        Assert.areEqual(9705, taxRate24.get('monthly'));
    }

    @isTest
    static void testEstimateTakeHomePay_MarriedJointlyFilingStatus() {

        Map<String, Decimal> taxRate37 = TakeHomePayCalculatorService.estimateTakeHomePay(724400, 'Married, Filing Jointly');

        Assert.isTrue(!taxRate37.isEmpty());
        Assert.areEqual(696700, taxRate37.get('taxableIncome'));
        Assert.areEqual(10503, taxRate37.get('medicareTax'));

        Map<String, Decimal> taxRate24 = TakeHomePayCalculatorService.estimateTakeHomePay(222500, 'Married, Filing Jointly');

        Assert.isTrue(!taxRate24.isEmpty());
        Assert.areEqual(194800, taxRate24.get('taxableIncome'));
        Assert.areEqual(14649, taxRate24.get('monthly'));

        Map<String, Decimal> taxRate12 = TakeHomePayCalculatorService.estimateTakeHomePay(51500, 'Married, Filing Jointly');

        Assert.isTrue(!taxRate12.isEmpty());
        Assert.areEqual(23800, taxRate12.get('taxableIncome'));
        Assert.areEqual(2416, taxRate12.get('federalTax'));
    }

    @isTest
    static void testEstimateTakeHomePay_MarriedSeparatelyFilingStatus() {

        Map<String, Decimal> taxRate35 = TakeHomePayCalculatorService.estimateTakeHomePay(267200, 'Married, Filing Separately');

        Assert.isTrue(!taxRate35.isEmpty());
        Assert.areEqual(253350, taxRate35.get('taxableIncome'));
        Assert.areEqual(9932, taxRate35.get('socialSecurityTax'));

        Map<String, Decimal> taxRate32 = TakeHomePayCalculatorService.estimateTakeHomePay(212540, 'Married, Filing Separately');

        Assert.isTrue(!taxRate32.isEmpty());
        Assert.areEqual(198690, taxRate32.get('taxableIncome'));
        Assert.areEqual(6546, taxRate32.get('biWeekly'));

        Map<String, Decimal> taxRate10 = TakeHomePayCalculatorService.estimateTakeHomePay(12000, 'Married, Filing Separately');

        Assert.isTrue(!taxRate10.isEmpty());
        Assert.areEqual(0, taxRate10.get('taxableIncome'));
        Assert.areEqual(174, taxRate10.get('medicareTax'));

        Map<String, Decimal> taxRate12 = TakeHomePayCalculatorService.estimateTakeHomePay(39450, 'Married, Filing Separately');

        Assert.isTrue(!taxRate12.isEmpty());
        Assert.areEqual(25600, taxRate12.get('taxableIncome'));
        Assert.areEqual(1399, taxRate12.get('biWeekly'));
    }

    @isTest
    static void testEstimateTakeHomePay_HeadOfHouseholdFilingStatus() {

        Map<String, Decimal> taxRate37 = TakeHomePayCalculatorService.estimateTakeHomePay(598901, 'Head of Household');

        Assert.isTrue(!taxRate37.isEmpty());
        Assert.areEqual(578101, taxRate37.get('taxableIncome'));
        Assert.areEqual(172623, taxRate37.get('federalTax'));

        Map<String, Decimal> taxRate35 = TakeHomePayCalculatorService.estimateTakeHomePay(347324, 'Head of Household');

        Assert.isTrue(!taxRate35.isEmpty());
        Assert.areEqual(326524, taxRate35.get('taxableIncome'));
        Assert.areEqual(9932, taxRate35.get('socialSecurityTax'));

        Map<String, Decimal> taxRate22 = TakeHomePayCalculatorService.estimateTakeHomePay(80651, 'Head of Household');

        Assert.isTrue(!taxRate22.isEmpty());
        Assert.areEqual(59851, taxRate22.get('taxableIncome'));
        Assert.areEqual(67614, taxRate22.get('takeHomePay'));
    }
}