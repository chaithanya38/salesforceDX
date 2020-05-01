/*******************************************************
Class Name: FinancialSummary 
Author:Peter Carlsson             Last modified by:Nagaraju G
Date:8/4/2014                     Date:14/10/2015
@Desc: Adding "musqot__FiscalYear__c"  field in getbudget in constructor.
********©2013 Musqot marketing technology Pvt ltd *******/
public with sharing class FinancialSummary {
    public String planId{get;set;}
    public String prjId{get;set;}
    public Budget__c getbudget {get;set;}
    public List<musqot__Activity__c> musAct{get;set;}
    Public list<task> tsk{get;set;}
    private ApexPages.standardController controller;
    private List<Financials> fin;
    private list<Resources> res;
    private List<Financials> subfin;
    private List<Allocation_amount__c> costcenter;
    private List<Allocation_amount__c> users;
    private List<Allocation_resources__c> users1;
    private list<musqot__Allocation_resources__c> costcenter_res;
    private List<Purchase_order__c> orders;
    private List<Forcast__c> forcast;
    private List<task> tasks;
    public list<task> taskrecs;
    private List<Invoice__c> invoices;
    private Project__c plan;
    public String taskid{get;set;}
    public String workId {get; set;}
    public boolean Level3{get;set;}
    public boolean Level4{get;set;}
    public boolean Level5{get;set;}
    public boolean Level6{get;set;}
    public List<Purchase_order__c> temmils;
    public List<Invoice__c> inv;
    public string Lname{get;set;} 
    String tabInFocus;
    String tabId;
    String maxPO; 
    //
    public double sumAllocated{get;set;}
    public double sumSubAlloc{get;set;}
    public double sumReserved{get;set;}
    public double sumSpent{get;set;}
    public double sumRemaing{get;set;}
    public double sumBudget{get;set;}    
    public boolean disablePO{get;set;}
    public string poEffectiveYear;
    public string budgetYears{get;set;}
    public list<string> budgetIds;
    public Decimal budget{get;set;}
    public list<AggregateResult> allocationList;
    public list<AggregateResult> suballocationList;
    public list<AggregateResult> budgetAggList;
    public list<AggregateResult> budgetAggList2;
    public List<string>subprojectIdList;
    public string fiscalYearName{get;set;}
    public boolean showRequest{get;set;}
    public FinancialSummary(ApexPages.StandardController controller) {      
        this.controller = controller;
        this.plan = (Project__c)controller.getRecord();
        taskid= ApexPages.currentPage().getParameters().get('taskid');        
        tabInFocus = System.currentPageReference().getParameters().get('tab');
        planId= controller.getRecord().Id; 
        subprojectIdList=new list<string>();
        budgetAggList2=new list<AggregateResult>();
        project__c projectRec=[SELECT Id,Starts_date__c,musqot__Ends_date__c from project__c where id=:planId];
        if(projectRec.Ends_date__c< system.today()){
            showRequest=true;
        }
        try{            
        getbudget = [SELECT Name, Budget__c.Owner.name,LastModifiedBy.name,LastModifiedDate,
                     Approved__c ,Approved_date__c , Budget__c , Budget_h__c ,user__c , 
                     Description__c,Project__c 
                     ,FiscalYear__c FROM Budget__c WHERE Project__c= :planId Order by CreatedDate limit 1]; //subproject__c = NULL and                                     
         FiscalYearSettings Result= [SELECT Id, Name
                                      FROM FiscalYearSettings where id=:getbudget.FiscalYear__c];
          fiscalYearName=Result.Name;    
        }catch(Exception e){
        }
        list<subproject__c>subprojectList=[SELECT id,Name FROM subproject__c
                                           where Parent_project__c=:planId AND Project_del__c=null limit 100];
        for(subproject__c s:subprojectList){
            subprojectIdList.add(s.id);
        }
        musAct=[SELECT id,Name,keycode__c,Use_Allocation__c,Use_Budget__c,Use_Finance1__c,
                Use_Forcasting__c,Use_milestones__c,Use_Resource__c  FROM Activity__c limit 1];
        if(musAct[0].musqot__Use_Budget__c==true){         
            level4=true;
        }  
        if(musAct[0].Use_Resource__c ==true){         
            level5=true;
        }  
        if(musAct[0].musqot__Use_Finance1__c==true){         
            level6=true;
        } 
        securitySetting();
    }
    /***************************************** 
getTabInFocus():redirect to particular tab 
*****************************************/    
    public String getTabInFocus() {
        return tabInFocus;
    }
    
    public void setTabInFocus(String s ) {
        this.tabInFocus = s;
    }
    /******************************************************** 
securitySetting():security gives for financial summery page.
********************************************************/    
    public void securitySetting(){
        String myuserrole;
        String ownerrole; 
        String MyProflieName;
        String userid ;
        List<Allocation_amount__c> parentid;
        String PermissionSet;
        list<profile> userprofile =new List<Profile>();
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
        
        
        list<Members__c> userrole =new List<Members__c> ();
        userrole = [Select Id,musqot__Role__c from Musqot__Members__c where musqot__ProjMembers__c=:planId AND musqot__ProjUsers__c =:UserInfo.getUserId() limit 1];
        if(!userrole.isEmpty()){
            myuserrole = userrole[0].Role__c;
        }
        parentid=new  List<Allocation_amount__c>(); 
        parentid = [Select musqot__Costcentre__r.OwnerID,musqot__Costcentre__r.musqot__cc_Owner__c  from musqot__Allocation_amount__c where musqot__To_Plan__c =:planId];                               
        String myuserid;
        if(!parentid.isEmpty()){
            myuserid = parentid[0].Costcentre__r.OwnerID;
        }
        If (myuserid == Userinfo.getUserId() ){
            ownerrole = 'Owner';
        }  
        Permissionlist__c pset=Permissionlist__c.getInstance(PermissionSet);
        Profilelist__c p3 = Profilelist__c.getInstance(MyProflieName);  
        if(p3<>null||pset<>null){            
            if(MyProflieName=='System Administrator'||myuserrole == 'Owner')
            {
                Level3=True;
            }       
            else { 
                Level3=False; 
            } 
        }
    }
		//Forecast
    public List<Forcast__c> getForcast(){
        
        List<Forcast__c> FC =  [Select Id, Name, Amount__c,Period__c, Hours__c, Start_date__c, End_date__c, LastModifiedDate
                                FROM Forcast__c  
                                where Plan__c =:planid And End_date__c > YESTERDAY order by Start_date__c  LIMIT 100];
        return FC;
    }
    /****************************************
neworders(): redirect to Purchaseorderpage
*******************************************/    
    Public PageReference neworders(){
        temmils =new List<Purchase_order__c>();
        temmils = [Select Id, Name, Description__c, Total_cost__c,Project__c,subproject__c,
                   Marketing_activity__c, Send_date__c,musqot__Purchase_order_cloesed__c, 
                   Purchase_order__c, total_Invoice_cost__c,Effective_date__c, Purchase_article__c, 
                   Allocation_amount__c FROM Purchase_order__c  where Project__c=:planId Limit 1];
        PageReference orderspage=new PageReference('/apex/Purchaseorderpage?&planid='+EncodingUtil.urlEncode(planid,'UTF-8')+'&maxpo='+EncodingUtil.urlEncode(maxPO,'UTF-8'));
        orderspage.setredirect(true);        
        
        return orderspage; 
    }
    /****************************************************************
gotopurchaseorderedit() :redirect to PurchaseorderEditdetailspage 
******************************************************************/  
    public PageReference gotopurchaseorderedit() {
        String orderid= ApexPages.currentPage().getParameters().get('orderid'); 
        PageReference pgr;
        if(orderid<>null){       
            pgr =new PageReference ('/apex/PurchaseorderEditdetailspage?planid='+EncodingUtil.urlEncode(planid,'UTF-8')+'&purid='+EncodingUtil.urlEncode(orderid,'UTF-8')+'&maxpo='+EncodingUtil.urlEncode(maxPO,'UTF-8'));
            return pgr;
        }
        return null;
    }
    /******************************************************** 
getorders():This is for getting Purchase_order__c record
/********************************************************/  
    public List<Purchase_order__c> getorders(){
       // return [Select Id, Name, Description__c,musqot__Purchase_order_cloesed__c,Total_cost__c,Project__c,subproject__c,Marketing_activity__c, Send_date__c, Purchase_order__c, total_Invoice_cost__c,Effective_date__c, Purchase_article__c, Allocation_amount__c, Purchase_order_name__c FROM Purchase_order__c  where Project__c =:planid AND subproject__c=null AND total_Invoice_cost__c<>0 LIMIT 100];
          
        List<Purchase_order__c> PO =  [Select Id, Name,Description__c,musqot__Purchase_order_cloesed__c,Total_cost__c,Project__c,subproject__c,Marketing_activity__c, Send_date__c, Purchase_order__c, total_Invoice_cost__c,Effective_date__c, Purchase_article__c, Allocation_amount__c, Purchase_order_name__c FROM Purchase_order__c  where Project__c =:planid AND subproject__c=null AND total_Invoice_cost__c<>0 order by musqot__Purchase_order_name__c  LIMIT 100];
        
        List<Purchase_order__c> PO_final= new List<Purchase_order__c> ();
        for(Purchase_order__c P:PO)
        {
            string name = P.Purchase_order_name__c;
            If(name.substringBeforeLast('_')!='Wild_Inv')
            {
                PO_final.add(P);
            }
                
            
        }
        return PO_final;
    } 
    /******************************************************** 
newinvoices():This is for redirect to Invoicepage from Project detail page
********************************************************/  
    Public PageReference newinvoices(){
        inv= new  List<Invoice__c>();
        inv= [Select Id, Name, Description__c, Marketing_activity__c,Project__c,Purchase_article__c,Purchase_orders__c, subproject__c, supplier__c, Total_spent__c FROM Invoice__c  where Project__c=:planId limit 1 ];
        PageReference orderspage=new PageReference('/apex/Invoicepage?&planid='+EncodingUtil.urlEncode(planid,'UTF-8'));
        orderspage.setredirect(true);
        
        return orderspage; 
    }
    /******************************************************** 
gotoinvoiceedit():This is for redirect to InvoiceEditpage from Project detail page
********************************************************/  
    public PageReference gotoinvoiceedit() {
        String invid= ApexPages.currentPage().getParameters().get('invid'); 
        PageReference pgr;
        if(invid<>null){       
            pgr =new PageReference ('/apex/InvoiceEditpage?planid='+EncodingUtil.urlEncode(planid,'UTF-8')+'&invid='+EncodingUtil.urlEncode(invid,'UTF-8'));
            return pgr;
        }
        return null;
    }
    /******************************************************** 
getinv():This is for getting Invoice record
********************************************************/  
    public List<Invoice__c> getinv(){
        List<Invoice__c>invList=new List<Invoice__c>();
        List<Invoice__c>invList1=new List<Invoice__c>();
        invList=[Select Id, Name, Description__c, Marketing_activity__c,Project__c,Purchase_article__c,Purchase_orders__R.Purchase_order_name__c, subproject__c, supplier__c, Total_spent__c FROM Invoice__c  where Project__c=:planId AND subproject__c=null order by supplier__c Limit 100];
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
    
/******************************************************** 
 Raju--- getplanFinancials():This is for display yearwise 
 financial summary of plan  
********************************************************/  
    public List<Financials>getplanFinancials(){
        string cosName='';
        string userName='';
        decimal appAmount;
        string  fiscalYear;
        list<string> invIds=new list<string>();
        decimal alloc;
        Decimal budget;
        Decimal budget2;
        AggregateResult invoices;
        List<Purchase_order__c>poCalclutions= new List<Purchase_order__c>();
        List<Financials>profinlist = new List<Financials>();
        List<Allocation_amount__c>allocationRecList=[SELECT Id,Allocated__c ,Costcentre__r.OwnerID,CreatedBy.Name,
                                                     Costcentre__r.musqot__cc_Owner__c ,Costcentre__r.name,Approved_Amount__c 
                                                    ,FiscalYear__c from Allocation_amount__c where Approved_Amount__c >0 AND (To_Plan__c =:planId OR To_Project__c IN:subprojectIdList)limit 100];
        map<string,Allocation_amount__c>allocationYearMap=new map<string,Allocation_amount__c>();
        map<string,Id>allocationYearWithId=new map<string,Id>();
        if(allocationRecList.size()>0){
            for(Allocation_amount__c a:allocationRecList){
                 // if(a.FiscalYear__c<>null){
                       allocationYearMap.put(a.FiscalYear__c,a);
                       allocationYearWithId.put(a.FiscalYear__c,a.id); 
                 //  }
            }
        }
        Activity__c musAct=[SELECT id,Name,keycode__c,Use_Allocation__c,Use_Budget__c
                            FROM Activity__c limit 1];
        poCalclutions = [SELECT Total_cost__c, total_Invoice_cost__c, Effective_date__c,
                         Purchase_order_cloesed__c,(SELECT Id,Name from Invoiced__r)FROM Purchase_order__c 
                         WHERE Project__c = :planId];
        Map<Id,List<Invoice__c>> invMap = new Map<Id,List<Invoice__c>>();
        for(Purchase_order__c p:poCalclutions){
            invMap.put(p.id,p.Invoiced__r);
        }
        allocationList=[
            SELECT SUM(Approved_Amount__c)totals,FiscalYear__c
            FROM Allocation_amount__c
            WHERE To_Plan__c=:planId GROUP BY  FiscalYear__c 
        ];
       
        suballocationList=[
            SELECT SUM(Approved_Amount__c)totals,FiscalYear__c
            FROM Allocation_amount__c 
            WHERE To_Project__c =:subprojectIdList GROUP BY  
            FiscalYear__c 
        ];
       budgetAggList=[
            SELECT SUM(Budget__c) totals ,FiscalYear__c
            FROM Budget__c
            WHERE Project__c =:planId GROUP BY  
            FiscalYear__c 
        ];
       budgetAggList2= [
            SELECT SUM(Budget__c) totals,FiscalYear__c
            FROM Budget__c
            WHERE Project__c =:planId and 
            subproject__c = NULL GROUP BY  
            FiscalYear__c LIMIT 1];
       Map<id,string>fiscalMap=new Map<id,string>(); 
       list<FiscalYearSettings> ResultList= [SELECT Id, Name
                                      FROM FiscalYearSettings limit 50];
         for(FiscalYearSettings f:ResultList){
            fiscalMap.put(f.id,f.Name);
        }  
      for(string s:allocationYearMap.keySet()){
            decimal spent=0.00;
            decimal suballoc=0.00;
            invIds.clear();
            cosName='';
            Decimal reserved = 0;
            fiscalYear='';
            if(s<>'2015'&& s<>'2016'){
               fiscalYear=fiscalMap.get(s); 
            }
            string compareYear='';
        try{
            compareYear=fiscalYear.substring(0,4);
            List<musqot__Allocation_amount__c>costcenter12=[SELECT Id,Allocated__c ,Costcentre__r.OwnerID,Costcentre__r.musqot__cc_Owner__c ,Costcentre__r.name,Approved_Amount__c, 
                                                          CreatedBy.Name,FiscalYear__c from Allocation_amount__c where Costcentre__c <> null and Approved_Amount__c > 0 and (To_Plan__c =:planId OR To_Project__c IN:subprojectIdList) and FiscalYear__c=:s];
            Map<String, musqot__Allocation_amount__c > maps= new Map<String, musqot__Allocation_amount__c >();
            for(Allocation_amount__c oh:costcenter12){
                if(oh.Costcentre__r.name<>null){
                    if(!maps.containsKey(oh.Costcentre__r.OwnerID)) 
                        maps.put(oh.musqot__Costcentre__r.OwnerID,oh);
                }
            }
            costcenter= maps.values();
           
        }
        catch(Exception e){}
      
       for(AggregateResult a:allocationList){
           if(s==a.get('musqot__FiscalYear__c')){
               alloc= (Decimal)a.get('totals');
           }
       }
       for(AggregateResult a:suballocationList){
           if(s==(string)a.get('musqot__FiscalYear__c')){
               suballoc=(Decimal)a.get('totals');
            }
       }
       for(AggregateResult a:budgetAggList){
           if(s==a.get('musqot__FiscalYear__c')&& a.get('musqot__FiscalYear__c')<>null){
             budget= (Decimal)a.get('totals');
            }
       }
       for(AggregateResult a:budgetAggList2){
           if(s==a.get('musqot__FiscalYear__c')){
              budget2= (Decimal)a.get('totals');
            }else
            budget2=0.00;
       }
       if(poCalclutions.size()>0){    
        for(Purchase_order__c pruchOrdr:poCalclutions){
          
            if(pruchOrdr.Effective_date__c<>null){
                 poEffectiveYear=string.valueOf(pruchOrdr.Effective_date__c.year());
            }    
            if(poEffectiveYear<>null){
                if(poEffectiveYear==compareYear){  
                    for(Invoice__c i:invMap.get(pruchOrdr.Id)){
                        invIds.add(i.Id); 
                    }
                    if(pruchOrdr.Purchase_order_cloesed__c ){
                        reserved += 0;
                    }
                    else if( pruchOrdr.total_Invoice_cost__c >  pruchOrdr.Total_cost__c){
                        reserved += 0;
                    }
                    else if(pruchOrdr.total_Invoice_cost__c >0) {
                        reserved +=(pruchOrdr.Total_cost__c-pruchOrdr.total_Invoice_cost__c); 
                    }else{
                        reserved +=pruchOrdr.Total_cost__c ;
                    }
                } 
            }
          }
       }
 
            invoices=[
            SELECT SUM(Total_spent__c) totals 
            FROM Invoice__c
            WHERE  id IN:invIds];
   
        Financials f = new Financials();
        spent=(Decimal) invoices.get('totals');
        spent = (spent == null) ? 0.00 : spent.setscale(2);
   
        reserved = (reserved == null) ? 0.00 : reserved.setscale(2);
       
        alloc = (alloc == null) ? 0.00 : alloc.setscale(2);
    
        suballoc = (suballoc == null) ? 0.00 : suballoc.setscale(2);
        
        budget2= (budget2 == null) ? 0.00 : budget2.setscale(2); 
        
        Decimal remaining =(Decimal)alloc - suballoc - reserved-spent ;
        
        maxPO = String.valueOf(remaining);
        if(musAct.Use_Allocation__c==true){
            for(Allocation_amount__c  cost:costcenter){
                cosName+=cost.Costcentre__r.name+', ';
                
            }
            f.type=cosName.substringBeforeLast(', ');  
        }
        else if(musAct.Use_Allocation__c==false){
           for(Allocation_amount__c  user:costcenter){
                userName+=user.Costcentre__r.Name+', ';
            }
            f.type=userName.substringBeforeLast(', ');
        }     
        f.allocated = alloc;
        f.Suballocated = suballoc;
        f.reserved = reserved;
        f.spent = spent;
        f.remaining = remaining;
        f.budget = budget; 
        f.budget2 = budget2;          
        f.fiscalyear=fiscalYear;
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
        profinlist.add(f);
       }
        return profinlist;  
    }    
        
/******************************************************** 
getFin():This is for display financial summary of plan.
********************************************************/  
    public List<Financials> getFin(){
        string cosName='';
        string userName='';
        decimal appAmount;
        List<Financials> finlist = new List<Financials>();
        try{
            List<musqot__Allocation_amount__c>costcenter1= [SELECT Id,musqot__Allocated__c ,musqot__Costcentre__r.OwnerID,musqot__Costcentre__r.musqot__cc_Owner__c ,Costcentre__r.name,musqot__Approved_Amount__c from Allocation_amount__c 
                                                            where Costcentre__c <> null and Approved_Amount__c > 0 and To_Plan__c =:planId limit 100];
            Map<String, musqot__Allocation_amount__c > maps= new Map<String, musqot__Allocation_amount__c >();
            for(musqot__Allocation_amount__c oh : costcenter1){
                if(oh.musqot__Costcentre__r.name<>null){
                    
                    if(!maps.containsKey(oh.musqot__Costcentre__r.OwnerID)) 
                        maps.put(oh.musqot__Costcentre__r.OwnerID,oh);
                    
                }
            }
            costcenter= maps.values();
            List<musqot__Allocation_amount__c>appAmo=[SELECT  CreatedBy.Name,Allocated__c ,Costcentre__r.name,
                                                      Approved_Amount__c from Allocation_amount__c where  Approved_Amount__c > 0 and To_Plan__c =:planId ];
            
            Map<String, musqot__Allocation_amount__c > maps1= new Map<String, musqot__Allocation_amount__c >();
            for(musqot__Allocation_amount__c oh : appAmo){
                if(oh.CreatedBy.Name<>null){
                    
                    if(!maps1.containsKey(oh.CreatedBy.Name)) 
                        maps1.put(oh.CreatedBy.Name,oh);
                    
                }
            }
            users= maps1.values();
            
        }
        catch(Exception e){}
        
        AggregateResult allocation = [
            SELECT SUM(Approved_Amount__c) totals 
            FROM Allocation_amount__c
            WHERE To_Plan__c = :planId 
        ];
        AggregateResult suballocation = [
            SELECT SUM(Approved_Amount__c) totals 
            FROM Allocation_amount__c
            WHERE Plan__c = :planId
        ];
               
        List<Purchase_order__c> POcalk = new List<Purchase_order__c>();
        POcalk = [SELECT Total_cost__c, total_Invoice_cost__c, Purchase_order_cloesed__c FROM Purchase_order__c WHERE Project__c = :planId ];
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
            WHERE Project__c = :planId
        ];
        AggregateResult budgetamn = [
            SELECT SUM(Budget__c) totals 
            FROM Budget__c
            WHERE Project__c = :planId
        ];
        AggregateResult budget2amn = [
            SELECT SUM(Budget__c) totals 
            FROM Budget__c
            WHERE Project__c = :planId and subproject__c = NULL];   
        
        Financials f = new Financials();
        
        Decimal spent = (Decimal) invoices.get('totals');
        spent = (spent == null) ? 0.00 : spent.setscale(2);
        
      //  Decimal reserved = purchaseOrders;
        reserved = (reserved == null) ? 0.00 : reserved.setscale(2);
        
        Decimal alloc = (Decimal) allocation.get('totals');
        alloc = (alloc == null) ? 0.00 : alloc.setscale(2);
        
        Decimal suballoc = (Decimal) suballocation.get('totals');
        suballoc = (suballoc == null) ? 0.00 : suballoc.setscale(2);
        
        Decimal budget = (Decimal) budgetamn.get('totals');
        budget = (budget == null) ? 0.00 : budget.setscale(2); 
        
        Decimal budget2 = (Decimal) budget2amn.get('totals');
        budget2 = (budget2 == null) ? 0.00 : budget2.setscale(2); 
        
        Decimal remaining = (Decimal)  alloc - suballoc - reserved-spent ;
        
        maxPO = String.valueOf(remaining);
        /** R: List of CC Associated with This specific Plan **/
        musqot__Activity__c musAct=[SELECT id,Name,keycode__c,Use_Allocation__c,Use_Budget__c,musqot__Use_Finance1__c,Use_Forcasting__c,Use_milestones__c,Use_Resource__c  FROM musqot__Activity__c limit 1];
        if(musAct.musqot__Use_Allocation__c==true)
        {
            for(Allocation_amount__c  cost:costcenter){
                cosName+=cost.Costcentre__r.name+', ';
            }
            f.type=cosName.substringBeforeLast(', ');
            
        }
        else if(musAct.musqot__Use_Allocation__c==false){
            
            for(Allocation_amount__c  user:users){
                userName+=user.CreatedBy.Name+', ';
            }
            f.type=userName.substringBeforeLast(', ');
            
            
        }     
        f.allocated = alloc;
        f.Suballocated = suballoc;
        f.reserved = reserved;
        f.spent = spent;
        f.remaining = remaining;
        f.budget = budget; 
        f.budget2 = budget2; 
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
	getSubFin:it  display financial summary of Subproject.
	********************************************************/  
     public List<Financials> getSubFin(){
       List<Financials> subfinlist = new List<Financials>();
       list<string>proIds=new list<string>();
       list<string>probudIds=new list<string>();
       list<Allocation_amount__c>allocationList=[SELECT Approved_Amount__c,Approved__c ,
                                                 project__c,To_Project__c FROM Allocation_amount__c where Approved_Amount__c<>0];
       for(Allocation_amount__c a:allocationList){
             proIds.add(a.To_Project__c);
         }
       
       List<Budget__c> budlis=[SELECT Budget__c,subproject__c FROM Budget__c where Budget__c<>0];//=:prjId];
         for(Budget__c abud:budlis){
             probudIds.add(abud.subproject__c);
         }
         
       List<SubProject__c> subPrjs = [select Id, Name, Parent_project__c,Project_del__c,(SELECT Approved_Amount__c,musqot__Approved__c ,musqot__project__c,musqot__To_Project__c FROM Allocation_amounts1__r ),
                                       (SELECT Approved_Amount__c,musqot__Approved__c ,musqot__project__c,musqot__To_Project__c FROM Allocation_amounts__r  ),( SELECT Total_cost__c, total_Invoice_cost__c, 
                                        Purchase_order_cloesed__c FROM Purchase_orders__r),(SELECT musqot__subproject__c ,musqot__Total_spent__c FROM Invoices__r),(SELECT Budget__c,Project__c,subproject__c FROM Budget__r) 
                                        from SubProject__c where Parent_project__c =:planId AND (Id IN:proIds OR Id IN:probudIds) AND Project_del__c=null order by Name limit 250];//
        
        if(subPrjs<>null){
            boolean drawFinSub =  true ;
        }
        else
        {
            boolean drawFinSub =  false ;  
        }  
        Decimal allocation;
        Decimal subAllocation; 
        Decimal reserved; 
        Decimal invoices; 
        Decimal budget; 
        for(SubProject__c sp1 : subPrjs){
            allocation=0.0;
            subAllocation=0.0;
            reserved =0.0; 
            budget=0.0; 
            invoices=0.0; 
            for(musqot__Allocation_amount__c alRe: sp1.Allocation_amounts1__r){
                if(alRe.musqot__project__c<>null){
                    if(alRe.musqot__Approved_Amount__c<>null){
                        subAllocation+=alRe.musqot__Approved_Amount__c;
                    }
                }   
            }
            for(musqot__Allocation_amount__c alRec: sp1.Allocation_amounts__r){
                if(alRec.musqot__To_Project__c<>null){
                    if(alRec.musqot__Approved_Amount__c<>null){
                        allocation +=alRec.musqot__Approved_Amount__c;
                    }   
                }
            }
            for(Purchase_order__c pruchOrdr : sp1.Purchase_orders__r){
                if(pruchOrdr.Purchase_order_cloesed__c==true ){
                    reserved +=0;
                }
                else if( pruchOrdr.total_Invoice_cost__c >  pruchOrdr.Total_cost__c){
                    reserved += 0;
                }else if(pruchOrdr.total_Invoice_cost__c >0){
                     reserved +=(pruchOrdr.Total_cost__c-pruchOrdr.total_Invoice_cost__c);
                }
                else {
                    reserved += pruchOrdr.Total_cost__c; 
                }
            } 
            for( Invoice__c i: sp1.Invoices__r){         
                if(i.Total_spent__c<>null)
                    invoices+=i.Total_spent__c;
            }  
            
            for( Budget__c  b : sp1.Budget__r){         
                if(b.musqot__Budget__c<>null)
                    budget+=b.musqot__Budget__c;
            }      
            
            Financials sf = new Financials();
            Decimal remaining = (Decimal)  allocation- subAllocation- reserved-invoices;
            
            if(sp1<>null){
                sf.type = sp1.Name;
            }
            sf.allocated = allocation;
            sf.Suballocated = subAllocation;
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
Financials:This wrapper class variables declaration.
********************************************************/  
    public class Financials {
        public String type{get;set;}
        public Decimal allocated{get;set;}
        public Decimal approved{get;set;}
        public Decimal reserved{get;set;}
        public Decimal spent{get;set;}
        public Decimal remaining{get;set;}
        public Decimal Suballocated{get;set;}
        public Decimal budget{get;set;}
        public Decimal budget2{get;set;}
        public String color{get;set;}
        public string fiscalyear{get;set;}
    }
    /******************************************************** 
Resources:This wrapper class variables declaration.
********************************************************/ 
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
        public Decimal budget2{get;set;}
        public String color{get;set;}
    }
    /********************************************************************
getres:it  display financial summary of plan of allaocation resources.
*********************************************************************/ 
    //janardhan:imple
    public List<Resources> getres(){
        string cosName='';
        decimal appAmount;
        List<Resources> reslist = new List<Resources>();
        try{
            List<musqot__Allocation_resources__c >costcenter1= [SELECT Id,musqot__To_Plan__c,musqot__Cost_center__r.OwnerID,musqot__Cost_center__r.musqot__cc_Owner__c ,musqot__Cost_center__r.name,musqot__Approved_houver__c from musqot__Allocation_resources__c where musqot__Cost_center__c <> null and musqot__Approved_houver__c > 0 and (To_Plan__c =:planId OR To_Project__c IN:subprojectIdList) limit 100];
            Map<String, musqot__Allocation_resources__c   > maps= new Map<String, musqot__Allocation_resources__c>();
            for(musqot__Allocation_resources__c   oh : costcenter1){
                if(oh.musqot__Cost_center__r.name<>null){
                    
                    if(!maps.containsKey(oh.musqot__Cost_center__r.OwnerID)) 
                        maps.put(oh.musqot__Cost_center__r.OwnerID,oh);
                    
                }
            }
            costcenter_res= maps.values();
            List<musqot__Allocation_resources__c>apphours=[SELECT  CreatedBy.Name,musqot__Requested_hours__c ,Cost_center__r.name,musqot__Approved_houver__c from musqot__Allocation_resources__c where  Approved_houver__c> 0 and To_Plan__c =:planId];             
            Map<String, musqot__Allocation_resources__c > maps1= new Map<String, musqot__Allocation_resources__c>();
            for(musqot__Allocation_resources__c oh : apphours){
                if(oh.CreatedBy.Name<>null){
                    
                    if(!maps1.containsKey(oh.CreatedBy.Name)) 
                        maps1.put(oh.CreatedBy.Name,oh);
                    
                }
            }
            users1= maps1.values();
        }
        catch(Exception e){}
        AggregateResult allocation = [
            SELECT SUM(Approved_houver__c) totals 
            FROM Allocation_resources__c
            WHERE To_Plan__c = :planId
        ];
        AggregateResult suballocation = [
            SELECT SUM(Approved_houver__c) totals 
            FROM Allocation_resources__c
            WHERE Plan__c = :planId
        ];
        
        AggregateResult estimates = [
            SELECT SUM(Allocated_h__c) totals 
            FROM Task
            WHERE WhatId = :planId
        ];
        AggregateResult outcomes = [
            SELECT SUM(Outcome_h__c) totals 
            FROM Task
            WHERE WhatId = :planId
        ];
        
        AggregateResult budgetamn = [
            SELECT SUM(Budget_h__c) totals 
            FROM Budget__c
            WHERE Project__c = :planId
        ];
        AggregateResult budget2amn = [
            SELECT SUM(Budget_h__c) totals 
            FROM Budget__c
            WHERE Project__c = :planId and subproject__c = NULL];   
        
        Resources r = new Resources();
        Decimal Outcome = (Decimal) outcomes.get('totals');
        Outcome = (Outcome == null) ? 0.0 : Outcome.setscale(1);
        
        Decimal Estimate = (Decimal) estimates.get('totals');
        Estimate = (Estimate == null) ? 0.0 : Estimate.setscale(1);
        
        Decimal alloc = (Decimal) allocation.get('totals');
        alloc = (alloc == null) ? 0.0 : alloc.setscale(1);
        
        Decimal suballoc = (Decimal) suballocation.get('totals');
        suballoc = (suballoc == null) ? 0.0 : suballoc.setscale(1);
        
        Decimal budget = (Decimal) budgetamn.get('totals');
        budget = (budget == null) ? 0.0 : budget.setscale(1); 
        
        Decimal budget2 = (Decimal) budget2amn.get('totals');
        budget2 = (budget2 == null) ? 0.0 : budget2.setscale(1); 
        
        if(Estimate<Outcome){
            Estimate=Outcome; // hakan 
        }
        Decimal remaining = (Decimal)  alloc - suballoc - Estimate;
        remaining = (remaining == null) ? 0.0 : remaining.setscale(1);  
        musqot__Activity__c musAct=[SELECT id,Name,keycode__c,Use_Allocation__c,Use_Budget__c,musqot__Use_Finance1__c,Use_Forcasting__c,Use_milestones__c,Use_Resource__c  FROM musqot__Activity__c limit 1];
        if(musAct.musqot__Use_Allocation__c==true)
        {
            if(costcenter_res.size()>0 && costcenter_res<>null){
                for(Allocation_resources__c  cost:costcenter_res){
                    cosName+=cost.Cost_center__r.name+', ';
                }
                r.type=cosName.substringBeforeLast(', ');
            }  }
        else if(musAct.musqot__Use_Allocation__c==false){
            // if(users[0].Costcentre__r.name==null){
            for(Allocation_resources__c  user:users1){
                cosName+=user.CreatedBy.Name+', ';
            }
            r.type=cosName.substringBeforeLast(', ');
            // }
            
        }     
        r.allocated = alloc;
        r.Suballocated = suballoc;
        r.Estimate = Estimate;
        r.outcome = outcome;
        r.remaining = remaining;
        r.budget = budget; 
        r.budget2 = budget2; 
        
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
    /******************************************************** 
gettaskrecs:it  display financial summary of plan all tasks
********************************************************/ 
    
    public List<Task> gettaskrecs(){
        return [Select Id, WhatId, Remaining__c, IsClosed,  Allocated_h__c, Outcome_h__c,Task_name__c FROM Task where whatid=:planId  order by Task_name__c limit 400];
        
    }  
    /* user tasks dun by Håkan  */
    /******************************************************** 
getusertaskrecs:it  display  particular users of plan tasks
********************************************************/ 
    public List<Resources> getusertaskrecs(){
        List<Resources> usertakslist = new List<Resources>();
        try{
            List<Task> usrlist =  [Select Id,ownerId,CreatedByid, owner.name,WhatId, Remaining__c, IsClosed, 
                                   Allocated_h__c, Outcome_h__c,Task_name__c FROM Task where whatid=:planid  order by owner.name limit 400]; 
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
                    WHERE ownerId = :ut.ownerId and whatid=:planid 
                ];
                AggregateResult outcomes = [
                    SELECT SUM(Outcome_h__c) totals 
                    FROM Task
                    WHERE ownerId = :ut.ownerId and whatid=:planid 
                ];
                AggregateResult openh = [
                    SELECT SUM(Remaining__c) totals 
                    FROM Task
                    WHERE ownerId = :ut.ownerId and whatid=:planid 
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
    
    /* user task end*/
    /************************************************************************** 
getSubres:it  display financial summary of project of Allocation resources 
**************************************************************************/ 
    public List<Resources> getSubres(){
        List<Resources> ressublist = new List<Resources>();
        List<SubProject__c> subPrjs1 = [select Id, Name, Parent_project__c,(SELECT musqot__Approved_houver__c,Project__c,musqot__To_Project__c
                                                                            FROM Allocation_resources__r),(SELECT musqot__Approved_houver__c,Project__c,musqot__To_Project__c FROM Allocation_resources1__r),
                                        (SELECT Outcome_h__c, whatid,Allocated_h__c FROM Tasks),(SELECT Budget_h__c FROM Budget__r)from SubProject__c where Parent_project__c = :planId AND Project_del__c = null order by name limit 250];
        Decimal allocation;
        Decimal subAllocation; 
        Decimal estimate; 
        Decimal outcome; 
        Decimal budget; 
        for(SubProject__c sp1 : subPrjs1){
            allocation=0.0;
            subAllocation=0.0;
            estimate=0.0; 
            budget=0.0; 
            outcome=0.0; 
            for(musqot__Allocation_resources__c res1 : sp1.musqot__Allocation_resources__r){
                if(res1.Project__c<>null){
                    if(res1.musqot__Approved_houver__c<>null){
                        subAllocation+=res1.musqot__Approved_houver__c;
                    }   
                }
            }
            for(musqot__Allocation_resources__c res: sp1.musqot__Allocation_resources1__r){
                if(res.musqot__To_Project__c<>null){
                    if(res.musqot__Approved_houver__c<>null){
                        allocation += res.musqot__Approved_houver__c;
                    } 
                }
            }
            for(Task t:sp1.Tasks){
                
                if(t.Allocated_h__c <> null &&t.Outcome_h__c<> null){
                    estimate+=t.Allocated_h__c;
                    outcome+=t.Outcome_h__c;
                }
            }
            for( Budget__c  b : sp1.Budget__r){         
                if(b.Budget_h__c<>null)
                    budget+=b.Budget_h__c;
                
            }      
            Resources re = new Resources();
            Decimal remaining = allocation-subAllocation-estimate;
            remaining = (remaining == null) ? 0.0 : remaining.setscale(1);  
            
            if(subPrjs1<>null){
                re.type = sp1.Name;
            }
            re.allocated = allocation;
            re.Suballocated = subAllocation;  
            re.Estimate = estimate;
            re.Outcome = outcome;
            re.remaining = remaining;
            re.budget = budget; 
            if (remaining < 0) {
                re.color = 'red';
            } else {
                re.color = 'black';
            }
            ressublist.add(re);  
        }
        
        return ressublist; 
    }
    
}