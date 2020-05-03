/**********************************************************
Class Name: Approval_ProcessTest
Author: Nagaraju G        Last modified by:G Janardhanreddy 
Date  : 24/07/2014             Date:18/03/2015
***********©2013 Musqot marketing technology Pvt ltd ******/
@isTest(seeAllData=true)
public class Approval_ProcessTest{
    static testMethod void Approval_ProcessMethod(){
    Allocation_amount__c objAllocation=new Allocation_amount__c ();
    objAllocation.Name='testallocation';
    objAllocation.Approved_Amount__c=1000;
    objAllocation.Approvedate__c=System.today();
    System.assertEquals('testallocation', objAllocation.name);
    insert objAllocation;
   
}
}