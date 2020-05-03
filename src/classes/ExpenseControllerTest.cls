/*******************************************************
Class Name: EmailUpdateByOwnerTest
Author:G Janarhanreddy     Last modified by:G Janarhanreddy
Date: 23/7/2014            Date:19/03/2015
********©2013 Musqot marketing technology Pvt ltd *******/
@isTest
public class ExpenseControllerTest{
    static testMethod void Expense(){
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
        Members__c objmember = new Members__c();
        objmember .User_Email__c = 'testrec';              
        System.assertEquals('testrec', objmember .User_Email__c);
        insert objmember ;
        
        Subproject__c objsubproj = new Subproject__c();
        objsubproj .name = 'testname';            
        objsubproj .Description__c = 'sampdesc';
        objsubproj .Starts_date__c =  System.now().date();
        objsubproj .Ends_date__c =  System.now().date();    
        System.assertEquals('testname', objsubproj .name);
        insert objsubproj ;
        
        Project__c prj = new Project__c ();
        prj.Name='ITC';
        //prj.Plantype__c= pt.Id;
        prj.Ends_date__c = system.toDay().addDays(3);
        prj.Starts_date__c= system.toDay();
        prj.Status__c = 'In Progress';
        prj.ownerid =plm.userid__c;
        System.assertEquals('ITC', prj.name);         
        insert prj;
        
        ApexPages.currentPage().getParameters().put('id', objmember .id);
        
    //    PageReference pageRef = Page.Exception;
     //   Test.setCurrentPage(pageRef); 
        ApexPages.StandardController sc = new ApexPages.standardController(objmember ); 
        test.starttest();
        ExpenseController expcont1 = new ExpenseController();                           
        ExpenseController expcont = new ExpenseController(sc);     
        //expcont.Save();
        // expcont.cancel();        
        test.stopTest();        
    }
    static testMethod void Expense1(){ 
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
        Members__c objmember = new Members__c();
        objmember .User_Email__c = 'testrec';              
        System.assertEquals('testrec', objmember .User_Email__c);
        insert objmember ;
        
        Members__c  member = [Select Id, Name, ProjMembers__c, ProjUsers__c, SubProjMembers__c, Role__c, User_Email__c FROM Members__c  where Id=:objmember.id];
        update member;
        Subproject__c objsubproj = new Subproject__c();
        objsubproj .name = 'testname';            
        objsubproj .Description__c = 'sampdesc';
        objsubproj .Starts_date__c =  System.now().date();
        objsubproj .Ends_date__c =  System.now().date();    
        System.assertEquals('testname', objsubproj .name);
        insert objsubproj ;
        
        Project__c prj = new Project__c ();
        prj.Name='ITC';
        //prj.Plantype__c= pt.Id;
        prj.Ends_date__c = system.toDay().addDays(3);
        prj.Starts_date__c= system.toDay();
        prj.Status__c = 'In Progress';
        prj.ownerid =plm.userid__c;
        System.assertEquals('ITC', prj.name);         
        insert prj;
        test.starttest();
       // PageReference pageRef = Page.Exception;
      //  Test.setCurrentPage(pageRef); 
        ApexPages.currentPage().getParameters().put('Projectid', prj.id);
        ApexPages.currentPage().getParameters().put('SubProjectid', objsubproj .id);
        ApexPages.StandardController sc = new ApexPages.standardController(prj); 
        ApexPages.StandardController sc1 = new ApexPages.standardController(objsubproj ); 
        ExpenseController expcont1 = new ExpenseController();                           
        ExpenseController expcont = new ExpenseController(sc);   
        try{
            expcont .Save();
        }catch(Exception e){
          //  system.debug('exception caught');
        }
        expcont.cancel();
        
        // expcont .Save();
        // expcont.cancel();        
        test.stopTest();        
    }
     static testMethod void Expense2(){
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
        Members__c objmember = new Members__c();
        objmember .User_Email__c = 'testrec';              
        System.assertEquals('testrec', objmember .User_Email__c);
        insert objmember ;
        
        Members__c  member = [Select Id, Name, ProjMembers__c, ProjUsers__c, SubProjMembers__c, Role__c, User_Email__c FROM Members__c  where Id=:objmember.id];
        update member;
        Subproject__c objsubproj = new Subproject__c();
        objsubproj .name = 'testname';            
        objsubproj .Description__c = 'sampdesc';
        objsubproj .Starts_date__c =  System.now().date();
        objsubproj .Ends_date__c =  System.now().date();    
        System.assertEquals('testname', objsubproj .name);
        insert objsubproj ;
        
        Project__c prj = new Project__c ();
        prj.Name='ITC';
        //prj.Plantype__c= pt.Id;
        prj.Ends_date__c = system.toDay().addDays(3);
        prj.Starts_date__c= system.toDay();
        prj.Status__c = 'In Progress';
        prj.ownerid =plm.userid__c;
        System.assertEquals('ITC', prj.name);         
        insert prj;
        test.starttest();
        PageReference pageRef = Page.ProjectDetails;
        Test.setCurrentPage(pageRef); 
        ApexPages.currentPage().getParameters().put('Projectid', prj.id);
        ApexPages.currentPage().getParameters().put('SubProjectid', objsubproj .id);
        ApexPages.StandardController sc = new ApexPages.standardController(prj); 
        ApexPages.StandardController sc1 = new ApexPages.standardController(objsubproj ); 
        ExpenseController expcont1 = new ExpenseController();                           
        ExpenseController expcont = new ExpenseController(sc1);   
        try{
            expcont .Save();
        }catch(Exception e){
          //  system.debug('exception caught');
        }
        expcont.cancel();
        
        // expcont .Save();
        // expcont.cancel();        
        test.stopTest();        
    }
}