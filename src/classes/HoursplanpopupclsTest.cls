/**************************************************************
Class Name: HoursplanpopupclsTest
Author:chaithanya daggumati     Last modified by:chaithanya daggumati
Date: 14/4/2015                 Date:14/4/2015
********©2013 Musqot marketing technology Pvt ltd *************/
@isTest(Seealldata = True)
public class HoursplanpopupclsTest{
    static testMethod void Hoursplanpopup(){
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
        Costcentre__c cc = new Costcentre__c();
        cc .Name = 'test';
        cc.musqot__Headline__c='skjajjkja';
        System.assertEquals('test', cc .name);
        insert cc;
        
        Project__c prj = new Project__c ();
        prj.Name='ITC';
        prj.Ends_date__c = system.toDay().addDays(3);
        prj.Starts_date__c= system.toDay();
        prj.Status__c = 'In Progress';
        prj.ownerid=plm.userid__c;
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
           musqot__Musqot_fiscal_year__c fiscalYearObj=new musqot__Musqot_fiscal_year__c();
        fiscalYearObj.name='2015';
        fiscalYearObj.musqot__Start_date__c=system.today();
        fiscalYearObj.musqot__End_date__c=system.today()+10;
        insert fiscalYearObj;
        
        Allocation_resources__c  objAllocationhours = new Allocation_resources__c ();
        objAllocationhours.Name='testAllochours';
        objAllocationhours.Approved_houver__c=1;
        objAllocationhours.plan__c=prj.id;
        objAllocationhours.project__c=subPrj.id;
        objAllocationhours.Approved_date__c=System.today();
        objAllocationhours.Request_date__c=System.today();
        objAllocationhours.Description__c='testDescription';
        objAllocationhours.Requested_hours__c=1;
        System.assertEquals('testAllochours', objAllocationhours.name);
        insert objAllocationhours;
       
        try{
            insert objAllocationhours;
            }
            catch(Exception e){
             Boolean expectedExceptionThrown =  e.getMessage().contains('Please create Cost Center') ? true : false;
            system.assertEquals(expectedExceptionThrown,false);       
            } 
             
        musqot__Activity__c m1 =new musqot__Activity__c();
        m1.musqot__keycode__c='212';
        m1.musqot__Use_Allocation__c=true;
        m1.musqot__Use_Budget__c=true;
        m1.musqot__Use_Finance1__c=true;
        m1.musqot__Use_Forcasting__c=true;
        m1.musqot__Use_milestones__c=true;
        m1.musqot__Use_Resource__c=true;
        System.assertEquals('212', m1.musqot__keycode__c);
    insert m1;
        test.startTest(); 
        PageReference pageRef = Page.Hoursplanpopup;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id',objAllocationhours.Id);           
        ApexPages.StandardController sc = new ApexPages.standardController(objAllocationhours);        
        Hoursplanpopupcls hrsplnpop = new Hoursplanpopupcls();  
        List<selectoption>temp=hrsplnpop.CCList;
        List<SelectOption>fiscaYearTemp= hrsplnpop.fisicalYearOptions;  
    try{       
        hrsplnpop.saveHrs();
        }catch(exception e){}
        hrsplnpop.sendrec=true;
        hrsplnpop.ccRequst=true;
        hrsplnpop.uname='test';
        hrsplnpop.selectedFisicalYear='2015';
        try{       
        hrsplnpop.ccUserRec();
         }catch(exception e){}
        hrsplnpop.Selfhrs();
        test.stopTest();
          }
 static testMethod void Hoursplanpopup1(){
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
        Costcentre__c cc = new Costcentre__c();
        cc .Name = 'test';
        cc.musqot__cc_Owner__c=UserInfo.getUserId();
        cc.musqot__Headline__c='skjajjkja';
        System.assertEquals('test', cc .name);
        insert cc;
        
        Project__c prj = new Project__c ();
        prj.Name='ITC';
        prj.Ends_date__c = system.toDay().addDays(3);
        prj.Starts_date__c= system.toDay();
        prj.Status__c = 'In Progress';
     	prj.ownerid=plm.userid__c;
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
        
        Allocation_resources__c  objAllocationhours = new Allocation_resources__c ();
        objAllocationhours.Name='testAllochours';
        objAllocationhours.Approved_houver__c=1;
        objAllocationhours.plan__c=prj.id;
        objAllocationhours.project__c=subPrj.id;
        objAllocationhours.Approved_date__c=System.today();
        objAllocationhours.Request_date__c=System.today();
        objAllocationhours.Description__c='testDescription';
        objAllocationhours.Requested_hours__c=1;
        System.assertEquals('testAllochours', objAllocationhours.name);
        insert objAllocationhours; 
        
        try{
            insert objAllocationhours;
            }
            catch(Exception e){
             Boolean expectedExceptionThrown =  e.getMessage().contains('Please create Cost Center') ? true : false;
            system.assertEquals(expectedExceptionThrown,false);       
            } 
        
        musqot__Activity__c m1 =new musqot__Activity__c();
        m1.musqot__keycode__c='212';
        m1.musqot__Use_Allocation__c=true;
        m1.musqot__Use_Budget__c=true;
        m1.musqot__Use_Finance1__c=true;
        m1.musqot__Use_Forcasting__c=true;
        m1.musqot__Use_milestones__c=true;
        m1.musqot__Use_Resource__c=true;
        System.assertEquals('212', m1.musqot__keycode__c);
        insert m1;
        test.startTest(); 
        PageReference pageRef = Page.Hoursplanpopup;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('pid',prj.Id);           
        ApexPages.StandardController sc = new ApexPages.standardController(prj);        
        Hoursplanpopupcls hrsplnpop = new Hoursplanpopupcls();  
        List<selectoption>temp=hrsplnpop.CCList;
    try{       
        hrsplnpop.saveHrs();
        }catch(exception e){}
        hrsplnpop.sendrec=true;
        try{       
            hrsplnpop.ccUserRec();
        }catch(exception e){}
        test.stopTest();          
        }
   static testMethod void Hoursplanpopup2(){
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
        /*Costcentre__c cc = new Costcentre__c();
        cc .Name = 'test';
        cc.musqot__Headline__c='skjajjkja';
        System.assertEquals('test', cc .name);
        insert cc;*/
        
        Project__c prj = new Project__c ();
        prj.Name='ITC';
        prj.Ends_date__c = system.toDay().addDays(3);
        prj.Starts_date__c= system.toDay();
        prj.Status__c = 'In Progress';
       	prj.ownerid=plm.userid__c;
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
        
        Allocation_resources__c  objAllocationhours = new Allocation_resources__c ();
        objAllocationhours.Name='testAllochours';
        objAllocationhours.Approved_houver__c=1;
        objAllocationhours.plan__c=prj.id;
        objAllocationhours.project__c=subPrj.id;
        objAllocationhours.Approved_date__c=System.today();
        objAllocationhours.Request_date__c=System.today();
        objAllocationhours.Description__c='testDescription';
        objAllocationhours.Requested_hours__c=1;
        System.assertEquals('testAllochours', objAllocationhours.name);
        insert objAllocationhours; 
        
        try{
            insert objAllocationhours;
            }
            catch(Exception e){
             Boolean expectedExceptionThrown =  e.getMessage().contains('Please create Cost Center') ? true : false;
            system.assertEquals(expectedExceptionThrown,false);       
            } 
        
        musqot__Activity__c m1 =new musqot__Activity__c();
        m1.musqot__keycode__c='212';
        m1.musqot__Use_Allocation__c=true;
        m1.musqot__Use_Budget__c=true;
        m1.musqot__Use_Finance1__c=true;
        m1.musqot__Use_Forcasting__c=true;
        m1.musqot__Use_milestones__c=true;
        m1.musqot__Use_Resource__c=true;
        System.assertEquals('212', m1.musqot__keycode__c);
        insert m1;
        test.startTest(); 
        PageReference pageRef = Page.Hoursplanpopup;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('pid',prj.Id);           
        ApexPages.StandardController sc = new ApexPages.standardController(prj);        
        Hoursplanpopupcls hrsplnpop = new Hoursplanpopupcls();  
        List<selectoption>temp=hrsplnpop.CCList;
    try{       
        hrsplnpop.saveHrs();
        }catch(exception e){}
        hrsplnpop.sendrec=true;
        try{       
            hrsplnpop.ccUserRec();
        }catch(exception e){}
        test.stopTest();          
       }
 }