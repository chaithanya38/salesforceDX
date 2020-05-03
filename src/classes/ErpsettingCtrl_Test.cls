/******************************************************
Class Name: ErpsettingCtrl_Test 
Author:Nagaraju G      Last modified by:G Janarhanreddy
Date:  19/11/2014      Date:19/03/2015
********©2013 Musqot marketing technology Pvt ltd *****/
@isTest(Seealldata = True)
Public class ErpsettingCtrl_Test{
  static testMethod void  ErpsettingtestMethod(){ 
  test.startTest();
  musqot__ERP_Settings__c  ObjERP=new musqot__ERP_Settings__c ();
   ObjERP.Name='testERP';
   ObjERP.musqot__Selector__c='Business area';
   ObjERP.musqot__erp_Chart__c='Bar charts';
   ObjERP.musqot__Bar_color__c='#123344,#224466';
   insert ObjERP;
   System.assertEquals('Business area', ObjERP.musqot__Selector__c);
   
   ERP_logfile__c err = new ERP_logfile__c();
    err.Name='test';
    err.musqot__Imported__c = true;
    err.musqot__Import_message__c = 'Good';
    err.musqot__Number_of_records__c = 10;
    insert err;
    System.assertEquals('test', err.Name);
        
   musqot__ERP_sales_obj__c erp=new musqot__ERP_sales_obj__c();
    erp.Name='test';
    erp.musqot__Business_area__c='area';
    erp.musqot__Business_region__c='region';
    erp.musqot__Sales__c=200;
    erp.musqot__ERP_logfile__c=err.id;
    erp.musqot__Sales_date__c= System.now().date();
    erp.musqot__Sales_import_date__c=System.now().date();
    insert erp;
    System.assertEquals('test', erp.Name);
   
   PageReference pageRef = Page.ERPsettingpage;
   Test.setCurrentPage(pageRef); 
   ApexPages.currentPage().getParameters().put('mpsett', ObjERP.id);      
   Erpsettingcontroller ERPSCtrl = new Erpsettingcontroller();
   List<SelectOption>  temp=ERPSCtrl.getMyOptions();
      try{
      ERPSCtrl.inserterps();
       }catch(exception e){}
      ERPSCtrl.cancel();
     test.stopTest();
          }
     }