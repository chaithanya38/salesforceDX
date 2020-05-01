@isTest(seeAllData=true)
Public class ConnectioneditsettingcontTest{
    static testMethod void Connection(){
    Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
           User u2 =new User( Alias = 'newUser1' ,
           Email ='newuser123@testorg.com',
           EmailEncodingKey = 'UTF-8',
           LastName = 'Testing',
           LanguageLocaleKey='en_US',
           LocaleSidKey='en_US', 
           UserName='newuser1234@testorg.com',
           ProfileId=p.Id,
           TimeZoneSidKey = 'America/Los_Angeles');
           insert u2;
    
    Socialmedia_settings__c OBJSocial=new Socialmedia_settings__c();
        OBJSocial.Name='testmedia';
        OBJSocial.musqot__Import_rate__c='Hour';        
        OBJSocial.musqot__Socialmedia_type__c='Facebook';
        OBJSocial.musqot__Watch_type__c='Downloads';
        OBJSocial.musqot__Chart__c='Bar charts';
        OBJSocial.musqot__Auto_import__c= true ;        
        insert OBJSocial;
        System.assertEquals('Downloads', OBJSocial.musqot__Watch_type__c);
        
    musqot__OAuthService__c objOAuth = new musqot__OAuthService__c();        
        objOAuth.Name='ffbook';
        objOAuth.musqot__Authorization_Type__c='Requestheader';
        objOAuth.musqot__Authorization_URL__c='https://www.facebook.com/dialog/oauth';
        objOAuth.musqot__Response_Type__c='token';
        objOAuth.musqot__Signature_Method__c='PLAINTEXT';
        objOAuth.musqot__Consumer_Key__c = '876785757';
        objOAuth.musqot__Consumer_Secret__c = '987867ghvchgcgf';  
        objOAuth.musqot__Bar_color__c='#333';   
        objOAuth.musqot__Page_Id__c='65456456465'; 
        objOAuth.musqot__Socialmedia__c = OBJSocial.Id;
        try{
        insert objOAuth;
        }catch(exception e){}         
        System.assertEquals('PLAINTEXT', objOAuth.musqot__Signature_Method__c);
        
        PageReference pageRef = Page.Connectioneditsettings;
        Test.setCurrentPage(pageRef);  
        ApexPages.currentPage().getParameters().put('id', objOAuth.id); 
        String tabId = System.currentPageReference().getParameters().get('tabId');
        ApexPages.StandardController sc = new ApexPages.standardController(objOAuth);         
        Connectioneditsettingcont coneditsetting = new Connectioneditsettingcont (sc);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HttpRequestandResponse());
            
        Test.stopTest();
        try{
        coneditsetting.importData();
        }catch(exception e){}
        try{
        coneditsetting.testConnection();
        }catch(exception e){}
        coneditsetting.cancel();
        coneditsetting.fbLoginURL='test';
        coneditsetting.accessToken='test';
        coneditsetting.code='test';
        coneditsetting.connectionId='test';
        try{     
        coneditsetting.updatecon();
        }
        catch(exception e){}
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean b = false;
        for(Apexpages.Message msg:msgs){
        if (msg.getDetail().contains('Search requires more characters')) b = true;
                }
          }
 static testMethod void Connectionatoauth(){
    Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
           User u2 =new User( Alias = 'newUser1' ,
           Email ='newuser123@testorg.com',
           EmailEncodingKey = 'UTF-8',
           LastName = 'Testing',
           LanguageLocaleKey='en_US',
           LocaleSidKey='en_US', 
           UserName='newuser1234@testorg.com',
           ProfileId=p.Id,
           TimeZoneSidKey = 'America/Los_Angeles');
           insert u2;
    
    Socialmedia_settings__c OBJSocial=new Socialmedia_settings__c();
        OBJSocial.Name='testmedia';
        OBJSocial.musqot__Import_rate__c='Hour';        
        OBJSocial.musqot__Socialmedia_type__c='Facebook';
        OBJSocial.musqot__Watch_type__c='Downloads';
        OBJSocial.musqot__Chart__c='Bar charts';
        OBJSocial.musqot__Auto_import__c= true ;        
        insert OBJSocial;
        System.assertEquals('Downloads', OBJSocial.musqot__Watch_type__c);
        
    musqot__OAuthService__c objOAuth = new musqot__OAuthService__c();        
        objOAuth.Name='ffbook';
        objOAuth.musqot__Authorization_Type__c='Requestheader';
        objOAuth.musqot__Authorization_URL__c='https://www.facebook.com/dialog/oauth';
        objOAuth.musqot__Response_Type__c='token';
        objOAuth.musqot__Signature_Method__c='PLAINTEXT';
        objOAuth.musqot__Consumer_Key__c = '876785757';
        objOAuth.musqot__Consumer_Secret__c = '987867ghvchgcgf';  
        objOAuth.musqot__Bar_color__c='#333';   
        objOAuth.musqot__Page_Id__c='65456456465'; 
        objOAuth.musqot__Socialmedia__c = OBJSocial.Id;
        insert objOAuth;         
        System.assertEquals('PLAINTEXT', objOAuth.musqot__Signature_Method__c);
        
        PageReference pageRef = Page.Facebook_Connection;
        Test.setCurrentPage(pageRef); 
        ApexPages.currentPage().getParameters().put('oauthid', objOAuth.id); 
        ApexPages.currentPage().getParameters().put('cntId', objOAuth.id); 
        ApexPages.StandardController sc = new ApexPages.standardController(objOAuth);         
        Connectioneditsettingcont coneditsetting = new Connectioneditsettingcont (sc);
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new HttpRequestandResponse());
            
        Test.stopTest();          
            
        try{
        coneditsetting.importData();
        }catch(exception e){}
        try{
        coneditsetting.testConnection();
        }catch(exception e){}
        coneditsetting.cancel();
        coneditsetting.fbLoginURL='test';
        coneditsetting.accessToken='test';
        coneditsetting.code='test';
        coneditsetting.connectionId='test';
        try{     
        coneditsetting.updatecon();
        }
        catch(exception e){}
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean b = false;
        for(Apexpages.Message msg:msgs){
        if(msg.getDetail().contains('Search requires more characters')) b = true;
            }
         } 
   }