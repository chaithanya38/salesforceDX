/***********************************************************
Class Name: approvalhourdetailcontTest
Author:chaithanya daggumati           Last modified by:chaithanya daggumati
Date:10/04/2015                       Date:10/04/2015
********©2013 Musqot marketing technology Pvt ltd **********/
@isTest(seeAllData=true)
private class approvalhourdetailcontTest{
    static testMethod void approvalhourcont(){                        
        Project__c objproject=new Project__c ();
        objproject.Name='testpro';
        objproject.Starts_date__c = Date.Today();
        objproject.Ends_date__c = Date.Today();
        objproject.Status__c = 'Completed';    
        System.assertEquals('testpro', objproject.name);
        insert objproject;
        
        Subproject__c objsubprojct=new Subproject__c();
        objsubprojct.Parent_project__c=objproject.id;
        objsubprojct.Name = 'testsubpro';
        objsubprojct.Starts_date__c = Date.Today();
        objsubprojct.Ends_date__c= Date.Today();
        objsubprojct.Status__c = 'Completed';
        System.assertEquals('testsubpro', objsubprojct.name);
        insert objsubprojct;
        
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact;
          
        Costcentre__c objcoscenter=new Costcentre__c();
        objcoscenter.Name='testcoscenter';
        objcoscenter.musqot__Headline__c='mmusqottestCostcenter';
        System.assertEquals('testcoscenter', objcoscenter.name);
        insert objcoscenter;
        
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
           
        Musqot_fiscal_year__c fiscalYearObj=new Musqot_fiscal_year__c();
        fiscalYearObj.name='2015';
        fiscalYearObj.musqot__Start_date__c=system.today();
        fiscalYearObj.musqot__End_date__c=system.today()+10;
        insert fiscalYearObj;
           
        Allocation_resources__c  objAllocationhours = new Allocation_resources__c ();
        objAllocationhours.Name='testAllocation';
        objAllocationhours.musqot__Approved__c=true;
        objAllocationhours.Approved_houver__c=1000;
        objAllocationhours.plan__c=objproject.id;
        objAllocationhours.FiscalYear__c='november';
        objAllocationhours.Musqot_fiscal_year__c=fiscalYearObj.id;
        objAllocationhours.Cost_center__c=objcoscenter.id;
        //objAllocationhours.project__c=objsubprojct.id;
        objAllocationhours.Approved_date__c=System.today();
        objAllocationhours.Description__c='testDescription';
        objAllocationhours.Requested_hours__c=1000;
        objAllocationhours.musqot__To_Marketing_activity__c=objMarketingact.id;
        //objAllocationhours.musqot__To_Plan__c=objproject.id;
        objAllocationhours.musqot__To_Project__c=objsubprojct.id;
        System.assertEquals('testAllocation', objAllocationhours.name);
        insert objAllocationhours;
        
        Task objtask = new Task();      
            objtask.Task_name__c = 'testname';
            objtask.WhatId=objproject.id; 
             objtask.musqot__Allocated_h__c=20;
             objtask.ownerId=u2.id;
             objtask.Status='Completed';
             objtask.Priority='high';
            insert objtask ;
      
        Budget__c objbudget =new Budget__c();
        objbudget.name='testbudget';
        objbudget.Approved__c =true; 
        System.assertEquals('testbudget', objbudget.name);
        insert objbudget;
        
        ApexPages.currentPage().getParameters().put('hrsId',objAllocationhours.Id);
        ApexPages.currentPage().getParameters().put('arsId',objAllocationhours.Id);       
        approvalhourdetailcont objapprovalhour = new approvalhourdetailcont();
        objapprovalhour.approverec();
        objapprovalhour.rejectrec();
        objapprovalhour.cancleApproval();
        objapprovalhour.returnValue=true;
        objapprovalhour.Remaininghours=0.5;
        objapprovalhour.Comments='test';
        objapprovalhour.alloc=0.1;
        objapprovalhour.Estimate=0.1;
        objapprovalhour.suballoc=0.1;
		objapprovalhour.fiscalYear='2016';
        objapprovalhour.ccId='ccmusqot';              
    }   
    static testMethod void approvalhourcont1(){                        
        Project__c objproject=new Project__c ();
        objproject.Name='testpro';
        objproject.Starts_date__c = Date.Today();
        objproject.Ends_date__c = Date.Today();
        objproject.Status__c = 'Completed';    
        System.assertEquals('testpro', objproject.name);
        insert objproject;
        
        Subproject__c objsubprojct=new Subproject__c();
        objsubprojct.Parent_project__c=objproject.id;
        objsubprojct.Name = 'testsubpro';
        objsubprojct.Starts_date__c = Date.Today();
        objsubprojct.Ends_date__c= Date.Today();
        objsubprojct.Status__c = 'Completed';
        System.assertEquals('testsubpro', objsubprojct.name);
        insert objsubprojct;
        
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact;
          
        Costcentre__c objcoscenter=new Costcentre__c();
        objcoscenter.Name='testcoscenter';
        objcoscenter.musqot__Headline__c='mmusqottestCostcenter';
        System.assertEquals('testcoscenter', objcoscenter.name);
        insert objcoscenter;
        
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
        
        Musqot_fiscal_year__c fiscalYearObj=new Musqot_fiscal_year__c();
        fiscalYearObj.name='2015';
        fiscalYearObj.musqot__Start_date__c=system.today();
        fiscalYearObj.musqot__End_date__c=system.today()+10;
        insert fiscalYearObj;
           
        Allocation_resources__c  objAllocationhours = new Allocation_resources__c ();
        objAllocationhours.Name='testAllocation';
        objAllocationhours.musqot__Approved__c=true;
        objAllocationhours.Approved_houver__c=1000;
        //objAllocationhours.plan__c=objproject.id;
        //objAllocationhours.musqot__Costcentre__c=objcoscenter.id;
        objAllocationhours.project__c=objsubprojct.id;
        objAllocationhours.FiscalYear__c='December';
        objAllocationhours.Musqot_fiscal_year__c=fiscalYearObj.id;
        objAllocationhours.Approved_date__c=System.today();
        objAllocationhours.Description__c='testDescription';
        objAllocationhours.Requested_hours__c=1000;
        objAllocationhours.musqot__To_Marketing_activity__c=objMarketingact.id;
       objAllocationhours.musqot__To_Plan__c=objproject.id;
       //objAllocationhours.musqot__To_Project__c=objsubprojct.id;
        System.assertEquals('testAllocation', objAllocationhours.name);
        insert objAllocationhours; 
        
       Task objtask = new Task();      
            objtask.Task_name__c = 'testname';
            objtask.WhatId=objsubprojct.id; 
             objtask.musqot__Allocated_h__c=20;
             objtask.ownerId=u2.id;
             objtask.Status='Completed';
             objtask.Priority='high';
            insert objtask ;
      
        Budget__c objbudget =new Budget__c();
        objbudget.name='testbudget';
        objbudget.Approved__c =true; 
        System.assertEquals('testbudget', objbudget.name);
        insert objbudget;
        
        ApexPages.currentPage().getParameters().put('hrsId',objAllocationhours.Id);
        ApexPages.currentPage().getParameters().put('arsId',objAllocationhours.Id);
        approvalhourdetailcont objapprovalhour = new approvalhourdetailcont();
        objapprovalhour.approverec();
        objapprovalhour.rejectrec();
        objapprovalhour.cancleApproval();
        objapprovalhour.returnValue=true;
        objapprovalhour.Remaininghours=0.5;
        objapprovalhour.Comments='test';
        objapprovalhour.alloc=0.1;
        objapprovalhour.Estimate=0.1;
        objapprovalhour.suballoc=0.1;                      
    }
    static testMethod void ApprovalhoursDetail(){
        Project__c objproject=new Project__c ();
        objproject.Name='testpro';
        objproject.Starts_date__c = Date.Today();
        objproject.Ends_date__c = Date.Today();
        objproject.Status__c = 'Completed';    
        System.assertEquals('testpro', objproject.name);
        insert objproject;
        
        Subproject__c objsubprojct=new Subproject__c();
        objsubprojct.Parent_project__c=objproject.id;
        objsubprojct.Name = 'testsubpro';
        objsubprojct.Starts_date__c = Date.Today();
        objsubprojct.Ends_date__c= Date.Today();
        objsubprojct.Status__c = 'Completed';
        System.assertEquals('testsubpro', objsubprojct.name);
        insert objsubprojct;
        
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact;
          
        Costcentre__c objcoscenter=new Costcentre__c();
        objcoscenter.Name='testcoscenter';
        objcoscenter.musqot__Headline__c='mmusqottestCostcenter';
        System.assertEquals('testcoscenter', objcoscenter.name);
        insert objcoscenter;
        
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
        
        Musqot_fiscal_year__c fiscalYearObj=new Musqot_fiscal_year__c();
        fiscalYearObj.name='2015';
        fiscalYearObj.musqot__Start_date__c=system.today();
        fiscalYearObj.musqot__End_date__c=system.today()+10;
        insert fiscalYearObj;
           
        Allocation_resources__c  objAllocationhours = new Allocation_resources__c ();
        objAllocationhours.Name='testAllocation';
        objAllocationhours.musqot__Approved__c=true;
        objAllocationhours.Approved_houver__c=1000;
        objAllocationhours.plan__c=objproject.id;
        objAllocationhours.Approved_date__c=System.today();
        objAllocationhours.Description__c='testDescription';
        objAllocationhours.Requested_hours__c=1000;
        objAllocationhours.musqot__To_Marketing_activity__c=objMarketingact.id;
        System.assertEquals('testAllocation', objAllocationhours.name);
        insert objAllocationhours;  
        
       Task objtask = new Task();      
            objtask.Task_name__c = 'testname';
            objtask.WhatId=objsubprojct.id; 
             objtask.musqot__Allocated_h__c=20;
             objtask.ownerId=u2.id;
             objtask.Status='Completed';
             objtask.Priority='high';
            insert objtask ;
      
        Budget__c objbudget =new Budget__c();
        objbudget.name='testbudget';
        objbudget.Approved__c =true; 
        System.assertEquals('testbudget', objbudget.name);
        insert objbudget;
        
        ApexPages.currentPage().getParameters().put('hrsId',objAllocationhours.Id);
        ApexPages.currentPage().getParameters().put('arsId',objAllocationhours.Id);
        approvalhourdetailcont objapprovalhour = new approvalhourdetailcont();
        objapprovalhour.approverec();
        objapprovalhour.rejectrec();
        objapprovalhour.cancleApproval();
        objapprovalhour.returnValue=true;
        objapprovalhour.Remaininghours=0.5;
        objapprovalhour.Comments='test';
        objapprovalhour.alloc=0.1;
        objapprovalhour.Estimate=0.1;
        objapprovalhour.suballoc=0.1;
    }
  static testMethod void Approvalcancel(){
        Costcentre__c objcoscenter=new Costcentre__c();
        objcoscenter.Name='testcoscenter';
        objcoscenter.musqot__Headline__c='mmusqottestCostcenter';
        System.assertEquals('testcoscenter', objcoscenter.name);
        insert objcoscenter;
        Test.startTest();
        PageReference pageRef = Page.Costcenterdetail;
        Test.setCurrentPage(pageRef); 
        ApexPages.currentPage().getParameters().put('ccId',objcoscenter.Id);
        approvalhourdetailcont appcancel = new approvalhourdetailcont();
        appcancel.ccString='cos';
        appcancel.cancleApproval();
        appcancel.rejectrec();
        Test.stopTest();        
    }
 static testMethod void Approvalremaining(){         
        Allocation_resources__c  objAllocationhours = new Allocation_resources__c ();
        objAllocationhours.Name='testAllocation';
        objAllocationhours.Approved_houver__c=1.0;
        System.assertEquals('testAllocation', objAllocationhours.name);
        insert objAllocationhours;
        Test.startTest();
        PageReference pageRef = Page.Costcenterdetail;
        Test.setCurrentPage(pageRef); 
        ApexPages.currentPage().getParameters().put('hrsId',objAllocationhours.Id);
        approvalhourdetailcont apprem = new approvalhourdetailcont();
      	apprem.Remaininghours=50.5;
        apprem.approverec();
     	Test.stopTest();
  }
}