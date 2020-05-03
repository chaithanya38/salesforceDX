/***********************************************************************
Class Name: tasktablecontrollertest
Author:G Janardhanreddy           Last modified by: Chaithanya daggumati
Date: 29/1/2015                   Date: 19/3/2015 
********©2013 Musqot marketing technology Pvt ltd **********************/
@isTest(SeeAllData = true)   
private class tasktablecontrollertest{
    static testMethod void tasktablecontroller(){
                  
        Project__c objproject = new Project__c ();
        objproject.Name='test';
        objproject.Starts_date__c= System.now().date();
        objproject.Ends_date__c= System.now().date();
        insert objproject;
        System.assertEquals('test', objproject.name);
        
        Account acc = new Account();
        acc.Name = 'test';
        insert acc;
        System.assertEquals('test',acc.Name);
    
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objproject.id;
        attach.contentType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
        System.assertEquals(objproject.id,attach.parentId);
        insert attach; 
        Account acct = new Account(name='test account');
        insert acct;
        
        Contact c = new Contact(AccountId=acct.Id, lastname='testing', firstname='apex');
        insert c;

        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.CreatedById=UserInfo.getUserId();
        objtask.WhatId=objproject.id;
        objtask.ActivityDate =system.toDay()+1;
        objtask.whoid=c.id;  
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        System.assertEquals('Testtask', objtask .Task_name__c); 
        
        test.starttest();
        PageReference pageRef = Page.Musqottasks;
        Test.setCurrentPageReference(pageRef);           
        ApexPages.currentPage().getParameters().put('taskid',objtask.id);
        ApexPages.currentPage().getParameters().put('planid',objproject .id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        tasktablecontroller taskeditcont = new tasktablecontroller(sc);
        taskeditcont.selectedTask='testask';
        taskeditcont.newtaskpage='test';
        //taskeditcont.refreshtask=true;
        taskeditcont.refreshPage=true;
        taskeditcont.planid='test';
        taskeditcont.subpid='test';
        taskeditcont.markid='test';
        taskeditcont.tabInFocus='test';
        //taskeditcont.parenid=true;
        taskeditcont.regionValue='Today';
        taskeditcont.gotoTaskEdit();
        taskeditcont.gotoeditmode();
        taskeditcont.gotoParent();
        taskeditcont.tasklist();
        test.stoptest();
        }
        static testMethod void tasktablecontroller1(){
        Subproject__c objsp = new Subproject__c ();
        objsp.name = 'testname';
        objsp.Description__c = 'sampdesc';
        objsp.Starts_date__c = date.today();
        objsp.Ends_date__c = date.today();
        objsp.Status__c = 'Notstarted';
        System.assertEquals('testname', objsp .name);
        insert objsp ;
        Account acc = new Account();
        acc.Name = 'test';
        System.assertEquals('test',acc.Name);
        insert acc;
        
        Task objtask1 = new Task();      
        objtask1.Task_name__c = 'testname'; 
        objtask1.OwnerId=UserInfo.getUserId();
        objtask1.WhatId=objsp.id;
        objtask1.ActivityDate =system.toDay()-1;
        objtask1.whoid=null;  
        objtask1.Status='Deferred';
        objtask1.Allocated_h__c=2;
        objtask1.Outcome_h__c=2;
        objtask1.Task_description__c='test record';
        objtask1.Task_name__c='emailtest';                     
        insert objtask1 ;
        System.assertEquals('emailtest', objtask1 .Task_name__c); 
        
        test.starttest();      
         PageReference pageRef = Page.Musqottasks;
        Test.setCurrentPageReference(pageRef);            
        ApexPages.currentPage().getParameters().put('taskid',objtask1.id);
        ApexPages.currentPage().getParameters().put('subpid',objsp .id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask1);
        tasktablecontroller taskeditcont1 = new tasktablecontroller(sc);
        taskeditcont1.selectedTask='emailtest';
        taskeditcont1.newtaskpage='test';
        //taskeditcont1.refreshtask=true;
        taskeditcont1.refreshPage=true;
        taskeditcont1.planid='test';
        taskeditcont1.subpid='test';
        taskeditcont1.markid='test';
        taskeditcont1.tabInFocus='test';
        //taskeditcont1.parenid=true;
        taskeditcont1.regionValue='Overdue';

        taskeditcont1.gotoTaskEdit();
        taskeditcont1.gotoeditmode();
        taskeditcont1.gotoParent();
        taskeditcont1.tasklist();
 
        test.stoptest();
        }
        
       static testMethod void tasktablecontroller2(){
        
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact;
        
        Account acc = new Account();
        acc.Name = 'test';
        System.assertEquals('test',acc.Name);
        insert acc;
        
        Task objtask2= new Task();      
        objtask2.Task_name__c = 'testname'; 
        objtask2.OwnerId=UserInfo.getUserId();
        objtask2.WhatId=objMarketingact.id;
        objtask2.ActivityDate =system.toDay();
        objtask2.whoid=null;  
        objtask2.Status='Not started';
        objtask2.Allocated_h__c=2;
        objtask2.Outcome_h__c=2;
        objtask2.Task_description__c='test record';
        objtask2.Task_name__c='emailtest';                     
        insert objtask2;
        System.assertEquals('emailtest', objtask2 .Task_name__c); 
        
        test.starttest();
        PageReference pageRef2 = Page.Task;
        Test.setCurrentPage(pageRef2);            
        ApexPages.currentPage().getParameters().put('taskid',objtask2.id);
        ApexPages.currentPage().getParameters().put('markid',objMarketingact.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask2);
        tasktablecontroller taskeditcont2 = new tasktablecontroller(sc);
        taskeditcont2.selectedTask='test';
        taskeditcont2.newtaskpage='test';
        //taskeditcont2.refreshtask=true;
        taskeditcont2.refreshPage=true;
        taskeditcont2.planid='test';
        taskeditcont2.subpid='test';
        taskeditcont2.markid='test';
        taskeditcont2.tabInFocus='test';
        //taskeditcont2.parenid=true;
        taskeditcont2.regionValue='Today+Overdue';
        taskeditcont2.gotoTaskEdit();
        taskeditcont2.gotoeditmode();
        taskeditcont2.gotoParent();
        taskeditcont2.tasklist();
        test.stoptest();
    }   
 static testMethod void tasktablecontrollertask(){
        
        Account acc = new Account();
        acc.Name = 'test';
        System.assertEquals('test',acc.Name);
        insert acc;
        
        Task objtask3= new Task();      
        objtask3.Task_name__c = 'testname'; 
        objtask3.OwnerId=UserInfo.getUserId();
        objtask3.WhatId=acc.id;
        objtask3.ActivityDate =system.today();
        objtask3.whoid=null;  
        objtask3.Status='Not started';
        objtask3.Allocated_h__c=2;
        objtask3.Outcome_h__c=2;
        objtask3.Task_description__c='test record';
        objtask3.Task_name__c='emailtest';                     
        insert objtask3;
        System.assertEquals('emailtest', objtask3.Task_name__c); 
        
        test.starttest();          
        ApexPages.currentPage().getParameters().put('taskid',objtask3.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask3);
        tasktablecontroller tsktable = new tasktablecontroller(sc);
        tsktable.selectedTask='test';
        tsktable.newtaskpage='test';
        //tsktable.refreshtask=true;
        tsktable.refreshPage=true;
        tsktable.planid='test';
        tsktable.subpid='test';
        tsktable.markid='test';
        tsktable.tabInFocus='test';
        //tsktable.parenid=true;
        tsktable.regionValue='This Month';
        tsktable.gotoTaskEdit();
        tsktable.gotoeditmode();
        tsktable.gotoParent();
        tsktable.tasklist();
        test.stoptest();
    }
    static testMethod void tasktablecontrollertasktest(){
        Account acc = new Account();
        acc.Name = 'test';
        System.assertEquals('test',acc.Name);
        insert acc;
        
        Task objtask4= new Task();      
        objtask4.Task_name__c = 'testname'; 
        objtask4.OwnerId=UserInfo.getUserId();
        objtask4.WhatId=acc.id;
        //objtask4.ActivityDate =system.today();
        objtask4.whoid=null;  
        objtask4.Status='Not started';
        objtask4.Allocated_h__c=2;
        objtask4.Outcome_h__c=2;
        objtask4.Task_description__c='test record';
        objtask4.Task_name__c='emailtest';                     
        insert objtask4;
        System.assertEquals('emailtest', objtask4.Task_name__c); 
        
        test.starttest();          
        ApexPages.currentPage().getParameters().put('taskid',objtask4.id);
        ApexPages.currentPage().getParameters().put('id',acc.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask4);
        tasktablecontroller tsktable = new tasktablecontroller(sc);
        tsktable.selectedTask='test';
        tsktable.newtaskpage='test';
        //tsktable.refreshtask=true;
        tsktable.refreshPage=true;
        tsktable.planid='test';
        tsktable.subpid='test';
        tsktable.markid='test';
        tsktable.tabInFocus='test';
        //tsktable.parenid=true;
        tsktable.regionValue='All Open';
        tsktable.gotoTaskEdit();
        tsktable.gotoeditmode();
        tsktable.gotoParent();
        tsktable.tasklist();
    }
    static testMethod void tasktablecontrollertasktest1(){
        Account acc = new Account();
        acc.Name = 'test';
        System.assertEquals('test',acc.Name);
        insert acc;
        
        Task objtask4= new Task();      
        objtask4.Task_name__c = 'testname'; 
        objtask4.OwnerId=UserInfo.getUserId();
        objtask4.WhatId=acc.id;
        objtask4.ActivityDate =system.today();
        objtask4.whoid=null;  
        objtask4.Status='Not started';
        objtask4.Allocated_h__c=2;
        objtask4.Outcome_h__c=2;
        objtask4.Task_description__c='test record';
        objtask4.Task_name__c='emailtest';                     
        insert objtask4;
        System.assertEquals('emailtest', objtask4.Task_name__c); 
        
        test.starttest();          
        ApexPages.currentPage().getParameters().put('taskid',objtask4.id);
        ApexPages.currentPage().getParameters().put('id',acc.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask4);
        tasktablecontroller tsktable = new tasktablecontroller(sc);
        tsktable.selectedTask='test';
        tsktable.newtaskpage='test';
        //tsktable.refreshtask=true;
        tsktable.refreshPage=true;
        tsktable.planid='test';
        tsktable.subpid='test';
        tsktable.markid='test';
        tsktable.tabInFocus='test';
        //tsktable.parenid=true;
        tsktable.regionValue='Tomorrow';
        tsktable.gotoTaskEdit();
        tsktable.gotoeditmode();
        tsktable.gotoParent();
        tsktable.tasklist();
      test.stoptest();
    }
    static testMethod void tasktablecontrollertasktest2(){
        Account acc = new Account();
        acc.Name = 'test';
        System.assertEquals('test',acc.Name);
        insert acc;
        
        Task objtask4= new Task();      
        objtask4.Task_name__c = 'testname'; 
        objtask4.OwnerId=UserInfo.getUserId();
        objtask4.WhatId=acc.id;
        objtask4.ActivityDate =system.today();
        objtask4.whoid=null;  
        objtask4.Status='Not started';
        objtask4.Allocated_h__c=2;
        objtask4.Outcome_h__c=2;
        objtask4.Task_description__c='test record';
        objtask4.Task_name__c='emailtest';                     
        insert objtask4;
        System.assertEquals('emailtest', objtask4.Task_name__c); 
        
        test.starttest();          
        ApexPages.currentPage().getParameters().put('taskid',objtask4.id);
        ApexPages.currentPage().getParameters().put('id',acc.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask4);
        tasktablecontroller tsktable = new tasktablecontroller(sc);
        tsktable.selectedTask='test';
        tsktable.newtaskpage='test';
        //tsktable.refreshtask=true;
        tsktable.refreshPage=true;
        tsktable.planid='test';
        tsktable.subpid='test';
        tsktable.markid='test';
        tsktable.tabInFocus='test';
        //tsktable.parenid=true;
        tsktable.regionValue='Next 7 Days';
        tsktable.gotoTaskEdit();
        tsktable.gotoeditmode();
        tsktable.gotoParent();
        tsktable.tasklist();
      test.stoptest();
    }
    static testMethod void tasktablecontrollertasktest3(){
        Account acc = new Account();
        acc.Name = 'test';
        System.assertEquals('test',acc.Name);
        insert acc;
        
        Task objtask4= new Task();      
        objtask4.Task_name__c = 'testname'; 
        objtask4.OwnerId=UserInfo.getUserId();
        objtask4.WhatId=acc.id;
        objtask4.ActivityDate =system.today()+10;
        objtask4.whoid=null;  
        objtask4.Status='Not started';
        objtask4.Allocated_h__c=2;
        objtask4.Outcome_h__c=2;
        objtask4.Task_description__c='test record';
        objtask4.Task_name__c='emailtest';                     
        insert objtask4;
        System.assertEquals('emailtest', objtask4.Task_name__c); 
        
        test.starttest();          
        ApexPages.currentPage().getParameters().put('taskid',objtask4.id);
        ApexPages.currentPage().getParameters().put('id',acc.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask4);
        tasktablecontroller tsktable = new tasktablecontroller(sc);
        tsktable.selectedTask='test';
        list<Task>  tem2=tsktable.Task;
        tsktable.newtaskpage='test';
        //tsktable.refreshtask=true;
        tsktable.refreshPage=true;
        tsktable.planid='test';
        tsktable.subpid='test';
        tsktable.markid='test';
        tsktable.tabInFocus='test';
        //tsktable.parenid=true;
        tsktable.regionValue='Next 7 Days+Overdue';
        tsktable.gotoTaskEdit();
        tsktable.gotoeditmode();
        tsktable.gotoParent();
        tsktable.tasklist();
      test.stoptest();
    }                                                      
   static testMethod void taskcomplete(){
        Account acc = new Account();
        acc.Name = 'test';
        System.assertEquals('test',acc.Name);
        insert acc;
        
        Task objtask4= new Task();      
        objtask4.Task_name__c = 'testname'; 
        objtask4.OwnerId=UserInfo.getUserId();
        objtask4.WhatId=acc.id;
        objtask4.ActivityDate =system.today();
        objtask4.whoid=null;  
        objtask4.Status='Completed';
        objtask4.Allocated_h__c=2;
        objtask4.Outcome_h__c=2;
        objtask4.Task_description__c='test record';
        objtask4.Task_name__c='emailtest';                     
        insert objtask4;
        System.assertEquals('emailtest', objtask4.Task_name__c); 
        
        test.starttest();          
        ApexPages.currentPage().getParameters().put('taskid',objtask4.id);
        ApexPages.currentPage().getParameters().put('id',acc.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask4);
        tasktablecontroller tsktable = new tasktablecontroller(sc);        
        tsktable.regionValue='Completed';
        tsktable.tasklist();
        test.stoptest();
    }     
}