@isTest(seeAllData=true)
public class Resource_report_CtrlTest{
     static testMethod void taskJobReportCtrl (){
     Profile p=[SELECT Id From Profile WHERE Name='System Administrator'];
           List<User> testuser = new List<User>();
           User u2 =new User( Alias = 'gnraju' ,
           Email ='nagaraju@musqot.com',
           Department = 'test',
           Title = 'test',
           EmployeeNumber = 'test',
           EmailEncodingKey = 'UTF-8',
           LastName = 'Testing',
           LanguageLocaleKey='en_US',
           LocaleSidKey='en_US', 
           UserName='gnraju1@musqot.com',
           ProfileId=p.Id,
           TimeZoneSidKey = 'America/Los_Angeles');
           insert u2;
           System.assertEquals('test', u2.Department);
           System.RunAs(u2){
        
           Group gr = new Group();
           gr.Name = 'All group';
           gr.DeveloperName = 'test';
           gr.Type = 'Regular';
           insert gr;
           System.assertEquals('All group', gr.Name);
    
           List<GroupMember> gmr = new List<GroupMember>();
           GroupMember gpm = new GroupMember();
           gpm.GroupId = gr.Id;
           gpm.UserOrGroupId = u2.Id;
           insert gpm;
           System.assertEquals(gr.Id, gpm.GroupId);           
           List<GroupMember>gml=[SELECT Id, GroupId, UserOrGroupId FROM GroupMember];
             
           Project__c objproject = new Project__c ();
           objproject.Name='test';
           objproject.Starts_date__c= System.now().date();
           objproject.Ends_date__c= System.now().date(); 
           insert objproject;                                          
           System.assertEquals('test', objproject.name);
            
            Task objtask = new Task();      
            objtask.Task_name__c = 'testname'; 
            objtask.WhatId=objproject.id;    
            objtask.musqot__sendEmail__c=true; 
            objtask.ActivityDate=system.today();
            objtask.musqot__Allocated_h__c=10;
            objtask.musqot__Outcome_h__c=10;
            objtask.ActivityDate= system.today();
            objtask.Status='In progress';
            objtask.musqot__Status_image_id__c='testimg';
            objtask.musqot__Task_description__c='testdesc';
            objtask.OwnerId= u2.id;                              
            insert objtask;
            System.assertEquals('testname', objtask .Task_name__c); 
           
           List<GroupMember> gm = new List<GroupMember> ();
           for(GroupMember g:gm){
               g.UserOrGroupId=gpm.id;               
           } 
           Test.startTest();
           PageReference pageRef = Page.Resource_report_page;
           Test.setCurrentPage(pageRef);
           ApexPages.currentPage().getParameters().put('id',objtask.id);
           ApexPages.currentPage().getParameters().put('id',gr.id);
           Resource_report_Ctrl taskjob=new Resource_report_Ctrl();
           Resource_report_Ctrl.Resources res=new Resource_report_Ctrl.Resources(); 

           List<Task> temp11=taskjob.taskUserList1;
           list<SelectOption> temp=taskjob.getItems();
           List<SelectOption> temp1=taskjob.groupList;
             taskjob.FocusA=true;
             taskjob.FocusB=true;
             taskjob.FocusL=true;
             taskjob.FocusWeek='test';
             taskjob.selectedStatus='open';
             //taskjob.selectedGroup='Musqotreportuser';
             taskjob.selectedGroup='All group';
             List<User> temp2=taskjob.UserList1;           
             taskjob.startDat=date.today(); 
             taskjob.sDateA=date.today();
             taskjob.eDateA=date.today()+7;
              GROUP grpId= [SELECT Id,Name FROM Group WHERE id=:gr.id limit 1];      
             //try{                    
             taskjob.getres();  
             //}catch(exception e){}           
             res.rUsername='test';
             res.rTitle='developer';
             res.rDepartment='it';
             res.rEmpNr='1005';
             res.rManager='pm';
             res.rGroup='All group';
             res.rWeekA=0.2;
             res.rWeekB=0.2;
             res.rWeekC=0.2;
             res.rWeekD=0.2;
             res.rWeekE=0.2;
             res.rWeekF=0.2;
             res.rWeekG=0.2;
             res.rWeekH=0.2;
             res.rWeekI=0.2;
             res.rWeekJ=0.2;
             res.rWeekK=0.2;
             res.rWeekL=0.2;
            Test.stopTest();
         }
     }  
     static testMethod void taskJobReportCtrl1(){
     Profile p=[SELECT Id From Profile WHERE Name='System Administrator'];
           List<User> testuser = new List<User>();
           User u2 =new User( Alias = 'gnraju' ,
           Email ='nagaraju@musqot.com',
           Department = 'test',
           Title = 'test',
           EmployeeNumber = 'test',
           EmailEncodingKey = 'UTF-8',
           LastName = 'Testing',
           LanguageLocaleKey='en_US',
           LocaleSidKey='en_US', 
           UserName='gnraju1@musqot.com',
           ProfileId=p.Id,
           TimeZoneSidKey = 'America/Los_Angeles');
           insert u2;
           System.assertEquals('test', u2.Department);
           System.RunAs(u2){
           
           Group gr = new Group();
           gr.Name = 'Musqot User group';
           gr.DeveloperName = 'test';
           gr.Type = 'Regular';
           insert gr;
           System.assertEquals('Musqot User group', gr.Name);
    
           List<GroupMember> gmr = new List<GroupMember>();
           GroupMember gpm = new GroupMember();
           gpm.GroupId = gr.Id;
           gpm.UserOrGroupId = u2.Id;
           insert gpm;
           System.assertEquals(gr.Id, gpm.GroupId);           
           List<GroupMember>gml=[SELECT Id, GroupId, UserOrGroupId FROM GroupMember];
             
           Project__c objproject = new Project__c ();
           objproject.Name='test';
           objproject.Starts_date__c= System.now().date();
           objproject.Ends_date__c= System.now().date(); 
           insert objproject;                                          
           System.assertEquals('test', objproject.name);
            
            Task objtask = new Task();      
            objtask.Task_name__c = 'testname'; 
            objtask.WhatId=objproject.id;    
            objtask.musqot__sendEmail__c=true; 
            objtask.ActivityDate=system.today();
            objtask.musqot__Allocated_h__c=10;
            objtask.musqot__Outcome_h__c=10;
            objtask.ActivityDate= system.today();
            objtask.Status='Notstarted';
            objtask.musqot__Status_image_id__c='testimg';
            objtask.musqot__Task_description__c='testdesc';
            objtask.OwnerId= gpm.UserOrGroupId;                              
            insert objtask;
           System.assertEquals('testname', objtask .Task_name__c); 
           List<GroupMember> gm = new List<GroupMember> ();
          
           Test.startTest();
           PageReference pageRef = Page.Resource_report_page;
           Test.setCurrentPage(pageRef);
           
           ApexPages.currentPage().getParameters().put('id',objtask.id);
           ApexPages.currentPage().getParameters().put('id',gr.id);
           Resource_report_Ctrl taskjob=new Resource_report_Ctrl();
           Resource_report_Ctrl.Resources res=new Resource_report_Ctrl.Resources(); 
           List<Task> temp11=taskjob.taskUserList1;
           list<SelectOption> temp=taskjob.getItems();
           List<SelectOption> temp1=taskjob.groupList;
         taskjob.FocusA=true;
         taskjob.FocusB=true;
         taskjob.FocusL=true;
         taskjob.FocusWeek='test';
         taskjob.selectedStatus='Inprogress';
         taskjob.selectedGroup='Musqot Report Users';
          GROUP grpId= [SELECT Id,Name FROM Group WHERe id=:gr.id  limit 1];  
         //taskjob.selectedGroup='All group';
         List<User> temp2=taskjob.UserList1;           
         taskjob.startDat=date.today();   
         taskjob.sDateA =date.today()+70;  
         try{                    
         taskjob.getres();  
         }catch(exception e){}     
         res.rUsername='test';
         res.rTitle='developer';
         res.rDepartment='it';
         res.rEmpNr='1005';
         res.rManager='pm';
         res.rGroup='Musqot Report Users';
         res.rWeekA=0.2;
         res.rWeekB=0.2;
         res.rWeekC=0.2;
         res.rWeekD=0.2;
         res.rWeekE=0.2;
         res.rWeekF=0.2;
         res.rWeekG=0.2;
         res.rWeekH=0.2;
         res.rWeekI=0.2;
         res.rWeekJ=0.2;
         res.rWeekK=0.2;
         res.rWeekL=0.2;
         Test.stopTest();
         }
     }
     static testMethod void taskJobReportCtrl2(){
     Profile p=[SELECT Id From Profile WHERE Name='System Administrator'];
           List<User> testuser = new List<User>();
           User u2 =new User( Alias = 'gnraju' ,
           Email ='nagaraju@musqot.com',
           Department = 'test',
           Title = 'test',
           EmployeeNumber = 'test',
           EmailEncodingKey = 'UTF-8',
           LastName = 'Testing',
           LanguageLocaleKey='en_US',
           LocaleSidKey='en_US', 
           UserName='gnraju1@musqot.com',
           ProfileId=p.Id,
           TimeZoneSidKey = 'America/Los_Angeles');
           insert u2;
           System.assertEquals('test', u2.Department);
           System.RunAs(u2){
           
           Group gr = new Group();
           gr.Name = 'All group';
           gr.DeveloperName = 'test';
           gr.Type = 'Regular';
           insert gr;
           System.assertEquals('All group', gr.Name);
    
           List<GroupMember> gmr = new List<GroupMember>();
           GroupMember gpm = new GroupMember();
           gpm.GroupId = gr.Id;
           gpm.UserOrGroupId = u2.Id;
           insert gpm;
           System.assertEquals(gr.Id, gpm.GroupId);           
           List<GroupMember>gml=[SELECT Id, GroupId, UserOrGroupId FROM GroupMember];
             
           Project__c objproject = new Project__c ();
           objproject.Name='test';
           objproject.Starts_date__c= System.now().date();
           objproject.Ends_date__c= System.now().date(); 
           insert objproject;                                          
           System.assertEquals('test', objproject.name);
            
            Task objtask = new Task();      
            objtask.Task_name__c = 'testname'; 
            objtask.WhatId=objproject.id;    
            objtask.musqot__sendEmail__c=true; 
            objtask.ActivityDate=system.today();
            objtask.musqot__Allocated_h__c=10;
            objtask.musqot__Outcome_h__c=10;
            objtask.ActivityDate= system.today();
            objtask.Status='Notstarted';
            objtask.musqot__Status_image_id__c='testimg';
            objtask.musqot__Task_description__c='testdesc';
            objtask.OwnerId= gpm.UserOrGroupId;                              
            insert objtask;
            System.assertEquals('testname', objtask .Task_name__c); 
            List<GroupMember> gm = new List<GroupMember> ();
          
           Test.startTest();
           PageReference pageRef = Page.Resource_report_page;
           Test.setCurrentPage(pageRef);
           
           ApexPages.currentPage().getParameters().put('id',objtask.id);
           ApexPages.currentPage().getParameters().put('id',gr.id);
           Resource_report_Ctrl taskjob=new Resource_report_Ctrl();
           Resource_report_Ctrl.Resources res=new Resource_report_Ctrl.Resources(); 
            List<Task> temp11=taskjob.taskUserList1;
            list<SelectOption> temp=taskjob.getItems();
            List<SelectOption> temp1=taskjob.groupList;
             taskjob.FocusA=true;
             taskjob.FocusB=true;
             taskjob.FocusL=true;
             taskjob.FocusWeek='test';
             taskjob.selectedStatus='Inprogress';
             //taskjob.selectedGroup='All group';
             List<User> temp2=taskjob.UserList1;           
             taskjob.startDat=date.today();   
             taskjob.sDateA =date.today()-70;  
             taskjob.getres();   
             res.rUsername='test';
             res.rTitle='developer';
             res.rDepartment='it';
             res.rEmpNr='1005';
             res.rManager='pm';
             res.rGroup='Musqot Report Users';
             res.rWeekA=0.2;
             res.rWeekB=0.2;
             res.rWeekC=0.2;
             res.rWeekD=0.2;
             res.rWeekE=0.2;
             res.rWeekF=0.2;
             res.rWeekG=0.2;
             res.rWeekH=0.2;
             res.rWeekI=0.2;
             res.rWeekJ=0.2;
             res.rWeekK=0.2;
             res.rWeekL=0.2;
            Test.stopTest();
         }
     }  
     static testMethod void taskJobReportCtrl3(){
     Profile p=[SELECT Id From Profile WHERE Name='System Administrator'];
           List<User> testuser = new List<User>();
           User u2 =new User( Alias = 'gnraju' ,
           Email ='nagaraju@musqot.com',
           Department = 'test',
           Title = 'test',
           EmployeeNumber = 'test',
           EmailEncodingKey = 'UTF-8',
           LastName = 'Testing',
           LanguageLocaleKey='en_US',
           LocaleSidKey='en_US', 
           UserName='gnraju1@musqot.com',
           ProfileId=p.Id,
           TimeZoneSidKey = 'America/Los_Angeles');
           insert u2;
           System.assertEquals('test', u2.Department);
           System.RunAs(u2){
           
           Group gr = new Group();
           gr.Name = 'All group';
           gr.DeveloperName = 'test';
           gr.Type = 'Regular';
           insert gr;
           System.assertEquals('All group', gr.Name);
    
           List<GroupMember> gmr = new List<GroupMember>();
           GroupMember gpm = new GroupMember();
           gpm.GroupId = gr.Id;
           gpm.UserOrGroupId = u2.Id;
           insert gpm;
           System.assertEquals(gr.Id, gpm.GroupId);           
           List<GroupMember>gml=[SELECT Id, GroupId, UserOrGroupId FROM GroupMember];
             
           Project__c objproject = new Project__c ();
           objproject.Name='test';
           objproject.Starts_date__c= System.now().date();
           objproject.Ends_date__c= System.now().date(); 
           insert objproject;                                          
           System.assertEquals('test', objproject.name);
            
            Task objtask = new Task();      
            objtask.Task_name__c = 'testname'; 
            objtask.WhatId=objproject.id;    
            objtask.musqot__sendEmail__c=true; 
            objtask.ActivityDate=system.today();
            objtask.musqot__Allocated_h__c=10;
            objtask.musqot__Outcome_h__c=10;
            objtask.ActivityDate= system.today();
            objtask.Status='Notstarted';
            objtask.musqot__Status_image_id__c='testimg';
            objtask.musqot__Task_description__c='testdesc';
            objtask.OwnerId= gpm.UserOrGroupId;                              
            insert objtask;
           System.assertEquals('testname', objtask .Task_name__c); 
           List<GroupMember> gm = new List<GroupMember> ();
          
           Test.startTest();
           PageReference pageRef = Page.Resource_report_page;
           Test.setCurrentPage(pageRef);
           
           ApexPages.currentPage().getParameters().put('id',objtask.id);
           ApexPages.currentPage().getParameters().put('id',gr.id);
           Resource_report_Ctrl taskjob=new Resource_report_Ctrl();
           Resource_report_Ctrl.Resources res=new Resource_report_Ctrl.Resources(); 
            List<Task> temp11=taskjob.taskUserList1;
            list<SelectOption> temp=taskjob.getItems();
            List<SelectOption> temp1=taskjob.groupList;
             taskjob.FocusA=true;
             taskjob.FocusB=true;
             taskjob.FocusL=true;
             taskjob.FocusWeek='test';
             taskjob.selectedStatus='open';
             taskjob.selectedGroup='All group';
             List<User> temp2=taskjob.UserList1;           
             taskjob.startDat=date.today();   
             taskjob.sDateA =date.today()-70;  
             taskjob.getres();   
             res.rUsername='test';
             res.rTitle='developer';
             res.rDepartment='it';
             res.rEmpNr='1005';
             res.rManager='pm';
             res.rGroup='Musqot Report Users';
             res.rWeekA=0.2;
             res.rWeekB=0.2;
             res.rWeekC=0.2;
             res.rWeekD=0.2;
             res.rWeekE=0.2;
             res.rWeekF=0.2;
             res.rWeekG=0.2;
             res.rWeekH=0.2;
             res.rWeekI=0.2;
             res.rWeekJ=0.2;
             res.rWeekK=0.2;
             res.rWeekL=0.2;
            Test.stopTest();
         }
     }  
     static testMethod void taskJobReportCtrl4(){
     Profile p=[SELECT Id From Profile WHERE Name='System Administrator'];
           List<User> testuser = new List<User>();
           User u2 =new User( Alias = 'gnraju' ,
           Email ='nagaraju@musqot.com',
           Department = 'test',
           Title = 'test',
           EmployeeNumber = 'test',
           EmailEncodingKey = 'UTF-8',
           LastName = 'Testing',
           LanguageLocaleKey='en_US',
           LocaleSidKey='en_US', 
           UserName='gnraju1@musqot.com',
           ProfileId=p.Id,
           TimeZoneSidKey = 'America/Los_Angeles');
           insert u2;
           System.assertEquals('test', u2.Department);
           System.RunAs(u2){
           
           Group gr = new Group();
           gr.Name = 'Musqot Report Users';
           gr.DeveloperName = 'test';
           gr.Type = 'Regular';
           insert gr;
           System.assertEquals('Musqot Report Users', gr.Name);
    
           List<GroupMember> gmr = new List<GroupMember>();
           GroupMember gpm = new GroupMember();
           gpm.GroupId = gr.Id;
           gpm.UserOrGroupId = u2.Id;
           insert gpm;
           System.assertEquals(gr.Id, gpm.GroupId);           
           List<GroupMember>gml=[SELECT Id, GroupId, UserOrGroupId FROM GroupMember];
             
           Project__c objproject = new Project__c ();
           objproject.Name='test';
           objproject.Starts_date__c= System.now().date();
           objproject.Ends_date__c= System.now().date(); 
           insert objproject;                                          
           System.assertEquals('test', objproject.name);
            
            Task objtask = new Task();      
            objtask.Task_name__c = 'testname'; 
            objtask.WhatId=objproject.id;    
            objtask.musqot__sendEmail__c=true; 
            objtask.ActivityDate=system.today();
            objtask.musqot__Allocated_h__c=10;
            objtask.musqot__Outcome_h__c=10;
            objtask.ActivityDate= system.today();
            objtask.Status='Not Started';
            objtask.musqot__Status_image_id__c='testimg';
            objtask.musqot__Task_description__c='testdesc';
            objtask.OwnerId= gpm.UserOrGroupId;                              
            insert objtask;
           System.assertEquals('testname', objtask .Task_name__c); 
           List<GroupMember> gm = new List<GroupMember> ();
          
           Test.startTest();
           PageReference pageRef = Page.Resource_report_page;
           Test.setCurrentPage(pageRef);
           
           ApexPages.currentPage().getParameters().put('id',objtask.id);
           Resource_report_Ctrl taskjob=new Resource_report_Ctrl();
           Resource_report_Ctrl.Resources res=new Resource_report_Ctrl.Resources(); 
            List<Task> temp11=taskjob.taskUserList1;
            list<SelectOption> temp=taskjob.getItems();
            List<SelectOption> temp1=taskjob.groupList;
             taskjob.FocusA=true;
             taskjob.FocusB=true;
             taskjob.FocusL=true;
             taskjob.FocusWeek='test';
             taskjob.selectedStatus='Not Started';
             taskjob.selectedGroup='Musqot Report Users';
             List<User> temp2=taskjob.UserList1;           
             taskjob.startDat=date.today();   
             taskjob.sDateA =date.today()-70;  
             taskjob.getres();   
             res.rUsername='test';
             res.rTitle='developer';
             res.rDepartment='it';
             res.rEmpNr='1005';
             res.rManager='pm';
             res.rGroup='Musqot Report Users';
             res.rWeekA=0.2;
             res.rWeekB=0.2;
             res.rWeekC=0.2;
             res.rWeekD=0.2;
             res.rWeekE=0.2;
             res.rWeekF=0.2;
             res.rWeekG=0.2;
             res.rWeekH=0.2;
             res.rWeekI=0.2;
             res.rWeekJ=0.2;
             res.rWeekK=0.2;
             res.rWeekL=0.2;
             Test.stopTest();
         }
     }  
       static testMethod void taskJobReportCtrl5(){
     Profile p=[SELECT Id From Profile WHERE Name='System Administrator'];
           List<User> testuser = new List<User>();
           User u2 =new User( Alias = 'gnraju' ,
           Email ='nagaraju@musqot.com',
           Department = 'test',
           Title = 'test',
           EmployeeNumber = 'test',
           EmailEncodingKey = 'UTF-8',
           LastName = 'Testing',
           LanguageLocaleKey='en_US',
           LocaleSidKey='en_US', 
           UserName='gnraju1@musqot.com',
           ProfileId=p.Id,
           TimeZoneSidKey = 'America/Los_Angeles');
           insert u2;
           System.assertEquals('test', u2.Department);
           System.RunAs(u2){
           
           Group gr = new Group();
           gr.Name = 'Musqot Report Users';
           gr.DeveloperName = 'test';
           gr.Type = 'Regular';
           insert gr;
           System.assertEquals('Musqot Report Users', gr.Name);
    
           List<GroupMember> gmr = new List<GroupMember>();
           GroupMember gpm = new GroupMember();
           gpm.GroupId = gr.Id;
           gpm.UserOrGroupId = u2.Id;
           insert gpm;
           System.assertEquals(gr.Id, gpm.GroupId);           
           List<GroupMember>gml=[SELECT Id, GroupId, UserOrGroupId FROM GroupMember];
             
           Project__c objproject = new Project__c ();
           objproject.Name='test';
           objproject.Starts_date__c= System.now().date();
           objproject.Ends_date__c= System.now().date(); 
           insert objproject;                                          
           System.assertEquals('test', objproject.name);
            
            Task objtask = new Task();      
            objtask.Task_name__c = 'testname'; 
            objtask.WhatId=objproject.id;    
            objtask.musqot__sendEmail__c=true; 
            objtask.ActivityDate=system.today();
            objtask.musqot__Allocated_h__c=10;
            objtask.musqot__Outcome_h__c=10;
            objtask.ActivityDate= system.today();
            objtask.Status='In Progress';
            objtask.musqot__Status_image_id__c='testimg';
            objtask.musqot__Task_description__c='testdesc';
            objtask.OwnerId= gpm.UserOrGroupId;                              
            insert objtask;
           System.assertEquals('testname', objtask .Task_name__c); 
           List<GroupMember> gm = new List<GroupMember> ();
          
           Test.startTest();
           PageReference pageRef = Page.Resource_report_page;
           Test.setCurrentPage(pageRef);
           
           ApexPages.currentPage().getParameters().put('id',objtask.id);
           Resource_report_Ctrl taskjob=new Resource_report_Ctrl();
           Resource_report_Ctrl.Resources res=new Resource_report_Ctrl.Resources(); 
            List<Task> temp11=taskjob.taskUserList1;
            list<SelectOption> temp=taskjob.getItems();
            List<SelectOption> temp1=taskjob.groupList;
             taskjob.FocusA=true;
             taskjob.FocusB=true;
             taskjob.FocusL=true;
             taskjob.FocusWeek='test';
             taskjob.selectedStatus='In Progress';
             taskjob.selectedGroup='Musqot Report Users';
             List<User> temp2=taskjob.UserList1;           
             taskjob.startDat=date.today();   
             taskjob.sDateA =date.today()-70;  
             taskjob.getres();   
             res.rUsername='test';
             res.rTitle='developer';
             res.rDepartment='it';
             res.rEmpNr='1005';
             res.rManager='pm';
             res.rGroup='Musqot Report Users';
             res.rWeekA=0.2;
             res.rWeekB=0.2;
             res.rWeekC=0.2;
             res.rWeekD=0.2;
             res.rWeekE=0.2;
             res.rWeekF=0.2;
             res.rWeekG=0.2;
             res.rWeekH=0.2;
             res.rWeekI=0.2;
             res.rWeekJ=0.2;
             res.rWeekK=0.2;
             res.rWeekL=0.2;
             Test.stopTest();
         }
     } 
        static testMethod void taskJobReportCtrl6(){
         Profile p=[SELECT Id From Profile WHERE Name='System Administrator'];
           List<User> testuser = new List<User>();
           User u2 =new User( Alias = 'gnraju' ,
           Email ='nagaraju@musqot.com',
           Department = 'test',
           Title = 'test',
           EmployeeNumber = 'test',
           EmailEncodingKey = 'UTF-8',
           LastName = 'Testing',
           LanguageLocaleKey='en_US',
           LocaleSidKey='en_US', 
           UserName='gnraju1@musqot.com',
           ProfileId=p.Id,
           TimeZoneSidKey = 'America/Los_Angeles');
           insert u2;
           System.assertEquals('test', u2.Department);
           System.RunAs(u2){
           
           Group gr = new Group();
           gr.Name = 'Musqot Report Users';
           gr.DeveloperName = 'test';
           gr.Type = 'Regular';
           insert gr;
           System.assertEquals('Musqot Report Users', gr.Name);
    
           List<GroupMember> gmr = new List<GroupMember>();
           GroupMember gpm = new GroupMember();
           gpm.GroupId = gr.Id;
           gpm.UserOrGroupId = u2.Id;
           insert gpm;
           System.assertEquals(gr.Id, gpm.GroupId);           
           List<GroupMember>gml=[SELECT Id, GroupId, UserOrGroupId FROM GroupMember];
             
           Project__c objproject = new Project__c ();
           objproject.Name='test';
           objproject.Starts_date__c= System.now().date();
           objproject.Ends_date__c= System.now().date(); 
           insert objproject;                                          
           System.assertEquals('test', objproject.name);
            
            Task objtask = new Task();      
            objtask.Task_name__c = 'testname'; 
            objtask.WhatId=objproject.id;    
            objtask.musqot__sendEmail__c=true; 
            objtask.ActivityDate=system.today();
            objtask.musqot__Allocated_h__c=10;
            objtask.musqot__Outcome_h__c=10;
            objtask.ActivityDate= system.today();
            objtask.Status='Open';
            objtask.musqot__Status_image_id__c='testimg';
            objtask.musqot__Task_description__c='testdesc';
            objtask.OwnerId= gpm.UserOrGroupId;                              
            insert objtask;
           System.assertEquals('testname', objtask .Task_name__c); 
           List<GroupMember> gm = new List<GroupMember> ();
          
           Test.startTest();
           PageReference pageRef = Page.Resource_report_page;
           Test.setCurrentPage(pageRef);
           
           ApexPages.currentPage().getParameters().put('id',objtask.id);
           Resource_report_Ctrl taskjob=new Resource_report_Ctrl();
           Resource_report_Ctrl.Resources res=new Resource_report_Ctrl.Resources(); 
            List<Task> temp11=taskjob.taskUserList1;
            list<SelectOption> temp=taskjob.getItems();
            List<SelectOption> temp1=taskjob.groupList;
             taskjob.FocusA=true;
             taskjob.FocusB=true;
             taskjob.FocusL=true;
             taskjob.FocusWeek='test';
             taskjob.selectedStatus='Open';
             taskjob.selectedGroup='Musqot Report Users';
             List<User> temp2=taskjob.UserList1;           
             taskjob.startDat=date.today();   
             taskjob.sDateA =date.today()-70;                   
             taskjob.getres();    
             res.rUsername='test';
             res.rTitle='developer';
             res.rDepartment='it';
             res.rEmpNr='1005';
             res.rManager='pm';
             res.rGroup='Musqot Report Users';
             res.rWeekA=0.2;
             res.rWeekB=0.2;
             res.rWeekC=0.2;
             res.rWeekD=0.2;
             res.rWeekE=0.2;
             res.rWeekF=0.2;
             res.rWeekG=0.2;
             res.rWeekH=0.2;
             res.rWeekI=0.2;
             res.rWeekJ=0.2;
             res.rWeekK=0.2;
             res.rWeekL=0.2;
             Test.stopTest();
         }
     } 
     static testMethod void taskJobReportCtrl7(){
         Profile p=[SELECT Id From Profile WHERE Name='System Administrator'];
           List<User> testuser = new List<User>();
           User u2 =new User( Alias = 'gnraju' ,
           Email ='nagaraju@musqot.com',
           Department = 'test',
           Title = 'test',
           EmployeeNumber = 'test',
           EmailEncodingKey = 'UTF-8',
           LastName = 'Testing',
           LanguageLocaleKey='en_US',
           LocaleSidKey='en_US', 
           UserName='gnraju1@musqot.com',
           ProfileId=p.Id,
           TimeZoneSidKey = 'America/Los_Angeles');
           insert u2;
           System.assertEquals('test', u2.Department);
           System.RunAs(u2){
           
           Group gr = new Group();
           gr.Name = 'Musqot Report Users';
           gr.DeveloperName = 'test';
           gr.Type = 'Regular';
           insert gr;
           System.assertEquals('Musqot Report Users', gr.Name);
    
           List<GroupMember> gmr = new List<GroupMember>();
           GroupMember gpm = new GroupMember();
           gpm.GroupId = gr.Id;
           gpm.UserOrGroupId = u2.Id;
           insert gpm;
           System.assertEquals(gr.Id, gpm.GroupId);           
           List<GroupMember>gml=[SELECT Id, GroupId, UserOrGroupId FROM GroupMember];
             
           Project__c objproject = new Project__c ();
           objproject.Name='test';
           objproject.Starts_date__c= System.now().date();
           objproject.Ends_date__c= System.now().date(); 
           insert objproject;                                          
           System.assertEquals('test', objproject.name);
            
            Task objtask = new Task();      
            objtask.Task_name__c = 'testname'; 
            objtask.WhatId=objproject.id;    
            objtask.musqot__sendEmail__c=true; 
            objtask.ActivityDate=system.today();
            objtask.musqot__Allocated_h__c=10;
            objtask.musqot__Outcome_h__c=10;
            objtask.ActivityDate= system.today();
            objtask.Status='Completed';
            objtask.musqot__Status_image_id__c='testimg';
            objtask.musqot__Task_description__c='testdesc';
            objtask.OwnerId= gpm.UserOrGroupId;                              
            insert objtask;
           System.assertEquals('testname', objtask .Task_name__c); 
           List<GroupMember> gm = new List<GroupMember> ();
          
           Test.startTest();
           PageReference pageRef = Page.Resource_report_page;
           Test.setCurrentPage(pageRef);
           
           ApexPages.currentPage().getParameters().put('id',objtask.id);
           Resource_report_Ctrl taskjob=new Resource_report_Ctrl();
           Resource_report_Ctrl.Resources res=new Resource_report_Ctrl.Resources(); 
            List<Task> temp11=taskjob.taskUserList1;
            list<SelectOption> temp=taskjob.getItems();
            List<SelectOption> temp1=taskjob.groupList;
             taskjob.FocusA=true;
             taskjob.FocusB=true;
             taskjob.FocusL=true;
             taskjob.FocusWeek='test';
             taskjob.selectedStatus='Completed';
             taskjob.selectedGroup='Musqot Report Users';
             List<User> temp2=taskjob.UserList1;           
             taskjob.startDat=date.today();   
             taskjob.sDateA =date.today()-70;                   
             taskjob.getres();       
             res.rUsername='test';
             res.rTitle='developer';
             res.rDepartment='it';
             res.rEmpNr='1005';
             res.rManager='pm';
             res.rGroup='Musqot Report Users';
             res.rWeekA=0.2;
             res.rWeekB=0.2;
             res.rWeekC=0.2;
             res.rWeekD=0.2;
             res.rWeekE=0.2;
             res.rWeekF=0.2;
             res.rWeekG=0.2;
             res.rWeekH=0.2;
             res.rWeekI=0.2;
             res.rWeekJ=0.2;
             res.rWeekK=0.2;
             res.rWeekL=0.2;
             Test.stopTest();
         }
     }  
                                 
}