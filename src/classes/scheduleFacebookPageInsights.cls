/****************************************************************
Class Name: scheduleFacebookPageInsights
Author:Arun Prasad                  Last modified by:Arun Prasad
Date: 08/01/2015                 Date: 08/01/2015
Description: class to schedule the social media data import.
********©2013 Musqot marketing technology Pvt ltd ****************/
 
global class scheduleFacebookPageInsights implements Schedulable {
    global String connId;
    global void execute(SchedulableContext sc){
        Socialmedia_connection_Ctrl.querySocialMediaPageInsights(connId);
    }
    
    public scheduleFacebookPageInsights (String aconnId) {
        connId = aconnId;
    }
}