/***********************************************************
Class Name: Budgetpageclass
Author:G Janardhanreddy    Last modified by:G Janardhanreddy 
Date: 21/7/2014             Date:18/03/2015
********©2013 Musqot marketing technology Pvt ltd **********/
public with sharing class Budgetpageclass{
    Public Budget__c bud{get;set;}
    public String planId{get;set;}
    public Budgetpageclass(ApexPages.StandardController controller) {
        bud=[SELECT id,Name,Approved__c,user__c,Approved_date__c,Description__c,Project__c,Budget__c,subproject__c FROM Budget__c LIMIT 1];
    }
        Public PageReference Editpage()//redirect to Budgetpage  page
    {
        
        PageReference pg=new PageReference ('/apex/Budgetpage?id='+EncodingUtil.urlEncode(bud.id,'UTF-8'));
        return pg;
    }
    /**************************************
	Save():redirect to ProjectDetails  page
	***************************************/
    Public PageReference Save()
    {
        PageReference pg;
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/ProjectDetails?id='+EncodingUtil.urlEncode(bud.id,'UTF-8')+'&tab='+EncodingUtil.urlEncode('bud','UTF-8');
        pg=new Pagereference (pageRef);
        // PageReference pg=new PageReference ('/apex/Budgetpage?id='+EncodingUtil.urlEncode(bud.id,'UTF-8'));
        return pg;
    }
    /************************************
	Cancel():redirect to Budgetpage  page
	************************************/
    Public PageReference Cancel()
    {
        PageReference pg=new PageReference ('/apex/Budgetpage?id='+EncodingUtil.urlEncode(bud.id,'UTF-8'));
        return pg;
    }
}