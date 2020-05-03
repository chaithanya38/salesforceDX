/*****************************************************************
Class Name: Socialmedia_Edit_Ctrl_Test 
Author:Nagaraju G                Last modified by: Hussain
Date:19/11/2014                  Date:20/03/2015
********©2013 Musqot marketing technology Pvt ltd ****************/
@isTest(seealldata = true)

Private class Socialmedia_Edit_Ctrl_Test{
        static testMethod void Socialmedia_controllerMethodTests(){  
           
        musqot__OAuthService__c  OAuth = new musqot__OAuthService__c ();
        OAuth.Name='ffbook';
        OAuth.musqot__Authorization_Type__c='Requestheader';
        OAuth.musqot__Access_Token_URL__c='uigyvjhvg';
        OAuth.musqot__Response_Type__c='token';
        OAuth.musqot__Auto_import__c=true;
        OAuth.musqot__Post_ID__c='65456456465';
        OAuth.musqot__Scope__c='added';
        //OAuth.musqot__Socialmedia__c=OBJSocial.id;
        OAuth.musqot__Social_media__c='Facebook';
        OAuth.musqot__Signature_Method__c='HMAC-SHA1';
        OAuth.musqot__Consumer_Key__c = '876785757';
        OAuth.musqot__Consumer_Secret__c = '987867ghvchgcgf'; 
        OAuth.musqot__End_Date__c = system.today();
        OAuth.musqot__Bar_color__c='#333';
        OAuth.musqot__ad_id__c='addid';
        OAuth.musqot__Campaign_Id__c='campaign';   
        OAuth.musqot__Page_Id__c='65456456465';       
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
        
        musqot__Socialmedia_settings__c OBJSocial = new musqot__Socialmedia_settings__c();
        OBJSocial.name='testmedia';
        OBJSocial.musqot__Import_rate__c='Hour';        
        OBJSocial.musqot__Socialmedia_type__c='Facebook';
        OBJSocial.musqot__Watch_type__c='Downloads';
        OBJSocial.musqot__Chart__c='Bar charts';
        OBJSocial.musqot__Auto_import__c= true ;   
        OBJSocial.musqot__Socialmedia__c=OAuth.id;
        OBJSocial.musqot__Bar_color__c= OAuth.musqot__Bar_color__c;  
        OBJSocial.Type__c ='Milestone';
        insert OBJSocial;
        
        System.assertEquals('Downloads', OBJSocial.musqot__Watch_type__c);
        String tabId = System.currentPageReference().getParameters().get('tabId');
        ApexPages.currentPage().getParameters().put('socialid',OBJSocial.Id);
        ApexPages.currentPage().getParameters().put('fromHome','true');
        ApexPages.StandardController ctrl = new ApexPages.StandardController(OBJSocial);
        Socialmedia_Edit_Ctrl soc = new Socialmedia_Edit_Ctrl(ctrl);
        OAuthService__c oauthService = [select id ,Name,Bar_color__c from OAuthService__c where Id =:OBJSocial.Socialmedia__c];           
        OBJSocial.Bar_color__c= oauthService.musqot__Bar_color__c;
        update OBJSocial;
        List<SelectOption>  temp=soc.getMyOptions();
        Test.startTest();
        soc.cancel();
        soc.updSocial();
        test.stopTest();
      
      }
        static testMethod void Socialmedia_controllerMethodTests1(){     
        musqot__OAuthService__c  OAuth = new musqot__OAuthService__c ();
        OAuth.Name='ffbook';
        OAuth.musqot__Authorization_Type__c='Requestheader';
        OAuth.musqot__Access_Token_URL__c='uigyvjhvg';
        OAuth.musqot__Response_Type__c='token';
        OAuth.musqot__Signature_Method__c='PLAINTEXT';
        OAuth.musqot__Consumer_Key__c = '876785757';
        OAuth.musqot__Consumer_Secret__c = '987867ghvchgcgf';  
        OAuth.musqot__Bar_color__c='#333';   
        OAuth.musqot__Page_Id__c='65456456465';  
         OAuth.musqot__Social_media__c='Mailchip';     
       // OAuth.musqot__Socialmedia__c = OBJSocial.Id;
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
        
        musqot__Socialmedia_settings__c OBJSocial = new musqot__Socialmedia_settings__c();
        OBJSocial.Name='testmedia';
        OBJSocial.musqot__Import_rate__c='Hour';        
        OBJSocial.musqot__Socialmedia_type__c='Facebook';
        OBJSocial.musqot__Watch_type__c='Downloads';
        OBJSocial.musqot__Chart__c='Bar charts';
        OBJSocial.musqot__Auto_import__c= true ;   
        OBJSocial.musqot__Socialmedia__c=OAuth.id;
        OBJSocial.musqot__Bar_color__c= OAuth.musqot__Bar_color__c;  
        OBJSocial.Type__c ='Milestone';
        upsert OBJSocial;
        
        System.assertEquals('Downloads', OBJSocial.musqot__Watch_type__c);
        String tabId = System.currentPageReference().getParameters().get('tabId');
        ApexPages.currentPage().getParameters().put('socialid',OBJSocial.Id);
        ApexPages.currentPage().getParameters().put('fromHome','true');
        ApexPages.StandardController ctrl = new ApexPages.StandardController(OBJSocial);
        Socialmedia_Edit_Ctrl soc = new Socialmedia_Edit_Ctrl(ctrl);
        OAuthService__c oauthService = [select id ,Name,Bar_color__c from OAuthService__c where Id =:OBJSocial.Socialmedia__c];           
        OBJSocial.Bar_color__c= oauthService.musqot__Bar_color__c;
        update OBJSocial;
        List<SelectOption>  temp=soc.getMyOptions();
        Test.startTest();
        soc.cancel();
        soc.updSocial();
        test.stopTest();
      
      }
  }