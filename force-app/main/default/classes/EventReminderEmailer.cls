public with sharing class EventReminderEmailer {

	public void sendEventReminderEmails() {
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();

        List<Event> scheduledEvents = [SELECT Id, StartDateTime, Event.Who.Name FROM Event];
        List<User> user = [SELECT Email FROM User WHERE Id = '005Ho000009zExUIAU'];

        for(Event event : scheduledEvents) {
            if(event.StartDateTime.addDays(-1).day() == Datetime.now().day()) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] sendTo = new String[]{String.valueOf(user[0].Email)};

                mail.setToAddresses(sendTo);
                mail.setSubject('Upcoming Interview!');
                mail.setPlainTextBody(
                    'Get ready to rock your interview tomorrow! \n\n' +
                    'You have an interview scheduled with ' 
                        + event.Who.Name + ' @ ' 
                        + event.StartDateTime.format('h:mm a') + '. \n\n' +
                    'All the best!'
                );

                emailsToSend.add(mail);
            }
        }

        Messaging.SendEmailResult[] results = Messaging.sendEmail(emailsToSend);

        inspectResults(results);
    }

    private void inspectResults(Messaging.SendEmailResult[] results) {

        for (Messaging.SendEmailResult result : results) {
            if (result.isSuccess()) {
                System.debug('Email sent successfully');
            }
            else {
                System.debug('The following errors occurred: ' + result.getErrors());                 
            }
        }
    }
}