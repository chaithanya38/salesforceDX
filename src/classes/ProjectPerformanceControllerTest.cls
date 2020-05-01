/*******************************************************
Class Name: ProjectPerformanceControllerTest
Author:Hussain      Last modified by: Hussain
Date:  20/04/2015      Date:20/04/2015
********©2013 Musqot marketing technology Pvt ltd *******/
@isTest(seeAllData=true)
Public class ProjectPerformanceControllerTest{
    static testMethod void  TestProjectPerformanceController(){ 
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
        prj.musqot__ERP__c='test';
        prj.musqot__CRM__c='test';
        prj.musqot__Social_media__c='test';
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
        smd.Socialmedia_Settings__c = ss.Id; 
        smd.Name = 'test';              
        insert smd;
        
        PageReference testPage = new pagereference('/apex/ProjectPerformance');
        testPage.getParameters().put('id', 'prj.id');
        Test.setCurrentPage(testPage);
        
        ApexPages.currentPage().getParameters().put('planid', prj.id);  
        ProjectPerformanceController GPC = new ProjectPerformanceController();
        ProjectPerformanceController.GanttRow wrp=new ProjectPerformanceController.GanttRow();
           List<ERP_Settings__c> temp1=GPC.erpChartList;  
            List<CRM_Settings__c> temp2=GPC.crmChartList; 
        List<socialmedia_settings__c> temp3=GPC.mediaSettigs;
        GPC.gotoPlanPage();
        GPC.getjsString();
        GPC.gettaskstyleString();         
        GPC.getdataString();
        GPC.getFbData();
        GPC.showSelectedPlanTypes();
        GPC.getData();
        List<SelectOption> opl = GPC.PlanList;
        //GPC.gotoGanttPage();
        GPC.IsDeleted=true;
        //GPC.selStr='test';             
        ProjectPerformanceController.GanttRow ganttwrap= new ProjectPerformanceController.GanttRow();
        ganttwrap.idPH='ph';
        ganttwrap.text='testPH';
        ganttwrap.typePH='testPH';
        ganttwrap.start_date='sdate';
        ganttwrap.description='desc';
        ganttwrap.duration=1;
        ganttwrap.progress=100;
        ganttwrap.open=false;
        ganttwrap.parent='testParent';
        ganttwrap.img='testimg';
        ganttwrap.objType='asia';
        ganttwrap.actImg='testact';              
        }
     static testMethod void  TestProjectPerformanceController1(){ 
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
        smd.Date__c = system.today();
        smd.Number_of_likes__c = 4;
        smd.Socialmedia_Settings__c = ss.Id; 
        smd.Name = 'test';              
        insert smd;
        
        PageReference testPage = new pagereference('/apex/ProjectPerformance');
        testPage.getParameters().put('id', 'prj.id');
        Test.setCurrentPage(testPage);
        
        ApexPages.currentPage().getParameters().put('planid', prj.id);  
        ProjectPerformanceController GPC = new ProjectPerformanceController();
        ProjectPerformanceController.GanttRow wrp=new ProjectPerformanceController.GanttRow();
           List<ERP_Settings__c> temp1=GPC.erpChartList;  
            List<CRM_Settings__c> temp2=GPC.crmChartList; 
         List<socialmedia_settings__c> temp3=GPC.mediaSettigs;
        GPC.gotoPlanPage();
        GPC.getjsString();
        GPC.gettaskstyleString();         
        GPC.getdataString();
        GPC.getFbData();
        GPC.showSelectedPlanTypes();
        GPC.getData();
        List<SelectOption> opl = GPC.PlanList;
        //GPC.gotoGanttPage();
        GPC.IsDeleted=true;
        //GPC.selStr='test';
    }
}