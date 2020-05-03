public with sharing class connectionsettingscont{    
    public musqot__OAuthService__c oauth{get;set;}
    private ApexPages.StandardController sc;
    public connectionsettingscont(ApexPages.StandardController controller){
        This.sc = sc;
        oauth= new musqot__OAuthService__c ();
      }
    
    Public Pagereference cancel(){
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('mpsett','UTF-8');
        Pagereference pg=new Pagereference (pageRef);
        return pg;
    }
    
    public Pagereference insertconnection(){
        
        if (musqot__OAuthService__c.sObjectType.getDescribe().isCreateable()){
            insert oauth;
        }
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('mpsett','UTF-8');
        Pagereference pg=new Pagereference (pageRef);
        return pg;
    }
}