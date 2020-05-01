/************************************************************************
Class Name: PlantypeControllerTest
Author:chaithanya daggumati          Last modified by:chaithanya daggumati
Date:23/7/2014                       Date:19/3/2015                     
********©2013 Musqot marketing technology Pvt ltd ************************/

@isTest
public class PlantypeControllerTest{
    static testMethod void Plantype(){
		Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
     	User u2 =new User( Alias = 'newUser1' ,Email ='newuser123@testorg.com',EmailEncodingKey = 'UTF-8',LastName = 'Testing',
     	LanguageLocaleKey='en_US',LocaleSidKey='en_US', UserName='newuser1234@testorg.com',ProfileId=p.Id,TimeZoneSidKey = 'America/Los_Angeles');
     	insert u2; 
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=u2.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);        
        plantype__c objplantype = new plantype__c();        
        objplantype .Name = 'testname';
        objplantype .Barcolor__c= 'color';        
        System.assertEquals('testname', objplantype .name);
        insert objplantype ;
        plantype__c  obj = [select id from plantype__c where id=:objplantype.id limit 1];     
        delete obj;
        Project__c objproj = new Project__c();
        objproj .Name = 'test';
        objproj .Ends_date__c = system.toDay();
        objproj .Starts_date__c= system.toDay();
        objproj .Status__c = 'In Progress';
        objproj.ownerid=plm.userid__c;
        System.assertEquals('test', objproj .Name );         
        insert objproj ;
        test.startTest(); 
        PageReference pageRef = Page.MusqotAdminPage;
        Test.setCurrentPage(pageRef); 
        ApexPages.currentPage().getParameters().put('planid',objplantype.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objplantype);
        PlantypeController OBJplntype = new PlantypeController();
        OBJplntype.LoadData();
        OBJplntype.DeleteAccount();
        OBJplntype.NewPrtype();
        //OBJplntype.SelectedPlanId='test';
        try{
            OBJplntype.redirectPage1();
        }catch(Exception e){
        }
        test.stopTest();
    }
}