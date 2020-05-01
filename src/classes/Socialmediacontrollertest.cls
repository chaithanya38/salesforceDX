/*******************************************************************
Class Name: Socialmediacontrollertest
Author:G Janardhanreddy             Last modified by:G Janardhanreddy
Date:5/1/2015                       Date:20/03/2015
********©2013 Musqot marketing technology Pvt ltd *******************/
@isTest(seeAllData=true)
Public class Socialmediacontrollertest{
    static testMethod void Socialmedia_controllerMethod(){
        test.startTest(); 
        OAuthService__c  OAuth=new OAuthService__c ();
        OAuth.Name='ffbook';
        OAuth.musqot__Authorization_Type__c='Requestheader';
        OAuth.musqot__Authorization_URL__c='https://www.facebook.com/dialog/oauth';
        OAuth.musqot__Response_Type__c='token';
        OAuth.musqot__Signature_Method__c='PLAINTEXT'; 
        OAuth.musqot__Bar_color__c='#333';   
        System.assertEquals('PLAINTEXT', OAuth.musqot__Signature_Method__c);
        insert OAuth;  
        
        musqot__Activity__c m1 =new musqot__Activity__c();
        m1.musqot__keycode__c='212';
        m1.musqot__Use_Allocation__c=true;
        m1.musqot__Use_Budget__c=true;
        m1.musqot__Use_Finance1__c=true;
        m1.musqot__Use_Forcasting__c=true;
        m1.musqot__Use_milestones__c=false;
        m1.musqot__Use_Resource__c=true;
        System.assertEquals('212', m1.musqot__keycode__c);
        insert m1; 
            
        Socialmedia_settings__c OBJSocial=new Socialmedia_settings__c();
        OBJSocial.Name='testmedia';
        OBJSocial.musqot__Import_rate__c='Hour';
        OBJSocial.musqot__Socialmedia_type__c='Facebook';
        OBJSocial.musqot__Watch_type__c='Downloads';
        OBJSocial.musqot__Chart__c='Line charts';
        OBJSocial.musqot__Bar_color__c='#333';
        OBJSocial.musqot__Page_Id__c='87567567567';
        OBJSocial.musqot__Auto_import__c= true ;
        OBJSocial.musqot__Socialmedia__c=OAuth.id;
        OBJSocial.musqot__Bar_color__c=OAuth.musqot__Bar_color__c;
        OBJSocial.Type__c ='Milestone';
        insert OBJSocial;

        System.assertEquals('Downloads', OBJSocial.musqot__Watch_type__c);
        PageReference pageRef = Page.MusqotAdminPage;
        Test.setCurrentPage(pageRef); 
      
        String tabId = System.currentPageReference().getParameters().get('tabId');
        ApexPages.currentPage().getParameters().put('socialid',OBJSocial.Id);
        ApexPages.currentPage().getParameters().put('Connid',OAuth.Id);
        ApexPages.currentPage().getParameters().put('fromHome','true');
        ApexPages.currentPage().getParameters().put('IsfromMrk','true');
        ApexPages.currentPage().getParameters().put('Name','OBJSocial');
        ApexPages.StandardController sc = new ApexPages.standardController(OBJSocial);
        Socialmediacontroller OBJSocm = new Socialmediacontroller(sc);
        List<SelectOption> temp=OBJSocm.getMyOptions();
        objsocm.smSet = OBJSocial;
        OBJSocm.insertsoscailmedia();       
        OBJSocm.cancel();
        OBJSocm.socialmediaSettingId='OBJSocialid';
        test.stopTest();
       }
 static testMethod void Socialmedia_controllerMethod1(){
        test.startTest(); 
        OAuthService__c  OAuth=new OAuthService__c ();
        OAuth.Name='ffbook';
        OAuth.musqot__Authorization_Type__c='Requestheader';
        OAuth.musqot__Authorization_URL__c='https://www.facebook.com/dialog/oauth';
        OAuth.musqot__Response_Type__c='token';
        OAuth.musqot__Signature_Method__c='PLAINTEXT'; 
        OAuth.musqot__Bar_color__c='#333';  
        System.assertEquals('PLAINTEXT', OAuth.musqot__Signature_Method__c);
        insert OAuth;  
        
        musqot__Activity__c m1 =new musqot__Activity__c();
        m1.musqot__keycode__c='212';
        m1.musqot__Use_Allocation__c=true;
        m1.musqot__Use_Budget__c=true;
        m1.musqot__Use_Finance1__c=true;
        m1.musqot__Use_Forcasting__c=true;
        m1.musqot__Use_milestones__c=true;
        m1.musqot__Use_Resource__c=true;
        System.assertEquals('212', m1.musqot__keycode__c);
        insert m1; 
            
        Socialmedia_settings__c OBJSocial=new Socialmedia_settings__c();
        OBJSocial.Name='testmedia';
        OBJSocial.musqot__Import_rate__c='Hour';
        OBJSocial.musqot__Socialmedia_type__c='Facebook';
        OBJSocial.musqot__Watch_type__c='Downloads';
        OBJSocial.musqot__Chart__c='Line charts';
        OBJSocial.musqot__Bar_color__c=OAuth.musqot__Bar_color__c;
        OBJSocial.musqot__Page_Id__c='87567567567';
        OBJSocial.musqot__Auto_import__c= true ;
        OBJSocial.Type__c ='Milestone';
        insert OBJSocial;
     	try{
     	CronJobDetail cj = [select id, Name from CronJobDetail where Name = :'SocialMediaSettingMilestoneSchedulerJob'];
        }catch(Exception e){}
        System.assertEquals('Downloads', OBJSocial.musqot__Watch_type__c);
        PageReference pageRef = Page.MusqotAdminPage;
        Test.setCurrentPage(pageRef); 
      
        String tabId = System.currentPageReference().getParameters().get('tabId');
        ApexPages.currentPage().getParameters().put('socialid',OBJSocial.Id);
        ApexPages.currentPage().getParameters().put('fromHome','true');    
        ApexPages.StandardController sc = new ApexPages.standardController(OBJSocial);
        Socialmediacontroller OBJSocm = new Socialmediacontroller(sc);
        List<SelectOption> temp=OBJSocm.getMyOptions();
        objsocm.smSet = OBJSocial;
        OBJSocm.insertsoscailmedia();
        OBJSocm.cancel();
        test.stopTest();
       }
 }