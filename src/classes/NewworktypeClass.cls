/******************************************************************
Class Name: NewworktypeClass
Author:chaithanya daggumati      Last modified by: G Janardhanreddy
Date: 16/7/2014                  Date:24/03/2015  
********©2013 Musqot marketing technology Pvt ltd *****************/
public with sharing class NewworktypeClass {
    Public worktype__c Newworktype{get;set;}
    public NewworktypeClass(ApexPages.StandardController controller) {
        Newworktype=new worktype__c();
    }
    /*************************************************************************
	Newrec():create new worktype__c records and redirect to  Worktasktype page
	**************************************************************************/
    Public Pagereference  Newrec()
    {
        if (worktype__c.sObjectType.getDescribe().isCreateable())
        {
            insert Newworktype;
        }
        Pagereference  pgn=new Pagereference ('/apex/Worktasktype');
        return pgn;
    }
        Public Pagereference  Cancel()//redirect to  Worktasktype page
    {
        Pagereference  pgc=new Pagereference ('/apex/Worktasktype');
        return pgc;
    }
}