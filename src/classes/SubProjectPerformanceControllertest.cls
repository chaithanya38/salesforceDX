/*******************************************************
Class Name: SubProjectPerformanceControllertest
Author:Hussain      Last modified by:Raju GN
Date:  20/04/2015      Date:20/04/2015
********©2013 Musqot marketing technology Pvt ltd *******/
@isTest(seeAllData=true)
Public class SubProjectPerformanceControllertest{
    static testMethod void  TestSubProjectGanttController(){ 
        Plantype__c pt = new Plantype__c();
        pt.Barcolor__c = '6E766F';
        pt.Name = 'Zuri';
        System.assertEquals('Zuri', pt.name);
        insert pt;
        
        Project__c prj = new Project__c ();
        prj.Name='ITC';
        prj.Plantype__c= pt.Id;
        prj.Ends_date__c = system.toDay().addDays(3);
        prj.Starts_date__c= system.toDay();
        prj.Status__c = 'In Progress'; 
        System.assertEquals('ITC', prj.name);        
        insert prj;
        
        Project_type__c prjType = new Project_type__c();
        prjType.Name = 'Business';
        prjType.Color__c = 'FFFF01';
        System.assertEquals('Business', prjType.name);
        insert prjType; 
        
        Subproject__c subPrj = new Subproject__c();         
        subPrj.Name='ITC Project';
        subPrj.Parent_project__c = prj.Id;
        subPrj.Ends_date__c = system.toDay().addDays(3);
        subPrj.Starts_date__c= system.toDay();
        subPrj.Status__c = 'In Progress';
        subPrj.musqot__ERP__c= 'ERP';
        subPrj.musqot__CRM__c= 'CRM';
        subPrj.musqot__Social_media__c= 'Socialmedia'; 
        subPrj.Project_type__c = prjType.Id;
        System.assertEquals('ITC Project', subPrj.name);     
        insert subPrj;
        
        Subproject__c subsubPrj = new Subproject__c();         
        subsubPrj.Name='ITC Project';
        subsubPrj.Parent_project__c = prj.Id;
        subsubPrj.Ends_date__c = system.toDay().addDays(3);
        subsubPrj.Starts_date__c= system.toDay();
        subsubPrj.Status__c = 'In Progress';
        subsubPrj.Project_del__c = subPrj.Id;  
        subsubPrj.Project_type__c = prjType.Id;
         subsubPrj.musqot__ERP__c='test';
        subsubPrj.musqot__CRM__c='test';
        subsubPrj.musqot__Social_media__c='test';
        System.assertEquals('ITC Project', subsubPrj.name);
        insert subsubPrj;
        
        Activitytype__c objActivity = new Activitytype__c(); 
        objActivity.Name='test';
        objActivity.Icon__c='testicon';
        objActivity.Bar_color__c ='red';   
        insert objActivity;
        
         Marketing_activity__c objMarketingact=new Marketing_activity__c();
         objMarketingact.Name='test';
         objMarketingact.Description__c='tdescriptionest';
         objMarketingact.Status__c='completed'; 
         objMarketingact.Activitytype__c = objActivity.Id;
         objMarketingact.Starts_date__c = system.today();
         objMarketingact.Ends_date__c= system.today();
         objMarketingact.Project__c=subsubPrj.id;
         objMarketingact.ERP__c='testERP';
         objMarketingact.CRM__c='testCRM';
         objMarketingact.Social_media__c='facebook';
         insert objMarketingact;
         System.assertEquals('test', objMarketingact.Name);
        
        ERP_logfile__c err = new ERP_logfile__c();
        err.Imported__c = true;
        err.Import_message__c = 'Good';
        err.Number_of_records__c = 10;
        insert err;
        
        ERP_sales_obj__c ess = new ERP_sales_obj__c();
        ess.Name = 'test';
        ess.Business_region__c = 'APAC';
        ess.Business_area__c = 'Prodcut';
        ess.sales_import_id__c = 'uftyft';
        ess.Sales_date__c = system.today();
        ess.Sales__c = 1000.00;
        ess.Sales_import_date__c = system.today();
        ess.ERP_logfile__c = err.Id;
        
        insert ess;
            
        socialmedia_settings__c ss = new socialmedia_settings__c();
        ss.Socialmedia_type__c = 'Facebook';
        ss.Import_rate__c = 'Day';
        ss.Watch_type__c = 'Visitor';
        ss.Chart__c = 'bar';
        insert ss;
 
        Social_media_data__c smd = new Social_media_data__c();        
        smd.Date__c = system.today();
        smd.Number_of_likes__c = 4;
      //  smd.Socialmedia_Settings__c = ss.Id; 
        smd.Name = 'test';              
        insert smd;
        ApexPages.currentPage().getParameters().put('subid', subsubPrj.id);  
        //ApexPages.StandardController sc = new ApexPages.standardController(subsubPrj);
        SubProjectPerformanceController SGPC = new SubProjectPerformanceController();
        SubProjectPerformanceController.GanttRow actWrp = new SubProjectPerformanceController.GanttRow(); 
        List<ERP_Settings__c> temp1=SGPC.erpChartList;  
        List<CRM_Settings__c> temp2=SGPC.crmChartList;
        List<socialmedia_settings__c> temp3=SGPC.mediaSettigs;
        SGPC.gotoProjectPage();
    
        SGPC.getjsString();
        SGPC.gettaskstyleString();         
        SGPC.getdataString();
        try{
        SGPC.getFbData();
        }catch(exception e){}
        SGPC.showSelectedPlanTypes();
        SGPC.getData();
        List<SelectOption> opl = SGPC.PlanList;
        
        SGPC.IsDeleted=true;
        //SGPC.selStr='test';
        }
        
       static testMethod void  TestSubProjectGanttController1(){ 
        Plantype__c pt = new Plantype__c();
        pt.Barcolor__c = '6E766F';
        pt.Name = 'Zuri';
        System.assertEquals('Zuri', pt.name);
        insert pt;
        
        Project__c prj = new Project__c ();
        prj.Name='ITC';
        prj.Plantype__c= pt.Id;
        prj.Ends_date__c = system.toDay().addDays(3);
        prj.Starts_date__c= system.toDay();
        prj.Status__c = 'In Progress'; 
        System.assertEquals('ITC', prj.name);        
        insert prj;
        
        Project_type__c prjType = new Project_type__c();
        prjType.Name = 'Business';
        prjType.Color__c = 'FFFF01';
        System.assertEquals('Business', prjType.name);
        insert prjType; 
        
        Subproject__c subPrj = new Subproject__c();         
        subPrj.Name='ITC Project';
        subPrj.Parent_project__c = prj.Id;
        subPrj.Ends_date__c = system.toDay().addDays(3);
        subPrj.Starts_date__c= system.toDay();
        subPrj.Status__c = 'In Progress';
        subPrj.musqot__ERP__c= 'ERP';
        subPrj.musqot__CRM__c= 'CRM';
        subPrj.musqot__Social_media__c= 'Socialmedia'; 
        subPrj.Project_type__c = prjType.Id;
        System.assertEquals('ITC Project', subPrj.name);     
        insert subPrj;
        
        Subproject__c subsubPrj = new Subproject__c();         
        subsubPrj.Name='ITC Project';
        subsubPrj.Parent_project__c = prj.Id;
        subsubPrj.Ends_date__c = system.toDay().addDays(3);
        subsubPrj.Starts_date__c= system.toDay();
        subsubPrj.Status__c = 'In Progress';
        subsubPrj.Project_del__c = subPrj.Id;  
        subsubPrj.Project_type__c = prjType.Id;
        System.assertEquals('ITC Project', subsubPrj.name);
        insert subsubPrj;
        
        Activitytype__c objActivity = new Activitytype__c(); 
        objActivity.Name='test';
        objActivity.Icon__c='testicon';
        objActivity.Bar_color__c ='red';   
        insert objActivity;
        
         Marketing_activity__c objMarketingact=new Marketing_activity__c();
         objMarketingact.Name='test';
         objMarketingact.Description__c='tdescriptionest';
         objMarketingact.Status__c='completed'; 
         objMarketingact.Activitytype__c = objActivity.Id;
         objMarketingact.Starts_date__c = system.today();
         objMarketingact.Ends_date__c= system.today();
         insert objMarketingact;
        
        ERP_logfile__c err = new ERP_logfile__c();
        err.Imported__c = true;
        err.Import_message__c = 'Good';
        err.Number_of_records__c = 10;
        insert err;
        
        ERP_sales_obj__c ess = new ERP_sales_obj__c();
        ess.Name = 'test';
        ess.Business_region__c = 'APAC';
        ess.Business_area__c = 'Prodcut';
        ess.sales_import_id__c = 'uftyft';
        ess.Sales_date__c = system.today();
        ess.Sales__c = 1000.00;
        ess.Sales_import_date__c = system.today();
        ess.ERP_logfile__c = err.Id;
        
        insert ess;
            
        socialmedia_settings__c ss = new socialmedia_settings__c();
        ss.Socialmedia_type__c = 'Facebook';
        ss.Import_rate__c = 'Day';
        ss.Watch_type__c = 'Visitor';
        ss.Chart__c = 'bar';
        insert ss;
 
        Social_media_data__c smd = new Social_media_data__c();        
        smd.Date__c = system.today()+2;
        //smd.Number_of_likes__c = 4;
      //  smd.Socialmedia_Settings__c = ss.Id; 
         smd.Name = 'test';              
      insert smd;
      
      musqot__CRM_logfile__c log=new musqot__CRM_logfile__c();
      log.musqot__Imported__c=true;
      log.musqot__Import_message__c='test';
      log.musqot__Number_of_records__c=55;
      insert log;
      
      CRM_data__c crm=new CRM_data__c();
      crm.musqot__Business_area__c='testArea';
      crm.musqot__Business_region__c='testRegion';
      crm.musqot__CRM_import_date__c=system.today();
      crm.musqot__CRM_import_id__c='test';
      crm.musqot__CRM_logfile__c=log.id;
      crm.musqot__Date__c=system.today();
      crm.musqot__No_Deals__c=4;
      crm.musqot__No_Leads__c=4;
      //crm.musqot__No_Opportunities__c=4;
     // crm.musqot__Value_Deals__c=50.00;
      //crm.musqot__Value_w_Opportunities__c=50.00;
      //crm.musqot__Value_Opportunities__c=50.00;
      crm.Date__c=system.today()+2;
      insert crm;
      
        ApexPages.currentPage().getParameters().put('subid', subsubPrj.id);  
        //ApexPages.StandardController sc = new ApexPages.standardController(subsubPrj);
        ApexPages.currentPage().getParameters().put('ganttid','01Ib0000000kPLw');
        SubProjectPerformanceController SGPC = new SubProjectPerformanceController();
        SubProjectPerformanceController.GanttRow actWrp = new SubProjectPerformanceController.GanttRow(); 
        List<ERP_Settings__c> temp1=SGPC.erpChartList;  
        List<CRM_Settings__c> temp2=SGPC.crmChartList;
        List<socialmedia_settings__c> temp3=SGPC.mediaSettigs;
        SGPC.gotoProjectPage();
    
        SGPC.getjsString();
        SGPC.gettaskstyleString();         
        SGPC.getdataString();
        try{
        SGPC.getFbData();
        }catch(exception e){}
        SGPC.showSelectedPlanTypes();
        SGPC.getData();
        List<SelectOption> opl = SGPC.PlanList;
        SGPC.getCRMData();
        SGPC.IsDeleted=true;
        //SGPC.selStr='test';
        date sdate=system.today();
        date edate=system.today()+2;
        //SGPC.setDuration(sdate,edate);
        }
       
    }