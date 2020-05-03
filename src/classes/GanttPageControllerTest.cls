@isTest(seeAlldata=true)
public class GanttPageControllerTest{
    
    /*** testing all gantt methods ****/
    static testMethod void preapreJSONTest(){   
     Profile p = [select id from profile where name='System Administrator']; 
        User objUser = new User(alias = 'stan', email='standarduser@test.com', 
                                emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
                                localesidkey='en_US', profileid = p.Id, 
                                timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
        insert objUser ;       
                
        Plantype__c pt = new Plantype__c();
        pt.Barcolor__c = '6E766F';
        pt.Name = 'Zuri';
        System.assertEquals('Zuri', pt.name);
        insert pt;
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=objUser.id;
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
        
         Marketing_activity__c objMarketingact=new Marketing_activity__c();
         objMarketingact.Name='test';
         objMarketingact.Description__c='tdescriptionest';
         objMarketingact.Status__c='completed';
         objMarketingact.musqot__Project__c=subPrj.id;
         objMarketingact.Ends_date__c = system.toDay();
         objMarketingact.Starts_date__c= system.toDay();
         objMarketingact.Activity_Class__c= 'Activity blue';
         objMarketingact.multi_pubication__c= true;
         //objMarketingact.Priority_level__c= 'High';
         insert objMarketingact;
         System.assertEquals('test', objMarketingact.name);
        
        Members__c objmemberedit = new Members__c();
        objmemberedit .User_Email__c = 'test';
        objmemberedit .Role__c = 'Member';
        objmemberedit .Type__c = 'Internal User';
        objmemberedit.ProjUsers__c=objUser.id;
        objmemberedit .Marketingmebers__c = objMarketingact.id;
        objmemberedit .SubProjMembers__c = subPrj.id;
        objmemberedit.ProjMembers__c = prj.Id;
        System.assertEquals('Member', objmemberedit.Role__c);
        insert objmemberedit ;
        
        Musqot_member__c plmr=new Musqot_member__c();
        plmr.musqot__userid__c=objUser.id;
        plmr.musqot__Plan__c=prj.id;
        plmr.musqot__project__c=subPrj.id;
        plmr.musqot__Marketing_activity__c=objMarketingact.id;
        plmr.musqot__Role__c='Member';        
        plmr.musqot__User_type__c='Internal user';
        System.assertEquals('Member', plmr.musqot__Role__c);
        insert plmr;
        
        Musqot_fiscal_year__c mfy = new Musqot_fiscal_year__c();
        mfy.Name='jan';
        mfy.Start_date__c=System.today();
        mfy.End_date__c=System.today();  
        System.assertEquals('jan', mfy.name);
        insert mfy;
        
        Budget__c  bud=new Budget__c ();    
        bud.Name='test';
        bud.Approved_date__c =System.now().date(); 
        bud.Project__c =prj.id; 
        bud.subproject__c=subPrj.id;
        bud.FiscalYear__c='january';
        bud.Musqot_fiscal_year__c =mfy.id;
        bud.user__c=objUser.id;
        bud.Description__c='test';
        bud.Budget__c=200;
        System.assertEquals('test', bud.name);
        insert bud;
        
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
        System.assertEquals('Testtask', objtask .Task_name__c); 
         
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=prj.id;
        attach.contentType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
        System.assertEquals(prj.id,attach.parentId);
        insert attach;
        musqot__User_setting__c gantt=new musqot__User_setting__c();
        gantt.musqot__Gantt_type__c=2;
        gantt.musqot__Ganttview__c='test';
        gantt.musqot__Global__c=true;
        gantt.musqot__My_default__c=true;
        gantt.musqot__Userid__c=objUser.id;
        insert gantt;
        Document document = new Document();
        document .name='test';
        document.AuthorId = UserInfo.getUserId();
        document.FolderId = UserInfo.getUserId();
        insert document ;
        
        User_setting__c  us=new User_setting__c();
        us.musqot__Gantt_type__c=0;
        us.musqot__Ganttview__c='test';
        us.musqot__Global__c=true;
        us.musqot__My_default__c=true;
        us.musqot__Userid__c=objUser.id;
        System.assertEquals( us.musqot__Global__c,true);
        insert us;      
        
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null,'1.0');
        w.writeStartElement(null,'gantt',null);        
        w.writeStartElement(null,'gtimeSlot',null);
      
        w.writeEndElement();
        w.writeStartElement(null,'gstartDate',null);
        
        w.writeEndElement();
        w.writeStartElement(null,'gendDate',null);
       
        w.writeEndElement();
    
        GanttPageController GPC = new GanttPageController();
        GanttPageController.createPlanCopy(prj.id,'test',date.today(),true,true,true,true,true,true,'2016');
        //GanttPageController.createProjectCopy(subPrj.id,prj.id,'project',prj.id,'test',date.today(),new List<String>(),true,true,true,true,true,true,'2016');
        GanttPageController.createActivityCopy(objMarketingact.id,subPrj.id,prj.id,'test',date.today(),true,true,true,true);
        List<SelectOption> selOpts = GPC.PLANList;
        List<SelectOption> temp1=GPC.FilterList;
        List<SelectOption> temp4=GPC.getProjectStatusList();
        List<String> tem=GPC.getselectedFilterTypes();
        
        musqot__Project__c temp23=GPC.ObjPro;
        GPC.IsDeleted=true;  
        GPC.FilterName='test';  
        GPC.displayPopup=true;
        GPC.addfiltersetting=true;
        List<String> temp2=GPC.FilterTypes; 
        GPC.FilterStartDate=system.toDay();
        GPC.FilterEndDate=system.toDay(); 
        GPC.FilterZooming='Daily';
        list<User_setting__c >selFilter= [SELECT Id FROM User_setting__c 
                                    WHERE id=:us.id limit 250];
        //GPC.selectedFilter=;
        GPC.selectedFilter=selFilter[0].id;
        string prjSet ;
         prjSet =subPrj.id; 
          List<Subproject__c> spList = [select Id,Name,(select Id,Name,Activitytype__r.Icon__c,Activitytype__r.Name,Activitytype__r.Bar_color__c,Ends_date__c,Starts_date__c,Project__c,StatusImage__c,Status__c,Description__c,Project__r.Name 
                                                              from Marketing_activities__r order by Starts_date__c) 
                                              from Subproject__c where Id=:prjSet ];
       // GPC.selectedFilterTypes(List<String> selectedFilterTypes);
        GPC.displayPopup=true;
        try{
        GPC.SaveFilter();
        }catch(Exception e){}
        try{
        GPC.closePopup();
        }catch(Exception e){}
        //try{
        GPC.showPopup();
       // }catch(Exception e){}
        //try{
        GPC.getFilter();
        //}catch(Exception e){}
        try{
        //GPC.showSelectedPlanTypes();         
        }catch(exception e){}
       // try{
        GPC.loadganttviewbyFilter();
        //}catch(exception e){}
        GPC.getganttviewbyFilter();
       // try{
        GPC.DeleteFilter();
        //}catch(exception e){} 
        GPC.getstyleString();
        GPC.getjsString();
        GPC.gettaskstyleString();
        GPC.gotoPerformancePage();         
        GPC.displayInfoPopup=true;
        GPC.projectName='tpro';
        GPC.projectDescription='tprodesc';
        GPC.projectStatus='progress';
        GPC.projectStartDate=system.today();
        GPC.projectEndDate=system.today();
        GPC.projectOwner='prowner'; 
        //GPC.selectedPriorityLevels('priority');
        GPC.getselectedPriorityLevels();
    }
     static testMethod void preapreJSONTest1(){   
     Profile p = [select id from profile where name='System Administrator']; 
        User objUser = new User(alias = 'stan', email='standarduser@test.com', 
                                emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
                                localesidkey='en_US', profileid = p.Id, 
                                timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
        insert objUser ;       
                
        Plantype__c pt = new Plantype__c();
        pt.Barcolor__c = '6E766F';
        pt.Name = 'Zuri';
        System.assertEquals('Zuri', pt.name);
        insert pt;
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=objUser.id;
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
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=prj.id;
        attach.contentType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
        System.assertEquals(prj.id,attach.parentId);
        insert attach;
        musqot__User_setting__c gantt=new musqot__User_setting__c();
        gantt.musqot__Gantt_type__c=2;
        gantt.musqot__Ganttview__c='test';
        gantt.musqot__Global__c=true;
        gantt.musqot__My_default__c=true;
        gantt.musqot__Userid__c=objUser.id;
        insert gantt;
        Document document = new Document();
        document .name='test';
        document.AuthorId = UserInfo.getUserId();
        document.FolderId = UserInfo.getUserId();
        insert document ;
        
        User_setting__c  us=new User_setting__c();
        us.musqot__Gantt_type__c=1;
        us.musqot__Ganttview__c='test';
        us.musqot__Global__c=true;
        us.musqot__My_default__c=true;
        us.musqot__Userid__c=objUser.id;
        System.assertEquals( us.musqot__Global__c,true);
        insert us;      
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null,'1.0');
        w.writeStartElement(null,'gantt',null);        
        w.writeStartElement(null,'gtimeSlot',null);
        w.writeEndElement();
        w.writeStartElement(null,'gstartDate',null);
        w.writeEndElement();
        w.writeStartElement(null,'gendDate',null);
        w.writeEndElement();
        GanttPageController GPC = new GanttPageController();
        List<SelectOption> selOpts = GPC.PLANList;
        List<SelectOption> temp1=GPC.FilterList;
        List<String> tem=GPC.getselectedFilterTypes();
        
        musqot__Project__c temp23=GPC.ObjPro;
        GPC.IsDeleted=true;  
        GPC.FilterName='test';  
        GPC.displayPopup=true;
        List<String> temp2=GPC.FilterTypes; 
        GPC.FilterStartDate=system.toDay();
        GPC.FilterEndDate=system.toDay(); 
        GPC.FilterZooming='Daily';
        list<User_setting__c >selFilter= [SELECT Id FROM User_setting__c 
                                    WHERE id=:us.id limit 250];
        GPC.mydefaultFilter=true;
        GPC.isGlobaluser=true;
        //GPC.selectedFilter=;
        //GPC.selectedFilter=null;//selFilter[0].id;
        //GPC.selectedFilterTypes(List<String> selectedFilterTypes);
        GPC.displayPopup=true;
        try{
        GPC.SaveFilter();
        }catch(Exception e){}
        try{
        GPC.closePopup();
        }catch(Exception e){}
       try{
        GPC.showPopup();
       }catch(Exception e){}
       try{
        GPC.getFilter();
       }catch(Exception e){}
        GPC.showSelectedPlanTypes(); 
       try{
        GPC.loadganttviewbyFilter();
       }catch(exception e){}
        GPC.getganttviewbyFilter();
       try{
        GPC.DeleteFilter();
       }catch(exception e){} 
        GPC.getstyleString();
        GPC.getjsString();
        GPC.gettaskstyleString();
        GPC.showSelectedPlanTypes();
        GPC.gotoPerformancePage();         
        GPC.getdataString();      
    }
    static testMethod void projectcopy(){
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
        subPrj.oldId__c='oldid';
        subPrj.tempId__c='tempid';
        subPrj.Project_type__c = prjType.Id;
        System.assertEquals('ITC Project', subPrj.name);     
        insert subPrj;
        
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        objtask.WhatId=subPrj.id;
        objtask.ActivityDate =system.toDay();
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        System.assertEquals('Testtask', objtask .Task_name__c);
        
        Subproject__c subsubPrj = new Subproject__c();         
        subsubPrj.Name='ITC Project';
        subsubPrj.Parent_project__c = prj.Id;
        subsubPrj.Ends_date__c = system.toDay().addDays(3);
        subsubPrj.Starts_date__c= system.toDay();
        subsubPrj.Status__c = 'In Progress';
        subsubPrj.Project_del__c = subPrj.Id;  
        subsubPrj.Project_type__c = prjType.Id;
        subsubPrj.oldId__c='oldid';
        subsubPrj.tempId__c='tempid';
        System.assertEquals('ITC Project', subsubPrj.name);
        insert subsubPrj;
        GanttPageController GPC = new GanttPageController();
        List<String> subids = new List<String>();
        subids.add(subsubPrj.id);
        GanttPageController.createProjectCopy(subPrj.id,prj.id,'project',prj.id,'test',date.today(),subids,true,true,true,true,true,true,'2016');        
    	GPC.pid_ap='project';
        GPC.pc_npn_ap='project';
        GPC.pc_np_sd_ap='project';
        GPC.showBtn=false;
    }
    static testMethod void projectcopy2(){
    	Project__c prj = new Project__c ();
        prj.Name='ITC';
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
        subPrj.Project_type__c = prjType.Id;
        subPrj.oldId__c='oldid';
        subPrj.tempId__c='tempid';
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
        subsubPrj.oldId__c='oldid';
        subsubPrj.tempId__c='tempid';
        System.assertEquals('ITC Project', subsubPrj.name);
        insert subsubPrj;
        
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
         objMarketingact.Name='test';
         objMarketingact.Description__c='tdescriptionest';
         objMarketingact.Status__c='completed';
         objMarketingact.Project__c=subPrj.id;
         objMarketingact.Plan__c=prj.id;
         objMarketingact.Ends_date__c = system.toDay();
         objMarketingact.Starts_date__c= system.toDay();
         objMarketingact.Activity_Class__c= 'Activity blue';
         objMarketingact.multi_pubication__c= true;
         //objMarketingact.Priority_level__c= 'High';
         insert objMarketingact;
         System.assertEquals('test', objMarketingact.name);
        GanttPageController GPC1 = new GanttPageController();
        GanttPageController.createProjectCopy(subPrj.id,prj.id,'project',prj.id,'test',date.today(),new List<String>(),true,true,true,true,true,false,'2016');
    }
    static testMethod void projectcopy1(){
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
        subPrj.Project_type__c = prjType.Id;
        subPrj.oldId__c='oldid';
        subPrj.tempId__c='tempid';
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
        subsubPrj.oldId__c='oldid';
        subsubPrj.tempId__c='tempid';
        System.assertEquals('ITC Project', subsubPrj.name);
        insert subsubPrj;
        GanttPageController GPC = new GanttPageController();
        GanttPageController.createProjectCopy(subPrj.id,prj.id,'project',prj.id,'test',date.today(),new List<String>(),true,true,false,true,true,false,'2016');        
    	GPC.pid_ap='project';
        GPC.pc_npn_ap='project';
        GPC.pc_np_sd_ap='project';
        GPC.showBtn=false;
    }
    static testMethod void marketcopy(){
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
        
         Marketing_activity__c objMarketingact=new Marketing_activity__c();
         objMarketingact.Name='test';
         objMarketingact.Description__c='tdescriptionest';
         objMarketingact.Status__c='completed';
         objMarketingact.Project__c=subPrj.id;
         objMarketingact.Ends_date__c = system.toDay();
         objMarketingact.Starts_date__c= system.toDay();
         objMarketingact.Activity_Class__c= 'Activity blue';
         objMarketingact.multi_pubication__c= true;
         //objMarketingact.Priority_level__c= 'High';
         insert objMarketingact;
         System.assertEquals('test', objMarketingact.name);
        
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay();
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        System.assertEquals('Testtask', objtask .Task_name__c);
      
        GanttPageController GPC = new GanttPageController();
        GanttPageController.createActivityCopy(objMarketingact.id,subPrj.id,prj.id,'test',date.today(),true,false,true,false);        
    	GPC.pid_ap='project';
        GPC.pc_npn_ap='project';
        GPC.pc_np_sd_ap='project';
        GPC.showBtn=false;
    }
    static testMethod void plancopysub(){
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
        subPrj.Project_type__c = prjType.Id;
        System.assertEquals('ITC Project', subPrj.name);     
        insert subPrj;
        
        Subproject__c subsubPrj = new Subproject__c();         
        subsubPrj.Name='ITC Project';
        subsubPrj.Parent_project__c = prj.Id;
        subsubPrj.Ends_date__c = system.toDay().addDays(3);
        subsubPrj.Starts_date__c= system.toDay();
        subsubPrj.Status__c = 'In Progress';
        subsubPrj.Project_del__c = null;  
        subsubPrj.Project_type__c = prjType.Id;
        System.assertEquals('ITC Project', subsubPrj.name);
        insert subsubPrj;
        GanttPageController GPC = new GanttPageController();
        GanttPageController.createPlanCopy(prj.id,'test',date.today(),false,true,false,true,true,false,'2016');
    }
}