/****************************************************************
Class Name: scheduleFacebookAdsInsights
Author:Arun Prasad                  Last modified by:Arun Prasad
Date: 08/01/2015                 Date: 08/01/2015
Description: class to schedule the social media data import.
********©2013 Musqot marketing technology Pvt ltd ****************/
 
global class scheduleFacebookAdsInsights implements Schedulable {
    global String connId;
    global void execute(SchedulableContext sc){
        Socialmedia_connection_Ctrl.queryfacebookAdsInsights(connId);
    }
    
    public scheduleFacebookAdsInsights (String aconnId) {
        connId = aconnId;
    }
}