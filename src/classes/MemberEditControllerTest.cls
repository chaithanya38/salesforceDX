/*******************************************************
Class Name: MemberEditControllerTest
Author:Chaithanya daggumati        Last modified by: Chaithanya daggumati
Date :25/8/2014                   Date : 19/3/2105                    
********©2013 Musqot marketing technology Pvt ltd *******/

@isTest(seeAllData=true)
    public class MemberEditControllerTest{
    static testMethod void MemberEditController(){
    
    Members__c objmemberedit = new Members__c();
    objmemberedit .User_Email__c = 'test';
    //objmemberedit .Email_del__c = 'test';
    System.assertEquals('test', objmemberedit .User_Email__c);
    insert objmemberedit ; 
    
    ApexPages.currentPage().getParameters().put('id', objmemberedit.id);
    ApexPages.currentPage().getParameters().put('mbrId', objmemberedit.id);
    ApexPages.StandardController sc = new ApexPages.standardController(objmemberedit );
    
    MemberEditController memeditcont = new MemberEditController(sc);
    memeditcont.Save();
    memeditcont.deleteMember();
     memeditcont.mbrRole='test';
    memeditcont.Cancel();  
    }    
static testMethod void MemberEditController1(){
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
    Plantype__c pt = new Plantype__c();
    pt.Barcolor__c = '6E766F';
    pt.Name = 'Zuri';
    System.assertEquals('Zuri', pt.name);
    insert pt;
    
    Project__c prj = new Project__c ();
    prj.Name='ITC';
    prj.Plantype__c= pt.Id;
    prj.Ends_date__c = system.toDay().addDays(3);
    prj.Starts_date__c= system.toDay();
    prj.Status__c = 'In Progress';
    prj.OwnerId=plm.musqot__userid__c;
    System.assertEquals('ITC', prj.name);         
    insert prj;
    
    Project_type__c prjType = new Project_type__c();
    prjType.Name = 'Business';
    prjType.Color__c = 'FFFF01';
    System.assertEquals('Business', prjType.name);
    insert prjType; 
    
    Subproject__c subPrj = new Subproject__c();         
    subPrj.Name='ITC Project';
    subPrj.Parent_project__c = prj.Id;
    subPrj.Ends_date__c = system.toDay().addDays(3);
    subPrj.Starts_date__c= system.toDay();
    subPrj.Status__c = 'In Progress'; 
    subPrj.Project_type__c = prjType.Id;
    System.assertEquals('ITC Project', subPrj.name);     
    insert subPrj;       
    
    Members__c objmemberedit = new Members__c();
    objmemberedit .User_Email__c = 'test';
    //objmemberedit .Email_del__c = 'test';
    objmemberedit.ProjMembers__c = prj.Id;
    System.assertEquals('test', objmemberedit.User_Email__c);
    insert objmemberedit ;     
    
    ApexPages.currentPage().getParameters().put('planid', prj.id);
    ApexPages.currentPage().getParameters().put('mbrId', objmemberedit.id);
    ApexPages.StandardController sc = new ApexPages.standardController(objmemberedit );
    test.startTest();
    MemberEditController memeditcont = new MemberEditController(sc);
    memeditcont.Save();
    memeditcont.deleteMember();
     memeditcont.mbrRole='test';
    memeditcont.Cancel();    
    }    
 static testMethod void MemberEditController2(){
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
    Plantype__c pt = new Plantype__c();
    pt.Barcolor__c = '6E766F';
    pt.Name = 'Zuri';
    System.assertEquals('Zuri', pt.name);
    insert pt;
    
    Project__c prj = new Project__c ();
    prj.Name='ITC';
    prj.Plantype__c= pt.Id;
    prj.Ends_date__c = system.toDay().addDays(3);
    prj.Starts_date__c= system.toDay();
    prj.Status__c = 'In Progress';
    prj.OwnerId=plm.musqot__userid__c;
    System.assertEquals('ITC', prj.name);         
    insert prj;
    
    Project_type__c prjType = new Project_type__c();
    prjType.Name = 'Business';
    prjType.Color__c = 'FFFF01';
    System.assertEquals('Business', prjType.name);
    insert prjType; 
    
    Subproject__c subPrj = new Subproject__c();         
    subPrj.Name='ITC Project';
    subPrj.Parent_project__c = prj.Id;
    subPrj.Ends_date__c = system.toDay().addDays(3);
    subPrj.Starts_date__c= system.toDay();
    subPrj.Status__c = 'In Progress'; 
    subPrj.Project_type__c = prjType.Id;
    System.assertEquals('ITC Project', subPrj.name);     
    insert subPrj;       
    
    Members__c objmemberedit = new Members__c();
    objmemberedit .User_Email__c = 'test';
    //objmemberedit .Email_del__c = 'test';
    objmemberedit.SubProjMembers__c = subprj.Id;
    System.assertEquals('test', objmemberedit .User_Email__c);
    insert objmemberedit ;    
    
    ApexPages.currentPage().getParameters().put('subid', subPrj.id);
    ApexPages.currentPage().getParameters().put('mbrId', objmemberedit.id);
    ApexPages.StandardController sc = new ApexPages.standardController(objmemberedit );
    test.startTest();
    MemberEditController memeditcont = new MemberEditController(sc);
    memeditcont.Save();
    memeditcont.deleteMember();
     memeditcont.mbrRole='test';
    memeditcont.Cancel();  
 	}  
  static testMethod void MemberEditController3(){
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
    Plantype__c pt = new Plantype__c();
    pt.Barcolor__c = '6E766F';
    pt.Name = 'Zuri';
    System.assertEquals('Zuri', pt.name);
    insert pt;
    
    Project__c prj = new Project__c ();
    prj.Name='ITC';
    prj.Plantype__c= pt.Id;
    prj.Ends_date__c = system.toDay().addDays(3);
    prj.Starts_date__c= system.toDay();
    prj.Status__c = 'In Progress';
    prj.OwnerId=plm.musqot__userid__c;
    System.assertEquals('ITC', prj.name);         
    insert prj;
    
    Project_type__c prjType = new Project_type__c();
    prjType.Name = 'Business';
    prjType.Color__c = 'FFFF01';
    System.assertEquals('Business', prjType.name);
    insert prjType; 
    
    Subproject__c subPrj = new Subproject__c();         
    subPrj.Name='ITC Project';
    subPrj.Parent_project__c = prj.Id;
    subPrj.Ends_date__c = system.toDay().addDays(3);
    subPrj.Starts_date__c= system.toDay();
    subPrj.Status__c = 'In Progress'; 
    subPrj.Project_type__c = prjType.Id;
    System.assertEquals('ITC Project', subPrj.name);     
    insert subPrj;    
    
    Marketing_activity__c objMarketingact=new Marketing_activity__c();
    objMarketingact.Name='test';
    objMarketingact.Description__c='tdescriptionest';
    objMarketingact.Status__c='completed';
    System.assertEquals('test', objMarketingact.name);
    insert objMarketingact;
    
    
    Members__c objmemberedit = new Members__c();
    objmemberedit .User_Email__c = 'test';
    //objmemberedit .Email_del__c = 'test';
    objmemberedit.SubProjMembers__c = subprj.Id;
    System.assertEquals('test', objmemberedit .User_Email__c);
    insert objmemberedit ;    
    
    ApexPages.currentPage().getParameters().put('mrk', objMarketingact.id);
    ApexPages.currentPage().getParameters().put('mbrId', objmemberedit.id);
    ApexPages.StandardController sc = new ApexPages.standardController(objMarketingact );
    
    MemberEditController memeditcont = new MemberEditController(sc);
    memeditcont.Save();
    memeditcont.deleteMember();
   memeditcont.mbrRole='test';
    
    memeditcont.Cancel();  
    }    
}