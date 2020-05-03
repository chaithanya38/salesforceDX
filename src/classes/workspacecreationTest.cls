/********************************************************************
Class Name: workspacecreationTest 
Author:Janardhan reddy          Last modified by: Chaithanya daggumati
Date: 11/9/2014                 Date: 19/3/2015  
********©2013 Musqot marketing technology Pvt ltd ********************/
@isTest
public class workspacecreationTest{
    static testMethod void workspaceCreMethod()    {
        Profile p = [select id from profile where name='Musqot admin'];
        User u = new User();
        List<User> User = [select Id,Name from User where ProfileId =:p.Id];     
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
        subprj.Status_Image_Id__c='test';
        subPrj.Project_type__c = prjType.id;
        System.assertEquals('ITC Project', subPrj.name);     
        insert subPrj;
        
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact;        
        //objMarketingact.ownerid=u.id;
        objMarketingact.Name='testmarketing';
        Marketing_activity__c  OBJMRA=[select id,name from Marketing_activity__c where id=:objMarketingact.id limit 1];
        OBJMRA.name='testmarket';
        update OBJMRA;
        
        Workspace__c Wsp = New Workspace__c(); 
        wsp.name = subPrj.name;
        wsp.subproject__c= subPrj.id;
        wsp.description__C = subPrj.description__C;
        insert wsp;
        
        Members__c Mem    = New Members__c();
        Mem.ProjUsers__c  = objMarketingact.ownerid;
        Mem.Marketingmebers__c= objMarketingact.id;
        Mem.Role__c = 'Owner';
        Mem.Type__c = 'Internal User';
        System.assertEquals('Owner', Mem.Role__c);
        insert mem;
        Members__c member=[SELECT id,name,Role__c  FROM Members__c where id=:mem.id limit 1];
        member.Role__c ='Member';
        update member;
         
        Members__c OBJmem=[select id,Role__c ,Type__c  from Members__c where id=:mem.id limit 1]; 
        delete OBJmem;
        
        Account a= new Account();
        a.Name = 'testAcc1';
        a.AccountNumber = 'TestA00001';
        insert a;
        Account acc=[SELECT name FROM Account WHERE id=:a.id];
        acc.name='testAcc';
        update acc;
        
        List<musqot__Marketing_activity__c>  mark = new List<musqot__Marketing_activity__c> ();
        ApexPages.currentPage().getParameters().put('id',mem.id);
                
       }
                       
}