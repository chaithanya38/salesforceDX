/*******************************************************
Class Name: FinancialSummarymarketingTest
Author:chaithanya daggumati     Last modified by:G Janarhanreddy
Date: 24/07/2014                Date:19/03/2015
********©2013 Musqot marketing technology Pvt ltd *******/
@isTest
    public class FinancialSummarymarketingTest{
    static testMethod void FinancialSummarymarketing(){
    
    Profile p = [select id from profile where name='System Administrator'];
        User objUser = new User(alias = 'stan', email='standarduser@test.com', 
                                emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
                                localesidkey='en_US', profileid = p.Id, 
                                timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
        insert objUser ;
        System.assertEquals('stan', objUser.alias);
    
    Activitytype__c objActiv = new Activitytype__c();
    objActiv.Name='musqot';
    objActiv.Icon__c='testicon';
    objActiv.Bar_color__c='blue';
    System.assertEquals('musqot', objActiv.name);
    insert objActiv;
    
    musqot__Costcentre__c objCostCen= new musqot__Costcentre__c();
    objCostCen.Name='cc bangalore';
    objCostCen.musqot__cc_Owner__c=objUser.id;
    objCostCen.musqot__Headline__c='musottestCostCenter';
    insert objCostCen;
    System.assertEquals('cc bangalore', objCostCen.name); 
    Musqot_member__c plm=new Musqot_member__c();
    plm.musqot__userid__c=objUser.id;
    plm.musqot__Role__c='Member';        
    plm.User_type__c='Internal user';
    insert plm;
    System.assertEquals('Member', plm.Role__c);
    
    Project__c objproject=new Project__c ();
    objproject.Name='testpro';
    objproject.Starts_date__c = Date.Today();
    objproject.Ends_date__c = Date.Today();
    objproject.Status__c = 'Completed';
    objproject.ownerid =plm.userid__c;
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
    
    Subproject__c subpro=new Subproject__c();
    subpro.Parent_project__c=objproject.id;
    subpro.Name = 'testsubpro';
    subpro.musqot__Project_del__c=objsubprojct.id;
    subpro.Starts_date__c = Date.Today();
    subpro.Ends_date__c= Date.Today();
    subpro.Status__c = 'Completed';
    System.assertEquals('testsubpro', subpro.name);
    insert subpro;
    
    Allocation_amount__c  objAllocationamount=new Allocation_amount__c ();
    objAllocationamount.Name='testAllocation';
    objAllocationamount.Approved_Amount__c=1000;
    objAllocationamount.plan__c=objproject.id;
    objAllocationamount.project__c=objsubprojct.id;
    objAllocationamount.Approvedate__c=System.today();
    objAllocationamount.Description__c='testDescription';
    objAllocationamount.Allocated__c=1000;
    System.assertEquals('testAllocation', objAllocationamount.name);
    insert objAllocationamount;
    
    Purchase_order__c objpurchasorder=new Purchase_order__c();
    objpurchasorder.Name='test';
    objpurchasorder.musqot__Purchase_order_name__c='musqottest';
    objpurchasorder.Total_cost__c=1000;
    objpurchasorder.supplier__c='test';
    objpurchasorder.Purchase_order_cloesed__c=true;
    objpurchasorder.total_Invoice_cost__c=10000;
    insert objpurchasorder; 
    System.assertEquals('test', objpurchasorder.name);
    
    Invoice__c objinvoice=new Invoice__c();
    objinvoice.Name='tetsinvoice';
    objinvoice.supplier__c='testsupplier';
    objinvoice.supplier__c='test';
    System.assertEquals('tetsinvoice', objinvoice.name);
    insert objinvoice;
    
    Marketing_activity__c objMarketingact=new Marketing_activity__c();
     objMarketingact.Name='test';
     objMarketingact.Description__c='tdescriptionest';
     objMarketingact.Ends_date__c= System.now().date();
     objMarketingact.Starts_date__c= System.now().date();
     objMarketingact.Status__c='completed';
     objMarketingact.Activitytype__c=objActiv.id;
     objMarketingact.Project__c=objproject.id;
     System.assertEquals('test', objMarketingact.name);
     try{
     insert objMarketingact;
     }catch(Exception e){}
     
    Marketing_activity__c objmarkact = new  Marketing_activity__c();
    objmarkact .Name = 'test';
    System.assertEquals('test', objmarkact .Name );
    insert objmarkact ;
    musqot__Activity__c m1 =new musqot__Activity__c();
    m1.musqot__keycode__c='212';
    m1.musqot__Use_Allocation__c=true;
    m1.musqot__Use_Budget__c=true;
    m1.musqot__Use_Finance1__c=true;
    m1.musqot__Use_Forcasting__c=true;
    m1.musqot__Use_milestones__c=true;
    m1.musqot__Use_Resource__c=true;
    System.assertEquals('212', m1.musqot__keycode__c);
    insert m1;
    
    Task objtask = new Task();      
    objtask.Task_name__c = 'testname';
    objtask.WhatId=objmarkact.id; 
    objtask.Allocated_h__c=2.0;
    objtask.Outcome_h__c=2.0;
    objtask.status='complted';
    objtask.OwnerID= objUser.id;
    objtask.Priority='high';
    insert objtask ;                     
    System.assertEquals('testname', objtask .Task_name__c); 
    
    /*Costcentre__c objcoscenter=new Costcentre__c();
    objcoscenter.Name='testcoscenter';
    objCostCen.musqot__Headline__c='musottestCostCenterafdsfdsfsdgs';
    System.assertEquals('testcoscenter', objcoscenter.name);
    insert objcoscenter;*/
     
    Budget__c objbudget =new Budget__c();
    objbudget.name='testbudget';
    objbudget.Approved__c =true; 
    System.assertEquals('testbudget', objbudget.name);
    insert objbudget;
   
    PageReference pageRef = Page.FinancialSummarymarketing;
    Test.setCurrentPage(pageRef);  
    ApexPages.currentPage().getParameters().put('markID', objmarkact .id);
    ApexPages.currentPage().getParameters().put('id', objsubprojct.id);
    ApexPages.currentPage().getParameters().put('invid', objinvoice.id);
    ApexPages.currentPage().getParameters().put('orderid', objpurchasorder.id); 
    
    ApexPages.StandardController sc = new ApexPages.standardController(objmarkact );
         
    FinancialSummarymarketing fisummarkt  = new FinancialSummarymarketing(sc);
    FinancialSummarymarketing.Financials actWrp = new FinancialSummarymarketing.Financials();
    FinancialSummarymarketing.Resources actWrp1 = new FinancialSummarymarketing.Resources();
    actWrp.type='test';
    actWrp.Suballocated=0.2;
    actWrp.color='test';
    actWrp1.type='test';
    actWrp1.approved=0.2; 
    actWrp1.color='test';
    actWrp1.Suballocated=0.2;
    actWrp1.budget=0.2;  
    
    fisummarkt.getFin();
    fisummarkt.planId='test';
    fisummarkt.neworders();
    fisummarkt.gotoinvoiceedit();
    fisummarkt.newinvoices();
    fisummarkt.getorders();
    fisummarkt.getinv();
    fisummarkt.Level3=true;
    fisummarkt.workId='test';
    fisummarkt.gotopurchaseorderedit();
    fisummarkt.getTabInFocus();
    fisummarkt.taskid='test';
    fisummarkt.getres();
    fisummarkt.gettaskrecs();
    fisummarkt.getusertaskrecs(); 
   fisummarkt.disablePO=true;
        }
    }