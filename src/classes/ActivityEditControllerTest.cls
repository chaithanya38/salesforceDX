/***********************************************************
Class Name: ActivityEditControllerTest
Author: Nagaraju G         Last modified by:G Janardhanreddy 
Date  :  18/7/2014            Date:18/03/2015
*************©2013 Musqot marketing technology Pvt ltd ******/
@isTest(seeAllData=true)
public class ActivityEditControllerTest{
     static testmethod void Activitytest() {
     Profile p = [select id from profile where name='System Administrator']; 
        User objUser = new User(alias = 'stan', email='standarduser@test.com', 
                                emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
                                localesidkey='en_US', profileid = p.Id,
                                timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
        insert objUser ;
     
     Activitytype__c objActivitytype = new Activitytype__c();
     objActivitytype.Name='test';
     objActivitytype.Icon__c='testicon';
     objActivitytype.Bar_color__c ='red';
     System.assertEquals('test', objActivitytype.name);
     try{
     insert objActivitytype;
     }catch(exception e){}
	 
     Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=objUser.id;
        //plm.Plan__c=objproj.id;        
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('test', objActivitytype.name);
         
     Project__c objproj = new Project__c();
     objproj .Name = 'testrec';
     objproj .Plantype__c =  null;
     objproj .Starts_date__c = Date.Today();
     objproj .Ends_date__c= Date.Today();
     objproj .Status__c = 'testpick'; 
     objproj.Ownerid=plm.userid__c;
     System.assertEquals('testrec', objproj.name);
     insert objproj ;
     try{
     Activitytype__c act=new Activitytype__c ();
     act.Name='musqot';
     act.Bar_color__c  ='green';
     System.assertEquals ('green',act.Bar_color__c);
     act.Icon__c ='musqottech'; 
     act.F__c = null;          
     insert act;
           Activitytype__c act1=[select id,name,Bar_color__c,Icon__c,F__c  from Activitytype__c  Where Id =:objActivitytype.Id];
           update act1;
      
     }catch(exception e){}	 
     
     Activitytype__c OBJActivit= new Activitytype__c();
     OBJActivit.Name='test';
     OBJActivit.Icon__c='testicon';
     OBJActivit.Bar_color__c ='red';
     System.assertEquals('test', OBJActivit.name);
     try{
     insert OBJActivit;
     }catch(exception e){}
    //}
    test.startTest();
    PageReference pageRef = Page.ActivitytypesPage;
    Test.setCurrentPage(pageRef); 
     
    ApexPages.currentPage().getParameters().put('Plans.id',objActivitytype.id);
    ApexPages.StandardController sc = new ApexPages.standardController(objActivitytype);
     
     ActivityEditController objact1 = new ActivityEditController ();
     ActivityEditController objactt = new ActivityEditController (sc);
     //objactt.redirectPage1();
     objactt.LoadData();
     objactt.getPln(); 
     objactt.DeleteAccount(); 
     objactt.NewPrtype();
     objactt.Save();
     objactt.Cancel();
          try{
        objactt.redirectPage1();
    }catch(Exception e){
        system.debug('exception caught');
    }

     ActivityEditController.GetResourceURL('Sponsor');      
     
     test.stopTest();  
     
  }
}