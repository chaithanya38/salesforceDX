/*************************************************************************
Class Name: UpdateTotalInvoicetest 
Author:G Janardhanreddy             Last modified by: Chaithanya daggumati
Date: 6/1/2015                      Date: 19/3/2015
********©2013 Musqot marketing technology Pvt ltd ************************/
@isTest(seeAllData=true)
public class UpdateTotalInvoicetest{
    static testMethod void Purchaseordertest(){
        Project__c prj = new Project__c ();
        prj.Name='ITC';
        prj.Plantype__c=  prj.Id;
        prj.Ends_date__c = system.toDay().addDays(3);
        prj.Starts_date__c= system.toDay();
        prj.Status__c = 'In Progress';
        System.assertEquals('ITC', prj.name); 
        try{        
        insert prj;
        }catch(Exception e){}
        
        Subproject__c subPrj = new Subproject__c();         
        subPrj.Name='ITC Project';
        subPrj.Parent_project__c = prj.Id;
        subPrj.Ends_date__c = system.toDay().addDays(3);
        subPrj.Starts_date__c= system.toDay();
        subPrj.Status__c = 'In Progress'; 
        subPrj.Parent_project__c = prj.Id;
        System.assertEquals('ITC Project', subPrj.name);     
        insert subPrj;
       
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact;
        
        Purchase_order__c objpurchase=new Purchase_order__c ();   
        objpurchase.Name='testpurchaces';
        objpurchase.musqot__Purchase_order_name__c='testperchage';
        objpurchase.musqot__Project__c=prj.Id;
        objpurchase.musqot__subproject__c=subPrj.Id;
        objpurchase.musqot__Marketing_activity__c=objMarketingact.Id;
        objpurchase.musqot__Supplier_email__c='test@gmail.com';
        objpurchase.musqot__Total_cost__c=100;
        objpurchase.musqot__Supplier__c='testsuppilor';
        objpurchase.musqot__Send_date__c=system.today();
        objpurchase.musqot__Effective_date__c=system.today();
        objpurchase.musqot__Purchase_order_cloesed__c = true;
        objpurchase.musqot__total_Invoice_cost__c=10;
        System.assertEquals('testpurchaces', objpurchase.Name);
        insert objpurchase;
       
        Invoice__c  objInvoice=new Invoice__c();
        objInvoice.Name='testinvoice';
        objInvoice.musqot__Project__c=prj.Id;
        objInvoice.Purchase_orders__c=objpurchase.id;
        objInvoice.musqot__subproject__c=subPrj.Id;
        objInvoice.musqot__Marketing_activity__c=objMarketingact.Id;
        objInvoice.musqot__supplier__c='testsupplier';
        System.assertEquals('testinvoice', objInvoice.Name);
        try{
        insert objInvoice;
        }catch(Exception e){}
        
        Purchase_order_setting__c objpoorderset = new Purchase_order_setting__c();
        objpoorderset.musqot__PO_Startnumber__c = 10;
        System.assertEquals(10, objpoorderset .musqot__PO_Startnumber__c);
        insert objpoorderset;                   
              }
            }