/************************************************************
Class Name: PurchaseArticleEditController 
Author: Håkan Sjöberg      Last modified by: G Janardhanreddy
Date: 16/7/2014            Date: 20/03/2015 
********©2013 Musqot marketing technology Pvt ltd ***********/

public with sharing class PurchaseArticleEditController {
    Public String Purchasearticleid{get;set;}
    Public Purchase_article__c Purchasearticle{get;set;}   
    public PurchaseArticleEditController(ApexPages.StandardController controller) {
        Purchasearticleid=ApexPages.currentPage().getParameters().get('id');
        try{
            Purchasearticle=[SELECT id,Name from Purchase_article__c where id=:Purchasearticleid];
        }catch(Exception e){}
    }
    
/**********************************************************************
Save(): Updates Purchase article record and redirect to MusqotAdminPage
***********************************************************************/
    public Pagereference Save(){ 
        if (Purchase_article__c.sObjectType.getDescribe().isUpdateable())
        { 
            Update Purchasearticle;
        }
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('purarti','UTF-8');
        Pagereference pg=new Pagereference (pageRef);
        return pg;
    }
    /**************************************
	Cancel(): redirects to MusqotAdminPage
	**************************************/
    public Pagereference Cancel(){
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('purarti','UTF-8');
        Pagereference pg=new Pagereference (pageRef);
        return pg;        
    }    
}