trigger EventTrigger on Event (before insert, before update) {

    EventTriggerHandler handler = new EventTriggerHandler();

    switch on trigger.operationType {
        when BEFORE_INSERT {
            handler.handleBeforeInsert();
        }
        when BEFORE_UPDATE {
            handler.handleBeforeUpdate();
        }
    }
}