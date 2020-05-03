/*******************************************************
Class Name: WorktypeClass 
Author:Chaithanya daggumati     Last modified by: G Janardhanreddy
Date: 6/7/2014                 Date: 19/3/2015
********©2013 Musqot marketing technology Pvt ltd *******/

public with sharing class WorktypeClass {
    Public List<worktype__c> worktype{get;set;}
    public WorktypeClass(ApexPages.StandardController controller) {
        worktype =[SELECT id,Name from worktype__C Limit 200];
    }
    /*****************************************
	NewRec(): redirect to NewWorktasktype page
	******************************************/
    public Pagereference NewRec()
    {
        Pagereference pg=new Pagereference ('/apex/NewWorktasktype');
        return pg;
    }
}