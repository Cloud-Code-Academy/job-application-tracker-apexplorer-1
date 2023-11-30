public with sharing class EventTriggerHandler {

    EventHelper helper;

    public EventTriggerHandler() {
        this.helper = new EventHelper(
            (List<Event>) Trigger.new,
            (Map<Id,Event>) Trigger.newMap,
            (Map<Id,Event>) Trigger.oldMap
        );
    }
    
    public void handleBeforeInsert() {
        helper.createEvents();
    }

    public void handleBeforeUpdate() {
        helper.updateEvents();
    }
}