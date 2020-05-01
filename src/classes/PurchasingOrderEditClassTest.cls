/****************************************************************
Class Name: PurchasingOrderEditClassTest
Author:chaithanya daggumati     Last modified by: Janardhan reddy
Date: 21/7/2014                 Date: 18/2/2015 
********©2013 Musqot marketing technology Pvt ltd ***************/

@isTest
    public class PurchasingOrderEditClassTest{
        static testMethod void PurchasingOrderEdit(){
        Purchase_order_setting__c objpos = new Purchase_order_setting__c ();
        objpos .name = 'test';
        objpos .PO_Startnumber__c= 1;
         objpos.musqot__PO_Prefix__c='auto';
         objpos.PO_Autoprefix__c='test';
         objpos.PO_External__c='auto';
         objpos.PO_Lastnumber__c =2;
        objpos.musqot__PO_Lastnumber__c = objpos.musqot__PO_Startnumber__c;  
        System.assertEquals('test', objpos.name);
        insert objpos;
       
        Attachment att = new  Attachment();
        att.ParentId = objpos.Id;
        att.body = Blob.valueOf('Unit Test Attachment Body');
        att.contentType = 'application/msword';
        att.Name = 'test';
        insert att;

        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', objpos.id);
        PageReference pageRef = Page.PurchaseOrderSettingEditPage; 
        Test.setCurrentPage(pageref);
        ApexPages.StandardController sc = new ApexPages.standardController(objpos);
        PurchasingOrderEditClass poes = new PurchasingOrderEditClass(sc);                            
        poes .Save();
        poes .Cancel();
        poes.gotoEditMode();
        poes.gotoInfoMode(); 
        //poes.Pageid='test';
        //poes.contentType='test';
        //poes.fileType='test';
        Test.stopTest();             
           }
 static testMethod void PurchasingOrderEdit1(){
        Purchase_order_setting__c objpos = new Purchase_order_setting__c ();
        objpos .name = 'test';
        objpos .PO_Startnumber__c= 1;
        objpos.musqot__PO_Prefix__c='auto';
        objpos.PO_Autoprefix__c='test';
        objpos.PO_External__c='auto';
        objpos.PO_Lastnumber__c =2;
        objpos.musqot__PO_Lastnumber__c = objpos.musqot__PO_Startnumber__c;  
        System.assertEquals('test', objpos.name);
        insert objpos;          
        
        Test.startTest();        
        PageReference pageRef = Page.PurchaseOrderSettingEditPage; 
        Test.setCurrentPage(pageref);
        ApexPages.currentPage().getParameters().put('id', objpos.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objpos);        
        PurchasingOrderEditClass poes = new PurchasingOrderEditClass(sc); 
        Purchase_order_setting__c posetting=[SELECT id,Name,PO_Startnumber__c,PO_Prefix__c,PO_Autoprefix__c,PO_External__c,PO_Lastnumber__c FROM Purchase_order_setting__c];
        posetting.musqot__PO_Lastnumber__c=posetting.musqot__PO_Startnumber__c;
        upsert posetting; 
        Test.stopTest();
        }
   }