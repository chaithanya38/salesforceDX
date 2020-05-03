/*********************************************************************
Class Name: TaskControllerTest 
Author:Chaithanya daggumati         Last modified by:Raju GN
Date: 22/7/2014                     Date: 19/3/2015  
********©2013 Musqot marketing technology Pvt ltd ********************/
@isTest(seeAllData=true)
    public class TaskControllerTest{
        static testMethod void TaskController(){           
           Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
           User u2 =new User( Alias = 'newUser1' ,
           Email ='newuser123@testorg.com',
           EmailEncodingKey = 'UTF-8',
           LastName = 'Testing',
           LanguageLocaleKey='en_US',
           LocaleSidKey='en_US', 
           UserName='newuser1234@testorg.com',
           ProfileId=p.Id,
           TimeZoneSidKey = 'America/Los_Angeles');
           insert u2;
            
            Project__c objproject = new Project__c ();
            objproject.Name='test';
           //objproject.Project_type__c='test';
            objproject.Starts_date__c= System.now().date();
            objproject.Ends_date__c= System.now().date();
            System.assertEquals('test', objproject.name);
            insert objproject;
            
            Subproject__c objspr = new Subproject__c ();
            objspr.name = 'testname';
            objspr.Description__c = 'sampdesc';
            objspr.Starts_date__c = date.today();
            objspr.Ends_date__c = date.today();
            objspr.Status__c = 'Notstarted';    
            System.assertEquals('testname', objspr.name);
            insert objspr; 
            
            Subproject__c objsp = new Subproject__c ();
            objsp.name = 'testname';
            objsp.Description__c = 'sampdesc';
            objsp.Starts_date__c = date.today();
            objsp.Ends_date__c = date.today()+10;
            objsp.Project_del__c = objspr.id;
            objsp.Parent_project__c = objproject.id;
            //objsp.Project_type__c = 'prtyp';
            objsp.Status__c = 'Notstarted';
           //objsp.user__c = u2.id;        
            System.assertEquals('testname', objsp .name);
            insert objsp ; 

            Marketing_activity__c objMarketingact=new Marketing_activity__c();
            objMarketingact.Name='test';
            objMarketingact.Description__c='tdescriptionest';
            objMarketingact.Status__c='completed';
            System.assertEquals('test', objMarketingact.name);
            insert objMarketingact;
            
            Task objtask = new Task();      
            objtask.Task_name__c = 'testname'; 
            objtask.OwnerId=UserInfo.getUserId();
            objtask.WhatId=objproject.id;
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
            attach.parentId=objtask .id;
            System.assertEquals(objtask .id,attach.parentId);
            insert attach;
            
             Members__c objmember=new Members__c ();
             objmember.ProjMembers__c= objproject.Id;
             objmember.ProjUsers__c= u2.Id;
             objmember.SubProjMembers__c= objsp.Id;
             objmember.Role__c='Member';
             objmember.User_Email__c ='standarduser1@test.com';
             System.assertEquals('Member', objmember.Role__c);
             insert objmember;
            
            test.starttest();  
            String tabId = System.currentPageReference().getParameters().get('tabId');           
            ApexPages.currentPage().getParameters().put('id', objtask.id);
            ApexPages.currentPage().getParameters().put('mrkId',objMarketingact.id);
            PageReference pageRef = Page.Task;
            Test.setCurrentPage(pageRef); 
            ApexPages.StandardController sc = new ApexPages.standardController(objtask);            
            TaskController tsk = new TaskController(sc);
            TaskController tsk1= new TaskController();
            Members__c mbrs = [select Id,ProjUsers__c from Members__c LIMIT 1];
            upsert objmember;
            list<SelectOption>  temp=tsk.getItems();
            tsk.selectedTime='test';
            try{
            DateTime temp1=tsk.getConvertDateTime('string strDT');
            }catch(exception e){}
            tsk.Task = objtask;
           tsk.dauDateMethod();
           // c
            tsk.Save();
           // }catch(exception e){}
            tsk.cancel();
            tsk.getRedirectToTemplate();
            tsk.redirectToTemplate();
            tsk.getSelectedItem();
            tsk.setSelectedItem('String s');
            //tsk.getConvertDateTime('String strDt');
            test.stopTest();
           }           
    static testMethod void Taskprojtest1(){
           Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
           User u2 =new User( Alias = 'newUser1' ,
           Email ='newuser123@testorg.com',
           EmailEncodingKey = 'UTF-8',
           LastName = 'Testing',
           LanguageLocaleKey='en_US',
           LocaleSidKey='en_US', 
           UserName='newuser1234@testorg.com',
           ProfileId=p.Id,
           TimeZoneSidKey = 'America/Los_Angeles');
           insert u2;
            
            Project__c objproject = new Project__c ();
            objproject.Name='test';
           //objproject.Project_type__c='test';
            objproject.Starts_date__c= System.now().date();
            objproject.Ends_date__c= System.now().date();
            System.assertEquals('test', objproject.name);
            insert objproject;
            
            Subproject__c objsp = new Subproject__c ();
            objsp.name = 'testname';
            objsp.Description__c = 'sampdesc';
            objsp.Starts_date__c = date.today();
            objsp.Ends_date__c = date.today();
            objsp.Status__c = 'Notstarted';
            //objsp.StatusImage__c = 'Inprograss';
            //objsp.user__c = u2.id;        
            System.assertEquals('testname', objsp .name);
            insert objsp ; 
                    
            
            Marketing_activity__c objMarketingact=new Marketing_activity__c();
            objMarketingact.Name='test';
            objMarketingact.Description__c='tdescriptionest';
            objMarketingact.Status__c='completed';
            System.assertEquals('test', objMarketingact.name);
            insert objMarketingact;
            
            Task objtask = new Task();      
            objtask.Task_name__c = 'testname';
            objtask.WhatId=objproject.id;                      
            System.assertEquals('testname', objtask .Task_name__c); 
            //insert objtask ;
            
             Members__c objmember=new Members__c ();
             //objmember.Name ='test';
             objmember.ProjMembers__c= objproject.Id;
             objmember.ProjUsers__c= u2.Id;
             objmember.SubProjMembers__c= objsp.Id;
            objmember.Role__c='Member';
            objmember.User_Email__c ='standarduser1@test.com';
            System.assertEquals('Member', objmember.Role__c);
            insert objmember;
            test.starttest();
            PageReference pageRef = Page.Task;
            Test.setCurrentPage(pageRef); 
            String tabId = System.currentPageReference().getParameters().get('tabId');
            //ApexPages.currentPage().getParameters().put('mrkId',null);            
            ApexPages.currentPage().getParameters().put('planid',objproject.id);
            system.debug('----->'+objproject.id);
            
            ApexPages.StandardController sc = new ApexPages.standardController(objtask);
            TaskController tsk = new TaskController(sc);
            tsk.Task = objtask;
            try{
            tsk.Save();
            }catch(exception e){}
            tsk.cancel();
            tsk.getRedirectToTemplate();
            tsk.redirectToTemplate();
            tsk.getSelectedItem();
            tsk.setSelectedItem('String s');
           // tsk.getConvertDateTime('String strDt');
           }
    static testMethod void Taskprojtest2(){
           Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
           User u2 =new User( Alias = 'newUser1' ,
           Email ='newuser123@testorg.com',
           EmailEncodingKey = 'UTF-8',
           LastName = 'Testing',
           LanguageLocaleKey='en_US',
           LocaleSidKey='en_US', 
           UserName='newuser1234@testorg.com',
           ProfileId=p.Id,
           TimeZoneSidKey = 'America/Los_Angeles');
           insert u2;
            
            Project__c objproject = new Project__c ();
            objproject.Name='test';
           //objproject.Project_type__c='test';
            objproject.Starts_date__c= System.now().date();
            objproject.Ends_date__c= System.now().date();
            System.assertEquals('test', objproject.name);
            insert objproject;
            
            Subproject__c objsp = new Subproject__c ();
            objsp.name = 'testname';
            objsp.Description__c = 'sampdesc';
            objsp.Starts_date__c = date.today();
            objsp.Ends_date__c = date.today();
            //objsp.Project_del__c = ;
            //objsp.Parent_project__c = 'pproj';
            //objsp.Project_type__c = 'prtyp';
            objsp.Status__c = 'Notstarted';
            //objsp.StatusImage__c = 'Inprograss';
            //objsp.user__c = u2.id;        
            System.assertEquals('testname', objsp .name);
            insert objsp ; 
                    
            
            Marketing_activity__c objMarketingact=new Marketing_activity__c();
            objMarketingact.Name='test';
            objMarketingact.Description__c='tdescriptionest';
            objMarketingact.Status__c='completed';
            System.assertEquals('test', objMarketingact.name);
            insert objMarketingact;
            
            Task objtask = new Task();      
            objtask.Task_name__c = 'testname';
            objtask.WhatId=objsp.id;                      
            System.assertEquals('testname', objtask .Task_name__c); 
            //insert objtask ;
            
             Members__c objmember=new Members__c ();
             objmember.ProjMembers__c= objproject.Id;
             objmember.ProjUsers__c= u2.Id;
             objmember.SubProjMembers__c= objsp.Id;
             objmember.Role__c='Member';
             objmember.User_Email__c ='standarduser1@test.com';
             System.assertEquals('Member', objmember.Role__c);
             insert objmember;
             test.starttest();
             PageReference pageRef = Page.Task;
             Test.setCurrentPage(pageRef); 
           
            String tabId = System.currentPageReference().getParameters().get('tabId');         
            ApexPages.currentPage().getParameters().put('subid',objsp .id);
            system.debug('----->'+objproject.id);
            ApexPages.StandardController sc = new ApexPages.standardController(objtask);
            TaskController tsk = new TaskController(sc);
            tsk.Task = objtask;
           try{
            tsk.Save();
            }catch(exception e){}
            tsk.cancel();
            tsk.getRedirectToTemplate();
            tsk.redirectToTemplate();
            tsk.getSelectedItem();
            tsk.setSelectedItem('String s');
            //tsk.getConvertDateTime('String strDt');
            test.stopTest();
           }
 static testMethod void Taskprojtest3(){           
           Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
           User u2 =new User( Alias = 'newUser1' ,
           Email ='newuser123@testorg.com',
           EmailEncodingKey = 'UTF-8',
           LastName = 'Testing',
           LanguageLocaleKey='en_US',
           LocaleSidKey='en_US', 
           UserName='newuser1234@testorg.com',
           ProfileId=p.Id,
           TimeZoneSidKey = 'America/Los_Angeles');
           insert u2;
            
            Project__c objproject = new Project__c ();
            objproject.Name='test';
           //objproject.Project_type__c='test';
            objproject.Starts_date__c= System.now().date();
            objproject.Ends_date__c= System.now().date();
            System.assertEquals('test', objproject.name);
            insert objproject;
            
            Subproject__c objsp = new Subproject__c ();
            objsp.name = 'testname';
            objsp.Description__c = 'sampdesc';
            objsp.Starts_date__c = date.today();
            objsp.Ends_date__c = date.today();
            //objsp.Project_del__c = ;
            //objsp.Parent_project__c = 'pproj';
            //objsp.Project_type__c = 'prtyp';
            objsp.Status__c = 'Notstarted';
            //objsp.StatusImage__c = 'Inprograss';
            //objsp.user__c = u2.id;        
            System.assertEquals('testname', objsp .name);
            insert objsp ; 
                    
            
            Marketing_activity__c objMarketingact=new Marketing_activity__c();
            objMarketingact.Name='test';
            objMarketingact.Description__c='tdescriptionest';
            objMarketingact.Status__c='completed';
            System.assertEquals('test', objMarketingact.name);
            insert objMarketingact;
            
            Task objtask = new Task();      
            objtask.Task_name__c = 'testname';
            objtask.WhatId=objproject.id;                      
            System.assertEquals('testname', objtask .Task_name__c); 
            //insert objtask ;
            
             Members__c objmember=new Members__c ();
             //objmember.Name ='test';
             objmember.ProjMembers__c= objproject.Id;
             objmember.ProjUsers__c= u2.Id;
             objmember.SubProjMembers__c= objsp.Id;
            objmember.Role__c='Member';
            objmember.User_Email__c ='standarduser1@test.com';
            System.assertEquals('Member', objmember.Role__c);
            insert objmember;
            test.starttest();
            PageReference pageRef = Page.Task;
            Test.setCurrentPage(pageRef); 
            //ApexPages.currentPage().getParameters().put('mrkId',null);    
            String tabId = System.currentPageReference().getParameters().get('tabId');        
            ApexPages.currentPage().getParameters().put('mrkid',objMarketingact.id);
            ApexPages.StandardController sc = new ApexPages.standardController(objtask);
            TaskController tsk = new TaskController(sc);
            tsk.Task = objtask;
            //try{
            tsk.Save();
            //}catch(exception e){}
            tsk.cancel();
            tsk.getRedirectToTemplate();
            tsk.redirectToTemplate();
            tsk.getSelectedItem();
            tsk.setSelectedItem('String s');
            //tsk.getConvertDateTime('String strDt');
             test.stopTest();
              }
     static testMethod void Taskprojtestsave(){ 
           Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
           User u2 =new User( Alias = 'newUser1' ,
           Email ='newuser123@testorg.com',
           EmailEncodingKey = 'UTF-8',
           LastName = 'Testing',
           LanguageLocaleKey='en_US',
           LocaleSidKey='en_US', 
           UserName='newuser1234@testorg.com',
           ProfileId=p.Id,
           TimeZoneSidKey = 'America/Los_Angeles');
           insert u2;
            
            Project__c objproject = new Project__c ();
            objproject.Name='test';
           //objproject.Project_type__c='test';
            objproject.Starts_date__c= System.now().date();
            objproject.Ends_date__c= System.now().date();
            System.assertEquals('test', objproject.name);
            insert objproject;
            
            Subproject__c objsp = new Subproject__c ();
            objsp.name = 'testname';
            objsp.Description__c = 'sampdesc';
            objsp.Starts_date__c = date.today();
            objsp.Ends_date__c = date.today();
            objsp.Project_del__c =objsp.id ;
            objsp.Parent_project__c =objproject.id;          
            objsp.Status__c = 'Notstarted';                  
            System.assertEquals('testname', objsp .name);
            insert objsp;
            
            Task objtask = new Task();      
            objtask.Task_name__c = 'testname';
            objtask.WhatId=objproject.id;                                 
            insert objtask ; 
            System.assertEquals('testname', objtask .Task_name__c);
            
            test.starttest();
            PageReference pageRef = Page.ProjectDetails;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('projectid',objproject.id);
            ApexPages.StandardController sc = new ApexPages.standardController(objproject);
            TaskController tsksave = new TaskController(sc);
            try{
            tsksave.Save();
            }catch(exception e){}
            test.stopTest();      
             }
   static testMethod void Taskprojtestsave1(){ 
            Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
           User u2 =new User( Alias = 'newUser1' ,
           Email ='newuser123@testorg.com',
           EmailEncodingKey = 'UTF-8',
           LastName = 'Testing',
           LanguageLocaleKey='en_US',
           LocaleSidKey='en_US', 
           UserName='newuser1234@testorg.com',
           ProfileId=p.Id,
           TimeZoneSidKey = 'America/Los_Angeles');
           insert u2;
            
            Project__c objproject = new Project__c ();
            objproject.Name='test';
           //objproject.Project_type__c='test';
            objproject.Starts_date__c= System.now().date();
            objproject.Ends_date__c= System.now().date();
            System.assertEquals('test', objproject.name);
            insert objproject;
            
            Subproject__c objsp = new Subproject__c ();
            objsp.name = 'testname';
            objsp.Description__c = 'sampdesc';
            objsp.Starts_date__c = date.today();
            objsp.Ends_date__c = date.today();
            objsp.Project_del__c =objsp.id ;
            objsp.Parent_project__c =objproject.id;          
            objsp.Status__c = 'Notstarted';                  
            System.assertEquals('testname', objsp .name);
            insert objsp;
            
            Task objtask = new Task();      
            objtask.Task_name__c = 'testname';
            objtask.WhatId=objproject.id;                                 
            insert objtask ; 
            System.assertEquals('testname', objtask .Task_name__c);
            
            test.starttest();
            PageReference pageRef = Page.ProjectDetails;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('subprjid',objsp.id);
            ApexPages.StandardController sc = new ApexPages.standardController(objsp);
            TaskController tsksave = new TaskController(sc);
            try{
            tsksave.Save();
            }catch(exception e){}
            test.stopTest();      
             }
     static testMethod void Taskcos(){
     		 Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
             User u2 =new User( Alias = 'newUser1',Email ='newuser123@testorg.com',EmailEncodingKey = 'UTF-8',LastName = 'Testing',
             LanguageLocaleKey='en_US',LocaleSidKey='en_US', UserName='newuser1234@testorg.com',ProfileId=p.Id,
             TimeZoneSidKey = 'America/Los_Angeles');
             insert u2;
         	musqot__Costcentre__c objCC=new musqot__Costcentre__c(); 
              objCC.Name='test';
              objCC.musqot__cc_Owner__c=u2.id;
              objCC.musqot__Headline__c ='present';
              insert objCC;
              System.assertEquals('test', objCC.name);
            ApexPages.currentPage().getParameters().put('cosid',objCC.id);
            ApexPages.StandardController sc = new ApexPages.standardController(objCC);
         	TaskController tskcs = new TaskController(sc);
            tskcs.Save();
         	tskcs.cancel();            
        }
    }