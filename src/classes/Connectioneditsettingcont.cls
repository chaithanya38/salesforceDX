public with sharing class Connectioneditsettingcont {
    Public Id oauthid;
    public String fbLoginURL{get;set;}
    public String accessToken {get;set;}
    public String code {get;set;}
    public String connectionId{get;set;}
    public OAuthService__c oauth{get;set;}
    public Connectioneditsettingcont (ApexPages.StandardController controller){
        oauthid=ApexPages.currentPage().getParameters().get('oauthid');
        oauth= new OAuthService__c();  
        try{            
            oauth= [SELECT Id, Name,Access_Token_URL__c,Authorization_Type__c,Authorization_URL__c, Consumer_Key__c,Consumer_Secret__c,Redirect_URL__c,Request_Token_URL__c,Response_Type__c,Scope__c,Signature_Method__c,Page_Id__c,Bar_color__c,Socialmedia__c,Post_ID__c,Access_Token__c,End_Date__c,Auto_import__c FROM OAuthService__c where id =:oauthid];          
                  }catch(exception e){}
    }
    
     /*public Connectioneditsettingcont() {
       
    } */
     /********update OAuthService**************/
      public PageReference updatecon(){
        if (musqot__OAuthService__c.sObjectType.getDescribe().isUpdateable()){   
            update oauth;            
        }
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('mpsett','UTF-8');
        Pagereference pg=new Pagereference (pageRef);
        return pg;
    }
    
    /***** redirect to MusqotAdminPage ********/
    public PageReference cancel(){
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('mpsett','UTF-8');
        Pagereference pg=new Pagereference (pageRef);
        return pg;
    }
    /***** test oAuth connection ****/    
    public void testConnection(){         
        oauth = [select id ,Name,Access_Token_URL__c, Authorization_Type__c, Authorization_URL__c,Page_Id__c,Post_ID__c,Consumer_Key__c,Socialmedia__c, Bar_color__c,Consumer_Secret__c, Redirect_URL__c, Request_Token_URL__c, Response_Type__c, Scope__c, Signature_Method__c from OAuthService__c where Id =:ApexPages.currentPage().getParameters().get('cntId')];
        HttpRequest req=new HttpRequest();
        req.setMethod('GET');
        String ReqURL = 'https://graph.facebook.com/oauth/authorize?client_id='+EncodingUtil.urlEncode(oauth.Consumer_Key__c,'UTF-8')+'&redirect_uri=https://'+System.URL.getSalesforceBaseUrl().getHost()+'/apex/Facebook_Connection';
        req.setEndpoint(ReqURL);
        
        HttpResponse res = null;
        http h= new Http();
        res = h.send(req);
        fbLoginURL = res.getHeader('Location');        
        Pagereference pg = new Pagereference (fbLoginURL);                             
    }
    
    /***** import social media data ****/
     
    public void importData(){   
        Cookie langCookie = new Cookie('socialId', connectionId, null, 1446, false);
        ApexPages.currentPage().setCookies(new Cookie[]{langCookie}); 
              
        oauth = [select id ,Name,musqot__Access_Token_URL__c, musqot__Authorization_Type__c, musqot__Authorization_URL__c,Page_Id__c,musqot__Consumer_Key__c,musqot__Socialmedia__c, musqot__Bar_color__c,musqot__Consumer_Secret__c, musqot__Redirect_URL__c, musqot__Request_Token_URL__c, musqot__Response_Type__c, musqot__Scope__c, musqot__Signature_Method__c from musqot__OAuthService__c where Id =:ApexPages.currentPage().getParameters().get('cntId')];
        HttpRequest req=new HttpRequest();
        req.setMethod('GET');
        String ReqURL = 'https://graph.facebook.com/oauth/authorize?client_id='+EncodingUtil.urlEncode(oauth.Consumer_Key__c,'UTF-8')+'&redirect_uri=https://'+System.URL.getSalesforceBaseUrl().getHost()+'/apex/Facebook_Connection';
        req.setEndpoint(ReqURL);
        HttpResponse res = null;
        http h= new Http();
        res = h.send(req);        
        fbLoginURL = res.getHeader('Location'); 
        Pagereference pg = new Pagereference (fbLoginURL);                   
    }           
}