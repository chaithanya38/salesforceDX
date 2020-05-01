/**********************************************************
Class Name: PlanEditontrollerTest
Author:Nagaraju G            Last modified by:Janardhanreddy
Date: 11/9/2014              Date:24/03/2015 
********©2013 Musqot marketing technology Pvt ltd *********/

@isTest (seeAlldata=true)
    public class PlanEditontrollerTest{
    static testmethod void planEdittest(){
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
    plantype__c objplanty = new plantype__c();
    objplanty.Name='APAC'; 
    objplanty.Barcolor__c='red';
    objplanty.musqot__sort__c=1234;
    System.assertEquals('APAC', objplanty.Name);
    insert objplanty;
   
    Project__c objproject = new Project__c ();
    objproject.Name='test';
    objproject.Starts_date__c= System.now().date();
    objproject.Ends_date__c= System.now().date();
    objproject.musqot__Plantype__c=objplanty.id;
    objproject.musqot__Headline__c='Test';
    objproject.ownerid=plm.userid__c;
    System.assertEquals(System.now().date(), objproject.Ends_date__c);
    insert objproject;
    
    ApexPages.currentPage().getParameters().put('planid', objproject.id);
    ApexPages.StandardController sc = new ApexPages.standardController(objproject);
    PlanEditontroller ObjPLN= new PlanEditontroller(sc);
     PlanEditontroller ObjPLN1= new PlanEditontroller();
     
    test.startTest();
    List<SelectOption> temp=ObjPLN.PLANList;
    List<SelectOption> temp1=ObjPLN.SocialFilter;
    List<SelectOption> temp2=ObjPLN.ERPFilter;
    List<SelectOption> temp3=ObjPLN.CRMFilter;
    List<schema.fieldsetmember> temp4=ObjPLN.getFields();
    String[] plan=ObjPLN.ERPItems;
    String[] plan1=ObjPLN.CRMItems; 
    String[] plan2=ObjPLN.SocialItems;
    List<String> stringList = new List<String>{'string1','string2','string3'};
    ObjPLN.SocialItems= stringList;
    ObjPLN.CRMItems= stringList;
    ObjPLN.ERPItems= stringList;
    try{  
    ObjPLN.updPlan(); 
    objPLN.getFieldSet();
    objPLN.gotoEditMode();
    objPLN.gotoInfoMode();
    }catch(Exception e){}
    try{
    ObjPLN.getFieldsetList('string planeId');
     }catch(Exception e){}
    try{
    ObjPLN.cancel();
    }catch(Exception e){}
    ObjPLN.updPlan2();
    ObjPLN.cancel2();
    test.stopTest();    
   }
static testmethod void planupdate(){
    Project__c objproject = new Project__c ();
    objproject.Name='test';
    objproject.Starts_date__c= System.today()+7;
    objproject.Ends_date__c= System.today();
    objproject.musqot__Headline__c='Test';
    System.assertEquals(System.today(), objproject.Ends_date__c);
    insert objproject;
    
    ApexPages.currentPage().getParameters().put('planid', objproject.id);
    ApexPages.StandardController sc = new ApexPages.standardController(objproject);
    PlanEditontroller ObjPLN= new PlanEditontroller(sc);
    ObjPLN.updPlan();
    ObjPLN.updPlan2();
}
}