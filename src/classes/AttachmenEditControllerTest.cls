/************************************************************
Class Name: AttachmenEditControllertest
Author:G Janardhanreddy      Last modified by:G Janardhanreddy
Date: 14/01/2015              Date:18/03/2015
********©2013 Musqot marketing technology Pvt ltd ***********/
@isTest(seeAllData=true)
public class AttachmenEditControllerTest{
    static testMethod void myAttachment(){
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
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=u2.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
     
     Project__c objPrj = new Project__c ();
     objPrj.Name='ITC';
     objPrj.Ends_date__c = system.toDay().addDays(3);
     objPrj.Starts_date__c= system.toDay();
     objPrj.Status__c = 'In Progress';
     objPrj.ownerid =plm.userid__c;
     insert objPrj ;
     System.assertEquals('ITC', objPrj.name);
     
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
          
    Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
    objtask.WhatId=objPrj.id;  
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
   List<Attachment> attachments=[select id, name from Attachment where parent.id=:objtask.id];
   System.assertEquals(1, attachments.size());       
            
    test.startTest();  
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
    actWrp.contentType='application/msword'; 
    actWrp.size='549453825'; 
    
    ATTcontroller.attid='test';
    ATTcontroller.showRec=false;
    ATTcontroller.showEdt=false;
    ATTcontroller.fileSize=0.1;
    //ATTcontroller.tempfilesize=549453825;
    ATTcontroller.fileSize2='test';
    ATTcontroller.fileType='.doc'; 
    ATTcontroller.att = attach;
    ATTcontroller.att = attach;
    ATTcontroller.FileSizeFunc();
    ATTcontroller.save();
    ATTcontroller.Cancel();
       
    }
    static testMethod void myAttachmentplantest(){     
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
    
     Musqot_member__c plm=new Musqot_member__c();
     plm.musqot__userid__c=u2.id;
     plm.musqot__Role__c='Member';        
     plm.User_type__c='Internal user';
     insert plm;
     System.assertEquals('Member', plm.Role__c);
     
     Project__c objPrj = new Project__c ();
     objPrj.Name='ITC';
     objPrj.Ends_date__c = system.toDay().addDays(3);
     objPrj.Starts_date__c= system.toDay();
     objPrj.Status__c = 'In Progress';
     objPrj.ownerid =plm.userid__c;
     insert objPrj ;
     System.assertEquals('ITC', objPrj.name);
     
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
          
    Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
    objtask.WhatId=objPrj.id;  
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'text/calendar';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
   List<Attachment> attachments=[select id, name from Attachment where parent.id=:objtask.id];
   System.assertEquals(1, attachments.size());       
            
    test.startTest();
    ApexPages.currentPage().getParameters().put('planId',objPrj.id);   
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
    actWrp.contentType='text/calendar';
    actWrp.size='55mb'; 
    
    ATTcontroller.att = attach;
    ATTcontroller.att = attach;
    ATTcontroller.FileSizeFunc();
    try{
    ATTcontroller.save();
    }catch(exception e){}
    try{
    ATTcontroller.Cancel();
    }catch(exception e){}
    ATTcontroller.attid='test';
    ATTcontroller.showRec=false;
    ATTcontroller.showEdt=false;
    ATTcontroller.fileSize=0.1;
    ATTcontroller.fileSize2='test';
    //ATTcontroller.contentType=
    ATTcontroller.fileType='.ics';    
    }
    static testMethod void myAttachmentprojecttest(){     
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
        
     Musqot_member__c plm=new Musqot_member__c();
     plm.musqot__userid__c=u2.id;
     plm.musqot__Role__c='Member';        
     plm.User_type__c='Internal user';
     insert plm;
     System.assertEquals('Member', plm.Role__c);
     
     Project__c objPrj = new Project__c ();
     objPrj.Name='ITC';
     objPrj.Ends_date__c = system.toDay().addDays(3);
     objPrj.Starts_date__c= system.toDay();
     objPrj.Status__c = 'In Progress';
     objPrj.ownerid =plm.userid__c;
     insert objPrj ;
     System.assertEquals('ITC', objPrj.name);
     
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
          
    Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
    objtask.WhatId=objPrj.id;  
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/x-indesign';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
   List<Attachment> attachments=[select id, name from Attachment where parent.id=:objtask.id];
   System.assertEquals(1, attachments.size());       
            
    test.startTest();
    ApexPages.currentPage().getParameters().put('subpid',objsubpro.id);   
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
    actWrp.contentType='application/x-indesign';  
    actWrp.size='55kb'; 
    
    ATTcontroller.att = attach;
    ATTcontroller.att = attach;
    ATTcontroller.FileSizeFunc();
    try{
    ATTcontroller.save();
    }catch(exception e){}
    try{
    ATTcontroller.Cancel();
    }catch(exception e){}
    ATTcontroller.attid='test';
    ATTcontroller.showRec=false;
    ATTcontroller.showEdt=false;
    ATTcontroller.fileSize=0.1;
    ATTcontroller.fileSize2='test';
    ATTcontroller.fileType='.indd';    
        }
static testMethod void myAttachmentmarktest(){
     
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
    
   	 Musqot_member__c plm=new Musqot_member__c();
     plm.musqot__userid__c=u2.id;
     plm.musqot__Role__c='Member';        
     plm.User_type__c='Internal user';
     insert plm;
     System.assertEquals('Member', plm.Role__c);
     
     Project__c objPrj = new Project__c ();
     objPrj.Name='ITC';
     objPrj.Ends_date__c = system.toDay().addDays(3);
     objPrj.Starts_date__c= system.toDay();
     objPrj.Status__c = 'In Progress';
   	 objPrj.ownerid =plm.userid__c;
     insert objPrj ;
     System.assertEquals('ITC', objPrj.name);
     
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
          
    Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
    objtask.WhatId=objPrj.id;  
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/vnd.oasis.opendocument.database';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
   List<Attachment> attachments=[select id, name from Attachment where parent.id=:objtask.id];
   System.assertEquals(1, attachments.size());       
            
    test.startTest();
    ApexPages.currentPage().getParameters().put('markId',objMarketingact.id);   
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
    actWrp.contentType='application/vnd.oasis.opendocument.chart';  
    actWrp.size='55bytes'; 
    
    ATTcontroller.att = attach;
    ATTcontroller.att = attach;
    ATTcontroller.FileSizeFunc();
    try{
    ATTcontroller.save();
    }catch(exception e){}
    try{
    ATTcontroller.Cancel();
    }catch(exception e){}
    ATTcontroller.attid='test';
    ATTcontroller.showRec=false;
    ATTcontroller.showEdt=false;
    ATTcontroller.fileSize=0.1;
    ATTcontroller.fileSize2='test';
    ATTcontroller.fileType='.odb';   
     
  }
  static testMethod void myAttachmentmarktest2(){
     
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
      
     Musqot_member__c plm=new Musqot_member__c();
     plm.musqot__userid__c=u2.id;
     plm.musqot__Role__c='Member';        
     plm.User_type__c='Internal user';
     insert plm;
     System.assertEquals('Member', plm.Role__c);
     
     Project__c objPrj = new Project__c ();
     objPrj.Name='ITC';
     objPrj.Ends_date__c = system.toDay().addDays(3);
     objPrj.Starts_date__c= system.toDay();
     objPrj.Status__c = 'In Progress';
     objPrj.ownerid =plm.userid__c;
     insert objPrj ;
     System.assertEquals('ITC', objPrj.name);
     
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
          
    Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
    objtask.WhatId=objPrj.id;  
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/vnd.oasis.opendocument.chart';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
   List<Attachment> attachments=[select id, name from Attachment where parent.id=:objtask.id];
   System.assertEquals(1, attachments.size());       
            
    test.startTest();
    ApexPages.currentPage().getParameters().put('markId',objMarketingact.id);   
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
    actWrp.contentType='application/vnd.oasis.opendocument.chart';  
    actWrp.size='55bytes'; 
    
    ATTcontroller.att = attach;
    ATTcontroller.att = attach;
    ATTcontroller.FileSizeFunc();
    try{
    ATTcontroller.save();
    }catch(exception e){}
    try{
    ATTcontroller.Cancel();
    }catch(exception e){}
    ATTcontroller.attid='test';
    ATTcontroller.showRec=false;
    ATTcontroller.showEdt=false;
    ATTcontroller.fileSize=0.1;
    ATTcontroller.fileSize2='test';
    ATTcontroller.fileType='.odb';   
     
  }
  static testMethod void myAttachmentmarktest3(){
     
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
      
     Musqot_member__c plm=new Musqot_member__c();
     plm.musqot__userid__c=u2.id;
     plm.musqot__Role__c='Member';        
     plm.User_type__c='Internal user';
     insert plm;
     System.assertEquals('Member', plm.Role__c);
     Project__c objPrj = new Project__c ();
     objPrj.Name='ITC';
     objPrj.Ends_date__c = system.toDay().addDays(3);
     objPrj.Starts_date__c= system.toDay();
     objPrj.Status__c = 'In Progress';
     objPrj.ownerid =plm.userid__c;
     insert objPrj ;
     System.assertEquals('ITC', objPrj.name);
     
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
          
    Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
    objtask.WhatId=objPrj.id;  
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/vnd.oasis.opendocument.formula';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
   List<Attachment> attachments=[select id, name from Attachment where parent.id=:objtask.id];
   System.assertEquals(1, attachments.size());       
            
    test.startTest();
    ApexPages.currentPage().getParameters().put('markId',objMarketingact.id);   
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
    actWrp.contentType='application/vnd.oasis.opendocument.formula';  
    actWrp.size='55bytes'; 
    
    ATTcontroller.att = attach;
    ATTcontroller.att = attach;
    ATTcontroller.FileSizeFunc();
    try{
    ATTcontroller.save();
    }catch(exception e){}
    try{
    ATTcontroller.Cancel();
    }catch(exception e){}
    ATTcontroller.attid='test';
    ATTcontroller.showRec=false;
    ATTcontroller.showEdt=false;
    ATTcontroller.fileSize=0.1;
    ATTcontroller.fileSize2='test';
    ATTcontroller.fileType='.odb';   
     
  }
   static testMethod void myAttachmentmarktest4(){
     
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
     
     Musqot_member__c plm=new Musqot_member__c();
     plm.musqot__userid__c=u2.id;
     plm.musqot__Role__c='Member';        
     plm.User_type__c='Internal user';
     insert plm;
     System.assertEquals('Member', plm.Role__c);
     
     Project__c objPrj = new Project__c ();
     objPrj.Name='ITC';
     objPrj.Ends_date__c = system.toDay().addDays(3);
     objPrj.Starts_date__c= system.toDay();
     objPrj.Status__c = 'In Progress';
     objPrj.ownerid =plm.userid__c;
     insert objPrj ;
     System.assertEquals('ITC', objPrj.name);
     
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
          
    Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
    objtask.WhatId=objPrj.id;  
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/vnd.oasis.opendocument.graphics';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
   List<Attachment> attachments=[select id, name from Attachment where parent.id=:objtask.id];
   System.assertEquals(1, attachments.size());       
            
    test.startTest();
    ApexPages.currentPage().getParameters().put('markId',objMarketingact.id);   
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
    actWrp.contentType='application/vnd.oasis.opendocument.graphics';  
    actWrp.size='55bytes'; 
    
    ATTcontroller.att = attach;
    ATTcontroller.att = attach;
    ATTcontroller.FileSizeFunc();
    try{
    ATTcontroller.save();
    }catch(exception e){}
    try{
    ATTcontroller.Cancel();
    }catch(exception e){}
    ATTcontroller.attid='test';
    ATTcontroller.showRec=false;
    ATTcontroller.showEdt=false;
    ATTcontroller.fileSize=0.1;
    ATTcontroller.fileSize2='test';
    ATTcontroller.fileType='.odb';   
     
  }
   static testMethod void myAttachmentmarktest5(){
     
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
     
     Musqot_member__c plm=new Musqot_member__c();
     plm.musqot__userid__c=u2.id;
     plm.musqot__Role__c='Member';        
     plm.User_type__c='Internal user';
     insert plm;
     System.assertEquals('Member', plm.Role__c);
       
     Project__c objPrj = new Project__c ();
     objPrj.Name='ITC';
     objPrj.Ends_date__c = system.toDay().addDays(3);
     objPrj.Starts_date__c= system.toDay();
     objPrj.Status__c = 'In Progress';
     objPrj.ownerid =plm.userid__c;
     insert objPrj ;
     System.assertEquals('ITC', objPrj.name);
     
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
          
    Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
    objtask.WhatId=objPrj.id;  
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/vnd.oasis.opendocument.image';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
   List<Attachment> attachments=[select id, name from Attachment where parent.id=:objtask.id];
   System.assertEquals(1, attachments.size());       
            
    test.startTest();
    ApexPages.currentPage().getParameters().put('markId',objMarketingact.id);   
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
    actWrp.contentType='application/vnd.oasis.opendocument.image';  
    actWrp.size='55bytes'; 
    
    ATTcontroller.att = attach;
    ATTcontroller.att = attach;
    ATTcontroller.FileSizeFunc();
    try{
    ATTcontroller.save();
    }catch(exception e){}
    try{
    ATTcontroller.Cancel();
    }catch(exception e){}
    ATTcontroller.attid='test';
    ATTcontroller.showRec=false;
    ATTcontroller.showEdt=false;
    ATTcontroller.fileSize=0.1;
    ATTcontroller.fileSize2='test';
    ATTcontroller.fileType='.odb';   
     
  }
  static testMethod void myAttachmentmarktest6(){
     
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
    Musqot_member__c plm=new Musqot_member__c();
    plm.musqot__userid__c=u2.id;
    plm.musqot__Role__c='Member';        
    plm.User_type__c='Internal user';
    insert plm;
    System.assertEquals('Member', plm.Role__c);
      
    Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
      
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/vnd.oasis.opendocument.presentation';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
   List<Attachment> attachments=[select id, name from Attachment where parent.id=:objtask.id];
   System.assertEquals(1, attachments.size());       
            
    test.startTest();
     
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
    actWrp.contentType='application/vnd.oasis.opendocument.presentation';  
    actWrp.size='55bytes'; 
    }
     static testMethod void myAttachmentmarktest7(){
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
   Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
      
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/vnd.oasis.opendocument.spreadsheet';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
   List<Attachment> attachments=[select id, name from Attachment where parent.id=:objtask.id];
   System.assertEquals(1, attachments.size());       
            
    test.startTest();
     
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
    actWrp.contentType='application/vnd.oasis.opendocument.spreadsheet';            
        actWrp.size='55bytes'; 
     
    }
     static testMethod void myAttachmentmarktest8(){
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
   Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
      
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/vnd.oasis.opendocument.text';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
   List<Attachment> attachments=[select id, name from Attachment where parent.id=:objtask.id];
   System.assertEquals(1, attachments.size());       
            
    test.startTest();
     
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
    actWrp.contentType='application/vnd.oasis.opendocument.text';            
        actWrp.size='55bytes'; 
     
    }  
     static testMethod void myAttachmentmarktest9(){
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
   Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
      
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/pdf';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
   List<Attachment> attachments=[select id, name from Attachment where parent.id=:objtask.id];
   System.assertEquals(1, attachments.size());       
            
    test.startTest();
     
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
    actWrp.contentType='application/pdf';            
        actWrp.size='55bytes'; 
     
    }
     static testMethod void myAttachmentmarktest10(){
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
   Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
      
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/vnd.openxmlformats-officedocument.presentationml.slideshow';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
   List<Attachment> attachments=[select id, name from Attachment where parent.id=:objtask.id];
   System.assertEquals(1, attachments.size());       
            
    test.startTest();
     
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
    actWrp.contentType='application/vnd.openxmlformats-officedocument.presentationml.slideshow';            
        actWrp.size='55bytes'; 
     
    }
    static testMethod void myAttachmentmarktest11(){
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
   Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
      
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/vnd.ms-powerpoint';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
   List<Attachment> attachments=[select id, name from Attachment where parent.id=:objtask.id];
   System.assertEquals(1, attachments.size());       
            
    test.startTest();
     
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
    actWrp.contentType='application/vnd.ms-powerpoint';            
        actWrp.size='55bytes'; 
     
    }
    static testMethod void myAttachmentmarktest12(){
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
   Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
      
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
   List<Attachment> attachments=[select id, name from Attachment where parent.id=:objtask.id];
   System.assertEquals(1, attachments.size());       
            
    test.startTest();
     
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
    actWrp.contentType='application/vnd.openxmlformats-officedocument.presentationml.presentation';            
        actWrp.size='55bytes'; 
     
    }
     static testMethod void myAttachmentmarktest13(){
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
   Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
      
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/x-mspublisher';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
     test.startTest();
     
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
    actWrp.contentType='application/x-mspublisher';            
        actWrp.size='55bytes'; 
  }    
   static testMethod void myAttachmentmarktest14(){
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
   Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
      
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/vnd.quark';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
     test.startTest();
     
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
    actWrp.contentType='application/vnd.quark';            
        actWrp.size='55bytes'; 
  }    
   static testMethod void myAttachmentmarktest15(){
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
   Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
      
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/x-rar-compressed';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
     test.startTest();
     
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
    actWrp.contentType='application/x-rar-compressed';            
        actWrp.size='55bytes'; 
  } 
   static testMethod void myAttachmentmarkt(){
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
   Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
      
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/vnd.stardivision.draw';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
               
    test.startTest();
     
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
      actWrp.contentType='application/vnd.stardivision.draw';            
 actWrp.size='55bytes'; 
     
    }
     static testMethod void myAttachmentmarkt1(){
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
   Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
      
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/vnd.stardivision.calc';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
               
    test.startTest();
     
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
      actWrp.contentType='application/vnd.stardivision.calc';            
 actWrp.size='55bytes'; 
     
    }
    static testMethod void myAttachmentmarkt2(){
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
   Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
      
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/vnd.stardivision.impress';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
               
    test.startTest();
     
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
      actWrp.contentType='application/vnd.stardivision.impress';            
 actWrp.size='55bytes'; 
     
    }
    static testMethod void myAttachmentmarkt3(){
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
   Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
      
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/vnd.stardivision.writer';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
               
    test.startTest();
     
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
      actWrp.contentType='application/vnd.stardivision.writer';            
 actWrp.size='55bytes'; 
     
    }
    static testMethod void myAttachmentmarkt4(){
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
   Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
      
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/x-stuffit';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
               
    test.startTest();
     
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
      actWrp.contentType='application/x-stuffit';            
 actWrp.size='55bytes'; 
     
    }
      static testMethod void myAttachmentmarkt5(){
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
   Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
      
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/vnd.openxmlformats-officedocument.presentationml.slide';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
               
    test.startTest();
     
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
      actWrp.contentType='application/vnd.openxmlformats-officedocument.presentationml.slide';            
 actWrp.size='55bytes'; 
     
    }
      static testMethod void myAttachmentmarkt6(){
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
   Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
      
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/vnd.stardivision.math';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
               
    test.startTest();
     
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
      actWrp.contentType='application/vnd.stardivision.math';            
 actWrp.size='55bytes'; 
     
    }
      static testMethod void myAttachmentmarkt7(){
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
   Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
      
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/x-shockwave-flash';
      insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
               
    test.startTest();
     
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
      actWrp.contentType='application/x-shockwave-flash';            
 actWrp.size='55bytes'; 
     
    }
      static testMethod void myAttachmentmarkt8(){
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
   Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
      
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/vnd.sun.xml.calc';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
               
    test.startTest();
     
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
      actWrp.contentType='application/vnd.sun.xml.calc';            
 actWrp.size='55bytes'; 
     
    }
      static testMethod void myAttachmentmarkt9(){
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
   Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
      
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/vnd.sun.xml.draw';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
               
    test.startTest();
     
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
      actWrp.contentType='application/vnd.sun.xml.draw';            
 actWrp.size='55bytes'; 
     
    }
    
     static testMethod void myAttachment1221(){
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
   Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
      
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/vnd.sun.xml.impress';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
               
    test.startTest();
     
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
      actWrp.contentType='application/vnd.sun.xml.impress';            
 actWrp.size='55bytes'; 
     
    }
     static testMethod void myAttachment1(){
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
   Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
      
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/vnd.sun.xml.math';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
               
    test.startTest();
     
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
      actWrp.contentType='application/vnd.sun.xml.math';            
 actWrp.size='55bytes'; 
     
    }
     static testMethod void myAttachment2(){
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
   Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
      
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/vnd.sun.xml.writer';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
               
    test.startTest();
     
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
      actWrp.contentType='application/vnd.sun.xml.writer';            
 actWrp.size='55bytes'; 
     
    }
     static testMethod void myAttachment3(){
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
   Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
      
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'text/plain';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
               
    test.startTest();
     
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
      actWrp.contentType='text/plain';            
 actWrp.size='55bytes'; 
     
    }
     static testMethod void myAttachment4(){
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
   Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
      
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/vnd.ms-wpl';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
               
    test.startTest();
     
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
      actWrp.contentType='application/vnd.ms-wpl';            
 actWrp.size='55bytes'; 
     
    }
     static testMethod void myAttachment5(){
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
   Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
      
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/vnd.ms-works';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
               
    test.startTest();
     
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
      actWrp.contentType='application/vnd.ms-works';            
 actWrp.size='55bytes'; 
     
    }
     static testMethod void myAttachment6(){
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
   Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
      
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/x-mswrite';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
               
    test.startTest();
     
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
      actWrp.contentType='application/x-mswrite';            
 actWrp.size='55bytes'; 
     
    }
     static testMethod void myAttachment7(){
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
   Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
      
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/vnd.ms-excel';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
               
    test.startTest();
     
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
      actWrp.contentType='application/vnd.ms-excel';            
 actWrp.size='55bytes'; 
     
    }
     static testMethod void myAttachment8(){
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
   Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
      
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
               
    test.startTest();
     
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
      actWrp.contentType='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';            
 actWrp.size='55bytes'; 
     
    }
     static testMethod void myAttachment9(){
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
   Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
      
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/vnd.ms-xpsdocument';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
               
    test.startTest();
     
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
      actWrp.contentType='application/vnd.ms-xpsdocument';            
 actWrp.size='55bytes'; 
     
    }
     static testMethod void myAttachment10(){
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
   Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
      
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'application/zip';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
               
    test.startTest();
     
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
      actWrp.contentType='application/zip';            
 actWrp.size='55bytes'; 
     
    }
    
       static testMethod void myAttachment11(){
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
   Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
      
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'audio/';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
               
    test.startTest();
     
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
      actWrp.contentType='audio/';            
 actWrp.size='55bytes'; 
     
    }
       static testMethod void myAttachment12(){
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
   Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
      
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'image/';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
               
    test.startTest();
     
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
      actWrp.contentType='image/';            
 actWrp.size='55bytes'; 
     
    }
       static testMethod void myAttachment13(){
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
   Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.ownerId = u2.Id;  
      
    objtask.Subject = 'Run Test Trigger';
    objtask.Status = 'Not Started';
    objtask.Priority = 'Normal';                      
    insert objtask; 
    System.assertEquals('testname', objtask .Task_name__c); 
    
    Attachment attach=new Attachment();       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId = objtask.id;
    attach.ownerId = u2.Id;     
    attach.contentType = 'video/';
    insert attach;    
    System.assertEquals(objtask.id,attach.parentId);
      
               
    test.startTest();
     
    ApexPages.currentPage().getParameters().put('attsid',attach.id);      
    ApexPages.StandardController sc = new ApexPages.standardController(attach);
    AttachmenEditController ATTcontroller= new AttachmenEditController(sc);
    AttachmenEditController.WrapperClass actWrp = new AttachmenEditController.WrapperClass();
   
    actWrp.id=attach.id;
    actWrp.Description='TestDescription'; 
    actWrp.Name='testFile';
      actWrp.contentType='video/';            
 actWrp.size='55bytes'; 
     
    }
}