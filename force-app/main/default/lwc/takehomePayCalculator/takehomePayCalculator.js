import { LightningElement, api, track, wire } from 'lwc';
import getJobApp from'@salesforce/apex/TakeHomePayCalculatorService.getJobApp';
import estimateTakeHomePay from'@salesforce/apex/TakeHomePayCalculatorService.estimateTakeHomePay';

export default class TakehomePayCalculator extends LightningElement {
    @api recordId;

    salary;
    filingStatus;
    
    taxableIncome;
    federalTax;
    socialSecurityTax;
    medicareTax;
    takeHomePay;
    monthly;
    biWeekly;

    displayCalculation = false;

    get options() {
        return [
            { label: 'Single', value: 'Single' },
            { label: 'Married, Filing Jointly', value: 'Married, Filing Jointly' },
            { label: 'Married, Filing Separately', value: 'Married, Filing Separately' },
            { label: 'Head of Household', value: 'Head of Household' }
        ];
    }

    @wire(getJobApp, { jobAppId: '$recordId' })
    wiredJobApp({data, error}) {
        console.log('jobApp data ' + data);
		if(data) {
			this.salary = data.Salary__c;
            this.filingStatus = data.Tax_Filing_Status__c;
			this.error = undefined;
		}else {
			this.salary = undefined;
			this.error = error;
		}
	}

    handleChange(event) {
        const inputName = event.target.name;
        let value = event.target.value;     

        if(inputName === 'salary') {
            this.salary = value;
            console.log('salary value ' + this.salary);
        } else if(inputName === 'filingStatus') {
            this.filingStatus = value;
            console.log('filing status' + this.filingStatus);
        }
    }

    calculateTakeHomePay() {
        if(this.salary > 0) {
            estimateTakeHomePay({ salary: this.salary, filingStatus: this.filingStatus })
                .then(result => {
                    this.taxableIncome = result['taxableIncome'];
                    this.federalTax = result['federalTax'];
                    this.socialSecurityTax = result['socialSecurityTax'];
                    this.medicareTax = result['medicareTax'];
                    this.takeHomePay = result['takeHomePay'];
                    this.monthly = result['monthly'];
                    this.biWeekly = result['biWeekly'];
                    this.error = undefined;

                    this.displayCalculation = true;
                })
                .catch(error => {
                    this.error = error;
                })
        } else {
            console.log('negative salary ' + this.salary);
            alert('Salary must be greater than 0.');
        }
    }
}