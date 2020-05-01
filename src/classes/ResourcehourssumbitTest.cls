/*******************************************************
Class Name: ResourcehourssumbitTest 
Author:Chaithanya daggumati               Last modified by: Chaithanya daggumati 
Date: 15/4/2015                           Date:15/4/2015 
********©2013 Musqot marketing technology Pvt ltd *******/
@isTest
public class ResourcehourssumbitTest{
    static testMethod void HoursApprove(){
         
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
         
        Allocation_resources__c  objAllocationhours = new Allocation_resources__c ();
        objAllocationhours.Name='testAllochours';
        objAllocationhours.Approved_houver__c=1;
        objAllocationhours.plan__c=prj.id;
        objAllocationhours.project__c=subPrj.id;
        objAllocationhours.To_Plan__c=prj.id;
        objAllocationhours.To_Project__c=subPrj.id;
        objAllocationhours.To_marketing_activity__c=objMarketingact.id;
        objAllocationhours.Approved_date__c=System.today();
        objAllocationhours.Request_date__c=System.today();
        objAllocationhours.Description__c='testDescription';
        objAllocationhours.Requested_hours__c=1;
        System.assertEquals('testAllochours', objAllocationhours.name);
        insert objAllocationhours;                      
            }
        }