/**************************************************************
Class Name: FRPlanPopupCtrlTest
Author:chaithanya daggumati     Last modified by:G Janarhanreddy
Date: 23/7/2014                 Date:19/03/2015
********©2013 Musqot marketing technology Pvt ltd *************/
@isTest(seeAlldata=true)
public class FRPlanPopupCtrlTest{
    static testMethod void FRPlanPopupTest(){
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
        Costcentre__c cc = new Costcentre__c();
        cc .Name = 'test';
        cc.ownerId=UserInfo.getUserId();
        cc.musqot__cc_Owner__c=UserInfo.getUserId();
        cc.musqot__Headline__c='headline';
        System.assertEquals('test', cc .name);
        insert cc;
        
        Project__c prj = new Project__c ();
        prj.Name='ITC';
        //prj.Plantype__c= pt.Id;
        prj.Ends_date__c = system.toDay().addDays(3);
        prj.Starts_date__c= system.toDay();
        prj.Status__c = 'In Progress';
        prj.ownerid =plm.userid__c;
        System.assertEquals('ITC', prj.name);         
        insert prj;
        
        Subproject__c subPrj = new Subproject__c();         
        subPrj.Name='ITC Project';
        subPrj.Parent_project__c = prj.Id;
        subPrj.Ends_date__c = system.toDay().addDays(3);
        subPrj.Starts_date__c= system.toDay();
        subPrj.Status__c = 'In Progress'; 
        //subPrj.Project_type__c = prjType.Id;
        System.assertEquals('ITC Project', subPrj.name);     
        insert subPrj;
        
        Allocation_amount__c objallocamt = new Allocation_amount__c ();
        objallocamt .Approvedate__c= Date.Today(); 
        objallocamt .Name = 'Name';
        objallocamt.Costcentre__c=cc.id;
        objallocamt.plan__c=prj.id;
        objallocamt.project__c=subPrj.id;          
        System.assertEquals('Name', objallocamt .name);         
        insert objallocamt ; 
        musqot__Activity__c m1 =new musqot__Activity__c();
        m1.musqot__keycode__c='212';
        m1.musqot__Use_Allocation__c=true;
        m1.musqot__Use_Budget__c=true;
        m1.musqot__Use_Finance1__c=true;
        m1.musqot__Use_Forcasting__c=true;
        m1.musqot__Use_milestones__c=true;
        m1.musqot__Use_Resource__c=true;
        insert m1;
        
         musqot__Musqot_fiscal_year__c fiscalYearObj=new musqot__Musqot_fiscal_year__c();
        fiscalYearObj.name='2015';
        fiscalYearObj.musqot__Start_date__c=system.today();
        fiscalYearObj.musqot__End_date__c=system.today()+10;
        insert fiscalYearObj;
        test.startTest();  
                
        ApexPages.currentPage().getParameters().put('pid',prj.Id);           
        ApexPages.StandardController sc = new ApexPages.standardController(prj);
        FRPlanPopupCtrl frplnpop = new FRPlanPopupCtrl();  
        List<selectoption>temp=frplnpop.CCList;   
        List<SelectOption>fiscaYearTemp= frplnpop.fisicalYearOptions;  
        frplnpop.ccId=UserInfo.getUserId();
        frplnpop.saveAmt();
        try{
        frplnpop.ccUserRec();
        }catch(Exception e){}
        frplnpop.saveSelfAmt();
        frplnpop.uname='test';
        frplnpop.sendrec=true;
        frplnpop.selectedFisicalYear='year';
        test.stopTest();                 
       }
    static testMethod void FRPlanPopuponplan(){
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
        Costcentre__c cc = new Costcentre__c();
        cc .Name = 'test';
        //cc.musqot__cc_Owner__c='005b00000019Yzt';
        cc.musqot__Headline__c='headline';
        System.assertEquals('test', cc .name);
        insert cc;
        
        Project__c prj = new Project__c ();
        prj.Name='ITC';
        //prj.Plantype__c= pt.Id;
        prj.Ends_date__c = system.toDay().addDays(3);
        prj.Starts_date__c= system.toDay();
        prj.Status__c = 'In Progress';
        prj.ownerid =plm.userid__c;
        System.assertEquals('ITC', prj.name);         
        insert prj;
        
        Subproject__c subPrj = new Subproject__c();         
        subPrj.Name='ITC Project';
        subPrj.Parent_project__c = prj.Id;
        subPrj.Ends_date__c = system.toDay().addDays(3);
        subPrj.Starts_date__c= system.toDay();
        subPrj.Status__c = 'In Progress'; 
        //subPrj.Project_type__c = prjType.Id;
        System.assertEquals('ITC Project', subPrj.name);     
        insert subPrj;
        
        Allocation_amount__c objallocamt = new Allocation_amount__c ();
        objallocamt .Approvedate__c= Date.Today(); 
        objallocamt .Name = 'Name';
        objallocamt.Costcentre__c=cc.id;
        objallocamt.plan__c=prj.id;
        objallocamt.project__c=subPrj.id;          
        System.assertEquals('Name', objallocamt .name);         
        insert objallocamt ; 
        musqot__Activity__c m1 =new musqot__Activity__c();
        m1.musqot__keycode__c='212';
        m1.musqot__Use_Allocation__c=true;
        m1.musqot__Use_Budget__c=true;
        m1.musqot__Use_Finance1__c=true;
        m1.musqot__Use_Forcasting__c=true;
        m1.musqot__Use_milestones__c=true;
        m1.musqot__Use_Resource__c=true;
        insert m1;
        
        test.startTest();          
        ApexPages.currentPage().getParameters().put('Id',cc.Id);           
        ApexPages.StandardController sc = new ApexPages.standardController(prj);
        FRPlanPopupCtrl frplnpop = new FRPlanPopupCtrl();  
        List<selectoption>temp=frplnpop.CCList;
        
        frplnpop.uname='test';
        frplnpop.sendrec=true;
        frplnpop.ccApp=true;
        frplnpop.ccRequst=false;       
        try{
        frplnpop.saveAmt();
        }catch(Exception e){}
        try{
        frplnpop.ccUserRec();
        }catch(Exception e){}        
        test.stopTest();                  
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
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=u2.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);  
        Project__c prj = new Project__c ();
        prj.Name='ITC';
        //prj.Plantype__c= pt.Id;
        prj.Ends_date__c = system.toDay().addDays(3);
        prj.Starts_date__c= system.toDay();
        prj.Status__c = 'In Progress';
        prj.ownerid =plm.userid__c;
        System.assertEquals('ITC', prj.name);         
        insert prj;
        
        Subproject__c subPrj = new Subproject__c();         
        subPrj.Name='ITC Project';
        subPrj.Parent_project__c = prj.Id;
        subPrj.Ends_date__c = system.toDay().addDays(3);
        subPrj.Starts_date__c= system.toDay();
        subPrj.Status__c = 'In Progress'; 
        //subPrj.Project_type__c = prjType.Id;
        System.assertEquals('ITC Project', subPrj.name);     
        insert subPrj; 
          
        Costcentre__c cc = new Costcentre__c();
        cc .Name = 'test';
        cc.ownerId=UserInfo.getUserId();
        cc.musqot__Headline__c='headline';
        cc.musqot__cc_Owner__c=u2.id;
        System.assertEquals('test', cc .name);
        insert cc;
        
        ApexPages.StandardController sc = new ApexPages.standardController(prj);
        FRPlanPopupCtrl frplnpopup1 = new FRPlanPopupCtrl();
        Costcentre__c ccRec=[SELECT Id,musqot__cc_Owner__c,owner.name,OwnerId,Name FROM musqot__Costcentre__c where Id =:cc.id];
        frplnpopup1.ccRequst=false;  
    }
    
}