/*******************************************************************
Class Name: NewworktypeClassTest
Author:Chaithanya daggumati        Last modified by: Janardhan reddy
Date:22/7/2014                     Date: 19/3/2015                     
********©2013 Musqot marketing technology Pvt ltd *****************/

@isTest
    public class NewworktypeClassTest{
        static testMethod void Newworktype(){
        worktype__c objnwtype = new worktype__c();
        objnwtype.name = 'testrec';
        System.assertEquals('testrec', objnwtype.name);
        insert objnwtype; 
        ApexPages.currentPage().getParameters().put('id', objnwtype.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objnwtype);
        test.startTest();
        NewworktypeClass nwty = new NewworktypeClass(sc);     
        nwty .Newrec();
        nwty .Cancel(); 
        }
        }