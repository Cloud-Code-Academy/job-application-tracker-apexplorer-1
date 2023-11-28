public with sharing class EventReminderEmailerScheduler implements Schedulable{

    public void execute(SchedulableContext context) {
       EventReminderEmailer emailer = new EventReminderEmailer();
       emailer.sendEventReminderEmails();
    }
}