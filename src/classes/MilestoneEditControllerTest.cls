/*******************************************************
Class Name: MilestoneEditControllerTest
Author:chaithanya daggumati        Last modified by: Chaithanya Daggumati
Date: 25/8/2014                    Date: 19/3/2015                    
********©2013 Musqot marketing technology Pvt ltd *******/

@isTest(seeAlldata=true)
    public class MilestoneEditControllerTest{
     static testMethod void MilestoneEditController(){
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
     
     Socialmedia_settings__c OBJSocial=new Socialmedia_settings__c();
     OBJSocial.Name='testmedia';
     OBJSocial.type__c = 'Milestone';
     OBJSocial.musqot__Import_rate__c='Hour';
     OBJSocial.musqot__Socialmedia_type__c='Facebook';
     OBJSocial.musqot__Watch_type__c='Unique visitors';
     OBJSocial.musqot__Chart__c='Line charts';
     OBJSocial.musqot__Bar_color__c='#333';
     OBJSocial.musqot__Page_Id__c='87567567567';
     OBJSocial.musqot__Auto_import__c= true ;
     insert OBJSocial;
     
     musqot__Social_media_data__c socMedia=new musqot__Social_media_data__c();
     socMedia.Name='testmedia';
     socMedia.musqot__Date__c=system.today();
     socMedia.musqot__Number_of_likes__c=100;
     socMedia.musqot__Number_of_member__c=100;
     socMedia.musqot__Number_of_unik_visitor__c=500;
     socMedia.musqot__Socialmedia_Settings__c=OBJSocial.id;
     insert socMedia;
     
     Project__c objprj= new Project__c ();
     objprj.Name='ITC';
     objprj.Starts_date__c= system.toDay();
     objprj.Ends_date__c = system.toDay().addDays(1);
     objprj.Status__c = 'In Progress';
     objprj.OwnerId=plm.userid__c;
     System.assertEquals('ITC', objprj.name);         
     insert objprj;
         
     
    Milestone__c objmilestone = new  Milestone__c();
    objmilestone.Name = 'test';
    objmilestone.Description__c = 'testdesc';
    objmilestone.Targetdate__c = Date.Today();
    objmilestone.Status__c='Reach on time';
    objmilestone.Target_Socialmedia__c=OBJSocial.id;
    objmilestone.Milestone_type__c =3;
    objmilestone.Target_number__c=10;
    System.assertEquals('test', objmilestone.name);
    try{
    insert objmilestone ; 
    }catch(Exception e){}
      
    ApexPages.currentPage().getParameters().put('id', objmilestone.id);
    String tabId = System.currentPageReference().getParameters().get('tabId');
    ApexPages.currentPage().getParameters().put('mileId', objmilestone.id);
    ApexPages.StandardController sc = new ApexPages.standardController(objmilestone);
    
    MilestoneEditController mileedit= new MilestoneEditController(sc);
    mileedit.hideTargetNo=true;
    mileedit.Save();
    mileedit.deleteMilestone();
    mileedit.Cancel(); 
    mileedit.selctType(); 
       }
    static testMethod void MilestoneEditControllertest(){
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
     
     Socialmedia_settings__c OBJSocial=new Socialmedia_settings__c();
     OBJSocial.Name='testmedia';
     OBJSocial.type__c = 'Milestone';
     OBJSocial.musqot__Import_rate__c='Hour';
     OBJSocial.musqot__Socialmedia_type__c='Facebook';
     OBJSocial.musqot__Watch_type__c='Likes/click';
     OBJSocial.musqot__Chart__c='Line charts';
     OBJSocial.musqot__Bar_color__c='#333';
     OBJSocial.musqot__Page_Id__c='87567567567';
     OBJSocial.musqot__Auto_import__c= true ;
     insert OBJSocial;
     
     musqot__Social_media_data__c socMedia=new musqot__Social_media_data__c();
     socMedia.Name='testmedia';
     socMedia.musqot__Date__c=system.today();
     socMedia.musqot__Number_of_likes__c=100;
     socMedia.musqot__Number_of_member__c=100;
     socMedia.musqot__Number_of_unik_visitor__c=500;
     socMedia.musqot__Socialmedia_Settings__c=OBJSocial.id;
     insert socMedia;
     
     Project__c objprj= new Project__c ();
     objprj.Name='ITC';
     objprj.Starts_date__c= system.toDay();
     objprj.Ends_date__c = system.toDay().addDays(1);
     objprj.Status__c = 'In Progress';
     objprj.OwnerId=plm.userid__c;
     System.assertEquals('ITC', objprj.name);         
     insert objprj;
         
     
    Milestone__c objmilestone = new  Milestone__c();
    objmilestone.Name = 'test';
    objmilestone.Description__c = 'testdesc';
    objmilestone.Targetdate__c = Date.Today();
    objmilestone.Status__c='Reach on time';
    objmilestone.Target_Socialmedia__c=OBJSocial.id;
    objmilestone.Milestone_type__c =3;
    objmilestone.Target_number__c=10;
    System.assertEquals('test', objmilestone.name);
    try{
    insert objmilestone ;
    }catch(Exception e){} 
    
    ApexPages.currentPage().getParameters().put('id', objmilestone.id);
    String tabId = System.currentPageReference().getParameters().get('tabId');
    ApexPages.currentPage().getParameters().put('mileId', objmilestone.id);
    ApexPages.StandardController sc = new ApexPages.standardController(objmilestone);
    
    MilestoneEditController mileedit= new MilestoneEditController(sc);
    mileedit.hideTargetNo=true;
    mileedit.Save();
    mileedit.deleteMilestone();
    mileedit.Cancel(); 
    mileedit.selctType(); 
  }
static testMethod void MilestoneEditController1(){
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
    Socialmedia_settings__c OBJSocial=new Socialmedia_settings__c();
     OBJSocial.Name='testmedia';
     OBJSocial.type__c = 'Milestone';
     OBJSocial.musqot__Import_rate__c='Hour';
     OBJSocial.musqot__Socialmedia_type__c='Facebook';
     OBJSocial.musqot__Watch_type__c='Downloads';
     OBJSocial.musqot__Chart__c='Line charts';
     OBJSocial.musqot__Bar_color__c='#333';
     OBJSocial.musqot__Page_Id__c='87567567567';
     OBJSocial.musqot__Auto_import__c= true ;
     insert OBJSocial;
     
    Project__c objproj = new Project__c();
    objproj .Name = 'test';
    objproj .Starts_date__c = Date.Today();
    objproj .Ends_date__c = Date.Today();
    objproj .Description__c = 'testdesc';
    objproj.OwnerId=plm.userid__c;
    System.assertEquals('test', objproj .Name);
    insert objproj ;
    
    Subproject__c objsubproj = new Subproject__c();
    objsubproj .Name = 'test';
    objsubproj .Starts_date__c = Date.Today();
    objsubproj .Ends_date__c = Date.Today();
    objsubproj .Description__c = 'testdesc';    
    System.assertEquals('test', objsubproj .Name);
    insert objsubproj ; 
    
    musqot__ERP_Settings__c erpSet=new musqot__ERP_Settings__c();
    erpSet.Name='testERP';
    erpSet.musqot__Bar_color__c='#335566';
    erpSet.musqot__erp_Chart__c='Area charts';
    erpSet.musqot__erp_Chart__c='Performance, general';
    erpSet.musqot__Expression_business_area__c='APAC';
    erpSet.musqot__Expression_business_region__c='Leads';
    erpSet.musqot__Selector__c='Business area';
    insert erpSet;
    
    ERP_logfile__c err = new ERP_logfile__c();
    err.Name='test';
    err.musqot__Imported__c = true;
    err.musqot__Import_message__c = 'Good';
    err.musqot__Number_of_records__c = 10;
    insert err;
    System.assertEquals('test', err.Name);
    
    musqot__ERP_sales_obj__c erp=new musqot__ERP_sales_obj__c();
    erp.Name='test';
    erp.musqot__Business_area__c='area';
    erp.musqot__Business_region__c='region';
    erp.musqot__Sales__c=200;
    erp.musqot__ERP_logfile__c=err.id;
    erp.musqot__Sales_date__c= System.now().date();
    erp.musqot__Sales_import_date__c=System.now().date();
    insert erp;
    System.assertEquals('test', erp.Name); 
    
    Milestone__c objmilestone = new  Milestone__c();
    objmilestone.Name = 'test';
    objmilestone.musqot__Plan__c=objproj.id;
    objmilestone.Description__c = 'testdesc';
    objmilestone.Targetdate__c = Date.Today();
    objmilestone.Target_Socialmedia__c=OBJSocial.id;
    objmilestone.Milestone_type__c =4;
    objmilestone.Target_number__c=10;
    objmilestone.musqot__Target_ERP_Sales__c=erpSet.id;
    System.assertEquals('test', objmilestone.name);
    insert objmilestone ; 
    
    ApexPages.currentPage().getParameters().put('planid', objproj .id);
    String tabId = System.currentPageReference().getParameters().get('tabId');
    ApexPages.currentPage().getParameters().put('mileid', objmilestone.id);
    ApexPages.StandardController sc = new ApexPages.standardController(objmilestone);
    test.startTest();
    MilestoneEditController mileedit= new MilestoneEditController(sc);
    mileedit.hideTargetNo=false;
    mileedit.Save();
    mileedit.deleteMilestone();
    mileedit.Cancel(); 
    mileedit.selctType();       
    }
 static testMethod void MilestoneEditController11(){
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
     Socialmedia_settings__c OBJSocial=new Socialmedia_settings__c();
     OBJSocial.Name='testmedia';
     OBJSocial.type__c = 'Milestone';
     OBJSocial.musqot__Import_rate__c='Hour';
     OBJSocial.musqot__Socialmedia_type__c='Facebook';
     OBJSocial.musqot__Watch_type__c='Downloads';
     OBJSocial.musqot__Chart__c='Line charts';
     OBJSocial.musqot__Bar_color__c='#333';
     OBJSocial.musqot__Page_Id__c='87567567567';
     OBJSocial.musqot__Auto_import__c= true ;
     insert OBJSocial;
     
    Project__c objproj = new Project__c();
    objproj .Name = 'test';
    objproj .Starts_date__c = Date.Today();
    objproj .Ends_date__c = Date.Today();
    objproj .Description__c = 'testdesc';
    objproj.OwnerId=plm.userid__c;
    System.assertEquals('test', objproj .Name);
    insert objproj ;
    
    musqot__ERP_Settings__c erpSet=new musqot__ERP_Settings__c();
    erpSet.Name='testERP';
    erpSet.musqot__Bar_color__c='#335566';
    erpSet.musqot__erp_Chart__c='Area charts';
    erpSet.musqot__erp_Chart__c='Performance, general';
    erpSet.musqot__Expression_business_area__c='APAC';
    //erpSet.musqot__Expression_business_region__c='Leads';
    erpSet.musqot__Selector__c='Business area';
    insert erpSet;
    
    Marketing_activity__c objmarket = new Marketing_activity__c();
    objmarket .Name = 'test';
    System.assertEquals('test', objmarket .Name);
    insert objmarket ; 
    
    Milestone__c objmilestone = new  Milestone__c();
    objmilestone.Name = 'test';
    objmilestone.musqot__Plan__c=objproj.id;
    objmilestone.Description__c = 'testdesc';
    objmilestone.Targetdate__c = Date.Today();
    objmilestone.Target_Socialmedia__c=OBJSocial.id;
    objmilestone.Milestone_type__c =4;
    objmilestone.Target_number__c=10;
    objmilestone.musqot__Target_ERP_Sales__c=erpSet.id;
    System.assertEquals('test', objmilestone.name);
    insert objmilestone ; 
    
    ApexPages.currentPage().getParameters().put('planid', objproj .id);
    String tabId = System.currentPageReference().getParameters().get('tabId');
    ApexPages.currentPage().getParameters().put('mileid', objmilestone.id);
    ApexPages.StandardController sc = new ApexPages.standardController(objmilestone);
    test.startTest();
    MilestoneEditController mileedit= new MilestoneEditController(sc);
    mileedit.hideTargetNo=false;
    mileedit.Save();
    mileedit.deleteMilestone();
    mileedit.Cancel(); 
    mileedit.selctType();       
    }
 static testMethod void MilestoneEditController12(){
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
    Project__c objproj = new Project__c();
    objproj .Name = 'test';
    objproj .Starts_date__c = Date.Today();
    objproj .Ends_date__c = Date.Today();
    objproj .Description__c = 'testdesc';
    objproj.OwnerId=plm.userid__c;
    System.assertEquals('test', objproj .Name);
    insert objproj ;
    
    musqot__ERP_Settings__c erpSet=new musqot__ERP_Settings__c();
    erpSet.Name='testERP';
    erpSet.musqot__Bar_color__c='#335566';
    erpSet.musqot__erp_Chart__c='Area charts';
    erpSet.musqot__erp_Chart__c='Performance, general';
    erpSet.musqot__Expression_business_region__c='Leads';
    erpSet.musqot__Selector__c='Business area';
    insert erpSet;
    
    Milestone__c objmilestone = new  Milestone__c();
    objmilestone.Name = 'test';
    objmilestone.musqot__Plan__c=objproj.id;
    objmilestone.Description__c = 'testdesc';
    objmilestone.Targetdate__c = Date.Today();
    //objmilestone.Target_Socialmedia__c=OBJSocial.id;
    objmilestone.Milestone_type__c =4;
    objmilestone.Target_number__c=10;
    objmilestone.musqot__Target_ERP_Sales__c=erpSet.id;
    System.assertEquals('test', objmilestone.name);
    insert objmilestone ; 
    
    ApexPages.currentPage().getParameters().put('planid', objproj .id);
    String tabId = System.currentPageReference().getParameters().get('tabId');
    ApexPages.currentPage().getParameters().put('mileid', objmilestone.id);
    ApexPages.StandardController sc = new ApexPages.standardController(objmilestone);
    test.startTest();
    MilestoneEditController mileedit= new MilestoneEditController(sc);
    mileedit.hideTargetNo=false;
    mileedit.Save();
    mileedit.deleteMilestone();
    mileedit.Cancel(); 
    mileedit.selctType();       
    }
static testMethod void MilestoneEditController2(){
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
    Project__c objproj = new Project__c();
    objproj .Name = 'test';
    objproj .Starts_date__c = Date.Today();
    objproj .Ends_date__c = Date.Today();
    objproj .Description__c = 'testdesc';
    objproj.OwnerId=plm.userid__c;
    System.assertEquals('test', objproj .Name);
    insert objproj ;
    
    Subproject__c objsubproj = new Subproject__c();
    objsubproj .Name = 'test';
    objsubproj .Starts_date__c = Date.Today();
    objsubproj .Ends_date__c = Date.Today();
    objsubproj .Description__c = 'testdesc';
    System.assertEquals('test', objsubproj .Name);
    insert objsubproj ; 
    
    Marketing_activity__c objmarket = new Marketing_activity__c();
    objmarket .Name = 'test';
    System.assertEquals('test', objmarket .Name);
    insert objmarket ; 
    
    Milestone__c OBJMil= new  Milestone__c();
    OBJMil.Name='musqotmilestone';
    OBJMil.Description__c ='testing';
    OBJMil.Milestone_type__c =1;
    insert OBJMil;
    
     Socialmedia_settings__c OBJSocial=new Socialmedia_settings__c();
     OBJSocial.Name='testmedia';
     OBJSocial.type__c = 'Milestone';
     OBJSocial.musqot__Import_rate__c='Hour';
     OBJSocial.musqot__Socialmedia_type__c='Facebook';
     OBJSocial.musqot__Watch_type__c='Downloads';
     OBJSocial.musqot__Chart__c='Line charts';
     OBJSocial.musqot__Bar_color__c='#333';
     OBJSocial.musqot__Page_Id__c='87567567567';
     OBJSocial.musqot__Auto_import__c= true ;
     insert OBJSocial;
     System.assertEquals('Downloads', OBJSocial.musqot__Watch_type__c);
        
      musqot__ERP_Settings__c  ObjERP=new musqot__ERP_Settings__c ();
      ObjERP.Name='testERP';
      ObjERP.ERP_performance_type__c = 'Milestone';
      ObjERP.musqot__Selector__c='Business area';
      ObjERP.musqot__erp_Chart__c='Bar charts';
      ObjERP.musqot__Bar_color__c='#123344,#224466';
      insert ObjERP;
      System.assertEquals('Business area', ObjERP.musqot__Selector__c);
    
    ApexPages.currentPage().getParameters().put('subid', objsubproj .id);
    String tabId = System.currentPageReference().getParameters().get('tabId');
    ApexPages.currentPage().getParameters().put('mileid', OBJMil.id);
    ApexPages.StandardController sc = new ApexPages.standardController(OBJMil);
    test.startTest();
    MilestoneEditController mileedit= new MilestoneEditController(sc);
    List<SelectOption> selOpts=mileedit.SocialMedia;
    List<SelectOption> selOpts1=mileedit.ERPSales;
    mileedit.hideTargetNo=false;
    mileedit.Save();
    mileedit.deleteMilestone();
    mileedit.Cancel();
    mileedit.gotoEditMode();
    mileedit.gotoInfoMode();
    mileedit.selctType();            
    }     
 }