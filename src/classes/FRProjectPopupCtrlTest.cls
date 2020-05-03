/****************************************************************
Class Name: FRProjectPopupCtrlTest
Author:chaithanya daggumati      Last modified by:G Janarhanreddy
Date:  24/07/2014                Date:19/03/2015
********©2013 Musqot marketing technology Pvt ltd ***************/
@isTest(Seealldata = True)
public class FRProjectPopupCtrlTest{
    static testMethod void FRProjectPopup(){
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
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=u2.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);  
        project__c objpro=new project__c();
        objpro.Name='testt';
        objpro.Starts_date__c = Date.Today();
        objpro.Ends_date__c = Date.Today();
        objpro.Status__c = 'Completed';
        objpro.ownerid =plm.userid__c;
        System.assertEquals('testt', objpro.Name);
        insert objpro;
        
        Subproject__c objsubproj = new Subproject__c();
        objsubproj.Parent_project__c=objpro.id;
        objsubproj.Name = 'test';
        objsubproj.Starts_date__c = Date.Today();
        objsubproj.Ends_date__c= Date.Today();
        objsubproj.Status__c = 'Completed';
        System.assertEquals('test', objsubproj.Name);
        insert objsubproj;
        
        Subproject__c objsubproj1 = new Subproject__c();
        objsubproj1.Parent_project__c=objpro.id;
        objsubproj1.project_del__c = objsubproj.id;
        objsubproj1.Name = 'test1';
        objsubproj1.Starts_date__c = Date.Today();
        objsubproj1.Ends_date__c= Date.Today();
        objsubproj1.Status__c = 'Completed';
        System.assertEquals('test1', objsubproj1.Name);
        objsubproj1.musqot__Project_del__c=objsubproj.id;
        insert objsubproj1;
        
        Musqot_fiscal_year__c fiscalYearObj=new Musqot_fiscal_year__c();
        fiscalYearObj.name='2015';
        fiscalYearObj.musqot__Start_date__c=system.today();
        fiscalYearObj.musqot__End_date__c=system.today()+10;
        insert fiscalYearObj;
                
        User otherOwner = [SELECT Id from User where isActive = true and Id != :UserInfo.getUserId() LIMIT 1]; //This will give you another active user other than you.
    //Now when creating records in test class, 
        Costcentre__c objCC=new Costcentre__c(); 
                  objCC.Name='test';
                  objCC.cc_Owner__c=u2.id;
                  objCC.Headline__c ='present';
                  objCC.OwnerId = UserInfo.getUserId(); // you are the owner
                  insert objCC;
        Costcentre__c objCC2=new Costcentre__c(); 
                  objCC2.Name='test';
                  objCC2.cc_Owner__c=u2.id;
                  objCC2.Headline__c ='present';
                  objCC2.OwnerId = otherOwner.Id;// Other user is the owner.
                  insert objCC2;
        
        Allocation_amount__c  objAllocationamount=new Allocation_amount__c ();
        objAllocationamount.Name='testAllocation';
        objAllocationamount.Approved_Amount__c=1000;
        objAllocationamount.plan__c=objpro.id;
        objAllocationamount.project__c=objsubproj.id;
        objAllocationamount.To_Project__c=objsubproj1.id;
        objAllocationamount.To_Project__c=objsubproj1.id;
        objAllocationamount.FiscalYear__c='november';
        objAllocationamount.Musqot_fiscal_year__c=fiscalYearObj.id;
        objAllocationamount.Approvedate__c=System.today();
        objAllocationamount.Description__c='testDescription';
        objAllocationamount.Allocated__c=1000;
        objAllocationamount.FiscalYear__c='2000';
        System.assertEquals('testAllocation', objAllocationamount.name);
        insert objAllocationamount;
        id fid = objAllocationamount.id;
        ApexPages.currentPage().getParameters().put('id', objpro.id);
        ApexPages.currentPage().getParameters().put('id', objsubproj.id);
        ApexPages.currentPage().getParameters().put('prjID',objsubproj1.Id);
        ApexPages.currentPage().getParameters().put('ccid',objCC2.Id);
        //ApexPages.StandardController sc = new ApexPages.standardController(objAllocationamount);
        FRProjectPopupCtrl frprojpopup = new FRProjectPopupCtrl();
        //FRProjectPopupCtrl.Reciver OBJR=new FRProjectPopupCtrl.Reciver();
        List<SelectOption> cctemp = frprojpopup.CCList;
        List<SelectOption>fiscaYearTemp= frprojpopup.fisicalYearOptions;
        frprojpopup.sObjName='Costcentre__c';
        frprojpopup.saveAmt();
        /*try{
        frprojpopup.ccUserRec();
        }catch(exception e){}*/
        frprojpopup.ccId = 'cc';
        frprojpopup.ccRequst = false;
        frprojpopup.saveSelfAmt();
        frprojpopup.selectedFisicalYear='fiscalyear';
        try{
        frprojpopup.ccUserRec();
        }catch(Exception e){}
        frprojpopup.sendRec=true;
        frprojpopup.uname='test';
    }
    static testMethod void FRProjectPopup1(){
        Profile p = [select id from profile where name='System Administrator']; 
        User objUser = new User(alias = 'stan', email='standarduser@test.com', 
                                emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
                                localesidkey='en_US', profileid = p.Id, 
                                timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
        insert objUser ;  
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=objUser.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
        project__c objpro=new project__c();
        objpro.Name='testt';
        objpro.Starts_date__c = Date.Today();
        objpro.Ends_date__c = Date.Today();
        objpro.Status__c = 'Completed';
        objpro.ownerid =plm.userid__c;
        System.assertEquals('testt', objpro.Name);
        insert objpro;
        Subproject__c objsubproj1 = new Subproject__c();
        objsubproj1.Parent_project__c=objpro.id;
        objsubproj1.Name = 'test1';
        objsubproj1.Starts_date__c = Date.Today();
        objsubproj1.Ends_date__c= Date.Today();
        objsubproj1.Status__c = 'Completed';
        System.assertEquals('test1', objsubproj1.Name);
        insert objsubproj1;
        Allocation_amount__c  objAllocationamount=new Allocation_amount__c ();
        objAllocationamount.Name='testAllocation';
        objAllocationamount.Approved_Amount__c=1000;
        objAllocationamount.plan__c=objpro.id;
        objAllocationamount.To_Project__c=objsubproj1.id;
        objAllocationamount.Approvedate__c=System.today();
        objAllocationamount.Description__c='testDescription';
        objAllocationamount.Allocated__c=1000;
        System.assertEquals('testAllocation', objAllocationamount.name);
        insert objAllocationamount;
        id fid = objAllocationamount.id;
        ApexPages.currentPage().getParameters().put('id', objpro.id);
        ApexPages.currentPage().getParameters().put('prjID',objsubproj1.Id);
        //ApexPages.StandardController sc = new ApexPages.standardController(objAllocationamount);
        FRProjectPopupCtrl frprojpopup = new FRProjectPopupCtrl();
        //FRProjectPopupCtrl.Reciver OBJR=new FRProjectPopupCtrl.Reciver();
        frprojpopup.sObjName='Subproject__c';
        frprojpopup.saveAmt();         
    }
  static testMethod void FRProjectPopup2(){
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
          
        Costcentre__c cc = new Costcentre__c();
        cc .Name = 'test';
        cc.ownerId=UserInfo.getUserId();
        cc.musqot__Headline__c='headline';
        cc.musqot__cc_Owner__c=u2.id;
        System.assertEquals('test', cc .name);
        insert cc;
      Musqot_fiscal_year__c fiscalYearObj=new Musqot_fiscal_year__c();
        fiscalYearObj.name='2015';
        fiscalYearObj.musqot__Start_date__c=system.today();
        fiscalYearObj.musqot__End_date__c=system.today()+10;
        insert fiscalYearObj;   
        
      Allocation_amount__c  objAllocationamount=new Allocation_amount__c ();
        objAllocationamount.Name='testAllocation';
        objAllocationamount.Approved_Amount__c=1000;        
        objAllocationamount.FiscalYear__c='november';
        objAllocationamount.Musqot_fiscal_year__c=fiscalYearObj.id;
        objAllocationamount.Approvedate__c=System.today();
        objAllocationamount.Description__c='testDescription';
        objAllocationamount.Allocated__c=1000;
        objAllocationamount.FiscalYear__c='2000';
        System.assertEquals('testAllocation', objAllocationamount.name);
        insert objAllocationamount;
        
        //ApexPages.StandardController sc = new ApexPages.standardController(cc);
        FRProjectPopupCtrl frprojpopup1 = new FRProjectPopupCtrl();
        Costcentre__c ccRec=[SELECT Id,musqot__cc_Owner__c,owner.name,OwnerId,Name FROM musqot__Costcentre__c where Id =:cc.id];
        frprojpopup1.ccRequst=false;
        frprojpopup1.sObjName='Project__c';
        //frprojpopup1.selectedRec();  
  }
   static testMethod void FRProjectPopup3(){
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
          
        Costcentre__c cc = new Costcentre__c();
        cc .Name = 'test';
        cc.ownerId=UserInfo.getUserId();
        cc.musqot__Headline__c='headline';
        cc.musqot__cc_Owner__c=u2.id;
        System.assertEquals('test', cc .name);
        insert cc;
      Musqot_fiscal_year__c fiscalYearObj=new Musqot_fiscal_year__c();
        fiscalYearObj.name='2015';
        fiscalYearObj.musqot__Start_date__c=system.today();
        fiscalYearObj.musqot__End_date__c=system.today()+10;
        insert fiscalYearObj;   
        
        //ApexPages.StandardController sc = new ApexPages.standardController(cc);
        FRProjectPopupCtrl frprojpopup1 = new FRProjectPopupCtrl();
        Costcentre__c ccRec=[SELECT Id,musqot__cc_Owner__c,owner.name,OwnerId,Name FROM musqot__Costcentre__c where Id =:cc.id];
        frprojpopup1.ccRequst=false;
        frprojpopup1.sObjName='Project__c';
        //frprojpopup1.selectedRec();  
  }
  static testMethod void FRProjectPopup4(){
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
          
        Costcentre__c cc = new Costcentre__c();
        cc .Name = 'test';
        cc.ownerId=UserInfo.getUserId();
        cc.musqot__Headline__c='headline';
        cc.musqot__cc_Owner__c=u2.id;
        System.assertEquals('test', cc .name);
        insert cc;
        Musqot_fiscal_year__c fiscalYearObj=new Musqot_fiscal_year__c();
        fiscalYearObj.name='2015';
        fiscalYearObj.musqot__Start_date__c=system.today();
        fiscalYearObj.musqot__End_date__c=system.today()+10;
        insert fiscalYearObj;   
        
        Allocation_amount__c  objAllocationamount=new Allocation_amount__c ();
        objAllocationamount.Name='testAllocation';
        objAllocationamount.Approved_Amount__c=1000;        
        objAllocationamount.FiscalYear__c='november';
        objAllocationamount.Musqot_fiscal_year__c=fiscalYearObj.id;
        objAllocationamount.Approvedate__c=System.today();
        objAllocationamount.Description__c='testDescription';
        objAllocationamount.FiscalYear__c='2000';
        objAllocationamount.Allocated__c=1000;
        System.assertEquals('testAllocation', objAllocationamount.name);
        insert objAllocationamount;

        //ApexPages.StandardController sc = new ApexPages.standardController(cc);
        FRProjectPopupCtrl frprojpopup1 = new FRProjectPopupCtrl();
        Costcentre__c ccRec=[SELECT Id,musqot__cc_Owner__c,owner.name,OwnerId,Name FROM musqot__Costcentre__c where Id =:cc.id];
        frprojpopup1.ccRequst=false;
        frprojpopup1.sObjName='Subproject__c';
       // frprojpopup1.selectedRec();  
  	}
}