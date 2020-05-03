/********************************************************
Class Name: BudgetpageclassTest
Author:Nagaraju G       Last modified by:G Janardhanreddy
Date: 24/7/2014                        Date:18/03/2015
********©2013 Musqot marketing technology Pvt ltd *******/
@isTest
public class BudgetpageclassTest{
    static testMethod void BudgetpageclassMethod(){
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
        Project__c objproject = new Project__c ();
        objproject.Name='test';
        objproject.Starts_date__c= System.now().date();
        objproject.Ends_date__c= System.now().date();
        objproject.ownerid =plm.userid__c;
        System.assertEquals('test', objproject.name);
        insert objproject;
        Budget__c  objbudgect=new Budget__c ();
        objbudgect.Name='test';
        objbudgect.Approved_date__c =System.now().date();
        System.assertEquals('test', objbudgect.name);
        insert objbudgect;
        ApexPages.currentPage().getParameters().put('id', objbudgect.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objbudgect); 
        Budgetpageclass objbudgtpage = new Budgetpageclass(sc );
        objbudgtpage.Save();
        objbudgtpage.Editpage();
        objbudgtpage.planId='test';
        objbudgtpage.Cancel();
    }
}