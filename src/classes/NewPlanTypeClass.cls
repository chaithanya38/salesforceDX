/*******************************************************
Class Name: NewPlanTypeClass
Author:Nagaraju                   Last modified by: G Janardhanreddy
Date :22/7/2014                   Date : 19/3/2015                    
********©2013 Musqot marketing technology Pvt ltd *******/
public with sharing class NewPlanTypeClass {
    Public plantype__c plans{get;set;}
    public NewPlanTypeClass(ApexPages.StandardController controller) {
        plans=new plantype__c();
    }
    /***********************************************************
	save():create new plantypes and redirect to  MusqotAdminPage
	************************************************************/
    public Pagereference Save()
    {
        if (plantype__c.sObjectType.getDescribe().isCreateable())
        {
            insert plans;
        }
        Pagereference pg=new Pagereference ('/apex/MusqotAdminPage');
        return pg;
    }
    /************************************
	Cancel():Redirect to  MusqotAdminPage
	************************************/
    public Pagereference Cancel()
    {
        Pagereference pg=new Pagereference ('/apex/MusqotAdminPage');
        return pg;
    }
}