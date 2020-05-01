/******************************************************************
Class Name: ProjectTypeClassTest
Author: chaithanya daggumati       Last modified by: Janardhan reddy
Date : 19/7/2014                     Date :  20/03/2015                   
********©2013 Musqot marketing technology Pvt ltd ******************/

@isTest
public class ProjectTypeClassTest{
    static testMethod void projectType(){
        Project_type__c objprojtype = new Project_type__c();
        objprojtype.name = 'test';
        objprojtype.Color__c = 'red';
        System.assertEquals('test', objprojtype.name);
        insert objprojtype; 
        ApexPages.currentPage().getParameters().put('id', objprojtype.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objprojtype);
        test.startTest();
        ProjectTypeClass prty = new ProjectTypeClass(sc);     
        prty.NewPrtype();
        prty.NewPrtyp();
    }
}