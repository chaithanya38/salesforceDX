/*******************************************************
Class Name: ERPSalesCotrollertest   
Author:G Janardhanreddy     Last modified by:G Janarhanreddy
Date:  2/1/2015                  Date:19/03/2015
********©2013 Musqot marketing technology Pvt ltd *******/
@isTest
public class ERPSalesCotrollertest
{
    static testMethod void ERPSalesCotroller()
    {
        musqot__ERP_logfile__c mus=new musqot__ERP_logfile__c();
        
        mus.musqot__Import_message__c='helloworld';
        mus.musqot__Number_of_records__c=2;
        System.assertEquals('helloworld', mus.Import_message__c);
        insert mus;
        
        musqot__ERP_sales_obj__c erp=new musqot__ERP_sales_obj__c();
        erp.musqot__Business_area__c='hyd';
        erp.musqot__Business_region__c='india';
        erp.musqot__Sales__c=200;
        erp.musqot__ERP_logfile__c=mus.id;
        
        erp.musqot__Sales_date__c= System.now().date();
        erp.musqot__Sales_import_date__c=System.now().date();
        System.assertEquals('hyd', erp.Business_area__c);
        insert erp;
        JSONGenerator jsonGen = JSON.createGenerator(true);
        ERPSalesCotroller erpcont=new ERPSalesCotroller();
        erpcont.getData();
    }
}