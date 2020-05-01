/*******************************************************
Class Name: MarketingactivityTest
Author:Nagaraju         Last modified by: Janardhan reddy
Date :21/7/2014         Date : 19/3/2105                    
********©2013 Musqot marketing technology Pvt ltd *******/

@isTest(Seealldata = True)
private class MarketingactivityTest{
    static testMethod void Marketingactivity(){
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
    Project__c objproject = new Project__c ();
    objproject.Name='test';
    //objproject.Project_type__c='test';
    objproject.Starts_date__c= System.now().date();
    objproject.Ends_date__c= System.now().date();
    objproject.OwnerId=plm.userid__c;
    System.assertEquals('test', objproject.name);
    insert objproject;
    
    Marketing_activity__c objMarketingact=new Marketing_activity__c();
    objMarketingact.Name='test';
    objMarketingact.Description__c='tdescriptionest';
    objMarketingact.Status__c='completed';
    objMarketingact.Plan__c=objproject.id;
    System.assertEquals('test', objMarketingact.name);
    try{
    insert objMarketingact;
    }
    catch(Exception e){
    Boolean expectedExceptionThrown =  e.getMessage().contains('Here goes your custom message') ? true : false;
    system.assertEquals(expectedExceptionThrown,true);      
    }
    Workspace__c objectwork1=new Workspace__c();
    objectwork1.Name='test';
    objectwork1.ProjectName__c=objproject.id;
    objectwork1.Description__c='test1';
    objectwork1.html_description__c='test123';
    
    insert objectwork1;
    
    Workspace__c objectwork=new Workspace__c();
    objectwork.Name='test';
    objectwork.ProjectName__c=objproject.id;
    objectwork.Description__c='test1';
    objectwork.html_description__c='test123';
    
    System.assertEquals('test', objectwork.name);
    insert objectwork;
    
    Task Objtask=new Task();
    Objtask.Task_name__c='test';
    Objtask.Status='completed';
    Objtask.Priority='high';
    Objtask.Allocated_h__c=12;
    System.assertEquals('test',Objtask.Task_name__c);
    //insert Objtask;
    Members__c objmember=new Members__c ();
    //objmember.Name ='test';
    //objmember.ProjMembers__c='test';
    //objmember.ProjUsers__c=u2.Id;
    //objmember.SubProjMembers__c='test';
    objmember.Role__c='Member';
    objmember.User_Email__c ='standarduser1@test.com';
    System.assertEquals('Member', objmember.Role__c);
    insert objmember;
    Attachment attach=new Attachment();
    attach.OwnerId = objMarketingact.OwnerId;       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId=objMarketingact.id;
    attach.contentType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    System.assertEquals(objMarketingact.id,attach.parentId);
    //insert attach;
    ApexPages.currentPage().getParameters().put('id', objMarketingact.id);
    ApexPages.currentPage().getParameters().get('taskid');
    ApexPages.currentPage().getParameters().get('atmid');
    ApexPages.currentPage().getParameters().get('mbrId'); 
    ApexPages.StandardController sc = new ApexPages.standardController(objMarketingact); 
    Marketingactivity  objMarketingactivity = new Marketingactivity(sc);
    //Marketingactivity.AttachWrapper mawrap = new Marketingactivity.AttachWrapper(sc);
    objMarketingactivity .workSpace();
    objMarketingactivity.getmyfile();
    objMarketingactivity.Savedoc();
    objMarketingactivity.newMember();
    objMarketingactivity.gotoMemberEdit();
    objMarketingactivity.getparentmembers();
    objMarketingactivity.newtask(); 
    objMarketingactivity.gotoattchmentpage();
    objMarketingactivity.getTabInFocus();
    try{
    
    objMarketingactivity.delMrkRe();
    objMarketingactivity.gotoTaskEdit();
     
    }catch(exception e){}
   
    objMarketingactivity.getmembers();
    objMarketingactivity.gotomarketingEdit();
    objMarketingactivity.gettaskrecs2();
    objMarketingactivity.getGadgetHTMLContent();
    objMarketingactivity.customset();
    objMarketingactivity.getpubdatelist();
    objMarketingactivity.redirectNewDatesPage();
    objMarketingactivity.getAttLinks();
    objMarketingactivity.newPubdate();
    objMarketingactivity.activityEndDate='dec31';
    try{
     objMarketingactivity.goToActivityDatEditMode();
    }catch(exception e){}
    }
  static testMethod void Marketingactivity2(){
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
    Project__c objproject = new Project__c ();
    objproject.Name='test';
    //objproject.Project_type__c='test';
    objproject.Starts_date__c= System.now().date();
    objproject.Ends_date__c= System.now().date();
    objproject.OwnerId=plm.userid__c;
    System.assertEquals('test', objproject.name);
    insert objproject;
    
    Marketing_activity__c objMarketingact=new Marketing_activity__c();
    objMarketingact.Name='test';
    objMarketingact.Description__c='tdescriptionest';
    objMarketingact.Status__c='completed';
    objMarketingact.Plan__c=objproject.id;
    System.assertEquals('test', objMarketingact.name);
    try{
    insert objMarketingact;
    }
    catch(Exception e){
    Boolean expectedExceptionThrown =  e.getMessage().contains('Here goes your custom message') ? true : false;
    system.assertEquals(expectedExceptionThrown,true);      
    }
    
    
    Workspace__c objectwork1=new Workspace__c();
    objectwork1.Name='test';
    objectwork1.ProjectName__c=objproject.id;
    objectwork1.Description__c='test1';
    objectwork1.html_description__c='test123';
    
    insert objectwork1;
    
    Workspace__c objectwork=new Workspace__c();
    objectwork.Name='test';
    objectwork.ProjectName__c=objproject.id;
    objectwork.Description__c='test1';
    objectwork.html_description__c='test123';
    
    System.assertEquals('test', objectwork.name);
    insert objectwork;
    
    Task Objtask=new Task();
    Objtask.Task_name__c='test';
    Objtask.Status='completed';
    Objtask.Priority='high';
    Objtask.Allocated_h__c=12;
    System.assertEquals('test',Objtask.Task_name__c);
    //insert Objtask;
    Members__c objmember=new Members__c ();
    //objmember.Name ='test';
    //objmember.ProjMembers__c='test';
    //objmember.ProjUsers__c=u2.Id;
    //objmember.SubProjMembers__c='test';
    objmember.Role__c='Member';
    objmember.User_Email__c ='standarduser1@test.com';
    System.assertEquals('Member', objmember.Role__c);
    insert objmember;
    Attachment attach=new Attachment();
    attach.OwnerId = objMarketingact.OwnerId;       
    attach.Name='Unit Test Attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    attach.body=bodyBlob;
    attach.parentId=objMarketingact.id;
    attach.contentType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    System.assertEquals(objMarketingact.id,attach.parentId);
    //insert attach;
    ApexPages.currentPage().getParameters().put('id', objMarketingact.id);
    ApexPages.currentPage().getParameters().get('taskid');
    ApexPages.currentPage().getParameters().get('atmid');
    ApexPages.currentPage().getParameters().get('mbrId'); 
    ApexPages.StandardController sc = new ApexPages.standardController(objMarketingact); 
    Marketingactivity  objMarketingactivity = new Marketingactivity(sc);
    objMarketingactivity .workSpace();
    objMarketingactivity.setTabInFocus('String s' );
    objMarketingactivity.getmyfile();
    objMarketingactivity.Savedoc();
    objMarketingactivity.newMember();
    objMarketingactivity.gotoMemberEdit();
     objMarketingactivity.getparentmembers();
    objMarketingactivity.newtask(); 
    objMarketingactivity.gotoattchmentpage();
    objMarketingactivity.getTabInFocus();
    try{
    
    objMarketingactivity.delMrkRe();
    objMarketingactivity.gotoTaskEdit();
     
    }catch(exception e){}
   
    objMarketingactivity.getmembers();
    objMarketingactivity.name='test';
    objMarketingactivity.displayPopup=true;
    objMarketingactivity.gotomarketingEdit();
    objMarketingactivity.gettaskrecs2();
        objMarketingactivity.getGadgetHTMLContent();
    objMarketingactivity.customset();
 
    //objMarketingactivity.getTabInFocus();
    
    }}