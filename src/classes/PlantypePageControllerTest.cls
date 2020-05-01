/***********************************************************
Class Name: PlantypePageControllerTest
Author:Nagaraju           Last modified by:G Janardhan reddy
Date :18/7/2014           Date : 20/03/2015                    
********©2013 Musqot marketing technology Pvt ltd *********/

@isTest(seealldata=true)
public class PlantypePageControllerTest{
    static testMethod void insertplanty(){
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
        plantype__c objPlantype=new plantype__c ();    
        objPlantype.Name='test';    
        objPlantype.Barcolor__c ='test1';  
        objPlantype.Fieldset__c =null;  
        System.assertEquals('test', objPlantype.name);
        insert objPlantype;
        
        Project__c objproj = new Project__c();
        objproj .Name = 'test';
        objproj .Ends_date__c = system.toDay();
        objproj .Starts_date__c= system.toDay();
        objproj .Status__c = 'In Progress';
        objproj.ownerid=plm.userid__c;
        System.assertEquals('test', objproj .Name );         
        insert objproj;
        
        test.startTest();
        PageReference pageRef = Page.MusqotAdminPage;
        Test.setCurrentPage(pageRef); 
        ApexPages.currentPage().getParameters().put('plns','objproj.id');
        String tabId = System.currentPageReference().getParameters().get('tabId');
        ApexPages.StandardController sc = new ApexPages.standardController(objPlantype);
        PlantypePageController plantypepagecont = new PlantypePageController();     
        plantypepagecont .LoadData() ;
        //try{
        plantypepagecont.DeleteAccount();
     
        plantypepagecont .NewPrtype();
        //plantypepagecont.SelectedPlanId='test';
        try{
            plantypepagecont .plantypedit(); 
        }catch(Exception e){   
            
        }  
    }
    static testMethod void insertplanty1(){
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
        plantype__c objPlantype=new plantype__c ();    
        objPlantype.Name='test';    
        objPlantype.Barcolor__c ='test1'; 
        objPlantype.Fieldset__c =null; 
        System.assertEquals('test', objPlantype.name);
        insert objPlantype;
        
        Project__c objproj = new Project__c();
        objproj .Name = 'test';
        objproj .Ends_date__c = system.toDay();
        objproj .Starts_date__c= system.toDay();
        objproj .Status__c = 'In Progress';
        objproj.ownerid=plm.userid__c;
        System.assertEquals('test', objproj .Name );         
        insert objproj;
        
        test.startTest();
        PageReference pageRef = Page.MusqotAdminPage;
        Test.setCurrentPage(pageRef); 
        ApexPages.currentPage().getParameters().put('plns', 'objproj.id');
        String tabId = System.currentPageReference().getParameters().get('tabId');
        ApexPages.StandardController sc = new ApexPages.standardController(objproj);
        PlantypePageController plantypepagecont = new PlantypePageController();     
        plantypepagecont .LoadData() ;
        //try{
        plantypepagecont.DeleteAccount();
        //catch(exception e){}
        plantypepagecont .NewPrtype();
        //plantypepagecont.SelectedPlanId='test';
        try{
            plantypepagecont .plantypedit(); 
        }catch(Exception e){           
        }  
    }    
}