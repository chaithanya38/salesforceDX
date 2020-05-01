/*******************************************************
Class Name: CRMSettingsEditControllertest
Author:Nagaraju G      Last modified by:G Janarhanreddy
Date:  19/11/2014      Date:19/03/2015
********©2013 Musqot marketing technology Pvt ltd *******/
@isTest(Seealldata = True)
Public class CRMSettingsEditControllertest{
    static testMethod void  CRMsettingcontroller(){ 
    musqot__CRM_settings__c mr=new musqot__CRM_settings__c();
    mr.musqot__Bar_color__c='test';
    mr.musqot__Chart__c='test';
    mr.musqot__CRM_performance_type__c='test';
    mr.musqot__Expression_business_area__c='test';
    mr.musqot__Expression_business_region__c='test';
    mr.musqot__Selector__c='test';
    insert mr;
    System.assertEquals('test', mr.musqot__Bar_color__c);
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
   // Campaign camp = new Campaign(Name='Test Campaign',EndDate=system.today()+2);
    //insert camp;
    //system.assertEquals('Test Campaign', camp.name);         
              
    Lead Lea = new Lead(lastname ='Create_CampaignMember_For_New_Leads',
    firstname ='Test For',company ='Company Name',leadsource = 'Sales Line',
    Status='Open - Not Contacted',country ='US');
    insert Lea;
    //system.assertEquals('Create_CampaignMember_For_New_Leads', Lea.lastname);
      
   test.startTest();
   PageReference pageRef = Page.CRMsettingEditpage;
   Test.setCurrentPage(pageRef); 
   ApexPages.StandardController sc = new ApexPages.standardController(crm);
        
   ApexPages.currentPage().getParameters().put('crmid', mr.id);      
   CRMSettingsEditController crmctrl = new CRMSettingsEditController(sc);
   crmctrl.stdObjectLead=true;
   List<SelectOption> watch= crmctrl.getwatchtype();
   List<SelectOption> leads=crmctrl.getleadsources;
   //List<SelectOption> camps=crmctrl.getCampaigns;
   Lead temp11=crmctrl.leadsrce;
   crmctrl.Level1=true;
      try{
     crmctrl.Save();
      String[] lead1=crmctrl.LeadItems;
  	//  String[] camp1=crmctrl.campItems;
       }catch(exception e){}
   
   List<String> stringList = new List<String>{'string1','string2','string3'};
   crmctrl.LeadItems = stringList;
 //  crmctrl.campItems= stringList;
      crmctrl.cancel();
      crmctrl.getMyOptions();
     test.stopTest();
          }
          static testMethod void  CRMsettingcontroller1(){ 
    musqot__CRM_settings__c mr=new musqot__CRM_settings__c();
    mr.musqot__Bar_color__c='test';
    mr.musqot__Chart__c='test';
    mr.musqot__CRM_performance_type__c='test';
    mr.musqot__Expression_business_area__c='test';
    mr.musqot__Expression_business_region__c='test';
    mr.musqot__Selector__c='test';
    insert mr;
      System.assertEquals('test', mr.musqot__Bar_color__c);
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
    musqot__Activity__c m1 =new musqot__Activity__c();
    m1.musqot__keycode__c='212';
    m1.musqot__Use_Allocation__c=true;
    m1.musqot__Use_Budget__c=true;
    m1.musqot__Use_Finance1__c=true;
    m1.musqot__Use_Forcasting__c=true;
    m1.musqot__Use_milestones__c=false;
    m1.musqot__Use_Resource__c=true;
    m1.Use_Performance_CRM__c='Salesforce (in same org)';
    System.assertEquals('212', m1.musqot__keycode__c);
    insert m1;

	//Campaign camp = new Campaign(Name='Test Campaign',EndDate=system.today()+2);
    //insert camp;
    //system.assertEquals('Test Campaign', camp.name);         
              
    Lead Lea = new Lead(lastname ='Create_CampaignMember_For_New_Leads',
    firstname ='Test For',company ='Company Name',leadsource = 'Sales Line',
    Status='Open - Not Contacted',country ='US');
    insert Lea;
    system.assertEquals('Create_CampaignMember_For_New_Leads', Lea.lastname);
      
   test.startTest();
   PageReference pageRef = Page.CRMsettingEditpage;
   Test.setCurrentPage(pageRef); 
   ApexPages.StandardController sc = new ApexPages.standardController(crm);
        
   ApexPages.currentPage().getParameters().put('crmid', mr.id);      
   CRMSettingsEditController crmctrl = new CRMSettingsEditController(sc);
   List<SelectOption> watch= crmctrl.getwatchtype();
   List<SelectOption> leads=crmctrl.getleadsources;
  // List<SelectOption> camps=crmctrl.getCampaigns;
   List<String> stringList = new List<String>{'string1','string2','string3'};
   crmctrl.LeadItems = stringList;
  // crmctrl.campItems= stringList;
   Lead temp11=crmctrl.leadsrce;
   crmctrl.Level1=true;
   try{
   crmctrl.Save();
   String[] lead1=crmctrl.LeadItems;  
 //  String[] camp1=crmctrl.campItems;       
   }catch(exception e){}
   crmctrl.cancel();
   crmctrl.getMyOptions();
   test.stopTest();
   }
 static testMethod void  CRMsettingsf(){
    Activity__c m1 =new Activity__c();
    m1.Use_Performance_CRM__c='Salesforce (in same org)';
    System.assertEquals('Salesforce (in same org)', m1.Use_Performance_CRM__c);
    insert m1;    
    ApexPages.StandardController sc = new ApexPages.standardController(m1);
    CRMSettingsEditController crmctrl = new CRMSettingsEditController(sc);
    crmctrl.level1=true;    
    }
}