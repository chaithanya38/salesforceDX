/***********************************************************************
Class Name: ProjecttypeEditControllerTest
Author: chaithanya daggumati             Last modified by: janrdhan reddy
Date: 19/7/2014                          Date:  20/03/2015
********©2013 Musqot marketing technology Pvt ltd ***********************/

@isTest(seeAllData=true)
public class ProjecttypeEditControllerTest{
 static testMethod void projecttypeEdit(){
    Project_type__c objprojecttype = new Project_type__c();
    objprojecttype .Name = 'test';
    objprojecttype .Color__c = 'red';
    System.assertEquals('test', objprojecttype .name);
    insert objprojecttype ;
    
    //PageReference pageRef = page.ProjectType;
    //Test.setCurrentPage(ProjectType);
    ApexPages.currentPage().getParameters().put('id', objprojecttype .id);
    ApexPages.StandardController sc = new ApexPages.standardController(objprojecttype ); 
    ProjecttypeEditController objpro=new ProjecttypeEditController(sc);
    List<SelectOption> selOpts=objpro.Fieldsetlist;
    List<SelectOption> temppltype =objpro.planTypeOptions;
    objpro.Save();
    objpro.Cancel();
    objpro.Val='pltype';
 }
}