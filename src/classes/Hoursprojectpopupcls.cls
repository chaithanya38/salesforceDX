/*******************************************************
Class Name: Hoursprojectpopupcls
Author:chaithanya daggumati           Last modified by:Raju GN
Date: 09/04/2015                      Date: 2/12/2015
Description:Adding id of fiscl year in controller (dropdown in page),and insert the fiscal year in Allocation_resources__c
********©2013 Musqot marketing technology Pvt ltd *******/
public with sharing class Hoursprojectpopupcls{
    public Allocation_resources__c hrs{get;set;}
    private ApexPages.standardController controller;
    public Subproject__c subPrj {get;set;}
    private List<Reciver> rev;
    String prjID;
    Decimal prjCheck;
    public musqot__Costcentre__c ccRec{get;set;}
    public List<Costcentre__c>defaultCostenrList{get;set;}
    public String ccId{get;set;}
    public string planId;
    public boolean ccRequst{get;set;}
    public String parentName{get;set;}
    public boolean defaultplan {get; set;}
    public boolean defaultProject {get; set;}
    public boolean selfApp{get;set;}
    public boolean ccApp{get;set;}
    public List<musqot__Activity__c> musAct{get;set;}
    public Set<string> projectYearSet = new Set<string>();
    public String selectedFisicalYear{get;set;}
    public string defaultFiscalYearId{get;set;}
    public Musqot_fiscal_year__c musqotFiscalYearList;
    public List<Allocation_resources__c> allcationList=new List<Allocation_resources__c>();
    public integer projectYear;
    public integer projectEndYear;
    public integer projctStartdat;
    public list<integer>pronSpanYears=new list<integer>();
    public string sObjName;
    public string ownerName{get;set;}
    public boolean parentShow{get;set;}
    public List<Allocation_resources__c> allcationHrsList=new List<Allocation_resources__c>();
    public List<musqot__Costcentre__c> CC_Temp = new List<musqot__Costcentre__c>();
    public Hoursprojectpopupcls(ApexPages.StandardController controller) { 
        hrs = new Allocation_resources__c ();   
        subPrj = new Subproject__c();
        projectYearSet=new Set<string>();
        prjId = ApexPages.currentPage().getParameters().get('prjID');
        defaultCostenrList=[SELECT Id, cc_Owner__c, owner.name, OwnerId, Name FROM  Costcentre__c LIMIT 1];                
        try {
            subPrj = [select ID,Name,Project_del__r.OwnerId,Parent_project__c,
                      Parent_project__r.Starts_date__c,Parent_project__r.OwnerId,
                      Parent_project__r.Ends_date__c,Project_del__r.owner.name,
                      Subproject__c.Owner.name,Subproject__c.OwnerId,Starts_date__c,
                      Ends_date__c ,Project_del__r.id,Project_del__r.Name,
                      Parent_project__r.owner.name,Parent_project__r.id,Parent_project__r.Name 
                      from Subproject__c 
                      where Id =:prjId];
            projectEndYear=subPrj.Ends_date__c.year();
            projctStartdat= subPrj.Starts_date__c.year();
            //projectYear=subPrj.Starts_date__c.year();
            for(integer i=projctStartdat;i<=projectEndYear;i++){
               integer currentYear=system.today().year();
               if(i>=currentYear){  
                    pronSpanYears.add(i);
               }
            }
            if(defaultCostenrList.size()>0){
                if(defaultCostenrList[0].OwnerId<>UserInfo.getUserId()){
                    ccRequst=false;   
                } 
            }
            planID = ApexPages.currentPage().getParameters().get('pid');        
            hrs.To_Plan__c = planId;
            //This is Parent project allocated year----
            string parentPlanId;
            string parentProjId;
            parentShow=true;
            set<id>fsyesrSet=new set<id>();
            if(subPrj.Project_del__c<>null){
                    ccId=subPrj.Project_del__r.OwnerId;
                    parentProjId=subPrj.Project_del__c;
                }
            
            else if(subPrj.Parent_project__c<>null &&subPrj.Project_del__c==null){
                ccId=subPrj.Parent_project__r.OwnerId;      
                parentPlanId=subPrj.Parent_project__c;
            }
            allcationList=[SELECT Id,plan__c,FiscalYear__c 
                           FROM Allocation_resources__c 
                           where Approved__c=true and (To_Project__c=:parentProjId OR To_Plan__c=:parentPlanId) limit 10]; 
            for(Allocation_resources__c a:allcationList){
                if(a.FiscalYear__c<>null && a.FiscalYear__c.length()>10){
                    fsyesrSet.add(a.FiscalYear__c);
                }  
            }
            list<FiscalYearSettings>queryResult1= [SELECT Id, Name, YearType
                                                   FROM FiscalYearSettings where Id IN:fsyesrSet limit 10];
            for(FiscalYearSettings f:queryResult1){
                 projectYearSet.add(f.Name);
              
            }
            
         
            if(subPrj.Project_del__c<>null){
                ccId=subPrj.Project_del__r.OwnerId;
                ownerName=subPrj.Project_del__r.owner.name;
                allcationHrsList=[SELECT Id,Approved__c,Plan__c,FiscalYear__c  
                                  FROM Allocation_resources__c 
                                  where Approved__c=true and Project__c=:subPrj.Project_del__c];             
                for(Allocation_resources__c a:allcationHrsList){
                    if(a.FiscalYear__c<>null){ 
                        // projectYear.add(integer.valueof(a.FiscalYear__c.substring(0,4)));
                    }
                }
            }
            //This is Parent Plan allocated year----
            else if(subPrj.Parent_project__c<>null){
                ccId=subPrj.Parent_project__r.OwnerId;
                ownerName=subPrj.Parent_project__r.owner.name;
                allcationHrsList=[SELECT Id,Approved__c,Plan__c,FiscalYear__c  
                                  FROM Allocation_resources__c 
                                  where Approved__c=true and Plan__c=:subPrj.Parent_project__c];
            
                for(Allocation_resources__c a:allcationHrsList){    
                    if(a.FiscalYear__c<>null){
                        // projectYear.add(integer.valueof(a.FiscalYear__c.substring(0,4)));
                    }
                }   
            }
        }
        catch (System.QueryException e) {}
        //end-----
        Activity__c musAct=[SELECT id,Name,Use_Allocation__c  
                            FROM Activity__c limit 1];
        if(musAct.Use_Allocation__c==true){         
            selfApp=true;
            ccApp=false;
        }else{
            ccApp=true;
            ccRequst=false; 
        }
        if(subPrj.Project_del__c<>null){
            parentName = subPrj.Project_del__r.Name;
            defaultplan = false;
            defaultProject=true;
            if(subPrj.Project_del__r.OwnerId==UserInfo.getUserId()){
                ccRequst=false;      
            } 
            else 
                ccRequst=true;
        }
        else if(subPrj.Parent_project__c<>null){
            if(subPrj.Parent_project__r.OwnerId==UserInfo.getUserId()){
                ccRequst=false;    
            } 
            else{
                ccRequst=true; 
            }
            parentName = subPrj.Parent_project__r.Name;
            planId=subPrj.Parent_project__r.id;
            defaultplan = true;
            defaultProject=false;
        }
        
    }
    /*****************************************************
CCList: Convert lookup to dropdown of Costcentres list
******************************************************/
    public List<SelectOption> CCList{
        get
        {            
            CCList= new List<SelectOption>();             
            if(!CCList.isEmpty() && ccId==null){
                ccRec=[SELECT Id, cc_Owner__c, owner.name,OwnerId,Name 
                       FROM Costcentre__c 
                       where Id =:CCList[0].getvalue()];              
            }
            if(planId<>null){
                Project__c planRec=[SELECT u.id,u.Name,Project__c.OwnerId
                                    from Project__c u 
                                    WHERE id=:planId];
                CCList.add(new SelectOption(planRec.id,planRec.Name));                
            }
            else if(subPrj.Project_del__r.id<>null){
                CCList.add(new SelectOption(subPrj.Project_del__r.id, subPrj.Project_del__r.name));                
            }
            CC_Temp = [Select u.Name, owner.name,u.Id From Costcentre__c u where Status__c='Active' limit 250];
            for(musqot__Costcentre__c objCos: CC_Temp )
            {
                CCList.add(new SelectOption(objCos.Id, objCos.Name));                
            }
            return CCList;
        }        
        set;
    }
     //insert Allocationresorces 
     public void Selfhrs(){  
             Costcentre__c defaultCC=[SELECT Id,owner.name,ownerId
                                     FROM  Costcentre__c where ownerId=:UserInfo.getUserId() LIMIT 1];
             if(subprj.Project_del__c==null){
             hrs.Approved__c=true;
             hrs.Approved_date__c=system.today();            
             hrs.To_Project__c = prjID;
             hrs.plan__c=subprj.Parent_project__c;
             hrs.name = subPrj.name;
             insert hrs;
    	}
         else{
             hrs.Approved__c=true;
             hrs.Approved_date__c=system.today();            
             hrs.To_Project__c = prjID;
             hrs.name = subPrj.name;
             insert hrs; 
         }
     }
    //
    //this method used at cost center onchange event-----
    public Subproject__c subPrj1;
    public string projectId;
    public void ccUserRec(){
         parentShow=false;
        string projectId = ApexPages.currentPage().getParameters().get('prjID');
        subPrj1 = [select ID,Name,Project_del__r.OwnerId,Parent_project__r.OwnerId,
                   Project_del__r.Name,Parent_project__r.Name,
                   Subproject__c.Owner.name,Subproject__c.OwnerId,Parent_project__c
                   from Subproject__c 
                   where Id =:projectId];
        defaultplan=false;
        defaultProject=false;
        string sObjName =Id.valueof(ccId).getSObjectType().getDescribe().getName();
        if(sObjName=='musqot__Costcentre__c'){
             parentShow=false;
            ccRec=[SELECT Id,  owner.name, OwnerId, Name 
                   FROM  Costcentre__c 
                   where Id =:ccId];
            if(ccRec.OwnerId== UserInfo.getUserId()){                                      
                ccRequst=false;
            }
            else{                        
                ccRequst=true;          
            }
        }
        else if(sObjName=='musqot__Project__c'){
             parentShow=true;
            musqot__Project__c pl=[SELECT ID,Name,OwnerId FROM musqot__Project__c WHERE id=:ccId];
            defaultplan=true;
            if(pl.OwnerId== UserInfo.getUserId()){                                      
                ccRequst=false;
            }
            else{                        
                ccRequst=true;          
            }
        }
        else if(sObjName=='musqot__SUbProject__c'){
             parentShow=true;
            SUbProject__c pro=[SELECT ID,Name,OwnerId FROM SUbProject__c WHERE id=:ccId];
            defaultProject=true;
            if(pro.OwnerId== UserInfo.getUserId()){                                      
                ccRequst=false;
            }
            else{                        
                ccRequst=true;          
            }
        }
    }
    /*****************************************************
saveHrs():insert Allocationamount
******************************************************/
    public void saveHrs(){       
        if (defaultplan){
            list<Project__c>p=[SELECT Id,OwnerId FROM Project__c WHERE ID=:ccId limit 1]; 
            if(p[0].OwnerId==UserInfo.getUserId()){    
                hrs.Approved__c=true; 
                hrs.Approved_date__c=system.today();
            }else{
                hrs.Approved__c=false;
                hrs.Approved_houver__c=0.0;
            }
            hrs.plan__c =subPrj.Parent_project__c ;
            hrs.To_Project__c = prjID;
            hrs.name = subPrj.name;  
            insert hrs;
        }else if(defaultProject){
            list<SUbProject__c> pro=[SELECT ID,Name,OwnerId FROM SUbProject__c WHERE id=:ccId limit 1];
            if(pro[0].OwnerId==UserInfo.getUserId()){    
                hrs.Approved__c=true;  
                hrs.Approved_date__c=system.today();
            }
            else{
                hrs.musqot__Approved__c=false;
                hrs.Approved_houver__c=0.0;
            } 
            hrs.project__c = subPrj.Project_del__c ;
            hrs.To_Project__c = prjId;      
            hrs.Name = subprj.name;
            insert hrs;
        }
        else{
            try{  
                Costcentre__c defaultCC=[SELECT Id,owner.name,ownerId
                                         FROM  Costcentre__c where Id =:ccId];          
                // this is for autoapproved
                if(defaultCC.ownerId==UserInfo.getUserId()){
                    hrs.Cost_center__c= ccRec.Id;
                    hrs.Approved__c=true;
                    hrs.Approved_date__c=system.today();
                }
                else{
                    hrs.Cost_center__c= ccRec.Id;
                    hrs.Approved__c=false; 
                    hrs.Approved_houver__c=0.0;
                }
                hrs.To_Project__c = subprj1.id;      
                hrs.Name = subPrj1.name;
                insert hrs;
            }catch(exception e){}
        }
    }
    public class Reciver{
    }
    //---Raju prepared fisical year dropdowen --- 
    public string fisYearCompare;
    public List<SelectOption> fisicalYearOptions
    {
        get
        {
            list<FiscalYearSettings>queryResult= [SELECT Id, Name
                                                  FROM FiscalYearSettings order by SystemModstamp limit 200];
            fisicalYearOptions= new List<SelectOption>(); 
            Set<SelectOption>fiscalYerSet= new set<SelectOption>();
            for(FiscalYearSettings obj:queryResult)
            {  
                fisYearCompare=obj.Name;
                fisYearCompare=fisYearCompare.substring(0,4);
                for(integer i:pronSpanYears){
                    //if(projectYearSet.contains(string.valueof(i))){
                        if(fisYearCompare==string.valueof(i))
                            fiscalYerSet.add(new SelectOption(obj.id, obj.Name));
                   // }   
                }              
            }    
            fisicalYearOptions.addAll(fiscalYerSet);
            return fisicalYearOptions;
        }
        set;
    }
    //----End----
}