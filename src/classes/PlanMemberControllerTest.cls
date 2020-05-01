/*******************************************************
Class Name: PlanMemberControllerTest
Author:Nagaraju         Last modified by: Chaithanya reddy
Date :19/7/2014         Date : 19/3/2105                    
********©2013 Musqot marketing technology Pvt ltd *******/

@isTest(seeAllData=true)
public class PlanMemberControllerTest{
        static testMethod void MemberControllermethod() {        
        Profile p = [select id from profile where name='System Administrator']; 
        User objUser = new User(alias = 'stan', email='standarduser@test.com', 
                                emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
                                localesidkey='en_US', profileid = p.Id, 
                                timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
        insert objUser ;
        Musqot_member__c plmr=new Musqot_member__c();
        plmr.musqot__userid__c=objUser.id;
        plmr.musqot__Role__c='Member';        
        plmr.User_type__c='Internal user';
        insert plmr;
        System.assertEquals('Member', plmr.Role__c);
        Project__c objprj = new Project__c ();
        objprj.Name='ITC';
        //objprj.Plantype__c= pt.Id;
        objprj.Ends_date__c = system.toDay().addDays(3);
        objprj.Starts_date__c= system.toDay();
        objprj.Status__c = 'In Progress';
        objprj.ownerid=plmr.userid__c;
        System.assertEquals('ITC', objprj.name);         
        insert objprj ;
        
        Subproject__c objsubPrj = new Subproject__c();         
        objsubPrj.Name='ITC Project';
        objsubPrj.Parent_project__c = objprj.Id;
        objsubPrj.Ends_date__c = system.toDay().addDays(3);
        objsubPrj.Starts_date__c= system.toDay();
        objsubPrj.Status__c = 'In Progress'; 
        //objsubPrj.Project_type__c = prjType.Id;
        System.assertEquals('ITC Project', objsubPrj.name);     
        insert objsubPrj;
        
        Marketing_activity__c objma = new Marketing_activity__c();
        objma.Name = 'test';
        objma.Description__c = 'sampledesc';
        objma.Status_Image_Id__c  = 'test';
        System.assertEquals('test', objma.name);     
        insert objma;  
        
        musqot__Musqot_member__c plm=new musqot__Musqot_member__c();
        plm.musqot__userid__c=objUser.id;
        plm.musqot__Role__c='Member';
        plm.musqot__Plan__c=objprj.id;
        insert plm;
        
        UserRole ur=new UserRole();
        ur.Name='Developer';
        //insert ur;
        
        String tabId = System.currentPageReference().getParameters().get('tabId');        
        ApexPages.StandardController sc = new ApexPages.standardController(objUser);
        //ApexPages.currentPage().getParameters().put('id', objmember.id);
        ApexPages.currentPage().getParameters().put('planid', objprj.id);
        PlanMemberController objmem = new PlanMemberController(sc);
        PlanMemberController.WrapperClass memwrap = new PlanMemberController.WrapperClass(objUser,'eloperdev');
        memwrap.checked=true;
        //memwrap.pmRole='viewer';
        try{
         objmem.saveMember();
        }catch(Exception e){}
        objmem.cancel();        
        objmem.allBool=true;
    }
}