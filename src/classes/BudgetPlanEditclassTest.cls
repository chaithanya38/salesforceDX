/********************************************************
Class Name: BudgetPlanEditclassTest
Author:Nagaraju G       Last modified by:G Janardhanreddy
Date: 23/7/2014         Date:18/03/2015
********©2013 Musqot marketing technology Pvt ltd *******/
@isTest(seeAllData=true)
public class BudgetPlanEditclassTest{
    static testMethod void BudgetPlanEditMethod(){
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
     
     Project__c prj = new Project__c ();
     prj.Name='ITC';         
     prj.Ends_date__c = system.toDay().addDays(3);
     prj.Starts_date__c= system.toDay();
     prj.Status__c = 'In Progress';
     prj.ownerid = plm.userid__c;
     System.assertEquals('ITC', prj.name);         
     insert prj;
     
     plantype__c objplntype = new plantype__c();
     objplntype .Name = 'test';
     objplntype .Barcolor__c = 'B741';
     System.assertEquals('test', objplntype .Name );         
     insert objplntype ;
     
    Subproject__c objsp = new Subproject__c ();
    objsp .name = 'testname';            
    objsp .Description__c = 'sampdesc';
    objsp .Starts_date__c =  System.now().date();
    objsp .Ends_date__c =  System.now().date();   
    System.assertEquals('testname', objsp .name);
    insert objsp ;
    
    Musqot_fiscal_year__c mfy = new Musqot_fiscal_year__c();
    mfy.Name='jan';
    mfy.Start_date__c=System.today();
    mfy.End_date__c=System.today();  
    System.assertEquals('jan', mfy.name);
    insert mfy;
     
    Budget__c  bud=new Budget__c ();    
    bud.Name='test';
    bud.Approved_date__c =System.now().date(); 
    bud.Project__c =prj.id; 
    bud.subproject__c=objsp.id;
    bud.FiscalYear__c='january';
    bud.Musqot_fiscal_year__c =mfy.id;
    bud.user__c=objUser.id;
    bud.musqot__Description__c='test';
    bud.musqot__Budget__c=200;
    bud.FiscalYear__c='november';
    System.assertEquals('test', bud.name);
    insert bud;
    
    Budget__c   bud1=new Budget__c();
    bud1.Approved_date__c=System.now().date();
    bud1.id=bud.id;    
    update bud1;
    
    test.starttest();
    PageReference pageRef = Page.Budget_edit;
	Test.setCurrentPage(pageRef);
    ApexPages.currentPage().getParameters().put('planid', prj.Id);
    ApexPages.currentPage().getParameters().put('bud', bud.Id);
    String tabId = System.currentPageReference().getParameters().get('Id');    
    ApexPages.StandardController sc = new ApexPages.standardController(bud);
    BudgetPlanEditclass objbudgtplan = new BudgetPlanEditclass(sc);
    List<SelectOption> temp1 =objbudgtplan.fisicalYearOptions;                           
      //try{
      objbudgtplan.Save();      
      //}catch(Exception e){}
      objbudgtplan.closebud();
      objbudgtplan.planYear=2015;
      objbudgtplan.fisyear='november';
      objbudgtplan.planEndDate=15;
      test.stoptest();  
            }
        }