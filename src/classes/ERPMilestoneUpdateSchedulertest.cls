/****************************************************************
Class Name: ERPMilestoneUpdateSchedulertest
Author:chaithanya daggumati                  Last modified by:chaithanya daggumati
Date: 26/10/2015                             Date: 26/10/2015
Description: class to schedule the CRM data update.
********©2013 Musqot marketing technology Pvt ltd ****************/
@isTest(seeAllData=true)
public class ERPMilestoneUpdateSchedulertest{
    static testMethod void ERPmilestonesupdate(){ 
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
         objMarketingact.Name='test';
         objMarketingact.Description__c='tdescriptionest';
         objMarketingact.Status__c='completed';
         objMarketingact.musqot__ERP__c='testERP';
         objMarketingact.musqot__Social_media__c='testSocial';
         objMarketingact.musqot__CRM__c='testCRM';
         objMarketingact.Starts_date__c=Date.Today();
         objMarketingact.Ends_date__c=Date.Today();
         //objMarketingact.musqot__Activitytype__c=objActiv.id;
         insert objMarketingact;
         System.assertEquals('test', objMarketingact.name);

        musqot__ERP_Settings__c  ERPset=new musqot__ERP_Settings__c ();
        ERPset.Name='testERPEdit';
        ERPset.musqot__Selector__c='Business area';
        ERPset.musqot__erp_Chart__c='Bar charts';
        ERPset.musqot__Bar_color__c='#123344,#224466';
        ERPset.ERP_performance_type__c='Performance, project';
        ERPset.Expression_business_area__c='APAC';
        ERPset.Expression_business_region__c='Global';
        System.assertEquals('Business area', ERPset.musqot__Selector__c);
        insert ERPset;
        
        ERP_logfile__c mus=new ERP_logfile__c();
        mus.Imported__c=true;        
        mus.Import_message__c='helloworld';
        mus.Number_of_records__c=2;
        System.assertEquals('helloworld', mus.Import_message__c);
        insert mus;
        
        ERP_sales_obj__c erp=new ERP_sales_obj__c();
        erp.Business_area__c='APAC';
        erp.Business_region__c='Global';
        erp.ERP_logfile__c=mus.id;
        erp.Sales__c=200;
        erp.sales_currency__c='cur';
        erp.Sales_date__c=Date.Today();
        erp.Sales_import_date__c=Date.Today();
        erp.sales_import_id__c='saleid';
        System.assertEquals('APAC', erp.Business_area__c);
        insert erp;
        
        Milestone__c objmilestone = new  Milestone__c();
        objmilestone.Name = 'mile';
        //objmilestone.Plan__c=objproj.id;
        //objmilestone.Project__c=objsubproj .id;
        //objmilestone.Target_Project__c=objMarketingact.id;
        objmilestone.Marketing_activity__c=objMarketingact.id;
        objmilestone.Description__c = 'testdesc';
        objmilestone.Targetdate__c = Date.Today();
        objmilestone.Target_ERP_Sales__c=ERPset.id;
        objmilestone.Milestone_type__c =4;        
        objmilestone.Status__c ='Open';
        objmilestone.Target_number__c=5;
        objmilestone.Target_Achieved__c=2;
        objmilestone.Target_number_outcome__c=10;        
        insert objmilestone;
        System.assertEquals('mile', objmilestone.Name);
        
        OAuthService__c  OAuth=new OAuthService__c ();
        OAuth.Name='ffbook';
        OAuth.musqot__Authorization_Type__c='Requestheader';
        OAuth.musqot__Authorization_URL__c='https://www.facebook.com/dialog/oauth';
        OAuth.musqot__Response_Type__c='token';
        OAuth.musqot__Signature_Method__c='PLAINTEXT'; 
        OAuth.musqot__Bar_color__c='#333';   
        System.assertEquals('PLAINTEXT', OAuth.musqot__Signature_Method__c);
        insert OAuth;
        
     ERPMilestoneUpdateScheduler ERPschedule = new ERPMilestoneUpdateScheduler();
        SchedulableContext sc;
        ERPschedule.execute(sc);
        ERPschedule.getStatus(objmilestone,10);   
    }
    static testMethod void ERPmilestonesupdate1() {
     Subproject__c objsubproj = new Subproject__c();
        objsubproj .Name = 'test';
        //objsubproj .musqot__Parent_project__c=objproj.id;
        objsubproj .Starts_date__c = Date.Today();
        objsubproj .Ends_date__c = Date.Today();
        objsubproj .Description__c = 'testdesc';
        System.assertEquals('test', objsubproj .Name);
        insert objsubproj ;
        
        musqot__ERP_Settings__c  ERPset=new musqot__ERP_Settings__c ();
        ERPset.Name='testERPEdit';
        ERPset.musqot__Selector__c='Business region';
        ERPset.musqot__erp_Chart__c='Line charts';
        ERPset.musqot__Bar_color__c='#FF9933,#A700DF,#369E2B';
        ERPset.ERP_performance_type__c='Milestone';
        ERPset.Expression_business_area__c='APAC';
       // ERPset.Expression_business_region__c='Global';
        System.assertEquals('Business region', ERPset.musqot__Selector__c);
        insert ERPset;
        
        ERP_logfile__c mus=new ERP_logfile__c();
        mus.Imported__c=true;        
        mus.Import_message__c='helloworld';
        mus.Number_of_records__c=5;
        System.assertEquals('helloworld', mus.Import_message__c);
        insert mus;
        
        ERP_sales_obj__c erp=new ERP_sales_obj__c();
        erp.Business_area__c='APAC';
        erp.Business_region__c='Global';
        erp.ERP_logfile__c=mus.id;
        erp.Sales__c=200;
        erp.sales_currency__c='cur';
        erp.Sales_date__c=Date.Today();
        erp.Sales_import_date__c=Date.Today();
        erp.sales_import_id__c='saleid';
        System.assertEquals('Global', erp.Business_region__c);
        insert erp;
        
        Milestone__c objmilestone = new  Milestone__c();
        objmilestone.Name = 'mile'; 
        objmilestone.Project__c =objsubproj.id;       
        objmilestone.Description__c = 'testdesc';
        objmilestone.Targetdate__c = Date.Today();
        objmilestone.Target_ERP_Sales__c=ERPset.id;
        objmilestone.Milestone_type__c =4;        
        objmilestone.Status__c ='Open';
        objmilestone.Target_number__c=5;
        objmilestone.Target_Achieved__c=2;
        objmilestone.Target_number_outcome__c=10;        
        insert objmilestone;
        System.assertEquals('mile', objmilestone.Name);
        
     ERPMilestoneUpdateScheduler ERPschedule = new ERPMilestoneUpdateScheduler();
        SchedulableContext sc;
        ERPschedule.execute(sc);
        ERPschedule.getStatus(objmilestone,10);           
    }
     static testMethod void ERPmilestonesupdate2(){
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
        objproj.name = 'testname';
        objproj.Starts_date__c = Date.Today()-5;
        objproj.Ends_date__c =  Date.Today()-10; 
        objproj.Description__c = 'sampdesc';
        objproj.ownerid =plm.userid__c;
        System.assertEquals('testname', objproj .name);
        insert objproj;
        
        musqot__ERP_Settings__c  ERPset=new musqot__ERP_Settings__c ();
        ERPset.Name='testERPEdit';
        ERPset.musqot__Selector__c='Business region';
        ERPset.musqot__erp_Chart__c='Line charts';
        ERPset.musqot__Bar_color__c='#FF9933,#A700DF,#369E2B';
        ERPset.ERP_performance_type__c='Milestone';
        ERPset.Expression_business_area__c='APAC';
        //ERPset.Expression_business_region__c='Global';
        System.assertEquals('Business region', ERPset.musqot__Selector__c);
        insert ERPset;
        
        ERP_logfile__c mus=new ERP_logfile__c();
        mus.Imported__c=true;        
        mus.Import_message__c='helloworld';
        mus.Number_of_records__c=5;
        System.assertEquals('helloworld', mus.Import_message__c);
        insert mus;
        
        ERP_sales_obj__c erp=new ERP_sales_obj__c();
        erp.Business_area__c='APAC';
        erp.Business_region__c='Global';
        erp.ERP_logfile__c=mus.id;
        erp.Sales__c=200;
        erp.sales_currency__c='cur';
        erp.Sales_date__c=Date.Today();
        erp.Sales_import_date__c=Date.Today();
        erp.sales_import_id__c='saleid';
        System.assertEquals('Global', erp.Business_region__c);
        insert erp;
        
        Milestone__c objmilestone = new  Milestone__c();
        objmilestone.Name = 'mile';  
        objmilestone.Plan__c=objproj.id;      
        objmilestone.Description__c = 'testdesc';
        objmilestone.Targetdate__c = Date.Today();
        objmilestone.Target_ERP_Sales__c=ERPset.id;
        objmilestone.Milestone_type__c =4;        
        objmilestone.Status__c ='Open';
        objmilestone.Target_number__c=5;
        objmilestone.Target_Achieved__c=2;
        objmilestone.Target_number_outcome__c=10;        
        insert objmilestone;
        System.assertEquals('mile', objmilestone.Name);
        
        ERPMilestoneUpdateScheduler ERPschedule = new ERPMilestoneUpdateScheduler();
        SchedulableContext sc;
        ERPschedule.execute(sc);
        ERPschedule.getStatus(objmilestone,10);           
    }
    static testMethod void ERPmilestonesupdate3(){
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
        objproj.name = 'testname';
        objproj.Starts_date__c = Date.Today()-5;
        objproj.Ends_date__c =  Date.Today()-10; 
        objproj.Description__c = 'sampdesc';
        objproj.ownerid =plm.userid__c;
        System.assertEquals('testname', objproj .name);
        insert objproj;
        
        musqot__ERP_Settings__c  ERPset=new musqot__ERP_Settings__c ();
        ERPset.Name='testERPEdit';
        ERPset.musqot__Selector__c='Business region';
        ERPset.musqot__erp_Chart__c='Line charts';
        ERPset.musqot__Bar_color__c='#FF9933,#A700DF,#369E2B';
        ERPset.ERP_performance_type__c='Milestone';
        ERPset.Expression_business_area__c='';
        ERPset.Expression_business_region__c='Global';
        System.assertEquals('Business region', ERPset.musqot__Selector__c);
        insert ERPset;
        
        ERP_logfile__c mus=new ERP_logfile__c();
        mus.Imported__c=true;        
        mus.Import_message__c='helloworld';
        mus.Number_of_records__c=5;
        System.assertEquals('helloworld', mus.Import_message__c);
        insert mus;
        
        ERP_sales_obj__c erp=new ERP_sales_obj__c();
        //erp.Business_area__c='APAC';
        erp.Business_region__c='Global';
        erp.ERP_logfile__c=mus.id;
        erp.Sales__c=200;
        erp.sales_currency__c='cur';
        erp.Sales_date__c=Date.Today();
        erp.Sales_import_date__c=Date.Today();
        erp.sales_import_id__c='saleid';
        System.assertEquals('Global', erp.Business_region__c);
        insert erp;
        
        Milestone__c objmilestone = new  Milestone__c();
        objmilestone.Name = 'mile';  
        objmilestone.Plan__c=objproj.id;      
        objmilestone.Description__c = 'testdesc';
        objmilestone.Targetdate__c = Date.Today();
        objmilestone.Target_ERP_Sales__c=ERPset.id;
        objmilestone.Milestone_type__c =4;        
        objmilestone.Status__c ='Open';
        objmilestone.Target_number__c=5;
        objmilestone.Target_Achieved__c=2;
        objmilestone.Target_number_outcome__c=10;        
        insert objmilestone;
        System.assertEquals('mile', objmilestone.Name);
        
        ERPMilestoneUpdateScheduler ERPschedule = new ERPMilestoneUpdateScheduler();
        SchedulableContext sc;
        ERPschedule.execute(sc);
        ERPschedule.getStatus(objmilestone,10);           
    }
     static testMethod void ERPmilestonesupdate4() {
     Subproject__c objsubproj = new Subproject__c();
        objsubproj .Name = 'test';
        //objsubproj .musqot__Parent_project__c=objproj.id;
        objsubproj .Starts_date__c = Date.Today();
        objsubproj .Ends_date__c = Date.Today();
        objsubproj .Description__c = 'testdesc';
        System.assertEquals('test', objsubproj .Name);
        insert objsubproj ;
        
        musqot__ERP_Settings__c  ERPset=new musqot__ERP_Settings__c ();
        ERPset.Name='testERPEdit';
        ERPset.musqot__Selector__c='Business region';
        ERPset.musqot__erp_Chart__c='Line charts';
        ERPset.musqot__Bar_color__c='#FF9933,#A700DF,#369E2B';
        ERPset.ERP_performance_type__c='Milestone';
        //ERPset.Expression_business_area__c='APAC';
        ERPset.Expression_business_region__c='Global';
        System.assertEquals('Business region', ERPset.musqot__Selector__c);
        insert ERPset;
        
        ERP_logfile__c mus=new ERP_logfile__c();
        mus.Imported__c=true;        
        mus.Import_message__c='helloworld';
        mus.Number_of_records__c=5;
        System.assertEquals('helloworld', mus.Import_message__c);
        insert mus;
        
        ERP_sales_obj__c erp=new ERP_sales_obj__c();
        //erp.Business_area__c='APAC';
        erp.Business_region__c='Global';
        erp.ERP_logfile__c=mus.id;
        erp.Sales__c=200;
        erp.sales_currency__c='cur';
        erp.Sales_date__c=Date.Today();
        erp.Sales_import_date__c=Date.Today();
        erp.sales_import_id__c='saleid';
        System.assertEquals('Global', erp.Business_region__c);
        insert erp;
        System.assertEquals(null, erp.Business_area__c);
        
        Milestone__c objmilestone = new  Milestone__c();
        objmilestone.Name = 'mile'; 
        objmilestone.Project__c =objsubproj.id;       
        objmilestone.Description__c = 'testdesc';
        objmilestone.Targetdate__c = Date.Today();
        objmilestone.Target_ERP_Sales__c=ERPset.id;
        objmilestone.Milestone_type__c =4;        
        objmilestone.Status__c ='Open';
        objmilestone.Target_number__c=5;
        objmilestone.Target_Achieved__c=2;
        objmilestone.Target_number_outcome__c=10;        
        insert objmilestone;
        System.assertEquals('mile', objmilestone.Name);
        
     ERPMilestoneUpdateScheduler ERPschedule = new ERPMilestoneUpdateScheduler();
        SchedulableContext sc;
        ERPschedule.execute(sc);
        ERPschedule.getStatus(objmilestone,10);           
    }
     static testMethod void ERPmilestonesupdate6(){ 
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
         objMarketingact.Name='test';
         objMarketingact.Description__c='tdescriptionest';
         objMarketingact.Status__c='completed';
         objMarketingact.musqot__ERP__c='testERP';
         objMarketingact.musqot__Social_media__c='testSocial';
         objMarketingact.musqot__CRM__c='testCRM';
         objMarketingact.Starts_date__c=Date.Today();
         objMarketingact.Ends_date__c=Date.Today();
         //objMarketingact.musqot__Activitytype__c=objActiv.id;
         insert objMarketingact;
         System.assertEquals('test', objMarketingact.name);

        musqot__ERP_Settings__c  ERPset=new musqot__ERP_Settings__c ();
        ERPset.Name='testERPEdit';
        ERPset.musqot__Selector__c='Business area';
        ERPset.musqot__erp_Chart__c='Bar charts';
        ERPset.musqot__Bar_color__c='#123344,#224466';
        ERPset.ERP_performance_type__c='Performance, project';
        ERPset.Expression_business_area__c='APAC';
        //ERPset.Expression_business_region__c='Global';
        System.assertEquals('Business area', ERPset.musqot__Selector__c);
        insert ERPset;
        
        ERP_logfile__c mus=new ERP_logfile__c();
        mus.Imported__c=true;        
        mus.Import_message__c='helloworld';
        mus.Number_of_records__c=2;
        System.assertEquals('helloworld', mus.Import_message__c);
        insert mus;
        
        ERP_sales_obj__c erp=new ERP_sales_obj__c();
        erp.Business_area__c='APAC';
       // erp.Business_region__c='Global';
        erp.ERP_logfile__c=mus.id;
        erp.Sales__c=200;
        erp.sales_currency__c='cur';
        erp.Sales_date__c=Date.Today();
        erp.Sales_import_date__c=Date.Today();
        erp.sales_import_id__c='saleid';
        System.assertEquals('APAC', erp.Business_area__c);
        insert erp;
        
        Milestone__c objmilestone = new  Milestone__c();
        objmilestone.Name = 'mile';
        //objmilestone.Plan__c=objproj.id;
        //objmilestone.Project__c=objsubproj .id;
        //objmilestone.Target_Project__c=objMarketingact.id;
        objmilestone.Marketing_activity__c=objMarketingact.id;
        objmilestone.Description__c = 'testdesc';
        objmilestone.Targetdate__c = Date.Today();
        objmilestone.Target_ERP_Sales__c=ERPset.id;
        objmilestone.Milestone_type__c =4;        
        objmilestone.Status__c ='Open';
        objmilestone.Target_number__c=5;
        objmilestone.Target_Achieved__c=2;
        objmilestone.Target_number_outcome__c=10;        
        insert objmilestone;
        System.assertEquals('mile', objmilestone.Name);
        
        OAuthService__c  OAuth=new OAuthService__c ();
        OAuth.Name='ffbook';
        OAuth.musqot__Authorization_Type__c='Requestheader';
        OAuth.musqot__Authorization_URL__c='https://www.facebook.com/dialog/oauth';
        OAuth.musqot__Response_Type__c='token';
        OAuth.musqot__Signature_Method__c='PLAINTEXT'; 
        OAuth.musqot__Bar_color__c='#333';   
        System.assertEquals('PLAINTEXT', OAuth.musqot__Signature_Method__c);
        insert OAuth;
        
     ERPMilestoneUpdateScheduler ERPschedule = new ERPMilestoneUpdateScheduler();
        SchedulableContext sc;
        ERPschedule.execute(sc);
        ERPschedule.getStatus(objmilestone,10);   
    }
    static testMethod void ERPmilestonesupdate5(){ 
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
         objMarketingact.Name='test';
         objMarketingact.Description__c='tdescriptionest';
         objMarketingact.Status__c='completed';
         objMarketingact.musqot__ERP__c='testERP';
         objMarketingact.musqot__Social_media__c='testSocial';
         objMarketingact.musqot__CRM__c='testCRM';
         objMarketingact.Starts_date__c=Date.Today();
         objMarketingact.Ends_date__c=Date.Today();
         //objMarketingact.musqot__Activitytype__c=objActiv.id;
         insert objMarketingact;
         System.assertEquals('test', objMarketingact.name);

        musqot__ERP_Settings__c  ERPset=new musqot__ERP_Settings__c ();
        ERPset.Name='testERPEdit';
        ERPset.musqot__Selector__c='Business area';
        ERPset.musqot__erp_Chart__c='Bar charts';
        ERPset.musqot__Bar_color__c='#123344,#224466';
        ERPset.ERP_performance_type__c='Performance, project';
        //ERPset.Expression_business_area__c='APAC';
        ERPset.Expression_business_region__c='Global';
        System.assertEquals('Business area', ERPset.musqot__Selector__c);
        insert ERPset;
        
        ERP_logfile__c mus=new ERP_logfile__c();
        mus.Imported__c=true;        
        mus.Import_message__c='helloworld';
        mus.Number_of_records__c=2;
        System.assertEquals('helloworld', mus.Import_message__c);
        insert mus;
        
        ERP_sales_obj__c erp=new ERP_sales_obj__c();
        //erp.Business_area__c='APAC';
        erp.Business_region__c='Global';
        erp.ERP_logfile__c=mus.id;
        erp.Sales__c=200;
        erp.sales_currency__c='cur';
        erp.Sales_date__c=Date.Today();
        erp.Sales_import_date__c=Date.Today();
        erp.sales_import_id__c='saleid';
        insert erp;
        System.assertEquals(null, erp.Business_area__c);
        System.assertEquals('Global', erp.Business_region__c);
         
        Milestone__c objmilestone = new  Milestone__c();
        objmilestone.Name = 'mile';
        //objmilestone.Plan__c=objproj.id;
        //objmilestone.Project__c=objsubproj .id;
        //objmilestone.Target_Project__c=objMarketingact.id;
        objmilestone.Marketing_activity__c=objMarketingact.id;
        objmilestone.Description__c = 'testdesc';
        objmilestone.Targetdate__c = Date.Today();
        objmilestone.Target_ERP_Sales__c=ERPset.id;
        objmilestone.Milestone_type__c =4;        
        objmilestone.Status__c ='Open';
        objmilestone.Target_number__c=5;
        objmilestone.Target_Achieved__c=2;
        objmilestone.Target_number_outcome__c=10;        
        insert objmilestone;
        System.assertEquals('mile', objmilestone.Name);
        
        OAuthService__c  OAuth=new OAuthService__c ();
        OAuth.Name='ffbook';
        OAuth.musqot__Authorization_Type__c='Requestheader';
        OAuth.musqot__Authorization_URL__c='https://www.facebook.com/dialog/oauth';
        OAuth.musqot__Response_Type__c='token';
        OAuth.musqot__Signature_Method__c='PLAINTEXT'; 
        OAuth.musqot__Bar_color__c='#333';   
        System.assertEquals('PLAINTEXT', OAuth.musqot__Signature_Method__c);
        insert OAuth;
        
     ERPMilestoneUpdateScheduler ERPschedule = new ERPMilestoneUpdateScheduler();
        SchedulableContext sc;
        ERPschedule.execute(sc);
        ERPschedule.getStatus(objmilestone,10);   
    }
     static testMethod void ERPmilestonesupdatetestm(){ 
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
         objMarketingact.Name='test';
         objMarketingact.Description__c='tdescriptionest';
         objMarketingact.Status__c='completed';
         objMarketingact.musqot__ERP__c='testERP';
         objMarketingact.musqot__Social_media__c='testSocial';
         objMarketingact.musqot__CRM__c='testCRM';
         objMarketingact.Starts_date__c=Date.Today();
         objMarketingact.Ends_date__c=Date.Today();
         //objMarketingact.musqot__Activitytype__c=objActiv.id;
         insert objMarketingact;
         System.assertEquals('test', objMarketingact.name);

        musqot__ERP_Settings__c  ERPset=new musqot__ERP_Settings__c ();
        ERPset.Name='testERPEdit';
        ERPset.musqot__Selector__c='Business area';
        ERPset.musqot__erp_Chart__c='Bar charts';
        ERPset.musqot__Bar_color__c='#123344,#224466';
        ERPset.ERP_performance_type__c='Performance, project';
        ERPset.Expression_business_area__c='APAC';
        //ERPset.Expression_business_region__c='Global';
        System.assertEquals('Business area', ERPset.musqot__Selector__c);
        insert ERPset;
        
        ERP_logfile__c mus=new ERP_logfile__c();
        mus.Imported__c=true;        
        mus.Import_message__c='helloworld';
        mus.Number_of_records__c=2;
        System.assertEquals('helloworld', mus.Import_message__c);
        insert mus;
        
        ERP_sales_obj__c erp=new ERP_sales_obj__c();
        erp.Business_area__c='APAC';
        erp.Business_region__c='Global';
        erp.ERP_logfile__c=mus.id;
        erp.Sales__c=200;
        erp.sales_currency__c='cur';
        erp.Sales_date__c=Date.Today();
        erp.Sales_import_date__c=Date.Today();
        erp.sales_import_id__c='saleid';
        System.assertEquals('APAC', erp.Business_area__c);
        insert erp;
        
        Milestone__c objmilestone = new  Milestone__c();
        objmilestone.Name = 'mile';
        //objmilestone.Plan__c=objproj.id;
        //objmilestone.Project__c=objsubproj .id;
        //objmilestone.Target_Project__c=objMarketingact.id;
        objmilestone.Marketing_activity__c=objMarketingact.id;
        objmilestone.Description__c = 'testdesc';
        objmilestone.Targetdate__c = Date.Today();
        objmilestone.Target_ERP_Sales__c=ERPset.id;
        objmilestone.Milestone_type__c =4;        
        objmilestone.Status__c ='Open';
        objmilestone.Target_number__c=5;
        objmilestone.Target_Achieved__c=2;
        objmilestone.Target_number_outcome__c=10;        
        insert objmilestone;
        System.assertEquals('mile', objmilestone.Name);
        
     ERPMilestoneUpdateScheduler ERPschedule = new ERPMilestoneUpdateScheduler();
        SchedulableContext sc;
        ERPschedule.execute(sc);
        ERPschedule.getStatus(objmilestone,10);   
    }
    static testMethod void ERPmilestonesupdatetestmxx(){ 
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
         objMarketingact.Name='test';
         objMarketingact.Description__c='tdescriptionest';
         objMarketingact.Status__c='completed';
         objMarketingact.musqot__ERP__c='testERP';
         objMarketingact.musqot__Social_media__c='testSocial';
         objMarketingact.musqot__CRM__c='testCRM';
         objMarketingact.Starts_date__c=Date.Today()-1;
         objMarketingact.Ends_date__c=Date.Today()-2;
         //objMarketingact.musqot__Activitytype__c=objActiv.id;
         insert objMarketingact;
         System.assertEquals('test', objMarketingact.name);

        musqot__ERP_Settings__c  ERPset=new musqot__ERP_Settings__c ();
        ERPset.Name='testERPEdit';
        ERPset.musqot__Selector__c='Business area';
        ERPset.musqot__erp_Chart__c='Bar charts';
        ERPset.musqot__Bar_color__c='#123344,#224466';
        ERPset.ERP_performance_type__c='Performance, project';
        //ERPset.Expression_business_area__c='APAC';
        ERPset.Expression_business_region__c='Global';
        System.assertEquals('Business area', ERPset.musqot__Selector__c);
        insert ERPset;
        
        ERP_logfile__c mus=new ERP_logfile__c();
        mus.Imported__c=true;        
        mus.Import_message__c='helloworld';
        mus.Number_of_records__c=2;
        System.assertEquals('helloworld', mus.Import_message__c);
        insert mus;
        
        ERP_sales_obj__c erp=new ERP_sales_obj__c();
        erp.Business_area__c='APAC';
        erp.Business_region__c='Global';
        erp.ERP_logfile__c=mus.id;
        erp.Sales__c=200;
        erp.sales_currency__c='cur';
        erp.Sales_date__c=Date.Today();
        erp.Sales_import_date__c=Date.Today();
        erp.sales_import_id__c='saleid';
        System.assertEquals('APAC', erp.Business_area__c);
        insert erp;
        
        Milestone__c objmilestone = new  Milestone__c();
        objmilestone.Name = 'mile';
        //objmilestone.Plan__c=objproj.id;
        //objmilestone.Project__c=objsubproj .id;
        //objmilestone.Target_Project__c=objMarketingact.id;
        objmilestone.Marketing_activity__c=objMarketingact.id;
        objmilestone.Description__c = 'testdesc';
        objmilestone.Targetdate__c = Date.Today();
        objmilestone.Target_ERP_Sales__c=ERPset.id;
        objmilestone.Milestone_type__c =4;        
        objmilestone.Status__c ='Open';
        objmilestone.Target_number__c=5;
        objmilestone.Target_Achieved__c=2;
        objmilestone.Target_number_outcome__c=10;        
        insert objmilestone;
        System.assertEquals('mile', objmilestone.Name);
        
        ERPMilestoneUpdateScheduler ERPschedule = new ERPMilestoneUpdateScheduler();
        SchedulableContext sc;
        ERPschedule.execute(sc);
        //ERPschedule.TargetNumber_Sales=0;
        ERPschedule.getStatus(objmilestone,10);   
    }
}