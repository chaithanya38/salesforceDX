/**************************************************************
Class Name: ActivityTypeClassTest
Author: Nagaraju G         Last modified by:G Janardhanreddy 
Date  :  18/7/2014            Date:18/03/2015
***********©2013 Musqot marketing technology Pvt ltd **********/
@isTest(seeAllData=true)
public class ActivityTypeClassTest{
    static testmethod void ActivityTypeClass() {
     Activitytype__c objActiv = new Activitytype__c();
     objActiv.Name='musqot';
     objActiv.Icon__c='testicon';
     objActiv.Bar_color__c='blue';
     System.assertEquals('musqot', objActiv.name);
     insert objActiv;
      Activitytype__c  ActivityType= [select Icon__c from Activitytype__c where id = :objActiv.id];
             
     ApexPages.currentPage().getParameters().put('id', objActiv.id);
     PageReference pageRef = Page.Purchaseorderpage;
     Test.setCurrentPage(pageRef);  
     ApexPages.StandardController sc = new ApexPages.standardController(objActiv);
     test.startTest();
     ActivityTypeClass acttype = new ActivityTypeClass(sc);
     List<SelectOption>  temp1=acttype.Fieldsetlist;
     acttype.ActivityType=objActiv;         
     acttype.Save();
     acttype.banner='test';
     acttype.Cancel();
     acttype.selectActivityImage();
    
     acttype.closePopUp();
     acttype.showUplodePopUp();
     acttype.showActivityImagPopUp();
     try{
     acttype.createStaticResource();
     acttype.getIcon();
     //acttype.handleSaveResults();
     }catch (Exception e){}
     ActivityTypeClass.GetResourceURL('Sponsor');
                      
     }
     static testmethod void ActivityTypeClass1() {
     Activitytype__c objActiv = new Activitytype__c();
     objActiv.Name='musqot';
     objActiv.Icon__c='testicon';
     objActiv.Bar_color__c='blue';
     System.assertEquals('musqot', objActiv.name);
     insert objActiv;
      Activitytype__c  ActivityType= [select Icon__c from Activitytype__c where id = :objActiv.id];
             
     ApexPages.currentPage().getParameters().put('id', objActiv.id);
     PageReference pageRef = Page.Purchaseorderpage;
     Test.setCurrentPage(pageRef);  
     ApexPages.StandardController sc = new ApexPages.standardController(objActiv);
     test.startTest();
     ActivityTypeClass acttype = new ActivityTypeClass(sc);
     List<SelectOption>  temp1=acttype.Fieldsetlist;
     acttype.ActivityType=objActiv;   
     acttype.fileName='test'; 
     acttype.fileImage=blob.valueof('sample');
     acttype.filesize=1048577;     
     acttype.Save();
     acttype.banner='test';
     acttype.Cancel();
     acttype.selectActivityImage();
    
     acttype.closePopUp();
     acttype.showUplodePopUp();
     acttype.showActivityImagPopUp();
     try{
     acttype.createStaticResource();
     acttype.getIcon();
     //acttype.handleSaveResults();
     }catch (Exception e){}
     ActivityTypeClass.GetResourceURL('Sponsor');
                      
     }
     static testmethod void ActivityTypeClass2(){
     Activitytype__c objActiv = new Activitytype__c();
     objActiv.Name='musqot';
     objActiv.Icon__c='testicon';
     objActiv.Bar_color__c='blue';
     System.assertEquals('musqot', objActiv.name);
     insert objActiv;
      Activitytype__c  ActivityType= [select Icon__c from Activitytype__c where id = :objActiv.id];
             
     ApexPages.currentPage().getParameters().put('id', objActiv.id);
     PageReference pageRef = Page.Purchaseorderpage;
     Test.setCurrentPage(pageRef);  
     ApexPages.StandardController sc = new ApexPages.standardController(objActiv);
     test.startTest();
     ActivityTypeClass acttype = new ActivityTypeClass(sc);
     List<SelectOption>  temp1=acttype.Fieldsetlist;
     acttype.ActivityType=objActiv;   
     acttype.fileName='test'; 
     acttype.fileImage=blob.valueof('sample');
     acttype.filesize=1048570;     
     acttype.Save();
     acttype.banner='test';
     acttype.Cancel();
     acttype.selectActivityImage();
    
     acttype.closePopUp();
     acttype.showUplodePopUp();
     acttype.showActivityImagPopUp();
     try{
     acttype.createStaticResource();
     acttype.getIcon();
     //acttype.handleSaveResults();
     }catch (Exception e){}
     ActivityTypeClass.GetResourceURL('Sponsor');
                      
     }
 }