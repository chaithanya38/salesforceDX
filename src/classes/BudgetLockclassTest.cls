/*************************************************************
Class Name: BudgetLockclassTest
Author:Nagaraju G            Last modified by:G Janardhanreddy
Date: 23/7/2014              Date:18/03/2015
************©2013 Musqot marketing technology Pvt ltd ********/
@isTest (SeeAllData = true)
private class BudgetLockclassTest{
    static testMethod void BudgetLockclassTestMethod(){
        test.startTest();
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
        insert objproject;
        System.assertEquals('test', objproject.name);
        
        Subproject__c objsp = new Subproject__c ();
        objsp.name = 'testname';
        objsp.Description__c = 'sampdesc';
        objsp.Starts_date__c = date.today();
        objsp.Ends_date__c = date.today();
        objsp.Status__c = 'Notstarted';
        insert objsp ; 
        System.assertEquals('testname', objsp.name);
        
        Budget__c  objbudget1=new Budget__c ();
        objbudget1.Name = 'test1';
        objbudget1.Approved_date__c = System.today()+2;
        objbudget1.user__c=UserInfo.getUserId();
        objbudget1.musqot__Approved__c=true;
        objbudget1.musqot__Project__c=objproject.id;
        objbudget1.musqot__subproject__c=objsp.id;
        objbudget1	.Budget_h__c=10;
        objbudget1.Description__c='test123';
        objbudget1.Budget__c=5;
        insert objbudget1;
        update objbudget1;
        System.assertEquals('test1', objbudget1.name);
        
        Budget__c  objbudget2=new Budget__c ();
        objbudget1.Name = 'test1';
        objbudget1.Approved_date__c = System.today();
        objbudget1.user__c=UserInfo.getUserId();
        objbudget1.musqot__Approved__c=false;
        objbudget1.musqot__Project__c=objproject.id;
        objbudget1.musqot__subproject__c=objsp.id;
        objbudget1.Budget_h__c=10;
        objbudget1.Description__c='test123';
        objbudget1.Budget__c=5;
        insert objbudget2;
        update objbudget2;
        System.assertEquals('test1', objbudget1.name);
                               
        ApexPages.currentPage().getParameters().put('planId', objproject.id);    
        ApexPages.StandardController sc = new ApexPages.standardController(objproject); 
        BudgetLockclass objbudg = new BudgetLockclass(sc);
        List<Budget__c> budgloop = new List<Budget__c>(); 
        List<SelectOption> fisctemp=objbudg.fisicalYearOptions;
        Project__c temp1=objbudg.plan;
        Budget__c temp2=objbudg.plansum2;
        Budget__c temp3=objbudg.plansum;
        objbudg.closeBudget();
        objbudg.totbudget_h=0.1;
        objbudg.totbudget=10;
        test.stopTest();       
                 }
    Static testMethod void BudgetLockclassTestMethod1(){
        Test.startTest();
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
        insert objproject;
        System.assertEquals('test', objproject.name);
        
        Subproject__c objsp = new Subproject__c ();
        objsp.name = 'testname';
        objsp.Description__c = 'sampdesc';
        objsp.Starts_date__c = date.today();
        objsp.Ends_date__c = date.today();
        objsp.Status__c = 'Notstarted';
        insert objsp ; 
        System.assertEquals('testname', objsp.name);
        
        Budget__c  objbudget1=new Budget__c ();
        objbudget1.Name = 'test1';
        objbudget1.Approved_date__c = System.today();
        objbudget1.user__c=UserInfo.getUserId();
        objbudget1.musqot__Approved__c=false;
        objbudget1.musqot__Project__c=objproject.id;
        objbudget1.musqot__subproject__c=objsp.id;
        objbudget1.Budget_h__c=10;
        objbudget1.Description__c='test123';
        objbudget1.Budget__c=5;
        insert objbudget1;
        update objbudget1;
        System.assertEquals('test1', objbudget1.name);
        
        Budget__c  objbudget2=new Budget__c ();
        objbudget1.Name = 'test1';
        objbudget1.Approved_date__c = System.today()+2;
        objbudget1.user__c=UserInfo.getUserId();
        objbudget1.musqot__Approved__c=true;
        objbudget1.musqot__Project__c=objproject.id;
        objbudget1.musqot__subproject__c=objsp.id;
        objbudget1.Budget_h__c=10;
        objbudget1.Description__c='test123';
        objbudget1.Budget__c=5;
        insert objbudget2;
        try{
        
       Budget__c   planBudget=[SELECT Id, musqot__Approved__c, musqot__Approved_date__c, musqot__user__c, musqot__subproject__c, musqot__Project__c,musqot__Budget__c FROM musqot__Budget__c where musqot__Project__c =:objproject.id];
        
    planBudget.musqot__Approved__c=true;
                planBudget.musqot__Approved_date__c=system.toDay();
                planBudget.user__c  = UserInfo.getUserId();
        update planBudget;
        System.assertEquals('test1', objbudget1.name);
               }catch(exception e){}     
        ApexPages.currentPage().getParameters().put('planId', objproject.id);    
        ApexPages.StandardController sc = new ApexPages.standardController(objproject); 
        BudgetLockclass objbudg = new BudgetLockclass(sc);
        List<Budget__c> budgloop = new List<Budget__c>(); 
        ApexPages.currentPage().getParameters().put('id',objbudget1.id);
        for(Budget__c budg : budgloop){
            budg.musqot__Approved__c=true;
            budg.musqot__Approved_date__c=system.toDay();
            budg.user__c  = UserInfo.getUserId(); 
            upsert budg;     
        Project__c temp1=objbudg.plan;
        Budget__c temp2=objbudg.plansum2;
        Budget__c temp3=objbudg.plansum;
        objbudg.closeBudget();
        objbudg.totbudget_h=0.1;
        objbudg.totbudget=10;
        test.stopTest();       
                 }
            }
       }