/***********************************************************
Class Name: AttachmentInfoControllerTest
Author:Nagaraju G           Last modified by:G Janardhanreddy
Date: 15/9/2014             Date:18/03/2015
********©2013 Musqot marketing technology Pvt ltd **********/
@isTest(seeAllData=true)
    public class AttachmentInfoControllerTest{
        static testMethod void myAttachmentTest(){
        Profile p = [select id from profile where name='System Administrator']; 
        User objUser = new User(alias = 'stan', email='standarduser@test.com', 
                                emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
                                localesidkey='en_US', profileid = p.Id, 
                                timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
        insert objUser ;  
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=objUser.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c); 
         Project__c prj = new Project__c ();
         prj.Name='ITC';
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c= system.toDay();
         prj.Status__c = 'In Progress';
         prj.ownerid =plm.userid__c;
         System.assertEquals('ITC', prj.name);
         insert prj;
         
        Subproject__c objsubpro=new Subproject__c();
        objsubpro.Name='testsub';
        objsubpro.Starts_date__c=System.now().date();
        objsubpro.Ends_date__c=System.now().date();
        System.assertEquals('testsub', objsubpro.name);
        insert objsubpro;  
         
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact;       
         
         
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=prj.id;
        attach.contentType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
        System.assertEquals(prj.id,attach.parentId);
        insert attach;
               
      Attachment   att=[Select id,Name, Description, Body,BodyLength, 
                OwnerID, CreatedByID, IsPrivate,contentType, 
                ParentId FROM Attachment 
                WHERE id =:attach.id limit 1];
      update att;

        test.startTest();
        ApexPages.currentPage().getParameters().put('atmid',attach.id);  
        ApexPages.StandardController sc = new ApexPages.standardController(attach);
        AttachmentInfoController ATTcontroller= new AttachmentInfoController(sc);
        ATTcontroller.att = attach;
        //ATTcontroller.savedoc();
        ATTcontroller.EditAttachmentPage();
        try{
        ATTcontroller.delDoc();  
        ATTcontroller.FileSizeFunc();
        ATTcontroller.backtoAttinfo();
        }catch(exception e){}
        ATTcontroller.Cancel();        
        AttachmentInfoController.WrapperClass actWrp = new AttachmentInfoController.WrapperClass();
        actWrp.id=attach.id;
        actWrp.Description='TestDescription'; 
        actWrp.Name='testFile';
        actWrp.contentType='text';  
        actWrp.size='55mb';
        test.stopTest();
        }
        
   static testMethod void myAttachmentPrjTest(){
         Profile p = [select id from profile where name='System Administrator']; 
         User objUser = new User(alias = 'stan', email='standarduser@test.com', 
                                emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
                                localesidkey='en_US', profileid = p.Id, 
                                timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
        insert objUser ;  
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=objUser.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
         Project__c prj = new Project__c ();
         prj.Name='ITC';
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c= system.toDay();
         prj.Status__c = 'In Progress';
         prj.ownerid =plm.userid__c;
         System.assertEquals('ITC', prj.name);
         insert prj;
         
        Subproject__c objsubpro=new Subproject__c();
        objsubpro.Name='testsub';
        objsubpro.Starts_date__c=System.now().date();
        objsubpro.Ends_date__c=System.now().date();
        System.assertEquals('testsub', objsubpro.name);
        insert objsubpro;  
         
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact;       

        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=prj.id;
        attach.contentType = 'text/calendar';
        System.assertEquals(prj.id,attach.parentId);
        insert attach;
       
        test.startTest();
        ApexPages.currentPage().getParameters().put('planId',prj.id);  
        ApexPages.currentPage().getParameters().put('attid',attach.id);  
        ApexPages.StandardController sc = new ApexPages.standardController(attach);
        AttachmentInfoController ATTcontroller= new AttachmentInfoController(sc);
        ATTcontroller.att = attach;
        //ATTcontroller.savedoc();
        ATTcontroller.EditAttachmentPage();
        ATTcontroller.delDoc();
        try{
        ATTcontroller.FileSizeFunc();
        ATTcontroller.backtoAttinfo();
        }catch(exception e){}
        ATTcontroller.Cancel();        
        AttachmentInfoController.WrapperClass actWrp = new AttachmentInfoController.WrapperClass();
        actWrp.id=attach.id;
        actWrp.Description='TestDescription'; 
        actWrp.Name='testFile';
        actWrp.contentType='text';  
        actWrp.size='55mb';
        test.stopTest();
    }  
   static testMethod void myAttachmentsubPrjTest(){
         Profile p = [select id from profile where name='System Administrator']; 
         User objUser = new User(alias = 'stan', email='standarduser@test.com', 
                                emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
                                localesidkey='en_US', profileid = p.Id, 
                                timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
        insert objUser ;  
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=objUser.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
         Project__c prj = new Project__c ();
         prj.Name='ITC';
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c= system.toDay();
         prj.Status__c = 'In Progress';
         prj.ownerid =plm.userid__c;
         System.assertEquals('ITC', prj.name);
         insert prj;
         
        Subproject__c objsubpro=new Subproject__c();
        objsubpro.Name='testsub';
        objsubpro.Starts_date__c=System.now().date();
        objsubpro.Ends_date__c=System.now().date();
        System.assertEquals('testsub', objsubpro.name);
        insert objsubpro;  
         
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact;       

        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=prj.id;
        attach.contentType = 'application/x-indesign';
        System.assertEquals(prj.id,attach.parentId);
        insert attach;
        test.startTest();
        ApexPages.currentPage().getParameters().put('subid',objsubpro.id);  
        ApexPages.currentPage().getParameters().put('attid',attach.id);  
        ApexPages.StandardController sc = new ApexPages.standardController(attach);
        AttachmentInfoController ATTcontroller= new AttachmentInfoController(sc);
        ATTcontroller.att = attach;
        //ATTcontroller.savedoc();
        ATTcontroller.EditAttachmentPage();
        ATTcontroller.delDoc();
        ATTcontroller.fileNmaeWithExtension='filename';
        try{
        ATTcontroller.FileSizeFunc();
        ATTcontroller.backtoAttinfo();
        }catch(exception e){}
        ATTcontroller.Cancel();        
        AttachmentInfoController.WrapperClass actWrp = new AttachmentInfoController.WrapperClass();
        actWrp.id=attach.id;
        actWrp.Description='TestDescription'; 
        actWrp.Name='testFile';
        actWrp.contentType='text';  
        actWrp.size='55mb';       
        test.stopTest();
    } 
   static testMethod void myAttachmentMrkTest(){
         Profile p = [select id from profile where name='System Administrator']; 
         User objUser = new User(alias = 'stan', email='standarduser@test.com', 
                                emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
                                localesidkey='en_US', profileid = p.Id, 
                                timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
        insert objUser ;  
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=objUser.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
         Project__c prj = new Project__c ();
         prj.Name='ITC';
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c= system.toDay();
         prj.Status__c = 'In Progress';
         prj.ownerid =plm.userid__c;
         System.assertEquals('ITC', prj.name);
         insert prj;
         
        Subproject__c objsubpro=new Subproject__c();
        objsubpro.Name='testsub';
        objsubpro.Starts_date__c=System.now().date();
        objsubpro.Ends_date__c=System.now().date();
        System.assertEquals('testsub', objsubpro.name);
        insert objsubpro;  
         
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact;        
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=prj.id;
        attach.contentType = 'application/vnd.oasis.opendocument.database';
        System.assertEquals(prj.id,attach.parentId);
        insert attach;      
        test.startTest();
        ApexPages.currentPage().getParameters().put('mrkid',objMarketingact.id);  
        ApexPages.currentPage().getParameters().put('attid',attach.id);  
        ApexPages.StandardController sc = new ApexPages.standardController(attach);
        AttachmentInfoController ATTcontroller= new AttachmentInfoController(sc);
        ATTcontroller.att = attach;
        //ATTcontroller.savedoc();
        ATTcontroller.EditAttachmentPage();
        ATTcontroller.delDoc();
        try{
        ATTcontroller.FileSizeFunc();
        ATTcontroller.backtoAttinfo();
        }catch(exception e){}
        ATTcontroller.Cancel();        
        AttachmentInfoController.WrapperClass actWrp = new AttachmentInfoController.WrapperClass();
        actWrp.id=attach.id;
        actWrp.Description='TestDescription'; 
        actWrp.Name='testFile';
        actWrp.contentType='text';  
        actWrp.size='55mb';
        test.stopTest();  
        }        
 static testMethod void myAttachmentMrkTest1(){
         Profile p = [select id from profile where name='System Administrator']; 
         User objUser = new User(alias = 'stan', email='standarduser@test.com', 
                                emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
                                localesidkey='en_US', profileid = p.Id, 
                                timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
        insert objUser ;  
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=objUser.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
         Project__c prj = new Project__c ();
         prj.Name='ITC';
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c= system.toDay();
         prj.Status__c = 'In Progress';
         prj.ownerid =plm.userid__c;
         System.assertEquals('ITC', prj.name);
         insert prj;
         
        Subproject__c objsubpro=new Subproject__c();
        objsubpro.Name='testsub';
        objsubpro.Starts_date__c=System.now().date();
        objsubpro.Ends_date__c=System.now().date();
        System.assertEquals('testsub', objsubpro.name);
        insert objsubpro;  
         
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact;       

        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=prj.id;
        attach.contentType = 'application/vnd.oasis.opendocument.chart';
        System.assertEquals(prj.id,attach.parentId);
        insert attach;

        test.startTest();
        ApexPages.currentPage().getParameters().put('mrkid',objMarketingact.id);  
        ApexPages.currentPage().getParameters().put('attid',attach.id);  
        ApexPages.StandardController sc = new ApexPages.standardController(attach);
        AttachmentInfoController ATTcontroller= new AttachmentInfoController(sc);
        ATTcontroller.att = attach;
        //ATTcontroller.savedoc();
        ATTcontroller.EditAttachmentPage();
        ATTcontroller.delDoc();
        try{
        ATTcontroller.FileSizeFunc();
        ATTcontroller.backtoAttinfo();
        }catch(exception e){}
        ATTcontroller.Cancel();        
        AttachmentInfoController.WrapperClass actWrp = new AttachmentInfoController.WrapperClass();
     actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
    actWrp.contentType='text';  
    actWrp.size='55mb';
        test.stopTest();
        }
 static testMethod void myAttachmentMrkTest2(){
         Profile p = [select id from profile where name='System Administrator']; 
         User objUser = new User(alias = 'stan', email='standarduser@test.com', 
                                emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
                                localesidkey='en_US', profileid = p.Id, 
                                timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
        insert objUser ;  
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=objUser.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
         Project__c prj = new Project__c ();
         prj.Name='ITC';
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c= system.toDay();
         prj.Status__c = 'In Progress';
         prj.ownerid =plm.userid__c;
         System.assertEquals('ITC', prj.name);
         insert prj;
         
        Subproject__c objsubpro=new Subproject__c();
        objsubpro.Name='testsub';
        objsubpro.Starts_date__c=System.now().date();
        objsubpro.Ends_date__c=System.now().date();
        System.assertEquals('testsub', objsubpro.name);
        insert objsubpro;  
         
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact;       

        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=prj.id;
        attach.contentType = 'application/vnd.oasis.opendocument.formula';
        System.assertEquals(prj.id,attach.parentId);
        insert attach;

        test.startTest();
        ApexPages.currentPage().getParameters().put('mrkid',objMarketingact.id);  
        ApexPages.currentPage().getParameters().put('attid',attach.id);  
        ApexPages.StandardController sc = new ApexPages.standardController(attach);
        AttachmentInfoController ATTcontroller= new AttachmentInfoController(sc);
        ATTcontroller.att = attach;
        //ATTcontroller.savedoc();
        ATTcontroller.EditAttachmentPage();
        ATTcontroller.delDoc();
        try{
        ATTcontroller.FileSizeFunc();
        ATTcontroller.backtoAttinfo();
        }catch(exception e){}
        ATTcontroller.Cancel();        
        AttachmentInfoController.WrapperClass actWrp = new AttachmentInfoController.WrapperClass();
     actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
    actWrp.contentType='text';  
    actWrp.size='55mb';
        test.stopTest();
        }
 static testMethod void myAttachmentMrkTest3(){
         Profile p = [select id from profile where name='System Administrator']; 
         User objUser = new User(alias = 'stan', email='standarduser@test.com', 
                                emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
                                localesidkey='en_US', profileid = p.Id, 
                                timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
        insert objUser ;  
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=objUser.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
         Project__c prj = new Project__c ();
         prj.Name='ITC';
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c= system.toDay();
         prj.Status__c = 'In Progress';
         prj.ownerid =plm.userid__c;
         System.assertEquals('ITC', prj.name);
         insert prj;
         
        Subproject__c objsubpro=new Subproject__c();
        objsubpro.Name='testsub';
        objsubpro.Starts_date__c=System.now().date();
        objsubpro.Ends_date__c=System.now().date();
        System.assertEquals('testsub', objsubpro.name);
        insert objsubpro;  
         
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact;       
 
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=prj.id;
        attach.contentType = 'application/vnd.oasis.opendocument.graphics';
        System.assertEquals(prj.id,attach.parentId);
        insert attach;

        test.startTest();
        ApexPages.currentPage().getParameters().put('mrkid',objMarketingact.id);  
        ApexPages.currentPage().getParameters().put('attid',attach.id);  
        ApexPages.StandardController sc = new ApexPages.standardController(attach);
        AttachmentInfoController ATTcontroller= new AttachmentInfoController(sc);
        ATTcontroller.att = attach;
        //ATTcontroller.savedoc();
        ATTcontroller.EditAttachmentPage();
        ATTcontroller.delDoc();
        try{
        ATTcontroller.FileSizeFunc();
        ATTcontroller.backtoAttinfo();
        }catch(exception e){}
        ATTcontroller.Cancel();        
        AttachmentInfoController.WrapperClass actWrp = new AttachmentInfoController.WrapperClass();
     actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
    actWrp.contentType='text';  
    actWrp.size='55mb';
        test.stopTest();
     }
 static testMethod void myAttachmentMr(){
         Profile p = [select id from profile where name='System Administrator']; 
         User objUser = new User(alias = 'stan', email='standarduser@test.com', 
                                emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
                                localesidkey='en_US', profileid = p.Id, 
                                timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
        insert objUser ;  
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=objUser.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
         Project__c prj = new Project__c ();
         prj.Name='ITC';
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c= system.toDay();
         prj.Status__c = 'In Progress';
         prj.ownerid =plm.userid__c;
         System.assertEquals('ITC', prj.name);
         insert prj;
         
        Subproject__c objsubpro=new Subproject__c();
        objsubpro.Name='testsub';
        objsubpro.Starts_date__c=System.now().date();
        objsubpro.Ends_date__c=System.now().date();
        System.assertEquals('testsub', objsubpro.name);
        insert objsubpro;  
         
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact;       

        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=prj.id;
        attach.contentType = 'application/vnd.oasis.opendocument.image';
        System.assertEquals(prj.id,attach.parentId);
        insert attach;      
        test.startTest();
        ApexPages.currentPage().getParameters().put('mrkid',objMarketingact.id);  
        ApexPages.currentPage().getParameters().put('attid',attach.id);  
        ApexPages.StandardController sc = new ApexPages.standardController(attach);
        AttachmentInfoController ATTcontroller= new AttachmentInfoController(sc);
        ATTcontroller.att = attach;
        //ATTcontroller.savedoc();
        ATTcontroller.EditAttachmentPage();
        ATTcontroller.delDoc();
        try{
        ATTcontroller.FileSizeFunc();
        ATTcontroller.backtoAttinfo();
        }catch(exception e){}
        ATTcontroller.Cancel(); 
        AttachmentInfoController.WrapperClass actWrp = new AttachmentInfoController.WrapperClass();
     actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
    actWrp.contentType='text';  
    actWrp.size='55mb';
        test.stopTest();
      }
    static testMethod void myAttachmentMrkTest4(){
         Profile p = [select id from profile where name='System Administrator']; 
         User objUser = new User(alias = 'stan', email='standarduser@test.com', 
                                emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
                                localesidkey='en_US', profileid = p.Id, 
                                timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
        insert objUser ;  
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=objUser.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
         Project__c prj = new Project__c ();
         prj.Name='ITC';
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c= system.toDay();
         prj.Status__c = 'In Progress';
         prj.ownerid =plm.userid__c;
         System.assertEquals('ITC', prj.name);
         insert prj;
         
        Subproject__c objsubpro=new Subproject__c();
        objsubpro.Name='testsub';
        objsubpro.Starts_date__c=System.now().date();
        objsubpro.Ends_date__c=System.now().date();
        System.assertEquals('testsub', objsubpro.name);
        insert objsubpro;  
         
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact;       

        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=prj.id;
        attach.contentType = 'application/vnd.oasis.opendocument.presentation';
        System.assertEquals(prj.id,attach.parentId);
        insert attach;

        test.startTest();
        ApexPages.currentPage().getParameters().put('mrkid',objMarketingact.id);  
        ApexPages.currentPage().getParameters().put('attid',attach.id);  
        ApexPages.StandardController sc = new ApexPages.standardController(attach);
        AttachmentInfoController ATTcontroller= new AttachmentInfoController(sc);
        ATTcontroller.att = attach;
        //ATTcontroller.savedoc();
        ATTcontroller.EditAttachmentPage();
        ATTcontroller.delDoc();
        try{
        ATTcontroller.FileSizeFunc();
        ATTcontroller.backtoAttinfo();
        }catch(exception e){}
        ATTcontroller.Cancel();        
        AttachmentInfoController.WrapperClass actWrp = new AttachmentInfoController.WrapperClass();
     actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
    actWrp.contentType='text';  
    actWrp.size='55mb';
        test.stopTest();
       } 
    static testMethod void myAttachmentMrkTest5(){
         Profile p = [select id from profile where name='System Administrator']; 
         User objUser = new User(alias = 'stan', email='standarduser@test.com', 
                                emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
                                localesidkey='en_US', profileid = p.Id, 
                                timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
        insert objUser ;  
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=objUser.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c); 
         Project__c prj = new Project__c ();
         prj.Name='ITC';
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c= system.toDay();
         prj.Status__c = 'In Progress';
         prj.ownerid =plm.userid__c;
         System.assertEquals('ITC', prj.name);
         insert prj;
         
        Subproject__c objsubpro=new Subproject__c();
        objsubpro.Name='testsub';
        objsubpro.Starts_date__c=System.now().date();
        objsubpro.Ends_date__c=System.now().date();
        System.assertEquals('testsub', objsubpro.name);
        insert objsubpro;  
         
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact;       

        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=prj.id;
        attach.contentType = 'application/vnd.oasis.opendocument.spreadsheet';
        System.assertEquals(prj.id,attach.parentId);
        insert attach;

        test.startTest();
        ApexPages.currentPage().getParameters().put('mrkid',objMarketingact.id);  
        ApexPages.currentPage().getParameters().put('attid',attach.id);  
        ApexPages.StandardController sc = new ApexPages.standardController(attach);
        AttachmentInfoController ATTcontroller= new AttachmentInfoController(sc);
        ATTcontroller.att = attach;
        //ATTcontroller.savedoc();
        ATTcontroller.EditAttachmentPage();
        ATTcontroller.delDoc();
        try{
        ATTcontroller.FileSizeFunc();
        ATTcontroller.backtoAttinfo();
        }catch(exception e){}
        ATTcontroller.Cancel();        
        AttachmentInfoController.WrapperClass actWrp = new AttachmentInfoController.WrapperClass();
     actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
    actWrp.contentType='text';  
    actWrp.size='55mb';
        test.stopTest();
        }
 static testMethod void myAttachmentMrkTest6(){
         Profile p = [select id from profile where name='System Administrator']; 
         User objUser = new User(alias = 'stan', email='standarduser@test.com', 
                                emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
                                localesidkey='en_US', profileid = p.Id, 
                                timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
        insert objUser ;  
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=objUser.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c); 
         Project__c prj = new Project__c ();
         prj.Name='ITC';
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c= system.toDay();
         prj.Status__c = 'In Progress';
         prj.ownerid =plm.userid__c;
         System.assertEquals('ITC', prj.name);
         insert prj;
         
        Subproject__c objsubpro=new Subproject__c();
        objsubpro.Name='testsub';
        objsubpro.Starts_date__c=System.now().date();
        objsubpro.Ends_date__c=System.now().date();
        System.assertEquals('testsub', objsubpro.name);
        insert objsubpro;  
         
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact;       

        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=prj.id;
        attach.contentType = 'application/vnd.oasis.opendocument.text';
        System.assertEquals(prj.id,attach.parentId);
        insert attach;

        test.startTest();
        ApexPages.currentPage().getParameters().put('mrkid',objMarketingact.id);  
        ApexPages.currentPage().getParameters().put('attid',attach.id);  
        ApexPages.StandardController sc = new ApexPages.standardController(attach);
        AttachmentInfoController ATTcontroller= new AttachmentInfoController(sc);
        ATTcontroller.att = attach;
        //ATTcontroller.savedoc();
        ATTcontroller.EditAttachmentPage();
        ATTcontroller.delDoc();
        try{
        ATTcontroller.FileSizeFunc();
        ATTcontroller.backtoAttinfo();
        }catch(exception e){}
        ATTcontroller.Cancel();
       
        AttachmentInfoController.WrapperClass actWrp = new AttachmentInfoController.WrapperClass();
     actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
    actWrp.contentType='text';  
    actWrp.size='55mb';
        test.stopTest();         
     }
 static testMethod void myAttachmentMrkTest7(){
         Profile p = [select id from profile where name='System Administrator']; 
         User objUser = new User(alias = 'stan', email='standarduser@test.com', 
                                emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
                                localesidkey='en_US', profileid = p.Id, 
                                timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
        insert objUser ;  
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=objUser.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
         Project__c prj = new Project__c ();
         prj.Name='ITC';
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c= system.toDay();
         prj.Status__c = 'In Progress';
         prj.ownerid =plm.userid__c;
         System.assertEquals('ITC', prj.name);
         insert prj;
         
        Subproject__c objsubpro=new Subproject__c();
        objsubpro.Name='testsub';
        objsubpro.Starts_date__c=System.now().date();
        objsubpro.Ends_date__c=System.now().date();
        System.assertEquals('testsub', objsubpro.name);
        insert objsubpro;  
         
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact;       

        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=prj.id;
        attach.contentType = 'application/pdf';
        System.assertEquals('Unit Test Attachment',attach.name);
        insert attach;
      
        test.startTest();
        ApexPages.currentPage().getParameters().put('mrkid',objMarketingact.id);  
        ApexPages.currentPage().getParameters().put('attid',attach.id);  
        ApexPages.StandardController sc = new ApexPages.standardController(attach);
        AttachmentInfoController ATTcontroller= new AttachmentInfoController(sc);
        //ATTcontroller.contentType='application/pdf';
        //ATTcontroller.fileNmaeWithExtension='.txt';   
        ATTcontroller.att = attach;
        //ATTcontroller.savedoc();
        ATTcontroller.EditAttachmentPage();
        ATTcontroller.delDoc();
        try{
        ATTcontroller.FileSizeFunc();
        ATTcontroller.backtoAttinfo();
        }catch(exception e){}
        ATTcontroller.Cancel();
        AttachmentInfoController.WrapperClass actWrp = new AttachmentInfoController.WrapperClass();        
        test.stopTest();        
       }
   static testMethod void attsaveprj(){
        Profile p = [select id from profile where name='System Administrator']; 
         User objUser = new User(alias = 'stan', email='standarduser@test.com', 
                                emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
                                localesidkey='en_US', profileid = p.Id, 
                                timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
        insert objUser ;
        Project__c prj = new Project__c ();
         prj.Name='ITC';
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c= system.toDay();
         prj.Status__c = 'In Progress';
         System.assertEquals('ITC', prj.name);
         insert prj;
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=prj.id;
        attach.OwnerId=userinfo.getuserid();
        attach.contentType = 'application/pdf';
        System.assertEquals('Unit Test Attachment',attach.name);
        insert attach;
      
        test.startTest();
        PageReference pageRef = Page.ProjectDetails;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('projectid',prj.id);
        ApexPages.currentPage().getParameters().put('atmid',attach.id);
        ApexPages.StandardController sc = new ApexPages.standardController(prj);
        AttachmentInfoController ATTprj= new AttachmentInfoController(sc);
        //ATTprj.savedoc();        
        test.stopTest(); 
   }
  }