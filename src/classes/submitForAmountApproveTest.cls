/*******************************************************
Class Name: submitForAmountApproveTest 
Author:Chaithanya daggumati               Last modified by: Chaithanya daggumati 
Date: 15/4/2015                           Date:15/4/2015 
********©2013 Musqot marketing technology Pvt ltd *******/
@isTest
public class submitForAmountApproveTest {
    static testMethod void AmountApprove(){
    
        Costcentre__c objcoscenter=new Costcentre__c();
        objcoscenter.Name='testcoscenter';
        objcoscenter.musqot__Headline__c='musqotCostcenter';
        System.assertEquals('testcoscenter', objcoscenter.name);
        insert objcoscenter;
        
        Project__c prj = new Project__c ();
        prj.Name='ITC';
        prj.Plantype__c=  prj.Id;
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
        subPrj.Parent_project__c = prj.Id;
        System.assertEquals('ITC Project', subPrj.name);     
        insert subPrj;
        
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact; 
         
        Allocation_amount__c  objAllocationamount=new Allocation_amount__c ();
        objAllocationamount.Name='testAllocation';
       objAllocationamount.musqot__Costcentre__c=objcoscenter.id;
        objAllocationamount.Approved_Amount__c=1000;
       // objAllocationamount.plan__c=prj.id;
      //  objAllocationamount.project__c=subPrj.id;
        objAllocationamount.Approvedate__c=System.today();
        objAllocationamount.Description__c='testDescription';
        objAllocationamount.Allocated__c=1000;
        System.assertEquals('testAllocation', objAllocationamount.name);
        insert objAllocationamount;
                      
            }
       static testMethod void AmountApprove1(){
    
        Costcentre__c objcoscenter=new Costcentre__c();
        objcoscenter.Name='testcoscenter';
        objcoscenter.musqot__Headline__c='musqotCostcenter';
        System.assertEquals('testcoscenter', objcoscenter.name);
        insert objcoscenter;
        
        Project__c prj = new Project__c ();
        prj.Name='ITC';
        prj.Plantype__c=  prj.Id;
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
        subPrj.Parent_project__c = prj.Id;
        System.assertEquals('ITC Project', subPrj.name);     
        insert subPrj;
        
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact; 
         
        Allocation_amount__c  objAllocationamount=new Allocation_amount__c ();
        objAllocationamount.Name='testAllocation';
        objAllocationamount.Approved_Amount__c=1000;
        objAllocationamount.plan__c=prj.id;
        //objAllocationamount.project__c=subPrj.id;
        objAllocationamount.Approvedate__c=System.today();
        objAllocationamount.Description__c='testDescription';
        objAllocationamount.Allocated__c=1000;
        System.assertEquals('testAllocation', objAllocationamount.name);
        insert objAllocationamount;
                      
            }
         static testMethod void AmountApprove2(){
    
        Costcentre__c objcoscenter=new Costcentre__c();
        objcoscenter.Name='testcoscenter';
        objcoscenter.musqot__Headline__c='musqotCostcenter';
        System.assertEquals('testcoscenter', objcoscenter.name);
        insert objcoscenter;
        
        Project__c prj = new Project__c ();
        prj.Name='ITC';
        prj.Plantype__c=  prj.Id;
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
        subPrj.Parent_project__c = prj.Id;
        System.assertEquals('ITC Project', subPrj.name);     
        insert subPrj;
        
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact; 
         
        Allocation_amount__c  objAllocationamount=new Allocation_amount__c ();
        objAllocationamount.Name='testAllocation';
        objAllocationamount.Approved_Amount__c=1000;
       // objAllocationamount.plan__c=prj.id;
        objAllocationamount.project__c=subPrj.id;
        objAllocationamount.To_Marketing_activity__c=objMarketingact.id;
        objAllocationamount.Approvedate__c=System.today();
        objAllocationamount.Description__c='testDescription';
        objAllocationamount.Allocated__c=1000;
        System.assertEquals('testAllocation', objAllocationamount.name);
        insert objAllocationamount;                      
            }
    static testMethod void AmountApprove3(){
        Profile p = [select id from profile where name='System Administrator'];
        User objUser = new User(alias = 'stan', email='standarduser@test.com', 
        emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, 
        timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
        insert objUser ;
        
        Costcentre__c objcoscenter=new Costcentre__c();
        objcoscenter.Name='testcoscenter';
        objcoscenter.cc_Owner__c=objUser.id;
        objcoscenter.musqot__Headline__c='musqotCostcenter';
        System.assertEquals('testcoscenter', objcoscenter.name);
        insert objcoscenter;
        
        Project__c proj = new Project__c ();
        proj.Name='ITC';
        proj.Ends_date__c = system.toDay().addDays(3);
        proj.Starts_date__c= system.toDay();
        proj.Status__c = 'In Progress';
        System.assertEquals('ITC', proj.name);         
        insert proj;
        
        Subproject__c subProj = new Subproject__c();         
        subProj.Name='ITC Project';
        subProj.Parent_project__c = proj.Id;
        subProj.Ends_date__c = system.toDay().addDays(3);
        subProj.Starts_date__c= system.toDay();
        subProj.Status__c = 'In Progress'; 
        System.assertEquals('ITC Project', subProj.name);     
        insert subProj;
        
        Allocation_amount__c  objAllocationamount=new Allocation_amount__c ();
        objAllocationamount.Name='testAllocation';
        objAllocationamount.Approved_Amount__c=1000;
       // objAllocationamount.plan__c=prj.id;
        objAllocationamount.project__c=subProj.id;
        objAllocationamount.Approvedate__c=System.today();
        objAllocationamount.Description__c='testDescription';
        objAllocationamount.Allocated__c=1000;
        System.assertEquals('testAllocation', objAllocationamount.name);
        insert objAllocationamount;            
                }           
        }