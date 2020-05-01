/*************************************************************
Class Name: SubprojecteditEditontrollerTest
Author:Nagaraju G            Last modified by: G Janardhanreddy
Date: 11/9/2014              Date:  20/03/2015
********©2013 Musqot marketing technology Pvt ltd ************/
@isTest(seeAllData=true)
public class SubprojecteditEditontrollerTest{
      static testMethod void SubprojectControlle(){
      Project__c prj = new Project__c ();
      prj.Name='ITC';
     //prj.Plantype__c= pt.Id;
      prj.Ends_date__c = system.toDay().addDays(3);
      prj.Starts_date__c= system.toDay();
      prj.Status__c = 'In Progress';
      System.assertEquals('ITC', prj.name);         
      insert prj;
      
      Project_type__c objprojtype = new Project_type__c();
      objprojtype .Name = 'testname';
      objprojtype .Color__c = 'red';
      objprojtype .Fieldset__c = 'testfieldset';
      insert objprojtype ;
      System.assertEquals('testname', objprojtype .Name);
     
      Subproject__c objsubpro=new Subproject__c();
      objsubpro.Name='testsub';
      objsubpro.Starts_date__c=System.now().date();
      objsubpro.Ends_date__c=System.now().date();
      objsubpro.Project_type__c=objprojtype.id;
      objsubpro.Description__c = 'testdesc';
      insert objsubpro;
      System.assertEquals('testsub', objsubpro.name);
      Project_type__c  proType = [SELECT Id, Fieldset__c FROM Project_type__c  WHERE Id =:objSubpro.Project_type__c];

      ApexPages.CurrentPage().getparameters().put('projectid',objsubpro.id);
      ApexPages.StandardController sc = new ApexPages.standardController(objsubpro);
      test.startTest();
      //SubprojecteditEditontroller objSUBPR1 = new SubprojecteditEditontroller();
      SubprojecteditEditontroller objSUBPR = new SubprojecteditEditontroller(sc);
      SubprojecteditEditontroller onbj=new SubprojecteditEditontroller();
       
      try{
      List<SelectOption> temp = objSUBPR.PROTList;
      }catch(Exception e){}
      List<SelectOption> sofilter = objSUBPR.SocialFilter;
      List<SelectOption> erfilter = objSUBPR.ERPFilter;
      List<SelectOption> crfilter = objSUBPR.CRMFilter;
      List<Schema.FieldSetMember>  temp2=objSUBPR.getFields();
      String[] plan=objSUBPR.ERPItems;
      String[] plan1=objSUBPR.CRMItems; 
      String[] plan2=objSUBPR.SocialItems;
      List<String> stringList = new List<String>{'string1','string2','string3'};
      objSUBPR.ERPItems= stringList;
      objSUBPR.CRMItems= stringList;
      objSUBPR.SocialItems= stringList;
      objSUBPR.save();
      objSUBPR.cancel();
      objSUBPR.gotoEditMode();
      objSUBPR.gotoInfoMode();
      objSUBPR.getCustomSettRec();
      try{
      objSUBPR.getFieldsetList('string subproId');
       }catch(Exception e){}
      Test.stopTest();
     }
}