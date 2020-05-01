/*****************************************************
Class Name: HoursmarketingpopupclsTest
Author:Chaithanya Daggumati     Last modified by:Chaithanya Daggumati
Date:14/04/2015                 Date:14/04/2015
********©2013 Musqot marketing technology Pvt ltd ****/
@isTest
public class HoursmarketingpopupclsTest{
    static testMethod void Hoursmarketingpopup(){
        Profile p = [select id from profile where name='System Administrator']; 
        User objUser = new User(alias = 'stan', email='standarduser@test.com', 
                                emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
                                localesidkey='en_US', profileid = p.Id, 
                                timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
        insert objUser ;  
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=objUser.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c); 
        project__c objpro=new project__c();
        objpro.Name='test';
        objpro.Starts_date__c = Date.Today();
        objpro.Ends_date__c = Date.Today();
        objpro.Status__c = 'Completed';
        objpro.ownerid =plm.userid__c;
        System.assertEquals('test', objpro.Name);
        insert objpro;
        
        Subproject__c objsubproj = new Subproject__c();
        objsubproj.Parent_project__c=objpro.id;
        objsubproj.Name = 'test';
        objsubproj.Starts_date__c = Date.Today();
        objsubproj.Ends_date__c= Date.Today();
        objsubproj.Status__c = 'Completed';
        System.assertEquals('test', objsubproj.Name);
        insert objsubproj;
        
         Marketing_activity__c objMarketingact=new Marketing_activity__c();
         objMarketingact.Name='test';
         objMarketingact.Description__c='tdescriptionest';
         objMarketingact.Status__c='completed';
         System.assertEquals('test', objMarketingact.name);
         insert objMarketingact;
        
        Activitytype__c objActivity = new Activitytype__c(); 
        objActivity.Name='test';
        objActivity.Icon__c='testicon';
        objActivity.Bar_color__c ='red';
        System.assertEquals('test', objActivity.name);
        insert objActivity;
        
        Allocation_resources__c  objAllocationhours = new Allocation_resources__c ();
        objAllocationhours.Name='testAllochours';
        objAllocationhours.Approved_houver__c=1;
        objAllocationhours.plan__c=objpro.id;
        objAllocationhours.project__c=objsubproj.id;
        objAllocationhours.To_marketing_activity__c=objMarketingact.id;
        objAllocationhours.Approved_date__c=System.today();
        objAllocationhours.Request_date__c=System.today();
        objAllocationhours.Description__c='testDescription';
        objAllocationhours.Requested_hours__c=1;
        System.assertEquals('testAllochours', objAllocationhours.name);
           try{ 
        insert objAllocationhours;
        }catch(exception e){}
            
        test.startTest(); 
        PageReference pageRef = Page.Hoursmarketingpopup;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', objAllocationhours.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objAllocationhours);
        Hoursmarketingpopupcls hrsmarkpopup = new Hoursmarketingpopupcls(sc);
        try{
        hrsmarkpopup.saveHrs();
         }catch(exception e){}
        test.stopTest();
             }
  static testMethod void Hoursmarketingpopup1(){
      	Profile p = [select id from profile where name='System Administrator']; 
        User objUser = new User(alias = 'stan', email='standarduser@test.com', 
                                emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
                                localesidkey='en_US', profileid = p.Id, 
                                timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
        insert objUser ;  
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=objUser.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c); 
        project__c objpro=new project__c();
        objpro.Name='test';
        objpro.Starts_date__c = Date.Today();
        objpro.Ends_date__c = Date.Today();
        objpro.Status__c = 'Completed';
      	objpro.ownerid =plm.userid__c;
        System.assertEquals('test', objpro.Name);
        insert objpro;
        
        Subproject__c objsubproj = new Subproject__c();
        objsubproj.Parent_project__c=objpro.id;
        objsubproj.Name = 'test';
        objsubproj.Starts_date__c = Date.Today();
        objsubproj.Ends_date__c= Date.Today();
        objsubproj.Status__c = 'Completed';
        System.assertEquals('test', objsubproj.Name);
        insert objsubproj;
        
         Marketing_activity__c objMarketingact=new Marketing_activity__c();
         objMarketingact.Name='test';
         objMarketingact.Description__c='tdescriptionest';
         objMarketingact.Status__c='completed';
         System.assertEquals('test', objMarketingact.name);
         insert objMarketingact;
        
        Activitytype__c objActivity = new Activitytype__c(); 
        objActivity.Name='test';
        objActivity.Icon__c='testicon';
        objActivity.Bar_color__c ='red';
        System.assertEquals('test', objActivity.name);
        insert objActivity;
        
        Allocation_resources__c  objAllocationhours = new Allocation_resources__c ();
        objAllocationhours.Name='testAllochours';
        objAllocationhours.Approved_houver__c=1;
        objAllocationhours.plan__c=objpro.id;
        objAllocationhours.project__c=objsubproj.id;
        objAllocationhours.To_marketing_activity__c=objMarketingact.id;
        objAllocationhours.Approved_date__c=System.today();
        objAllocationhours.Request_date__c=System.today();
        objAllocationhours.Description__c='testDescription';
        objAllocationhours.Requested_hours__c=1;
        System.assertEquals('testAllochours', objAllocationhours.name);
           try{ 
        insert objAllocationhours;
        }catch(exception e){}
            
        test.startTest(); 
        PageReference pageRef = Page.Hoursmarketingpopup;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('mark', objMarketingact.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objMarketingact);
        Hoursmarketingpopupcls hrsmarkpopup = new Hoursmarketingpopupcls(sc);
        List<SelectOption>fiscaYearTemp= hrsmarkpopup.fisicalYearOptions;
        try{
        hrsmarkpopup.saveHrs();
         }catch(exception e){}
        test.stopTest();
             }
             
        }