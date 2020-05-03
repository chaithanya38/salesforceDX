/****************************************************************
Class Name: scheduleFacebookAdInsightstest
Author:chaithanya daggumati                  Last modified by:chaithanya daggumati
Date: 19/10/2015                             Date: 19/10/2015
Description: class to schedule the social media data import.
********©2013 Musqot marketing technology Pvt ltd ****************/
@isTest
private class scheduleFacebookAdInsightstest{
    static testMethod void schedulefbaddinsights() {
            Test.startTest();
                    String CRON_EXP = '0 0 0 1 1 ? 2025';  
                    String jobId = System.schedule('testScheduledApex', CRON_EXP, new scheduleFacebookAdInsights() );          
                    CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];          
                    System.assertEquals(CRON_EXP, ct.CronExpression); 
                    System.assertEquals(0, ct.TimesTriggered);
                    System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));
            Test.stopTest();
    }
}