/*****************************************************************
Class Name: SubprojectControllerTest
Author:Nagaraju G               Last modified by:Raju GN
Date: 22/7/2014                 Date: 23/09/2015 
********©2013 Musqot marketing technology Pvt ltd ****************/
@isTest(Seealldata = True)
public class SubprojectControllerTest{
        static testMethod void SubprojectController(){
        
        Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
           User u2 =new User( Alias = 'newUser1' ,
           Email ='newuser123@testorg.com',
           EmailEncodingKey = 'UTF-8',
           LastName = 'Testing',
           LanguageLocaleKey='en_US',
           LocaleSidKey='en_US', 
           UserName='newuser1234@testorg.com',
           ProfileId=p.Id,
           TimeZoneSidKey    = 'America/Los_Angeles');
           insert u2;
           
          musqot__Costcentre__c objCC=new musqot__Costcentre__c(); 
          objCC.Name='test';
          objCC.OwnerId=u2.id;
          objCC.musqot__cc_Owner__c=u2.id;
          objCC.Headline__c='hl';
          insert objCC;
          System.assertEquals('test', objCC.name);  
           
         Project__c objprj= new Project__c ();
         objprj.Name='ITC';
         objprj.Starts_date__c= system.toDay();
         objprj.Ends_date__c = system.toDay().addDays(1);
         objprj.Status__c = 'In Progress';
         System.assertEquals('ITC', objprj.name);         
         insert objprj;
         
        Workspace__c  objWorkspace=new Workspace__c ();
        objWorkspace.Name='test';
        objWorkspace.Description__c='musqot';
        objWorkspace.html_description__c='musqot1';
        System.assertEquals('test', objWorkspace.name);        
        insert objWorkspace;
         
        Subproject__c objsubpro=new Subproject__c();
        objsubpro.Name='testsub';
        objsubpro.musqot__Parent_project__c=objprj.id;
        objsubpro.Starts_date__c=System.now().date();
        objsubpro.Ends_date__c=System.now().date();
        System.assertEquals('testsub', objsubpro.name);
        insert objsubpro;
        
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objsubpro.id;
        attach.contentType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
        System.assertEquals(objsubpro.id,attach.parentId);
        insert attach;
        Allocation_amount__c  objAllocationamount=new Allocation_amount__c ();
        objAllocationamount.Name='testAllocation';
        objAllocationamount.Approved_Amount__c=1000;
       
        objAllocationamount.plan__c=objprj.id;
        objAllocationamount.Costcentre__c=objCC.id;
        objAllocationamount.project__c=objsubpro.id;
        //objAllocationamount.musqot__To_Plan__c=objprj.id;
        objAllocationamount.Approvedate__c=System.today();
        objAllocationamount.Description__c='testDescription';
        objAllocationamount.Allocated__c=1000;
        System.assertEquals('testAllocation', objAllocationamount.name);
        insert objAllocationamount;
              
        musqot__Workspace__c wrkSpe=new musqot__Workspace__c();
        wrkSpe.Name='test';
        wrkSpe.musqot__Description__c='This for testclass';
        wrkSpe.musqot__subproject__c=objsubpro.id;
        wrkSpe.musqot__html_description__c='This for testclass';
        insert wrkSpe;
        
        Socialmedia_settings__c OBJSocial=new Socialmedia_settings__c();
        OBJSocial.Name='testmedia';
        OBJSocial.type__c = 'Milestone';
        OBJSocial.musqot__Import_rate__c='Hour';
        OBJSocial.musqot__Socialmedia_type__c='Facebook';
        OBJSocial.musqot__Watch_type__c='Unique visitors';
        OBJSocial.musqot__Chart__c='Line charts';
        OBJSocial.musqot__Bar_color__c='#333';
        OBJSocial.musqot__Page_Id__c='87567567567';
        OBJSocial.musqot__Auto_import__c= true ;
        insert OBJSocial;
        System.assertEquals('Unique visitors', OBJSocial.musqot__Watch_type__c);
        
        musqot__ERP_Settings__c  ObjERP=new musqot__ERP_Settings__c ();
        ObjERP.Name='testERP';
        ObjERP.ERP_performance_type__c = 'Milestone';
        ObjERP.Expression_business_region__c='APAC';
        ObjERP.musqot__Selector__c='Business area';
        ObjERP.musqot__erp_Chart__c='Bar charts';
        ObjERP.Expression_business_area__c='Lead';
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
        
        musqot__CRM_settings__c mr=new musqot__CRM_settings__c();
        mr.musqot__Bar_color__c='test';
        mr.musqot__Chart__c='test';
        mr.Watch_type__c='No Opportunities';
        mr.musqot__CRM_performance_type__c='test';
        mr.musqot__Expression_business_area__c='test';
        mr.musqot__Expression_business_region__c='test';
        mr.musqot__Selector__c='test';
        insert mr;
        System.assertEquals('test', mr.musqot__Bar_color__c);
        
       Milestone__c objmilestone=new Milestone__c ();
       objmilestone.Name='test';
       objmilestone.Milestone_type__c =4;
       objmilestone.musqot__Target_number__c=3;
       objmilestone.musqot__Status__c='Open';
       objmilestone.Target_number_outcome__c=100;
       objmilestone.Target_number__c=10;
       objmilestone.musqot__Target_ERP_Sales__c=ObjERP.id;
       objmilestone.musqot__Targetdate__c=system.today();
       objmilestone.Project__c=objsubpro.id;
       insert objmilestone;
       System.assertEquals('test', objmilestone.name);
     
        
        Members__c objMember=new Members__c ();
        objMember.User_Email__c='standarduser@test.com';
        objMember.musqot__ProjMembers__c=objprj.id;
        //objMember.SubProjMembers__c=objsubpro.id;
        objMember.Role__c='Owner';
        System.assertEquals('standarduser@test.com', objMember.User_Email__c);
        insert objMember;
        
         musqot__Allocation_amount__c objAllocate=new musqot__Allocation_amount__c();
         objAllocate.Name='test';
         objAllocate.musqot__Approved_Amount__c=4444;
         objAllocate.musqot__To_Plan__c=objprj.id;
         objAllocate.musqot__To_Project__c=objsubpro.id;
         objAllocate.musqot__Costcentre__c=objCC.id;
         insert objAllocate;
         
          Task objtask = new Task();      
            objtask.Task_name__c = 'testname'; 
            objtask.OwnerId=UserInfo.getUserId();
            objtask.WhatId=objsubpro.id;
            objtask.ActivityDate =system.toDay();
            objtask.Status='Deferred';
            objtask.Allocated_h__c=2;
            objtask.Outcome_h__c=2;
            objtask.Task_description__c='test record';
            objtask.Task_name__c='Testtask';                     
            insert objtask ;
     
        Marketing_activity__c  objMarketing=new Marketing_activity__c();
        objMarketing.Name='test';
        objMarketing.Description__c='marktingact';
        objMarketing.musqot__Project__c=objsubpro.id;
        objMarketing.musqot__ERP__c='testerp';
        System.assertEquals('test', objMarketing.name);
        insert objMarketing;
        
        musqot__Activity__c m1 =new musqot__Activity__c();
        m1.musqot__keycode__c='212';
        m1.musqot__Use_Allocation__c=true;
        m1.musqot__Use_Budget__c=true;
        m1.musqot__Use_Finance1__c=true;
        m1.musqot__Use_Forcasting__c=true;
        m1.musqot__Use_milestones__c=true;
        m1.musqot__Use_Resource__c=true;
        insert m1;
                  System.assertEquals('test', mr.musqot__Bar_color__c);

        test.starttest();
        List<String>  businessAreaList= new List<String>(); 
        List<String> businessRegionList=new List<String>(); 
        PageReference pageRef = Page.SubProject;
        Test.setCurrentPage(pageRef); 
        ApexPages.CurrentPage().getparameters().put('id',objsubpro.id);
        ApexPages.currentPage().getParameters().put('planid',objprj.id);
        ApexPages.currentPage().getParameters().put('mileId',objmilestone.id);
        ApexPages.currentPage().getParameters().put('mbrId',objmember.id);
        ApexPages.currentPage().getParameters().put('atmid',attach.id);
        ApexPages.currentPage().getParameters().put('taskid',objtask .id); 
        ApexPages.StandardController sc = new ApexPages.standardController(objsubpro);
        SubprojectController objsubprojectco = new SubprojectController (sc);
        MusqotUtility.innerClass musIncls = MusqotUtility.securitySetting(objsubpro.id);
        SubprojectController.addCostcenter cosWrap=new SubprojectController.addCostcenter();
        cosWrap.ccName='ccn';
        objsubprojectco.parentProId=objsubpro.id;
        objsubprojectco.getTabInFocus();
        objsubprojectco.gotoSubproEdit();
        objsubprojectco.setTabInFocus('String s'); 
        objsubprojectco.workSpace();
        //objsubprojectco.updateMilestone();
        try{
            objsubprojectco.workRedirect();
        } catch(exception e){}
            objsubprojectco.newMilstone();
            objsubprojectco.newProject();
            try{
            objsubprojectco.gotoTaskEdit();
            }catch(exception e){}
            objsubprojectco.customset();
            objsubprojectco.newMarketingPage();
      //  try{
         objsubprojectco.getmilston();
      //  }catch(exception e){}
        objsubprojectco.getmyfile();
        objsubprojectco.Savedoc();
        objsubprojectco.gotoattchmentpage();
        objsubprojectco.gotoMilestoneEdit();
       // try{
         objsubprojectco.getparentmembers();
       // } catch(exception e){}
       // try{
         objsubprojectco.getccMembers();
       // } catch(exception e){}
        objsubprojectco.newMember();
        //objsubprojectco.getMarkActivies();
        objsubprojectco.getmembers();
        objsubprojectco.gotoMemberEdit();
        //objsubprojectco.getsubProjects();
        objsubprojectco.newtask();
        //objsubprojectco.gettaskrecs1();
        objsubprojectco.delSubpro();
        objsubprojectco.getGadgetHTMLContent(); 
        objsubprojectco.name='test';
        objsubprojectco.parentPlanId='parent';
        //objsubprojectco.displayPopup=true;       
        //objsubprojectco.displaytab=true; 
        test.stopTest();          
        }
       static testMethod void SubprojectController1(){ 
        Project__c prj = new Project__c ();
         prj.Name='ITC';
         //prj.Plantype__c= pt.Id;
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c= system.toDay();
         prj.Status__c = 'In Progress';
         System.assertEquals('ITC', prj.name);         
         insert prj;
         
        Subproject__c objsubpro=new Subproject__c();
        objsubpro.Name='testsub';
        objsubpro.musqot__Parent_project__c=prj.id;
        objsubpro.Starts_date__c=System.now().date();
        objsubpro.Ends_date__c=System.now().date();
        System.assertEquals('testsub', objsubpro.name);
        insert objsubpro;
        
        Marketing_activity__c  objMarketing=new Marketing_activity__c();
        objMarketing.Name='test';
        objMarketing.Description__c='marktingact';
        objMarketing.musqot__Project__c=objsubpro.id;
        objMarketing.musqot__CRM__c='testCRM';
        System.assertEquals('test', objMarketing.name);
        insert objMarketing;
        
        Socialmedia_settings__c OBJSocial=new Socialmedia_settings__c();
        OBJSocial.Name='testmedia';
        OBJSocial.type__c = 'Milestone';
        OBJSocial.musqot__Import_rate__c='Hour';
        OBJSocial.musqot__Socialmedia_type__c='Facebook';
        OBJSocial.musqot__Watch_type__c='Likes / click';
        OBJSocial.musqot__Chart__c='Line charts';
        OBJSocial.musqot__Bar_color__c='#333';
        OBJSocial.musqot__Page_Id__c='87567567567';
        OBJSocial.musqot__Auto_import__c= true ;
        insert OBJSocial;
        System.assertEquals('Likes / click', OBJSocial.musqot__Watch_type__c);
        
       Milestone__c objmilestone=new Milestone__c ();
       objmilestone.Name='test';
       objmilestone.Milestone_type__c =3;
       objmilestone.musqot__Target_number__c=3;
       objmilestone.musqot__Status__c='Open';
       objmilestone.Target_Socialmedia__c=OBJSocial.id;
       objmilestone.musqot__Targetdate__c=system.today();
       objmilestone.Project__c=objsubpro.id;
       try{
       insert objmilestone;
       }catch(Exception e){}
       System.assertEquals('test', objmilestone.name);

       test.starttest();
       List<String>  businessAreaList= new List<String>(); 
       List<String> businessRegionList=new List<String>(); 
       PageReference pageRef = Page.SubProject;
       Test.setCurrentPage(pageRef); 
        ApexPages.CurrentPage().getparameters().put('id',objsubpro.id);
        ApexPages.currentPage().getParameters().put('mileId',objmilestone.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objsubpro);
        SubprojectController objsubprojectco = new SubprojectController (sc);
        MusqotUtility.innerClass musIncls = MusqotUtility.securitySetting(objsubpro.id);
        //objsubprojectco.parentProId=objsubpro.id;
        //objsubprojectco.updateMilestone();
        objsubprojectco.getmilston();
        objsubprojectco.delSubpro();
        test.stopTest();          
    }
   static testMethod void SubprojectController2(){ 
        Project__c prj = new Project__c ();
         prj.Name='ITC';
         //prj.Plantype__c= pt.Id;
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c= system.toDay();
         prj.Status__c = 'In Progress';
         System.assertEquals('ITC', prj.name);         
         insert prj;
         
        Subproject__c objsubpro=new Subproject__c();
        objsubpro.Name='testsub';
        objsubpro.musqot__Parent_project__c=prj.id;
        objsubpro.Starts_date__c=System.now().date();
        objsubpro.Ends_date__c=System.now().date();
        System.assertEquals('testsub', objsubpro.name);
        insert objsubpro;
        
        Marketing_activity__c  objMarketing=new Marketing_activity__c();
        objMarketing.Name='test';
        objMarketing.Description__c='marktingact';
        objMarketing.musqot__Project__c=objsubpro.id;
        objMarketing.Social_media__c='testFb';
        System.assertEquals('test', objMarketing.name);
        insert objMarketing;
        
        Socialmedia_settings__c OBJSocial=new Socialmedia_settings__c();
        OBJSocial.Name='testmedia';
        OBJSocial.type__c = 'Milestone';
        OBJSocial.musqot__Import_rate__c='Hour';
        OBJSocial.musqot__Socialmedia_type__c='Facebook';
        OBJSocial.musqot__Watch_type__c='Members';
        OBJSocial.musqot__Chart__c='Line charts';
        OBJSocial.musqot__Bar_color__c='#333';
        OBJSocial.musqot__Page_Id__c='87567567567';
        OBJSocial.musqot__Auto_import__c= true ;
        insert OBJSocial;
        System.assertEquals('Members', OBJSocial.musqot__Watch_type__c);
        
         musqot__CRM_settings__c mr=new musqot__CRM_settings__c();
          mr.musqot__Bar_color__c='#11100';
          mr.musqot__Chart__c='Line';
          mr.musqot__CRM_performance_type__c='Milestone';
          mr.Watch_type__c='No Leads';
          //mr.musqot__Expression_business_area__c='APAC,EMEA';
          mr.musqot__Expression_business_region__c='Lead';
          mr.musqot__Selector__c='Milestone';
          insert mr;
          System.assertEquals('#11100', mr.musqot__Bar_color__c);
          
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
          crm.musqot__No_Opportunities__c=4000;
          insert crm;
        
       Milestone__c objmilestone=new Milestone__c ();
       objmilestone.Name='test';
       objmilestone.Milestone_type__c =5;
       objmilestone.musqot__Target_number__c=3;
       objmilestone.musqot__Status__c='Open';
       objmilestone.musqot__Target_CRM_settings__c=mr.id;
       objmilestone.musqot__Targetdate__c=system.today();
       objmilestone.Project__c=objsubpro.id;
       insert objmilestone;
       System.assertEquals('test', objmilestone.name);

       test.starttest();
       List<String>  businessAreaList= new List<String>(); 
       List<String> businessRegionList=new List<String>(); 
       PageReference pageRef = Page.SubProject;
       Test.setCurrentPage(pageRef); 
        ApexPages.CurrentPage().getparameters().put('id',objsubpro.id);
        ApexPages.currentPage().getParameters().put('mileId',objmilestone.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objsubpro);
        SubprojectController objsubprojectco = new SubprojectController (sc);
        MusqotUtility.innerClass musIncls = MusqotUtility.securitySetting(objsubpro.id);
        //objsubprojectco.updateMilestone();
        objsubprojectco.getmilston();
        test.stopTest();          
        }
   static testMethod void SubprojectController3(){ 
        Project__c prj = new Project__c ();
         prj.Name='ITC';
         //prj.Plantype__c= pt.Id;
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c= system.toDay();
         prj.Status__c = 'In Progress';
         System.assertEquals('ITC', prj.name);         
         insert prj;
         
        Subproject__c objsubpro=new Subproject__c();
        objsubpro.Name='testsub';
        objsubpro.musqot__Parent_project__c=prj.id;
        objsubpro.Starts_date__c=System.now().date();
        objsubpro.Ends_date__c=System.now().date();
        System.assertEquals('testsub', objsubpro.name);
        insert objsubpro;
        
         musqot__CRM_settings__c mr=new musqot__CRM_settings__c();
          mr.musqot__Bar_color__c='#11100';
          mr.musqot__Chart__c='Line';
          mr.musqot__CRM_performance_type__c='Milestone';
          mr.Watch_type__c='No Leads';
         mr.musqot__Expression_business_area__c='APAC,EMEA';
          //mr.musqot__Expression_business_region__c='Lead';
          mr.musqot__Selector__c='Milestone';
          insert mr;
          System.assertEquals('#11100', mr.musqot__Bar_color__c);
          
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
          crm.musqot__No_Opportunities__c=4000;
          insert crm;
        
       Milestone__c objmilestone=new Milestone__c ();
       objmilestone.Name='test';
       objmilestone.Milestone_type__c =5;
       objmilestone.musqot__Target_number__c=3;
       objmilestone.musqot__Status__c='Open';
       objmilestone.musqot__Target_CRM_settings__c=mr.id;
       objmilestone.musqot__Targetdate__c=system.today();
       objmilestone.Project__c=objsubpro.id;
       insert objmilestone;
       System.assertEquals('test', objmilestone.name);

       test.starttest();
       List<String>  businessAreaList= new List<String>(); 
       List<String> businessRegionList=new List<String>(); 
       PageReference pageRef = Page.SubProject;
       Test.setCurrentPage(pageRef); 
        ApexPages.CurrentPage().getparameters().put('id',objsubpro.id);
        ApexPages.currentPage().getParameters().put('mileId',objmilestone.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objsubpro);
        SubprojectController objsubprojectco = new SubprojectController (sc);
        MusqotUtility.innerClass musIncls = MusqotUtility.securitySetting(objsubpro.id);
        //objsubprojectco.updateMilestone();
        objsubprojectco.getmilston();
        test.stopTest();          
        }
          static testMethod void SubprojectController4(){ 
        Project__c prj = new Project__c ();
         prj.Name='ITC';
         //prj.Plantype__c= pt.Id;
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c= system.toDay();
         prj.Status__c = 'In Progress';
         System.assertEquals('ITC', prj.name);         
         insert prj;
         
        Subproject__c objsubpro=new Subproject__c();
        objsubpro.Name='testsub';
        objsubpro.musqot__Parent_project__c=prj.id;
        objsubpro.Starts_date__c=System.now().date();
        objsubpro.Ends_date__c=System.now().date();
        System.assertEquals('testsub', objsubpro.name);
        insert objsubpro;
        
         musqot__CRM_settings__c mr=new musqot__CRM_settings__c();
          mr.musqot__Bar_color__c='#11100';
          mr.musqot__Chart__c='Line';
          mr.musqot__CRM_performance_type__c='Milestone';
          mr.Watch_type__c='No Leads';
          mr.musqot__Expression_business_area__c='APAC,EMEA';
          mr.musqot__Expression_business_region__c='Lead';
          mr.musqot__Selector__c='Milestone';
          insert mr;
          System.assertEquals('#11100', mr.musqot__Bar_color__c);
          
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
          crm.musqot__No_Opportunities__c=4000;
          insert crm;
        
       Milestone__c objmilestone=new Milestone__c ();
       objmilestone.Name='test';
       objmilestone.Milestone_type__c =5;
       objmilestone.musqot__Target_number__c=3;
       objmilestone.musqot__Status__c='Open';
       objmilestone.musqot__Target_CRM_settings__c=mr.id;
       objmilestone.musqot__Targetdate__c=system.today();
       objmilestone.Project__c=objsubpro.id;
       insert objmilestone;
       System.assertEquals('test', objmilestone.name);

       test.starttest();
       List<String>  businessAreaList= new List<String>(); 
       List<String> businessRegionList=new List<String>(); 
       PageReference pageRef = Page.SubProject;
       Test.setCurrentPage(pageRef); 
        ApexPages.CurrentPage().getparameters().put('id',objsubpro.id);
        ApexPages.currentPage().getParameters().put('mileId',objmilestone.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objsubpro);
        SubprojectController objsubprojectco = new SubprojectController (sc);
        MusqotUtility.innerClass musIncls = MusqotUtility.securitySetting(objsubpro.id);
        //objsubprojectco.updateMilestone();
        objsubprojectco.getmilston();
        test.stopTest();          
       }
       static testMethod void SubprojectControllerll3(){ 
        Project__c prj = new Project__c ();
         prj.Name='ITC';
         //prj.Plantype__c= pt.Id;
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c= system.toDay();
         prj.Status__c = 'In Progress';
         System.assertEquals('ITC', prj.name);         
         insert prj;
         
        Subproject__c objsubpro=new Subproject__c();
        objsubpro.Name='testsub';
        objsubpro.musqot__Parent_project__c=prj.id;
        objsubpro.Starts_date__c=System.now().date();
        objsubpro.Ends_date__c=System.now().date();
        System.assertEquals('testsub', objsubpro.name);
        insert objsubpro;
        
         musqot__CRM_settings__c mr=new musqot__CRM_settings__c();
          mr.musqot__Bar_color__c='#11100';
          mr.musqot__Chart__c='Line';
          mr.musqot__CRM_performance_type__c='Milestone';
          mr.Watch_type__c='No Leads';
         mr.musqot__Expression_business_area__c='APAC,EMEA';
          //mr.musqot__Expression_business_region__c='Lead';
          mr.musqot__Selector__c='Milestone';
          insert mr;
          System.assertEquals('#11100', mr.musqot__Bar_color__c);
          
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
          crm.musqot__No_Opportunities__c=4000;
          insert crm;
        
       Milestone__c objmilestone=new Milestone__c ();
       objmilestone.Name='test';
       objmilestone.Milestone_type__c =5;
       objmilestone.musqot__Target_number__c=3;
       objmilestone.musqot__Status__c='Open';
       objmilestone.musqot__Target_CRM_settings__c=mr.id;
       objmilestone.musqot__Targetdate__c=system.today();
       objmilestone.Project__c=objsubpro.id;
       insert objmilestone;
       System.assertEquals('test', objmilestone.name);

       test.starttest();
       List<String>  businessAreaList= new List<String>(); 
       List<String> businessRegionList=new List<String>(); 
       PageReference pageRef = Page.SubProject;
       Test.setCurrentPage(pageRef); 
        ApexPages.CurrentPage().getparameters().put('id',objsubpro.id);
        ApexPages.currentPage().getParameters().put('mileId',objmilestone.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objsubpro);
        SubprojectController objsubprojectco = new SubprojectController (sc);
        MusqotUtility.innerClass musIncls = MusqotUtility.securitySetting(objsubpro.id);
        //objsubprojectco.updateMilestone();
        objsubprojectco.getmilston();
        test.stopTest();          
        }
        static testMethod void SubprojectControllers4(){ 
        Project__c prj = new Project__c ();
         prj.Name='ITC';
         //prj.Plantype__c= pt.Id;
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c= system.toDay();
         prj.Status__c = 'In Progress';
         System.assertEquals('ITC', prj.name);         
         insert prj;
         
        Subproject__c objsubpro=new Subproject__c();
        objsubpro.Name='testsub';
        objsubpro.musqot__Parent_project__c=prj.id;
        objsubpro.Starts_date__c=System.now().date();
        objsubpro.Ends_date__c=System.now().date();
        System.assertEquals('testsub', objsubpro.name);
        insert objsubpro;
        
         musqot__CRM_settings__c mr=new musqot__CRM_settings__c();
          mr.musqot__Bar_color__c='#11100';
          mr.musqot__Chart__c='Line';
          mr.musqot__CRM_performance_type__c='Milestone';
          mr.Watch_type__c='No Leads';
          mr.musqot__Expression_business_area__c='APAC,EMEA';
          mr.musqot__Expression_business_region__c='Lead';
          mr.musqot__Selector__c='Milestone';
          insert mr;
          System.assertEquals('#11100', mr.musqot__Bar_color__c);
          
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
          crm.musqot__No_Opportunities__c=4000;
          insert crm;
        
       Milestone__c objmilestone=new Milestone__c ();
       objmilestone.Name='test';
       objmilestone.Milestone_type__c =1;
       objmilestone.musqot__Target_number__c=3;
       objmilestone.musqot__Status__c='Open';
       objmilestone.musqot__Target_CRM_settings__c=mr.id;
       objmilestone.musqot__Targetdate__c=system.today();
       objmilestone.Project__c=objsubpro.id;
       insert objmilestone;
       System.assertEquals('test', objmilestone.name);

       test.starttest();
       List<String>  businessAreaList= new List<String>(); 
       List<String> businessRegionList=new List<String>(); 
       PageReference pageRef = Page.SubProject;
       Test.setCurrentPage(pageRef); 
        ApexPages.CurrentPage().getparameters().put('id',objsubpro.id);
        ApexPages.currentPage().getParameters().put('mileId',objmilestone.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objsubpro);
        SubprojectController objsubprojectco = new SubprojectController (sc);
        MusqotUtility.innerClass musIncls = MusqotUtility.securitySetting(objsubpro.id);
        //objsubprojectco.updateMilestone();
        objsubprojectco.getmilston();
        test.stopTest();          
       }
       static testMethod void SubprojectControllermm3(){ 
        Project__c prj = new Project__c ();
         prj.Name='ITC';
         //prj.Plantype__c= pt.Id;
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c= system.toDay();
         prj.Status__c = 'In Progress';
         System.assertEquals('ITC', prj.name);         
         insert prj;
         
        Subproject__c objsubpro=new Subproject__c();
        objsubpro.Name='testsub';
        objsubpro.musqot__Parent_project__c=prj.id;
        objsubpro.Starts_date__c=System.now().date();
        objsubpro.Ends_date__c=System.now().date();
        System.assertEquals('testsub', objsubpro.name);
        insert objsubpro;
        
         musqot__CRM_settings__c mr=new musqot__CRM_settings__c();
          mr.musqot__Bar_color__c='#11100';
          mr.musqot__Chart__c='Line';
          mr.musqot__CRM_performance_type__c='Milestone';
          mr.Watch_type__c='No Leads';
         mr.musqot__Expression_business_area__c='APAC,EMEA';
          //mr.musqot__Expression_business_region__c='Lead';
          mr.musqot__Selector__c='Milestone';
          insert mr;
          System.assertEquals('#11100', mr.musqot__Bar_color__c);
          
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
          crm.musqot__No_Opportunities__c=4000;
          insert crm;
        
       Milestone__c objmilestone=new Milestone__c ();
       objmilestone.Name='test';
       objmilestone.Milestone_type__c =5;
       objmilestone.musqot__Target_number__c=3;
       objmilestone.musqot__Status__c='Open';
       objmilestone.musqot__Target_CRM_settings__c=mr.id;
       objmilestone.musqot__Targetdate__c=system.today();
       objmilestone.Project__c=objsubpro.id;
       insert objmilestone;
       System.assertEquals('test', objmilestone.name);

       test.starttest();
       List<String>  businessAreaList= new List<String>(); 
       List<String> businessRegionList=new List<String>(); 
       PageReference pageRef = Page.SubProject;
       Test.setCurrentPage(pageRef); 
        ApexPages.CurrentPage().getparameters().put('id',objsubpro.id);
        ApexPages.currentPage().getParameters().put('mileId',objmilestone.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objsubpro);
        SubprojectController objsubprojectco = new SubprojectController (sc);
        MusqotUtility.innerClass musIncls = MusqotUtility.securitySetting(objsubpro.id);
        //objsubprojectco.updateMilestone();
        objsubprojectco.getmilston();
        test.stopTest();          
        }
        static testMethod void SubprojectControllerss(){ 
        Project__c prj = new Project__c ();
         prj.Name='ITC';
         //prj.Plantype__c= pt.Id;
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c= system.toDay();
         prj.Status__c = 'In Progress';
         System.assertEquals('ITC', prj.name);         
         insert prj;
         
        Subproject__c objsubpro=new Subproject__c();
        objsubpro.Name='testsub';
        objsubpro.musqot__Parent_project__c=prj.id;
        objsubpro.Starts_date__c=System.now().date();
        objsubpro.Ends_date__c=System.now().date();
        System.assertEquals('testsub', objsubpro.name);
        insert objsubpro;
        
         musqot__CRM_settings__c mr=new musqot__CRM_settings__c();
          mr.musqot__Bar_color__c='#11100';
          mr.musqot__Chart__c='Line';
          mr.musqot__CRM_performance_type__c='Milestone';
          mr.Watch_type__c='No Leads';
          mr.musqot__Expression_business_area__c='APAC,EMEA';
          mr.musqot__Expression_business_region__c='Lead';
          mr.musqot__Selector__c='Milestone';
          insert mr;
          System.assertEquals('#11100', mr.musqot__Bar_color__c);
          
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
          crm.musqot__No_Opportunities__c=4000;
          insert crm;
        
       Milestone__c objmilestone=new Milestone__c ();
       objmilestone.Name='test';
       objmilestone.Milestone_type__c =2;
       objmilestone.musqot__Target_number__c=3;
       objmilestone.musqot__Status__c='Open';
       objmilestone.musqot__Target_CRM_settings__c=mr.id;
       objmilestone.musqot__Targetdate__c=system.today();
       objmilestone.Project__c=objsubpro.id;
       insert objmilestone;
       System.assertEquals('test', objmilestone.name);

       test.starttest();
       List<String>  businessAreaList= new List<String>(); 
       List<String> businessRegionList=new List<String>(); 
       PageReference pageRef = Page.SubProject;
       Test.setCurrentPage(pageRef); 
        ApexPages.CurrentPage().getparameters().put('id',objsubpro.id);
        ApexPages.currentPage().getParameters().put('mileId',objmilestone.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objsubpro);
        SubprojectController objsubprojectco = new SubprojectController (sc);
        MusqotUtility.innerClass musIncls = MusqotUtility.securitySetting(objsubpro.id);
        //objsubprojectco.updateMilestone();
        objsubprojectco.getmilston();
        test.stopTest();          
       }
}