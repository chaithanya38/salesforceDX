/****************************************************************
Class Name: CRMMilestoneUpdateSchedulertest
Author:chaithanya daggumati                  Last modified by:Raju GN
Date: 19/10/2015                             Date: 29/10/2015
Description: class to schedule the CRM data update.
********©2013 Musqot marketing technology Pvt ltd ****************/
@isTest(seeAllData=true)
public class CRMMilestoneUpdateSchedulertest{
    static testMethod void CRMmilestonesupdate(){
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
        objproj .Starts_date__c = System.now().date()-10;
        objproj .Ends_date__c =  System.now().date()-5; 
        objproj .Description__c = 'sampdesc';
        objproj.ownerid =plm.userid__c;
        System.assertEquals('testname', objproj .name);
        insert objproj;
        
        Subproject__c objsubproj = new Subproject__c();
        objsubproj .Name = 'test';
        objsubproj .musqot__Parent_project__c=objproj.id;
        objsubproj .Starts_date__c = System.now().date()-5;
        objsubproj .Ends_date__c = System.now().date()-5;
        objsubproj .Description__c = 'testdesc';
        System.assertEquals('test', objsubproj .Name);
        insert objsubproj ;
        
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
         objMarketingact.Name='test';
         objMarketingact.musqot__Project__c=objsubproj.id;
         objMarketingact.Description__c='tdescriptionest';
         objMarketingact.Status__c='completed';
         objMarketingact.musqot__ERP__c='testERP';
         objMarketingact.musqot__Social_media__c='testSocial';
         objMarketingact.musqot__CRM__c='testCRM';
         objMarketingact.Starts_date__c=System.today()-10;
         objMarketingact.Ends_date__c=System.today()-10;
         //objMarketingact.musqot__Activitytype__c=objActiv.id;
         insert objMarketingact;
         System.assertEquals('test', objMarketingact.name);
        
        CRM_settings__c mr=new CRM_settings__c();
        mr.Name='crm';
        mr.Bar_color__c='#369E2B';
        mr.Chart__c='Bar charts';
        mr.CRM_performance_type__c='Milestone';
        mr.Expression_business_area__c='Campaign';
        mr.Expression_business_region__c='Lead Source';
        mr.Selector__c='Lead Source';
        mr.Watch_type__c='No Leads';
        insert mr;
        System.assertEquals('Bar charts', mr.Chart__c);
        
        musqot__CRM_logfile__c log=new musqot__CRM_logfile__c();
        log.musqot__Imported__c=true;
        log.musqot__Import_message__c='test';
        log.musqot__Number_of_records__c=2;
        insert log;
      
      CRM_data__c crm=new CRM_data__c();
      crm.Name='file';
      crm.musqot__Business_area__c='Campaign';
      crm.musqot__Business_region__c='Lead Source';
      crm.musqot__CRM_import_date__c=System.now().date();
      crm.musqot__CRM_import_id__c='id';
      crm.musqot__CRM_logfile__c=log.id;
      crm.musqot__Date__c=System.today()-1;
      crm.musqot__No_Deals__c=4;
      crm.musqot__No_Leads__c=4;
      crm.musqot__No_Opportunities__c=4;
      crm.musqot__Value_Deals__c=25.50;
      crm.musqot__Value_w_Opportunities__c=30.55;
      crm.musqot__Value_Opportunities__c=10.50;
      insert crm;
      
        Milestone__c objmilestone = new  Milestone__c();
        objmilestone.Name = 'mile';
        //objmilestone.musqot__Plan__c=objproj.id;
        objmilestone.Project__c=objsubproj .id;
        objmilestone.Target_Project__c=objsubproj .id;
        objmilestone.Marketing_activity__c=objMarketingact.id;
       // objmilestone.Target_Marketing_activity__c=objMarketingact.id;
        objmilestone.Description__c = 'testdesc';
        objmilestone.Targetdate__c = Date.Today()+1;
        objmilestone.Target_CRM_settings__c=mr.id;
        objmilestone.Milestone_type__c =5;        
        objmilestone.Status__c ='Open';
        objmilestone.Target_number__c=5;
        objmilestone.Target_number_outcome__c=1;        
        insert objmilestone;
        System.assertEquals('mile', objmilestone.Name);

        CRMMilestoneUpdateScheduler CRMschedule = new CRMMilestoneUpdateScheduler();
        SchedulableContext sc;
        CRMschedule.execute(sc);
        CRMschedule.getStatus(objmilestone,10);
        CRMschedule.startDate=Date.Today()-5;        
     }
 static testMethod void CRMmilestonesupdate11(){
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
        objproj .Starts_date__c = System.now().date()-10;
        objproj .Ends_date__c =  System.now().date()-5; 
        objproj .Description__c = 'sampdesc';
     	objproj.ownerid =plm.userid__c;
        System.assertEquals('testname', objproj .name);
        insert objproj;
        
        Subproject__c objsubproj = new Subproject__c();
        objsubproj .Name = 'test';
        objsubproj .musqot__Parent_project__c=objproj.id;
        objsubproj .Starts_date__c = System.now().date()-5;
        objsubproj .Ends_date__c = System.now().date()-5;
        objsubproj .Description__c = 'testdesc';
        System.assertEquals('test', objsubproj .Name);
        insert objsubproj ;
        
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
         objMarketingact.Name='test';
         objMarketingact.musqot__Project__c=objsubproj.id;
         objMarketingact.Description__c='tdescriptionest';
         objMarketingact.Status__c='completed';
         objMarketingact.musqot__ERP__c='testERP';
         objMarketingact.musqot__Social_media__c='testSocial';
         objMarketingact.musqot__CRM__c='testCRM';
         objMarketingact.Starts_date__c=System.today()-10;
         objMarketingact.Ends_date__c=System.today()-10;
         //objMarketingact.musqot__Activitytype__c=objActiv.id;
         insert objMarketingact;
         System.assertEquals('test', objMarketingact.name);
        
        CRM_settings__c mr=new CRM_settings__c();
        mr.Name='crm';
        mr.Bar_color__c='#369E2B';
        mr.Chart__c='Bar charts';
        mr.CRM_performance_type__c='Milestone';
        mr.Expression_business_area__c='Campaign';
        mr.Expression_business_region__c='Lead Source';
        mr.Selector__c='Lead Source';
        mr.Watch_type__c='No Opportunities';
        insert mr;
        System.assertEquals('Bar charts', mr.Chart__c);
        
        musqot__CRM_logfile__c log=new musqot__CRM_logfile__c();
        log.musqot__Imported__c=true;
        log.musqot__Import_message__c='test';
        log.musqot__Number_of_records__c=2;
        insert log;
      
      CRM_data__c crm=new CRM_data__c();
      crm.Name='file';
      crm.musqot__Business_area__c='Campaign';
      crm.musqot__Business_region__c='Lead Source';
      crm.musqot__CRM_import_date__c=System.now().date();
      crm.musqot__CRM_import_id__c='id';
      crm.musqot__CRM_logfile__c=log.id;
      crm.musqot__Date__c=System.today()-1;
      crm.musqot__No_Deals__c=4;
      crm.musqot__No_Leads__c=4;
      crm.musqot__No_Opportunities__c=4;
      crm.musqot__Value_Deals__c=25.50;
      crm.musqot__Value_w_Opportunities__c=30.55;
      crm.musqot__Value_Opportunities__c=10.50;
      insert crm;

        Milestone__c objmilestone = new  Milestone__c();
        objmilestone.Name = 'mile';
        //objmilestone.musqot__Plan__c=objproj.id;
        //objmilestone.Project__c=objsubproj .id;
        objmilestone.Target_Project__c=objsubproj .id;
        objmilestone.Marketing_activity__c=objMarketingact.id;
        objmilestone.Target_Marketing_activity__c=objMarketingact.id;
        objmilestone.Description__c = 'testdesc';
        objmilestone.Targetdate__c = Date.Today()-1;
        objmilestone.Target_CRM_settings__c=mr.id;
        objmilestone.Milestone_type__c =5;        
        objmilestone.Status__c ='Open';
        objmilestone.Target_number__c=5;
        objmilestone.Target_number_outcome__c=1;        
        insert objmilestone;
        System.assertEquals('mile', objmilestone.Name);

     CRMMilestoneUpdateScheduler CRMschedule = new CRMMilestoneUpdateScheduler();
        SchedulableContext sc;
        CRMschedule.execute(sc);
        CRMschedule.getStatus(objmilestone,10);
        CRMschedule.startDate=Date.Today();        
     }
 static testMethod void CRMmilestonesupdate1(){
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
        objproj .Starts_date__c = System.now().date()-10;
        objproj .Ends_date__c =  System.now().date()-5; 
        objproj .Description__c = 'sampdesc';
     	objproj.ownerid =plm.userid__c;
        System.assertEquals('testname', objproj .name);
        insert objproj;
        
        Subproject__c objsubproj = new Subproject__c();
        objsubproj .Name = 'test';
        objsubproj .musqot__Parent_project__c=objproj.id;
        objsubproj .Starts_date__c = System.now().date();
        objsubproj .Ends_date__c = System.now().date();
        objsubproj .Description__c = 'testdesc';
        System.assertEquals('test', objsubproj .Name);
        insert objsubproj ;
        
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
         objMarketingact.Name='test';
         objMarketingact.Description__c='tdescriptionest';
         objMarketingact.Status__c='completed';
         objMarketingact.musqot__ERP__c='testERP';
         objMarketingact.musqot__Social_media__c='testSocial';
         objMarketingact.musqot__CRM__c='testCRM';
         objMarketingact.Starts_date__c=System.today()-10;
         objMarketingact.Ends_date__c=System.today()-10;
         //objMarketingact.musqot__Activitytype__c=objActiv.id;
         insert objMarketingact;
         System.assertEquals('test', objMarketingact.name);
        
        CRM_settings__c mr=new CRM_settings__c();
        mr.Name='crm';
        mr.Bar_color__c='#369E2B';
        mr.Chart__c='Bar charts';
        mr.CRM_performance_type__c='Milestone';
        mr.Expression_business_area__c='Campaign';
       // mr.Expression_business_region__c='Lead Source';
        mr.Selector__c='Lead Source';
        mr.Watch_type__c='Amount Opportunities';
        insert mr;
        System.assertEquals('Bar charts', mr.Chart__c);
        
        musqot__CRM_logfile__c log=new musqot__CRM_logfile__c();
        log.musqot__Imported__c=true;
        log.musqot__Import_message__c='test';
        log.musqot__Number_of_records__c=2;
        insert log;
      
      CRM_data__c crm=new CRM_data__c();
      crm.Name='file';
      crm.musqot__Business_area__c='Campaign';
     // crm.musqot__Business_region__c='Global';
      crm.musqot__CRM_import_date__c=System.now().date();
      crm.musqot__CRM_import_id__c='id';
      crm.musqot__CRM_logfile__c=log.id;
      crm.musqot__Date__c=System.today();
      crm.musqot__No_Deals__c=4;
      crm.musqot__No_Leads__c=4;
      crm.musqot__No_Opportunities__c=4;
      crm.musqot__Value_Deals__c=25.50;
      crm.musqot__Value_w_Opportunities__c=30.55;
      crm.musqot__Value_Opportunities__c=10.50;
      insert crm;

        Milestone__c objmilestone = new  Milestone__c();
        objmilestone.Name = 'mile';
        objmilestone.musqot__Plan__c=objproj.id;
        //objmilestone.Project__c=objsubproj .id;
        objmilestone.Target_Project__c=objsubproj .id;
        //objmilestone.Marketing_activity__c=objMarketingact.id;
       // objmilestone.Target_Marketing_activity__c=objMarketingact.id;
        objmilestone.Description__c = 'testdesc';
        objmilestone.Targetdate__c = Date.Today();
        objmilestone.Target_CRM_settings__c=mr.id;
        objmilestone.Milestone_type__c =5;        
        objmilestone.Status__c ='Open';
        objmilestone.Target_number__c=0;
        objmilestone.Target_number_outcome__c=1;        
        insert objmilestone;
        System.assertEquals('mile', objmilestone.Name);

     CRMMilestoneUpdateScheduler CRMschedule = new CRMMilestoneUpdateScheduler();
        SchedulableContext sc;
        CRMschedule.execute(sc);
        CRMschedule.getStatus(objmilestone,10);
        CRMschedule.startDate=Date.Today();        
     }
  static testMethod void CRMmilestonesupdate2(){
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
        objproj .Starts_date__c = System.now().date()-10;
        objproj .Ends_date__c =  System.now().date()-5; 
        objproj .Description__c = 'sampdesc';
      	objproj.ownerid =plm.userid__c;
        System.assertEquals('testname', objproj .name);
        insert objproj;
        
        Subproject__c objsubproj = new Subproject__c();
        objsubproj .Name = 'test';
        objsubproj .musqot__Parent_project__c=objproj.id;
        objsubproj .Starts_date__c = System.now().date();
        objsubproj .Ends_date__c = System.now().date();
        objsubproj .Description__c = 'testdesc';
        System.assertEquals('test', objsubproj .Name);
        insert objsubproj ;
        
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
         objMarketingact.Name='test';
         objMarketingact.Description__c='tdescriptionest';
         objMarketingact.Status__c='completed';
         objMarketingact.musqot__ERP__c='testERP';
         objMarketingact.musqot__Social_media__c='testSocial';
         objMarketingact.musqot__CRM__c='testCRM';
         objMarketingact.Starts_date__c=System.today()-10;
         objMarketingact.Ends_date__c=System.today()-10;
         //objMarketingact.musqot__Activitytype__c=objActiv.id;
         insert objMarketingact;
         System.assertEquals('test', objMarketingact.name);
        
        CRM_settings__c mr=new CRM_settings__c();
        mr.Name='crm';
        mr.Bar_color__c='#369E2B';
        mr.Chart__c='Bar charts';
        mr.CRM_performance_type__c='Milestone';
        mr.Expression_business_area__c='Campaign';
       // mr.Expression_business_region__c='Lead Source';
        mr.Selector__c='Lead Source';
        mr.Watch_type__c='No Wins';
        insert mr;
        System.assertEquals('Bar charts', mr.Chart__c);
        
        musqot__CRM_logfile__c log=new musqot__CRM_logfile__c();
        log.musqot__Imported__c=true;
        log.musqot__Import_message__c='test';
        log.musqot__Number_of_records__c=2;
        insert log;
      
      CRM_data__c crm=new CRM_data__c();
      crm.Name='file';
      crm.musqot__Business_area__c='Campaign';
      //crm.musqot__Business_region__c='Global';
      crm.musqot__CRM_import_date__c=System.now().date();
      crm.musqot__CRM_import_id__c='id';
      crm.musqot__CRM_logfile__c=log.id;
      crm.musqot__Date__c=System.today();
      crm.musqot__No_Deals__c=4;
      crm.musqot__No_Leads__c=4;
      crm.musqot__No_Opportunities__c=4;
      crm.musqot__Value_Deals__c=25.50;
      crm.musqot__Value_w_Opportunities__c=30.55;
      crm.musqot__Value_Opportunities__c=10.50;
      insert crm;

        Milestone__c objmilestone = new  Milestone__c();
        objmilestone.Name = 'mile';
        //objmilestone.musqot__Plan__c=objproj.id;
        objmilestone.Project__c=objsubproj .id;
        objmilestone.Target_Project__c=objsubproj .id;
        //objmilestone.Marketing_activity__c=objMarketingact.id;
       // objmilestone.Target_Marketing_activity__c=objMarketingact.id;
        objmilestone.Description__c = 'testdesc';
        objmilestone.Targetdate__c = Date.Today();
        objmilestone.Target_CRM_settings__c=mr.id;
        objmilestone.Milestone_type__c =5;        
        objmilestone.Status__c ='Open';
        objmilestone.Target_number__c=5;
        objmilestone.Target_number_outcome__c=1;        
        insert objmilestone;
        System.assertEquals('mile', objmilestone.Name);

     CRMMilestoneUpdateScheduler CRMschedule = new CRMMilestoneUpdateScheduler();
        SchedulableContext sc;
        CRMschedule.execute(sc);
        CRMschedule.getStatus(objmilestone,10);
        CRMschedule.startDate=Date.Today();        
     }
  static testMethod void CRMmilestonesupdates22(){
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
        objproj .Starts_date__c = System.now().date()-10;
        objproj .Ends_date__c =  System.now().date()-5; 
        objproj .Description__c = 'sampdesc';
      	objproj.ownerid =plm.userid__c;
        System.assertEquals('testname', objproj .name);
        insert objproj;
        
        Subproject__c objsubproj = new Subproject__c();
        objsubproj .Name = 'test';
        objsubproj .musqot__Parent_project__c=objproj.id;
        objsubproj .Starts_date__c = System.now().date();
        objsubproj .Ends_date__c = System.now().date();
        objsubproj .Description__c = 'testdesc';
        System.assertEquals('test', objsubproj .Name);
        insert objsubproj ;
        
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
         objMarketingact.Name='test';
         objMarketingact.Description__c='tdescriptionest';
         objMarketingact.Status__c='completed';
         objMarketingact.musqot__ERP__c='testERP';
         objMarketingact.musqot__Social_media__c='testSocial';
         objMarketingact.musqot__CRM__c='testCRM';
         objMarketingact.Starts_date__c=System.today()-10;
         objMarketingact.Ends_date__c=System.today()-10;
         //objMarketingact.musqot__Activitytype__c=objActiv.id;
         insert objMarketingact;
         System.assertEquals('test', objMarketingact.name);
        
        CRM_settings__c mr=new CRM_settings__c();
        mr.Name='crm';
        mr.Bar_color__c='#369E2B';
        mr.Chart__c='Bar charts';
        mr.CRM_performance_type__c='Milestone';
        mr.Expression_business_area__c='Campaign';
        mr.Expression_business_region__c='3000';
        mr.Selector__c='Lead Source';
        mr.Watch_type__c='Amount Wins';
        insert mr;
        System.assertEquals('Bar charts', mr.Chart__c);
        
        musqot__CRM_logfile__c log=new musqot__CRM_logfile__c();
        log.musqot__Imported__c=true;
        log.musqot__Import_message__c='test';
        log.musqot__Number_of_records__c=2;
        insert log;
      
      CRM_data__c crm=new CRM_data__c();
      crm.Name='file';
      crm.musqot__Business_area__c='Campaign';
      crm.musqot__Business_region__c='3000';
      crm.musqot__CRM_import_date__c=System.now().date();
      crm.musqot__CRM_import_id__c='id';
      crm.musqot__CRM_logfile__c=log.id;
      crm.musqot__Date__c=System.today();
      crm.musqot__No_Deals__c=4;
      crm.musqot__No_Leads__c=4;
      crm.musqot__No_Opportunities__c=4;
      crm.musqot__Value_Deals__c=0;
      crm.musqot__Value_w_Opportunities__c=30.55;
      crm.musqot__Value_Opportunities__c=10.50;
      insert crm;

        Milestone__c objmilestone = new  Milestone__c();
        objmilestone.Name = 'mile';
        //objmilestone.musqot__Plan__c=objproj.id;
        objmilestone.Project__c=objsubproj .id;
        objmilestone.Target_Project__c=objsubproj .id;
        //objmilestone.Marketing_activity__c=objMarketingact.id;
       // objmilestone.Target_Marketing_activity__c=objMarketingact.id;
        objmilestone.Description__c = 'testdesc';
        objmilestone.Targetdate__c = Date.Today();
        objmilestone.Target_CRM_settings__c=mr.id;
        objmilestone.Milestone_type__c =5;        
        objmilestone.Status__c ='Open';
        objmilestone.Target_number__c=5;
        objmilestone.Target_number_outcome__c=1;        
        insert objmilestone;
        System.assertEquals('mile', objmilestone.Name);

     CRMMilestoneUpdateScheduler CRMschedule = new CRMMilestoneUpdateScheduler();
        SchedulableContext sc;
        CRMschedule.execute(sc);
        CRMschedule.getStatus(objmilestone,10);
        CRMschedule.startDate=Date.Today();        
     }
     static testMethod void CRMmilestonesupdate13(){
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
        objproj .Starts_date__c = System.now().date()-10;
        objproj .Ends_date__c =  System.now().date()-5; 
        objproj .Description__c = 'sampdesc';
        objproj.ownerid =plm.userid__c;
        System.assertEquals('testname', objproj .name);
        insert objproj;
        
        Subproject__c objsubproj = new Subproject__c();
        objsubproj .Name = 'test';
        objsubproj .musqot__Parent_project__c=objproj.id;
        objsubproj .Starts_date__c = System.now().date();
        objsubproj .Ends_date__c = System.now().date();
        objsubproj .Description__c = 'testdesc';
        System.assertEquals('test', objsubproj .Name);
        insert objsubproj ;
        
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
         objMarketingact.Name='test';
         objMarketingact.Description__c='tdescriptionest';
         objMarketingact.Status__c='completed';
         objMarketingact.musqot__ERP__c='testERP';
         objMarketingact.musqot__Social_media__c='testSocial';
         objMarketingact.musqot__CRM__c='testCRM';
         objMarketingact.Starts_date__c=System.today()-10;
         objMarketingact.Ends_date__c=System.today()-10;
         //objMarketingact.musqot__Activitytype__c=objActiv.id;
         insert objMarketingact;
         System.assertEquals('test', objMarketingact.name);
        
        CRM_settings__c mr=new CRM_settings__c();
        mr.Name='crm';
        mr.Bar_color__c='#369E2B';
        mr.Chart__c='Bar charts';
        mr.CRM_performance_type__c='Milestone';
        mr.Expression_business_area__c='Campaign';
        mr.Expression_business_region__c='3000';
        mr.Selector__c='Lead Source';
        mr.Watch_type__c='Amount (weighted) Opportunities';
        insert mr;
        System.assertEquals('Bar charts', mr.Chart__c);
        
        musqot__CRM_logfile__c log=new musqot__CRM_logfile__c();
        log.musqot__Imported__c=true;
        log.musqot__Import_message__c='test';
        log.musqot__Number_of_records__c=2;
        insert log;
      
      CRM_data__c crm=new CRM_data__c();
      crm.Name='file';
      crm.musqot__Business_area__c='Campaign';
      crm.musqot__Business_region__c='3000';
      crm.musqot__CRM_import_date__c=System.now().date();
      crm.musqot__CRM_import_id__c='id';
      crm.musqot__CRM_logfile__c=log.id;
      crm.musqot__Date__c=System.today();
      crm.musqot__No_Deals__c=4;
      crm.musqot__No_Leads__c=4;
      crm.musqot__No_Opportunities__c=4;
      crm.musqot__Value_Deals__c=0;
      crm.musqot__Value_w_Opportunities__c=30.55;
      crm.musqot__Value_Opportunities__c=10.50;
      insert crm;

        Milestone__c objmilestone = new  Milestone__c();
        objmilestone.Name = 'mile';
        objmilestone.musqot__Plan__c=objproj.id;
        //objmilestone.Project__c=objsubproj .id;
        objmilestone.Target_Project__c=objsubproj .id;
        //objmilestone.Marketing_activity__c=objMarketingact.id;
       // objmilestone.Target_Marketing_activity__c=objMarketingact.id;
        objmilestone.Description__c = 'testdesc';
        objmilestone.Targetdate__c = Date.Today();
        objmilestone.Target_CRM_settings__c=mr.id;
        objmilestone.Milestone_type__c =5;        
        objmilestone.Status__c ='Open';
        objmilestone.Target_number__c=5;
        objmilestone.Target_number_outcome__c=1;        
        insert objmilestone;
        System.assertEquals('mile', objmilestone.Name);

     CRMMilestoneUpdateScheduler CRMschedule = new CRMMilestoneUpdateScheduler();
        SchedulableContext sc;
        CRMschedule.execute(sc);
        CRMschedule.getStatus(objmilestone,10);
        CRMschedule.startDate=Date.Today();        
     }     
  static testMethod void CRMmilestonesupdatem11(){
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
        objproj .Starts_date__c = System.now().date()-10;
        objproj .Ends_date__c =  System.now().date()-5; 
        objproj .Description__c = 'sampdesc';
      	objproj.ownerid =plm.userid__c;
        System.assertEquals('testname', objproj .name);
        insert objproj;
        
        Subproject__c objsubproj = new Subproject__c();
        objsubproj .Name = 'test';
        objsubproj .musqot__Parent_project__c=objproj.id;
        objsubproj .Starts_date__c = System.now().date()-5;
        objsubproj .Ends_date__c = System.now().date()-5;
        objsubproj .Description__c = 'testdesc';
        System.assertEquals('test', objsubproj .Name);
        insert objsubproj ;
        
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
         objMarketingact.Name='test';
         objMarketingact.musqot__Project__c=objsubproj.id;
         objMarketingact.Description__c='tdescriptionest';
         objMarketingact.Status__c='completed';
         objMarketingact.musqot__ERP__c='testERP';
         objMarketingact.musqot__Social_media__c='testSocial';
         objMarketingact.musqot__CRM__c='testCRM';
         objMarketingact.Starts_date__c=System.today()-10;
         objMarketingact.Ends_date__c=System.today()-10;
         //objMarketingact.musqot__Activitytype__c=objActiv.id;
         insert objMarketingact;
         System.assertEquals('test', objMarketingact.name);
        
        CRM_settings__c mr=new CRM_settings__c();
        mr.Name='crm';
        mr.Bar_color__c='#369E2B';
        mr.Chart__c='Bar charts';
        mr.CRM_performance_type__c='Milestone';
        mr.Expression_business_area__c='Campaign';
        mr.Expression_business_region__c='3000';
        mr.Selector__c='Lead Source';
        mr.Watch_type__c='No Opportunities';
        insert mr;
        System.assertEquals('Bar charts', mr.Chart__c);
        
        musqot__CRM_logfile__c log=new musqot__CRM_logfile__c();
        log.musqot__Imported__c=true;
        log.musqot__Import_message__c='test';
        log.musqot__Number_of_records__c=2;
        insert log;
      
      CRM_data__c crm=new CRM_data__c();
      crm.Name='file';
      crm.musqot__Business_area__c='Campaign';
      crm.musqot__Business_region__c='3000';
      crm.musqot__CRM_import_date__c=System.now().date();
      crm.musqot__CRM_import_id__c='id';
      crm.musqot__CRM_logfile__c=log.id;
      crm.musqot__Date__c=System.today()-1;
      crm.musqot__No_Deals__c=4;
      crm.musqot__No_Leads__c=4;
      crm.musqot__No_Opportunities__c=4;
      crm.musqot__Value_Deals__c=0;
      crm.musqot__Value_w_Opportunities__c=30.55;
      crm.musqot__Value_Opportunities__c=10.50;
      insert crm;

        Milestone__c objmilestone = new  Milestone__c();
        objmilestone.Name = 'mile';
        //objmilestone.musqot__Plan__c=objproj.id;
        //objmilestone.Project__c=objsubproj .id;
        objmilestone.Target_Project__c=objsubproj .id;
        objmilestone.Marketing_activity__c=objMarketingact.id;
        objmilestone.Target_Marketing_activity__c=objMarketingact.id;
        objmilestone.Description__c = 'testdesc';
        objmilestone.Targetdate__c = Date.Today()-1;
        objmilestone.Target_CRM_settings__c=mr.id;
        objmilestone.Milestone_type__c =5;        
        objmilestone.Status__c ='Open';
        objmilestone.Target_number__c=5;
        objmilestone.Target_number_outcome__c=1;        
        insert objmilestone;
        System.assertEquals('mile', objmilestone.Name);

     CRMMilestoneUpdateScheduler CRMschedule = new CRMMilestoneUpdateScheduler();
        SchedulableContext sc;
        CRMschedule.execute(sc);
        CRMschedule.getStatus(objmilestone,10);
        //CRMschedule.startDate=Date.Today(); 
   	}
	static testMethod void CRMmilestonesupdatemm11(){            
        Subproject__c objsubproj = new Subproject__c();
        objsubproj .Name = 'test';
        //objsubproj .musqot__Parent_project__c=objproj.id;
        objsubproj .Starts_date__c = System.now().date()-5;
        objsubproj .Ends_date__c = System.now().date()-6;
        objsubproj .Description__c = 'testdesc';
        System.assertEquals('test', objsubproj .Name);
        insert objsubproj ;
        
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
         objMarketingact.Name='test';
         objMarketingact.musqot__Project__c=objsubproj.id;
         objMarketingact.Description__c='tdescriptionest';
         objMarketingact.Status__c='completed';
         objMarketingact.musqot__ERP__c='testERP';
         objMarketingact.musqot__Social_media__c='testSocial';
         objMarketingact.musqot__CRM__c='testCRM';
         objMarketingact.Starts_date__c=System.today()-10;
         objMarketingact.Ends_date__c=System.today()-10;
         //objMarketingact.musqot__Activitytype__c=objActiv.id;
         insert objMarketingact;
         System.assertEquals('test', objMarketingact.name);
        
        CRM_settings__c mr=new CRM_settings__c();
        mr.Name='crm';
        mr.Bar_color__c='#369E2B';
        mr.Chart__c='Bar charts';
        mr.CRM_performance_type__c='Milestone';
        //mr.Expression_business_area__c='3000';
        mr.Expression_business_region__c='3000';
        mr.Selector__c='Lead Source';
        mr.Watch_type__c='No Opportunities';
        insert mr;
        System.assertEquals('Bar charts', mr.Chart__c);
        System.assertEquals('3000', mr.Expression_business_region__c);
        
        musqot__CRM_logfile__c log=new musqot__CRM_logfile__c();
        log.musqot__Imported__c=true;
        log.musqot__Import_message__c='test';
        log.musqot__Number_of_records__c=2;
        insert log;
      
      CRM_data__c crm=new CRM_data__c();
      crm.Name='file';
      crm.musqot__Business_area__c='3000';
      crm.musqot__Business_region__c='3000';
      crm.musqot__CRM_import_date__c=System.now().date();
      crm.musqot__CRM_import_id__c='id';
      crm.musqot__CRM_logfile__c=log.id;
      crm.musqot__Date__c=System.today();
      crm.musqot__No_Deals__c=4;
      crm.musqot__No_Leads__c=4;
      crm.musqot__No_Opportunities__c=4;
      crm.musqot__Value_Deals__c=0;
      crm.musqot__Value_w_Opportunities__c=30.55;
      crm.musqot__Value_Opportunities__c=10.50;
      insert crm;

        Milestone__c objmilestone = new  Milestone__c();
        objmilestone.Name = 'mile';
        objmilestone.Target_Project__c=objsubproj .id;
        objmilestone.Marketing_activity__c=objMarketingact.id;
        objmilestone.Target_Marketing_activity__c=objMarketingact.id;
        objmilestone.Description__c = 'testdesc';
        objmilestone.Targetdate__c = Date.Today()-1;
        objmilestone.Target_CRM_settings__c=mr.id;
        objmilestone.Milestone_type__c =5;        
        objmilestone.Status__c ='Open';
        objmilestone.Target_number__c=5;
        objmilestone.Target_number_outcome__c=1;        
        insert objmilestone;
        System.assertEquals('mile', objmilestone.Name);

     CRMMilestoneUpdateScheduler CRMschedule = new CRMMilestoneUpdateScheduler();
        SchedulableContext sc;
        CRMschedule.execute(sc);
        CRMschedule.getStatus(objmilestone,10);
        CRMschedule.startDate=Date.Today(); 
        }
    static testMethod void CRMmilestonemark(){
          
      CRM_data__c crm1=new CRM_data__c();
      crm1.Name='file';
      crm1.Business_area__c='Campaign1';
      crm1.Business_region__c='Lead Source1';
      crm1.CRM_import_date__c=System.now().date();
      crm1.CRM_import_id__c='id1';
      crm1.Date__c=System.today()+7;
      crm1.No_Deals__c=4;
      crm1.No_Leads__c=4;
      crm1.No_Opportunities__c=4;
      crm1.Value_Deals__c=25.50;
      crm1.Value_w_Opportunities__c=30.55;
      crm1.Value_Opportunities__c=10.50;
      insert crm1;
        
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Starts_date__c=System.today();
        objMarketingact.Ends_date__c=System.today();
        insert objMarketingact;
        System.assertEquals('test', objMarketingact.name);
        
        Milestone__c objmilestone = new  Milestone__c();
        objmilestone.Name = 'mile';
        objmilestone.Marketing_activity__c=objMarketingact.id;
        objmilestone.Description__c = 'testdesc';
        objmilestone.Targetdate__c = Date.Today()+1;        
        objmilestone.Status__c ='Open';        
        insert objmilestone;
        System.assertEquals('mile', objmilestone.Name);
        CRMMilestoneUpdateScheduler CRMschedule = new CRMMilestoneUpdateScheduler();
        SchedulableContext sc;
        CRMschedule.execute(sc);
    } 
}