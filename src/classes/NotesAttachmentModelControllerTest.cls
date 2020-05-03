/**********************************************************************
Class Name: NotesAttachmentModelControllerTest
Author:chaithanya daggumati           Last modified by:G Janardhanreddy 
Date:22/7/2014                         Date: 30/1/2015 
********©2013 Musqot marketing technology Pvt ltd ********************/
@isTest
public class NotesAttachmentModelControllerTest{
    static testMethod void NotesAttachment(){
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
        
        List<workspace__c> objattachList = new List<workspace__c> ();
        Plantype__c pt = new Plantype__c();
        pt.Barcolor__c = '6E766F';
        pt.Name = 'Zuri';
        System.assertEquals('Zuri',pt.Name);
        insert pt;

        Project__c prj = new Project__c ();
        prj.Name='ITC';
        prj.Plantype__c= pt.Id;
        prj.Ends_date__c = system.toDay().addDays(3);
        prj.Starts_date__c= system.toDay();
        prj.Status__c = 'In Progress';
        prj.OwnerId=plm.userid__c;
        System.assertEquals('ITC',prj.Name);        
        insert prj;
        
        workspace__c objattach = new workspace__c(); 
        objattach .Name = 'testname';
        //objattach .Description__c = 'desc';
        objattach .ProjectName__c = prj.id;
        //objattach .subproject__c = 'testsubname';
        System.assertEquals('testname',objattach .Name);
        objattachList.add(objAttach);
        //System.assertEquals('testname', objattach .name);
        insert objattach ; 
        ApexPages.currentPage().getParameters().put('id', objattach .id);
        ApexPages.StandardController sc = new ApexPages.standardController(objattach );
        test.startTest();
        
        NotesAttachmentModelController nattach = new NotesAttachmentModelController (sc);  
        List<NoteAndAttachMent>  temp=nattach.modelList;   
        
    }
}