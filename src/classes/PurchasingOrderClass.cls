/***********************************************************
Class Name: PurchasingOrderClass  
Author:chaithanya daggumat        Last modified by:Nagaraju G
Date:16/7/2014                    Date:18/03/2015
********©2013 Musqot marketing technology Pvt ltd **********/

public with sharing class PurchasingOrderClass {
    Public Purchase_order_setting__c pos{get;set;}
    public PurchasingOrderClass(ApexPages.StandardController controller) 
    {
        pos=[SELECT id,Name,PO_Startnumber__c,PO_Prefix__c,PO_Autoprefix__c,PO_External__c,PO_Lastnumber__c FROM Purchase_order_setting__c LIMIT 1];
    }
    /**************************************************
	Editpage():redirect to PurchaseOrderSettingEditPage
	****************************************************/  
    Public PageReference Editpage()
    {
        PageReference pg=new PageReference ('/apex/PurchaseOrderSettingEditPage?id='+EncodingUtil.urlEncode(pos.id,'UTF-8'));
        return pg;
    }
     /***********************************************
	 Save():redirect to PurchaseOrderSettingEditPage 
	************************************************/  
    Public PageReference Save()
    {
        PageReference pg=new PageReference ('/apex/PurchaseOrderSettingEditPage?id='+EncodingUtil.urlEncode(pos.id,'UTF-8'));
        return pg;
    }
     /****************************************************
		Cancel(): redirect to PurchaseOrderSettingEditPage 
	 *****************************************************/  
    Public PageReference Cancel()
    {
        PageReference pg=new PageReference ('/apex/PurchaseOrderSettingEditPage?id='+EncodingUtil.urlEncode(pos.id,'UTF-8'));
        return pg;
    }
    Public PageReference CloneRec()
    {
        return Null;
    }
    Public PageReference DeleteRec()
    {
        return Null;
    }
}