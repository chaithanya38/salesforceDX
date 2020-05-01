/***********************************************************
Class Name: aprovalDetailTest
Author:Nagaraju G           Last modified by:G Janardhanreddy
Date: 23/07/2014             Date:18/03/2015
********©2013 Musqot marketing technology Pvt ltd **********/
@isTest(seealldata=true)
public class aprovalDetailTest{
    static testMethod void ApprovalDetailMethod(){                        
        
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
       
        Costcentre__c objcoscenter=new Costcentre__c();
        objcoscenter.Name='testcoscenter';
        objcoscenter.Headline__c='mmusqottestCostcenter';
        System.assertEquals('testcoscenter', objcoscenter.name);
        insert objcoscenter;
       
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact;
        
        Allocation_amount__c  objAllocationamount=new Allocation_amount__c ();
        objAllocationamount.Name='testAllocation';
        objAllocationamount.Approved__c=true;
        objAllocationamount.Approved_Amount__c=1000;
        //objAllocationamount.plan__c=objproject.id;
        objAllocationamount.Costcentre__c=objcoscenter.id;
        objAllocationamount.musqot__To_Project__c=objsubprojct.id;
        objAllocationamount.Approvedate__c=System.today();
        objAllocationamount.Description__c='testDescription';
        objAllocationamount.Allocated__c=1000;
        System.assertEquals('testAllocation', objAllocationamount.name);
        insert objAllocationamount;       
        
       
        Purchase_order__c objpurchasorder=new Purchase_order__c();
        objpurchasorder.Name='test';
        objpurchasorder.Purchase_order_name__c='musqottest';
        objpurchasorder.Total_cost__c=1000;
        objpurchasorder.supplier__c='test';
        System.assertEquals('test', objpurchasorder.name);
        insert objpurchasorder; 
        
        
        Invoice__c objinvoice=new Invoice__c();
        objinvoice.Name='tetsinvoice';
        objinvoice.supplier__c='testsupplier';
        objinvoice.supplier__c='test';
        System.assertEquals('tetsinvoice', objinvoice.name);
        insert objinvoice;
       
        Budget__c objbudget =new Budget__c();
        objbudget.name='testbudget';
        objbudget.Approved__c =true; 
        System.assertEquals('testbudget', objbudget.name);
        insert objbudget;
        
        //ApexPages.currentPage().getParameters().put('planid',objproject.id);  
        ApexPages.currentPage().getParameters().put('prjId',objsubprojct.id);       
        ApexPages.currentPage().getParameters().put('amtId',objAllocationamount.Id);       
        approvalDetail objapprovdetail = new approvalDetail();
        objapprovdetail.amt = objallocationamount;
        objapprovdetail.approveRecord();
        objapprovdetail.rejectRecord();
        objapprovdetail.cancleApproval();
        objapprovdetail.returnValue=true;
        
        objapprovdetail.purchaseOrders=0.1;
        objapprovdetail.Comments='test';
        objapprovdetail.alloc=0.1;
        objapprovdetail.suballoc=0.1;
        objapprovdetail.fiscalYear='2016';
        objapprovdetail.cId='id';
        }   
     static testMethod void ApprovalDetailMethod1(){                        
        
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
       
        Costcentre__c objcoscenter=new Costcentre__c();
        objcoscenter.Name='testcoscenter';
        objcoscenter.musqot__Headline__c='mmusqottestCostcenter';
        System.assertEquals('testcoscenter', objcoscenter.name);
        insert objcoscenter;
       
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact;
        
        Allocation_amount__c  objAllocationamount=new Allocation_amount__c ();
        objAllocationamount.Name='testAllocation';
        objAllocationamount.musqot__Approved__c=true;
        objAllocationamount.Approved_Amount__c=1000;
        //objAllocationamount.plan__c=objproject.id;
        //objAllocationamount.musqot__Costcentre__c=objcoscenter.id;
        objAllocationamount.project__c=objsubprojct.id;
        objAllocationamount.Approvedate__c=System.today();
        objAllocationamount.Description__c='testDescription';
        objAllocationamount.Allocated__c=1000;
        objAllocationamount.musqot__To_Marketing_activity__c=objMarketingact.id;
       objAllocationamount.musqot__To_Plan__c=objproject.id;
       //objAllocationamount.musqot__To_Project__c=objsubprojct.id;
        System.assertEquals('testAllocation', objAllocationamount.name);
        insert objAllocationamount;       
        
       
        Purchase_order__c objpurchasorder=new Purchase_order__c();
        objpurchasorder.Name='test';
        objpurchasorder.musqot__Purchase_order_name__c='musqottest';
        objpurchasorder.Total_cost__c=1000;
        objpurchasorder.supplier__c='test';
        System.assertEquals('test', objpurchasorder.name);
        insert objpurchasorder; 
        
        
        Invoice__c objinvoice=new Invoice__c();
        objinvoice.Name='tetsinvoice';
        objinvoice.supplier__c='testsupplier';
        objinvoice.supplier__c='test';
        System.assertEquals('tetsinvoice', objinvoice.name);
        insert objinvoice;
       
        Budget__c objbudget =new Budget__c();
        objbudget.name='testbudget';
        objbudget.Approved__c =true; 
        System.assertEquals('testbudget', objbudget.name);
        insert objbudget;
        
        
        ApexPages.currentPage().getParameters().put('amtId',objAllocationamount.Id);       
        approvalDetail objapprovdetail = new approvalDetail();
        
        objapprovdetail.amt = objallocationamount;
        objapprovdetail.approveRecord();
        objapprovdetail.rejectRecord();
        objapprovdetail.cancleApproval();
        objapprovdetail.returnValue=true;
        
        objapprovdetail.purchaseOrders=0.1;
        objapprovdetail.Comments='test';
        objapprovdetail.alloc=0.1;
        objapprovdetail.suballoc=0.1; 
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean b = false;
        for(Apexpages.Message msg:msgs){
        if (msg.getDetail().contains('Search requires more characters')) b = true;
                }            
            }
    static testMethod void ApprovalDetailMethod2(){                        
        
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
       
        Costcentre__c objcoscenter=new Costcentre__c();
        objcoscenter.Name='testcoscenter';
        objcoscenter.musqot__Headline__c='mmusqottestCostcenter';
        System.assertEquals('testcoscenter', objcoscenter.name);
        insert objcoscenter;
       
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact;
          Purchase_order__c objpurchase=new Purchase_order__c ();   
        objpurchase.Name='testpurchaces';
        objpurchase.musqot__Purchase_order_name__c='testperchage';
        objpurchase.musqot__Project__c=objproject.Id;
        objpurchase.musqot__subproject__c=objsubprojct.Id;
        objpurchase.musqot__Total_cost__c=100;
        objpurchase.musqot__Supplier__c='testsuppilor';
        System.assertEquals('testsuppilor', objpurchase.musqot__Supplier__c);
        insert objpurchase;
        
        Allocation_amount__c  objAllocationamount=new Allocation_amount__c ();
        objAllocationamount.Name='testAllocation';
        objAllocationamount.musqot__Approved__c=true;
        objAllocationamount.Approved_Amount__c=1000;
        objAllocationamount.To_Plan__c=objproject.id;
        objAllocationamount.Approvedate__c=System.today();
        objAllocationamount.Description__c='testDescription';
        objAllocationamount.Allocated__c=1000;
        objAllocationamount.musqot__To_Marketing_activity__c=objMarketingact.id;
         System.assertEquals('testAllocation', objAllocationamount.name);
        insert objAllocationamount;       
                
        ApexPages.currentPage().getParameters().put('amtId',objAllocationamount.Id);     
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        boolean b = false;
      for(Apexpages.Message msg:msgs){
       if (msg.getDetail().contains('Search requires more characters'))
              b = true;
        }
        approvalDetail objapprovdetail = new approvalDetail();
        
        objapprovdetail.amt = objallocationamount;
        objapprovdetail.approveRecord();
        objapprovdetail.rejectRecord();
        objapprovdetail.cancleApproval();
        objapprovdetail.returnValue=true;
        
        objapprovdetail.purchaseOrders=0.1;
        objapprovdetail.Comments='test';
        objapprovdetail.alloc=0.1;
        objapprovdetail.suballoc=0.1;                 
                }
    static testMethod void ApprovalDetail1(){
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
        objsubprojct.Parent_project__c = objproject.id;
        objsubprojct.Starts_date__c = Date.Today();
        objsubprojct.Ends_date__c= Date.Today();
        objsubprojct.Status__c = 'Completed';
        System.assertEquals('testsubpro', objsubprojct.name);
        insert objsubprojct;
               
        Costcentre__c objcoscenter=new Costcentre__c();
        objcoscenter.Name='testcoscenter';
        objcoscenter.musqot__Headline__c='mmusqottestCostcenter';
        System.assertEquals('testcoscenter', objcoscenter.name);
        insert objcoscenter;
        
        Allocation_amount__c  objAllocationamount=new Allocation_amount__c ();
        objAllocationamount.Name='testAllocation';
        objAllocationamount.Costcentre__c=objcoscenter.id;
        objAllocationamount.Approved_Amount__c=10;
        objAllocationamount.To_Project__c=objsubprojct.id;        
         System.assertEquals('testAllocation', objAllocationamount.name);
        insert objAllocationamount;               
        approvalDetail objapprovdetai1l = new approvalDetail();
        objapprovdetai1l.approveRecord();
        objapprovdetai1l.Remainingamount=1000;
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
        ApexPages.currentPage().getParameters().put('cId',objcoscenter.Id);
        approvalDetail appcancel = new approvalDetail();
        appcancel.ccString='cos';
        appcancel.cancleApproval();
        appcancel.rejectRecord();
        Test.stopTest();        
    }
  static testMethod void Approvalremaining(){         
        Allocation_amount__c  objAllocationamount=new Allocation_amount__c ();
        objAllocationamount.Name='testAllocation';
        objAllocationamount.Approved_Amount__c=1;        
        System.assertEquals('testAllocation', objAllocationamount.name);
        insert objAllocationamount;
        Test.startTest();
        PageReference pageRef = Page.Costcenterdetail;
        Test.setCurrentPage(pageRef); 
        ApexPages.currentPage().getParameters().put('amtId',objAllocationamount.Id);
        approvalDetail apprem = new approvalDetail();
      	apprem.Remainingamount=50.55;
        apprem.approveRecord();       
  }
}