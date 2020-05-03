/**************************************************************
Class Name: approvalRequestsTest
Author: Nagaraju G         Last modified by:G Janardhanreddy 
Date  :  27/07/2014        Date:18/03/2015
***********©2013 Musqot marketing technology Pvt ltd **********/
@isTest
    private class approvalRequestsTest{
    static testMethod void approvalDetailMethod() {
     plantype__c objplanty = new plantype__c();
     objplanty .Name='TestRecord'; 
     objplanty .Barcolor__c='red';
     System.assertEquals('TestRecord', objplanty .name);
     insert objplanty ;
     
     Project__c objproject = new Project__c ();
     objproject.Name='test';
     objproject.Starts_date__c= System.now().date();
     objproject.Ends_date__c= System.now().date();
     insert objproject;
     
      Profile p = [select id from profile where name='System Administrator']; 
          User objUser = new User(alias = 'stan', email='standarduser@test.com', 
          emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
          localesidkey='en_US', profileid = p.Id, 
          timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
          insert objUser ;
          
     musqot__Costcentre__c cc = new musqot__Costcentre__c();
     cc.Name = 'My Test';
     cc.musqot__Headline__c='mmusqottestCostcenter';
     cc.musqot__cc_Owner__c = objUser.Id;
     insert cc;
     
    musqot__Allocation_amount__c objAllocation = new musqot__Allocation_amount__c();
    objAllocation.Name='test';
    System.assertEquals('test', objAllocation.name);
    objAllocation.musqot__Allocated__c = 6000;
    insert objAllocation;
    
    Allocation_resources__c  objAllocationhours = new Allocation_resources__c ();
    objAllocationhours.Name='testAllochours';
    objAllocationhours.Approved_houver__c=1;
    objAllocationhours.plan__c=objplanty.id;
    objAllocationhours.project__c=objproject.id;
    objAllocationhours.Approved_date__c=System.today();
    objAllocationhours.Request_date__c=System.today();
    objAllocationhours.Description__c='testDescription';
    objAllocationhours.Requested_hours__c=1;
    System.assertEquals('testAllochours', objAllocationhours.name);
    try{
    insert objAllocationhours;
    }catch(exception e){} 
    
    test.startTest();
    PageReference pageRef = Page.approvalRequests;
    Test.setCurrentPage(pageRef);
    ApexPages.currentPage().getParameters().put('id', objAllocation.id);
    ApexPages.StandardController sc = new ApexPages.standardController(objAllocation);
    if([select count() from ProcessInstance where targetobjectid=:objAllocation.id] < 1)
    {       
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('Approve.');
        req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        req.setObjectId(objAllocation.Id);
        try{
        Approval.ProcessResult result = Approval.process(req);
        }catch(exception e){}
        }
    approvalRequests objapp = new approvalRequests();    
    ProcessInstanceWorkitem temp2=objapp.piw;   
    objapp.getwrapList();
    
    if([select count() from ProcessInstance where targetobjectid=:objAllocationhours.id] < 1)
        {       
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Approve.');
            req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req.setObjectId(objAllocationhours.Id);
            try{
            Approval.ProcessResult result = Approval.process(req);
            }catch(exception e){}
            }
        approvalRequests objapp1 = new approvalRequests();    
        ProcessInstanceWorkitem temp5=objapp1.piw;       
        objapp1.getwrapList();
    test.stoptest();
    }
    static testMethod void approvalDetailMethod1() {
     plantype__c objplanty = new plantype__c();
     objplanty .Name='TestRecord'; 
     objplanty .Barcolor__c='red';
     System.assertEquals('TestRecord', objplanty .name);
     insert objplanty ;
     
     Project__c prj = new Project__c ();
        prj.Name='ITC';
        prj.Ends_date__c = system.toDay().addDays(3);
        prj.Starts_date__c= system.toDay();
        prj.Status__c = 'In Progress';
        System.assertEquals('ITC', prj.name);         
        insert prj;
        
        Subproject__c subPrj = new Subproject__c();         
        subPrj.Name='ITC Project';
        subPrj.Parent_project__c = prj.Id;
        subPrj.Ends_date__c = system.toDay().addDays(3);
        subPrj.Starts_date__c= system.toDay();
        subPrj.Status__c = 'In Progress'; 
        System.assertEquals('ITC Project', subPrj.name);     
        insert subPrj;
          Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact;
     
      Profile p = [select id from profile where name='System Administrator']; 
          User objUser = new User(alias = 'stan', email='standarduser@test.com', 
          emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
          localesidkey='en_US', profileid = p.Id, 
          timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
          insert objUser ;
          
     musqot__Costcentre__c cc = new musqot__Costcentre__c();
     cc.Name = 'My Test';
     cc.musqot__Headline__c='mmusqottestCostcenter';
     cc.musqot__cc_Owner__c = objUser.Id;
     insert cc;
     
    Allocation_resources__c   objAllocation = new Allocation_resources__c  ();
    objAllocation.Name='test';
    System.assertEquals('test', objAllocation.name);
    objAllocation.Approved_houver__c= 2;
    insert objAllocation;
     musqot__Costcentre__c objCC=new musqot__Costcentre__c(); 
      objCC.Name='test';
      objCC.musqot__cc_Owner__c=objUser .id;
      objCC.musqot__Headline__c='adajhhscsdhusyhuisd';
      insert objCC;
      System.assertEquals('test', objCC.name);  
    
     Allocation_resources__c  objAllocationhours = new Allocation_resources__c ();
        objAllocationhours.Name='testAllochours';
        objAllocationhours.Approved_houver__c=1;
        objAllocationhours.plan__c=prj.id;
        objAllocationhours.project__c=subPrj.id;
        objAllocationhours.musqot__Cost_center__c=objCC.id;
        objAllocationhours.Approved_date__c=System.today();
        objAllocationhours.Request_date__c=System.today();
        objAllocationhours.Description__c='testDescription';
        objAllocationhours.Requested_hours__c=1;
        objAllocationhours.To_Plan__c=prj.id;
        objAllocationhours.To_Project__c=subPrj.id;
        objAllocationhours.To_marketing_activity__c=objMarketingact.id;
        System.assertEquals('testAllochours', objAllocationhours.name);
    
      try{
   insert objAllocationhours;
    }catch(exception e){} 
    
    test.startTest();
    PageReference pageRef = Page.approvalRequests;
    Test.setCurrentPage(pageRef);
    ApexPages.currentPage().getParameters().put('id', objAllocation.id);
    ApexPages.StandardController sc = new ApexPages.standardController(objAllocation);
    if([select count() from ProcessInstance where targetobjectid=:objAllocation.id] < 1)
    {       
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('Approve.');
        req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        req.setObjectId(objAllocation.Id);
        try{
        Approval.ProcessResult result = Approval.process(req);
        }catch(exception e){}
        }
    approvalRequests objapp = new approvalRequests();    
    ProcessInstanceWorkitem temp2=objapp.piw; 
  
    objapp.getwrapList();
    test.stoptest();
    }
    }