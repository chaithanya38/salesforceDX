/*****************************************************************
Class Name: costcenteroverviewcls
Author:Chaithanya daggumati                   Last modified by:Chaithanya daggumati
Date :25/11/2015                           	  Date :25/11/2015                    
********©2013 Musqot marketing technology Pvt ltd *****************/
public with sharing class costcenteroverviewcls {
    public Costcentre__c CCSpace{get;set;}
    private ApexPages.StandardController sc;
    public String cosid{get;set;}
    public String CCspaceId {get;set;}
    public costcenteroverviewcls(ApexPages.StandardController sc){
    This.sc = sc;
    CCSpace = new Costcentre__c();
    cosid = ApexPages.currentPage().getParameters().get('cosid');
    CCspaceId = ApexPages.currentPage().getParameters().get('id');
        try{
        CCSpace=[SELECT Id,Overveiw__c,Headline__c FROM Costcentre__c where id=:cosid];
        }catch(Exception e){}
    }   
    /***********************************************************************
    Save(): update the workspace record and redirects to related parent page
    ************************************************************************/
    Public Pagereference Save(){
        if (Costcentre__c.sObjectType.getDescribe().isUpdateable()){
            update CCSpace;
        }
        Pagereference PR;
        if(cosid<>null){            
            PR = new Pagereference('/apex/costcenterdetail?id='+EncodingUtil.urlEncode(cosid,'UTF-8'));                  
        }            
        return PR;
    }
    /*****************************************************
    cancel():redirects to redirects to related parent pag
    ******************************************************/
    Public Pagereference cancel(){
        Pagereference PR;        
        if(cosid<>null){            
            PR = new Pagereference('/apex/costcenterdetail?id='+EncodingUtil.urlEncode(cosid,'UTF-8'));                  
        }          
        return PR;        
    }
}