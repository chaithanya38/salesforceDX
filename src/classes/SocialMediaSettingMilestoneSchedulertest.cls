/***************************************************************
Class Name: SocialMediaSettingMilestoneSchedulertest
chaithanya daggumati      Last modified by: chaithanya daggumati
Date :16/10/2015           Date : 16/10/2015                    
********©2013 Musqot marketing technology Pvt ltd **************/

@isTest(seeAllData=true)
    public class SocialMediaSettingMilestoneSchedulertest{
        static testMethod void SocialMediaSettingMilestone(){
                 
        Project__c objproj = new Project__c();
        objproj .name = 'testname';
        objproj .Starts_date__c = System.now().date();
        objproj .Ends_date__c =  System.now().date()+5; 
        objproj .Description__c = 'sampdesc';
        System.assertEquals('testname', objproj .name);
        insert objproj;
        
        Subproject__c objsubproj = new Subproject__c();
        objsubproj .Name = 'test';
        objsubproj .musqot__Parent_project__c=objproj.id;
        objsubproj .Starts_date__c = Date.Today();
        objsubproj .Ends_date__c = Date.Today();
        objsubproj .Description__c = 'testdesc';
        System.assertEquals('test', objsubproj .Name);
        insert objsubproj ;
        
        OAuthService__c  OAuth=new OAuthService__c ();
        OAuth.Name='ffbook';
        OAuth.musqot__Authorization_Type__c='Requestheader';
        OAuth.musqot__Authorization_URL__c='https://www.facebook.com/dialog/oauth';
        OAuth.musqot__Response_Type__c='token';
        OAuth.musqot__Signature_Method__c='PLAINTEXT'; 
        OAuth.musqot__Bar_color__c='#333';   
        System.assertEquals('PLAINTEXT', OAuth.musqot__Signature_Method__c);
        insert OAuth;
        
        Socialmedia_settings__c OBJSocial=new Socialmedia_settings__c();
        OBJSocial.Name='facebook';
        OBJSocial.musqot__Import_rate__c='Hour';
        OBJSocial.musqot__Socialmedia_type__c='Facebook';
        OBJSocial.musqot__Watch_type__c='Likes / click';
        OBJSocial.musqot__Chart__c='Line charts';
        OBJSocial.musqot__Bar_color__c='#333';
        OBJSocial.musqot__Page_Id__c='87567567567';
        OBJSocial.musqot__Auto_import__c= true ;
        OBJSocial.musqot__Socialmedia__c=OAuth.id;
        OBJSocial.musqot__Bar_color__c=OAuth.musqot__Bar_color__c;
        OBJSocial.Type__c ='Milestone';
        System.assertEquals('facebook', OBJSocial.Name);
        insert OBJSocial;
        
        Milestone__c objmilestone = new  Milestone__c();
        objmilestone.Name = 'reachontime';
        objmilestone.musqot__Plan__c=objproj.id;
        objmilestone.Project__c=objsubproj .id;
        objmilestone.Target_Project__c=objsubproj .id;
        objmilestone.Description__c = 'testdesc';
        objmilestone.Targetdate__c = Date.Today();
        objmilestone.Target_Socialmedia__c=OBJSocial.id;
        objmilestone.Milestone_type__c =4;        
        objmilestone.Status__c ='Open';
        objmilestone.Target_number__c=5;
        System.assertEquals('reachontime', objmilestone.name);
        insert objmilestone;
        
        Social_media_data__c smd = new Social_media_data__c();        
        smd.Compound_Id__c='auth';
        smd.Date__c = system.today();
        smd.Number_of_likes__c = 4;
        smd.Number_of_member__c=5;
        smd.Number_of_unik_visitor__c=6;
        smd.Connection__c=OAuth.id;
        smd.Socialmedia_Settings__c =OBJSocial.Id; 
        smd.Name = 'test';
        System.assertEquals('auth', smd.Compound_Id__c);              
        insert smd;
        
        SocialMediaSettingMilestoneScheduler socmileschedule = new SocialMediaSettingMilestoneScheduler();
        SchedulableContext sc;
        socmileschedule.execute(sc);
      }
 static testMethod void SocialMediaSettingMilestone1(){
         Milestone__c objmilestone = new  Milestone__c();
        objmilestone.Name = 'reachontime';        
        objmilestone.Description__c = 'testdesc';
        objmilestone.Targetdate__c = system.toDay().addDays(-7);
        //objmilestone.Target_Socialmedia__c=OBJSocial.id;
        objmilestone.Milestone_type__c =4;        
        objmilestone.Status__c ='Not Reach';
        objmilestone.Target_number__c=5;
        System.assertEquals('reachontime', objmilestone.name);
        insert objmilestone; 
        
        SocialMediaSettingMilestoneScheduler socmileschedule = new SocialMediaSettingMilestoneScheduler();
        SchedulableContext sc;
        socmileschedule.execute(sc);                     
        }
 static testMethod void SocialMediaSettingMilestone2(){
        Socialmedia_settings__c OBJSocial=new Socialmedia_settings__c();
        OBJSocial.Name='facebook';       
        OBJSocial.musqot__Watch_type__c='Likes / click';       
        OBJSocial.Type__c ='Milestone';
        System.assertEquals('facebook', OBJSocial.Name);
        insert OBJSocial;
        
        Milestone__c objmilestone = new  Milestone__c();
        objmilestone.Name = 'reachontime';
        objmilestone.Description__c = 'testdesc';
        objmilestone.Targetdate__c = Date.Today();
        objmilestone.Target_Socialmedia__c=OBJSocial.id;
        objmilestone.Milestone_type__c =4;        
        objmilestone.Status__c ='Open';
        objmilestone.Target_number__c=5;
        System.assertEquals('reachontime', objmilestone.name);
        insert objmilestone;
        SocialMediaSettingMilestoneScheduler socmileschedule = new SocialMediaSettingMilestoneScheduler();
        SchedulableContext sc;
        socmileschedule.execute(sc);                     
        }
    }