/*********************************************************
Class Name: costcenterfinanceTest
Author:chaithanya daggumati                 Last modified by:chaithanya daggumati
Date:   15/12/2015                          Date: 15/12/2015
********©2013 Musqot marketing technology Pvt ltd ********/
@isTest(seeAllData=true)
public class costcenterfinanceTest {
    static testMethod void CostcentefinanceMethod(){
        Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
        User u2 =new User( Alias = 'newUser1' ,
                          Email ='newuser123@testorg.com',
                          EmailEncodingKey = 'UTF-8',
                          LastName = 'Testing',
                          LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', 
                          UserName='newuser1234@testorg.com',
                          ProfileId=p.Id,
                          TimeZoneSidKey='America/Los_Angeles');
        insert u2;
         Project__c prj = new Project__c ();
         prj.Name='ITC';
        // prj.Plantype__c= pt.Id;
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c= system.toDay();
         prj.Status__c = 'In Progress';
         //prj.ownerid=plm.musqot__userid__c;
         System.assertEquals('ITC', prj.name);         
         insert prj;
         
         Subproject__c subPrj = new Subproject__c();         
         subPrj.Name='ITC Project';
         subPrj.Parent_project__c = prj.Id;
         subPrj.Ends_date__c = system.toDay().addDays(3);
         subPrj.Starts_date__c= system.toDay();
         subPrj.Status__c = 'In Progress'; 
        // subPrj.Project_type__c = prjType.Id;
         System.assertEquals('ITC Project', subPrj.name);     
         insert subPrj; 
         
        Musqot_fiscal_year__c objMusqotfiscalyea=new Musqot_fiscal_year__c();
        objMusqotfiscalyea.name ='musqot';
        objMusqotfiscalyea.Start_date__c= Date.today();
        objMusqotfiscalyea.End_date__c =Date.today();        
        insert objMusqotfiscalyea;
        System.assertEquals('musqot', objMusqotfiscalyea.name);
        
        Costcentre__c objCC=new Costcentre__c(); 
        objCC.Name='CCRequest';
        objCC.OwnerId=u2.id;
        objCC.cc_Owner__c=u2.id;
        objCC.Description__c='description';
        objCC.Headline__c='musqotCostcenter';
        objCC.Fiscal_year__c=objMusqotfiscalyea.id;
        objCC.Overveiw__c='presentation';
        objCC.Status__c='Active';
        objCC.cc_Owner__c=u2.id;
        insert objCC;
        System.assertEquals('CCRequest', objCC.name);
        FiscalYearSettings fs=[select Id,Name from FiscalYearSettings where name='2016'];
        
        Allocation_amount__c  objAllocationamount=new Allocation_amount__c ();
        objAllocationamount.Name='testAllocation';
        objAllocationamount.Approved_Amount__c=1000;        
        objAllocationamount.Approvedate__c=System.today();
        objAllocationamount.Description__c='testDescription';
        objAllocationamount.Allocated__c=1000;
        objAllocationamount.Costcentre__c=objCC.id;
        objAllocationamount.FiscalYear__c=fs.id;
        objAllocationamount.To_Plan__c=prj.id;
        objAllocationamount.To_Project__c=subPrj.id;
        objAllocationamount.Musqot_fiscal_year__c=objMusqotfiscalyea.id;        
        insert objAllocationamount;
        System.assertEquals('testAllocation', objAllocationamount.name);
        
        Allocation_resources__c  objAllocationhours = new Allocation_resources__c ();
        objAllocationhours.Name='testAllocation';
        objAllocationhours.Approved__c=true;
        objAllocationhours.Approved_houver__c=1000;
        objAllocationhours.FiscalYear__c=fs.id;
        objAllocationhours.Musqot_fiscal_year__c=objMusqotfiscalyea.id;
        objAllocationhours.Cost_center__c=objCC.id;
        objAllocationhours.Approved_date__c=System.today();
        objAllocationhours.Description__c='testDescription';
        objAllocationhours.Requested_hours__c=1000;  
        objAllocationhours.To_Plan__c =prj.id; 
        objAllocationhours.To_Project__c=subPrj.id;    
        insert objAllocationhours;
        System.assertEquals('testAllocation', objAllocationhours.name);
        
        Test.startTest();
        PageReference pageRef = Page.costcenterfinance;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', objAllocationamount.id);
        ApexPages.currentPage().getParameters().put('id', objAllocationhours.id);
        costcenterfinance ccfin = new costcenterfinance();
        costcenterfinance.Financials finwrap =new costcenterfinance.Financials();
        finwrap.toplan='project';
        finwrap.toProjet='subproject';
        finwrap.requestedAmt=10.25;
        finwrap.approvedAmt=20.25;
        ccfin.viewvalues='Detail';
        ccfin.selectedyear=fs.id;
        ccfin.currentRecordId=objCC.id;
        costcenterfinance.Resources reswrap =new costcenterfinance.Resources();
        costcenterfinance.PieWedgeData piewrap =new costcenterfinance.PieWedgeData();
        //costcenterfinance.processInstanWorkItemWrap piwwrap =new costcenterfinance.processInstanWorkItemWrap(,objAllocationamount.id,objAllocationhours.id,);
        reswrap.toplan='project';
        reswrap.toProjet='subproject';
        reswrap.requestedhrs=3.0;
        reswrap.approvedhrs=2.0;
        
        List<SelectOption> temp=ccfin.fisicalYearOptions;
        ProcessInstanceWorkitem temp1=ccfin.piw;
        //ProcessInstance ptemp = ccfin.pwiWrap;
        ccfin.loaddata();
        ccfin.selectedview();
        ccfin.selectedresview();
        ccfin.selectedApprovalStatus();
        ccfin.getPieData();
        ccfin.totdetail=12.500;
        ccfin.totsum=12.500;
        ccfin.tothrsdetail=12.500;
        ccfin.tothrssum=12.500;
    }
    static testMethod void CCfinancependingrequests(){
        Profile p = [select id from profile where name='System Administrator']; 
              User objUser = new User(alias = 'stan', email='standarduser@test.com', 
              emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
              localesidkey='en_US', profileid = p.Id, 
              timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
              insert objUser ;
              
         Subproject__c subPrj = new Subproject__c();         
         subPrj.Name='ITC Project';
         //subPrj.Parent_project__c = prj.Id;
         subPrj.Ends_date__c = system.toDay().addDays(3);
         subPrj.Starts_date__c= system.toDay();
         subPrj.Status__c = 'In Progress'; 
        // subPrj.Project_type__c = prjType.Id;
         System.assertEquals('ITC Project', subPrj.name);     
         insert subPrj;  
          
        Costcentre__c objCC=new Costcentre__c(); 
        objCC.Name='CCRequest';
        objCC.OwnerId=objUser.id;
        //objCC.cc_Owner__c=u2.id;
        objCC.Description__c='description';
        objCC.Headline__c='musqotCostcenter';
        //objCC.Fiscal_year__c=objMusqotfiscalyea.id;
        objCC.Overveiw__c='presentation';
        objCC.Status__c='Active';
        objCC.cc_Owner__c=objUser.id;
        insert objCC;
         
        musqot__Costcentre__c cc = new musqot__Costcentre__c();
        cc.Name = 'My Test';
        cc.musqot__Headline__c='mmusqottestCostcenter';
        cc.musqot__cc_Owner__c = objUser.Id;
        insert cc;
         FiscalYearSettings fs=[select Id,Name from FiscalYearSettings where name='2016'];
         
        Allocation_amount__c  objAllocationamount=new Allocation_amount__c ();
        objAllocationamount.Name='testAllocation';
        objAllocationamount.Approved_Amount__c=1000;        
        objAllocationamount.Approvedate__c=System.today();
        objAllocationamount.Description__c='testDescription';
        objAllocationamount.Allocated__c=1000;
        objAllocationamount.Costcentre__c=objCC.id;
        objAllocationamount.FiscalYear__c=fs.id;
        objAllocationamount.To_Project__c=subPrj.id;
        //objAllocationamount.Musqot_fiscal_year__c=objMusqotfiscalyea.id;        
        insert objAllocationamount;
        System.assertEquals('testAllocation', objAllocationamount.name);
        
        Allocation_resources__c  objAllocationhours = new Allocation_resources__c ();
        objAllocationhours.Name='testAllocation';
        objAllocationhours.Approved__c=true;
        objAllocationhours.Approved_houver__c=1000;
        objAllocationhours.FiscalYear__c=fs.id;
        //objAllocationhours.Musqot_fiscal_year__c=objMusqotfiscalyea.id;
        objAllocationhours.Cost_center__c=objCC.id;
        objAllocationhours.Approved_date__c=System.today();
        objAllocationhours.Description__c='testDescription';
        objAllocationhours.Requested_hours__c=1000;  
        objAllocationhours.To_Project__c=subPrj.id;     
        insert objAllocationhours;
        System.assertEquals('testAllocation', objAllocationhours.name);
        try{
        insert objAllocationhours;
        }catch(exception e){} 
        
        test.startTest();
        PageReference pageRef = Page.costcenterfinance;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', objAllocationamount.id);
        ApexPages.currentPage().getParameters().put('id', objAllocationhours.id);        
        if([select count() from ProcessInstance where targetobjectid=:objAllocationamount.id] < 1)
        {       
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Approve.');
            req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req.setObjectId(objAllocationamount.Id);
            try{
            Approval.ProcessResult result = Approval.process(req);
            }catch(exception e){}
            }
        costcenterfinance ccfin = new costcenterfinance();    
        ProcessInstanceWorkitem temp3=ccfin.piw;       
        ccfin.getPendingrequestsList();
        
        if([select count() from ProcessInstance where targetobjectid=:objAllocationhours.id] < 1)
        {       
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Approve.');
            req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req.setObjectId(objAllocationhours.Id);
            try{
            Approval.ProcessResult result = Approval.process(req);
            }catch(exception e){}
            }
        costcenterfinance ccfin1 = new costcenterfinance();    
        ProcessInstanceWorkitem temp4=ccfin1.piw;       
        ccfin1.getPendingrequestsList();       
        test.stoptest();
        }
    static testMethod void rejectrequests(){
        Profile p = [select id from profile where name='System Administrator']; 
              User objUser = new User(alias = 'stan', email='standarduser@test.com', 
              emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
              localesidkey='en_US', profileid = p.Id, 
              timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
              insert objUser ;
        musqot__Costcentre__c cc = new musqot__Costcentre__c();
        cc.Name = 'My Test';
        cc.musqot__Headline__c='mmusqottestCostcenter';
        cc.musqot__cc_Owner__c = objUser.Id;
        insert cc;
         
        musqot__Allocation_amount__c objAllocation = new musqot__Allocation_amount__c();
        objAllocation.Name='test';
        System.assertEquals('test', objAllocation.name);
        objAllocation.musqot__Allocated__c = 6000;
        insert objAllocation;
        
        Allocation_resources__c  objAllocationhours = new Allocation_resources__c ();
        objAllocationhours.Name='testAllochours';
        objAllocationhours.Approved_houver__c=1;
        objAllocationhours.Approved_date__c=System.today();
        objAllocationhours.Request_date__c=System.today();
        objAllocationhours.Description__c='testDescription';
        objAllocationhours.Requested_hours__c=1;
        System.assertEquals('testAllochours', objAllocationhours.name);
        try{
        insert objAllocationhours;
        }catch(exception e){} 
        
        test.startTest();
        PageReference pageRef = Page.costcenterfinance;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', objAllocation.id);
        ApexPages.currentPage().getParameters().put('id', objAllocationhours.id);        
        if([select count() from ProcessInstance where targetobjectid=:objAllocation.id] < 1)
        {       
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Approve.');
            req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req.setObjectId(objAllocation.Id);
            try{
            Approval.ProcessResult result = Approval.process(req);
            }catch(exception e){}
            }
        costcenterfinance ccfin = new costcenterfinance();    
        ProcessInstance temp5=ccfin.piwrap;       
        ccfin.getRejectrequestsList();
        
        if([select count() from ProcessInstance where targetobjectid=:objAllocationhours.id] < 1)
        {       
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Approve.');
            req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req.setObjectId(objAllocationhours.Id);
            try{
            Approval.ProcessResult result = Approval.process(req);
            }catch(exception e){}
            }
        costcenterfinance ccfin1 = new costcenterfinance();
        //costcenterfinance.processInstanWorkItemWrap ccpiwrap = new costcenterfinance.processInstanWorkItemWrap(piwrap,objAllocation,objAllocationhours);
        costcenterfinance.PieWedgeData piedat=new costcenterfinance.PieWedgeData ();
        ProcessInstance temp6=ccfin1.piwrap;       
        ccfin1.getRejectrequestsList(); 
        ccfin1.getTabInFocus();
        ccfin1.setTabInFocus('sgfs');      
        test.stoptest();
        }
    static testMethod void selectedstatus(){
        costcenterfinance ccstts = new costcenterfinance();
        ccstts.Requesttype='Pending';
        ccstts.showPendingRecord=true;
        ccstts.showRejectedRecord=false;
        ccstts.selectedApprovalStatus();
    }
}