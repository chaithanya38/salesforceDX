/**************************************************************
Class Name: FinancialSummarysub 
Author:G Janardhanreddy         Last modified by:Raju GN
Date: 25/6/2014                 Date: 15/10/2015 
@Desc: Adding "FiscalYear__c"  field in getbudget in constructor.
********©2013 Musqot marketing technology Pvt ltd **************/
public with sharing class FinancialSummarysub{
    public String prjId{get;set;}
    private string parentName;
    private string parentProjID;
    public Budget__c getbudget {get;set;}
    public Budget__c getbudgetplan{get;set;}
    private ApexPages.standardController controller;
    private List<Financials> fin;
    private List<Financials> subfin;
    public String taskid{get;set;}
    private List<Financials> mafin;
    private List<Invoice__c> inv{get;set;}
    private Subproject__c Prj;
    public String planId{get;set;}
    public boolean Level3{get;set;}
    public boolean Level4{get;set;}
    public boolean Level5{get;set;}
    public boolean Level6{get;set;}
    public String workId {get; set;}
    public Subproject__c prjObj;
    public List<Purchase_order__c> temmils;
    public List<musqot__Activity__c> musAct{get;set;}
    String tabInFocus;
    String tabId;
    String maxPO; 
    public boolean disablePO{get;set;}
    public boolean disableReFund{get;set;}
    public string fiscalYearName{get;set;}
    public FinancialSummarysub(ApexPages.StandardController controller){      
        this.controller = controller;
        this.Prj  = (Subproject__c)controller.getRecord();
        tabInFocus = System.currentPageReference().getParameters().get('tab');
        prjId= controller.getRecord().Id;
        try{
            prjObj= [select Id, Name,Owner.name,OwnerId,Parent_project__c,Project_del__c, 
                     Parent_project__r.Name,Parent_project__r.OwnerId,Project_del__r.Name ,
                     Starts_date__c,Ends_date__c from Subproject__c where Id =:prjId]; 
            if(prjObj.musqot__Ends_date__c<system.today()){
                disableReFund=true;
            }
            if(prjObj.Parent_project__r.OwnerId==UserInfo.getUserId()){
                calcluteRemaing();
            }
            
        }catch(Exception e){}
        musAct=[SELECT id,Name,keycode__c,Use_Allocation__c,Use_Budget__c,musqot__Use_Finance1__c,
                Use_Forcasting__c,Use_milestones__c,Use_Resource__c  FROM musqot__Activity__c limit 1 ];
        if(musAct[0].musqot__Use_Budget__c==true){         
            level4=true;
        }  
        if(musAct[0].Use_Resource__c ==true){         
            level5=true;
        }  
        if(musAct[0].musqot__Use_Finance1__c==true){         
            level6=true;
        } 
        if(musAct[0].Use_Allocation__c==true)
        {
            if(prjObj.Project_del__c<>null){
                parentName = prjObj.Project_del__r.Name;
            }
            else{
                parentName = prjObj.Parent_project__r.Name;
                parentProjID = prjObj.Parent_project__r.id;
            }
        }
        else if(musAct[0].Use_Allocation__c==false){
            parentName = prjObj.Owner.name;
        }
        try{
            getbudget = [SELECT  Name,Approved__c ,Budget_h__c,Owner.name,LastModifiedBy.name,
                         LastModifiedDate,Approved_date__c , Budget__c , user__c , Description__c,Project__c,
                         subproject__c,musqot__FiscalYear__c FROM Budget__c WHERE subproject__c = :prjId LIMIT :1];
            FiscalYearSettings Result= [SELECT Id, Name
                                        FROM FiscalYearSettings where id=:getbudget.FiscalYear__c];
            fiscalYearName=Result.Name;  
            
        }
        catch(Exception e){ 
        }
        
        securitySetting();  
    } 
    /**************************************
getTabInFocus():redirect particular tab.
***************************************/    
    public String getTabInFocus() {
        return tabInFocus;
    }
    
    public void setTabInFocus(String s ) {
        this.tabInFocus = s;
    }
    /***********************************************************
securitySetting(): gives security for financial summery page.
************************************************************/    
    public void securitySetting(){
        String myuserrole;
        String ownerrole;
        String ccOwnerrole;
        String planOwnerrole;
        String MyProflieName;
        String MyPlanRole;
        String userid ;
        String myuserid;
        list<Allocation_amount__c> parentid ;
        list<profile> userprofile;
        list<Musqot__Members__c> userrole;
        String PermissionSet;
        //check my profile 
        userprofile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() Limit 1];
        MyProflieName = userprofile[0].Name; 
        List<PermissionSetAssignment> lstcurrentUserPerSet =[SELECT PermissionSet.Name,AssigneeId FROM PermissionSetAssignment
                                                             WHERE AssigneeId = :Userinfo.getUserId() ];
        
        for(PermissionSetAssignment p1:lstcurrentUserPerSet)
        {
            
            if(p1.permissionSet.Name == 'Musqot_admin' ||  p1.permissionSet.Name =='Musqot_global_user' ||p1.permissionSet.Name =='Musqot_user'||p1.permissionSet.Name =='Musqot_admin_sf'||p1.permissionSet.Name =='Musqot_global_user_sf'||p1.permissionSet.Name =='Musqot_user_sf')
            { 
                PermissionSet = p1.permissionSet.Name; 
            }       
        }
        // check my proj role 
        userrole = [Select musqot__Role__c from Musqot__Members__c where musqot__SubProjMembers__c=:prjId AND musqot__ProjUsers__c =:UserInfo.getUserId() limit 1];
        if(!userrole.isEmpty()){
            myuserrole = userrole[0].Role__c; 
        }
        parentid=new  List<Allocation_amount__c>(); 
        parentid = [Select musqot__Costcentre__r.musqot__cc_Owner__c  from musqot__Allocation_amount__c where musqot__To_Plan__c =:planId limit 1];                               
        //String myuserid;
        if(!parentid.isEmpty()){
            myuserid = parentid[0].Costcentre__r.cc_Owner__c; 
        }
        If (myuserid == userid ){
            ownerrole = 'Owner';
        }  
        //check my parent role 
        Permissionlist__c pset=Permissionlist__c.getInstance(PermissionSet);
        Profilelist__c p3 = Profilelist__c.getInstance(MyProflieName);  
        if(p3<>null||pset<>null){
            if(MyProflieName=='System Administrator'||myuserrole == 'Owner'){
                Level3=True;
            }       
            else { 
                Level3=False; 
            } 
        } 
    } 
    /****************************************************
neworders():This is for redirect to Purchaseorderpage
*****************************************************/    
    Public PageReference neworders(){
        temmils = [Select Id, Name, Description__c, musqot__Purchase_order_cloesed__c,Total_cost__c,Project__c,subproject__c,Marketing_activity__c, Send_date__c, Purchase_order__c, total_Invoice_cost__c,Effective_date__c, Purchase_article__c, Allocation_amount__c, Purchase_order_name__c FROM Purchase_order__c  where subproject__c=:prjId limit 100 ];
        PageReference orderspage=new PageReference('/apex/Purchaseorderpage?&prjId='+EncodingUtil.urlEncode(prjId,'UTF-8')+'&maxpo='+EncodingUtil.urlEncode(maxPO,'UTF-8'));
        orderspage.setredirect(true);
        return orderspage; 
    }
    
    /****************************************************************
gotopurchaseorderedit() : redirect to PurchaseorderEditdetailspage 
******************************************************************/  
    public PageReference gotopurchaseorderedit() {
        String orderid= ApexPages.currentPage().getParameters().get('orderid'); 
        PageReference pgr;
        if(orderid<>null){       
            pgr =new PageReference ('/apex/PurchaseorderEditdetailspage?prjId='+EncodingUtil.urlEncode(prjId,'UTF-8')+'&purid='+EncodingUtil.urlEncode(orderid,'UTF-8')+'&maxpo='+EncodingUtil.urlEncode(maxPO,'UTF-8'));
            return pgr;
        }
        return null;
    }
    /******************************************************** 
getorders():This is for getting Purchase_order__c record
********************************************************/  
    public List<Purchase_order__c> getorders(){
        List<Purchase_order__c> PO =  [Select Id, Name,Description__c,musqot__Purchase_order_cloesed__c,Total_cost__c,Project__c,subproject__c,Marketing_activity__c, Send_date__c, Purchase_order__c, total_Invoice_cost__c,Effective_date__c, Purchase_article__c, Allocation_amount__c, Purchase_order_name__c FROM Purchase_order__c  where subproject__c=:prjId order by Purchase_order_name__c LIMIT 100];
        List<Purchase_order__c> PO_final= new List<Purchase_order__c> ();
        for(Purchase_order__c P:PO)
        {
            string name = P.Purchase_order_name__c;
            system.debug('Name='+name);
            If(name.substringBeforeLast('_')!='Wild_Inv')
            {
                PO_final.add(P);
            }
            
            
        }
        return PO_final;
    } 
    /*************************************
newinvoices(): redirect to Invoicepage 
**************************************/   
    Public PageReference newinvoices(){
        inv= [Select Id, Name, Description__c, Marketing_activity__c,Project__c,Purchase_article__c,Purchase_orders__c, subproject__c, supplier__c, Total_spent__c FROM Invoice__c  where subproject__c =:prjId limit 1 ];
        PageReference orderspage=new PageReference('/apex/Invoicepage?&prjId='+EncodingUtil.urlEncode(prjId,'UTF-8'));
        orderspage.setredirect(true);
        return orderspage; 
    }
    /********************************************* 
gotoinvoiceedit(): redirect to InvoiceEditpage 
**********************************************/  
    public PageReference gotoinvoiceedit(){
        String invid= ApexPages.currentPage().getParameters().get('invid'); 
        PageReference pgr;
        if(invid<>null){       
            pgr =new PageReference ('/apex/InvoiceEditpage?prjid='+EncodingUtil.urlEncode(prjId,'UTF-8')+'&invid='+EncodingUtil.urlEncode(invid,'UTF-8'));
            return pgr;
        }
        return null;
    }
    /***************************************
getinv():returns list of invoice records
****************************************/     
    public List<Invoice__c> getinv(){
        List<Invoice__c>invList=new List<Invoice__c>();
        List<Invoice__c>invList1=new List<Invoice__c>();        
        invList = [Select Id, Name, Description__c, Marketing_activity__c,Project__c,Purchase_article__c,Purchase_orders__R.Purchase_order_name__c, subproject__c, supplier__c, Total_spent__c FROM Invoice__c  where subproject__c=:prjId order by subproject__c ];
        for(Invoice__c i:invList){
            string name = i.Purchase_orders__R.Purchase_order_name__c;
            if(name<>null){
                If(name.substringBeforeLast('_')=='Wild_Inv'){
                    invList1.add(i);
                }
            }
        }
        for(Invoice__c i:invList1){
            i.Purchase_orders__R.Purchase_order_name__c='';
        }
        return invList;
    } 
    //--
    
    public List<Financials> getFin(){  
        List<Subproject__c>subProjects = [Select id,Name
                                          FROM Subproject__c 
                                          WHERE Project_del__c =:prjId];
        list<id>parentProjectIds=new list<id>();
        for(Subproject__c s:subProjects){
            parentProjectIds.add(s.id);
        }
        List<Financials> finlist = new List<Financials>();
        AggregateResult allocation = [
            SELECT SUM(Approved_Amount__c) totals 
            FROM Allocation_amount__c
            WHERE To_Project__c = :prjId];
        
        AggregateResult suballocation =[
            SELECT SUM(Approved_Amount__c) totals 
            FROM Allocation_amount__c
            WHERE To_Project__c IN:parentProjectIds];  
        
        // New calk of AggregateResult purchaseOrders
        List<Purchase_order__c> POcalk = new List<Purchase_order__c>();
        POcalk = [SELECT Total_cost__c, total_Invoice_cost__c, Purchase_order_cloesed__c FROM Purchase_order__c WHERE Subproject__c = :prjId ];
        Decimal reserved = 0;
        for(Purchase_order__c pruchOrdr : POcalk){
            if(pruchOrdr.Purchase_order_cloesed__c ){
                reserved += 0;
            }
            else if( pruchOrdr.total_Invoice_cost__c >  pruchOrdr.Total_cost__c){
                reserved += 0;
            } else if(pruchOrdr.total_Invoice_cost__c >0) {
                reserved +=(pruchOrdr.Total_cost__c-pruchOrdr.total_Invoice_cost__c); 
            }
            else {
                reserved += pruchOrdr.Total_cost__c; 
            }
        } 
        
        AggregateResult invoices = [
            SELECT SUM(Total_spent__c) totals 
            FROM Invoice__c
            WHERE Subproject__c= :prjId];
        
        AggregateResult budgetamn = [
            SELECT SUM(Budget__c) totals 
            FROM Budget__c
            WHERE subproject__c = :prjId ];
        /// this query need to be  changed to  be total of sub project to the " prjId"
        AggregateResult budgetamn_subproj = [
            SELECT SUM(Budget__c) totals 
            FROM Budget__c 
            WHERE subproject__c = :prjId ];
        
        // End  her
        /////
        // need to include sub project also
        // in budgetamn
        // ----------
        Financials f = new Financials();
        
        Decimal alloc = (Decimal) allocation.get('totals');
        alloc = (alloc == null) ? 0.00 : alloc.setscale(2);
        
        Decimal suballoc = (Decimal)suballocation.get('totals');
        suballoc = (suballoc == null) ? 0.00 : suballoc.setscale(2); 
        
        Decimal spent = (Decimal) invoices.get('totals');
        spent = (spent == null) ? 0.00 : spent.setscale(2);
        
        reserved = (reserved == null) ? 0.00 : reserved.setscale(2);
        
        Decimal budget = (Decimal) budgetamn.get('totals');
        budget = (budget == null) ? 0.00 : budget.setscale(2);
        
        Decimal budget2 = (Decimal) budgetamn_subproj.get('totals');
        budget2 = (budget2 == null) ? 0.00 : budget2.setscale(2);   
        
        Decimal remaining = (Decimal) alloc-suballoc-reserved-spent ;
        maxPO = String.valueOf(remaining);
        
        f.type =  parentName;
        f.allocated = alloc;
        f.suballocated = suballoc;
        f.reserved = reserved;
        f.spent = spent;
        f.remaining = remaining;
        f.budget = budget2;
        if (remaining < 0) {
            f.color = 'red';
            disablePO = true; 
        } else if (remaining < 1) {
            f.color = 'black';
            disablePO = true;
        } else {
            f.color = 'black';
            disablePO = false;
        }
        finlist.add(f);  
        return finlist;
    }
    
    /******************************************************** 
Financials:This wrapper class for display financial summary of Subproject.
/********************************************************/   
    public class Financials {
        public String color{get;set;}
        public String type{get;set;}
        public Decimal allocated{get;set;}
        public Decimal reserved{get;set;}
        public Decimal spent{get;set;}
        public Decimal suballocated{get;set;}
        public Decimal remaining{get;set;}
        public Decimal budget{get;set;}
    }
    
    /********************************************************      
Financials:This wrapper class for display financial summary of Subproject.
/********************************************************/  
    public List<Financials> getSubFin(){
        List<Financials> subfinlist = new List<Financials>();
        
        List<SubProject__c> subPrjs = [select Id, Name, Parent_project__c,(SELECT Approved_Amount__c,Approved__c ,project__c,To_Project__c
                                                                           FROM Allocation_amounts1__r),(SELECT Approved_Amount__c,Approved__c ,project__c,To_Project__c
                                                                                                         FROM Allocation_amounts__r),( SELECT Total_cost__c, total_Invoice_cost__c, Purchase_order_cloesed__c FROM Purchase_orders__r),
                                       (SELECT musqot__subproject__c ,musqot__Total_spent__c FROM Invoices__r),(SELECT musqot__Budget__c FROM Budget__r) from SubProject__c where  Project_del__c =:prjId order by name limit 250];
        
        if(subPrjs<>null){
            boolean drawFinSub =  true ;
        }
        else
        {
            boolean drawFinSub =  false ;  
        }  
        Decimal allocationRec;
        Decimal subAllocationRec; 
        Decimal reserved; 
        Decimal invoices; 
        Decimal budget; 
        for(SubProject__c sp : subPrjs){
            allocationRec=0.00;
            subAllocationRec=0.00;
            reserved =0.00; 
            budget=0.00; 
            invoices=0.00; 
            for(Allocation_amount__c alRe:sp.Allocation_amounts1__r){
                if(alRe.project__c<>null && alRe.Approved_Amount__c<>null){
                    subAllocationRec+=alRe.Approved_Amount__c;
                }   
                
            }
            for(Allocation_amount__c alRec: sp.Allocation_amounts__r){
                if(alRec.To_Project__c<>null){
                    if(alRec.Approved_Amount__c<>null){
                        allocationRec +=alRec.Approved_Amount__c;
                    }   
                }
            }
            
            
            for(Purchase_order__c pruchOrdr : sp.Purchase_orders__r){
                if(pruchOrdr.Purchase_order_cloesed__c ){
                    reserved += 0;
                }
                else if( pruchOrdr.total_Invoice_cost__c >  pruchOrdr.Total_cost__c){
                    reserved += 0;
                }else if(pruchOrdr.total_Invoice_cost__c > 0){
                    reserved +=(pruchOrdr.total_Invoice_cost__c-pruchOrdr.Total_cost__c);
                }
                else {
                    reserved += pruchOrdr.Total_cost__c; 
                }
            } 
            for( Invoice__c i: sp.Invoices__r){         
                if(i.Total_spent__c<>null)
                    invoices+=i.Total_spent__c;
                
            }  
            
            for( Budget__c  b : sp.Budget__r){         
                if(b.musqot__Budget__c<>null)
                    budget+=b.musqot__Budget__c;
                
            }      
            Financials sf = new Financials();
            Decimal remaining = (Decimal)  allocationRec- subAllocationRec- reserved-invoices ;
            
            if(sp<>null){
                sf.type = sp.Name;
            }
            
            sf.allocated = allocationRec;
            sf.Suballocated = subAllocationRec;
            sf.reserved = reserved ;
            sf.spent = invoices;
            sf.remaining = remaining;
            sf.budget = budget;  
            if (remaining < 0) {
                sf.color = 'red';
            } else {
                sf.color = 'black';
            }
            subfinlist.add(sf);
        }
        return subfinlist;  
    } 
    /******************************************************** 
Financials:This wrapper class for display financial summary of Marketing_activity in Subproject.
/********************************************************/    
    public List<Financials> getMaFin(){
        
        List<Financials> mafinlist = new List<Financials>();
        
        List<Marketing_activity__c> maPrjs = [select Id, Name, musqot__Project__c,(SELECT musqot__Approved_Amount__c,musqot__Approved__c ,musqot__project__c,musqot__To_Marketing_activity__c
                                                                                   FROM Allocation_amounts__r),( SELECT Total_cost__c, total_Invoice_cost__c, Purchase_order_cloesed__c FROM Purchase_orders__r), (SELECT musqot__Marketing_activity__c,musqot__Total_spent__c FROM Invoices__r)
                                              
                                              from Marketing_activity__c where Project__c =:prjId  order by name limit 250];
        
        Decimal allocationRec;
        Decimal reserved; 
        Decimal invoices; 
        
        for(Marketing_activity__c ma : maPrjs ){
            allocationRec=0.00;
            reserved =0.00; 
            invoices=0.00; 
            
            for(musqot__Allocation_amount__c alRec: ma.Allocation_amounts__r){
                if(alRec.musqot__To_Marketing_activity__c   <>null){
                    if(alRec.musqot__Approved_Amount__c<>null){
                        allocationRec +=alRec.musqot__Approved_Amount__c;
                    }   
                }
            }
            
            
            for(Purchase_order__c pruchOrdr : ma.Purchase_orders__r){
                if(pruchOrdr.Purchase_order_cloesed__c ){
                    reserved += 0;
                }
                else if( pruchOrdr.total_Invoice_cost__c >  pruchOrdr.Total_cost__c){
                    reserved += 0;
                }
                else if(pruchOrdr.total_Invoice_cost__c>0){
                    reserved+=(pruchOrdr.total_Invoice_cost__c-pruchOrdr.Total_cost__c);
                }
                else {
                    reserved += pruchOrdr.Total_cost__c; 
                }
            } 
            for( Invoice__c i: ma.Invoices__r){         
                if(i.Total_spent__c<>null)
                    invoices+=i.Total_spent__c;
                
            }  
            
            
            Financials mf = new Financials();
            Decimal remaining = (Decimal)  allocationRec- reserved-invoices ;
            
            if(ma<>null){
                mf.type = ma.Name;
            }
            
            mf.allocated = allocationRec;
            mf.reserved = reserved ;
            mf.spent = invoices;
            mf.remaining = remaining;
            if (remaining < 0) {
                mf.color = 'red';
            } else {
                mf.color = 'black';
            }
            mafinlist.add(mf);
        }
        return mafinlist;  
    } 
    //janardhan: Resource implementation start
    /*************************
Resources: Wrapeerclass
*************************/
    public class Resources {
        public String type{get;set;}
        public Decimal allocated{get;set;}
        public Decimal approved{get;set;}
        public Decimal Estimate{get;set;}
        public Decimal Outcome{get;set;}
        public Decimal remaining{get;set;}
        public Decimal Suballocated{get;set;}
        public Decimal budget{get;set;}
        public Decimal budget2{get;set;}
        public String color{get;set;}
    }
    /******************************************************************
getres:t  display financial summary of project Allaocation resources
********************************************************************/ 
    public List<Resources> getres(){  
        
        List<Resources> reslist = new List<Resources>();
        AggregateResult allocation = [
            SELECT SUM(musqot__Approved_houver__c) totals 
            FROM musqot__Allocation_resources__c
            WHERE musqot__To_Project__c = :prjId];
        
        AggregateResult suballocation = [
            SELECT SUM(musqot__Approved_houver__c) totals 
            FROM musqot__Allocation_resources__c
            WHERE musqot__Project__c = :prjId];  
        
        AggregateResult estimates = [
            SELECT SUM(Allocated_h__c) totals 
            FROM Task
            WHERE WhatId = :prjId
        ];
        AggregateResult outcomes = [
            SELECT SUM(Outcome_h__c) totals 
            FROM Task
            WHERE WhatId = :prjId
        ];
        
        AggregateResult budgetamn = [
            SELECT SUM(Budget_h__c) totals 
            FROM Budget__c
            WHERE musqot__subproject__c = :prjId];
        
        Resources r = new Resources();
        
        Decimal alloc = (Decimal) allocation.get('totals');
        alloc = (alloc == null) ? 0.0 : alloc.setscale(1);
        
        Decimal suballoc = (Decimal)suballocation.get('totals');
        suballoc = (suballoc == null) ? 0.0 : suballoc.setscale(1); 
        
        Decimal Outcome = (Decimal) outcomes.get('totals');
        Outcome = (Outcome == null) ? 0.0 : Outcome.setscale(1);
        
        Decimal Estimate = (Decimal) estimates.get('totals');
        Estimate = (Estimate == null) ? 0.0 : Estimate.setscale(1);
        
        Decimal budget = (Decimal) budgetamn.get('totals');
        budget = (budget == null) ? 0.0 : budget.setscale(1);
        if(Estimate<Outcome){
            Estimate=Outcome;
        }
        Decimal remaining = (Decimal)  alloc - suballoc - Estimate;
        remaining = (remaining == null) ? 0.0 : remaining.setscale(1);  
        
        r.type =  parentName;
        r.allocated = alloc;
        r.suballocated = suballoc;
        r.Estimate = Estimate;
        r.outcome = outcome;
        r.remaining = remaining;
        r.budget = budget;
        
        
        if (remaining < 0) {
            r.color = 'red';
            
        } else if (remaining < 1) {
            r.color = 'black';
            
        } else {
            r.color = 'black';
            
        }
        
        
        reslist.add(r);
        return reslist;  
    }
    /*********************************************************************************
gettaskrecs:it  display financial summary of subproject all Tasks 
*****************************************************************************************/ 
    public List<Task> gettaskrecs(){
        return [Select Id, WhoId, WhatId,what.name,musqot__Remaining__c, CreatedById,Subject,status, ActivityDate,musqot__Status_image_id__c,musqot__StatusImage__c, Priority, OwnerId, Description, IsDeleted, AccountId, IsClosed,  Allocated_h__c, Outcome_h__c,Task_description__c,Task_name__c FROM Task where whatid=:PrjID  order by Task_name__c  limit 400];
    }
    /*********************************************************************************
getSubres:it  display financial summary of subsubproject of Allaocationresources 
*****************************************************************************************/ 
    public List<Resources> getSubres(){
        
        List<Resources> ressublist = new List<Resources>();
        
        List<SubProject__c> subPrjs1 = [select Id, Name, Parent_project__c,(SELECT musqot__Approved_houver__c,Project__c,musqot__To_Project__c
                                                                            FROM Allocation_resources__r),(SELECT musqot__Approved_houver__c,Project__c,musqot__To_Project__c
                                                                                                           FROM Allocation_resources1__r),( SELECT Outcome_h__c,Allocated_h__c 
                                                                                                                                           FROM Tasks
                                                                                                                                          ),(SELECT Budget_h__c
                                                                                                                                             FROM Budget__r
                                                                                                                                            ) from SubProject__c where Project_del__c =:prjId  order by Name limit 250];
        
        Decimal allocationRec;
        Decimal subAllocationRec; 
        Decimal estimateRec; 
        Decimal outcomRec; 
        Decimal budgetamnRec; 
        for(SubProject__c sp1 : subPrjs1){
            allocationRec=0.0;
            subAllocationRec=0.0;
            estimateRec=0.0; 
            budgetamnRec=0.0; 
            outcomRec=0.0; 
            for(musqot__Allocation_resources__c alRe : sp1.musqot__Allocation_resources__r){
                if(alRe.Project__c<>null){
                    if(alRe.musqot__Approved_houver__c<>null){
                        subAllocationRec+=alRe.musqot__Approved_houver__c;
                    }  
                } 
                
            }
            for(musqot__Allocation_resources__c alRec: sp1.musqot__Allocation_resources1__r){
                if(alRec.musqot__To_Project__c<>null){
                    if(alRec.musqot__Approved_houver__c<>null){
                        allocationRec += alRec.musqot__Approved_houver__c;
                    } 
                }
            }
            for(Task t:sp1.Tasks){
                
                if(t.Allocated_h__c <> null &&t.Outcome_h__c<> null){
                    estimateRec+=t.Allocated_h__c;
                    outcomRec+=t.Outcome_h__c;
                }
            }
            for( Budget__c  b : sp1.Budget__r){         
                if(b.Budget_h__c<>null)
                    budgetamnRec+=b.Budget_h__c;
                
            }      
            Resources re = new Resources();
            Decimal remaining = allocationRec-subAllocationRec-estimateRec;
            remaining = (remaining == null) ? 0.0 : remaining.setscale(1);  
            
            if(subPrjs1<>null){
                re.type = sp1.Name;
            }
            re.allocated = allocationRec;
            re.Suballocated = subAllocationRec;  
            re.Estimate = estimateRec;
            re.Outcome = outcomRec;
            re.remaining = remaining;
            re.budget = budgetamnRec; 
            if (remaining < 0) {
                re.color = 'red';
            } else {
                re.color = 'black';
            }
            ressublist.add(re);  
            
        }
        
        return ressublist; 
    }
    
    
    
    /******************************************************** 
getusertaskrecs:it  display particular users of project tasks
********************************************************/ 
    //implemented by janardhan
    public List<Resources> getusertaskrecs(){
        
        List<Resources> usertakslist = new List<Resources>();
        try{
            List<Task> usrlist =  [Select Id,ownerId,CreatedByid, owner.name,WhatId, Remaining__c, IsClosed, 
                                   Allocated_h__c, Outcome_h__c,Task_name__c FROM Task where whatid=:prjId  order by  owner.name limit 400]; 
            Map<String,Task> maps= new Map<String,Task>();
            for(Task tsk:usrlist){
                if(tsk.owner.name <>null){
                    if(!maps.containsKey(tsk.owner.name)) 
                        maps.put(tsk.owner.name,tsk); 
                } 
            }
            usrlist=maps.values();
            for(Task ut : usrlist){    
                AggregateResult estimates = [
                    SELECT SUM(Allocated_h__c) totals 
                    FROM Task
                    WHERE ownerId = :ut.ownerId and whatid=:prjId
                ];
                AggregateResult outcomes = [
                    SELECT SUM(Outcome_h__c) totals 
                    FROM Task
                    WHERE ownerId = :ut.ownerId and whatid=:prjId
                ];
                AggregateResult openh = [
                    SELECT SUM(Remaining__c) totals 
                    FROM Task
                    WHERE ownerId = :ut.ownerId and whatid=:prjId
                ];
                Resources utask = new Resources();
                
                Decimal outcome = (Decimal) Outcomes.get('totals');
                outcome = (outcome == null) ? 0.0 : outcome.setscale(1);
                
                Decimal Estimate = (Decimal) Estimates.get('totals');
                Estimate = (Estimate == null) ? 0.0 : Estimate.setscale(1);
                
                Decimal remaining = (Decimal)  openh.get('totals');
                remaining = (remaining == null) ? 0.0 : remaining.setscale(1);  
                
                if(ut<>null){
                    utask.type =ut.owner.name;
                }
                utask.Estimate = Estimate;
                utask.Outcome = outcome;
                utask.remaining = remaining;
                if (remaining < 0) {
                    utask.color = 'red';
                } else {
                    utask.color = 'black';
                }
                usertakslist.add(utask);
            }
        }catch(exception e){}
        return usertakslist; 
    }   
    /*********************************************************************************
gettaskrecs:it  display financial summary of marketing activity of Allaocationresources 
*****************************************************************************************/ 
    public List<Resources> getMares(){
        
        List<Resources> mareslist = new List<Resources>();
        List<Marketing_activity__c> maPrjs = [select Id, Name, musqot__Project__c,(SELECT musqot__Approved_houver__c,Project__c,musqot__To_marketing_activity__c
                                                                                   FROM Allocation_resources__r),( SELECT Outcome_h__c,Allocated_h__c 
                                                                                                                  FROM Tasks
                                                                                                                 )  from Marketing_activity__c where Project__c =:prjId order by name];
        Decimal allocationRec;
        Decimal subAllocationRec; 
        Decimal estimateRec; 
        Decimal outcomRec; 
        Decimal budgetamnRec; 
        for(Marketing_activity__c ma : maPrjs){    
            allocationRec=0.0;
            subAllocationRec=0.0;
            estimateRec=0.0; 
            budgetamnRec=0.0; 
            outcomRec=0.0; 
            
            for(musqot__Allocation_resources__c alRec: ma.musqot__Allocation_resources__r){
                if(alRec.musqot__To_marketing_activity__c<>null){
                    if(alRec.musqot__Approved_houver__c<>null){
                        allocationRec += alRec.musqot__Approved_houver__c;
                    } 
                }
            }
            for(Task t:ma.Tasks){
                if(t.Allocated_h__c<>null&&t.Outcome_h__c<>null){
                    estimateRec+=t.Allocated_h__c;
                    outcomRec+=t.Outcome_h__c;
                }}
            
            Resources rm = new Resources();
            Decimal remaining = allocationRec-subAllocationRec-estimateRec;
            remaining = (remaining == null) ? 0.0 : remaining.setscale(1);  
            
            
            if(ma<>null){
                rm.type = ma.Name;
            }
            
            rm.allocated = allocationRec ;
            rm.Estimate = estimateRec;
            rm.Outcome = outcomRec;
            rm.remaining = remaining;
            if (remaining < 0) {
                rm.color = 'red';
            } else {
                rm.color = 'black';
            }
            mareslist.add(rm);
        }
        return mareslist;  
    }
    
    public void calcluteRemaing(){
        decimal appAmount;
        List<Financials> finlist = new List<Financials>();
        
        AggregateResult allocation = [
            SELECT SUM(Approved_Amount__c) totals 
            FROM Allocation_amount__c
            WHERE To_Plan__c = :prjobj.Parent_project__c];//planId
        
        AggregateResult suballocation = [
            SELECT SUM(Approved_Amount__c) totals 
            FROM Allocation_amount__c
            WHERE Plan__c = :prjobj.Parent_project__c
        ];
        
        List<Purchase_order__c> POcalk = new List<Purchase_order__c>();
        POcalk = [SELECT Total_cost__c, total_Invoice_cost__c, Purchase_order_cloesed__c FROM Purchase_order__c WHERE Project__c = :prjobj.Parent_project__c];
        Decimal reserved = 0;
        for(Purchase_order__c pruchOrdr : POcalk){
            if(pruchOrdr.Purchase_order_cloesed__c ){
                reserved += 0;
            }
            else if( pruchOrdr.total_Invoice_cost__c >  pruchOrdr.Total_cost__c){
                reserved += 0;
            }
            else if(pruchOrdr.total_Invoice_cost__c >0) {
                reserved +=(pruchOrdr.Total_cost__c-pruchOrdr.total_Invoice_cost__c); 
            }else 
            {
                reserved +=pruchOrdr.Total_cost__c ;
            }
        }       
        
        AggregateResult invoices = [
            SELECT SUM(Total_spent__c) totals 
            FROM Invoice__c
            WHERE Project__c = :prjobj.Parent_project__c
        ];
        
        Financials f = new Financials();
        
        Decimal spent = (Decimal) invoices.get('totals');
        spent = (spent == null) ? 0.00 : spent.setscale(2);
        reserved = (reserved == null) ? 0.00 : reserved.setscale(2);
        
        Decimal alloc = (Decimal) allocation.get('totals');
        alloc = (alloc == null) ? 0.00 : alloc.setscale(2);
        
        Decimal suballoc = (Decimal) suballocation.get('totals');
        suballoc = (suballoc == null) ? 0.00 : suballoc.setscale(2);
        Decimal remaining = (Decimal)  alloc - suballoc - reserved-spent ;
        
    }   
}