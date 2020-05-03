/********************************************************
Class Name: MusqotUtiliyyTest
Author:Hussain           Last modified by:Raju GN
Date: 05/05/2015         Date:23/12/2015
********©2013 Musqot marketing technology Pvt ltd *******/
@isTest(seeAllData=true)
Public class MusqotUtilityTest{
    static testMethod void TestMusqotUtilityPlan(){
          Profile p=[SELECT Id ,Name From Profile WHERE name='System Administrator'];
          User u2 =new User( Alias = 'newUser1' ,
          Email ='newuser123@testorg.com',
          EmailEncodingKey = 'UTF-8',
          LastName = 'Testing',
          LanguageLocaleKey='en_US',
          LocaleSidKey='en_US', 
          UserName='newuser1234@testorg.com',
          ProfileId=p.Id,
          TimeZoneSidKey    = 'America/Los_Angeles');
          insert u2;  
          
          musqot__Costcentre__c objCC=new musqot__Costcentre__c(); 
          objCC.Name='test';
          objCC.musqot__cc_Owner__c=u2.id;
          objCC.musqot__Headline__c='musqotCostcenter';
          insert objCC;
          System.assertEquals('test', objCC.name);  
         
        Project__c project = new Project__c ();
        project.Name='ITC';             
        project.Starts_date__c= system.toDay();
        project.Ends_date__c = system.toDay().addDays(3);
        project.Status__c = 'In Progress'; 
        insert project;
        system.assertEquals('ITC',project.Name);        
        
        Members__c member = new Members__c();
        member.ProjMembers__c = project.Id;
        member.musqot__ProjUsers__c=u2.id;
        member.musqot__ProjMembers__c=project.id;
        member.Role__c = 'Owner';
        insert member;
        
        Allocation_amount__c allocAmount = new Allocation_amount__c();
        allocAmount.Allocated__c = 200.00;
        allocAmount.To_Plan__c = project.Id; 
        allocAmount.musqot__Costcentre__c= objCC.id;     
        insert allocAmount;
       
        musqot__Activity__c objAct=new musqot__Activity__c ();
        objAct.Name='test';
        objAct.musqot__Use_Allocation__c=true;
        objAct.musqot__Use_Forcasting__c=true;
        objAct.musqot__Use_milestones__c=true;
        insert objAct;
        
        musqot__Profilelist__c profileList=new musqot__Profilelist__c ();
        profileList.Name='System Administrator1';
        profileList.musqot__profilename__c='System Administrator';
        insert profileList;
        
        musqot__Permissionlist__c permisionCs=new musqot__Permissionlist__c();
        permisionCs.Name='Permissionlist1';
        permisionCs.musqot__Permissionlistname__c='Musqot admine';
        insert permisionCs;
        
        MusqotUtility.innerClass inr1 = new MusqotUtility.innerClass(true,true,true,true,true);
        MusqotUtility.securitySetting(project.Id);
        //MusqotUtility.getFieldMetaData();
        //MusqotUtility.unshift('test',10);
    }
     static testMethod void TestMusqotUtilityPlan1(){
         
          UserLicense UL=[SELECT Id, Name FROM UserLicense where Name='Salesforce'];
          Profile p=[SELECT Id ,Name From Profile WHERE UserLicenseId=:ul.id limit 1];
          User u2 =new User( Alias = 'newUser1' ,
          Email ='newuser123@testorg.com',
          EmailEncodingKey = 'UTF-8',
          LastName = 'Testing',
          LanguageLocaleKey='en_US',
          LocaleSidKey='en_US', 
          UserName='newuser1234@testorg.com',
          ProfileId=p.Id,
          TimeZoneSidKey = 'America/Los_Angeles');
          insert u2;  
           
         // PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Musqot_admin_sf' AND UserLicenseId=:UL.id];
        
          musqot__Costcentre__c objCC=new musqot__Costcentre__c(); 
          objCC.Name='test';
          objCC.musqot__cc_Owner__c=u2.id;
           objCC.musqot__Headline__c='musqotCostcenter';
          insert objCC;
          System.assertEquals('test', objCC.name);  
         
        Project__c project = new Project__c ();
        project.Name='ITC';             
        project.Starts_date__c= system.toDay();
        project.Ends_date__c = system.toDay().addDays(3);
        project.Status__c = 'In Progress'; 
        insert project;
        system.assertEquals('ITC',project.Name);        
        
        Subproject__c subProject = new Subproject__c();         
        subProject.Name='ITC Project';             
        subProject.Starts_date__c= system.toDay();
        subProject.Ends_date__c = system.toDay().addDays(3);
        subProject.Status__c = 'In Progress'; 
        subProject.Parent_project__c = project.Id; 
        insert subProject; 
        
        Allocation_amount__c allocAmount = new Allocation_amount__c();
        allocAmount.Allocated__c = 200.00;
        allocAmount.To_Plan__c = subProject.Parent_project__c ; 
        allocAmount.musqot__Costcentre__c= objCC.id;     
        insert allocAmount; 
         
        musqot__Permissionlist__c permisionCs=new musqot__Permissionlist__c();
        permisionCs.Name='Permissionlist1';
        permisionCs.musqot__Permissionlistname__c='Musqot admine';
        insert permisionCs;
        
        Members__c member = new Members__c();
        member.ProjMembers__c = project.Id;
        member.musqot__ProjUsers__c=u2.id;
        member.musqot__ProjMembers__c=project.id;
        member.Role__c = 'member';
        insert member;
        
        musqot__Activity__c m1 =new musqot__Activity__c();
        m1.musqot__keycode__c='212';
        m1.musqot__Use_Allocation__c=true;
        m1.musqot__Use_Budget__c=true;
        m1.musqot__Use_Finance1__c=true;
        m1.musqot__Use_Forcasting__c=true;
        m1.musqot__Use_milestones__c=true;
        m1.musqot__Use_Resource__c=true;
        insert m1;
        
        MusqotUtility.innerClass inr1 = new MusqotUtility.innerClass(true,true,true,true,true);
        MusqotUtility.securitySetting(project.Id); MusqotUtility.fileType('contentType');
        MusqotUtility.charOf(9);
        MusqotUtility.valueOf('ch');
        MusqotUtility.getEdition('edChar');
        MusqotUtility.unmask('c','c2');
        MusqotUtility.decryptKeycode('keycode');
        
        
    }
    static testMethod void TestMusqotUtilitySub(){
        
        Profile p=[SELECT Id From Profile WHERE Name='Musqot admin'];
          User u2 =new User( Alias = 'newUser1' ,
          Email ='newuser123@testorg.com',
          EmailEncodingKey = 'UTF-8',
          LastName = 'Testing',
          LanguageLocaleKey='en_US',
          LocaleSidKey='en_US', 
          UserName='newuser1234@testorg.com',
          ProfileId=p.Id,
          TimeZoneSidKey    = 'America/Los_Angeles');
          insert u2;  
          
        Project__c project = new Project__c ();
        project.Name='ITC';             
        project.Starts_date__c= system.toDay();
        project.Ends_date__c = system.toDay().addDays(3);
        project.Status__c = 'In Progress';         
        insert project;
        system.assertEquals('ITC',project.Name);        
        
        Subproject__c subProject = new Subproject__c();         
        subProject.Name='ITC Project';             
        subProject.Starts_date__c= system.toDay();
        subProject.Ends_date__c = system.toDay().addDays(3);
        subProject.Status__c = 'In Progress'; 
        subProject.Parent_project__c = project.Id; 
        insert subProject;   
        
        Members__c member = new Members__c();
        member.SubProjMembers__c = subProject.Id;
        member.ProjUsers__c = UserInfo.getUserId();
        member.Role__c = 'Member';
       // member.SubProjMembers__c = subproject.Id;
        insert member;
       
        musqot__Activity__c m1 =new musqot__Activity__c();
        m1.musqot__keycode__c='212';
        m1.musqot__Use_Allocation__c=true;
        m1.musqot__Use_Budget__c=true;
        m1.musqot__Use_Finance1__c=true;
        m1.musqot__Use_Forcasting__c=true;
        m1.musqot__Use_milestones__c=true;
        m1.musqot__Use_Resource__c=true;
        insert m1;
        
        musqot__Costcentre__c objCC=new musqot__Costcentre__c(); 
        objCC.Name='test';
        objCC.musqot__cc_Owner__c=u2.id;
        objCC.musqot__Headline__c='musqotCostcenter';
        insert objCC;
        System.assertEquals('test', objCC.name);  
        
        Allocation_amount__c allocAmount = new Allocation_amount__c();
        allocAmount.Allocated__c = 200.00;
        allocAmount.To_Plan__c = project.Id; 
        allocAmount.musqot__Costcentre__c= objCC.id;     
        insert allocAmount;      
        MusqotUtility.innerClass inr2 = new MusqotUtility.innerClass(true,true,true,true,true);
        MusqotUtility.securitySettingSub(subProject.Id);
        MusqotUtility.fileType('contentType');
        MusqotUtility.charOf(9);
        MusqotUtility.valueOf('ch');
        MusqotUtility.getEdition('edChar');
        MusqotUtility.unmask('c','c2');
        MusqotUtility.decryptKeycode('keycode');
      
    }
    static testMethod void TestMusqotUtilityMarketing(){
        Profile p=[SELECT Id From Profile WHERE Name='Musqot user'];
          User u2 =new User( Alias = 'newUser1' ,
          Email ='Musqotuser1@testorg.com',
          EmailEncodingKey = 'UTF-8',
          LastName = 'mus',
          LanguageLocaleKey='en_US',
          LocaleSidKey='en_US', 
          UserName='Musqotuser1@testorg.com',
          ProfileId=p.Id,
          TimeZoneSidKey    = 'America/Los_Angeles');
          insert u2; 
          
        Project__c project = new Project__c ();
        project.Name='ITC';             
        project.Starts_date__c= system.toDay();
        project.Ends_date__c = system.toDay().addDays(3);
        project.Status__c = 'In Progress';         
        insert project;
        system.assertEquals('ITC',project.Name);        
        
        Subproject__c subProject = new Subproject__c();         
        subProject.Name='ITC Project';             
        subProject.Starts_date__c= system.toDay();
        subProject.Ends_date__c = system.toDay().addDays(3);
        subProject.Status__c = 'In Progress'; 
        subProject.Parent_project__c = project.Id; 
        insert subProject;
        
        Marketing_activity__c marketingactivity =new Marketing_activity__c();
        marketingactivity.Name='hs mark';
        marketingactivity.Description__c='Nothing';
        marketingactivity.Status__c='completed';         
        marketingactivity.Starts_date__c = system.today();
        marketingactivity.Ends_date__c= system.today();
        marketingactivity.Plan__c= project.Id; 
        marketingactivity.Project__c = subproject.Id;  
        insert marketingactivity;       
        
        Members__c member = new Members__c();
        member.Marketingmebers__c = marketingactivity.Id;
        member.ProjUsers__c = UserInfo.getUserId();
        member.Role__c = 'Member';
       // member.SubProjMembers__c = subproject.Id;
        insert member;
        
        musqot__Costcentre__c objCC=new musqot__Costcentre__c(); 
        objCC.Name='ccbangalore';
        objCC.musqot__cc_Owner__c=u2.id;
        objCC.musqot__Headline__c='ccus';
        insert objCC;
        System.assertEquals('ccbangalore', objCC.name);
         
        Allocation_amount__c allocAmount = new Allocation_amount__c();
        allocAmount.Allocated__c = 200.00;
        allocAmount.To_Plan__c = project.Id;       
        insert allocAmount;
        
        musqot__Activity__c m1 =new musqot__Activity__c();
        m1.musqot__keycode__c='212';
        m1.musqot__Use_Allocation__c=true;
        m1.musqot__Use_Budget__c=true;
        m1.musqot__Use_Finance1__c=true;
        m1.musqot__Use_Forcasting__c=true;
        m1.musqot__Use_milestones__c=true;
        m1.musqot__Use_Resource__c=true;
        insert m1;
        MusqotUtility.innerClass inr3 = new MusqotUtility.innerClass(true,true,true,true,true);
        MusqotUtility.markertsecuritySetting(marketingactivity.Id);
        MusqotUtility.fileType('contentType');
        MusqotUtility.charOf(9);
        MusqotUtility.valueOf('ch');
        MusqotUtility.getEdition('edChar');
        MusqotUtility.unmask('c','c2');
        MusqotUtility.decryptKeycode('keycode');
        //MusqotUtility.unshift('c','k');
    } 
  static testMethod void TestMusqotUtilitycoscenter(){		
    	Profile p=[SELECT Id From Profile WHERE Name='Musqot user'];
          User u2 =new User( Alias = 'newUser1' ,Email ='Musqotuser1@testorg.com',EmailEncodingKey = 'UTF-8',
          LastName = 'mus',LanguageLocaleKey='en_US',LocaleSidKey='en_US', UserName='Musqotuser1@testorg.com',
          ProfileId=p.Id,TimeZoneSidKey= 'America/Los_Angeles');
          insert u2; 
      	musqot__Costcentre__c objCC=new musqot__Costcentre__c(); 
        objCC.Name='ccmusqot';
        objCC.musqot__cc_Owner__c=u2.id;
        objCC.musqot__Headline__c='ccus';
        insert objCC;
        System.assertEquals('ccmusqot', objCC.name);
         
        Allocation_amount__c allocAmount = new Allocation_amount__c();
        allocAmount.Allocated__c = 200.00;
        allocAmount.Costcentre__c = objCC.Id;       
        insert allocAmount;
        System.assertEquals(200.00, allocAmount.Allocated__c);
        MusqotUtility.innerClass inr4 = new MusqotUtility.innerClass(true,true,true,true,true);
        MusqotUtility.securitySettingcoscenter(objCC.Id);
  	}
}