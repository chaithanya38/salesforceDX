/*********************************************************
Class Name: MusqotsettingscontrollerTest
Author:Nagaraju      Last modified by: Håan
Date :21/7/2014      Date : 19/3/2105                    
********©2013 Musqot marketing technology Pvt ltd *********/
@isTest(seeAllData=true)
    public class MusqotsettingscontrollerTest{
    static testMethod void MusqotsettingscontrollerMethod(){
    Profile p=[SELECT Id ,Name From Profile WHERE name='System Administrator'];
        User u2 =new User( Alias = 'newUser1' ,
                          Email ='newuser123@testorg.com',
                          EmailEncodingKey = 'UTF-8',
                          LastName = 'Testing',
                          LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', 
                          UserName='newuser1234@testorg.com',
                          ProfileId=p.Id,
                          TimeZoneSidKey    = 'America/Los_Angeles');
        insert u2;  
    musqot__Activity__c m1 =new musqot__Activity__c();
    m1.musqot__keycode__c='emyJg-lemki-hP1Ce-wxaTb';
    m1.musqot__Use_Allocation__c=true;
    m1.musqot__Use_Budget__c=true;
    m1.musqot__Use_Finance1__c=true;
    m1.musqot__Use_Forcasting__c=true;
    m1.musqot__Use_milestones__c=true;
    m1.musqot__Use_Resource__c=true;
    System.assertEquals('emyJg-lemki-hP1Ce-wxaTb', m1.musqot__keycode__c);
    insert m1;
    ApexPages.currentPage().getParameters().put('musid',m1.id);
    ApexPages.StandardController sc = new ApexPages.standardController(m1);
    test.startTest();
    Musqotsettingscontroller mus = new Musqotsettingscontroller(sc);                    
    mus.Save();
    mus.Cancel();
    mus.gotoEditMode();
    mus.gotoInfoMode(); 
    mus.autoSel();
     }
 static testMethod void MusqotsettingscontrollerMethod1(){
    musqot__Activity__c m1 =new musqot__Activity__c();
    m1.musqot__keycode__c='emyJg-lemki-hP1Ce-wxaTb';
    m1.musqot__Use_Allocation__c=false;
    m1.musqot__Use_Budget__c=false;
    m1.musqot__Use_Finance1__c=false;
    m1.musqot__Use_Forcasting__c=false;
    m1.musqot__Use_milestones__c=false;
    m1.musqot__Use_Resource__c=false;
    System.assertEquals('emyJg-lemki-hP1Ce-wxaTb', m1.musqot__keycode__c);
    insert m1;
    ApexPages.currentPage().getParameters().put('musid',m1.id);
    ApexPages.StandardController sc = new ApexPages.standardController(m1);
    test.startTest();
    Musqotsettingscontroller mus = new Musqotsettingscontroller(sc);
    mus.Save();
    mus.Cancel();
    mus.gotoEditMode();
    mus.gotoInfoMode();
    mus.Cancel();
    mus.autoSel();
    mus.sendUpgradeRequest();
    mus.showLicenceUpgradePopUp();
    mus.hideLicenceUpgradePopUp();
    mus.verifyKeycode();
 	//mus.showVerifyKeycodeBtn();
    mus.redirectToMusqotFiscalYearPage();
    }
 static testMethod void verifiedkey(){
    Activity__c m1 =new Activity__c();
    m1.keycode__c='emyJg-lemki-hP1Ce-wxaTb';
    m1.Use_Allocation__c=false;
    m1.Use_Resource__c=false;
    System.assertEquals('emyJg-lemki-hP1Ce-wxaTb', m1.keycode__c);
    insert m1;
    ApexPages.currentPage().getParameters().put('musid',m1.id);
    ApexPages.StandardController sc = new ApexPages.standardController(m1);
    Musqotsettingscontroller mus = new Musqotsettingscontroller(sc);
    mus.isValidKeyCode = false;
    mus.isNotValidKeyCode = true;
    mus.verifyKeycode();
   }
 static testMethod void verifiedkey1(){
    musqot__Activity__c m1 =new musqot__Activity__c();
    m1.musqot__keycode__c='emyJg-lemki-hP1Ce-wxaTb';
    m1.musqot__Use_milestones__c=false;
    m1.Use_Performance_ERP__c=false;
    m1.Use_socialmedia__c=false;
    m1.musqot__Use_Resource__c=false;
    m1.Use_Performance_CRM__c='Not used';
    m1.Incl_Milestone_Main__c=false;
    m1.Incl_Milestone_Detail__c=false;
    m1.Performance_milestone_Detail__c=false;
    System.assertEquals('emyJg-lemki-hP1Ce-wxaTb', m1.musqot__keycode__c);
    insert m1;
    ApexPages.currentPage().getParameters().put('musid',m1.id);
    ApexPages.StandardController sc = new ApexPages.standardController(m1);
    Musqotsettingscontroller mus = new Musqotsettingscontroller(sc);
    mus.perGantt=true;
    mus.autoSel();
 }
}