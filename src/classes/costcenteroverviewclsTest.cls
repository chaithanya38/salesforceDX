/*****************************************************************
Class Name: costcenteroverviewclsTest
Author:Chaithanya daggumati                   Last modified by:Chaithanya daggumati
Date :15/12/2015                           	  Date :15/12/2015                    
********©2013 Musqot marketing technology Pvt ltd *****************/
@isTest
public class costcenteroverviewclsTest {
    static testMethod void CostcenteroverviewMethod(){
        Costcentre__c objCC=new Costcentre__c(); 
        objCC.Name='CCRequest';
        objCC.Headline__c='musqotCostcenter';
        objCC.Overveiw__c='presentation';
        objCC.Status__c='Active';
        objCC.Description__c='this is cc description';        
        insert objCC;
        System.assertEquals('CCRequest', objCC.name);
        
        Test.startTest();
        objCC.Name ='CCMusqot';  
        update objCC;
        PageReference pageRef = Page.costcenteredit;
        Test.setCurrentPage(pageRef);          
        ApexPages.StandardController sc = new ApexPages.standardController(objCC);
        ApexPages.currentPage().getParameters().put('cosid',objCC.id);
        costcenteroverviewcls ccoverview = new costcenteroverviewcls(sc);
        ccoverview.Save();
        ccoverview.cancel();
    }
}