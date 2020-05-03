/*****************************************************
Class Name: FRMarketingPopupCtrlTest
Author:Nagaraju G     Last modified by:G Janarhanreddy
Date: 24/7/2014        Date:19/03/2015
********©2013 Musqot marketing technology Pvt ltd ****/
@isTest(seeAllData=true)
public class FRMarketingPopupCtrlTest{
    static testMethod void FRPlanPopup(){
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
        prj.ownerid =plm.userid__c;
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
                
         Marketing_activity__c objMarketingact=new Marketing_activity__c();
         objMarketingact.Name='test';
         objMarketingact.Description__c='tdescriptionest';
         objMarketingact.Ends_date__c=system.today();
         objMarketingact.Starts_date__c=system.today();
         objMarketingact.Status__c='completed';
         objMarketingact.musqot__ERP__c='testERP';
         objMarketingact.musqot__Social_media__c='testSocial';
         objMarketingact.musqot__CRM__c='testCRM';         
         insert objMarketingact;
         System.assertEquals('test', objMarketingact.name);
        
        Musqot_fiscal_year__c fiscalYearObj=new Musqot_fiscal_year__c();
        fiscalYearObj.name='2015';
        fiscalYearObj.musqot__Start_date__c=system.today();
        fiscalYearObj.musqot__End_date__c=system.today()+10;
        insert fiscalYearObj;
        
        Allocation_amount__c objallocamt = new Allocation_amount__c ();
        objallocamt .Approvedate__c= Date.Today(); 
        objallocamt .Name = 'Name';
        objallocamt .FiscalYear__c='november';       
        objallocamt.plan__c=prj.id;
        objallocamt.project__c=subPrj.id;
        objallocamt.Musqot_fiscal_year__c=fiscalYearObj.id;       
        System.assertEquals('Name', objallocamt .name);         
        insert objallocamt; 
        
        test.startTest();
        PageReference pageRef = Page.Fundrequestmarketing;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('mark', objMarketingact.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objMarketingact);        
        FRMarketingPopupCtrl objfrMarketing = new FRMarketingPopupCtrl(sc);
        FRMarketingPopupCtrl.Reciver OBre=new FRMarketingPopupCtrl.Reciver();    
        objfrMarketing .saveAmt();
        List<SelectOption>fiscalyeartemp =objfrMarketing.fisicalYearOptions;
        objfrMarketing.defaultFiscalYearId='jan';
        objfrMarketing.selfApp=true;
        objfrMarketing.ccApp=true;
        test.stopTest();        
    }
}