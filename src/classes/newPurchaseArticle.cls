/***************************************************************
Class Name: newPurchaseArticle
Author:Hakan sjoberg           Last modified by: G Janardhanreddy
Date: 16/7/2014                Date:24/03/2015  
********©2013 Musqot marketing technology Pvt ltd ***************/

public with sharing class newPurchaseArticle{
    public Purchase_article__c Newact{get;set;}
    public newPurchaseArticle(ApexPages.StandardController controller) {
        Newact=new Purchase_article__c();
    }
    /********************************************************************
    Newrec(): insert new PurchaseArticle and redirects to MusqotAdminPage
    *********************************************************************/    
    Public Pagereference  Newrec()
    {
        if (Purchase_article__c.sObjectType.getDescribe().isCreateable())
        {
            insert Newact;
        }
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('purarti','UTF-8');
        Pagereference pg=new Pagereference (pageRef);
        return pg;
    }
    /*************************************
    Cancel(): redirects to MusqotAdminPage
    **************************************/
    Public Pagereference  Cancel()
    {
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('purarti','UTF-8');
        Pagereference pg=new Pagereference (pageRef);
        return pg;
    }   
}