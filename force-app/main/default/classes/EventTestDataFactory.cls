@IsTest
public with sharing class EventTestDataFactory {

    public static void createEvents() {
        List<Event> events = new List<Event>();

        events.add(
            new Event(
                Subject = 'Salesforce Admin Interview',
                StartDateTime = Datetime.newInstance(2023, 11, 21, 10, 00, 00),
                EndDateTime = Datetime.newInstance(2023, 11, 21, 10, 45, 00)
            )
        );

        events.add(
            new Event(
                Subject = 'Senior Salesforce Engineer Interview',
                StartDateTime = Datetime.newInstance(2024, 11, 28, 11, 00, 00),
                EndDateTime = Datetime.newInstance(2024, 11, 28, 11, 45, 00)
            )
        );

        events.add(
            new Event(
                Subject = 'Salesforce Developer Interview',
                StartDateTime = Datetime.newInstance(2024, 11, 28, 14, 00, 00),
                EndDateTime = Datetime.newInstance(2024, 11, 28, 15, 45, 00)
            )
        );

        insert events;
    }

    public static void createEventsForEmailer() {

        Contact contact = 
            new Contact(
                LastName = 'Belcher',
                FirstName = 'Bob'
            );

        insert contact;

        List<Event> events = new List<Event>();

        events.add(
            new Event(
                Subject = 'Senior Salesforce Admin Interview',
                WhoId = contact.Id,
                StartDateTime = Datetime.now().addDays(1),
                EndDateTime = Datetime.now().addDays(1).addHours(1)
            )
        );

        events.add(
            new Event(
                Subject = 'Salesforce Developer Interview',
                WhoId = contact.Id,
                StartDateTime = Datetime.now().addDays(1).addHours(4),
                EndDateTime = Datetime.now().addDays(1).addHours(5)
            )
        );

        insert events;
    }
}