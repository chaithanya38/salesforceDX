/*****************************************************************
Class Name: PopulateClassTest 
Author:Chaithanya daggumati      Last modified by: Janardhan reddy
Date:21/7/2014                   Date:  20/03/2015                                                  
********©2013 Musqot marketing technology Pvt ltd ****************/
@isTest
    public class PopulateClassTest {
        static testMethod void PopulateClass(){
        Subproject__c sp = New Subproject__c();
        sp .name = 'test';
        System.assertEquals('test', sp .name);
        insert sp ;         
        ApexPages.currentPage().getParameters().put('id', sp .id);
        ApexPages.StandardController sc = new ApexPages.standardController(sp );
        test.startTest();
        PopulateClass pcls = new PopulateClass(sc);        
        pcls.onLoad();  
         test.stopTest();        
          }
        }