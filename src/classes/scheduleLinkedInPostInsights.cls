/****************************************************************
Class Name: scheduleLinkedInPageInsights
Author:Arun Prasad                  Last modified by:Arun Prasad
Date: 08/01/2015                 Date: 08/01/2015
Description: class to schedule the social media data import.
********©2013 Musqot marketing technology Pvt ltd ****************/
 
global class scheduleLinkedInPostInsights implements Schedulable {
    global void execute(SchedulableContext sc){
        Socialmedia_connection_Ctrl.querylinkedinPostInsights();
    }
}