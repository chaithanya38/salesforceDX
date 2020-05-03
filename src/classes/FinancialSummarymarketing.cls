/***********************************************************************
Class Name: FinancialSummarymarketing
Author:G G Janardhanreddy          Last modified by:Poornima Natesha
Date:30/6/2014                     Date: 22/06/2015 
********©2013 Musqot marketing technology Pvt ltd **********************/
public with sharing class FinancialSummarymarketing{
    public String markID{get;set;}
    public String planId{get;set;}
    private ApexPages.standardController controller;
    private List<Financials> fin;
    public List<musqot__Activity__c> musAct{get;set;}
    private List<Purchase_order__c> purs;
    private List<Invoice__c> inv;
    private List<Purchase_order__c> orders;
    private List<Invoice__c> invoices;
    public String taskid{get;set;}
    public List<Purchase_order__c> temmils;
    private List<Subproject__c> ParentProj;
    private List<Project__c> plan;
    private List<Allocation_amount__c> amt;    
    private Marketing_activity__c mark;
    public String workId {get; set;}
    public boolean Level3{get;set;}
    public boolean Level4{get;set;}
    public boolean Level5{get;set;}
    public boolean disableReFund{get;set;}
    private Subproject__c sub;
    String tabInFocus;
    String tabId;    
    String maxPO; 
    public boolean disablePO{get;set;}
    
    public FinancialSummarymarketing(ApexPages.StandardController controller) {      
        this.controller = controller;
        this.mark  = (Marketing_activity__c)controller.getRecord();
        markID= controller.getRecord().Id;   
        tabInFocus = System.currentPageReference().getParameters().get('tab');    
        musAct=[SELECT id,Name,keycode__c,Use_Allocation__c,Use_Budget__c,
                musqot__Use_Finance1__c,Use_Forcasting__c,Use_milestones__c,
                Use_Resource__c  FROM musqot__Activity__c limit 1];
        Marketing_activity__c mrk=[SELECT Id,Starts_date__c, musqot__Ends_date__c 
                                   FROM musqot__Marketing_activity__c where id=:markID];
        if(mrk.musqot__Ends_date__c <system.today()){
            disableReFund=true;
        }
        if(musAct[0].Use_Resource__c ==true){         
            level5=true;
        }  
        if(musAct[0].musqot__Use_Finance1__c==true){         
            level4=true;
        }   
        securitySetting();   
    }
    /******************************************************** 
getTabInFocus():This is for redirect particular tab.
/********************************************************/    
    public String getTabInFocus() {
        return tabInFocus;
    }
    
    public void setTabInFocus(String s ) {
        this.tabInFocus = s;
    }
    /******************************************************** 
securitySetting():security gives for  financial summery page.
/********************************************************/    
    public void securitySetting(){
        String myuserrole;
        String MyProflieName;
        String ccRole;
        String marktingid;
        String planRole;
        List<Profile> userprofile ;
        String parentRole ;
        String userid ;
        String parentplanid ;
        String subprojectid ;
        list<musqot__Subproject__c> parentpID;
        List<Allocation_amount__c> parentid; 
        String parentprojID ;
        String PermissionSet;
        
        // check user Profile
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
        
        List<musqot__Members__c> userrole=new List<musqot__Members__c>();       
        userrole = [Select musqot__Role__c from musqot__Members__c where musqot__Marketingmebers__c=:Markid AND musqot__ProjUsers__c =:UserInfo.getUserId() limit 1];        
        if(!userrole.isEmpty()){
            myuserrole = userrole[0].musqot__Role__c;             
        }             
        parentid = [Select  musqot__Costcentre__r.musqot__cc_Owner__c ,Costcentre__r.name from musqot__Allocation_amount__c where musqot__To_Plan__c =:parentplanid  limit 1];                                        
        String myuserid;
        if(!parentid.isEmpty()){
            myuserid = parentid[0].Costcentre__r.cc_Owner__c;             
        }
        If (myuserid == userid ){
            ccRole = 'Owner';
        }        
        // Check Plan Owner
        userrole = [Select id,Role__c from Members__c where 
                    ProjMembers__c=:parentplanid AND ProjUsers__c =:UserInfo.getUserId() limit 1];         
        if(!userrole.isEmpty()){
            planRole = userrole[0].musqot__Role__c;             
        }
        // Check Parent Owner
        try{
            parentpID = [select Parent_project__c from Subproject__c 
                         where Parent_project__c  =:parentplanid limit 1];             
        }
        Catch(Exception e){
        }
        if(!parentpID.isEmpty()){
            parentprojID = parentpID [0].Parent_project__c ;
        }
        userrole = [Select Id,musqot__Role__c from Members__c where
                   SubProjMembers__c=:parentprojID AND ProjUsers__c =:UserInfo.getUserId()];
        if(!userrole.isEmpty()){
            parentRole = userrole[0].musqot__Role__c;
        }
        Permissionlist__c pset=Permissionlist__c.getInstance(PermissionSet);
        Profilelist__c p3 = Profilelist__c.getInstance(MyProflieName);  
        if(p3<>null||pset<>null){            
            If(MyProflieName=='System Administrator'||myuserrole == 'Owner' ){
                Level3=True;
            }        
        }
    }
    /******************************************************** 
neworders():This is for redirect to Purchaseorderpage
/********************************************************/       
    Public PageReference neworders(){
        temmils = [Select Id, Name, Description__c,musqot__Purchase_order_cloesed__c , Total_cost__c,Project__c,subproject__c,Marketing_activity__c, Send_date__c, Purchase_order__c, total_Invoice_cost__c,Effective_date__c, Purchase_article__c, Allocation_amount__c, Purchase_order_name__c FROM Purchase_order__c  where Marketing_activity__c=:markID limit 100 ];
        PageReference orderspage=new PageReference('/apex/Purchaseorderpage?&markID='+EncodingUtil.urlEncode(markID,'UTF-8')+'&maxpo='+EncodingUtil.urlEncode(maxPO,'UTF-8'));
        orderspage.setredirect(true);
        return orderspage; 
    }
    /****************************************************************
gotopurchaseorderedit() : redirect to PurchaseorderEditdetailspage 
/********************************************************/  
    public PageReference gotopurchaseorderedit() {
        String orderid= ApexPages.currentPage().getParameters().get('orderid'); 
        PageReference pgr;
        if(orderid<>null){       
            pgr =new PageReference ('/apex/PurchaseorderEditdetailspage?markID='+EncodingUtil.urlEncode(markID,'UTF-8')+'&purid='+EncodingUtil.urlEncode(orderid,'UTF-8')+'&maxpo='+EncodingUtil.urlEncode(maxPO,'UTF-8'));
            return pgr;
        }
        return null;
    } 
    /******************************************************** 
getorders():This is for getting Purchase_order__c record
/********************************************************/     
    public List<Purchase_order__c> getorders(){
        // return [Select Id, Name, Description__c,musqot__Purchase_order_cloesed__c,Total_cost__c,Project__c,subproject__c,Marketing_activity__c, Send_date__c, Purchase_order__c, total_Invoice_cost__c,Effective_date__c, Purchase_article__c, Allocation_amount__c, Purchase_order_name__c FROM Purchase_order__c  where Project__c =:planid AND subproject__c=null AND total_Invoice_cost__c<>0 LIMIT 100];
        
        List<Purchase_order__c> PO =  [Select Id, Name,Description__c,musqot__Purchase_order_cloesed__c,Total_cost__c,Project__c,subproject__c,Marketing_activity__c, Send_date__c, Purchase_order__c, total_Invoice_cost__c,Effective_date__c, Purchase_article__c, Allocation_amount__c, Purchase_order_name__c FROM Purchase_order__c  where Marketing_activity__c=:markID order by Purchase_order_name__c LIMIT 100];
        
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
newinvoices():redirect to Invoicepage
***************************************/   
    Public PageReference newinvoices(){
        inv= [Select Id, Name, Description__c, Marketing_activity__c,Project__c,Purchase_article__c,Purchase_orders__c, subproject__c, supplier__c, Total_spent__c FROM Invoice__c  where Marketing_activity__c=:markID limit 200 ];
        PageReference orderspage=new PageReference('/apex/Invoicepage?&markID='+EncodingUtil.urlEncode(markid,'UTF-8'));
        orderspage.setredirect(true);
        return orderspage;     
    }
    /*********************************************
gotoinvoiceedit():redirect to InvoiceEditpage 
***********************************************/
    
    public PageReference gotoinvoiceedit() {
        String invid= ApexPages.currentPage().getParameters().get('invid'); 
        PageReference pgr;
        if(invid<>null){       
            pgr =new PageReference ('/apex/InvoiceEditpage?markID='+EncodingUtil.urlEncode(markID,'UTF-8')+'&invid='+EncodingUtil.urlEncode(invid,'UTF-8'));
            return pgr;
        }
        return null;
    } 
    /******************************************************** 
getinv():This is for display financial summary of Markertin activity.
********************************************************/        
    public List<Invoice__c> getinv(){
        List<Invoice__c>invList=new List<Invoice__c>();
        List<Invoice__c>invList1=new List<Invoice__c>();   
        invList = [Select Id, Name, Description__c, Marketing_activity__c,Project__c,Purchase_article__c,Purchase_orders__R.Purchase_order_name__c, subproject__c, supplier__c, Total_spent__c FROM Invoice__c  where Marketing_activity__c=:markID order by supplier__c];
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
    
    public List<Financials> getFin(){
        List<Financials> finlist = new List<Financials>();
        Allocation_amount__c  am;
        try{
            am = [SELECT project__c from Allocation_amount__c where To_Marketing_activity__c =:markID limit 1];
        }catch(Exception e){
        }
        if(am<>null){
            ParentProj  = [SELECT Name FROM Subproject__c WHERE Id =:am.project__c];
        }
        AggregateResult allocation = [
            SELECT SUM(Approved_Amount__c) totals 
            FROM Allocation_amount__c
            WHERE To_Marketing_activity__c = :markid];
        
        // New calk of AggregateResult purchaseOrders
        List<Purchase_order__c> POcalk = new List<Purchase_order__c>();
        POcalk = [SELECT Total_cost__c, total_Invoice_cost__c, Purchase_order_cloesed__c FROM Purchase_order__c WHERE Marketing_activity__c = :markid ];
        Decimal reserved = 0;
        for(Purchase_order__c pruchOrdr : POcalk){
            if(pruchOrdr.Purchase_order_cloesed__c ){
                reserved += 0;
            }
            else if( pruchOrdr.total_Invoice_cost__c >  pruchOrdr.Total_cost__c){
                reserved += 0;
            }
            else {
                reserved += pruchOrdr.Total_cost__c; 
            }
        } 
        AggregateResult invoices = [
            SELECT SUM(Total_spent__c) totals 
            FROM Invoice__c
            WHERE Marketing_activity__c = :markid
        ];
        
        Financials f = new Financials();
        
        Decimal alloc = (Decimal) allocation.get('totals');
        alloc = (alloc == null) ? 0.00 : alloc.setscale(2);
        
        Decimal spent = (Decimal) invoices.get('totals');
        spent = (spent == null) ? 0.00 : spent.setscale(2);
        
        
        reserved = (reserved == null) ? 0.00 : reserved.setscale(2);
        
        Decimal remaining = (Decimal)  alloc - reserved -spent ;
        maxPO = String.valueOf(remaining);
        
        if(ParentProj<>null){
            f.type = ParentProj[0].Name;
        }
        f.allocated = alloc;
        f.reserved = reserved;
        f.spent = spent;
        f.remaining = remaining;
        if (remaining < 0) {
            f.color = 'red';
            
        } else if (remaining < 1) {
            f.color = 'black';
            
        } else {
            f.color = 'black';
            
        }
        finlist.add(f); 
        return finlist;
    }
    ////janardhan: Resource implementation start
    public List<Resources> getres(){
        List<Resources> reslist = new List<Resources>();
        musqot__Allocation_resources__c  ar;
        try{
            ar = [SELECT musqot__Project__c from musqot__Allocation_resources__c where musqot__To_marketing_activity__c =:markID limit 1];
        }catch(Exception e){
        }
        if(ar<>null){
            ParentProj  = [SELECT Name FROM Subproject__c WHERE Id =:ar.project__c];
        }
        AggregateResult allocation = [
            SELECT SUM(musqot__Approved_houver__c) totals 
            FROM musqot__Allocation_resources__c
            WHERE musqot__To_marketing_activity__c = :markid];
        AggregateResult estimates = [
            SELECT SUM(Allocated_h__c) totals 
            FROM Task
            WHERE WhatId = :markid
        ];
        AggregateResult outcomes = [
            SELECT SUM(Outcome_h__c) totals 
            FROM Task
            WHERE WhatId = :markid];
        Resources rm = new Resources();
        Decimal outcome = (Decimal) Outcomes.get('totals');
        outcome = (outcome == null) ? 0.0 : outcome.setscale(1);
        
        Decimal Estimate = (Decimal) Estimates.get('totals');
        Estimate = (Estimate == null) ? 0.0 : Estimate.setscale(1);
        
        Decimal alloc = (Decimal) allocation.get('totals');
        alloc = (alloc == null) ? 0.0 : alloc.setscale(1);
        if(Estimate<Outcome){
            Estimate=Outcome;
        }
        Decimal remaining = (Decimal)  alloc -Estimate;
        remaining = (remaining == null) ? 0.0 : remaining.setscale(1); 
        if(ParentProj<>null){
            rm.type = ParentProj[0].Name;
        }
        rm.allocated = alloc;
        rm.Estimate = Estimate;
        rm.Outcome = outcome;
        rm.remaining = remaining;
        
        
        if (remaining < 0) {
            rm.color = 'red';
            
        } else if (remaining < 1) {
            rm.color = 'black';
            
        } else {
            rm.color = 'black';
            disablePO = false;
        }        
        
        
        reslist.add(rm); 
        return reslist;
    }
    /******************************************************** 
getusertaskrecs:it  display particular users of project tasks
********************************************************/ 
    public List<Resources> getusertaskrecs(){ 
        List<Resources> usertakslist = new List<Resources>();
        try{
            List<Task> usrlist =  [Select Id,ownerId,CreatedByid, owner.name,WhatId, Remaining__c, IsClosed, 
                                   Allocated_h__c, Outcome_h__c,Task_name__c FROM Task where 
                                   whatid=:markid order by owner.name  limit 400]; 
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
                    WHERE ownerId = :ut.ownerId and whatid=:markid
                ];
                AggregateResult outcomes = [
                    SELECT SUM(Outcome_h__c) totals 
                    FROM Task
                    WHERE ownerId = :ut.ownerId and whatid=:markid
                ];
                AggregateResult openh = [
                    SELECT SUM(Remaining__c) totals 
                    FROM Task
                    WHERE ownerId = :ut.ownerId and whatid=:markid
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
    /******************************************************** 
Financials:it display  marketing activity All tasks
********************************************************/   
    public List<Task> gettaskrecs(){
        return [Select Id, WhoId, WhatId,what.name,Remaining__c, 
                CreatedById,Subject,status, ActivityDate,Status_image_id__c,
                StatusImage__c, Priority, OwnerId, Description, IsDeleted, 
                AccountId, IsClosed,  Allocated_h__c, Outcome_h__c,Task_description__c,
                Task_name__c FROM Task where whatid=:markid  order by Task_name__c limit 400];
    }
  
    /******************************************************** 
Financials:This wrapper class for display financial summary of Marketing activity.
********************************************************/   
    public class Financials {
        public String type{get;set;}
        public String color{get;set;}
        public Decimal allocated{get;set;}
        public Decimal reserved{get;set;}
        public Decimal spent{get;set;}
        public Decimal suballocated{get;set;}
        public Decimal remaining{get;set;}
    }  
    //janardhan: Resource implementation start
    public class Resources {
        public String type{get;set;}
        public Decimal allocated{get;set;}
        public Decimal approved{get;set;}
        public Decimal Estimate{get;set;}
        public Decimal Outcome{get;set;}
        public Decimal remaining{get;set;}
        public Decimal Suballocated{get;set;}
        public Decimal budget{get;set;}
        public String color{get;set;}
    }//janardhan :end
}