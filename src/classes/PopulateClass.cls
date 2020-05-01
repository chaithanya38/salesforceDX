/***********************************************************
Class Name: PopulateClass
Author:Nagaraju           Last modified by:G Janardhan reddy
Date :18/7/2014           Date : 20/03/2015                    
********©2013 Musqot marketing technology Pvt ltd **********/
public with sharing class PopulateClass {
    Subproject__c NewSub=New Subproject__c();
    Id Pageid;
    public PopulateClass(ApexPages.StandardController controller) {
        try
        {
            NewSub= (Subproject__c)controller.getRecord();
            Pageid=NewSub.Parent_project__c;
            Project__c sid=[Select id,Name from Project__c where id =:Pageid];
        }
        Catch(Exception e)
        {
        }
    }
    Public PageReference onLoad()
    {
              return null;
    }
}