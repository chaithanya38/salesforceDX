/*******************************************************
Class Name: PlanMemberControllerTest
Author:Nagaraju         Last modified by:Nagaraju 
Date :19/7/2014         Date :29/10/2105                    
********©2013 Musqot marketing technology Pvt ltd *******/
@isTest(seeAllData=true)
public class PlansListView_Ctrl_Test{
   static testMethod void PlansListView_Ctrlmethod(){
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
     Plantype__c pt = new Plantype__c();
     pt.Barcolor__c='#11000';
     pt.Name = 'Zuri';
     System.assertEquals('Zuri',pt.name);
     insert pt;
     
     Project__c objPrj = new Project__c ();
     objPrj.Name='ITC';
     objPrj.Plantype__c= pt.Id;
     objPrj.Ends_date__c = system.toDay().addDays(3);
     objPrj.Starts_date__c= system.toDay();
     objPrj.Status__c = 'In Progress';
     objPrj.ownerid=plm.userid__c;
     System.assertEquals('ITC', objPrj.name);         
     insert objPrj;
    musqot__Activity__c m1 =new musqot__Activity__c();
    m1.musqot__keycode__c='emyJg-lemki-hP1Ce-wxaTb';
    m1.musqot__Use_Allocation__c=true;
    m1.musqot__Use_Budget__c=true;
    m1.musqot__Use_Finance1__c=true;
    m1.Plan_access_controll__c=false;
    m1.musqot__Use_Forcasting__c=true;
    m1.musqot__Use_milestones__c=true;
    m1.musqot__Use_Resource__c=true;
    System.assertEquals('emyJg-lemki-hP1Ce-wxaTb', m1.musqot__keycode__c);
    insert m1;
     
      PageReference pageRef = Page.PlansListViewpage;  
      Test.setCurrentPage(pageRef);

     ApexPages.currentPage().getParameters().put('plnId',objPrj.id); 
     ApexPages.StandardController sc = new ApexPages.standardController(objPrj);
     PlansListView_Ctrl objPln= new PlansListView_Ctrl();
     objPln.redirectPlanpage();
     objPln.gotoPlanDetail();
     objPln.gotoPlanDetailResp();
     objPln.getPlanRecs();     
     }
  static testMethod void PlansListView_Ctrlmethod1(){
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
     Plantype__c pt = new Plantype__c();
     pt.Barcolor__c='#11000';
     pt.Name = 'Zuri';
     System.assertEquals('Zuri',pt.name);
     insert pt;
   
     Project__c objPrj = new Project__c ();
     objPrj.Name='ITC';
     objPrj.Plantype__c= pt.Id;
     objPrj.Ends_date__c = system.toDay().addDays(3);
     objPrj.Starts_date__c= system.toDay();
     objPrj.Status__c = 'In Progress';
     objPrj.ownerid=plm.userid__c;
     System.assertEquals('ITC', objPrj.name);         
     insert objPrj;
     
      PageReference pageRef = Page.PlansListViewpage;  
      Test.setCurrentPage(pageRef);
      //list<musqot__Activity__c >act=[SELECT id from musqot__Activity__c WHERE id=:objAct.id limit 1];
     ApexPages.currentPage().getParameters().put('plnId',objPrj.id); 
     ApexPages.StandardController sc = new ApexPages.standardController(objPrj);
     PlansListView_Ctrl objPln= new PlansListView_Ctrl();
     objPln.redirectPlanpage();
     objPln.gotoPlanDetail();
     objPln.getPlanRecs();
     }
}