/************************************************************
Class Name: ActivitycontrollerTest
Author: Nagaraju G         Last modified by:G Janardhanreddy 
Date  :  18/7/2014            Date:18/03/2015
**********©2013 Musqot marketing technology Pvt ltd **********/
@isTest(seeAllData=true)
public class ActivitycontrollerTest{
    static testMethod void myActivityTest(){         
    Activitytype__c objActivity = new Activitytype__c(); 
    objActivity.Name='test';
    objActivity.Icon__c='testicon';
    objActivity.Bar_color__c ='red';
    objActivity.F__c =Null;    
    System.assertEquals('test', objActivity.name);
    insert objActivity;
    
    ApexPages.currentPage().getParameters().put('id', objActivity.id);
    ApexPages.StandardController sc = new ApexPages.standardController(objActivity); 
    System.Dmlexception ex;
    test.startTest();
    Activitycontroller objact = new Activitycontroller(sc);
    ApexPages.Pagereference result = objact .save();
    List<SelectOption>  temp1=objact.Fieldsetlist;
    objact.selectActivityImage();
    objact.closePopUp();
    objact.showUplodePopUp();
    objact.showActivityImagPopUp();
    objact.getActivityImages();
    try{
    objact.Save();
    objact.Cancel();
    objact.createStaticResource(); 
    }catch(DmlException e) {
            ex = e;}
     objact.createStaticResource(); 
    }
    static testMethod void myActivityTest1(){         
    Activitytype__c objActivity = new Activitytype__c(); 
    objActivity.Name='test';
    objActivity.Icon__c='testicon';
    objActivity.Bar_color__c ='red';
    objActivity.F__c =Null;    
    System.assertEquals('test', objActivity.name);
    insert objActivity;
    
    ApexPages.currentPage().getParameters().put('id', objActivity.id);
    ApexPages.StandardController sc = new ApexPages.standardController(objActivity); 
    System.Dmlexception ex;
    test.startTest();
    Activitycontroller objact = new Activitycontroller(sc);
    ApexPages.Pagereference result = objact .save();
    List<SelectOption>  temp1=objact.Fieldsetlist;
    objact.fileName=''; 
    objact.fileImage=blob.valueof('sample');
    objact.filesize=1048577;   
    objact.selectActivityImage();
    objact.closePopUp();
    objact.showUplodePopUp();
    objact.showActivityImagPopUp();   
    try{
    objact.Save();
    objact.Cancel();    
    }catch(DmlException e){}
    objact.createStaticResource(); 
   }
  static testMethod void activityfile(){
    Activitytype__c objActivity = new Activitytype__c(); 
    objActivity.Name='test';
    objActivity.Icon__c='testicon';
    objActivity.Bar_color__c ='red';
    objActivity.F__c =Null;    
    System.assertEquals('test', objActivity.name);
    insert objActivity;
    
    ApexPages.currentPage().getParameters().put('id', objActivity.id);
    ApexPages.StandardController sc = new ApexPages.standardController(objActivity);
	Activitycontroller actfile = new Activitycontroller(sc);
    actfile.filesize=1048555;
    actfile.fileName=null;
    actfile.fileName='test';
    actfile.poptext='pop';
    actfile.createStaticResource();
    }  
  }