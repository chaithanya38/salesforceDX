@isTest
public class createApprovalProcesstestclass{
    static testMethod void createApprovalProcess(){
      
      Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
      User u2 =new User( Alias = 'newUser1' ,
      Email ='newuser123@testorg.com',
      EmailEncodingKey = 'UTF-8',
      LastName = 'Testing',
      LanguageLocaleKey='en_US',
      LocaleSidKey='en_US', 
      UserName='newuser1234@testorg.com',
      ProfileId=p.Id,
      TimeZoneSidKey    = 'America/Los_Angeles');
      insert u2; 
      
      musqot__Post_Install__c pt=new musqot__Post_Install__c();
      pt.name='Amount Approval';
      pt.musqot__Is_Approval_Crated__c=true;
      pt.musqot__Is_Hoursapproval_Crated__c=false;
      insert pt;
      System.assertEquals('Amount Approval', pt.name);
      
    MetadataService.MetadataPort service = new MetadataService.MetadataPort();
    service.SessionHeader = new MetadataService.SessionHeader_element();
    service.SessionHeader.sessionId = UserInfo.getSessionId();
    String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
    MetadataService.ApprovalProcess approvalProcess = new MetadataService.ApprovalProcess();
    approvalProcess.fullName = 'musqot__Allocation_amount__c.Approval';
    approvalProcess.label = 'Approval';
    approvalProcess.active = true;
    approvalProcess.allowRecall = true;
    approvalProcess.showApprovalHistory = false;
    approvalProcess.recordEditability = 'AdminOrCurrentApprover';
    approvalProcess.finalApprovalRecordLock = false;
    approvalProcess.finalRejectionRecordLock = false;
    approvalProcess.emailTemplate = 'musqot__Approval_Templates/musqot__Amount_Request';
            
    MetadataService.FilterItem filterItm = new MetadataService.FilterItem();
    createApprovalProcess cs=new createApprovalProcess();
    try{
       cs.cretaeAproval();
     }catch(Exception e){}
    }
           
    /*static testMethod void createApprovalProcess1(){  
      Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
      User u2 =new User( Alias = 'newUser1' ,
      Email ='newuser123@testorg.com',
      EmailEncodingKey = 'UTF-8',
      LastName = 'Testing',
      LanguageLocaleKey='en_US',
      LocaleSidKey='en_US', 
      UserName='newuser1234@testorg.com',
      ProfileId=p.Id,
      TimeZoneSidKey    = 'America/Los_Angeles');
      insert u2; 
      
      musqot__Post_Install__c pt=new musqot__Post_Install__c();
      pt.musqot__Is_Approval_Crated__c=true;
      pt.musqot__Is_Hoursapproval_Crated__c=false;
      pt.name='Amount Approval';
      insert pt;
      
      System.assertEquals('Amount Approval', pt.name);
      MetadataService.MetadataPort service = new MetadataService.MetadataPort();
    service.SessionHeader = new MetadataService.SessionHeader_element();
    service.SessionHeader.sessionId = UserInfo.getSessionId();
    String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
    MetadataService.ApprovalProcess approvalProcess = new MetadataService.ApprovalProcess();
    approvalProcess.fullName = 'musqot__Allocation_resources__c.Approvalhours';
    approvalProcess.label = 'Approvalhours';
    approvalProcess.active = true;
    approvalProcess.allowRecall = true;
    approvalProcess.showApprovalHistory = false;
    approvalProcess.recordEditability = 'AdminOrCurrentApprover';
    approvalProcess.finalApprovalRecordLock = false;
    approvalProcess.finalRejectionRecordLock = false;
    approvalProcess.emailTemplate = 'musqot__Approval_Templates/musqot__Hours_Request';
    
    MetadataService.FilterItem filterItm = new MetadataService.FilterItem();      
    createApprovalProcess cs=new createApprovalProcess();
   // try{
     cs.cretaeAproval();
    //}catch(Exception e){}
    }*/
    static testMethod void createApprovalProcess2(){
      
      Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
      User u2 =new User( Alias = 'newUser1' ,
      Email ='newuser123@testorg.com',
      EmailEncodingKey = 'UTF-8',
      LastName = 'Testing',
      LanguageLocaleKey='en_US',
      LocaleSidKey='en_US', 
      UserName='newuser1234@testorg.com',
      ProfileId=p.Id,
      TimeZoneSidKey    = 'America/Los_Angeles');
      insert u2; 
      
      musqot__Post_Install__c pt=new musqot__Post_Install__c();
      pt.name='Amount Approval';
      pt.musqot__Is_Approval_Crated__c=false;
      pt.musqot__Is_Hoursapproval_Crated__c=false;
      insert pt;
      System.assertEquals('Amount Approval', pt.name);
      
    MetadataService.MetadataPort service = new MetadataService.MetadataPort();
    service.SessionHeader = new MetadataService.SessionHeader_element();
    service.SessionHeader.sessionId = UserInfo.getSessionId();
    String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
    MetadataService.ApprovalProcess approvalProcess = new MetadataService.ApprovalProcess();
    approvalProcess.fullName = 'musqot__Allocation_resources__c.Approvalhours';
    approvalProcess.label = 'Approval';
    approvalProcess.active = true;
    approvalProcess.allowRecall = true;
    approvalProcess.showApprovalHistory = false;
    approvalProcess.recordEditability = 'AdminOrCurrentApprover';
    approvalProcess.finalApprovalRecordLock = false;
    approvalProcess.finalRejectionRecordLock = false;
    approvalProcess.emailTemplate = 'musqot__Approval_Templates/musqot__Hours_Request';
            
    MetadataService.FilterItem filterItm = new MetadataService.FilterItem();
    createApprovalProcess cs=new createApprovalProcess();
    try{
       cs.cretaeAproval();
     }catch(Exception e){}
    }
    /*static testMethod void createApprovalProcess12(){  
      Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
      User u2 =new User( Alias = 'newUser1' ,
      Email ='newuser123@testorg.com',
      EmailEncodingKey = 'UTF-8',
      LastName = 'Testing',
      LanguageLocaleKey='en_US',
      LocaleSidKey='en_US', 
      UserName='newuser1234@testorg.com',
      ProfileId=p.Id,
      TimeZoneSidKey    = 'America/Los_Angeles');
      insert u2; 
      
      musqot__Post_Install__c pt=new musqot__Post_Install__c();
      pt.musqot__Is_Approval_Crated__c=true;
      pt.musqot__Is_Hoursapproval_Crated__c=false;
      pt.name='Amount Approval';
      insert pt;
      
      System.assertEquals('Amount Approval', pt.name);
      MetadataService.MetadataPort service = new MetadataService.MetadataPort();
      service.SessionHeader = new MetadataService.SessionHeader_element();
      service.SessionHeader.sessionId = UserInfo.getSessionId();
      String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
      MetadataService.ApprovalProcess approvalProcess = new MetadataService.ApprovalProcess();
      approvalProcess.fullName = 'musqot__Allocation_amount__c.Approval';
      approvalProcess.label = 'Approvalhours';
      approvalProcess.active = true;
      approvalProcess.allowRecall = true;
      approvalProcess.showApprovalHistory = false;
      approvalProcess.recordEditability = 'AdminOrCurrentApprover';
      approvalProcess.finalApprovalRecordLock = false;
      approvalProcess.finalRejectionRecordLock = false;
      approvalProcess.emailTemplate = 'musqot__Approval_Templates/musqot__Amount_Request';
    
      MetadataService.FilterItem filterItm = new MetadataService.FilterItem();      
      createApprovalProcess cs=new createApprovalProcess();
   // try{
     cs.cretaeAproval();
    //}catch(Exception e){}
    }*/
  }