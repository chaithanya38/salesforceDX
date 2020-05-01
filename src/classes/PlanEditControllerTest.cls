/**************************************************************
Class Name: PlanEditControllerTest
Author:Nagaraju G            Last modified by: G Janardhanreddy
Date: 18/7/2014              Date:20/03/2015  
********©2013 Musqot marketing technology Pvt ltd *************/
@isTest
public class PlanEditControllerTest{
    static testmethod void planEdittest(){
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
        plantype__c objplanty = new plantype__c();
        objplanty .Name='TestRecord'; 
        objplanty .Barcolor__c='red';
        System.assertEquals('TestRecord', objplanty .name);
        insert objplanty ;
        Project__c objproject = new Project__c ();
        objproject.Name='test';
        objproject.Starts_date__c= System.now().date();
        objproject.Ends_date__c= System.now().date();
        objproject.ownerid=plm.userid__c;
        insert objproject;
        ApexPages.currentPage().getParameters().put('id', objplanty .id);
        ApexPages.StandardController sc = new ApexPages.standardController(objplanty );
        PlanEditController pla= new PlanEditController (sc );
        List<SelectOption> selOpts=pla.Fieldsetlist;
        pla.Save();
        pla.Cancel();
        
    }
}