@isTest(seeAllData=true)
    public class Trigger_Task_Emailtests{
           static testMethod void TaskController(){ 
           Profile p=[SELECT Id From Profile WHERE Name='System Administrator'];
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
            
            Task objtask = new Task();      
            objtask.Task_name__c = 'testname'; 
            objtask.OwnerId=u2.id;
            objtask.musqot__sendEmail__c=true;
            objtask.WhatId=objproject.id;
            objtask.ActivityDate =system.toDay();
            objtask.Status='Deferred';
            objtask.Allocated_h__c=2;
            objtask.Outcome_h__c=2;
            objtask.Task_description__c='test record';
            objtask.Task_name__c='Testtask';                     
            insert objtask ;
        System.assertEquals('Testtask', objtask .Task_name__c); 
        
     }
      static testMethod void TaskController1(){
            
           Profile p=[SELECT Id From Profile WHERE Name='System Administrator'];
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
            objsp.Ends_date__c = date.today()+10;
            //objsp.Project_del__c = objspr.id;
            objsp.Parent_project__c = objproject.id;
            objsp.Status__c = 'Notstarted';
           //objsp.user__c = u2.id;        
            System.assertEquals('testname', objsp .name);
            insert objsp ; 
            
            Task objtask = new Task();      
            objtask.Task_name__c = 'testname'; 
            objtask.OwnerId=u2.id;
            objtask.WhatId=objsp.id;
            objtask.musqot__sendEmail__c=true;
            objtask.ActivityDate =system.toDay();
            objtask.Status='Deferred';
            objtask.Allocated_h__c=2;
            objtask.Outcome_h__c=2;
            objtask.Task_description__c='test record';
            objtask.Task_name__c='Testtask';                     
            insert objtask ;
        System.assertEquals('Testtask', objtask .Task_name__c); 
     }
      static testMethod void TaskController2(){
            
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
            objMarketingact.musqot__Project__c=objsp.id;
            System.assertEquals('test', objMarketingact.name);
            insert objMarketingact;
            
            Task objtask = new Task();      
            objtask.Task_name__c = 'testname'; 
            objtask.OwnerId=u2.id;
            objtask.WhatId=objMarketingact.id;
            objtask.ActivityDate =system.toDay();
            objtask.Status='Deferred';
            objtask.Allocated_h__c=2;
            objtask.Outcome_h__c=2;
            objtask.musqot__sendEmail__c=true;
            objtask.Task_description__c='test record';
            objtask.Task_name__c='Testtask';                     
            insert objtask ;
        System.assertEquals('Testtask', objtask .Task_name__c); 
      
     }
     static testMethod void TaskController3(){
            
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
            objMarketingact.musqot__Project__c=objsp.id;
            System.assertEquals('test', objMarketingact.name);
            insert objMarketingact;
            
            Task objtask = new Task();      
            objtask.Task_name__c = 'testname'; 
            objtask.OwnerId=u2.id;
            objtask.WhatId=objMarketingact.id;
            //objtask.ActivityDate =system.toDay();
            objtask.Status='Deferred';
            objtask.Allocated_h__c=2;
            objtask.Outcome_h__c=2;
            objtask.musqot__sendEmail__c=true;
            objtask.Task_description__c='test record';
            objtask.Task_name__c='Testtask';                     
            insert objtask ;
        System.assertEquals('Testtask', objtask .Task_name__c); 
      
     }

 }