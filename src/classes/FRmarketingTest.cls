/**************************************************************
Class Name: FRmarketingTest
Author:chaithanya daggumati     Last modified by:G Janarhanreddy
Date: 23/7/2014                  Date:19/03/2015
********©2013 Musqot marketing technology Pvt ltd *************/
@isTest
public class  FRmarketingTest{
    static testMethod void FRmarketing(){
        Subproject__c objsubproj = new Subproject__c ();
        objsubproj .Name = 'test';
        System.assertEquals('test', objsubproj .name);
        insert objsubproj;
        
        Allocation_amount__c objfrmarktng = new Allocation_amount__c ();
        objfrmarktng.Approvedate__c= Date.Today();
        System.assertEquals(Date.Today(), objfrmarktng.Approvedate__c);
        insert objfrmarktng;
        
        Marketing_activity__c ma = new Marketing_activity__c ();
        ma.Project__c = objsubproj.Id;
        ma.Name= 'Market';
        insert ma;
        
        ApexPages.currentPage().getParameters().put('mark', ma.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objfrmarktng);
        
        FRMarketingPopupCtrl FRM = new FRMarketingPopupCtrl(sc);    
        FRM.saveAmt();
        FRM.selfApp=true;
        FRM.ccApp=true;
    }
}