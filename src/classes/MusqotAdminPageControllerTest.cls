/*************************************************************
Class Name: MusqotAdminPageControllerTest
Author:Nagaraju          Last modified by: chaithanya daggumati
Date :23/7/2014          Date : 19/3/2015                    
********©2013 Musqot marketing technology Pvt ltd ************/
@isTest(seeALLData=true)
public class MusqotAdminPageControllerTest{
 static testMethod void MusqotAdminPageControlleretMethod(){
 Project_type__c objProjecttype=new Project_type__c();
 objProjecttype.Name='test';
 objProjecttype.Color__c='red';
 System.assertEquals('test', objProjecttype.name);
 insert objProjecttype;
 Post_Install__c pi = new Post_Install__c();
 pi.name = 'Approval';
 pi.Is_Approval_Crated__c = true;
 insert pi;
  ApexPages.CurrentPage().getparameters().put('Id', objProjecttype.id); 
 ApexPages.StandardController sc = new ApexPages.standardController(objProjecttype);
 test.startTest();
 MusqotAdminPageController objMusqotAdmin= new MusqotAdminPageController();
 objMusqotAdmin.showRecords();
 objMusqotAdmin.showRecords();
 objMusqotAdmin.getObjNames();
 objMusqotAdmin.getObj();
 objMusqotAdmin.setTabInFocus('String s' );
 
 try{
 objMusqotAdmin.getTabInFocus();
 }catch(exception e){}
 objMusqotAdmin.redirectToMusqotFiscalYearPage();
 test.stopTest();
         } 
    }