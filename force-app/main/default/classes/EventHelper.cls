public with sharing class EventHelper {

    List<Event> events;
    Map<Id,Event> eventsMap;
    Map<Id,Event> oldEventsMap;

    List<Event> scheduledEvents;

    public EventHelper(
        List<Event> events,
        Map<Id,Event> eventsMap,
        Map<Id,Event> oldEventsMap) {

        this.events = events;
        this.eventsMap = eventsMap;
        this.oldEventsMap = oldEventsMap;
    }

    public void createEvents() {

        scheduledEvents = [SELECT Id, StartDateTime, EndDateTime FROM Event];

        for(Event event : events) {
            calendarValidation(event, scheduledEvents);
        }
    }

    public void updateEvents() {

        scheduledEvents = [SELECT Id, StartDateTime, EndDateTime FROM Event];

        for(Event event : eventsMap.values()) {
            if(oldEventsMap.containsKey(event.Id)) {
                Event oldEvent = oldEventsMap.get(event.Id);

                if(event.StartDateTime != oldEvent.StartDateTime
                    && event.EndDateTime != oldEvent.EndDateTime) {
                    
                    calendarValidation(event, scheduledEvents);
                }
            }
        }

    }

    public void calendarValidation(Event event, List<Event> scheduledEvents) {

        if(event.StartDateTime.format('EEEE').equalsIgnoreCase('SATURDAY')
            || event.StartDateTime.format('EEEE').equalsIgnoreCase('SUNDAY')) {
        
            Event.addError('Weekends are for relaxation, not meetings!');
        }

        for(Event scheduledEvent : scheduledEvents) {
            Long eventStartTime = event.StartDateTime.getTime();
            Long eventEndTime = event.EndDateTime.getTime();
            Long scheduledEventStartTime = scheduledEvent.StartDateTime.getTime();
            Long scheduledEventEndTime = scheduledEvent.EndDateTime.getTime();

            if(((eventStartTime >= scheduledEventStartTime 
                    && eventStartTime < scheduledEventEndTime)
                || (eventEndTime > scheduledEventStartTime
                        && eventEndTime < scheduledEventEndTime))
                || (scheduledEventStartTime >= eventStartTime
                        && scheduledEventStartTime < eventEndTime)) {

                Event.addError('Interview currently scheduled during this time.');
            }
        }
    }
}