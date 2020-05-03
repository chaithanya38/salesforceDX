/****************************************************************
Class Name: scheduleFacebookInsights
Author:Hussain                  Last modified by:Hussain
Date: 5/20/2015                 Date: 5/20/2015
Description: class to schedule the social media data import.
********©2013 Musqot marketing technology Pvt ltd ****************/
 
global class scheduleFacebookInsights implements Schedulable {
    global void execute(SchedulableContext sc){
        Socialmedia_connection_Ctrl.querySocialMediaInsights();
    }
}