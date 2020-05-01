/*******************************************************
Class Name: CRMsettingcontrollertest
Author:Nagaraju G      Last modified by:G Janarhanreddy
Date:  19/11/2014      Date:19/03/2015
********©2013 Musqot marketing technology Pvt ltd *******/
@isTest(Seealldata = True)
Public class CRMsettingcontrollertest{
    static testMethod void  CRMsettingcontroller(){
      musqot__CRM_logfile__c log=new musqot__CRM_logfile__c();
      log.musqot__Imported__c=true;
      log.musqot__Import_message__c='test';
      log.musqot__Number_of_records__c=55;
      insert log;
      
      CRM_data__c crm=new CRM_data__c();
      crm.musqot__Business_area__c='test';
      crm.musqot__Business_region__c='test';
      crm.musqot__CRM_import_date__c=system.today();
      crm.musqot__CRM_import_id__c='test';
      crm.musqot__CRM_logfile__c=log.id;
      crm.musqot__Date__c=system.today();
      crm.musqot__No_Deals__c=4;
      crm.musqot__No_Leads__c=4;
      crm.musqot__No_Opportunities__c=4;
     crm.musqot__Value_Deals__c=50.00;
     crm.musqot__Value_w_Opportunities__c=50.00;
     crm.musqot__Value_Opportunities__c=50.00;
     insert crm; 
     
    CRM_settings__c mr=new CRM_settings__c();
    mr.Bar_color__c='#369E2B';
    mr.Chart__c='test';
    mr.CRM_performance_type__c='test';
    mr.Expression_business_area__c='test';
    mr.Expression_business_region__c='test';
    mr.Selector__c='test';
    insert mr;
    System.assertEquals('#369E2B', mr.Bar_color__c);
    
    musqot__Activity__c m1 =new musqot__Activity__c();
    m1.musqot__keycode__c='212';
    m1.musqot__Use_Allocation__c=true;
    m1.musqot__Use_Budget__c=true;
    m1.musqot__Use_Finance1__c=true;
    m1.musqot__Use_Forcasting__c=true;
    m1.musqot__Use_milestones__c=true;
    m1.musqot__Use_Resource__c=true;
    m1.Use_Performance_CRM__c='Salesforce (in same org)';
    System.assertEquals('212', m1.musqot__keycode__c);
    insert m1;
    
   test.startTest();
   PageReference pageRef = Page.CRMsetting;
   Test.setCurrentPage(pageRef); 
   ApexPages.currentPage().getParameters().put('crmid', mr.id);      
   CRMsettingcontroller crmctrl = new CRMsettingcontroller();
   //CRMsettingcontroller.Summary sum= new CRMsettingcontroller.Summary();
   List<SelectOption> myoption = crmctrl.getMyOptions();
   List<SelectOption> watch= crmctrl.getwatchtype ();
   List<SelectOption> leads=crmctrl.getleadsources;
   //List<SelectOption> campns=crmctrl.getCampaigns;
   Lead temp21=crmctrl.leadsrce;
   try{
   String[] lead1=crmctrl.LeadItems;
   //String[] camp1=crmctrl.campItems;
   Lead temp=crmctrl.leadsrce;
   }catch(exception e){}
   List<String> stringList = new List<String>{'string1','string2','string3'};
   crmctrl.LeadItems = stringList;
   //crmctrl.campItems= stringList;
   String s ='ABC;xyz';
   String selectedConcat = s;
   crmctrl.Level1=true;   
      try{
      crmctrl.insertcrms();
       }catch(exception e){}
      crmctrl.cancel();
      
     test.stopTest();
    }
      
    static testMethod void  CRMsettingcontroller1(){ 
    CRM_settings__c mr=new CRM_settings__c();
    mr.Bar_color__c='test';
    mr.Chart__c='test';
    mr.CRM_performance_type__c='test';
    mr.Expression_business_area__c='test';
    mr.Expression_business_region__c='test';
    mr.Selector__c='test';
    insert mr;
    System.assertEquals('test', mr.Bar_color__c);
    musqot__Activity__c m1 =new musqot__Activity__c();
    m1.musqot__keycode__c='212';
    m1.musqot__Use_Allocation__c=true;
    m1.musqot__Use_Budget__c=true;
    m1.musqot__Use_Finance1__c=true;
    m1.musqot__Use_Forcasting__c=false;
    m1.musqot__Use_milestones__c=false;
    m1.musqot__Use_Resource__c=true;
    m1.Use_Performance_CRM__c='Salesforce (in same org)';
    System.assertEquals('212', m1.musqot__keycode__c);
    insert m1;
    
   test.startTest();
   PageReference pageRef = Page.CRMsetting;
   Test.setCurrentPage(pageRef); 
   ApexPages.currentPage().getParameters().put('crmid', mr.id);      
   CRMsettingcontroller crmctrl = new CRMsettingcontroller();
   List<SelectOption> myoption = crmctrl.getMyOptions();
   List<SelectOption> watch= crmctrl.getwatchtype ();
   List<SelectOption> leads=crmctrl.getleadsources;
   //List<SelectOption> campns=crmctrl.getCampaigns;
   Lead temp21=crmctrl.leadsrce;
   try{
   String[] lead1=crmctrl.LeadItems;
   //String[] camp1=crmctrl.campItems;
   Lead temp=crmctrl.leadsrce;
   }catch(exception e){}
   String s ='ABC;xyz';
   String selectedConcat = s;
   crmctrl.Level1=true;   
      try{
      crmctrl.insertcrms();
       }catch(exception e){}
      crmctrl.cancel();
      
     test.stopTest();
     }
 }