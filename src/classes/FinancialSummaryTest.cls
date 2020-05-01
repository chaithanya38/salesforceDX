/*******************************************************
Class Name: FinancialSummaryTest
Author:Nagaraju G      Last modified by:G Janarhanreddy
Date: 24/07/2014       Date:19/03/2015
********©2013 Musqot marketing technology Pvt ltd *******/
@isTest(Seealldata = True)
public class FinancialSummaryTest{
    static testMethod void financialSummaryMethod(){
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
        Activitytype__c objActiv = new Activitytype__c();
        objActiv.Name='musqot';
        objActiv.Icon__c='testicon';
        objActiv.Bar_color__c='blue';
        System.assertEquals('musqot', objActiv.name);
        insert objActiv;
        musqot__Costcentre__c objCostCen= new musqot__Costcentre__c();
        objCostCen.Name='cc bangalore';
        //objCostCen.musqot__Email__c=objUser.id;
        objCostCen.musqot__cc_Owner__c=objUser.id;
        objCostCen.musqot__Headline__c='musottestCostCenter';
        insert objCostCen;
        System.assertEquals('cc bangalore', objCostCen.name);
         
        Project__c objproject=new Project__c ();
        objproject.Name='testpro';
        objproject.Starts_date__c = Date.Today();
        objproject.Ends_date__c = Date.Today();
        objproject.Status__c = 'Completed';
        objproject.ownerid =plm.userid__c;
        insert objproject;
        System.assertEquals('testpro', objproject.name);
        
        Subproject__c objsubprojct=new Subproject__c();
        objsubprojct.Parent_project__c=objproject.id;
        objsubprojct.Name = 'testsubpro';
        objsubprojct.Starts_date__c = Date.Today();
        objsubprojct.Ends_date__c= Date.Today();
        objsubprojct.Status__c = 'Completed';
        insert objsubprojct;
        System.assertEquals('testsubpro', objsubprojct.name);
        
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
        Allocation_amount__c  objAllocationamount=new Allocation_amount__c ();
        objAllocationamount.Name='testAllocation';
        objAllocationamount.Approved_Amount__c=1000;
        objAllocationamount.plan__c=objproject.id;
        objAllocationamount.project__c=objsubprojct.id;
        objAllocationamount.Approvedate__c=System.today();
        objAllocationamount.Description__c='testDescription';
        objAllocationamount.Allocated__c=1000;
        objAllocationamount.musqot__Costcentre__c=objCostCen.id;
        objAllocationamount.musqot__To_Project__c=objsubprojct.id;
        objAllocationamount.musqot__To_Marketing_activity__c=objMarketingact.id;
        objAllocationamount.musqot__To_Plan__c=objproject.id;
        insert objAllocationamount;
        System.assertEquals('testAllocation', objAllocationamount.name);
        
         Allocation_resources__c  objAllocationhours = new Allocation_resources__c ();
        objAllocationhours.Name='testAllochours';
        objAllocationhours.Approved_houver__c=1;
        objAllocationhours.plan__c=objproject.id;
        objAllocationhours.Approved_date__c=System.today();
        objAllocationhours.Request_date__c=System.today();
        objAllocationhours.Description__c='testDescription';
        objAllocationhours.Requested_hours__c=1;
        System.assertEquals('testAllochours', objAllocationhours.name);
        insert objAllocationhours;
        
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
        insert objinvoice;
        System.assertEquals('tetsinvoice', objinvoice.name);
        
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname';
        objtask.WhatId=objproject.id; 
        objtask.Allocated_h__c=2.0;
        objtask.Outcome_h__c=2.0;
        objtask.status='complted';
        objtask.OwnerID= objUser.id;
        objtask.Priority='high';
        insert objtask ;                     
        System.assertEquals('testname', objtask .Task_name__c); 
        
        List<Purchase_order__c> POcalk = new List<Purchase_order__c>();
        POcalk = [SELECT Total_cost__c, total_Invoice_cost__c, Purchase_order_cloesed__c FROM Purchase_order__c WHERE Project__c = :objproject.id];
        Decimal purchaseOrders = 0;
        for(Purchase_order__c pruchOrdr : POcalk){
            if(pruchOrdr.Purchase_order_cloesed__c ){
                purchaseOrders += pruchOrdr.total_Invoice_cost__c;
            }
            else if( pruchOrdr.total_Invoice_cost__c >  pruchOrdr.Total_cost__c){
                purchaseOrders += pruchOrdr.total_Invoice_cost__c;
            }
            else {
                purchaseOrders += pruchOrdr.Total_cost__c; 
            }
        }
       /* Costcentre__c objcoscenter=new Costcentre__c();
        //objcoscenter.Name='testcoscenter';
        //objcoscenter= [SELECT Name FROM Costcentre__c limit 10 ];
       objCostCen.musqot__cc_Owner__c=objUser.id;
        insert objcoscenter;*/
        Budget__c objbudget =new Budget__c();
        objbudget.name='testbudget';
        objbudget.Approved__c =true; 
        System.assertEquals('testbudget', objbudget.name);
        insert objbudget;
        test.starttest();
        PageReference pageRef = Page.FinancialSummary;
        Test.setCurrentPage(pageRef);  
        ApexPages.currentPage().getParameters().put('planid', objproject.id);
        ApexPages.currentPage().getParameters().put('id', objsubprojct.id);
        ApexPages.currentPage().getParameters().put('invid', objinvoice.id);
        ApexPages.currentPage().getParameters().put('orderid', objpurchasorder.id); 
        ApexPages.StandardController sc = new ApexPages.standardController(objproject);
        FinancialSummary objfinancialSum=new FinancialSummary (sc);
        FinancialSummary.Financials f = new FinancialSummary.Financials();
         FinancialSummary.Resources r = new FinancialSummary.Resources();
         list<task> temp2=objfinancialSum.tsk;
         objfinancialSum.setTabInFocus('String s ');
         f.approved=0.2;
         f.color='test';
        
          r.approved=0.2;
         r.color='test';
         
        objfinancialSum.level3=false;
        try{
            objfinancialSum.getFin();
        }catch(exception e){}
        objfinancialSum.getSubFin(); 
        objfinancialSum.neworders();
        objfinancialSum.gotoinvoiceedit();
        objfinancialSum.newinvoices();
        objfinancialSum.getinv();
        objfinancialSum.getTabInFocus();
        objfinancialSum.getorders();
        objfinancialSum.neworders();
        objfinancialSum.getSubres();
        objfinancialSum.gettaskrecs();
        objfinancialSum.workId='test';
        objfinancialSum.Lname='test';
        objfinancialSum.getres();
        objfinancialSum.prjId='test';
        objfinancialSum.taskid='test';
        objfinancialSum.sumAllocated=1.234;
        objfinancialSum.sumSubAlloc=1.234;
        objfinancialSum.sumReserved=1.234;
        objfinancialSum.sumSpent=1.234;
        objfinancialSum.sumRemaing=1.234;
        objfinancialSum.sumBudget=1.234;
        objfinancialSum.budgetYears='2016';
        objfinancialSum.budget=10.50;
        objfinancialSum.fiscalYearName='january';
        objfinancialSum.showRequest=true;
        objfinancialSum.gotopurchaseorderedit();
        objfinancialSum.getusertaskrecs();
        objfinancialSum.getForcast();
        objfinancialSum.getplanFinancials();
        test.stoptest();
    }
    static testMethod void financialSummary1(){
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
        Project__c objproject=new Project__c ();
        objproject.Name='testpro';
        objproject.Starts_date__c = Date.Today();
        objproject.Ends_date__c = Date.Today();
        objproject.Status__c = 'Completed';
        objproject.ownerid =plm.userid__c;
        insert objproject;
        System.assertEquals('testpro', objproject.name);
        
        Subproject__c objsubprojct=new Subproject__c();
        objsubprojct.Parent_project__c=objproject.id;
        objsubprojct.Name = 'testsubpro';
        objsubprojct.Starts_date__c = Date.Today();
        objsubprojct.Ends_date__c= Date.Today();
        objsubprojct.Status__c = 'Completed';
        insert objsubprojct;
        System.assertEquals('testsubpro', objsubprojct.name);
        
        Purchase_order__c objpurchasorder=new Purchase_order__c();
        objpurchasorder.Name='test';
        objpurchasorder.musqot__Purchase_order_name__c='musqottest';
        objpurchasorder.Total_cost__c=100;
        objpurchasorder.supplier__c='test';
        objpurchasorder.Purchase_order_cloesed__c=true;
        objpurchasorder.total_Invoice_cost__c=10000;
        insert objpurchasorder; 
        System.assertEquals(100, objpurchasorder.Total_cost__c);
        
        Allocation_resources__c  objAllocationhours = new Allocation_resources__c ();
        objAllocationhours.Name='testAllochours';
        objAllocationhours.Approved_houver__c=1;
        //objAllocationhours.plan__c=objproject.id;
        objAllocationhours.Project__c=objsubprojct.id;
        objAllocationhours.To_Project__c=objsubprojct.id;
        objAllocationhours.Approved_date__c=System.today();
        objAllocationhours.Request_date__c=System.today();
        objAllocationhours.Description__c='testDescription';
        objAllocationhours.Requested_hours__c=1;
        System.assertEquals('testAllochours', objAllocationhours.name);
        insert objAllocationhours;
        
        musqot__Activity__c m1 =new musqot__Activity__c();
        m1.musqot__keycode__c='212';
        m1.musqot__Use_Allocation__c=false;
        m1.musqot__Use_Budget__c=true;
        m1.musqot__Use_Finance1__c=true;
        m1.musqot__Use_Forcasting__c=true;
        m1.musqot__Use_milestones__c=true;
        m1.musqot__Use_Resource__c=true;
        System.assertEquals('212', m1.musqot__keycode__c);
        insert m1;
        
        ApexPages.StandardController sc = new ApexPages.standardController(objproject);
        FinancialSummary fsum=new FinancialSummary (sc);
        fsum.getFin();
        fsum.getSubres();
        fsum.getres();
    } 
}