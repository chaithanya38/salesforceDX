/****************************************************************
Class Name: HoursprojectpopupclsTest
Author:chaithanya daggumati      Last modified by:chaithanya daggumati
Date:14/04/2015                  Date:14/04/2015
********©2013 Musqot marketing technology Pvt ltd ***************/
@isTest(Seealldata = True)
public class HoursprojectpopupclsTest{
    static testMethod void Hoursprojectpopup(){
    Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
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
      Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=u2.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);   
      musqot__Costcentre__c objCC=new musqot__Costcentre__c(); 
      objCC.Name='test';
      objCC.musqot__cc_Owner__c=u2.id;
      objCC.musqot__Headline__c ='present';
      insert objCC;
      System.assertEquals('test', objCC.name);  
      
        project__c objpro=new project__c();
        objpro.Name='testt';
        objpro.Starts_date__c = Date.Today();
        objpro.Ends_date__c = Date.Today();
        objpro.Status__c = 'Completed';
        objpro.ownerid=plm.userid__c;
        System.assertEquals('testt', objpro.Name);
        insert objpro;
        
        Subproject__c objsubproj = new Subproject__c();
        objsubproj.Parent_project__c=objpro.id;
        objsubproj.Name = 'test';
        objsubproj.Starts_date__c = Date.Today();
        objsubproj.Ends_date__c= Date.Today();
        objsubproj.Status__c = 'Completed';
        System.assertEquals('test', objsubproj.Name);
        insert objsubproj;
        
        Allocation_resources__c  objAllocationhours = new Allocation_resources__c ();
        objAllocationhours.Name='testAllochours';
        objAllocationhours.Approved_houver__c=1;
        objAllocationhours.plan__c=objpro.id;
        objAllocationhours.musqot__Cost_center__c=objCC.Id;
        objAllocationhours.project__c=objsubproj.id;
        objAllocationhours.Approved_date__c=System.today();
        objAllocationhours.Request_date__c=System.today();
        objAllocationhours.Description__c='testDescription';
        objAllocationhours.Requested_hours__c=1;
        System.assertEquals('testAllochours', objAllocationhours.name);
        insert objAllocationhours; 
        
        musqot__Musqot_fiscal_year__c fiscalYearObj=new musqot__Musqot_fiscal_year__c();
        fiscalYearObj.name='2015';
        fiscalYearObj.musqot__Start_date__c=system.today();
        fiscalYearObj.musqot__End_date__c=system.today()+10;
        insert fiscalYearObj;
        
        musqot__Activity__c m1 =new musqot__Activity__c();
        m1.musqot__keycode__c='emyJg-lemki-hP1Ce-wxaTb';
        m1.musqot__Use_Allocation__c=true;
        m1.musqot__Use_Budget__c=true;
        m1.musqot__Use_Finance1__c=true;
        m1.musqot__Use_Forcasting__c=true;
        m1.musqot__Use_milestones__c=true;
        m1.musqot__Use_Resource__c=true;
        System.assertEquals('emyJg-lemki-hP1Ce-wxaTb', m1.musqot__keycode__c);
        insert m1;
        
        test.startTest(); 
        PageReference pageRef = Page.Hoursprojectpopup;
        Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getParameters().put('prjID', objsubproj.id);
        ApexPages.currentPage().getParameters().put('id', objsubproj.id);
        ApexPages.currentPage().getParameters().put('ccId',objCC.Id);
        ApexPages.StandardController sc = new ApexPages.standardController(objAllocationhours);
        Hoursprojectpopupcls hrsprojpopup = new Hoursprojectpopupcls(sc);
        Hoursprojectpopupcls.Reciver OBJR=new Hoursprojectpopupcls.Reciver();
        List<selectoption>temp=hrsprojpopup.CCList;  
        List<SelectOption>fiscaYearTemp= hrsprojpopup.fisicalYearOptions;  
        try{
        hrsprojpopup.saveHrs();
        }catch(Exception e){}
        hrsprojpopup.ccUserRec();
        hrsprojpopup.Selfhrs();
        hrsprojpopup.ccRequst=false;
        hrsprojpopup.selectedFisicalYear='january';
        hrsprojpopup.defaultFiscalYearId='january';
        hrsprojpopup.sObjName='musqot__Costcentre__c';        
        test.stopTest();                  
      }
  static testMethod void Hoursprojectpopup1(){
      Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
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
      Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=u2.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);      
      musqot__Costcentre__c objCC=new musqot__Costcentre__c(); 
      objCC.Name='test';
      objCC.musqot__cc_Owner__c=u2.id;
      objCC.musqot__Headline__c ='present';
      insert objCC;
      System.assertEquals('test', objCC.name);  
      
        project__c objpro=new project__c();
        objpro.Name='testt';
        objpro.Starts_date__c = Date.Today();
        objpro.Ends_date__c = Date.Today();
        objpro.Status__c = 'Completed';
        objpro.ownerid=plm.userid__c;
        System.assertEquals('testt', objpro.Name);
        insert objpro;
        
        Subproject__c objsubproj = new Subproject__c();
        objsubproj.Parent_project__c=objpro.id;
        objsubproj.Name = 'test';
        objsubproj.Starts_date__c = Date.Today();
        objsubproj.Ends_date__c= Date.Today();
        objsubproj.Status__c = 'Completed';
        System.assertEquals('test', objsubproj.Name);
        insert objsubproj;
        
        Allocation_resources__c  objAllocationhours = new Allocation_resources__c ();
        objAllocationhours.Name='testAllochours';
        objAllocationhours.Approved_houver__c=1;
        objAllocationhours.plan__c=objpro.id;
        objAllocationhours.Approved__c=true;
        objAllocationhours.Plan__c=objsubproj.Parent_project__c;
        objAllocationhours.musqot__Cost_center__c=objCC.Id;
        objAllocationhours.project__c=objsubproj.id;
        objAllocationhours.Approved_date__c=System.today();
        objAllocationhours.Request_date__c=System.today();
        objAllocationhours.Description__c='testDescription';
        objAllocationhours.Requested_hours__c=1;
        objAllocationhours.FiscalYear__c='2000';
        System.assertEquals('testAllochours', objAllocationhours.name);
        insert objAllocationhours; 
        
         musqot__Musqot_fiscal_year__c fiscalYearObj=new musqot__Musqot_fiscal_year__c();
        fiscalYearObj.name='2015';
        fiscalYearObj.musqot__Start_date__c=system.today();
        fiscalYearObj.musqot__End_date__c=system.today()+10;
        insert fiscalYearObj;
       
        test.startTest(); 
        PageReference pageRef = Page.Hoursprojectpopup;
        Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getParameters().put('prjID', objsubproj.id);
        ApexPages.currentPage().getParameters().put('id', objsubproj.id);
        ApexPages.currentPage().getParameters().put('ccId',objCC.Id);
        ApexPages.StandardController sc = new ApexPages.standardController(objAllocationhours);
        Hoursprojectpopupcls hrsprojpopup = new Hoursprojectpopupcls(sc);
        Hoursprojectpopupcls.Reciver OBJR=new Hoursprojectpopupcls.Reciver();
        List<selectoption>temp=hrsprojpopup.CCList;  
        List<SelectOption>fiscaYearTemp= hrsprojpopup.fisicalYearOptions;  
        try{
        hrsprojpopup.saveHrs();
        }catch(Exception e){}
        hrsprojpopup.ccRequst=false;
        hrsprojpopup.selectedFisicalYear='january';
        hrsprojpopup.defaultFiscalYearId='january';
        hrsprojpopup.sObjName='musqot__Subproject__c';        
        test.stopTest();                 
      }
    static testMethod void Hoursprojectself(){
        Subproject__c objsub = new Subproject__c();
        objsub.Name = 'test';
        objsub.Starts_date__c = Date.Today();
        objsub.Ends_date__c= Date.Today();
        objsub.Status__c = 'Completed';
        System.assertEquals('test', objsub.Name);
        insert objsub;
        Subproject__c objsubproj = new Subproject__c();
        objsubproj.Project_del__c=objsub.id;
        objsubproj.Name = 'test';
        objsubproj.Starts_date__c = Date.Today();
        objsubproj.Ends_date__c= Date.Today();
        objsubproj.Status__c = 'Completed';
        System.assertEquals('test', objsubproj.Name);
        insert objsubproj;
        Allocation_resources__c  objAllocationhours = new Allocation_resources__c ();
        objAllocationhours.Name='testAllochours';        
        objAllocationhours.Approved__c=true;
        objAllocationhours.To_Project__c=objsubproj.id;
        objAllocationhours.Approved_date__c=System.today();
        System.assertEquals('testAllochours', objAllocationhours.name);
        insert objAllocationhours; 
        ApexPages.StandardController sc = new ApexPages.standardController(objsub);
        Hoursprojectpopupcls hrsself = new Hoursprojectpopupcls(sc);
        hrsself.Selfhrs();
    }
   static testMethod void Hoursprojectpopup2(){
      Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
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
      Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=u2.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);      
      musqot__Costcentre__c objCC=new musqot__Costcentre__c(); 
      objCC.Name='test';
      objCC.musqot__cc_Owner__c=u2.id;
      objCC.musqot__Headline__c ='present';
      insert objCC;
      System.assertEquals('test', objCC.name);  
      
        project__c objpro=new project__c();
        objpro.Name='testt';
        objpro.Starts_date__c = Date.Today();
        objpro.Ends_date__c = Date.Today();
        objpro.Status__c = 'Completed';
        objpro.ownerid=plm.userid__c;
        System.assertEquals('testt', objpro.Name);
        insert objpro;
        
        Subproject__c objsubproj = new Subproject__c();
        objsubproj.Parent_project__c=objpro.id;
        objsubproj.Name = 'test';
        objsubproj.Starts_date__c = Date.Today();
        objsubproj.Ends_date__c= Date.Today();
        objsubproj.Status__c = 'Completed';
        objsubproj.Ownerid = UserInfo.getUserId();
        System.assertEquals('test', objsubproj.Name);
        insert objsubproj;
        
        Subproject__c objsubproj1 = new Subproject__c();
        objsubproj1.Parent_project__c=objpro.id;
        objsubproj1.Name = 'test';
        objsubproj1.Project_del__c=objsubproj.id;
        objsubproj1.Starts_date__c = Date.Today();
        objsubproj1.Ends_date__c= Date.Today();
        objsubproj1.Status__c = 'Completed';
        objsubproj1.Ownerid = UserInfo.getUserId();
        System.assertEquals('test', objsubproj1.Name);
        insert objsubproj1;
        
        Allocation_resources__c  objAllocationhours = new Allocation_resources__c ();
        objAllocationhours.Name='testAllochours';
        objAllocationhours.Approved_houver__c=1;
        objAllocationhours.plan__c=objpro.id;
        objAllocationhours.musqot__Cost_center__c=objCC.Id;
        objAllocationhours.project__c=objsubproj.id;
        objAllocationhours.Approved__c=true;
        //objAllocationhours.To_Project__c=objsubproj1.Project_del__c;
        objAllocationhours.To_Project__c=objsubproj.id;
        objAllocationhours.Approved_date__c=System.today();
        objAllocationhours.Request_date__c=System.today();
        objAllocationhours.Description__c='testDescription';
        objAllocationhours.Requested_hours__c=1;
        objAllocationhours.FiscalYear__c='2000';
        System.assertEquals('testAllochours', objAllocationhours.name);
        insert objAllocationhours; 
        
        musqot__Musqot_fiscal_year__c fiscalYearObj=new musqot__Musqot_fiscal_year__c();
        fiscalYearObj.name='2015';
        fiscalYearObj.musqot__Start_date__c=system.today();
        fiscalYearObj.musqot__End_date__c=system.today()+10;
        insert fiscalYearObj;
       
        test.startTest(); 
        PageReference pageRef = Page.Hoursprojectpopup;
        Test.setCurrentPage(pageRef);
        
        ApexPages.currentPage().getParameters().put('prjID', objsubproj1.id);
        ApexPages.currentPage().getParameters().put('id', objpro.id);
        ApexPages.currentPage().getParameters().put('ccId',objCC.Id);
        ApexPages.StandardController sc = new ApexPages.standardController(objAllocationhours);
        Hoursprojectpopupcls hrsprojpopup = new Hoursprojectpopupcls(sc);
        Hoursprojectpopupcls.Reciver OBJR=new Hoursprojectpopupcls.Reciver();
        List<selectoption>temp=hrsprojpopup.CCList;  
        List<SelectOption>fiscaYearTemp= hrsprojpopup.fisicalYearOptions;  
        try{
        hrsprojpopup.saveHrs();
        }catch(Exception e){}
        hrsprojpopup.ccRequst=false;
        hrsprojpopup.selectedFisicalYear='january';
        hrsprojpopup.defaultFiscalYearId='january';
        hrsprojpopup.sObjName='musqot__Project__c';         
        test.stopTest();                  
      }
    /*static testMethod void Hoursdefaultplan(){
        project__c objpro=new project__c();
        objpro.Name='testt';
        objpro.Starts_date__c = Date.Today();
        objpro.Ends_date__c = Date.Today();
        objpro.Status__c = 'Completed';
        objpro.ownerid=userinfo.getuserid();
        System.assertEquals('testt', objpro.Name);
        insert objpro;
        Allocation_resources__c  objAllocationhours = new Allocation_resources__c ();
        objAllocationhours.Name='testAllochours';
        objAllocationhours.Approved_date__c=System.today();
        objAllocationhours.plan__c=objpro.id;
        objAllocationhours.Approved__c=true;
        System.assertEquals('testAllochours', objAllocationhours.name);
        insert objAllocationhours;
        ApexPages.StandardController sc = new ApexPages.standardController(objAllocationhours);
        Hoursprojectpopupcls hrsprojpopup = new Hoursprojectpopupcls(sc);
        hrsprojpopup.defaultplan=true;
        hrsprojpopup.saveHrs();
    	}*/
  }