/*********************************************************
Class Name: costcenterfinance
Author:chaithanya daggumati    Last modified by:Raju
Date:   24/11/2015                          Date:28/12/2015
Dsc:Adding wrapper class to piechart
********©2013 Musqot marketing technology Pvt ltd ********/
public with sharing class costcenterfinance {
    public Costcentre__c coscen{get;set;}
    public List<Costcentre__c>cosRec;
    public Allocation_amount__c amt{ get; set; }
    public List<Allocation_amount__c> displaydata{ get; set; }
    public List<Allocation_resources__c> Resourcedetaildata{ get; set; }
    public List<Allocation_amount__c> displaydata1;
    public List<Allocation_resources__c> Resourcedata;
    public ProcessInstanceWorkitem piw{get;set;}
    public ProcessInstance piwrap{get;set;}
    public String selectedyear {get;set;}
    public String Requesttype {get;set;}
    public String viewvalues {get;set;}
    public double totdetail{get;set;}
    public double totsum{get;set;}
    public double tothrsdetail{get;set;}
    public double tothrssum{get;set;}
    public boolean tb1{get;set;}
    public boolean tb2{get;set;}
    public List<SelectOption> viewOptions {get;set;}
    public List<SelectOption> Requestoptions {get;set;}
    public string defaultId{get;set;}
    public string currentRecordId{get;set;}
    public string defaultFiscalYear{get;set;}
    public id onchangSelectdYear{get;set;}
    String tabInFocus;
    //public  list<Allocation_amount__c> allocationAmtList;
    private String chartData;
    public costcenterfinance() {
        amt = new Allocation_amount__c (); 
        List<Allocation_amount__c> displaydata;
        List<Allocation_resources__c> Resourcedetaildata;
        showPendingRecord=true;
        showRejectedRecord=false;
        //RejectrequestsList=new List<ProcessInstanceWorkitem>();
        data = new List<PieWedgeData>();
        currentRecordId=ApexPages.CurrentPage().getparameters().get('Id');
        tabInFocus = System.currentPageReference().getParameters().get('tab');
        string yearname=string.valueof(system.today().year());
        list<FiscalYearSettings>fs = [SELECT Id,Name FROM FiscalYearSettings ];
        for(FiscalYearSettings f:fs){
            if(f.Name.substring(0,4)==yearname)
                defaultFiscalYear = f.id;
        }
        amt.Allocated__c=0.00;
        amt.Approved_Amount__c=0.00;
        selectedyear=defaultFiscalYear;
        viewOptions = new List<SelectOption>();        
        viewOptions.add(new SelectOption('Summed','Summed'));
        viewOptions.add(new SelectOption('Detail','Detail'));
        
        Requestoptions = new List<SelectOption>();        
        Requestoptions.add(new SelectOption('Pending','Pending'));
        Requestoptions.add(new SelectOption('Rejected','Rejected'));
        viewvalues='Summed';
        tb1=false;
        tb2=true;
       
        /*allocationAmtList=new list<Allocation_amount__c>();
        allocationAmtList=[SELECT Id, Name,Approved_Amount__c,Costcentre__c, To_Plan__c 
                           FROM Allocation_amount__c 
                           where Costcentre__c=:currentRecordId and Approved_Amount__c<>null and To_Plan__c <>null]; 
        list<Allocation_resources__c> alhr= [SELECT FiscalYear__c  
                                             FROM Allocation_resources__c  
                                             where isdeleted = false order by FiscalYear__c limit 1]; */
        selectedview();
        selectedresview();   
        //getPieData();
    }   
    public void loaddata(){
        tb1=false;
        tb2=true;
        totalAmt=0.00;
        totalhrs=0.0;
        displaydata=new list<Allocation_amount__c>();
        Resourcedetaildata=new list<Allocation_resources__c>();
        displaydata.clear();
        Resourcedetaildata.clear();
        displaydata = [SELECT Id, Name, Approved_By__r.name, CreatedById,Approved__c,Approvedate__c, Description__c,Allocated__c,To_Plan__c,To_Plan__r.Name, To_Project__c, FiscalYear__c,To_Project__r.Name, Approved_Amount__c 
                       FROM Allocation_amount__c  
                       where FiscalYear__c=:defaultId and Costcentre__c=:currentRecordId AND Approved_Amount__c<>null order by  To_Plan__r.Name , To_Project__r.name limit 100];
        set<id>plnIds=new set<Id>();
        for(Allocation_amount__c a:displaydata){
            plnIds.add(a.To_Plan__c);
        }
        aggReqAmt=[
            SELECT SUM(Approved_Amount__c) totals 
            FROM Allocation_amount__c 
            where To_Plan__c IN:plnIds and Costcentre__c=:currentRecordId GROUP BY  FiscalYear__c 
        ];
        
        /*for(AggregateResult a:aggReqAmt){
            
            totalAmt = (Decimal) a.get('totals');
            totalAmt = (totalAmt == null) ? 0.00 : totalAmt.setscale(2);   
        }*/
        
        //Resource data in load method
        Resourcedetaildata=[SELECT Id, Name, Approved_By__r.name, CreatedById,Approved__c,Approved_date__c,Description__c,Requested_hours__c,To_Plan__c, To_Project__c,FiscalYear__c, Approved_houver__c 
                            FROM Allocation_resources__c 
                            where FiscalYear__c=:defaultId AND Cost_center__c=:currentRecordId limit 100];
        for(Allocation_resources__c ar:Resourcedetaildata){
            plnIds.add(ar.To_Plan__c);
        }
        aggReqhrs=[
            SELECT SUM(Approved_houver__c) totals 
            FROM Allocation_resources__c 
            where To_Plan__c IN:plnIds and Cost_center__c=:currentRecordId GROUP BY  FiscalYear__c 
        ];
        
        /*for(AggregateResult ar:aggReqhrs){
            
            totalhrs = (Decimal) ar.get('totals');
            totalhrs = (totalhrs == null) ? 0.00 : totalhrs.setscale(1);   
        }*/
        
    }
    public List<SelectOption> fisicalYearOptions
    {        
        get
        {
            list<FiscalYearSettings>queryResult= [SELECT Id, Name, YearType
                                                  FROM FiscalYearSettings order by Name Desc limit 100];                                                             
            Set<SelectOption>fiscalYerSet= new set<SelectOption>();
            List<SelectOption> fisicalYearOptions= new List<SelectOption>();
            for(FiscalYearSettings obj:queryResult)
            { 
                fiscalYerSet.add(new SelectOption(obj.Id,obj.Name));            
            }            
            fisicalYearOptions.addAll(fiscalYerSet);
            return fisicalYearOptions;
        }
        set;
    }
    public Decimal totalAmt {get;set;}
    public map<string,string>plnMap=new Map<string,string>();
    public void selectedview(){  
        displaydata=new list<Allocation_amount__c>();
        financial = new List<Financials>();
        list<id>plnIds=new list<id>();  
        //getPieData();
        totalAmt=0.00;
        tb1=false;
        tb2=true;
        set<Id>toProjectIds=new set<Id>();
        displaydata1=[SELECT Id, Name, Owner.Name,Approved_By__c,Approved_By__r.name,Approved__c,Approvedate__c, Description__c,Allocated__c,To_Plan__c, To_Plan__r.Name, To_Project__c,FiscalYear__c,To_Project__r.Name, Approved_Amount__c 
                      FROM Allocation_amount__c 
                      where FiscalYear__c=:selectedyear AND Costcentre__c=:currentRecordId AND Approved_Amount__c<>null and Approved__c=true order by To_Plan__r.Name,To_Project__r.Name limit 250];
        
        for(Allocation_amount__c a:displaydata1){
            plnIds.add(a.To_Plan__c);
            if(a.To_Project__c != null){
                toProjectIds.add(a.To_Project__c);
            }
        }
        list<Project__C>plnNmae=[SELECT Id,Name,(SELECT Id,Name,Parent_project__c 
                                                 FROM Subproject_1__r)
                                 FROM Project__C];
        map<string,string>proMap=new Map<string,string>();
        for(Project__C p:plnNmae){
            plnMap.put(p.id, p.Name);
            for(SubProject__C s:p.Subproject_1__r){
                proMap.put(s.Id,s.Name);
            }
        }
        map<id,Allocation_amount__c>toplanMap=new map<id,Allocation_amount__c>();
        map<id,List<Subproject__c>>toProjctMap=new map<id,list<Subproject__c>>();
        for(Allocation_amount__c a:displaydata1){
            if(a.To_Plan__c != null){
                toplanMap.put(a.To_Plan__c,a);
            }
        }
        
        list<Project__C>plnNmae12=[SELECT Id,Name,(SELECT Id,Name,Parent_project__c 
                                                   FROM Subproject_1__r)
                                   FROM Project__C 
                                   WHERE Id IN:toplanMap.keySet() limit 100];
        for(Project__C s:plnNmae12){
            toProjctMap.put(s.id,s.Subproject_1__r); 
        }
        //getPieData();
        if(viewvalues=='Detail'){ 
            displaydata.addAll(displaydata1);
            tb1=true;
            tb2=false;
           // return displaydata; 
        }               
        else if(viewvalues=='Summed'){ 
            displaydata.clear();
            tb1=false;
            tb2=true;
            for(string s :toplanMap.keySet()){ 
                string topln='';
                string toprojct='';
                decimal appAmount;
                decimal reqAmount;
                
                AggregateResult approveAmt= [
                    SELECT SUM(Approved_Amount__c) totals 
                    FROM Allocation_amount__c
                    WHERE To_Plan__c =:s AND FiscalYear__c=:selectedyear AND Costcentre__c=:currentRecordId 
                ];
                AggregateResult reqAmt= [
                    SELECT SUM(Allocated__c) totals 
                    FROM Allocation_amount__c
                    WHERE To_Plan__c =:s AND FiscalYear__c=:selectedyear AND Costcentre__c=:currentRecordId
                ];
                Financials f = new Financials();
                Decimal approved = (Decimal) approveAmt.get('totals');
                approved = (approved == null) ? 0.00 : approved.setscale(2);
                Decimal requested = (Decimal) reqAmt.get('totals');
                requested = (requested == null) ? 0.00 : requested.setscale(2);
                f.toplan=plnMap.get(s);
                // f.toProjet=proMap.get(s);
                f.requestedAmt=requested;
                f.approvedAmt=integer.valueOf(approved);
                financial.add(f);
                
            }
            for(Id s :toProjectIds){ 
                string toprojct='';
                decimal appAmount;
                decimal reqAmount;
                
                AggregateResult approveAmt= [
                    SELECT SUM(Approved_Amount__c) totals 
                    FROM Allocation_amount__c
                    WHERE To_Project__c =:s AND FiscalYear__c=:selectedyear AND Costcentre__c=:currentRecordId
                ];
                AggregateResult reqAmt= [
                    SELECT SUM(Allocated__c) totals 
                    FROM Allocation_amount__c
                    WHERE To_Project__c =:s AND FiscalYear__c=:selectedyear AND Costcentre__c=:currentRecordId
                ];
                Financials f = new Financials();
                Decimal approved = (Decimal) approveAmt.get('totals');
                approved = (approved == null) ? 0.00 : approved.setscale(2);
                Decimal requested = (Decimal) reqAmt.get('totals');
                requested = (requested == null) ? 0.00 : requested.setscale(2);
                f.toplan=proMap.get(s);
                f.requestedAmt=requested;
                f.approvedAmt=approved;
                financial.add(f);
            }            
        }
       // selectedyear=onchangSelectdYear;
        //getPieData();
        aggReqAmt=[
            SELECT SUM(Approved_Amount__c) totals 
            FROM Allocation_amount__c 
            where (To_Plan__c IN:plnIds OR To_Project__c IN :toProjectIds) AND Costcentre__c=:currentRecordId  GROUP BY FiscalYear__c 
        ];
     
    }
    public  list<AggregateResult> aggReqAmt;
    public  List<Financials> financial{get;set;}
    public class Financials {
        public String toplan{get;set;}
        public string toProjet{get;set;}
        public Decimal requestedAmt{get;set;}
        public Decimal approvedAmt{get;set;}
        
    }
    //Resource Implementation
    public Decimal totalhrs {get;set;}
    public void selectedresview(){  
        Resourcedetaildata=new list<Allocation_resources__c>();
        Resourcedata=new list<Allocation_resources__c>();
        Resource = new List<Resources>();
        list<id>plnIds=new list<id>();
        totalhrs=0.0;
        tb1=false;
        tb2=true;
        set<Id>toProjectIds=new set<Id>();
        Resourcedata=[SELECT Id, Name, Approved_By__r.name, CreatedById,Approved__c,Approved_date__c, Description__c,Requested_hours__c,To_Plan__c,To_Plan__r.Name,To_Project__r.Name,FiscalYear__c, Approved_houver__c 
                      FROM Allocation_resources__c 
                      where FiscalYear__c=:selectedyear AND Cost_center__c=:currentRecordId  order by To_Plan__r.Name,To_Project__r.Name];
        for(Allocation_resources__c a:Resourcedata){
            plnIds.add(a.To_Plan__c);
            if(a.To_Project__c != null){
                toProjectIds.add(a.To_Project__c);
            }
        }
        list<Project__C>plnNmae=[SELECT Id,Name,(SELECT Id,Name,Parent_project__c FROM Subproject_1__r)FROM Project__C];
        map<string,string>plnMap=new Map<string,string>();
        map<string,string>proMap=new Map<string,string>();
        for(Project__C p:plnNmae){
            plnMap.put(p.id, p.Name);
            for(SubProject__C s:p.Subproject_1__r){
                proMap.put(s.id,s.Name);
            }
        }
        map<id,Allocation_resources__c>toplanMap=new map<id,Allocation_resources__c>();
        map<id,List<Subproject__c>>toProjctMap=new map<id,list<Subproject__c>>();
        for(Allocation_resources__c a:Resourcedata){
            if(a.To_Plan__c != null){
                toplanMap.put(a.To_Plan__c,a);
            }
        }
        list<Project__C>plnNmae12=[SELECT Id,Name,(SELECT Id,Name,Parent_project__c FROM Subproject_1__r)
                                   FROM Project__C WHERE Id IN:toplanMap.keySet() limit 20];
        for(Project__C s:plnNmae12){
            toProjctMap.put(s.id,s.Subproject_1__r); 
        }
        if(viewvalues=='Detail'){ 
            Resourcedetaildata.addAll(Resourcedata);
            tb1=true;
            tb2=false;

        }               
        else if(viewvalues=='Summed'){ 
            Resourcedetaildata.clear();
            tb1=false;
            tb2=true;
            for(string s :toplanMap.keySet()){ 
                string topln='';
                string toprojct='';
                decimal apprHrs;
                decimal reqeHrs;
                
                AggregateResult approvehrs= [
                    SELECT SUM(Approved_houver__c) totals 
                    FROM Allocation_resources__c
                    WHERE To_Plan__c =:s AND FiscalYear__c=:selectedyear AND Cost_center__c=:currentRecordId
                ];
                AggregateResult reqhrs= [
                    SELECT SUM(Requested_hours__c) totals 
                    FROM Allocation_resources__c
                    WHERE To_Plan__c =:s AND FiscalYear__c=:selectedyear AND Cost_center__c=:currentRecordId
                ];
                
                Resources r = new Resources();
                PieWedgeData p=new PieWedgeData();
                Decimal approved = (Decimal) approvehrs.get('totals');
                approved = (approved == null) ? 0.0 : approved.setscale(1);
                Decimal requested = (Decimal) reqhrs.get('totals');
                requested = (requested == null) ? 0.0 : requested.setscale(1);
                r.toplan=plnMap.get(s);
                r.requestedhrs=requested;
                r.approvedhrs=approved;
                Resource.add(r);
               
                
            }
            for(Id s :toProjectIds){ 
                string toprojct='';
                decimal appAmount;
                decimal reqAmount;
                
                AggregateResult approvehrs= [
                    SELECT SUM(Approved_houver__c) totals 
                    FROM Allocation_resources__c
                    WHERE To_Project__c =:s AND FiscalYear__c=:selectedyear AND Cost_center__c=:currentRecordId
                ];
                AggregateResult reqhrs= [
                    SELECT SUM(Requested_hours__c) totals 
                    FROM Allocation_resources__c
                    WHERE To_Project__c =:s AND FiscalYear__c=:selectedyear AND Cost_center__c=:currentRecordId
                ];
                
                Resources r = new Resources();
                Decimal approved = (Decimal) approvehrs.get('totals');
                approved = (approved == null) ? 0.0 : approved.setscale(1);
                Decimal requested = (Decimal) reqhrs.get('totals');
                requested = (requested == null) ? 0.0 : requested.setscale(1);
                r.toplan=proMap.get(s);
                r.requestedhrs=requested;
                r.approvedhrs=approved;
                Resource.add(r);
            }
        }
        aggReqhrs=[           
            SELECT SUM(Approved_houver__c) totals 
            FROM Allocation_resources__c 
            where (To_Plan__c IN:plnIds OR To_Project__c IN :toProjectIds) AND Cost_center__c=:currentRecordId  GROUP BY  FiscalYear__c                                    
        ];
        for(AggregateResult a:aggReqhrs){
            totalhrs = (Decimal) a.get('totals');
            totalhrs = (totalhrs == null) ? 0.0 : totalhrs.setscale(1);   
        }                       
    }
    public  list<AggregateResult> aggReqhrs;
    public  List<Resources> Resource{get;set;}
    public class Resources {
        public String toplan{get;set;}
        public string toProjet{get;set;}
        public Decimal requestedhrs{get;set;}
        public Decimal approvedhrs{get;set;}        
    }       
    /************************************************************************
getTabInFocus():This is for display particular tab in costcenter details page.
/*************************************************************************/  
    public String getTabInFocus(){
        return tabInFocus;
    }
    public void setTabInFocus(String s ) {
        this.tabInFocus = s;
    }
    /************************************************************************
	selectedrequest():This is for display selected requests in costcenter details page.
	/*************************************************************************/ 
    public List<pwiWrap> getPendingrequestsList(){        
        List<ProcessInstanceWorkitem> tempList= [Select Id, ProcessInstanceId,ProcessInstance.TargetObject.Name, ProcessInstance.Status,ProcessInstance.TargetObjectId, ActorId, OriginalActorId,CreatedById,CreatedDate 
                                                 from ProcessInstanceWorkitem 
                                                 where ProcessInstance.Status='Pending'];
           									
        
        //chaithanya added for remove timestamp from created date column in pending requests
        //Datetime CreatedDate = Datetime.now();
        Set<Id> amtIds = new Set<Id>();
        if(tempList.size()>0){
            List<pwiWrap> tempWrpList = new List<pwiWrap>();
            for(ProcessInstanceWorkitem p : tempList){
                amtIds.add(p.ProcessInstance.TargetObjectId);
            }
            List<Allocation_amount__c> amtList = [select Id,Allocated__c,CreatedDate,LastModifiedById,LastModifiedBy.Name 
                                                  from Allocation_amount__c 
                                                  where Id IN :amtIds and Costcentre__c=:currentRecordId];
            List<Allocation_resources__c> hrsList = [select Id,Requested_hours__c,CreatedDate,LastModifiedById,LastModifiedBy.Name 
                                                     from Allocation_resources__c 
                                                     where Id IN :amtIds and Cost_center__c=:currentRecordId];
            Set<pwiWrap> setWrp = new Set<pwiWrap>();
            
            for(ProcessInstanceWorkitem p : tempList){
                id mmId=p.ProcessInstance.TargetObjectId;
                String sObjName = mmId.getSObjectType().getDescribe().getName();
                
                if(sObjName== 'musqot__Allocation_amount__c'){
                    for(Allocation_amount__c amt : amtList){
                        if(p.ProcessInstance.TargetObjectId == amt.Id){ 
                            
                            setWrp.add(new pwiWrap(p,amt,null)); 
                        }     
                    }
                }
                else if(sObjName== 'musqot__Allocation_resources__c'){
                    for(Allocation_resources__c hrs : hrsList){
                        if(p.ProcessInstance.TargetObjectId == hrs.Id){
                            setWrp.add(new pwiWrap(p,null,hrs)); 
                        }     
                    }
                }
            }            
            tempWrpList.addAll(setWrp);
            return tempWrpList;
        }
        else{
            return (new List<pwiWrap>());
        }
    }
    public List<processInstanWorkItemWrap> getRejectrequestsList(){
        
        List<ProcessInstance> tempList=[SELECT Id, Status, TargetObjectId, LastActorId,TargetObject.Name
                                        FROM ProcessInstance where status='Rejected']; // and LAstActorId=:UserInfo.getUserId()                   
        Set<Id> amtIds = new Set<Id>();
        if(tempList.size()>0){
            List<processInstanWorkItemWrap> tempWrpList = new List<processInstanWorkItemWrap>();
            for(ProcessInstance p : tempList){
                amtIds.add(p.TargetObjectId);
            }
            List<Allocation_amount__c> amtList = [select Id,Allocated__c,Description__c,CreatedDate,LastModifiedById,LastModifiedBy.Name 
                                                  from Allocation_amount__c 
                                                  where Id IN :amtIds and Costcentre__c=:currentRecordId];
            List<Allocation_resources__c> hrsList = [select Id,CreatedDate,Description__c,Requested_hours__c,LastModifiedById,LastModifiedBy.Name 
                                                     from Allocation_resources__c 
                                                     where Id IN :amtIds and Cost_center__c=:currentRecordId];
            Set<processInstanWorkItemWrap> setWrp = new Set<processInstanWorkItemWrap>();
            for(ProcessInstance p : tempList){
                id mmId=p.TargetObjectId;
                String sObjName = mmId.getSObjectType().getDescribe().getName();
                if(sObjName== 'musqot__Allocation_amount__c'){
                    for(Allocation_amount__c amt : amtList){
                        if(p.TargetObjectId == amt.Id){                    
                            setWrp.add(new processInstanWorkItemWrap(p,amt,null)); 
                            
                        }     
                    }
                }
                else if(sObjName== 'musqot__Allocation_resources__c'){
                    for(Allocation_resources__c hrs : hrsList){
                        if(p.TargetObjectId == hrs.Id){
                            setWrp.add(new processInstanWorkItemWrap(p,null,hrs)); 
                        }     
                    }
                }
            }            
            tempWrpList.addAll(setWrp);
            return tempWrpList;
        }
        else{
            return (new List<processInstanWorkItemWrap>());
        }
    }
    public class pwiWrap{
        public ProcessInstanceWorkitem pw{get;set;}
        public Allocation_amount__c allocAmount{get;set;}
        public Allocation_resources__c allocResource{get;set;}       
        public pwiWrap(ProcessInstanceWorkitem pw, Allocation_amount__c allocAmount,Allocation_resources__c allocResource){            
            this.pw = pw;
            this.allocAmount = allocAmount; 
            this.allocResource = allocResource;  
        }             
    }
    public class processInstanWorkItemWrap{
        public ProcessInstance p{get;set;}
        public Allocation_amount__c allocAmount{get;set;}
        public Allocation_resources__c allocResource{get;set;}       
        public processInstanWorkItemWrap(ProcessInstance p, Allocation_amount__c allocAmount,Allocation_resources__c allocResource){            
            this.p= p;
            this.allocAmount = allocAmount; 
            this.allocResource = allocResource;  
        }             
    }
    public boolean showPendingRecord{get;set;}
    public boolean showRejectedRecord{get;set;}
    public void selectedApprovalStatus(){
        
        if(Requesttype=='Pending'){
            showPendingRecord=true;
            showRejectedRecord=false;
        }
        else{
            showPendingRecord=false;
            showRejectedRecord=true;
        }
        
    }
    //--Raju adding to cost center piechart--
    public List<PieWedgeData> data {get;set;}
    public List<PieWedgeData> getPieData(){
        string pnam='';
        integer plnAmt=0;
        map<id,Allocation_amount__c>toplanMap=new map<id,Allocation_amount__c>();
        map<id,Allocation_amount__c>toPlanProMap=new map<id,Allocation_amount__c>();
       
        Set<String> planIds = new Set<String>();
        Set<String> projectIds = new Set<String>();
        for(Allocation_amount__c a:displaydata1){
            if(a.To_Plan__c!=null){
                if(!planIds.contains(a.To_Plan__c))
                	toplanMap.put(a.To_Plan__c,a); 
                planIds.add(a.To_Plan__c);
            }
            if(a.To_Project__c!=null){
                if(!projectIds.contains(a.To_Project__c))
                	toPlanProMap.put(a.To_Project__c,a); 
                projectIds.add(a.To_Project__c);
            }
        }
        
        toPlanProMap.putAll(toplanMap);
        system.debug('ddd'+toPlanProMap.size());
        
        AggregateResult approveAmt;
        for(string s :toPlanProMap.keySet()){ 
            string topln='';
            //decimal appAmount;
                if(onchangSelectdYear<>null){
                    approveAmt= [
                    SELECT SUM(Approved_Amount__c) totals 
                    FROM Allocation_amount__c
                    WHERE (To_Plan__c =:s OR To_Project__c=:s) AND FiscalYear__c=:onchangSelectdYear
                    AND Costcentre__c=:currentRecordId
                    ];
                    
                }else{
                    approveAmt= [
                    SELECT SUM(Approved_Amount__c) totals 
                    FROM Allocation_amount__c
                    WHERE (To_Plan__c =:s OR To_Project__c=:s) AND FiscalYear__c=:selectedyear
                    AND Costcentre__c=:currentRecordId
                    ]; 
                }
            
            
            Decimal approved = (Decimal) approveAmt.get('totals');
            approved = (approved == null) ? 0.00 : approved.setscale(2);
            PieWedgeData d=new PieWedgeData();
            Decimal percentage=0;
            if(approved<>null || totalAmt<>null){
                if(totalAmt>0)
                    percentage=((approved/totalAmt)*100).setScale(0);
            }
            else
            percentage=0;
            d.Name=toPlanProMap.get(s).name;
            d.data=integer.valueOf(approved);
            data.add(d);
        }       
        return data;
    }
    //-- Wrapper class for Pie Chart 
    public class PieWedgeData{
        public String name { get; set; } 
        public integer data { get; set; }
    }
}