@isTest(seeAlldata=true)
public class GanttDetailPageControllerTest{
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
        prjType.Plantype__c='EMEA Europen mark';
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
         insert objMarketingact;
         System.assertEquals('test', objMarketingact.name);
         
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=prj.id;
        attach.contentType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
        System.assertEquals(prj.id,attach.parentId);
        insert attach;
        musqot__User_setting__c gantt=new musqot__User_setting__c();
        gantt.musqot__Gantt_type__c=1;
        gantt.musqot__Ganttview__c='test';
        gantt.musqot__Global__c=true;
        gantt.musqot__My_default__c=true;
        gantt.musqot__Userid__c=objUser.id;
        insert gantt;
        
        musqot__Activity__c m1 =new musqot__Activity__c();
        m1.musqot__keycode__c='212';
        m1.Plan_access_controll__c=true;
        System.assertEquals('212', m1.musqot__keycode__c);
        insert m1;
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
        
    	ApexPages.currentPage().getParameters().put('id', subPrj.id);  
        GanttDetailPageController GPC = new GanttDetailPageController();        
        List<String> temp4=GPC.getselectedFilterProjectTypes();
        List<SelectOption> selOpts = GPC.PLANList;
        List<SelectOption> temp1=GPC.FilterList;
        //try{
        List<SelectOption> protemp=GPC.PROJECTList;
        //}catch(exception e){}
        
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
        try{
        GPC.showPopup();
       }catch(Exception e){}
        try{
        GPC.getFilter();
        }catch(Exception e){}
        try{
        GPC.showSelectedPlanTypes(); 
        }catch(exception e){}
       // try{
        GPC.loadganttviewbyFilter();
        //}catch(exception e){}
        //GPC.getganttviewbyFilter();
       try{
        GPC.DeleteFilter();
        }catch(exception e){} 
        GPC.getstyleString();
        GPC.getjsString();
        GPC.gettaskstyleString();
        try{
        GPC.showSelectedPlanTypes();
        }catch(Exception e){}
        GPC.gotoPerformancePage();
        GPC.gotoGanttPage();
        //GPC.getdataString();
        //GPC.loadNodeInfoPopUp();
        //GPC.displayInfoPopup=true;
        GPC.projectName='tpro';
        GPC.escapeSpecialChars('String str');
        GanttDetailPageController.GanttRow ganttwrap= new GanttDetailPageController.GanttRow();
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
        GanttDetailPageController.getParentId();
        GPC.showBtn = true;    
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
        prjType.Plantype__c='Businessarea';
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
        gantt.musqot__Gantt_type__c=1;
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
        GanttDetailPageController GPC = new GanttDetailPageController();
        List<SelectOption> selOpts = GPC.PLANList;
        List<SelectOption> temp1=GPC.FilterList;
        //List<String> tem=GPC.getselectedFilterTypes();
        
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
        GPC.showSelectedPlanTypes();
       }catch(Exception e){}
         
       try{
        GPC.loadganttviewbyFilter();
       }catch(exception e){}
       //GPC.getganttviewbyFilter();
       try{
        GPC.DeleteFilter();
       }catch(exception e){} 
        GPC.getstyleString();
        GPC.getjsString();
        GPC.gettaskstyleString();
        //GPC.showSelectedPlanTypes();
        GPC.gotoPerformancePage();         
        //GPC.getdataString();      
    }
 static testMethod void preapreJSONTest12(){   
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
        prjType.Plantype__c='Businessarea';
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
        gantt.musqot__Gantt_type__c=1;
        gantt.musqot__Ganttview__c='test';
        gantt.musqot__Global__c=true;
        gantt.musqot__My_default__c=true;
        gantt.musqot__Userid__c=UserInfo.getUserId();
        insert gantt;
        
        Document document = new Document();
        document .name='test';
        document.AuthorId = UserInfo.getUserId();
        document.FolderId = UserInfo.getUserId();
        insert document ;
        
        musqot__Activity__c m1 =new musqot__Activity__c();
        m1.musqot__keycode__c='212';
        m1.musqot__Use_Allocation__c=true;
        m1.musqot__Use_Budget__c=true;
        m1.musqot__Use_Finance1__c=true;
        m1.musqot__Use_Forcasting__c=true;
        m1.musqot__Use_milestones__c=true;
        m1.musqot__Use_Resource__c=true;
        m1.Plan_access_controll__c=false;
        System.assertEquals('212', m1.musqot__keycode__c);
        insert m1;
        
       
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null,'1.0');
        w.writeStartElement(null,'gantt',null);        
        w.writeStartElement(null,'gtimeSlot',null);
        w.writeEndElement();
        w.writeStartElement(null,'gstartDate',null);
        w.writeEndElement();
        w.writeStartElement(null,'gendDate',null);
        w.writeEndElement();
        
        GanttDetailPageController GPC = new GanttDetailPageController();
        List<SelectOption> selOpts = GPC.PLANList;
        List<SelectOption> temp1=GPC.FilterList;
        //List<String> tem=GPC.getselectedFilterTypes();
        
        musqot__Project__c temp23=GPC.ObjPro;
        GPC.IsDeleted=true;  
        GPC.FilterName='test';  
        GPC.displayPopup=true;
        List<String> temp2=GPC.FilterTypes; 
        GPC.FilterStartDate=system.toDay();
        GPC.FilterEndDate=system.toDay(); 
        GPC.FilterZooming='Daily';
        list<User_setting__c >selFilter= [SELECT Id FROM User_setting__c 
                                    WHERE id=:gantt.id limit 250];
        //GPC.mydefaultFilter=true;
        GPC.isGlobaluser=true;
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
        GPC.showSelectedPlanTypes();
       }catch(Exception e){}
         
       try{
        GPC.loadganttviewbyFilter();
       }catch(exception e){}
       //GPC.getganttviewbyFilter();
       try{
        GPC.DeleteFilter();
       }catch(exception e){} 
        GPC.getstyleString();
        GPC.getjsString();
        GPC.gettaskstyleString();
        //GPC.showSelectedPlanTypes();
        GPC.gotoPerformancePage();         
        //GPC.getdataString();     
    }
 static testMethod void preapreJSONTest123(){   
     Profile p = [select id from profile where name='System Administrator']; 
        User objUser = new User(alias = 'stan', email='standarduser@test.com', 
                                emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
                                localesidkey='en_US', profileid = p.Id, 
                                timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
        insert objUser ;       
                
        Plantype__c pt = new Plantype__c();
        pt.Barcolor__c = '6E766F';
        pt.Name = 'Global';
        System.assertEquals('Global', pt.name);
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
        prjType.Plantype__c='Businessarea';
        System.assertEquals('Business', prjType.name);
        insert prjType; 
        
        Subproject__c subsubPrj = new Subproject__c();         
        subsubPrj.Name='ITC Project';
        subsubPrj.Parent_project__c = prj.Id;
        subsubPrj.Ends_date__c = system.toDay().addDays(3);
        subsubPrj.Starts_date__c= system.toDay();
        subsubPrj.Status__c = 'In Progress';
        //subsubPrj.Project_del__c = subPrj.Id;  
        subsubPrj.Project_type__c = prjType.Id;
        System.assertEquals('ITC Project', subsubPrj.name);
        insert subsubPrj;
        
        musqot__User_setting__c gantt=new musqot__User_setting__c();
        gantt.musqot__Gantt_type__c=2;
        gantt.musqot__Ganttview__c='test';
        gantt.musqot__Global__c=false;
        gantt.musqot__My_default__c=true;
       // gantt.musqot__Userid__c=UserInfo.getUserId();
        insert gantt;
        
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=prj.id;
        attach.contentType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
        System.assertEquals(prj.id,attach.parentId);
        insert attach;
        
        musqot__Activity__c m1 =new musqot__Activity__c();
        m1.musqot__keycode__c='212';
        m1.musqot__Use_Allocation__c=true;
        m1.musqot__Use_Budget__c=true;
        m1.musqot__Use_Finance1__c=true;
        m1.musqot__Use_Forcasting__c=true;
        m1.musqot__Use_milestones__c=true;
        m1.musqot__Use_Resource__c=true;
        m1.Plan_access_controll__c=false;
        System.assertEquals('212', m1.musqot__keycode__c);
        insert m1;
       
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null,'1.0');
        w.writeStartElement(null,'gantt',null);        
        w.writeStartElement(null,'gtimeSlot',null);
        w.writeEndElement();
        w.writeStartElement(null,'gstartDate',null);
        w.writeEndElement();
        w.writeStartElement(null,'gendDate',null);
        w.writeEndElement();
        
        GanttDetailPageController GPC = new GanttDetailPageController();
        List<SelectOption> selOpts = GPC.PLANList;
        List<SelectOption> temp1=GPC.FilterList;
        //List<String> tem=GPC.getselectedFilterTypes();
        
        musqot__Project__c temp23=GPC.ObjPro;
        GPC.IsDeleted=true;  
        GPC.FilterName='test';  
        GPC.displayPopup=true;
        List<String> temp2=GPC.FilterTypes; 
        GPC.FilterStartDate=system.toDay();
        GPC.FilterEndDate=system.toDay(); 
        GPC.FilterZooming='Daily';
        list<User_setting__c >selFilter= [SELECT Id FROM User_setting__c 
                                    WHERE id=:gantt.id limit 250];
        //GPC.mydefaultFilter=true;
        GPC.isGlobaluser=true;
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
        GPC.showSelectedPlanTypes();
       }catch(Exception e){}
         
       try{
        GPC.loadganttviewbyFilter();
       }catch(exception e){}
       //GPC.getganttviewbyFilter();
       try{
        GPC.DeleteFilter();
       }catch(exception e){} 
        GPC.getstyleString();
        GPC.getjsString();
        GPC.gettaskstyleString();
        //GPC.showSelectedPlanTypes();
        GPC.gotoPerformancePage();         
        //GPC.getdataString();
    }
   static testMethod void dataString(){
        Plantype__c pt = new Plantype__c();
       	pt.Name='Zuri';
        pt.Barcolor__c = '6E766F';
        System.assertEquals('Zuri', pt.name);
        insert pt;
        
        Project__c prj = new Project__c ();
        prj.Name='ITC';
        prj.Plantype__c= pt.Id;
        prj.Ends_date__c = system.toDay();
        prj.Starts_date__c= system.toDay();
        prj.Status__c = 'In Progress';
        System.assertEquals('ITC', prj.name);        
        insert prj;
        
        Project_type__c prjType = new Project_type__c();
        prjType.Name = 'Business';
        prjType.Color__c = 'FFFF01';
        prjType.Plantype__c='Businessarea';
        System.assertEquals('Business', prjType.name);
        insert prjType;
		Subproject__c objsubprojct=new Subproject__c();
        objsubprojct.Parent_project__c=prj.id;
        objsubprojct.Name = 'testsubpro';
        objsubprojct.Starts_date__c = Date.Today();
        objsubprojct.Ends_date__c= Date.Today();
        objsubprojct.Status__c = 'Completed';
        //objsubprojct.IsDeleted=false;
        insert objsubprojct;
        System.assertEquals('testsubpro', objsubprojct.name);
        
        Subproject__c objsub=new Subproject__c();
        objsub.Parent_project__c=prj.id;
        objsub.Name = 'testsubpro';
        objsub.Starts_date__c = Date.Today();
        objsub.Ends_date__c= Date.Today();
        objsub.Project_del__c=objsubprojct.id;
        objsub.Status__c = 'Completed';
        //objsub.IsDeleted=false;
        insert objsub;
       
       Marketing_activity__c objMarketingact=new Marketing_activity__c();
         objMarketingact.Name='test';
         objMarketingact.Description__c='tdescriptionest';
         objMarketingact.Status__c='completed';
         objMarketingact.musqot__Project__c=objsub.id;
         insert objMarketingact;
         //System.assertEquals('test', objMarketingact.name);
       
        System.assertEquals('testsubpro', objsub.name);
		User_setting__c  us=new User_setting__c();
        us.Gantt_type__c=1;
        us.Ganttview__c='test';
        
       Task objtask = new Task();      
       objtask.Task_name__c = 'testname'; 
       objtask.OwnerId=UserInfo.getUserId();
       objtask.WhatId=objsub.id;
       objtask.ActivityDate =system.toDay();
       objtask.Status='Deferred';
       objtask.Allocated_h__c=2;
       objtask.Outcome_h__c=2;
       objtask.Task_description__c='test record';
       objtask.Task_name__c='Testtask';                     
       insert objtask ;
       System.assertEquals('Testtask', objtask .Task_name__c);
        System.assertEquals(1,us.Gantt_type__c);
        insert us;
        GanttDetailPageController GPC1 = new GanttDetailPageController();
        GPC1.getdataString();
        GPC1.getganttviewbyFilter();
    }
 static testMethod void seleectedfilt0(){
     	User_setting__c  us=new User_setting__c();
        us.Gantt_type__c=1;
     	us.My_default__c=false;
     	us.Userid__c=UserInfo.getUserId();
        us.Ganttview__c='test';
     	insert us;
     System.assertEquals(1,us.Gantt_type__c);
     
        GanttDetailPageController gdetailselfilter = new GanttDetailPageController();
     	gdetailselfilter.displayPopup=true;
     	gdetailselfilter.FilterZooming='';
     	gdetailselfilter.FilterStartDate=System.today();
     	gdetailselfilter.FilterEndDate=System.today();
     	gdetailselfilter.selectedFilter='0';
     	gdetailselfilter.mydefaultFilter=false;
     	gdetailselfilter.GlobalFilter=false;
     	gdetailselfilter.FilterName='test';
     	gdetailselfilter.SaveFilter();
 	}
}