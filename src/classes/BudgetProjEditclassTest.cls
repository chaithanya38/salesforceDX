/************************************************************
Class Name: BudgetProjEditclassTest
Author:Nagaraju G            Last modified by:G Janardhanreddy 
Date:  24/7/2014             Date:18/03/2015
********©2013 Musqot marketing technology Pvt ltd ***********/
@isTest(seeAllData=true)
    public class BudgetProjEditclassTest{
        static testMethod void BudgetProjEditMethod(){
        Profile p = [select id from profile where name='System Administrator'];
        User objUser = new User(alias = 'stan', email='standarduser@test.com', 
        emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
        localesidkey='en_US', profileid = p.Id, 
        timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
        insert objUser;
        
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
        
        Subproject__c objsp = new Subproject__c ();
        objsp .name = 'testname';            
        objsp .Description__c = 'sampdesc';
        objsp .Starts_date__c =  System.now().date();
        objsp .Ends_date__c =  System.now().date();   
        System.assertEquals('testname', objsp .name);
        insert objsp;
        
        Musqot_fiscal_year__c mfy = new Musqot_fiscal_year__c();
        mfy.Name='jan';
        mfy.Start_date__c=System.today();
        mfy.End_date__c=System.today();  
        System.assertEquals('jan', mfy.name);
        insert mfy;
        
        Budget__c  bud=new Budget__c ();    
        bud.Name='test';
        bud.Approved_date__c =System.now().date(); 
        bud.Project__c =objproject.id; 
        bud.subproject__c=objsp.id;
        bud.Musqot_fiscal_year__c =mfy.id;
        bud.user__c=objUser.id;
        bud.musqot__Description__c='test';
        bud.musqot__Budget__c=200;
        bud.FiscalYear__c='november';
        System.assertEquals('test', bud.name);
        insert bud;
        
        musqot__Activity__c m1 =new musqot__Activity__c();
        m1.musqot__keycode__c='212';
        m1.musqot__Use_Allocation__c=true;
        m1.musqot__Use_Budget__c=true;
        m1.musqot__Use_Finance1__c=true;
        m1.musqot__Use_Forcasting__c=true;
        m1.musqot__Use_milestones__c=true;
        m1.musqot__Use_Resource__c=true;
        System.assertEquals('212', m1.musqot__keycode__c);
        insert m1;
        
        ApexPages.currentPage().getParameters().put('PrjId', objsp.Id);
        ApexPages.currentPage().getParameters().put('id', bud.id);
        ApexPages.StandardController sc = new ApexPages.standardController(bud); 
        BudgetProjEditclass objbudgtproject= new BudgetProjEditclass(sc);
        List<SelectOption> temp1 =objbudgtproject.fisicalYearOptions;
        objbudgtproject.Save();
         }
    }