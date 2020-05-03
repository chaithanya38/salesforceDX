/***************************************************************
Class Name: MileStoneContrllorTest
Author:Nagaraju           Last modified by: chaithanya daggumati
Date :21/7/2014           Date : 19/3/2015                    
********©2013 Musqot marketing technology Pvt ltd **************/
@isTest(seeAllData=true)
private class MileStoneContrllorTest{
    static testmethod void MileStoneContrlloreplan(){
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
        objproj .name = 'testname';
        objproj .Starts_date__c = System.now().date();
        objproj .Ends_date__c =  System.now().date()+5; 
        objproj .Description__c = 'sampdesc';
        objproj.OwnerId=plm.userid__c;
        System.assertEquals('testname', objproj .name);
        insert objproj;
                       
        
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        insert objMarketingact;
        System.assertEquals('test', objMarketingact.name);
        
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
        ObjERP.Expression_business_region__c='APAC';
        ObjERP.musqot__Selector__c='Business area';
        ObjERP.musqot__erp_Chart__c='Bar charts';
        ObjERP.Expression_business_area__c='Lead';
        ObjERP.musqot__Bar_color__c='#123344,#224466';
        insert ObjERP;
        System.assertEquals('Business area', ObjERP.musqot__Selector__c);
        
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
        
        musqot__CRM_settings__c mr=new musqot__CRM_settings__c();
        mr.musqot__Bar_color__c='test';
        mr.musqot__Chart__c='test';
        mr.musqot__CRM_performance_type__c='test';
        mr.musqot__Expression_business_area__c='test';
        mr.musqot__Expression_business_region__c='test';
        mr.musqot__Selector__c='test';
        insert mr;
        System.assertEquals('test', mr.musqot__Bar_color__c);
        
        Milestone__c objmilestone = new  Milestone__c();
        objmilestone.Name = 'test';
        objmilestone.musqot__Plan__c=objproj.id;
        objmilestone.Description__c = 'testdesc';
        objmilestone.Targetdate__c = Date.Today();
        objmilestone.Target_Socialmedia__c=OBJSocial.id;
        objmilestone.Milestone_type__c =4;
        objmilestone.musqot__Target_ERP_Sales__c=ObjERP.id;
        objmilestone.Status__c ='Open';
        objmilestone.Target_number__c=5;
        System.assertEquals('test', objmilestone.name);
        insert objmilestone;
        
        PageReference pageRef1 = Page.MilestonePage;
        Test.setCurrentPage(pageRef1); 
        ApexPages.currentPage().getParameters().put('planid', objproj.id);   
        ApexPages.currentPage().getParameters().put('id', objmilestone.id);
        String tabId = System.currentPageReference().getParameters().get('tabId');
        ApexPages.StandardController sc = new ApexPages.standardController(objmilestone); 
        MileStoneContrllor objMileston=new MileStoneContrllor (sc);
        List<SelectOption> selOpts=objMileston.SocialMedia;
        List<SelectOption> selOpts1=objMileston.ERPSales;
        objMileston.hideTargetNo=false;
        objMileston.insertMilestone();
        objMileston.cancel();
        objMileston.redirectToTemplate();
        objMileston.getRedirectToTemplate();
        objMileston.redirectToTemplate();
        objMileston.selctType();
       }
    static testmethod void MileStoneContrlloreproject(){
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
        
        Project__c objproject = new Project__c ();
        objproject.Name='test';
        //objproject.Project_type__c='test';
        objproject.Starts_date__c= System.now().date();
        objproject.Ends_date__c= System.now().date()+1;
        objproject.OwnerId=plm.userid__c;
        System.assertEquals('test', objproject.name);
        insert objproject;
        
        Subproject__c objsubproj = new Subproject__c();
        objsubproj .Name = 'test';
        objsubproj .musqot__Parent_project__c=objproject.id;
        objsubproj .Starts_date__c = Date.Today();
        objsubproj .Ends_date__c = Date.Today();
        objsubproj .Description__c = 'testdesc';
        System.assertEquals('test', objsubproj .Name);
        insert objsubproj ;
        
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        insert objMarketingact;
        System.assertEquals('test', objMarketingact.name); 
        
        
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
        ObjERP.Expression_business_region__c='APAC';
        ObjERP.musqot__Selector__c='Business area';
        ObjERP.musqot__erp_Chart__c='Bar charts';
        ObjERP.Expression_business_area__c=null;
        ObjERP.musqot__Bar_color__c='#123344,#224466';
        insert ObjERP;
        System.assertEquals('Business area', ObjERP.musqot__Selector__c);
        
        musqot__CRM_settings__c mr=new musqot__CRM_settings__c();
        mr.Name='test';
        mr.musqot__Bar_color__c='#11100';
        mr.musqot__Chart__c='Area charts';
        mr.musqot__CRM_performance_type__c='Performance, general';
        mr.musqot__Expression_business_area__c='test';
        mr.musqot__Expression_business_region__c='test';
        mr.musqot__Selector__c='test';
        insert mr;
        System.assertEquals('#11100', mr.musqot__Bar_color__c);
        
        Milestone__c objmilestone = new  Milestone__c();
        objmilestone.Name = 'test';
        objmilestone.musqot__Project__c=objsubproj.id;
        objmilestone.Description__c = 'testdesc';
        objmilestone.Targetdate__c = Date.Today();
        objmilestone.Target_Socialmedia__c=OBJSocial.id;
        objmilestone.Milestone_type__c =4;
        objmilestone.musqot__Target_ERP_Sales__c=ObjERP.id;
        objmilestone.Status__c ='Open';
        objmilestone.Target_number__c=5;
        System.assertEquals('test', objmilestone.name);
        insert objmilestone; 
        
        PageReference pageRef1 = Page.MilestonePage;
        Test.setCurrentPage(pageRef1);
        ApexPages.currentPage().getParameters().put('planid', objproject.id);        
        ApexPages.currentPage().getParameters().put('subId', objsubproj.id);
        ApexPages.currentPage().getParameters().put('mileId', objmilestone.id);
        String tabId = System.currentPageReference().getParameters().get('tabId');
        ApexPages.StandardController sc = new ApexPages.standardController(objmilestone); 
        MileStoneContrllor objMileston=new MileStoneContrllor (sc);
        list<Milestone__c >updatemilestone=[SELECT Id, Name, Plan__c, Project__c, 
                                     Target_Marketing_activity__r.Name,Target_Socialmedia__r.Name,
                                     Status__c, Target_Marketing_activity__c, Targetdate__c,Target_Project__r.Name, Target_Project__c, 
                                     Milestone_type__c, Target_Socialmedia__c, Marketing_activity__c, Target_number__c, Target_ERP_Sales__c ,Target_ERP_Sales__r.Name, 
                                     musqot__Target_ERP_Sales__r.Expression_business_region__c , musqot__Target_ERP_Sales__r.Expression_business_area__c, 
                                     Target_CRM_settings__r.musqot__Expression_business_region__c,Target_CRM_settings__r.Expression_business_area__c,Target_CRM_settings__r.Watch_type__c FROM Milestone__c where Id=:objmilestone.id];
        updatemilestone[0].Milestone_type__c =5;  
        updatemilestone[0].Status__c= 'Reach on time'; 
        update updatemilestone;                         
        List<SelectOption> temp1=objMileston.crmSettingList;
        objMileston.hideTargetNo=true;
        objMileston.insertMilestone();
        objMileston.insertMilestone();
        objMileston.cancel();
        objMileston.selctType();
        objMileston.redirectToTemplate();
        objMileston.getRedirectToTemplate();
        objMileston.redirectToTemplate();
     }              
 }