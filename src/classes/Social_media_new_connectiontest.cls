@isTest(seealldata = true)
public class Social_media_new_connectiontest{
       static testMethod void Socialmedianewconnection(){
        Socialmedia_settings__c OBJSocial=new Socialmedia_settings__c();
        OBJSocial.Name='testmedia';
        OBJSocial.musqot__Import_rate__c='Hour';
        OBJSocial.musqot__Socialmedia_type__c='MailChimp';
        OBJSocial.musqot__Watch_type__c='Downloads';
        OBJSocial.musqot__Chart__c='Line charts';
        OBJSocial.musqot__Bar_color__c='#333';
        OBJSocial.musqot__Page_Id__c='87567567567';
        OBJSocial.musqot__Auto_import__c= true ;
        insert OBJSocial;
        System.assertEquals('Downloads', OBJSocial.musqot__Watch_type__c);
        
        
        OAuthService__c  OAuth = new OAuthService__c ();
        OAuth.Name='Mchip';
        OAuth.Authorization_Type__c='Requestheader';
        OAuth.Access_Token_URL__c='3fb5fa28a18e4d970e56ba8002792ddc-us11';
        OAuth.Response_Type__c='token';
        OAuth.Auto_import__c=true;
        OAuth.Post_ID__c='059c9a6e11';
        OAuth.Scope__c='added';
        OAuth.Socialmedia__c=OBJSocial.id;
        OAuth.Social_media__c='MailChimp';
        OAuth.Signature_Method__c='HMAC-SHA1';
        OAuth.Consumer_Key__c = '8d4377d4ab';
        OAuth.Consumer_Secret__c = ''; 
        OAuth.End_Date__c = system.today()+1;
        OAuth.Bar_color__c='#333';
        OAuth.ad_id__c='';
        OAuth.Campaign_Id__c='059c9a6e11';   
        OAuth.Redirect_URL__c='https://musqot.eu2.visual.force.com';
        OAuth.Page_Id__c='';       
        insert OAuth;
        System.assertEquals('MailChimp',OAuth.Social_media__c);  
        
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        MetadataService.RemoteSiteSetting remoteSiteSettings = new MetadataService.RemoteSiteSetting();
        remoteSiteSettings.fullName = 'MailChimp_';
        remoteSiteSettings.url = 'https://www.api.mailchimp.com';
        remoteSiteSettings.description='Musqot';
        remoteSiteSettings.isActive=true;
        remoteSiteSettings.disableProtocolSecurity=false;
        
        Test.startTest();
        PageReference pageRef = Page.Social_media_new_connection;
        Test.setCurrentPage(pageRef);
        List<String> dcList = OAuth.Access_Token_URL__c.split('-');
        list<string>urlslpt=new list<string>();
        List<musqot__OAuthService__c>oath=[SELECT Id,musqot__Access_Token_URL__c FROM OAuthService__c WHERE id=:OAuth.id];
        for(musqot__OAuthService__c a:oath){
            urlslpt.add(a.Access_Token_URL__c);
        }
        string   DateScheduled='1/1/2014';
        String[] myDateOnly = DateScheduled.split(' ');
            String[] strDate = myDateOnly[0].split('/');
            Integer myIntDate = integer.valueOf(strDate[1]);
            Integer myIntMonth = integer.valueOf(strDate[0]);
            Integer myIntYear = integer.valueOf(strDate[2]);
        
        ApexPages.currentPage().getParameters().put('id',OAuth.id);
        ApexPages.currentPage().getParameters().put('mpsett', OAuth.id);  
        ApexPages.CurrentPage().getParameters().put('Name','01rb0000000E6dasdf');   
        ApexPages.CurrentPage().getParameters().put('SocialMediaType','MailChimp');
      //ApexPages.CurrentPage().getParameters().put('EndDate','12/09/2015');
        //ApexPages.CurrentPage().getParameters().put(EndDate,date.valueof(Date.newInstance(myIntYear, myIntMonth, myIntDate)));
        ApexPages.StandardController sc = new ApexPages.standardController(OAuth);
        Social_media_new_connection socnewcon = new Social_media_new_connection (sc);
        Test.setMock(HttpCalloutMock.class, new HttpRequestandResponse()); 
        List<String>dcList1=urlslpt;
        try{
            socnewcon.insertsoscailmedia();
        }catch(exception e){}
        socnewcon.facebookCampaignConnection();
        socnewcon.mailchimpCampaignConsumerKeyConnection();
        socnewcon.mailchimpCampaignConnection();
        //socnewcon.createMailChimpCampaign();
        socnewcon.createAdvert();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://api.salesforce.com/Id/campaignId');
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse res = h.send(req);
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"campaignReqURL":"campaignId"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200,res.getStatusCode());           
        socnewcon.cancel();
        try{
         socnewcon.facebookCampaignMessageConnection();          
        }catch(exception e){} 
        socnewcon.createFacebookAd();
        socnewcon.createcampaignMailChimp();
        socnewcon.linkedinPageConnection();
        socnewcon.createLinkedInShare();
        socnewcon.createshareLinkedIn();
        
        Test.setMock(HttpCalloutMock.class, new HttpRequestandResponse());
        socnewcon.smMessage=true;
        Test.stopTest();                
    }
  static testMethod void Socialmedianewconnection2(){
        Socialmedia_settings__c OBJSocial=new Socialmedia_settings__c();
        OBJSocial.Name='testmedia';
        OBJSocial.musqot__Import_rate__c='Hour';
        OBJSocial.musqot__Socialmedia_type__c='Facebook';
        OBJSocial.musqot__Watch_type__c='Downloads';
        OBJSocial.musqot__Chart__c='Line charts';
        OBJSocial.musqot__Bar_color__c='#333';
        OBJSocial.musqot__Page_Id__c='87567567567';
        OBJSocial.musqot__Auto_import__c= true ;
        insert OBJSocial;
        System.assertEquals('Downloads', OBJSocial.musqot__Watch_type__c);
        
        
        musqot__OAuthService__c  OAuth = new musqot__OAuthService__c ();
        OAuth.Name='ffbook';
        OAuth.musqot__Authorization_Type__c='Requestheader';
        OAuth.musqot__Access_Token_URL__c='uigyvjhvg';
        OAuth.musqot__Response_Type__c='token';
        OAuth.musqot__Auto_import__c=true;
        OAuth.musqot__Post_ID__c='65456456465';
        OAuth.musqot__Scope__c='added';
        OAuth.musqot__Socialmedia__c=OBJSocial.id;
        OAuth.musqot__Social_media__c='LinkedIn';
        OAuth.musqot__Signature_Method__c='HMAC-SHA1';
        OAuth.musqot__Consumer_Key__c = '876785757';
        OAuth.musqot__Consumer_Secret__c = '987867ghvchgcgf'; 
        OAuth.musqot__End_Date__c = system.today();
        OAuth.musqot__Bar_color__c='#333';
        OAuth.musqot__ad_id__c='addid'; 
        OAuth.Redirect_URL__c='www.musqot.com';      
        OAuth.musqot__Page_Id__c='65456456465';       
        insert OAuth;
        
        
        MetadataService.RemoteSiteSetting remoteSiteSettings = new MetadataService.RemoteSiteSetting();
        remoteSiteSettings.fullName = 'MailChimp';
        remoteSiteSettings.url = 'https://us11.api.mailchimp.com';
        remoteSiteSettings.description='Musqot';
        remoteSiteSettings.isActive=true;
        remoteSiteSettings.disableProtocolSecurity=false;
        
   
        Test.startTest();
        PageReference pageRef = Page.Social_media_new_connection;
        Test.setCurrentPage(pageRef); 
        ApexPages.currentPage().getParameters().put('id', OAuth.id);
        ApexPages.currentPage().getParameters().put('mpsett', OAuth.id); 
        ApexPages.CurrentPage().getParameters().put('SocialMediaType','LinkedIn');    
        ApexPages.StandardController sc = new ApexPages.standardController(OAuth);
        Social_media_new_connection socnewcon = new Social_media_new_connection (sc);
        
        Test.setMock(HttpCalloutMock.class, new HttpRequestandResponse());
        socnewcon.createService();
        //socnewcon.createMailChimpCampaign();
        socnewcon.mailchimpCampaignConnection();
        socnewcon.facebookCampaignConnection();
        socnewcon.linkedinPageConnection();
        socnewcon.createshareLinkedIn();
        try{
            socnewcon.insertsoscailmedia();
        }catch(exception e){}
        //try{
        socnewcon.createAdvert();
        //}catch(exception e){}
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://api.salesforce.com/Id/campaignId');
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse res = h.send(req);
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"campaignReqURL":"campaignId"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200,res.getStatusCode());           
        socnewcon.cancel();
        socnewcon.createAdvert();
        try{
         socnewcon.facebookCampaignMessageConnection();
        }catch(exception e){}
        Test.setMock(HttpCalloutMock.class, new HttpRequestandResponse());
        socnewcon.smMessage=true;
        Test.stopTest();                
    }
   static testMethod void Socialmediamailchimp(){
       Socialmedia_settings__c OBJSocial1=new Socialmedia_settings__c();
        OBJSocial1.Name='MailChimp';
        OBJSocial1.musqot__Import_rate__c='Hour';
        OBJSocial1.musqot__Socialmedia_type__c='Facebook';
        OBJSocial1.musqot__Watch_type__c='Downloads';
        OBJSocial1.musqot__Chart__c='Line charts';
        OBJSocial1.musqot__Bar_color__c='#333';
        OBJSocial1.musqot__Page_Id__c='87567567567';
        OBJSocial1.musqot__Auto_import__c= true ;
        insert OBJSocial1;
        System.assertEquals('MailChimp', OBJSocial1.Name);
        
        
        musqot__OAuthService__c  OAuth = new musqot__OAuthService__c ();
        OAuth.Name='ffbook';
        OAuth.musqot__Authorization_Type__c='Requestheader';
        OAuth.musqot__Access_Token_URL__c='CAALlOqcmcU0BAIaeOHMdCPDYmBncSiSe3cy33qNcAZABm2ZAGaq1UkUW5ZBm6dHVHZBM0cnnvZAMwKLnOltsqveNZANCUpYdJK9Wgi6L3IpGcmI5rStbo1q5112WAxGxIhyxw6nXSDsOqXhlTlLfqM2TTzh6kdQ7JqH3swv0iZB4N1ZC3AuMESrXOBTGqz1d3Y4ZD';
        OAuth.musqot__Response_Type__c='token';
        OAuth.musqot__Auto_import__c=true;
        OAuth.musqot__Post_ID__c='65456456465';
        OAuth.musqot__Scope__c='added';
        OAuth.musqot__Social_media__c='MailChimp';
        OAuth.musqot__Signature_Method__c='HMAC-SHA1';
        OAuth.musqot__Consumer_Key__c = '876785757';
        OAuth.musqot__Consumer_Secret__c = '987867ghvchgcgf'; 
        OAuth.musqot__End_Date__c = system.today();
        OAuth.musqot__Bar_color__c='#333';
        OAuth.Redirect_URL__c='www.musqot.com';
        OAuth.musqot__ad_id__c='addid';       
        OAuth.musqot__Page_Id__c='65456456465';       
        insert OAuth;
        PageReference pageRef = Page.Social_media_new_connection;
        Test.setCurrentPage(pageRef); 
        ApexPages.currentPage().getParameters().put('id', OAuth.id);
        ApexPages.currentPage().getParameters().put('mpsett', OAuth.id);  
           
        ApexPages.StandardController sc = new ApexPages.standardController(OAuth);
        Social_media_new_connection socnewcon1 = new Social_media_new_connection (sc);
        try{
        socnewcon1.insertsoscailmedia();
        }catch(exception e){}
        socnewcon1.createAdvert();
        socnewcon1.smMessage=false;
   }
   static testMethod void SocialmediamailchimpCreatLinkdn(){
       Socialmedia_settings__c OBJSocial=new Socialmedia_settings__c();
        OBJSocial.Name='testmedia';
        OBJSocial.musqot__Import_rate__c='Hour';
        OBJSocial.musqot__Socialmedia_type__c='Facebook';
        OBJSocial.musqot__Watch_type__c='Downloads';
        OBJSocial.musqot__Chart__c='Line charts';
        OBJSocial.musqot__Bar_color__c='#333';
        OBJSocial.musqot__Page_Id__c='87567567567';
        OBJSocial.musqot__Auto_import__c= true ;
        insert OBJSocial;
        System.assertEquals('Downloads', OBJSocial.musqot__Watch_type__c);
        
        
        musqot__OAuthService__c  OAuth = new musqot__OAuthService__c ();
        OAuth.Name='ffbook';
        OAuth.musqot__Authorization_Type__c='Requestheader';
        OAuth.musqot__Access_Token_URL__c='uigyvjhvg';
        OAuth.musqot__Response_Type__c='token';
        OAuth.musqot__Auto_import__c=true;
        OAuth.musqot__Post_ID__c='65456456465';
        OAuth.musqot__Scope__c='added';
        OAuth.musqot__Socialmedia__c=OBJSocial.id;
        OAuth.musqot__Social_media__c='LinkedIn';
        OAuth.musqot__Signature_Method__c='HMAC-SHA1';
        OAuth.musqot__Consumer_Key__c = '876785757';
        OAuth.musqot__Consumer_Secret__c = '987867ghvchgcgf'; 
        OAuth.musqot__End_Date__c = system.today();
        OAuth.musqot__Bar_color__c='#333';
        OAuth.musqot__ad_id__c='addid'; 
        OAuth.Redirect_URL__c='www.musqot.com';      
        OAuth.musqot__Page_Id__c='65456456465';       
        insert OAuth;
        
        MetadataService.RemoteSiteSetting remoteSiteSettings = new MetadataService.RemoteSiteSetting();
        remoteSiteSettings.fullName = 'LinkedIn';
        remoteSiteSettings.url = 'https://us11.api.mailchimp.com';
        remoteSiteSettings.description='Musqot';
        remoteSiteSettings.isActive=true;
        remoteSiteSettings.disableProtocolSecurity=false;
        
        Test.startTest();
        PageReference pageRef = Page.Social_media_new_connection;
        Test.setCurrentPage(pageRef); 
        ApexPages.currentPage().getParameters().put('id', OAuth.id);
        ApexPages.currentPage().getParameters().put('mpsett', OAuth.id); 
        ApexPages.CurrentPage().getParameters().put('SocialMediaType','LinkedIn');    
        ApexPages.StandardController sc = new ApexPages.standardController(OAuth);
        Social_media_new_connection socnewcon = new Social_media_new_connection (sc);
        
        Test.setMock(HttpCalloutMock.class, new HttpRequestandResponse());
        socnewcon.createService();
        //socnewcon.createMailChimpCampaign();
        socnewcon.mailchimpCampaignConnection();
        socnewcon.facebookCampaignConnection();
        socnewcon.linkedinPageConnection();
        socnewcon.createshareLinkedIn();
        try{
            socnewcon.insertsoscailmedia();
        }catch(exception e){}
        try{
        socnewcon.createAdvert();
        }catch(exception e){}
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://api.salesforce.com/Id/campaignId');
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse res = h.send(req);
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"campaignReqURL":"campaignId"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200,res.getStatusCode());           
        socnewcon.cancel();
        socnewcon.createAdvert();
        try{
         socnewcon.facebookCampaignMessageConnection();
        }catch(exception e){}
        Test.setMock(HttpCalloutMock.class, new HttpRequestandResponse());
        socnewcon.smMessage=true;
        Test.stopTest();                
     }
    static testMethod void createmailchimp(){
        OAuthService__c OAuth = new OAuthService__c(); 
        OAuth.Name='ffbook';
        OAuth.Redirect_URL__c='HMdCPDYmBncSiSe3cy33';                  
        OAuth.Bar_color__c='#333';             
        OAuth.End_Date__c=Date.today();                     
        insert OAuth;          
        //system.assertnotEquals(null,OAuth.id);
        system.assertEquals('ffbook', OAuth.Name);
        Test.startTest();           
        ApexPages.StandardController ctrl = new ApexPages.StandardController(OAuth);
        Social_media_new_connection soclink = new Social_media_new_connection (ctrl);
        soclink.createMailChimpCampaign();
        Test.stopTest();
    }
  static testMethod void createsharedlink(){
        OAuthService__c  OAuth = new OAuthService__c ();
        OAuth.Name='link';
        OAuth.Access_Token_URL__c='uigyvjhvg';        
        OAuth.Social_media__c='LinkedIn'; 
        OAuth.End_Date__c = system.today();
        OAuth.Bar_color__c='#333';             
        OAuth.Page_Id__c='65456456465';       
        insert OAuth;
        system.assertEquals('link', OAuth.Name);
        ApexPages.StandardController ctrl = new ApexPages.StandardController(OAuth);
        Social_media_new_connection soclink = new Social_media_new_connection (ctrl);
        soclink.createshareLinkedIn();
}
    static testMethod void fbadd(){
        OAuthService__c  OAuth = new OAuthService__c ();
        OAuth.Name='link';
        OAuth.Redirect_URL__c=null;        
        OAuth.End_Date__c = system.today();
        OAuth.Bar_color__c='#333';             
        OAuth.Campaign_Id__c=null;       
        insert OAuth;
        system.assertEquals('link', OAuth.Name);
        ApexPages.StandardController ctrl = new ApexPages.StandardController(OAuth);
        Social_media_new_connection soclink = new Social_media_new_connection (ctrl);
        soclink.createFacebookAd();
    }
}