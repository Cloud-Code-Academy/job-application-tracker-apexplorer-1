@isTest
public with sharing class EventHelperTest {

    @isTest
    static void testCalendarValidation_NoOverlap() {
        EventTestDataFactory.createEvents();

        Event event = 
            new Event(
                Subject = 'Salesforce Admin/Developer Interview',
                StartDateTime = Datetime.newInstance(2023, 11, 24, 11, 00, 00),
                EndDateTime = Datetime.newInstance(2023, 11, 24, 12, 45, 00)
            );

        Test.startTest();

        insert event;

        Test.stopTest();

        List<Event> events = [SELECT Id FROM Event];

        Assert.areEqual(4, events.size());
    }

    @isTest
    static void testCalendarValidation_SameStartAndEndTime() {
        EventTestDataFactory.createEvents();

        Event event = 
            new Event(
                Subject = 'Salesforce Developer Interview',
                StartDateTime = Datetime.newInstance(2023, 11, 21, 10, 00, 00),
                EndDateTime = Datetime.newInstance(2023, 11, 21, 10, 45, 00)
            );

        Test.startTest();

        Database.SaveResult result = Database.insert(event, false);

        Test.stopTest();

        Assert.isTrue(!result.isSuccess());
        Assert.isTrue(result.getErrors().size() > 0);
        Assert.areEqual('Interview currently scheduled during this time.',
                             result.getErrors()[0].getMessage());
    }

    @isTest
    static void testCalendarValidation_OverlapStartAndEndTime() {
        EventTestDataFactory.createEvents();

        Event event = 
            new Event(
                Subject = 'Salesforce Developer Interview',
                StartDateTime = Datetime.newInstance(2023, 11, 21, 09, 00, 00),
                EndDateTime = Datetime.newInstance(2023, 11, 21, 11, 45, 00)
            );

        Test.startTest();

        Database.SaveResult result = Database.insert(event, false);

        Test.stopTest();

        Assert.isTrue(!result.isSuccess());
        Assert.isTrue(result.getErrors().size() > 0);
        Assert.areEqual('Interview currently scheduled during this time.',
                             result.getErrors()[0].getMessage());
    }

    @isTest
    static void testCalendarValidation_SaturdayEvent() {

        Event saturdayEvent = 
        new Event(
            Subject = 'Senior Salesforce Admin Interview',
            StartDateTime = Datetime.newInstance(2023, 11, 25, 10, 00, 00),
            EndDateTime = Datetime.newInstance(2023, 11, 25, 11, 00, 00)
        );
    
        Test.startTest();

        Database.SaveResult result = 
            Database.insert(saturdayEvent, false);

        Test.stopTest();

        Assert.isTrue(!result.isSuccess());
        Assert.isTrue(result.getErrors().size() > 0);
        Assert.areEqual('Weekends are for relaxation, not meetings!',
                             result.getErrors()[0].getMessage());
    }

    @isTest
    static void testCalendarValidation_SundayEvent() {
        List<Event> sundayEvents = new List<Event>();
        EventTestDataFactory.createEvents();

        Test.startTest();

        List<Event> scheduledEvents = [SELECT Id, StartDateTime FROM Event];

        for(Event event : scheduledEvents) {
            event.StartDateTime = Datetime.newInstance(2023, 12, 02, 10, 00, 00);
            event.EndDateTime = Datetime.newInstance(2023, 12, 02, 11, 00, 00);
            SundayEvents.add(event);
        }

        Database.SaveResult[] results = Database.update(SundayEvents, false);

        Test.stopTest();

        Assert.isTrue(!results[0].isSuccess());
        Assert.isTrue(results[0].getErrors().size() > 0);
        Assert.areEqual('Weekends are for relaxation, not meetings!',
                             results[0].getErrors()[0].getMessage());
    }
}