/*****************************************************************
Class Name: costcenterdetailclsTest
Author:Chaithanya daggumati                   Last modified by:Chaithanya daggumati
Date :14/12/2015                   			  Date :14/12/2015                    
********©2013 Musqot marketing technology Pvt ltd *****************/
@isTest
public class costcenterdetailclsTest {
    static testMethod void CostcenterDetailTestMethod(){
        Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
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
        Musqot_fiscal_year__c objMusqotfiscalyea=new Musqot_fiscal_year__c();
        objMusqotfiscalyea.name ='musqot';
        objMusqotfiscalyea.Start_date__c= System.now().date();
        objMusqotfiscalyea.End_date__c =System.now().date();
        System.assertEquals('musqot', objMusqotfiscalyea.name);
        insert objMusqotfiscalyea;
        
        Costcentre__c objCC=new Costcentre__c(); 
        objCC.Name='CCRequest';
        objCC.OwnerId=u2.id;
        objCC.Headline__c='musqotCostcenter';
        objCC.Fiscal_year__c=objMusqotfiscalyea.id;
        objCC.Overveiw__c='presentation';
        objCC.Status__c='Active';
        objCC.cc_Owner__c=u2.id;
        insert objCC;
        System.assertEquals('CCRequest', objCC.name);
        
        Members__c objmember=new Members__c();
        objmember.ProjUsers__c=UserInfo.getUserId();
        objmember.Role__c='Member';
        objmember.Cost_center__c=objCC.id;
        objmember.User_Email__c ='standarduser1@test.com';
        System.assertEquals('Member', objmember.Role__c);
        insert objmember; 
        
        Allocation_amount__c objAllocate=new Allocation_amount__c();
        objAllocate.Name='finance';
        objAllocate.Approved_Amount__c=4444;
        objAllocate.Allocated__c=220;
        objAllocate.Costcentre__c=objCC.id;
        insert objAllocate;
        System.assertEquals('finance', objAllocate.Name);
        
        Task ObTask = new Task();
        ObTask .Task_name__c = 'testname';
        ObTask .ownerId = u2.Id; 
        ObTask .WhatId=objCC.id; 
        ObTask .Subject = 'Run Test Trigger';
        ObTask .Status = 'Not Started';
        ObTask .Priority = 'Normal';
        insert ObTask ;
        System.assertEquals('testname', ObTask.Task_name__c);
        
        Test.startTest();
        PageReference pageRef = Page.Costcenterdetail;
        Test.setCurrentPage(pageRef);  
        ApexPages.currentPage().getParameters().put('cosid',objCC.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objCC);
        costcenterdetailcls ccdetails = new costcenterdetailcls(sc);
        MusqotUtility.innerClass musIncls = MusqotUtility.securitySettingcoscenter(objCC.Id);
        ccdetails.costcenteredit();
        ccdetails.costcenteroverview();
        ccdetails.workRedirect();
        ccdetails.getGadgetHTMLContent();
        ccdetails.newtask();
        ccdetails.gettaskrecs();
        ccdetails.gotoTaskEdit();
        ccdetails.newmember();
        ccdetails.getmembers();
        ccdetails.gotoMemberEdit();
        ccdetails.getTabInFocus();
        ccdetails.setTabInFocus('String');
        Test.stopTest();
    }
}