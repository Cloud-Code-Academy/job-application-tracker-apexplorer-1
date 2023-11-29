import { LightningElement } from 'lwc';
import getJobs from '@salesforce/apex/JobFinderService.getJobs';
import createJobApplications from '@salesforce/apex/JobFinderService.createJobApplications';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { reduceErrors } from 'c/ldsUtils';

export default class JobFinder extends LightningElement {

    keywords = '';
    location = '';

	jobs;
	error;
    success;

    columns = [{
            label: 'Title',
            fieldName: 'title',
            type: 'text',
            sortable: true
        },
        {
            label: 'Company',
            fieldName: 'company',
            type: 'text',
            sortable: true
        },
        {
            label: 'Location',
            fieldName: 'location',
            type: 'text',
            sortable: true
        },
        {
            label: 'Salary',
            fieldName: 'salary',
            type: 'text',
            sortable: true
        },
        {
            label: 'Link',
            fieldName: 'link',
            type: 'url',
            sortable: true
        }
    ];

    findJobs() {
        if(this.keywords === '' && this.location === '') {
            alert('Please enter a job title, keyword or a location.');
        } else {
            getJobs({ keywords: this.keywords, location: this.location })
            .then(result => {

                if(result === null) {
                    alert('No results returned from Jooble API service!');
                }

                this.jobs = result;
                this.error = undefined;
            })
            .catch(error => {
                this.error = reduceErrors(error);
                this.showErrorToast();
            })
        }
    }

    handleChange(event) {
        const inputName = event.target.name;
        let value = event.target.value;
     
        if(inputName === 'keywords') {
            this.keywords = value;
        } else if(inputName === 'location') {
            this.location = value;
        }
    }

    createJobApplications() {
        var selectedJobs =  this.template.querySelector('lightning-datatable').getSelectedRows();

        if(selectedJobs.length > 0) {
            createJobApplications({ createJobs: selectedJobs })
                .then(result => {
                    this.success = 'Job Application created!';
                    this.showSuccessToast();
                })
                .catch(error => {
                    this.error = reduceErrors(error);
                    this.showErrorToast();
                })
        } else {
            alert('Please select a job posting to create a Job Application!');
        }
    }

    showSuccessToast() {
        const evt = new ShowToastEvent({
            title: 'Toast Success',
            message: this.success,
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }

    showErrorToast() {
        const evt = new ShowToastEvent({
            title: 'Toast Error',
            message: this.error.toString(),
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }
}