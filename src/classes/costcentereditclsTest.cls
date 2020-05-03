/*****************************************************************
Class Name: costcentereditclsTest
Author:Chaithanya daggumati                   Last modified by:Chaithanya daggumati
Date :15/12/2015                              Date :15/12/2015                    
********©2013 Musqot marketing technology Pvt ltd *****************/
@isTest
public class costcentereditclsTest {
    static testMethod void CostcentereditMethod(){
        Costcentre__c objCC=new Costcentre__c(); 
        objCC.Name='CCRequest';
        objCC.Headline__c='musqotCostcenter';
        objCC.Overveiw__c='presentation';
        objCC.Status__c='Active';
        objCC.Description__c='this is cc description';        
        insert objCC;
        System.assertEquals('CCRequest', objCC.name);
        
        Test.startTest();
        PageReference pageRef = Page.costcenteredit;
        Test.setCurrentPage(pageRef);          
        ApexPages.StandardController sc = new ApexPages.standardController(objCC);
        ApexPages.currentPage().getParameters().put('cosid',objCC.id);
        costcentereditcls ccedit = new costcentereditcls(sc);
        //List<string> temp1=ccedit.CRMItems('test1','test2');
        List<SelectOption> socialtemp=ccedit.SocialFilter;
        List<SelectOption> erptemp=ccedit.ERPFilter;
        List<SelectOption> crmtemp=ccedit.CRMFilter;
        String[] plan=ccedit.ERPItems;
        String[] plan1=ccedit.CRMItems; 
        String[] plan2=ccedit.SocialItems;
        List<String> stringList = new List<String>{'string1','string2','string3'};
        ccedit.SocialItems= stringList;
        ccedit.CRMItems= stringList;
        ccedit.ERPItems= stringList;
        ccedit.updcc();
        ccedit.cancel();
    }
}