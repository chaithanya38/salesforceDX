/********************************************************
Class Name: Performance_setting_controller_Test
Author:Nagaraju G       Last modified by:Raju GN
Date: 18/11/2014         Date:19/03/2015
********©2013 Musqot marketing technology Pvt ltd *******/
@isTest(seeAllData=true)
Public class Performance_setting_controller_Test{
    static testMethod void Performance_setting(){  
        
        OAuthService__c  objOAuth=new OAuthService__c ();
        objOAuth.Name='ffbook';
        objOAuth.musqot__Authorization_Type__c='Requestheader';
        objOAuth.musqot__Authorization_URL__c='https://www.facebook.com/dialog/oauth';
        objOAuth.musqot__Response_Type__c='token';
        objOAuth.musqot__Signature_Method__c='PLAINTEXT'; 
        insert objOAuth;
        System.assertEquals('PLAINTEXT', objOAuth.musqot__Signature_Method__c);
        
        socialmedia_settings__c socailmedia = new socialmedia_settings__c();
        socailmedia.Name = 'Facebook';
        socailmedia.Watch_type__c = 'Unique Visitors';
        socailmedia.Import_rate__c= 'Day';
        socailmedia.Socialmedia_type__c = 'facebook';
        socailmedia.musqot__Socialmedia__c=objOAuth.id;
        insert socailmedia;
        System.assertEquals('Facebook', socailmedia.Name);
               
        ERP_logfile__c objerplog = new ERP_logfile__c();
        objerplog .Name = 'test';
        objerplog .Import_message__c = 'testmsg';
        objerplog .Number_of_records__c = 10;
        System.assertEquals('test', objerplog .Name );
        insert objerplog;
        
        ERP_sales_obj__c objerpsal = new ERP_sales_obj__c();
        objerpsal.Name = 'test';
        objerpsal.Sales__c = 100;
        objerpsal.Sales_date__c = system.toDay();
        objerpsal.Sales_import_date__c  = system.toDay();
        objerpsal.ERP_logfile__c = objerplog.Id;
        objerpsal.Business_area__c = 'test';
        System.assertEquals('test', objerpsal .Name);
        insert objerpsal ;
        
        musqot__ERP_Settings__c ERPobj=new musqot__ERP_Settings__c();
        ERPobj.Name='testERP';
        ERPobj.musqot__Selector__c='Business area';
        System.assertEquals('Business area', ERPobj.musqot__Selector__c);
        insert ERPobj;
        
        musqot__CRM_logfile__c clog=new musqot__CRM_logfile__c();
        clog.musqot__Imported__c=true;
        clog.musqot__Import_message__c='test';
        clog.musqot__Number_of_records__c=7;
        insert clog;
        
        musqot__CRM_data__c crm=new musqot__CRM_data__c();
        crm.musqot__Business_area__c='test';
        crm.musqot__Business_region__c='apec';
        crm.musqot__CRM_import_date__c=system.toDay();
        crm.musqot__CRM_import_id__c='test';
        crm.musqot__CRM_logfile__c=clog.id;
        crm.musqot__Date__c=system.toDay();
        crm.musqot__No_Deals__c=6;
        crm.musqot__No_Leads__c=4;
        crm.musqot__No_Opportunities__c=5;
        crm.musqot__Value_Deals__c=500.00;
        crm.musqot__Value_w_Opportunities__c=60.50;
        crm.musqot__Value_Opportunities__c=45.50;
        insert crm;
        
        musqot__CRM_settings__c crs=new musqot__CRM_settings__c();
        crs.musqot__Bar_color__c='test';
        crs.musqot__Chart__c='test';
        crs.musqot__CRM_performance_type__c='test';
        crs.musqot__Expression_business_area__c='test';
        crs.musqot__Expression_business_region__c='test';
        crs.musqot__Selector__c='test';
        insert crs;

        ApexPages.currentPage().getParameters().put('id', objOAuth.id);          
        ApexPages.currentPage().getParameters().put('socailId', objOAuth.id);   
        ApexPages.currentPage().getParameters().put('deleteid', socailmedia.id);   
        ApexPages.currentPage().getParameters().put('erpid', ERPobj.id);
        ApexPages.currentPage().getParameters().put('fromHome','true');
        ApexPages.currentPage().getParameters().put('fromHome1','true'); 
        ApexPages.currentPage().getParameters().put('sfdc.tabName','01rb0000000E6da');
        //ApexPages.currentPage().getParameters().put('sfdc.tabName',null);
       // String tabId = System.currentPageReference().getParameters().get('tabId');
       // String mpsett= System.currentPageReference().getParameters().get('mpsett');  
        ApexPages.currentPage().getParameters().put('tab','null');
        ApexPages.currentPage().getParameters().put('tab1','true');
        ApexPages.currentPage().getParameters().put('tabmassg','true');
        ApexPages.currentPage().getParameters().put('tab2','test1');
        ApexPages.currentPage().getParameters().put('tabm','test'); 
        ApexPages.currentPage().getParameters().put('deleteconnid',objOAuth.id); 
        Performance_setting_controller objPSCtrl = new Performance_setting_controller();
        CRM_settings__c crmsett= [SELECT Id, Bar_color__c, Chart__c, CRM_performance_type__c, Expression_business_area__c, Expression_business_region__c, Selector__c,Name 
                                      FROM CRM_settings__c  where id=:crs.id];
        delete crs;                                      
        objPSCtrl.geterplogList();
        objPSCtrl.csvFileBody = Blob.valueOf('test1,test2,test3,test4,test5,test6 \n Test,testing,test,10,100,02-02-2015,05-05-2015 \n Test,testing,test,0,100,02-02-2015,05-05-2015');
        objPSCtrl.csvName = 'testcsv';
        objPSCtrl.NewSocial();
        objPSCtrl.crmid='123asads';
        objPSCtrl.selectedTab='ERP_import';
        objPSCtrl.fromHome=true;
        objPSCtrl.selecteddateformat='1';
        objPSCtrl.selectedcrmdateformat='1';
        //objPSCtrl.selectedImportType='imtype';
        //objPSCtrl.allAutoImport='allaimp';        
        objPSCtrl.selectedMedia='MailChimp';
        objPSCtrl.tab='null';
        objPSCtrl.tabInFocus1=true;
        //objPSCtrl.nonAutoImport='true';
        objPSCtrl.getERP();
       // objPSCtrl.LoadData();  
        //objPSCtrl.getSocialmediaConnection();
        //try{
        objPSCtrl.DeleteConnection();
        //}catch (Exception e){}
        //objPSCtrl.getSocialmedia();      
        objPSCtrl.editPage();
        objPSCtrl.newERP();  
        objPSCtrl.Savedoc();     
        objPSCtrl.DeleteSettings();
        objPSCtrl.gotoERPedit();
        objPSCtrl.erpid = ERPobj.id;
        objPSCtrl.deletemethod();                
        //objPSCtrl.Socialmedia();
        objPSCtrl.newCRM();
        objPSCtrl.getCRM();
        objPSCtrl.getcrmlogList();
        objPSCtrl.uploadcrmdoc();
        //objPSCtrl.prepareDate('05-05-2015');
        //objPSCtrl.preparecrmDate('05-05-2015');  
        try{
        objPSCtrl.deleteCRM();
        }catch(Exception e){}
        objPSCtrl.gotoCRMedit();
        objPSCtrl.Socialmedia();
        objPSCtrl.setSocialMediaValue();
        //List<SelectOption> selOpts=objPSCtrl.mediaTypeList;
    //    List<SelectOption> SocMedia=objPSCtrl.mediaFilterList;
        objPSCtrl.fromURL='https://musqot.eu2.visual.force.com/apex/MusqotAdminPage?sfdc.tabName=null&tab=mpsett';
        
    }
    
    static testMethod void testPerformance_setting(){       
        socialmedia_settings__c socailmedia = new socialmedia_settings__c();
        socailmedia.Name = 'Facebook';
        socailmedia.Watch_type__c = 'Unique Visitors';
        socailmedia.Import_rate__c= 'Day';
        socailmedia.Socialmedia_type__c = 'facebook';
        insert socailmedia;
        
        OAuthService__c  objOAuth=new OAuthService__c ();
        objOAuth.Name='ffbook';
        objOAuth.Social_media__c='Facebook';
        objOAuth.musqot__Authorization_Type__c='Requestheader';
        objOAuth.musqot__Authorization_URL__c='https://www.facebook.com/dialog/oauth';
        objOAuth.musqot__Response_Type__c='token';
        objOAuth.musqot__Signature_Method__c='PLAINTEXT'; 
        System.assertEquals('PLAINTEXT', objOAuth.musqot__Signature_Method__c);
        insert objOAuth;
        
        
        ERP_logfile__c objerplog = new ERP_logfile__c();
        objerplog .Name = 'test';
        objerplog .Import_message__c = 'testmsg';
        objerplog .Number_of_records__c = 10;
        System.assertEquals('test', objerplog .Name );
        insert objerplog;
        
        ERP_sales_obj__c objerpsal = new ERP_sales_obj__c();
        objerpsal.Name = 'test';
        objerpsal.Sales__c = 100;
        objerpsal.Sales_date__c = system.toDay();
        objerpsal.Sales_import_date__c  = system.toDay();
        objerpsal.ERP_logfile__c = objerplog.Id;
        objerpsal.Business_area__c = 'test';
        System.assertEquals('test', objerpsal .Name);
        //insert objerpsal ;
        musqot__CRM_logfile__c clog=new musqot__CRM_logfile__c();
        clog.musqot__Imported__c=true;
        clog.musqot__Import_message__c='test';
        clog.musqot__Number_of_records__c=7;
        insert clog;
        musqot__CRM_data__c crm=new musqot__CRM_data__c();
        crm.musqot__Business_area__c='test';
        crm.musqot__Business_region__c='apec';
        crm.musqot__CRM_import_date__c=system.toDay();
        crm.musqot__CRM_import_id__c='test';
        crm.musqot__CRM_logfile__c=clog.id;
        crm.musqot__Date__c=system.toDay();
        crm.musqot__No_Deals__c=6;
        crm.musqot__No_Leads__c=4;
        crm.musqot__No_Opportunities__c=5;
        crm.musqot__Value_Deals__c=5;
        crm.musqot__Value_w_Opportunities__c=6;
        crm.musqot__Value_Opportunities__c=4;
        insert crm;
        musqot__CRM_settings__c crs=new musqot__CRM_settings__c();
        crs.musqot__Bar_color__c='test';
        crs.musqot__Chart__c='test';
        crs.musqot__CRM_performance_type__c='test';
        crs.musqot__Expression_business_area__c='test';
        crs.musqot__Expression_business_region__c='test';
        crs.musqot__Selector__c='test';
        insert crs;

        musqot__ERP_Settings__c ERPobj=new musqot__ERP_Settings__c();
        ERPobj.Name='testERP';
        ERPobj.musqot__Selector__c='Business area';
        System.assertEquals('Business area', ERPobj.musqot__Selector__c);
        insert ERPobj;
        
        ApexPages.currentPage().getParameters().put('id', objOAuth.id);          
        ApexPages.currentPage().getParameters().put('socailId', objOAuth.id);   
        ApexPages.currentPage().getParameters().put('deleteid', socailmedia.id);   
        ApexPages.currentPage().getParameters().put('erpid', ERPobj.id);   
        ApexPages.currentPage().getParameters().put('fromHome','false');
        ApexPages.currentPage().getParameters().put('fromHome1','null'); 
        ApexPages.currentPage().getParameters().put('sfdc.tabName','01rb0000000E6da');
        ApexPages.currentPage().getParameters().put('tab1','false');
        ApexPages.currentPage().getParameters().put('tab','mpsett');
        Performance_setting_controller objPSCtrl1 = new Performance_setting_controller();
        objPSCtrl1.geterplogList();
        objPSCtrl1.csvFileBody = Blob.valueOf('test1,test2,test3,5,10,10.50 \n 15.50,100.50,test,10,100,02-02-2015,05-05-2015 \n Test,testing,test,10,100,02022015,05-05-2015');
        objPSCtrl1.csvName = 'testcsv';
        objPSCtrl1.crmid='123asads';
        objPSCtrl1.selectedTab='Socialmediasettings';
        objPSCtrl1.fromHome=false;
        objPSCtrl1.selecteddateformat='2';
        //objPSCtrl1.selectedcrmdateformat='2';
        objPSCtrl1.NewSocial();
        objPSCtrl1.getERP();       
        objPSCtrl1.editPage();
        objPSCtrl1.newERP();  
        objPSCtrl1.Savedoc();     
        objPSCtrl1.DeleteSettings();
        objPSCtrl1.gotoERPedit();
        objPSCtrl1.erpid = ERPobj.id;
        objPSCtrl1.uploadcrmdoc();
        objPSCtrl1.deletemethod();                
      
    }
    
    static testMethod void testPerformance_settingExceptions(){
     socialmedia_settings__c socailmedia = new socialmedia_settings__c();
        socailmedia.Name = 'Facebook';
        socailmedia.Watch_type__c = 'Unique Visitors';
        socailmedia.Import_rate__c= 'Day';
        socailmedia.Socialmedia_type__c = 'facebook';
        insert socailmedia;
        
        OAuthService__c  objOAuth=new OAuthService__c ();
        objOAuth.Name='ffbook';
        objOAuth.musqot__Authorization_Type__c='Requestheader';
        objOAuth.musqot__Authorization_URL__c='https://www.facebook.com/dialog/oauth';
        objOAuth.musqot__Response_Type__c='token';
        objOAuth.musqot__Signature_Method__c='PLAINTEXT'; 
        System.assertEquals('PLAINTEXT', objOAuth.musqot__Signature_Method__c);
        insert objOAuth;
        
        
        ERP_logfile__c objerplog = new ERP_logfile__c();
        objerplog .Name = 'test';
        objerplog .Import_message__c = 'testmsg';
        objerplog .Number_of_records__c = 10;
        System.assertEquals('test', objerplog .Name );
        insert objerplog;
        
        ERP_sales_obj__c objerpsal = new ERP_sales_obj__c();
        objerpsal.Name = 'test';
        objerpsal.Sales__c = 100;
        objerpsal.Sales_date__c = system.toDay();
        objerpsal.Sales_import_date__c  = system.toDay();
        objerpsal.ERP_logfile__c = objerplog.Id;
        objerpsal.Business_area__c = 'test';
        System.assertEquals('test', objerpsal .Name);
        //insert objerpsal ;
        musqot__CRM_logfile__c clog=new musqot__CRM_logfile__c();
        clog.musqot__Imported__c=true;
        clog.musqot__Import_message__c='test';
        clog.musqot__Number_of_records__c=7;
        upsert clog;
        musqot__CRM_data__c crm=new musqot__CRM_data__c();
        crm.musqot__Business_area__c='test';
        crm.musqot__Business_region__c='apec';
        crm.musqot__CRM_import_date__c=system.toDay();
        crm.musqot__CRM_import_id__c='test';
        crm.musqot__CRM_logfile__c=clog.id;
        crm.musqot__Date__c=system.toDay();
        crm.musqot__No_Deals__c=6;
        crm.musqot__No_Leads__c=4;
        crm.musqot__No_Opportunities__c=5;
        crm.musqot__Value_Deals__c=5.0;
        crm.musqot__Value_w_Opportunities__c=6.0;
        crm.musqot__Value_Opportunities__c=4.0;
        insert crm;
        musqot__CRM_settings__c crs=new musqot__CRM_settings__c();
        crs.musqot__Bar_color__c='test';
        crs.musqot__Chart__c='test';
        crs.musqot__CRM_performance_type__c='test';
        crs.musqot__Expression_business_area__c='test';
        crs.musqot__Expression_business_region__c='test';
        crs.musqot__Selector__c='test';
        insert crs;

        musqot__ERP_Settings__c ERPobj=new musqot__ERP_Settings__c();
        ERPobj.Name='testERP';
        ERPobj.musqot__Selector__c='Business area';
        System.assertEquals('Business area', ERPobj.musqot__Selector__c);
        insert ERPobj; 
        
        Cookie cookie = new Cookie('LinkedIn', 'LinkedIn', null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookie});
        
        ApexPages.currentPage().getParameters().put('id', objOAuth.id);          
        ApexPages.currentPage().getParameters().put('socailId', objOAuth.id);   
        ApexPages.currentPage().getParameters().put('deleteid', socailmedia.id);   
        ApexPages.currentPage().getParameters().put('erpid', ERPobj.id);   
        ApexPages.currentPage().getParameters().put('fromHome','false');
        ApexPages.currentPage().getParameters().put('fromHome1','null');  
        ApexPages.currentPage().getCookies().put('current_sm',cookie);
        ApexPages.currentPage().getParameters().put('sfdc.tabName','01rb0000000E6da'); 
         ApexPages.currentPage().getParameters().put('deleteconnid',objOAuth.id); 
        Performance_setting_controller objPSCtrl2 = new Performance_setting_controller();
        list<musqot__CRM_settings__c> temp1=objPSCtrl2.crms;
        //List<Socialmedia_logfile__c> temp23=objPSCtrl2.getsocialmediaLoglist();
        Attachment att=objPSCtrl2.attachment;
        objPSCtrl2.csvFileBody =Blob.valueOf('test1,test2,test3,5,10,10.50 \n 15.50,100.50,test,10,100,02-02-2015,05-05-2015 \n Test,testing,test,10,100,02022015,05-05-2015');
        objPSCtrl2.selecteddateformat='3';
        objPSCtrl2.savedoc();
        //String temp2s=objPSCtrl.SocialmediaConnection();
        try{
        //Date da=objPSCtrl.preparecrmDate('String dt');
        }catch (Exception e){}
        objPSCtrl2.selectedcrmdateformat='test';
        objPSCtrl2.editConnection();
        objPSCtrl2.NewConnection();
        objPSCtrl2.editPage();
        objPSCtrl2.crmid='123asads';
        objPSCtrl2.selectedTab='Socialmediasettings';
        objPSCtrl2.fromHome=false;
        objPSCtrl2.selecteddateformat='3';
        objPSCtrl2.deleteid = 'id';
        objPSCtrl2.contentType = 'id';
        objPSCtrl2.socialid= 'id';
        objPSCtrl2.conid= 'id';
        objPSCtrl2.hide= true;
        objPSCtrl2.hide1 = true;
        //objPSCtrl2.SocialmediaConnection();
        objPSCtrl2.selectedMedia='MailChimp';
        //objPSCtrl2.getSocialmediaConnection();
        //try{
        objPSCtrl2.DeleteConnection();
        //}catch(Exception e){}
        objPSCtrl2.uploadcrmdoc();
        objPSCtrl2.NewConnection();
        objPSCtrl2.editConnection();
        objPSCtrl2.LoadDataByFilter();      
    }
    static testMethod void testPerformance_settingedit(){
         socialmedia_settings__c socailmedia = new socialmedia_settings__c();
        socailmedia.Name = 'Facebook';
        socailmedia.Watch_type__c = 'Unique Visitors';
        socailmedia.Import_rate__c= 'Day';
        socailmedia.Socialmedia_type__c = 'facebook';
        System.assertEquals('Facebook', socailmedia.Name);
        insert socailmedia;
        
        Cookie cookie = new Cookie('Google analytics', 'Google analytics', null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookie});
        
        PageReference pageRef = Page.Socialmedia_settings;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('socialId', socailmedia.id); 
        ApexPages.currentPage().getParameters().put('sfdc.tabName','null');   
        ApexPages.currentPage().getCookies().put('current_nai',cookie);   
        ApexPages.StandardController sc = new ApexPages.standardController(socailmedia);
        Performance_setting_controller pstcont = new Performance_setting_controller();   
        pstcont.editPage();
        pstcont.tabInFocus1=false;
        pstcont.isAutoimport=true;
        pstcont.isNonAutoimport=true; 
        pstcont.LoadDataByFilter();
        pstcont.csvFileBody=null;        
        pstcont.savedoc();
        }
   static testMethod void testPerformance_settingcon(){
        OAuthService__c  objOAuth=new OAuthService__c ();
        objOAuth.Name='ffbook';
        objOAuth.musqot__Authorization_Type__c='Requestheader';
        objOAuth.musqot__Authorization_URL__c='https://www.facebook.com/dialog/oauth';
        objOAuth.musqot__Response_Type__c='token';
        objOAuth.musqot__Signature_Method__c='PLAINTEXT'; 
        System.assertEquals('PLAINTEXT', objOAuth.musqot__Signature_Method__c);
        insert objOAuth;
        Cookie cookie = new Cookie('Facebook', 'Facebook', null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookie});
        
        PageReference pageRef = Page.Social_media_connection;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('conid', objOAuth.id);  
        ApexPages.currentPage().getParameters().put('sfdc.tabName','null');     
        ApexPages.currentPage().getParameters().put('tab1','true');     
        ApexPages.currentPage().getParameters().put('tab','null');   
        ApexPages.StandardController sc = new ApexPages.standardController(objOAuth);
        ApexPages.currentPage().getCookies().put('current_ai',cookie);
        Performance_setting_controller pstcont1 = new Performance_setting_controller();   
        pstcont1.editConnection();
        pstcont1.selectedMedia='MailChimp';
        //pstcont1.getSocialmediaConnection();
        pstcont1.tabInFocus1=false;
        pstcont1.isAutoimport=false;
        pstcont1.isNonAutoimport=false; 
        pstcont1.LoadDataByFilter();
       }
  static testMethod void testPerformance_settingcrm(){
        socialmedia_settings__c socailmedia = new socialmedia_settings__c();
        socailmedia.Name = 'Facebook';
        socailmedia.Watch_type__c = 'Unique Visitors';
        socailmedia.Import_rate__c= 'Day';
        socailmedia.Socialmedia_type__c = 'facebook';
        insert socailmedia;
        System.assertEquals('Facebook', socailmedia.Name);
        
        OAuthService__c  objOAuth=new OAuthService__c ();
        objOAuth.Name='ffbook';
        objOAuth.musqot__Authorization_Type__c='Requestheader';
        objOAuth.musqot__Authorization_URL__c='https://www.facebook.com/dialog/oauth';
        objOAuth.musqot__Response_Type__c='token';
        objOAuth.Social_media__c='Facebook';
        objOAuth.musqot__Signature_Method__c='PLAINTEXT'; 
        insert objOAuth;
        System.assertEquals('PLAINTEXT', objOAuth.musqot__Signature_Method__c);
               
        ERP_logfile__c objerplog = new ERP_logfile__c();
        objerplog .Name = 'test';
        objerplog .Import_message__c = 'testmsg';
        objerplog .Number_of_records__c = 10;
        System.assertEquals('test', objerplog .Name );
        insert objerplog;
        
        ERP_sales_obj__c objerpsal = new ERP_sales_obj__c();
        objerpsal.Name = 'test';
        objerpsal.Sales__c = 100;
        objerpsal.Sales_date__c = system.toDay();
        objerpsal.Sales_import_date__c  = system.toDay();
        objerpsal.ERP_logfile__c = objerplog.Id;
        objerpsal.Business_area__c = 'test';
        System.assertEquals('test', objerpsal .Name);
        //insert objerpsal ;
        
        musqot__ERP_Settings__c ERPobj=new musqot__ERP_Settings__c();
        ERPobj.Name='testERP';
        ERPobj.musqot__Selector__c='Business area';
        System.assertEquals('Business area', ERPobj.musqot__Selector__c);
        insert ERPobj;
        
        musqot__CRM_logfile__c clog=new musqot__CRM_logfile__c();
        clog.musqot__Imported__c=true;
        clog.musqot__Import_message__c='test';
        clog.musqot__Number_of_records__c=7;
        insert clog;
        
        musqot__CRM_data__c crm=new musqot__CRM_data__c();
        crm.musqot__Business_area__c='test';
        crm.musqot__Business_region__c='apec';
        crm.musqot__CRM_import_date__c=system.toDay();
        crm.musqot__CRM_import_id__c='test';
        crm.musqot__CRM_logfile__c=clog.id;
        crm.musqot__Date__c=system.toDay();
        crm.musqot__No_Deals__c=6;
        crm.musqot__No_Leads__c=4;
        crm.musqot__No_Opportunities__c=5;
        crm.musqot__Value_Deals__c=500.00;
        crm.musqot__Value_w_Opportunities__c=60.50;
        crm.musqot__Value_Opportunities__c=45.50;
        insert crm;
        
        musqot__CRM_settings__c crs=new musqot__CRM_settings__c();
        crs.musqot__Bar_color__c='test';
        crs.musqot__Chart__c='test';
        crs.musqot__CRM_performance_type__c='test';
        crs.musqot__Expression_business_area__c='test';
        crs.musqot__Expression_business_region__c='test';
        crs.musqot__Selector__c='test';
        insert crs;
        Cookie cookie = new Cookie('MailChimp', 'MailChimp', null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[]{cookie});

        ApexPages.currentPage().getParameters().put('id', objOAuth.id);          
        ApexPages.currentPage().getParameters().put('socailId', objOAuth.id);   
        ApexPages.currentPage().getParameters().put('deleteid', socailmedia.id);  
        
        PageReference pageRef = Page.CRMsettingEditpage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('crmid', crs.id);  
        ApexPages.currentPage().getParameters().put('sfdc.tabName','null');  
        ApexPages.currentPage().getParameters().put('tab1','true');  
        ApexPages.currentPage().getCookies().put('current_sm',cookie);
        ApexPages.currentPage().getParameters().put('sfdc.tabName','');
        ApexPages.currentPage().getParameters().put('tabmassg','false');
        ApexPages.StandardController sc = new ApexPages.standardController(crs);
        Performance_setting_controller pstcont2 = new Performance_setting_controller(); 
        pstcont2.isAutoimport=true;
        pstcont2.isNonAutoimport=true;
        pstcont2.tabInFocus1=true;
        List<SelectOption>ListOth = pstcont2.mediaFilterList;
        pstcont2.isAutoimport=false;
        pstcont2.isNonAutoimport=true;
        pstcont2.selectedMedia='MailChimp';  
        pstcont2.gotoCRMedit();
        pstcont2.LoadDataByFilter();
        //pstcont2.mediaFilterList();
        //pstcont2.getSocialmediaConnection();
      }
}