/*******************************************************
Class Name: MemberControllerTest
Author:Nagaraju         Last modified by: Chaithanya reddy
Date :19/7/2014         Date : 19/3/2105                    
********©2013 Musqot marketing technology Pvt ltd *******/

@isTest(seeAllData=true)
public class MemberControllerTest{
        
    static testMethod void MemberEditController1(){
        Profile p = [select id from profile where name='System Administrator']; 
        User objUser = new User(alias = 'stan', email='standarduser@test.com', 
                                emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
                                localesidkey='en_US', profileid = p.Id,
                                timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
        insert objUser ;
        
        Plantype__c pt = new Plantype__c();
        pt.Barcolor__c = '6E766F';
        pt.Name = 'Zuri';
        System.assertEquals('Zuri', pt.name);
        insert pt;
        Musqot_member__c plmr=new Musqot_member__c();
        plmr.musqot__userid__c=objUser.id;
        plmr.musqot__Role__c='Member';        
        plmr.User_type__c='Internal user';
        insert plmr;
        System.assertEquals('Member', plmr.Role__c);
        
        Project__c prj = new Project__c ();
        prj.Name='ITC';
        prj.Plantype__c= pt.Id;
        prj.Ends_date__c = system.toDay().addDays(3);
        prj.Starts_date__c= system.toDay();
        prj.Status__c = 'In Progress';
        prj.OwnerId=plmr.musqot__userid__c;
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
        
        Marketing_activity__c objmarkact = new Marketing_activity__c();
        objmarkact .Name = 'test';
        objmarkact .Description__c = 'sampledesc';
        objmarkact .Status_Image_Id__c  = 'test';
        System.assertEquals('test', objmarkact .name);     
        insert objmarkact ;    
        
        Members__c objmemberedit = new Members__c();
        objmemberedit .User_Email__c = 'test';
        //objmemberedit .Email_del__c = 'test';
        objmemberedit.ProjMembers__c = prj.Id;
        System.assertEquals('test', objmemberedit.User_Email__c);
        insert objmemberedit ;
        
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=objUser.id;
        plm.Marketing_activity__c=objmarkact.id;
        plm.Plan__c=prj.id;
        plm.project__c=subPrj.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
                 
        String tabId = System.currentPageReference().getParameters().get('tabId');
        ApexPages.currentPage().getParameters().put('planid', prj.id);
        ApexPages.currentPage().getParameters().put('mbrId', objmemberedit.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objmemberedit );
        MemberController objmem=new MemberController(sc);
        MemberController.WrapperClass memwrap = new MemberController.WrapperClass(plm,'eloperdev');
        memwrap.checked=true;
        
        objmem.Save();
        objmem.cancel();
        objmem.getRedirectToTemplate();
        objmem.redirectToTemplate();
        objmem.saveMember();
        objmem.allBool=true;
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
        
        Marketing_activity__c objmarkact = new Marketing_activity__c();
        objmarkact .Name = 'test';
        objmarkact .Description__c = 'sampledesc';
        objmarkact .Status_Image_Id__c  = 'test';
        System.assertEquals('test', objmarkact .name);     
        insert objmarkact ;       
        
        Members__c objmemberedit = new Members__c();
        objmemberedit .User_Email__c = 'test';
        //objmemberedit .Email_del__c = 'test';
        objmemberedit.SubProjMembers__c = subprj.Id;
        System.assertEquals('test', objmemberedit .User_Email__c);
        insert objmemberedit ;
        
        String tabId = System.currentPageReference().getParameters().get('tabId');
        ApexPages.currentPage().getParameters().put('subid', subPrj.id);
        ApexPages.currentPage().getParameters().put('mbrId', objmemberedit.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objmemberedit );
        MemberController objmem=new MemberController(sc);       
        objmem.Save();
        objmem.cancel();
        objmem.getRedirectToTemplate();
        objmem.redirectToTemplate();
        
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
        
        Marketing_activity__c objmarkact = new Marketing_activity__c();
        objmarkact .Name = 'test';
        objmarkact .Description__c = 'sampledesc';
        objmarkact .Status_Image_Id__c  = 'test';
        System.assertEquals('test', objmarkact .name);     
        insert objmarkact ;       
        
        Members__c objmemberedit = new Members__c();
        objmemberedit .User_Email__c = 'test';
        
        objmemberedit.SubProjMembers__c = subprj.Id;
        System.assertEquals('test', objmemberedit .User_Email__c);
        if(objmemberedit.ProjUsers__c!=null)
        {
            insert objmemberedit ;    
        }
        ApexPages.currentPage().getParameters().put('mrk', objmarkact .id);
        String tabId = System.currentPageReference().getParameters().get('tabId');
        ApexPages.currentPage().getParameters().put('mbrId', objmemberedit.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objmemberedit );
        MemberController objmem=new MemberController(sc);
        Members__c mbrList = [select ID,Name,ProjUsers__c,ProjUsers__r.Name from Members__c where ProjMembers__c =:prj.id];
        insert objmemberedit;
        objmem.Save();
        objmem.cancel();
        objmem.getRedirectToTemplate();
        objmem.redirectToTemplate();        
            }

 static testMethod void Membersavetest(){
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
        Project__c prj = new Project__c ();
        prj.Name='ITC';        
        prj.Ends_date__c = system.toDay().addDays(3);
        prj.Starts_date__c= system.toDay();
        prj.Status__c = 'In Progress';
        prj.OwnerId=plm.musqot__userid__c;
        System.assertEquals('ITC', prj.name);         
        insert prj;
        Subproject__c subPrj = new Subproject__c();         
        subPrj.Name='ITC Project';
        subPrj.Parent_project__c = prj.Id;
        subPrj.Ends_date__c = system.toDay().addDays(3);
        subPrj.Starts_date__c= system.toDay();
        subPrj.Status__c = 'In Progress';         
        System.assertEquals('ITC Project', subPrj.name);     
        insert subPrj;
        Members__c objmemberedit = new Members__c();
        objmemberedit .User_Email__c = 'test';
        System.assertEquals('test', objmemberedit .User_Email__c);
        insert objmemberedit ;    
        
        ApexPages.currentPage().getParameters().put('planid',Prj.id);
        ApexPages.StandardController sc = new ApexPages.standardController(subPrj);
        MemberController mc=new MemberController(sc); 
        //mc.Save(); 
     } 
 static testMethod void Membersavetest1(){
        Subproject__c subPrj = new Subproject__c();         
        subPrj.Name='ITC Project';
        //subPrj.Parent_project__c = prj.Id;
        subPrj.Ends_date__c = system.toDay().addDays(3);
        subPrj.Starts_date__c= system.toDay();
        subPrj.Status__c = 'In Progress';         
        System.assertEquals('ITC Project', subPrj.name);     
        insert subPrj;
        
        Members__c objmemberedit = new Members__c();
        objmemberedit .User_Email__c = 'test';
        System.assertEquals('test', objmemberedit .User_Email__c);
        insert objmemberedit ;   
        Musqot_member__c plm=new Musqot_member__c();
        plm.project__c=subPrj.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm; 
        
        ApexPages.currentPage().getParameters().put('subid',subPrj.id);
        ApexPages.StandardController sc = new ApexPages.standardController(subPrj);
        MemberController.WrapperClass memwrap = new MemberController.WrapperClass(plm,'Development');
        memwrap.checked=true;
        MemberController mc=new MemberController(sc); 
        //mc.Save(); 
       } 
}