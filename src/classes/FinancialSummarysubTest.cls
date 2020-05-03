/*****************************************************
Class Name: FinancialSummarysubTest
Author:Nagaraju G     Last modified by:G Janarhanreddy
Date:  24/7/2014      Date:19/03/2015
********©2013 Musqot marketing technology Pvt ltd ****/
@isTest
public class FinancialSummarysubTest{
    static testMethod void FinancialSummarysubMethod(){
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
        
        Marketing_activity__c  objMarketing=new Marketing_activity__c ();
        objMarketing.Name='test';
        System.assertEquals('test', objMarketing.Name);
        objMarketing.musqot__Plan__c=objproject.id;
        objMarketing.musqot__Project__c = objsubprojct.id;
        objMarketing.musqot__Status__c='notstarted';
        //objMarketing.musqot__Activitytype__c;
        insert objMarketing;
        
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
        
        Purchase_order__c objpurchasorder=new Purchase_order__c();
        objpurchasorder.Name='test';
        objpurchasorder.musqot__Purchase_order_name__c='musqottest';
        objpurchasorder.Total_cost__c=1000;
        objpurchasorder.supplier__c='test';
        System.assertEquals('test', objpurchasorder.name);
        objpurchasorder.Subproject__c = subpro.Id;
        insert objpurchasorder; 
        
        Invoice__c objinvoice=new Invoice__c();
        objinvoice.Name='tetsinvoice';
        objinvoice.subproject__c=subpro.id;
        objinvoice.supplier__c='testsupplier';
        objinvoice.supplier__c='test';
        System.assertEquals('tetsinvoice', objinvoice.name);
        insert objinvoice;
        
        Task objtask = new Task();      
        objtask.Task_name__c = 'testname';
        objtask.WhatId=objsubprojct.id; 
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
        
        Budget__c  objbudget=new Budget__c ();
        objbudget.Name = 'test';
        objbudget.Approved_date__c = System.today();
        objbudget.Project__c=objproject.id;
        objbudget.subproject__c=subpro.id;
        objbudget.user__c=UserInfo.getUserId();
        objbudget.musqot__Approved__c=true;
        objbudget.musqot__Project__c=objproject.id;
        objbudget.Budget_h__c=2;
        objbudget.Description__c='test';
        objbudget.Budget__c=2;
        System.assertEquals('test', objbudget.name);
        insert objbudget;
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
        
        
        musqot__Allocation_resources__c alloRes= new musqot__Allocation_resources__c();
        alloRes.Name='test';
        alloRes.musqot__Approved__c=true;
        alloRes.musqot__Approved_date__c=System.today();
        alloRes.musqot__Approved_houver__c=5;
        alloRes.musqot__Cost_center__c=objCostCen.id;
        alloRes.musqot__Description__c='test decription';
        alloRes.musqot__Plan__c=objproject.id;
        alloRes.musqot__Project__c=objsubprojct.id;
        alloRes.musqot__Request_date__c=System.today();
        alloRes.musqot__Requested_hours__c=10;
        alloRes.musqot__To_marketing_activity__c=objMarketing.id;
        alloRes.musqot__To_Plan__c=objproject.id;
        alloRes.musqot__To_Project__c=objsubprojct.id;
        insert alloRes;
        
        //Financials mf1 = new Financials();
        test.starttest();
        PageReference pageRef = Page.FinancialSummarysub;
        Test.setCurrentPage(pageRef);  
        
        ApexPages.currentPage().getParameters().put('prjid', subpro.id);
        
        ApexPages.currentPage().getParameters().put('invid', objinvoice.id);
        ApexPages.currentPage().getParameters().put('purid', objpurchasorder.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objsubprojct);
        // test.startTest();     
        
        FinancialSummarysub objfinancialsub = new FinancialSummarysub(sc);
        FinancialSummarysub.Financials f = new FinancialSummarysub.Financials();
         FinancialSummarysub.Resources r = new FinancialSummarysub.Resources();
         Budget__c temp=objfinancialsub.getbudgetplan;   
                 f.color='test';
        r.approved=0.2;
        r.color='test';
        
        try{
            objfinancialsub.neworders();
        }catch(exception e){}
        objfinancialsub.gotopurchaseorderedit();
        objfinancialsub.getorders();
        objfinancialsub.getTabInFocus();
        objfinancialsub.newinvoices();
        objfinancialsub.gotoinvoiceedit();
        objfinancialsub.getinv();
        objfinancialsub.getFin();
        objfinancialsub.Level3=true;        
    	objfinancialsub.workId='test';
        objfinancialsub.getSubFin();
        objfinancialsub.taskid='test';
        objfinancialsub.getres();
        objfinancialsub.gettaskrecs();
        objfinancialsub.getSubres();
        objfinancialsub.getMares();
       
        objfinancialsub.getMaFin();
       objfinancialsub.getusertaskrecs();
       objfinancialsub.calcluteRemaing();
        test.stoptest();
    }
    static testMethod void FinancialSummarysubMethod1(){
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
        
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
         objMarketingact.Name='test';
         objMarketingact.Description__c='tdescriptionest';
         objMarketingact.Ends_date__c= System.now().date();
         objMarketingact.Starts_date__c= System.now().date();
         objMarketingact.Status__c='completed';         
         objMarketingact.Project__c=objsubprojct.id;
         System.assertEquals('test', objMarketingact.name);
         insert objMarketingact;
        
        Purchase_order__c objpurchasorder=new Purchase_order__c();
        objpurchasorder.Name='test';
        objpurchasorder.musqot__Purchase_order_name__c='musqottest';
        objpurchasorder.Total_cost__c=100;
        objpurchasorder.supplier__c='test';
        objpurchasorder.Purchase_order_cloesed__c=true;
        objpurchasorder.total_Invoice_cost__c=10000;
        insert objpurchasorder; 
        System.assertEquals(100, objpurchasorder.Total_cost__c);
        
        Allocation_amount__c  objAllocationamount=new Allocation_amount__c ();
        objAllocationamount.Name='testAllocation';
        objAllocationamount.Approved_Amount__c=1000;        
        objAllocationamount.Allocated__c=1000;        
        objAllocationamount.musqot__To_Marketing_activity__c=objMarketingact.id;
        objAllocationamount.musqot__project__c=objsubprojct.id;
        objAllocationamount.musqot__To_Project__c=objsubprojct.id;
        insert objAllocationamount;
        System.assertEquals('testAllocation', objAllocationamount.name);

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
        
        ApexPages.StandardController sc = new ApexPages.standardController(objsubprojct);
        FinancialSummarysub fsumsub=new FinancialSummarysub (sc);
        fsumsub.getSubFin();
        fsumsub.getSubres();
        fsumsub.getMaFin();
    }    
}