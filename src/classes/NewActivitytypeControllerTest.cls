/****************************************************************
Class Name: NewActivitytypeControllerTest
Author:Chaithanya daggumati     Last modified by: Janardhan reddy
Date:22/7/2014                  Date:19/3/2015                    
********©2013 Musqot marketing technology Pvt ltd ***************/
@isTest
public class NewActivitytypeControllerTest{
    static testMethod void NewActivitytype(){
        plantype__c objact = new  plantype__c ();
        objact.name = 'test';
        objact.Barcolor__c = 'red';
        System.assertEquals('test', objact.name);
        ApexPages.currentPage().getParameters().put('id', objact.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objact);
        test.startTest();
        NewActivitytypeController objactivity= new NewActivitytypeController(sc); 
        List<SelectOption> selOpts = objactivity.Fieldsetlist;
        objactivity.newact = objact;  
        objactivity.Newrec();
        objactivity.Cancel();
    }
}