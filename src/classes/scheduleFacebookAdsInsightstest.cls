/****************************************************************
Class Name: scheduleFacebookAdsInsightstest
Author:chaithanya daggumati                  Last modified by:chaithanya daggumati
Date: 27/10/2015                             Date: 27/10/2015
Description: class to schedule the social media data import.
********©2013 Musqot marketing technology Pvt ltd ****************/
@isTest
public class scheduleFacebookAdsInsightstest{
    static testMethod void schedulefbadsinsights() {
            Test.startTest();
            scheduleFacebookAdsInsights schedulefbads = new scheduleFacebookAdsInsights('');
                    String CRON_EXP = '0 0 0 1 1 ? 2025';  
                    String jobId = System.schedule('testScheduledApex', CRON_EXP, new scheduleFacebookAdsInsights(''));          
                    CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];          
                    System.assertEquals(CRON_EXP, ct.CronExpression); 
                    System.assertEquals(0, ct.TimesTriggered);
                    System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));
            Test.stopTest();
    }
}