/*******************************************************
Class Name: ERPSalesGanttControllerTest
Author:Hussain      Last modified by: Hussain
Date:  20/04/2015      Date:20/04/2015
********©2013 Musqot marketing technology Pvt ltd *******/
@isTest(seeAllData=true)
Public class ERPSalesGanttControllerTest{
    static testMethod void  TestERPSalesGanttController(){
        Profile p = [select id from profile where name='System Administrator']; 
        User objUser = new User(alias = 'stan', email='standarduser@test.com', 
                                emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
                                localesidkey='en_US', profileid = p.Id, 
                                timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
        insert objUser ;  
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=objUser.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c); 
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
        prj.ownerid =plm.userid__c;
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
        
       CRM_data__c crm=new CRM_data__c();
       crm.musqot__Business_area__c='test';
       crm.musqot__Business_region__c='test';
       crm.musqot__CRM_import_date__c=system.today();
       crm.musqot__CRM_import_id__c='test';
       //crm.musqot__CRM_logfile__c=log.id;
       crm.musqot__Date__c=system.today();
       crm.musqot__No_Deals__c=4;
       crm.musqot__No_Leads__c=4;
       crm.musqot__No_Opportunities__c=4;
       crm.musqot__Value_Deals__c=50.00;
       crm.musqot__Value_w_Opportunities__c=50.00;
       crm.musqot__Value_Opportunities__c=50.00;
       insert crm;
        
        socialmedia_settings__c ss = new socialmedia_settings__c();
        ss.Socialmedia_type__c = 'Facebook';
        ss.Import_rate__c = 'Day';
        ss.Watch_type__c = 'Visitor';
        ss.Chart__c = 'bar';
        insert ss;
        
        Social_media_data__c smd = new Social_media_data__c();        
        smd.Date__c = system.today();
        smd.Number_of_likes__c = 4;
       
       // smd.connection__c = ss.Id; 
        smd.Name = 'test';              
        insert smd;
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null,'1.0');
        w.writeStartElement(null,'gantt',null);        
        w.writeStartElement(null,'gtimeSlot',null);
        w.writeEndElement();
        w.writeStartElement(null,'gstartDate',null);
        w.writeEndElement();
        w.writeStartElement(null,'gendDate',null);
        w.writeEndElement();
        ERPSalesGanttController GPC = new ERPSalesGanttController();
        GPC.FilterZooming='Days';
        GPC.selectedFilter='2366666';
        GPC.FilterStartDate=system.today();
        GPC.FilterEndDate=system.today()+10;
        GPC.getjsString();
        GPC.gettaskstyleString();         
        GPC.getdataString();
        try{
        GPC.getFbData();
        }catch(exception e){}
        GPC.getCRMData();
        GPC.showSelectedPlanTypes();
        GPC.getData();
        List<SelectOption> opl = GPC.PlanList;
        List<SelectOption> opl1 = GPC.FilterList;
        GPC.gotoGanttPage();        
        try{
        GPC.SaveFilter();
        GPC.DeleteFilter();
        GPC.closePopup();
        }catch(exception e){}
        GPC.showPopup();
        GPC.loadviewbyFilter();
        GPC.IsDeleted=true;
        GPC.selStr='test';
        GPC.MyProflieName='pname';
        GPC.Level1=false;
        GPC.addfiltersetting=true;
        GPC.displayPopup=true;
        }
 static testMethod void  TestERPSalesGanttController1(){
     	Profile p = [select id from profile where name='System Administrator']; 
        User objUser = new User(alias = 'stan', email='standarduser@test.com', 
                                emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
                                localesidkey='en_US', profileid = p.Id, 
                                timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
        insert objUser ;  
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=objUser.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c); 
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
     	prj.OwnerId=plm.userid__c;
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
        
       CRM_data__c crm=new CRM_data__c();
       crm.musqot__Business_area__c='test';
       crm.musqot__Business_region__c='test';
       crm.musqot__CRM_import_date__c=system.today();
       crm.musqot__CRM_import_id__c='test';
       //crm.musqot__CRM_logfile__c=log.id;
       crm.musqot__Date__c=system.today();
       crm.musqot__No_Deals__c=4;
       crm.musqot__No_Leads__c=4;
       crm.musqot__No_Opportunities__c=4;
       crm.musqot__Value_Deals__c=50.00;
       crm.musqot__Value_w_Opportunities__c=50.00;
       crm.musqot__Value_Opportunities__c=50.00;
       insert crm;
        
        socialmedia_settings__c ss = new socialmedia_settings__c();
        ss.Socialmedia_type__c = 'Facebook';
        ss.Import_rate__c = 'Day';
        ss.Watch_type__c = 'Visitor';
        ss.Chart__c = 'bar';
        insert ss;
        
        Social_media_data__c smd = new Social_media_data__c();        
        smd.Date__c = system.today();
        smd.Number_of_likes__c = 4;
       
       // smd.connection__c = ss.Id; 
        smd.Name = 'test';              
        insert smd;
        
        ERPSalesGanttController GPC = new ERPSalesGanttController();
        GPC.selectedFilter='0';
        GPC.FilterZooming='weeks';
        GPC.FilterStartDate=system.today();
        GPC.FilterEndDate=system.today()+10;
        GPC.getjsString();
        GPC.gettaskstyleString();         
        GPC.getdataString();
        try{
        GPC.getFbData();
        }catch(exception e){}
        GPC.getCRMData();
        GPC.showSelectedPlanTypes();
        GPC.getData();
        List<SelectOption> opl = GPC.PlanList;
        List<SelectOption> opl1 = GPC.FilterList;
        GPC.gotoGanttPage();        
        try{
        GPC.closePopup();
        GPC.SaveFilter();
        GPC.DeleteFilter();
        }catch(exception e){}
        GPC.showPopup();
        GPC.loadviewbyFilter();
        GPC.IsDeleted=true;
        GPC.selStr='test';
        GPC.MyProflieName='pname';
        GPC.Level1=false;
        GPC.addfiltersetting=true;
        GPC.displayPopup=true;
        }
    static testMethod void ERPSalesGanttfilter(){
        Profile p = [select id from profile where name='System Administrator']; 
        User objUser = new User(alias = 'stan', email='standarduser@test.com', 
                                emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
                                localesidkey='en_US', profileid = p.Id, 
                                timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
        insert objUser ;
        
        User_setting__c gantt=new User_setting__c();
        gantt.Gantt_type__c=2;
        gantt.Ganttview__c='test';
        gantt.Global__c=true;
        gantt.My_default__c=true;
        gantt.Userid__c=objUser.id;
        insert gantt;
        
        ERPSalesGanttController GPC = new ERPSalesGanttController();
        GPC.mydefaultFilter=true;
        GPC.selectedFilter='5';
        try{
        GPC.loadviewbyFilter();
        GPC.getFilter();
        }catch(Exception e){} 
    }
}