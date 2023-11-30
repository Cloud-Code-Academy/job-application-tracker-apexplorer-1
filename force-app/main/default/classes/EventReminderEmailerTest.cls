@isTest
public with sharing class EventReminderEmailerTest {

    @isTest
    static void testEventReminderEmailer() {

        if(!Datetime.now().format('EEEE').equalsIgnoreCase('SATURDAY')
            || !Datetime.now().format('EEEE').equalsIgnoreCase('SUNDAY')) {
            
            EventTestDataFactory.createEventsForEmailer();

            Test.startTest();
    
            EventReminderEmailerScheduler scheduler = new EventReminderEmailerScheduler();
            scheduler.execute(null);
    
            Assert.areEqual(1, Limits.getEmailInvocations());
    
            Test.stopTest();
        }        
    }
}