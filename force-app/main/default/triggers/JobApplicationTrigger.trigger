trigger JobApplicationTrigger on Job_Application__c (before insert, 
                                                     before update,
                                                     after insert) {

    JobApplicationTriggerHandler handler = new JobApplicationTriggerHandler();

    switch on trigger.operationType {
        when BEFORE_INSERT {
            handler.handleBeforeInsert();
        }
        when AFTER_INSERT {
            handler.handleAfterInsert();
        }
        when BEFORE_UPDATE {
            handler.handleBeforeUpdate();
        }
    }
}