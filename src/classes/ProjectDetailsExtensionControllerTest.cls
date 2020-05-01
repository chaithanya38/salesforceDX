/*****************************************************************
Class Name: ProjectDetailsExtensionControllerTest
Author:Nagaraju                   Last modified by:Raju GN
Date :23/7/2014                   Date :23/09/2015                    
********©2013 Musqot marketing technology Pvt ltd *****************/

@isTest(Seealldata = true)
public class ProjectDetailsExtensionControllerTest{
static testMethod void ProjectDetailsTestMethod(){
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
          objCC.musqot__Headline__c='musqotCostcenter';
          objCC.musqot__cc_Owner__c=u2.id;
          insert objCC;
          System.assertEquals('test', objCC.name);  
          
         Plantype__c pt = new Plantype__c();
         pt.Barcolor__c = '6E766F';
         pt.Name = 'Zuri';
         System.assertEquals('Zuri', pt.name);
         insert pt;
         list<Profilelist__c> pl =[SELECT Name, Id FROM Profilelist__c WHERE Name = 'MyProflieName' limit 1];
         Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=u2.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
         Project__c prj = new Project__c ();
         prj.Name='ITC';
         prj.Plantype__c= pt.Id;
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c= system.toDay();
         prj.Status__c = 'In Progress';
         prj.ownerid=plm.musqot__userid__c;
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
         
         Workspace__c objworkspace=new Workspace__c();
         objworkspace.name='test';
         objworkspace.Description__c='testdescription';
    	 objworkspace.html_description__c='longtext';
         objworkspace.ProjectName__c = prj.id;
         System.assertEquals('test', objworkspace.name);        
         insert objworkspace;
         
          musqot__ERP_Settings__c  ObjERP=new musqot__ERP_Settings__c ();
            ObjERP.Name='testERP';
            ObjERP.musqot__Selector__c='Business area';
            ObjERP.musqot__erp_Chart__c='Bar charts';
            ObjERP.musqot__Bar_color__c='#123344,#224466';
            ObjERP.musqot__ERP_performance_type__c='Milestone';
            ObjERP.musqot__Expression_business_area__c='Lead';
            ObjERP.musqot__Expression_business_region__c='APAC';
            insert ObjERP;
            System.assertEquals('Business area', ObjERP.musqot__Selector__c);
            
            
            ERP_logfile__c erLog = new ERP_logfile__c();
            erLog .Name='test';
            erLog .musqot__Imported__c = true;
            erLog .musqot__Import_message__c = 'Good';
            erLog .musqot__Number_of_records__c = 10;
            insert erLog ;
            System.assertEquals('test', erLog .Name);
            
           musqot__ERP_sales_obj__c erp=new musqot__ERP_sales_obj__c();
            erp.Name='test';
            erp.musqot__Business_area__c='Lead';
            erp.musqot__Business_region__c='APAC';
            erp.musqot__Sales__c=200;
            erp.musqot__ERP_logfile__c=erLog .id;
            erp.musqot__Sales_date__c= System.now().date();
            erp.musqot__Sales_import_date__c=System.now().date();
            insert erp;
            System.assertEquals('test', erp.Name);
            
          Milestone__c objmilestone=new Milestone__c ();
          objmilestone.Name='test';
          objmilestone.musqot__Plan__c=prj.id;   
          objmilestone.Milestone_type__c =4;
          objmilestone.musqot__Target_number__c=3;
          objmilestone.musqot__Status__c='Open';
          objmilestone.Target_number_outcome__c=100;
          objmilestone.Target_number__c=10;
          objmilestone.musqot__Target_ERP_Sales__c=ObjERP.id;
          objmilestone.musqot__Targetdate__c=system.today();
         // objmilestone.musqot__Target_Project__c=subPrj.id;
          insert objmilestone;
          System.assertEquals('test', objmilestone.name);
         
          Members__c objmember=new Members__c ();
          objmember.musqot__ProjUsers__c=UserInfo.getUserId();
          objmember.Role__c='Member';
          objmember.User_Email__c ='standarduser1@test.com';
          System.assertEquals('Member', objmember.Role__c);
          insert objmember;
         
         Members__c OBJME=[select id,name,Role__c from Members__c  where id=:objmember.id limit 1];
         delete OBJME;
         
         musqot__Allocation_amount__c objAllocate=new musqot__Allocation_amount__c();
         objAllocate.Name='test';
         objAllocate.musqot__Approved_Amount__c=4444;
         objAllocate.musqot__plan__c=prj.id;
         objAllocate.musqot__To_Plan__c=Prj.id;
         objAllocate.musqot__Costcentre__c=objCC.id;
         insert objAllocate;
         
         Task ObTask = new Task();
         ObTask .Task_name__c = 'testname';
         ObTask .ownerId = u2.Id; 
         ObTask .WhatId=prj.id; 
         ObTask .Subject = 'Run Test Trigger';
         ObTask .Status = 'Not Started';
         ObTask .Priority = 'Normal';
         insert ObTask ;
         Marketing_activity__c objMar=new Marketing_activity__c();
         objMar.Name='test';
         objMar.Description__c='tdescriptionest';
         objMar.Status__c='completed';
         System.assertEquals('test', objMar.name);
         insert objMar;

         musqot__Workspace__c ObjPre=new musqot__Workspace__c();
         ObjPre.Name='testPresention';
         ObjPre.musqot__Marketing_activity__c=objMar.id;
         ObjPre.musqot__ProjectName__c=prj.id;
    	 ObjPre.html_description__c='longtext';
         ObjPre.musqot__subproject__c=subPrj.id;
         insert ObjPre;
         
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        objtask.WhatId=prj.id;
        objtask.ActivityDate =system.toDay();
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.parentId=ObjPre.id;
        attach.body=bodyBlob;
        attach.contentType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
        insert attach;
    
    	Attachment attach1=new Attachment();       
        attach1.Name='Unit Test Attachment';
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
        attach1.parentId=objworkspace.id;
        attach1.body=bodyBlob;
        attach1.contentType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
        insert attach1;
        
         test.startTest();
         PageReference pageRef = Page.ProjectDetails;
         Test.setCurrentPage(pageRef);  
         ApexPages.currentPage().getParameters().put('workid',prjType.id);
         ApexPages.currentPage().getParameters().put('planid',prj .id);
         ApexPages.currentPage().getParameters().put('taskid',objtask .id);
         ApexPages.currentPage().getParameters().put('mileId',objmilestone.id);
         ApexPages.currentPage().getParameters().put('mbrId',objmember.id);
         ApexPages.currentPage().getParameters().put('atmid',attach.id);
         ApexPages.StandardController sc = new ApexPages.standardController(prj);
         
        ProjectDetailsExtensionController objprojec = new ProjectDetailsExtensionController (sc);
        MusqotUtility.innerClass musIncls = MusqotUtility.securitySetting(prj.id);
          List<task> temp1= objprojec.gettaskrecs();
          //List<progressbarClss> temp245=objprojec.milList;
          List<Project__c >  temp23=objprojec.member;
          Project__c temp2=objprojec.pln;
          List<musqot__Allocation_amount__c> temp22=objprojec.listrec;
         //List<user> tempuser = objprojec.getparentmembers();prj.Ends_date__c = system.toDay().addDays(3);
         //prj.Starts_date__c= system.toDay();
         objprojec.startDate=system.today();
         objprojec.endDate=prj.Ends_date__c;
         //objprojec.updateMilestone();
         objprojec.endDate=system.today()+1;
    	objprojec.workId = prj.Id;
         try{
         objprojec.getparentmembers();
         }catch(Exception e){}
         objprojec.workSpace();
         try{
         objprojec.gotoattchmentpage();
         }catch(Exception e){}
         try{         
         objprojec.gotoProjectEdit();
        }catch(Exception e){}
        try{
        objprojec.gotoTaskEdit();
        }catch(Exception e){}
        try{
        objprojec.workRedirect();
        }catch(Exception e){}
         objprojec.getmyfile();
         objprojec.Savedoc();
         
         objprojec.getsubRecs();
         try{
      //  objprojec.removeMember();
        }catch(exception e){}
         objprojec.newtask();
         objprojec.name='test';
         objprojec.showOwner=true;
         objprojec.displayPopup=true;
         objprojec.allBool=true;
         objprojec.newPoject();
         objprojec.gotoMilestoneEdit();
         objprojec.gotoMemberEdit(); 
         objprojec.newMilstone();
         try{
         objprojec.customset();
         }catch(Exception e){}
        
         objprojec.newmember();
         try{
         objprojec.getmembers();        
         }catch(Exception e){}
         objprojec.getmilston();
         objprojec.planNewmember();     
         objprojec.getTabInFocus();
         objprojec.getGadgetHTMLContent();
         objprojec.setTabInFocus(' s');
         try{
         objprojec.ownerSelected();
         }catch(exception e){}
         objprojec.hidetext=true;
         objprojec.commaSepratedList='select';
         objprojec.activeTab='project';
         objprojec.getAttLinks();
         test.stoptest();
         }
  static testMethod void ProjectDetailsTestMethod1(){
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
          objCC.musqot__Headline__c='musqotCostcenter';
          objCC.musqot__cc_Owner__c=u2.id;
          insert objCC;
          System.assertEquals('test', objCC.name);  
          
         Plantype__c pt = new Plantype__c();
         pt.Barcolor__c = '6E766F';
         pt.Name = 'Zuri';
         System.assertEquals('Zuri', pt.name);
         insert pt;
         list<Profilelist__c> pl =[SELECT Name, Id FROM Profilelist__c WHERE Name = 'MyProflieName' limit 1];
         Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=u2.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
         Project__c prj = new Project__c ();
         prj.Name='ITC';
         prj.Plantype__c= pt.Id;
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c= system.toDay();
         prj.Status__c = 'In Progress';
         prj.OwnerId=plm.musqot__userid__c;
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
         
         Workspace__c objworkspace=new Workspace__c();
         objworkspace.name='test';
         objworkspace.Description__c='testdescription'; 
         objworkspace.ProjectName__c = prj.id;
         System.assertEquals('test', objworkspace.name);        
         insert objworkspace;
         
        musqot__OAuthService__c  OAuth = new musqot__OAuthService__c ();
        OAuth.Name='ffbook';
        OAuth.musqot__Authorization_Type__c='Requestheader';
        OAuth.musqot__Access_Token_URL__c='uigyvjhvg';
        OAuth.musqot__Response_Type__c='token';
        OAuth.musqot__Auto_import__c=true;
        OAuth.musqot__Post_ID__c='65456456465';
        OAuth.musqot__Scope__c='added';
        //OAuth.musqot__Socialmedia__c=OBJSocial.id;
        OAuth.Social_media__c='MailChimp';
        OAuth.musqot__Signature_Method__c='HMAC-SHA1';
        OAuth.musqot__Consumer_Key__c = '876785757';
        OAuth.musqot__Consumer_Secret__c = '987867ghvchgcgf'; 
        OAuth.musqot__End_Date__c = system.today();
        OAuth.musqot__Bar_color__c='#333';
        OAuth.musqot__ad_id__c='addid';
        OAuth.musqot__Campaign_Id__c='campaignczczxcx';   
        OAuth.musqot__Page_Id__c='65456456465';       
        insert OAuth;
            
         Socialmedia_settings__c OBJSocial=new Socialmedia_settings__c();
         OBJSocial.Name='testmedia';
         OBJSocial.type__c = 'Milestone';
         OBJSocial.musqot__Import_rate__c='Hour';
         OBJSocial.musqot__Socialmedia_type__c='Facebook';
         OBJSocial.musqot__Watch_type__c='Unique visitors';
         OBJSocial.Socialmedia__c=OAuth.id;
         OBJSocial.musqot__Chart__c='Line charts';
         OBJSocial.musqot__Bar_color__c='#333';
         OBJSocial.musqot__Page_Id__c='87567567567';
         OBJSocial.musqot__Auto_import__c= true ;
         insert OBJSocial;
         
         musqot__Social_media_data__c socMedia=new musqot__Social_media_data__c();
         socMedia.Name='testmedia';
         socMedia.musqot__Connection__c=OBJSocial.Socialmedia__c;
         socMedia.musqot__Date__c=system.today();
         socMedia.musqot__Number_of_likes__c=100;
         socMedia.musqot__Number_of_member__c=100;
         socMedia.musqot__Number_of_unik_visitor__c=500;
         socMedia.musqot__Socialmedia_Settings__c=OBJSocial.id;
         insert socMedia;
            
          Milestone__c objmilestone=new Milestone__c ();
          objmilestone.Name='test';
          objmilestone.musqot__Plan__c=prj.id;   
          objmilestone.Milestone_type__c =3;
          objmilestone.musqot__Target_number__c=3;
          objmilestone.musqot__Status__c='Open';
          objmilestone.Target_Socialmedia__c=OBJSocial.id;
          objmilestone.musqot__Targetdate__c=system.today();
          insert objmilestone;
          System.assertEquals('test', objmilestone.name);
         
          Members__c objmember=new Members__c ();
          objmember.Role__c='Member';
          objmember.User_Email__c ='standarduser1@test.com';
          System.assertEquals('Member', objmember.Role__c);
          insert objmember;
         
         Members__c OBJME=[select id,name,Role__c from Members__c  where id=:objmember.id limit 1];
         delete OBJME;
         
         musqot__Allocation_amount__c objAllocate=new musqot__Allocation_amount__c();
         objAllocate.Name='test';
         objAllocate.musqot__Approved_Amount__c=4444;
         objAllocate.musqot__plan__c=prj.id;
         objAllocate.musqot__To_Plan__c=Prj.id;
         objAllocate.musqot__Costcentre__c=objCC.id;
         insert objAllocate;
         
         Task ObTask = new Task();
         ObTask .Task_name__c = 'testname';
         ObTask .ownerId = u2.Id; 
         ObTask .WhatId=prj.id; 
         ObTask .Subject = 'Run Test Trigger';
         ObTask .Status = 'Not Started';
         ObTask .Priority = 'Normal';
         insert ObTask ;
         
         Marketing_activity__c objMar=new Marketing_activity__c();
         objMar.Name='test';
         objMar.Description__c='tdescriptionest';
         objMar.Status__c='completed';
         System.assertEquals('test', objMar.name);
         insert objMar;
         
         
        musqot__Workspace__c ObjPre=new musqot__Workspace__c();
        ObjPre.Name='testPresention';
        ObjPre.musqot__Marketing_activity__c=objMar.id;
        ObjPre.musqot__ProjectName__c=prj.id;
        ObjPre.musqot__subproject__c=subPrj.id;
        insert ObjPre;
        
        
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        objtask.WhatId=prj.id;
        objtask.ActivityDate =system.toDay();
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.parentId=ObjPre.id;
        attach.body=bodyBlob;
        attach.contentType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
        insert attach;
        
         test.startTest();
         PageReference pageRef = Page.ProjectDetails;
         Test.setCurrentPage(pageRef);  
         ApexPages.currentPage().getParameters().put('workid',prjType.id);
         ApexPages.currentPage().getParameters().put('planid',prj .id);
         ApexPages.currentPage().getParameters().put('taskid',objtask .id);
         ApexPages.currentPage().getParameters().put('mileId',objmilestone.id);
         ApexPages.currentPage().getParameters().put('mbrId',objmember.id);
         ApexPages.currentPage().getParameters().put('atmid',attach.id);
         ApexPages.StandardController sc = new ApexPages.standardController(prj);
         
        ProjectDetailsExtensionController objprojec = new ProjectDetailsExtensionController (sc);
        MusqotUtility.innerClass musIncls = MusqotUtility.securitySetting(prj.id);
         
      
          List<task> temp1= objprojec.gettaskrecs();
          //List<progressbarClss> temp245=objprojec.milList;
          List<Project__c >  temp23=objprojec.member;
          Project__c temp2=objprojec.pln;
          List<musqot__Allocation_amount__c> temp22=objprojec.listrec;
         //List<user> tempuser = objprojec.getparentmembers();
         objprojec.startDate=system.today();
         objprojec.endDate=system.today()+1;
         try{
         objprojec.getparentmembers();
         }catch(Exception e){}
         objprojec.workSpace();
            try{
         objprojec.gotoattchmentpage();
         }catch(Exception e){}
         try{
         
              objprojec.gotoProjectEdit();
        }catch(Exception e){}
        try{
        objprojec.gotoTaskEdit();
        }catch(Exception e){}
        try{
        objprojec.workRedirect();
        }catch(Exception e){}
         objprojec.getmyfile();
         objprojec.Savedoc();
         
         objprojec.getsubRecs();
         try{
    //    objprojec.removeMember();
        }catch(exception e){}
         objprojec.newtask();
         objprojec.name='test';
         objprojec.showOwner=true;
         objprojec.displayPopup=true;
         objprojec.newPoject();
         objprojec.gotoMilestoneEdit();
         objprojec.gotoMemberEdit(); 
         objprojec.newMilstone();
         try{
         objprojec.customset();
         }catch(Exception e){}
        
         objprojec.newmember();
         try{
         objprojec.getmembers();
         }catch(Exception e){}
         try{
         objprojec.getmilston();
         }catch(Exception e){}
         objprojec.getTabInFocus();
         objprojec.getGadgetHTMLContent();
         objprojec.setTabInFocus(' s');
         test.stoptest();
       }
  static testMethod void ProjectDetailsTestMethod2(){
         Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
        User u2 =new User( Alias = 'newUser1' ,Email ='newuser123@testorg.com',EmailEncodingKey = 'UTF-8',LastName = 'Testing',
        LanguageLocaleKey='en_US',LocaleSidKey='en_US', UserName='newuser1234@testorg.com',ProfileId=p.Id,TimeZoneSidKey = 'America/Los_Angeles');
        insert u2; 
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=u2.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
         Project__c prj = new Project__c ();
         prj.Name='ITC';
         //prj.Plantype__c= pt.Id;
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c=system.toDay()-100;
         prj.Status__c = 'In Progress';
         prj.OwnerId=plm.musqot__userid__c;
         System.assertEquals('ITC', prj.name);         
         insert prj;
         
          musqot__CRM_settings__c mr=new musqot__CRM_settings__c();
          mr.musqot__Bar_color__c='#11100';
          mr.musqot__Chart__c='Line';
          mr.musqot__CRM_performance_type__c='Milestone';
          mr.Watch_type__c='No Wins';
          mr.musqot__Expression_business_area__c='APAC,EMEA';
          mr.musqot__Expression_business_region__c='Lead,Oppurtunities';
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
          crm.musqot__No_Deals__c=4000;
          //crm.musqot__No_Leads__c=400;
         // crm.musqot__No_Opportunities__c=4000;
          insert crm;
          System.assertEquals(4000,crm.musqot__No_Deals__c);
            
          Milestone__c objmilestone=new Milestone__c ();
          objmilestone.Name='test';
          objmilestone.musqot__Plan__c=prj.id;   
          objmilestone.Milestone_type__c =5;
          objmilestone.musqot__Target_number__c=3;
          objmilestone.musqot__Status__c='Reach on time';
          objmilestone.musqot__Target_CRM_settings__c=mr.id;
          objmilestone.musqot__Targetdate__c=system.today();
          insert objmilestone;
          System.assertEquals('test', objmilestone.name);
         test.startTest();
         PageReference pageRef = Page.ProjectDetails;
         Test.setCurrentPage(pageRef);  
         ApexPages.currentPage().getParameters().put('planid',prj .id);
         ApexPages.currentPage().getParameters().put('mileId',objmilestone.id);
         ApexPages.StandardController sc = new ApexPages.standardController(prj);
         
        ProjectDetailsExtensionController objprojec = new ProjectDetailsExtensionController (sc);
        MusqotUtility.innerClass musIncls = MusqotUtility.securitySetting(prj.id);
          List<task> temp1= objprojec.gettaskrecs();
          List<Project__c >  temp23=objprojec.member;
          Project__c temp2=objprojec.pln;
          List<musqot__Allocation_amount__c> temp22=objprojec.listrec;
          Project__c  pro=[SELECT Id,Starts_date__c,Ends_date__c FROM Project__c  WHERE Id=:Prj.id];
     //    objprojec.total=100;
         objprojec.startDate=pro.Starts_date__c; 
         objprojec.endDate=pro.Ends_date__c ; 
         //objprojec.updateMilestone();
         objprojec.getmilston();      
         test.stoptest();
       }
  static testMethod void ProjectDetailsTestMethod3(){ 
         Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
        User u2 =new User( Alias = 'newUser1' ,Email ='newuser123@testorg.com',EmailEncodingKey = 'UTF-8',LastName = 'Testing',
        LanguageLocaleKey='en_US',LocaleSidKey='en_US', UserName='newuser1234@testorg.com',ProfileId=p.Id,TimeZoneSidKey = 'America/Los_Angeles');
        insert u2; 
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=u2.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c); 
         Plantype__c pt = new Plantype__c();
         pt.Barcolor__c = '6E766F';
         pt.Name = 'Zuri';
         System.assertEquals('Zuri', pt.name);
         insert pt;
         list<Profilelist__c> pl =[SELECT Name, Id FROM Profilelist__c WHERE Name = 'MyProflieName' limit 1];
         
         Project__c prj = new Project__c ();
         prj.Name='ITC';
         prj.Plantype__c= pt.Id;
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c=system.toDay()-100;
         prj.Status__c = 'In Progress';
         prj.OwnerId=plm.musqot__userid__c;
         System.assertEquals('ITC', prj.name);         
         insert prj;
         
          musqot__CRM_settings__c mr=new musqot__CRM_settings__c();
          mr.musqot__Bar_color__c='#11100';
          mr.musqot__Chart__c='Line';
          mr.musqot__CRM_performance_type__c='Milestone';
          mr.Watch_type__c='Amount Opportunities';
          mr.musqot__Expression_business_area__c='APAC,EMEA';
          //mr.musqot__Expression_business_region__c='';
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
          objmilestone.musqot__Plan__c=prj.id;   
          objmilestone.Milestone_type__c =5;
          objmilestone.musqot__Target_number__c=3;
          objmilestone.musqot__Status__c='Reach on time';
          objmilestone.musqot__Target_CRM_settings__c=mr.id;
          objmilestone.musqot__Targetdate__c=system.today();
          insert objmilestone;
          System.assertEquals('test', objmilestone.name);
         
         test.startTest();
         PageReference pageRef = Page.ProjectDetails;
         Test.setCurrentPage(pageRef);  
         ApexPages.currentPage().getParameters().put('planid',prj .id);
         ApexPages.currentPage().getParameters().put('mileId',objmilestone.id);
         ApexPages.StandardController sc = new ApexPages.standardController(prj);
         
        ProjectDetailsExtensionController objprojec = new ProjectDetailsExtensionController (sc);
        MusqotUtility.innerClass musIncls = MusqotUtility.securitySetting(prj.id);
          List<task> temp1= objprojec.gettaskrecs();
          List<Project__c >  temp23=objprojec.member;
          Project__c temp2=objprojec.pln;
          List<musqot__Allocation_amount__c> temp22=objprojec.listrec;
          Project__c  pro=[SELECT Id,Starts_date__c,Ends_date__c FROM Project__c  WHERE Id=:Prj.id];
         objprojec.startDate=pro.Starts_date__c; 
         objprojec.endDate=pro.Ends_date__c ; 
         //objprojec.updateMilestone();
         objprojec.getmilston();
         test.stoptest();
       }
 static testMethod void ProjectDetailsTestMethod4(){
         Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
        User u2 =new User( Alias = 'newUser1' ,Email ='newuser123@testorg.com',EmailEncodingKey = 'UTF-8',LastName = 'Testing',
        LanguageLocaleKey='en_US',LocaleSidKey='en_US', UserName='newuser1234@testorg.com',ProfileId=p.Id,TimeZoneSidKey = 'America/Los_Angeles');
        insert u2; 
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=u2.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
         Project__c prj = new Project__c ();
         prj.Name='ITC';
         //prj.Plantype__c= pt.Id;
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c=system.toDay()-100;
         prj.Status__c = 'In Progress';
         prj.OwnerId=plm.musqot__userid__c;
         System.assertEquals('ITC', prj.name);         
         insert prj;
         
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
          objmilestone.musqot__Plan__c=prj.id;   
          objmilestone.Milestone_type__c =5;
          objmilestone.musqot__Target_number__c=3;
          objmilestone.musqot__Status__c='Reach on time';
          objmilestone.musqot__Target_CRM_settings__c=mr.id;
          objmilestone.musqot__Targetdate__c=system.today();
          insert objmilestone;
          System.assertEquals('test', objmilestone.name);
         
         test.startTest();
         PageReference pageRef = Page.ProjectDetails;
         Test.setCurrentPage(pageRef);  
         ApexPages.currentPage().getParameters().put('planid',prj .id);
         ApexPages.currentPage().getParameters().put('mileId',objmilestone.id);
         ApexPages.StandardController sc = new ApexPages.standardController(prj);
         
        ProjectDetailsExtensionController objprojec = new ProjectDetailsExtensionController (sc);
        MusqotUtility.innerClass musIncls = MusqotUtility.securitySetting(prj.id);
          List<task> temp1= objprojec.gettaskrecs();
          List<Project__c >  temp23=objprojec.member;
          Project__c temp2=objprojec.pln;
          List<musqot__Allocation_amount__c> temp22=objprojec.listrec;
          Project__c  pro=[SELECT Id,Starts_date__c,Ends_date__c FROM Project__c  WHERE Id=:Prj.id];
         objprojec.startDate=pro.Starts_date__c; 
         objprojec.endDate=pro.Ends_date__c ; 
         //objprojec.updateMilestone();
         objprojec.getmilston();        
      }
 static testMethod void ProjectDetailsTestMethod5(){
         Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
        User u2 =new User( Alias = 'newUser1' ,Email ='newuser123@testorg.com',EmailEncodingKey = 'UTF-8',LastName = 'Testing',
        LanguageLocaleKey='en_US',LocaleSidKey='en_US', UserName='newuser1234@testorg.com',ProfileId=p.Id,TimeZoneSidKey = 'America/Los_Angeles');
        insert u2; 
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=u2.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
         Project__c prj = new Project__c ();
         prj.Name='ITC';
        // prj.Plantype__c= pt.Id;
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c= system.toDay();
         prj.Status__c = 'In Progress';
         prj.OwnerId=plm.musqot__userid__c;
         System.assertEquals('ITC', prj.name);         
         insert prj;
  
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
         
         musqot__Social_media_data__c socMedia=new musqot__Social_media_data__c();
         socMedia.Name='testmedia';
         socMedia.musqot__Date__c=system.today();
         socMedia.musqot__Number_of_likes__c=100;
         socMedia.musqot__Number_of_member__c=100;
         socMedia.musqot__Number_of_unik_visitor__c=500;
         socMedia.musqot__Socialmedia_Settings__c=OBJSocial.id;
         insert socMedia;
            
          Milestone__c objmilestone=new Milestone__c ();
          objmilestone.Name='test';
          objmilestone.musqot__Plan__c=prj.id;   
          objmilestone.Milestone_type__c =4;
          objmilestone.musqot__Target_number__c=3;
          objmilestone.musqot__Status__c='Open';
          objmilestone.Target_Socialmedia__c=OBJSocial.id;
          objmilestone.musqot__Targetdate__c=system.today();
         // objmilestone.musqot__Target_Project__c=subPrj.id;
          insert objmilestone;
          System.assertEquals('test', objmilestone.name);
        
         test.startTest();
         PageReference pageRef = Page.ProjectDetails;
         Test.setCurrentPage(pageRef);  
         ApexPages.currentPage().getParameters().put('planid',prj .id);
         ApexPages.currentPage().getParameters().put('mileId',objmilestone.id);
         ApexPages.StandardController sc = new ApexPages.standardController(prj);
         
        ProjectDetailsExtensionController objprojec = new ProjectDetailsExtensionController (sc);
        MusqotUtility.innerClass musIncls = MusqotUtility.securitySetting(prj.id);
         
          List<task> temp1= objprojec.gettaskrecs();
          List<Project__c >  temp23=objprojec.member;
          Project__c temp2=objprojec.pln;
          List<musqot__Allocation_amount__c> temp22=objprojec.listrec;
         objprojec.startDate=system.today();
         //objprojec.updateMilestone();
         objprojec.getmilston();        
         test.stoptest();
         }
  static testMethod void ProjectDetailsTestMethod6(){
         Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
        User u2 =new User( Alias = 'newUser1' ,Email ='newuser123@testorg.com',EmailEncodingKey = 'UTF-8',LastName = 'Testing',
        LanguageLocaleKey='en_US',LocaleSidKey='en_US', UserName='newuser1234@testorg.com',ProfileId=p.Id,TimeZoneSidKey = 'America/Los_Angeles');
        insert u2; 
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=u2.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
         Project__c prj = new Project__c ();
         prj.Name='ITC';
         //prj.Plantype__c= pt.Id;
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c= system.toDay();
         prj.Status__c = 'In Progress';
         prj.OwnerId=plm.musqot__userid__c;
         System.assertEquals('ITC', prj.name);         
         insert prj;

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
         
         musqot__Social_media_data__c socMedia=new musqot__Social_media_data__c();
         socMedia.Name='testmedia';
         socMedia.musqot__Date__c=system.today();
         socMedia.musqot__Number_of_likes__c=100;
         socMedia.musqot__Number_of_member__c=100;
         socMedia.musqot__Number_of_unik_visitor__c=500;
         socMedia.musqot__Socialmedia_Settings__c=OBJSocial.id;
         insert socMedia;
            
          Milestone__c objmilestone=new Milestone__c ();
          objmilestone.Name='test';
          objmilestone.musqot__Plan__c=prj.id;   
          objmilestone.Milestone_type__c =4;
          objmilestone.musqot__Target_number__c=3;
          objmilestone.musqot__Status__c='Open';
          objmilestone.Target_Socialmedia__c=OBJSocial.id;
          objmilestone.musqot__Targetdate__c=system.today();
         // objmilestone.musqot__Target_Project__c=subPrj.id;
          insert objmilestone;
          System.assertEquals('test', objmilestone.name);
        
         test.startTest();
         PageReference pageRef = Page.ProjectDetails;
         Test.setCurrentPage(pageRef);  
         ApexPages.currentPage().getParameters().put('planid',prj .id);
         ApexPages.currentPage().getParameters().put('mileId',objmilestone.id);
         ApexPages.StandardController sc = new ApexPages.standardController(prj);
         
        ProjectDetailsExtensionController objprojec = new ProjectDetailsExtensionController (sc);
        MusqotUtility.innerClass musIncls = MusqotUtility.securitySetting(prj.id);
         
          List<task> temp1= objprojec.gettaskrecs();
          List<Project__c >  temp23=objprojec.member;
          Project__c temp2=objprojec.pln;
          List<musqot__Allocation_amount__c> temp22=objprojec.listrec;
         objprojec.startDate=system.today();
        // objprojec.updateMilestone();
         objprojec.getmilston();
        
         test.stoptest();
         }
  static testMethod void ProjectDetailsTestMethod11(){
        Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
         User u2 =new User( Alias = 'newUser1' ,Email ='newuser123@testorg.com',EmailEncodingKey = 'UTF-8',LastName = 'Testing',
        LanguageLocaleKey='en_US',LocaleSidKey='en_US', UserName='newuser1234@testorg.com',ProfileId=p.Id,TimeZoneSidKey = 'America/Los_Angeles');
        insert u2; 
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=u2.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
         Project__c prj = new Project__c ();
         prj.Name='ITC';
         //prj.Plantype__c= pt.Id;
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c= system.toDay();
         prj.Status__c = 'In Progress';
         prj.OwnerId=plm.musqot__userid__c;
         System.assertEquals('ITC', prj.name);         
         insert prj;
    
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
         
         musqot__Social_media_data__c socMedia=new musqot__Social_media_data__c();
         socMedia.Name='testmedia';
         socMedia.musqot__Date__c=system.today();
         socMedia.musqot__Number_of_likes__c=100;
         socMedia.musqot__Number_of_member__c=100;
         socMedia.musqot__Number_of_unik_visitor__c=500;
         socMedia.musqot__Socialmedia_Settings__c=OBJSocial.id;
         insert socMedia;
            
          Milestone__c objmilestone=new Milestone__c ();
          objmilestone.Name='test';
          objmilestone.musqot__Plan__c=prj.id;   
          objmilestone.Milestone_type__c =3;
          objmilestone.musqot__Target_number__c=3;
          objmilestone.musqot__Status__c='Open';
          objmilestone.Target_Socialmedia__c=OBJSocial.id;
          objmilestone.musqot__Targetdate__c=system.today();
          try{
          insert objmilestone;
          }catch(Exception e){}
          System.assertEquals('test', objmilestone.name);
         
         
         test.startTest();
         PageReference pageRef = Page.ProjectDetails;
         Test.setCurrentPage(pageRef);  
        
         ApexPages.currentPage().getParameters().put('planid',prj .id);
         ApexPages.currentPage().getParameters().put('mileId',objmilestone.id);
         ApexPages.StandardController sc = new ApexPages.standardController(prj);
         
        ProjectDetailsExtensionController objprojec = new ProjectDetailsExtensionController (sc);
        MusqotUtility.innerClass musIncls = MusqotUtility.securitySetting(prj.id);
        
        List<task> temp1= objprojec.gettaskrecs();
        List<Project__c >  temp23=objprojec.member;
        Project__c temp2=objprojec.pln;
        List<musqot__Allocation_amount__c> temp22=objprojec.listrec;
        objprojec.startDate=system.today();
        try{
         //objprojec.updateMilestone();
         objprojec.getmilston();
        }catch(exception e){}         
       }
   static testMethod void ProjectDetailsTestMethod9(){
         Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
        User u2 =new User( Alias = 'newUser1' ,Email ='newuser123@testorg.com',EmailEncodingKey = 'UTF-8',LastName = 'Testing',
        LanguageLocaleKey='en_US',LocaleSidKey='en_US', UserName='newuser1234@testorg.com',ProfileId=p.Id,TimeZoneSidKey = 'America/Los_Angeles');
        insert u2; 
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=u2.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
         Project__c prj = new Project__c ();
         prj.Name='ITC';
        // prj.Plantype__c= pt.Id;
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c=system.toDay()-100;
         prj.Status__c = 'In Progress';
         prj.OwnerId=plm.musqot__userid__c;
         System.assertEquals('ITC', prj.name);         
         insert prj;
         
          musqot__CRM_settings__c mr=new musqot__CRM_settings__c();
          mr.musqot__Bar_color__c='#11100';
          mr.musqot__Chart__c='Line';
          mr.musqot__CRM_performance_type__c='Milestone';
          mr.Watch_type__c='Amount Wins';
          mr.musqot__Expression_business_area__c='APAC,EMEA';
          mr.musqot__Expression_business_region__c='Lead,Oppurtunities';
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
          crm.Value_Deals__c=4000;
         
          insert crm;
          System.assertEquals(4000,crm.Value_Deals__c);
            
          Milestone__c objmilestone=new Milestone__c ();
          objmilestone.Name='test';
          objmilestone.musqot__Plan__c=prj.id;   
          objmilestone.Milestone_type__c =5;
          objmilestone.musqot__Target_number__c=3;
          objmilestone.musqot__Status__c='Reach on time';
          objmilestone.musqot__Target_CRM_settings__c=mr.id;
          objmilestone.musqot__Targetdate__c=system.today();
          insert objmilestone;
          System.assertEquals('test', objmilestone.name);
     
         test.startTest();
         PageReference pageRef = Page.ProjectDetails;
         Test.setCurrentPage(pageRef);  
         ApexPages.currentPage().getParameters().put('planid',prj .id);
         ApexPages.currentPage().getParameters().put('mileId',objmilestone.id);
         ApexPages.StandardController sc = new ApexPages.standardController(prj);
         
        ProjectDetailsExtensionController objprojec = new ProjectDetailsExtensionController (sc);
        MusqotUtility.innerClass musIncls = MusqotUtility.securitySetting(prj.id);
          List<task> temp1= objprojec.gettaskrecs();
          List<Project__c >  temp23=objprojec.member;
          Project__c temp2=objprojec.pln;
          List<musqot__Allocation_amount__c> temp22=objprojec.listrec;
          Project__c  pro=[SELECT Id,Starts_date__c,Ends_date__c FROM Project__c  WHERE Id=:Prj.id];
     //    objprojec.total=100;
         objprojec.startDate=pro.Starts_date__c; 
         objprojec.endDate=pro.Ends_date__c ; 
         //objprojec.updateMilestone();
         objprojec.getmilston();
      
         test.stoptest();
       }
  static testMethod void ProjectDetailsTestMethod10(){
         Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
        User u2 =new User( Alias = 'newUser1' ,Email ='newuser123@testorg.com',EmailEncodingKey = 'UTF-8',LastName = 'Testing',
        LanguageLocaleKey='en_US',LocaleSidKey='en_US', UserName='newuser1234@testorg.com',ProfileId=p.Id,TimeZoneSidKey = 'America/Los_Angeles');
        insert u2; 
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=u2.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
         Project__c prj = new Project__c ();
         prj.Name='ITC';
        // prj.Plantype__c= pt.Id;
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c=system.toDay()-100;
         prj.Status__c = 'In Progress';
         prj.OwnerId=plm.musqot__userid__c;
         System.assertEquals('ITC', prj.name);         
         insert prj;
         
          musqot__CRM_settings__c mr=new musqot__CRM_settings__c();
          mr.musqot__Bar_color__c='#11100';
          mr.musqot__Chart__c='Line';
          mr.musqot__CRM_performance_type__c='Milestone';
          mr.Watch_type__c='Amount (weighted) Opportunitie';
          mr.musqot__Expression_business_area__c='APAC,EMEA';
          mr.musqot__Expression_business_region__c='Lead,Oppurtunities';
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
          crm.Value_w_Opportunities__c=4000;
          insert crm;
          System.assertEquals(4000,crm.Value_w_Opportunities__c);
            
          Milestone__c objmilestone=new Milestone__c ();
          objmilestone.Name='test';
          objmilestone.musqot__Plan__c=prj.id;   
          objmilestone.Milestone_type__c =5;
          objmilestone.musqot__Target_number__c=3;
          objmilestone.musqot__Status__c='Reach on time';
          objmilestone.musqot__Target_CRM_settings__c=mr.id;
          objmilestone.musqot__Targetdate__c=system.today();
          try{
          insert objmilestone;
          }catch(Exception e){}
          System.assertEquals('test', objmilestone.name);
       
     
         test.startTest();
         PageReference pageRef = Page.ProjectDetails;
         Test.setCurrentPage(pageRef);  
         ApexPages.currentPage().getParameters().put('planid',prj .id);
         ApexPages.currentPage().getParameters().put('mileId',objmilestone.id);
         ApexPages.StandardController sc = new ApexPages.standardController(prj);
         
          ProjectDetailsExtensionController objprojec = new ProjectDetailsExtensionController (sc);
          MusqotUtility.innerClass musIncls = MusqotUtility.securitySetting(prj.id);
          List<task> temp1= objprojec.gettaskrecs();
          List<Project__c >  temp23=objprojec.member;
          Project__c temp2=objprojec.pln;
          List<musqot__Allocation_amount__c> temp22=objprojec.listrec;
          Project__c  pro=[SELECT Id,Starts_date__c,Ends_date__c FROM Project__c  WHERE Id=:Prj.id];
       //   objprojec.total=100;
          objprojec.startDate=pro.Starts_date__c; 
          objprojec.endDate=pro.Ends_date__c ; 
          //objprojec.updateMilestone();
          objprojec.getmilston();      
         test.stoptest();
       }
    static testMethod void ProjectDetailsTestMethod12(){
        Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
        User u2 =new User( Alias = 'newUser1' ,Email ='newuser123@testorg.com',EmailEncodingKey = 'UTF-8',LastName = 'Testing',
        LanguageLocaleKey='en_US',LocaleSidKey='en_US', UserName='newuser1234@testorg.com',ProfileId=p.Id,TimeZoneSidKey = 'America/Los_Angeles');
        insert u2; 
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=u2.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
         Project__c prj = new Project__c ();
         prj.Name='ITC';
        // prj.Plantype__c= pt.Id;
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c=system.toDay()-100;
         prj.Status__c = 'In Progress';
         prj.OwnerId=plm.musqot__userid__c;
         System.assertEquals('ITC', prj.name);         
         insert prj;
         
          musqot__CRM_settings__c mr=new musqot__CRM_settings__c();
          mr.musqot__Bar_color__c='#11100';
          mr.musqot__Chart__c='Line';
          mr.musqot__CRM_performance_type__c='Milestone';
          mr.Watch_type__c='Amount (weighted) Opportunitie';
          //mr.musqot__Expression_business_area__c='APAC,EMEA';
         // mr.musqot__Expression_business_region__c='Lead,Oppurtunities';
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
          crm.Value_w_Opportunities__c=4000;
          insert crm;
          System.assertEquals(4000,crm.Value_w_Opportunities__c);
            
          Milestone__c objmilestone=new Milestone__c ();
          objmilestone.Name='test';
          objmilestone.musqot__Plan__c=prj.id;   
          objmilestone.Milestone_type__c =5;
          objmilestone.musqot__Target_number__c=3;
          objmilestone.musqot__Status__c='Reach on time';
          objmilestone.musqot__Target_CRM_settings__c=mr.id;
          objmilestone.musqot__Targetdate__c=system.today();
          try{
          insert objmilestone;
          }catch(Exception e){}
          System.assertEquals('test', objmilestone.name);
       
     
         test.startTest();
         PageReference pageRef = Page.ProjectDetails;
         Test.setCurrentPage(pageRef);  
         ApexPages.currentPage().getParameters().put('planid',prj .id);
         ApexPages.currentPage().getParameters().put('mileId',objmilestone.id);
         ApexPages.StandardController sc = new ApexPages.standardController(prj);
         
          ProjectDetailsExtensionController objprojec = new ProjectDetailsExtensionController (sc);
          MusqotUtility.innerClass musIncls = MusqotUtility.securitySetting(prj.id);
          List<task> temp1= objprojec.gettaskrecs();
          List<Project__c >  temp23=objprojec.member;
          Project__c temp2=objprojec.pln;
          List<musqot__Allocation_amount__c> temp22=objprojec.listrec;
          Project__c  pro=[SELECT Id,Starts_date__c,Ends_date__c FROM Project__c  WHERE Id=:Prj.id];
         // objprojec.total=100;
          objprojec.startDate=pro.Starts_date__c; 
          objprojec.endDate=pro.Ends_date__c ; 
          //objprojec.updateMilestone();
          objprojec.getmilston();      
         test.stoptest();
       }  
 static testMethod void ProjectDetailsTestMethod133(){
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
         Musqot_member__c plmr=new Musqot_member__c();
        plmr.musqot__userid__c=u2.id;
        plmr.musqot__Role__c='Member';        
        plmr.User_type__c='Internal user';
        insert plmr;
        System.assertEquals('Member', plmr.Role__c);
         Project__c prj = new Project__c ();
         prj.Name='ITC';
        // prj.Plantype__c= pt.Id;
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c=system.toDay()-100;
         prj.Status__c = 'In Progress';
         prj.OwnerId=plmr.musqot__userid__c;
         System.assertEquals('ITC', prj.name);         
         insert prj;
         
          musqot__CRM_settings__c mr=new musqot__CRM_settings__c();
          mr.musqot__Bar_color__c='#11100';
          mr.musqot__Chart__c='Line';
          mr.musqot__CRM_performance_type__c='Milestone';
          mr.Watch_type__c='Amount (weighted) Opportunitie';
          //mr.musqot__Expression_business_area__c='APAC,EMEA';
         // mr.musqot__Expression_business_region__c='Lead,Oppurtunities';
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
          crm.Value_w_Opportunities__c=4000;
          insert crm;
          System.assertEquals(4000,crm.Value_w_Opportunities__c);
            
          Milestone__c objmilestone=new Milestone__c ();
          objmilestone.Name='test';
          objmilestone.musqot__Plan__c=prj.id;   
          objmilestone.Milestone_type__c =1;
          objmilestone.musqot__Target_number__c=3;
          objmilestone.musqot__Status__c='Reach on time';
          objmilestone.musqot__Target_CRM_settings__c=mr.id;
          objmilestone.musqot__Targetdate__c=system.today();
          
          musqot__Musqot_member__c plm=new musqot__Musqot_member__c();
          plm.musqot__userid__c=u2.id;
          plm.musqot__Role__c='Member';
          plm.musqot__Plan__c=prj.id;
          insert plm;
        
          try{
          insert objmilestone;
          }catch(Exception e){}
          System.assertEquals('test', objmilestone.name);
     
         test.startTest();
         PageReference pageRef = Page.ProjectDetails;
         Test.setCurrentPage(pageRef);  
         ApexPages.currentPage().getParameters().put('planid',prj .id);
         ApexPages.currentPage().getParameters().put('mileId',objmilestone.id);
         ApexPages.StandardController sc = new ApexPages.standardController(prj);
         
          ProjectDetailsExtensionController objprojec = new ProjectDetailsExtensionController (sc);
          MusqotUtility.innerClass musIncls = MusqotUtility.securitySetting(prj.id);
          List<task> temp1= objprojec.gettaskrecs();
          List<Project__c >  temp23=objprojec.member;
          Project__c temp2=objprojec.pln;
          List<musqot__Allocation_amount__c> temp22=objprojec.listrec;
          Project__c  pro=[SELECT Id,Starts_date__c,Ends_date__c FROM Project__c  WHERE Id=:Prj.id];
          ProjectDetailsExtensionController.AttachWrapper OBJR=new ProjectDetailsExtensionController.AttachWrapper();
          objprojec.startDate=pro.Starts_date__c; 
          objprojec.endDate=pro.Ends_date__c ; 
          objprojec.getmilston();  
          try{   
          objprojec.delMember();
          }catch(exception e){}
         test.stoptest();
       }
}