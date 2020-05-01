/****************************************************************
Class Name: taskEditController_Test 
Author:Nagaraju G               Last modified by: G Janardhanreddy
Date: 23/9/2014                 Date: 19/3/2015 
********©2013 Musqot marketing technology Pvt ltd ****************/
@isTest(seealldata=true)  
private class taskEditController_Test{
    static testMethod void TaskEditControllertest(){
        Project__c objproject = new Project__c ();
        objproject.Name='test';
        objproject.OwnerId=Userinfo.getUserId();
        objproject.Starts_date__c= System.now().date();
        objproject.Ends_date__c= System.now().date();
        System.assertEquals('test', objproject.name);
        insert objproject;
        
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        objtask.WhatId=objproject.id;
        objtask.ActivityDate =system.toDay()+1; 
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
        attach.parentId=objtask.id;
        attach.contentType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;

        test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef); 
        ApexPages.currentPage().getParameters().put('planid',objproject.id);           
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('mtaskId',objproject.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.currentPage().getParameters().put('atsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
        musqot__Project__c temp=taskeditcont.plaOwner;
        musqot__Subproject__c temp1=taskeditcont.subOwner;
        musqot__Marketing_activity__c temp21=taskeditcont.mrkOwner;
        musqot__Project__c temp4=taskeditcont.objPrjct;
        musqot__Subproject__c temp5=taskeditcont.sub;
       
        taskeditcont.tsk=objtask;
        taskeditcont.isPlanOwner=true;
        taskeditcont.mTaskId=objproject.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.gotoInputMode();
        taskeditcont.fileType='test';
        taskeditcont.gotoInfoMode();
        try{
        taskeditcont.gotoeditpage();
        }catch(Exception e1){}
        taskeditcont.gotoEditMode();
        try{
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
   }
    
    static testMethod void TaskEditController1(){
        Subproject__c objsp = new Subproject__c ();
        objsp.name = 'testname';
        objsp.Description__c = 'sampdesc';
        
        objsp.Starts_date__c = date.today();
        objsp.Ends_date__c = date.today();
        objsp.OwnerId=Userinfo.getUserId();
        objsp.Status__c = 'Notstarted';
        System.assertEquals('testname', objsp .name);
        insert objsp ; 
    
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        objtask.WhatId=objsp.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
         attach.contentType = 'text/calendar';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;
        
   
        list<Attachment> att=[select id,Name,contentType from Attachment where id=:attach.id limit 1];
         if(att.size()>0){
        delete att;
        }
       test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);            
        ApexPages.currentPage().getParameters().put('subpid',objsp.id);    
        ApexPages.currentPage().getParameters().put('attsid',attach.id);       
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask );
        taskEditController taskeditcont = new taskEditController(sc);
        taskeditcont.tsk=objtask;
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.mTaskId=objsp.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.gotoEditMode();
        taskeditcont.gotoInfoMode();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.getRedirectToTemplate();
        
        try{
         taskeditcont.gotoeditpage();
         taskeditcont.DeleteAttchment();
        }catch(Exception e){  }
        
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
   }
   
    static testMethod void TaskEditController2(){
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        objMarketingact.OwnerId=Userinfo.getUserId();
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact;
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        

        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/x-indesign';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;
                         
        test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        ApexPages.currentPage().getParameters().put('mrkId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('task',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
   } 
     static testMethod void TaskEditController3(){
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact;
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        

        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/vnd.oasis.opendocument.database';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;
                         
        test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        //taskeditcont.fromHomePage='https://eu2.salesforce.com';
        taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
   }  
    static testMethod void TaskEditController4(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        

        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/vnd.oasis.opendocument.formula';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;
                         
        test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
       }
       static testMethod void TaskEditController5(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/vnd.oasis.opendocument.graphics';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;  
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
               
            }
        static testMethod void TaskEditController6(){
               Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/vnd.oasis.opendocument.presentation';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;                 
            }
            static testMethod void TaskEditController7(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/vnd.oasis.opendocument.image';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
             
            }
       static testMethod void TaskEditController8(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/vnd.oasis.opendocument.presentation';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
             
            }
        static testMethod void TaskEditController9(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/vnd.oasis.opendocument.spreadsheet';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
             
            }
        static testMethod void TaskEditController10(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/vnd.oasis.opendocument.text';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
             
            }
       static testMethod void TaskEditController11(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/pdf';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
             
            } 
        static testMethod void TaskEditController12(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/vnd.openxmlformats-officedocument.presentationml.slideshow';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
             
            }
       static testMethod void TaskEditController13(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/vnd.ms-powerpoint';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
             
            }
         static testMethod void TaskEditController14(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
             
            }
              static testMethod void TaskEditController15(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/x-mspublisher';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
             
            }  static testMethod void TaskEditController16(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/vnd.quark';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
             
            }  static testMethod void TaskEditController17(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/x-rar-compressed';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
             
            }
     static testMethod void TaskEditController18(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/vnd.stardivision.draw';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
             
            }
              static testMethod void TaskEditController19(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/vnd.stardivision.calc';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
             
            }
      static testMethod void TaskEditController20(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/vnd.stardivision.impress';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
             
            }
         static testMethod void TaskEditControlle21(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/vnd.stardivision.writer';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
             
            }
            
     static testMethod void TaskEditControll22(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/x-stuffit';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
             
            }
              static testMethod void TaskEditController23(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/vnd.openxmlformats-officedocument.presentationml.slide';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
             
            }
              static testMethod void TaskEditControlle24(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/vnd.stardivision.math';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
             
            }
        static testMethod void TaskEditController25(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/x-shockwave-flash';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
             
            }
              static testMethod void TaskEditController26(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/vnd.sun.xml.calc';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
             
            }
       static testMethod void TaskEditControll27(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/vnd.sun.xml.draw';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
             
            }
           static testMethod void TaskEditController28(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/vnd.sun.xml.impress';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
             
            }
            
         static testMethod void TaskEditController29(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/vnd.sun.xml.math';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
             
            }
             static testMethod void TaskEditController30(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/vnd.sun.xml.writer';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
             
            }
       static testMethod void TaskEditController31(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'text/plain';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
             
            }
    static testMethod void TaskEditController32(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/vnd.ms-wpl';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
             
            }
          static testMethod void TaskEditController33(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/vnd.ms-works';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
             
            }
             static testMethod void TaskEditController34(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/x-mswrite';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
             
            }
             static testMethod void TaskEditController35(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/vnd.ms-excel';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
             
            }
             static testMethod void TaskEditController36(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
             
            }
             static testMethod void TaskEditController37(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/vnd.ms-xpsdocument';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
             
            }
             static testMethod void TaskEditController38(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/zip';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
             
            }
             static testMethod void TaskEditController39(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'audio/';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
             
            }
             static testMethod void TaskEditController40(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'image/';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
             
            }
            
               static testMethod void TaskEditController411(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'video/';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        listtskWrp =taskeditcont.getListWrapper;
        test.stopTest();    
             
            }
             static testMethod void TaskEditController41(){
       
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        //objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Deferred';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        Attachment atts=new Attachment();
       // atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment LIMIT 1];   
       Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'Other';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;    
           test.starttest();
        PageReference pageRef = Page.Taskeditpage;
        Test.setCurrentPage(pageRef);   
        //ApexPages.currentPage().getParameters().put('mTaskId',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('id',objtask.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController taskeditcont = new taskEditController(sc);
          
        taskeditcont.chekE=true;
        taskeditcont.showdel=true;
        taskeditcont.fileType='test';
        taskeditcont.tsk=objtask;
        taskeditcont.fromHomePage='eu2.salesforce.com';
        //taskeditcont.mTaskId=objMarketingact.id;
        taskeditcont.Save();
        taskeditcont.cancel();
        taskeditcont.getRedirectToTemplate();
        taskeditcont.redirectToTemplate();
        taskeditcont.gotoInfoMode();
        
        try{
        taskeditcont.gotoeditpage();
        taskeditcont.gotoEditMode();
        taskeditcont.DeleteAttchment();
        }catch(Exception e){}
        //List<taskEditController.WrapperClass> listtskWrp = new List<taskEditController.WrapperClass>();
        //listtskWrp =taskeditcont.getListWrapper;
        taskEditController.WrapperClass twrap = new taskEditController.WrapperClass();
        //taskEditController.getListWrapper twrap1 = new taskEditController.getListWrapper();
        //WrapperClass.getListWrapper();
        twrap.Description = 'desc';
        twrap.Name = 'gant';
        twrap.Size = 'small';
        twrap.contentType = 'ctype';
        twrap.ownerid = 'owner';
        twrap.CreatedBy = 'cby';
        twrap.fileType = 'file';
        twrap.LastModifiedDate = system.today();
        twrap.isVisible = true;
        test.stopTest();    
             
            }
        static testMethod void TaskEditControllerMytest(){   
        Project__c objproject = new Project__c ();
        objproject.Name='test';
        objproject.OwnerId=Userinfo.getUserId();
        objproject.Starts_date__c= System.now().date();
        objproject.Ends_date__c= System.now().date();
        System.assertEquals('test', objproject.name);
        insert objproject;
                    
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        objtask.WhatId=objproject.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Not started';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;

        ApexPages.currentPage().getParameters().put('planid',objproject.id);
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.currentPage().getParameters().put('taskid',objtask.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController tedit1 = new taskEditController(sc);
        taskEditController.WrapperClass twrap = new taskEditController.WrapperClass();
        twrap.Description = 'desc';
        twrap.Name = 'gant';
        twrap.Size = 'small';
        twrap.contentType = 'ctype';
        twrap.ownerid = 'owner';
        twrap.CreatedBy = 'cby';
        twrap.fileType = 'file';
        twrap.LastModifiedDate = system.today();
        twrap.isVisible = true;
        tedit1.gotoInfoMode();
        tedit1.gotoeditpage();
        tedit1.Save();
        tedit1.cancel();
        
        } 
        static testMethod void TaskEditControllerMytest1(){   
        Project__c objproject = new Project__c ();
        objproject.Name='test';
        objproject.OwnerId=Userinfo.getUserId();
        objproject.Starts_date__c= System.now().date();
        objproject.Ends_date__c= System.now().date();
        System.assertEquals('test', objproject.name);
        insert objproject;
        
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        objMarketingact.OwnerId=Userinfo.getUserId();
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact;
                    
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Not started';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;

        ApexPages.currentPage().getParameters().put('markid',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('ganttid','01rb0000000E6daasdf');
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.currentPage().getParameters().put('taskid',objtask.id);
        ApexPages.currentPage().getParameters().put('fromHome','true');
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController tedit1 = new taskEditController(sc);
        taskEditController.WrapperClass twrap = new taskEditController.WrapperClass();
        twrap.Description = 'desc';
        twrap.Name = 'gant';
        twrap.Size = 'small';
        twrap.contentType = 'ctype';
        twrap.ownerid = 'owner';
        twrap.CreatedBy = 'cby';
        twrap.fileType = 'file';
        tedit1.fromHomePage='true';
        twrap.LastModifiedDate = system.today();
        twrap.isVisible = true;
        tedit1.gotoInfoMode();
        tedit1.gotoeditpage();
        tedit1.Save();
        tedit1.cancel();        
        }
    static testMethod void TaskEditControllerMytest2(){   
        Project__c objproject = new Project__c ();
        objproject.Name='test';
        objproject.OwnerId=Userinfo.getUserId();
        objproject.Starts_date__c= System.now().date();
        objproject.Ends_date__c= System.now().date();
        System.assertEquals('test', objproject.name);
        insert objproject;
        
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        objMarketingact.OwnerId=Userinfo.getUserId();
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact;
                    
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        objtask.WhatId=objMarketingact.id;
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Not started';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;

        ApexPages.currentPage().getParameters().put('markid',objMarketingact.id);
        ApexPages.currentPage().getParameters().put('ganttid','01rb0000000E6daasdf');
        ApexPages.currentPage().getParameters().put('attsid',attach.id);
        ApexPages.currentPage().getParameters().put('taskid',objtask.id);
        ApexPages.currentPage().getParameters().put('fromHome','');
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController tedit1 = new taskEditController(sc);
        taskEditController.WrapperClass twrap = new taskEditController.WrapperClass();
        twrap.Description = 'desc';
        twrap.Name = 'gant';
        twrap.Size = 'small';
        twrap.contentType = 'ctype';
        twrap.ownerid = 'owner';
        twrap.CreatedBy = 'cby';
        twrap.fileType = 'file';
        tedit1.fromHomePage='true';
        twrap.LastModifiedDate = system.today();
        twrap.isVisible = true;
        tedit1.gotoInfoMode();
        tedit1.gotoeditpage();
        tedit1.Save();
        tedit1.cancel();        
        }
   static testMethod void TaskEditControllerMytest3(){
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname'; 
        objtask.OwnerId=UserInfo.getUserId();
        objtask.ActivityDate =system.toDay()+1; 
        objtask.Status='Not started';
        objtask.Allocated_h__c=2;
        objtask.Outcome_h__c=2;
        objtask.Task_description__c='test record';
        objtask.Task_name__c='Testtask';                     
        insert objtask ;
        
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objtask.id;
        attach.contentType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
        System.assertEquals(objtask.id,attach.parentId);
        insert attach;
        
        PageReference pageRef = Page.GanttDetailPage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('ganttdetailId','01rb0000000E6daasdf');
        ApexPages.StandardController sc = new ApexPages.standardController(objtask);
        taskEditController tsedit = new taskEditController(sc);
        tsedit.cancel();  
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
        	Task objtask = new Task();      
            objtask.Task_name__c = 'testname';
            objtask.WhatId=objCC.id;                                 
            insert objtask ; 
            System.assertEquals('testname', objtask .Task_name__c);
            ApexPages.currentPage().getParameters().put('cosid',objCC.id);
            ApexPages.StandardController sc = new ApexPages.standardController(objtask);
         	taskEditController tskcs = new taskEditController(sc);
            tskcs.Save();
         	tskcs.cancel();
        	tskcs.gotoInfoMode();
        }
    static testMethod void Taskuserproject(){
           Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
             User u2 =new User( Alias = 'newUser1',Email ='newuser123@testorg.com',EmailEncodingKey = 'UTF-8',LastName = 'Testing',
             LanguageLocaleKey='en_US',LocaleSidKey='en_US', UserName='newuser1234@testorg.com',ProfileId=p.Id,
             TimeZoneSidKey = 'America/Los_Angeles');
             insert u2;
        	Project__c objproject = new Project__c ();
            objproject.Name='test';
            objproject.OwnerId=Userinfo.getUserId();
            objproject.Starts_date__c= System.now().date();
            objproject.Ends_date__c= System.now().date();
            System.assertEquals('test', objproject.name);
            insert objproject;
        	Task objtask = new Task();      
            objtask.Task_name__c = 'testname';
            objtask.WhatId=objproject.id;                                 
            insert objtask ; 
            System.assertEquals('testname', objtask .Task_name__c);
        	ApexPages.currentPage().getParameters().put('planid',objproject.id);
            ApexPages.StandardController sc = new ApexPages.standardController(objtask);
         	taskEditController tskuserproj = new taskEditController(sc);
        	tskuserproj.isPlanCreatedUser = true;
            tskuserproj.showRec=false;
            tskuserproj.showEdt=true;
            tskuserproj.showEdtbtn=false;
            tskuserproj.editDetail=true;
            tskuserproj.showDetail=false;
    	}
     }