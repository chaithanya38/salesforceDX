/*********************************************************************
Class Name: costcentermemberclsTest
Author:Chaithanya daggumati        Last modified by: Chaithanya daggumati
Date: 15/12/2015                Date: 15/12/2015 
********©2013 Musqot marketing technology Pvt ltd *********************/
@isTest
public class costcentermemberclsTest {
    static testMethod void CostcentefinanceMethod(){
        Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
        User u2 =new User( Alias = 'newUser1' ,
                          Email ='newuser123@testorg.com',
                          EmailEncodingKey = 'UTF-8',
                          LastName = 'Testing',
                          LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', 
                          UserName='newuser1234@testorg.com',
                          ProfileId=p.Id,
                          TimeZoneSidKey='America/Los_Angeles');
        insert u2;
        
        Costcentre__c objCC=new Costcentre__c(); 
        objCC.Name='CCRequest';
        objCC.OwnerId=u2.id;
        objCC.cc_Owner__c=u2.id;
        objCC.Description__c='description';
        objCC.Headline__c='musqotCostcenter';
        objCC.Overveiw__c='presentation';
        objCC.Status__c='Active';
        objCC.cc_Owner__c=u2.id;
        insert objCC;
        System.assertEquals('CCRequest', objCC.name);
        
        Members__c objmemberedit = new Members__c();
        objmemberedit .User_Email__c = 'testmail';
        objmemberedit.Cost_center__c = objCC.Id;
        objmemberedit.Role__c='member';
        objmemberedit.Type__c='Internal User';        
        insert objmemberedit ;
        System.assertEquals('member', objmemberedit.Role__c);
        
        Test.startTest();
        PageReference pageRef = Page.Costcentermember;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('cosid', objCC.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objmemberedit);
        costcentermembercls cosmem = new costcentermembercls(sc);
        cosmem.Save();
        cosmem.cancel();
    }
}