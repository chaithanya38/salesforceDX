/**********************************************************************
Class Name: overview_creationsubTest
Author:G Janardhanreddy           Last modified by:chaithanya daggumati  
Date:11/9/2014                    Date: 6/1/2015 
********©2013 Musqot marketing technology Pvt ltd *********************/
@isTest(seeAlldata=true)
public class overview_creationsubTest
{
    static testMethod void overViewCreationSubtest()
    {
      	Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
        User u= new User(ProfileId = [select id from Profile where Name='System Administrator' limit 1].Id,
                         LanguageLocaleKey = 'en_US',LocaleSidKey = 'en_US',TimeZoneSidKey = 'America/Chicago',
                         EmailEncodingKey = 'UTF-8', LastName = 'Test User1',Alias = 'TestU1',Email = 'Testuser@gmail.com',Username = 'musqottester@gmail.com',CommunityNickname = 'TestUser 12345');
       insert u;
        
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=u.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
        
        Project__c objproject=new Project__c ();
        objproject.Name='testpro';
        objproject.Starts_date__c = Date.Today();
        objproject.Ends_date__c = Date.Today();
        objproject.Status__c = 'Completed';
        objproject.ownerid=plm.userid__c;
        System.assertEquals('testpro', objproject.name);
        insert objproject;
        update objproject;
        objproject.ownerid=u.id;
        
        Plantype__c pt = new Plantype__c();
        pt.Barcolor__c = '6E766F';
        pt.Name = 'Zuri';
        System.assertEquals('Zuri', pt.name);
        insert pt;
        
        Workspace__c Wsp = New Workspace__c(); 
        wsp.name = objproject.name;
        wsp.ProjectName__c= objproject.id;
        wsp.description__C = objproject.description__C;
        insert wsp;
        
        Subproject__c subPrj = new Subproject__c(); 
        subPrj.Name='ITC Project';
        subPrj.Parent_project__c = objproject.Id;
        subPrj.Ends_date__c = system.toDay().addDays(3);
        subPrj.Starts_date__c= system.toDay();
        subPrj.Status__c = 'In Progress'; 
        subprj.Status_Image_Id__c='test';
        System.assertEquals('ITC Project', subPrj.name);     
        insert subPrj;
      
        Subproject__c objsub=[select id,name from Subproject__c where id=:subPrj.id limit 1];
        objsub.name='mmtspro';
        update objsub; 
        Members__c Mem    = New Members__c();
        Mem.ProjUsers__c  = objproject.ownerid;
        Mem.ProjMembers__c = objproject.id;
        Mem.Role__c = 'Owner';
        insert mem; 
        Members__c objmem=[select id,name,Role__c from Members__c where id =:mem.id limit 1];  
        objmem.Role__c ='Member';
        update objmem;    
        
        Members__c Member    = New Members__c();
        Member.ProjUsers__c  = objproject.ownerid;
        Member.ProjMembers__c = objproject.id;
        Member.Role__c = 'member';
        insert Member;   
        
        Subproject__c subPrj1 = new Subproject__c(); 
        subPrj1.Name='ITC Project';
        subPrj1.Parent_project__c = objproject.Id;
        subPrj1.Ends_date__c = system.toDay().addDays(3);
        subPrj1.Starts_date__c= system.toDay();
        subPrj1.Status__c = 'In Progress'; 
        subprj1.Status_Image_Id__c='test';
        subprj1.musqot__Project_del__c=subPrj.id;
        System.assertEquals('ITC Project', subPrj1.name);     
        insert subPrj1;
        
        Musqot_member__c plm1=new Musqot_member__c();
        plm1.musqot__userid__c=u.id;
        plm1.musqot__Role__c='Member';        
        plm1.User_type__c='Internal user';
        insert plm1;
        System.assertEquals('Member', plm1.Role__c);
        
        List<User> newOwner = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND Id != :objproject.OwnerId AND IsActive= true];
        Project__c objpro=[select id,name from Project__c where id=:objproject.id];
        objpro.name='test';
        objpro.OwnerId = plm1.userid__c; 
        update objpro;
        Budget__c bud = new Budget__c();
        bud.Project__c = objproject.id;
        bud.Name = objproject.name;
        insert bud;
        
        Members__c objmember1=[select id,name,Role__c  from Members__c where id=:mem.id limit 1];
        objmember1.Role__c  ='member';
        update objmember1;
        
        Members__c objmember=[select id,name,Role__c  from Members__c where id=:mem.id limit 1];
        delete objmember; 
       
        }   
    }