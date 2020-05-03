/********************************************************************
Class Name: FRPlanPopupCtrl
Author:G Janardhanreddy         Last modified by:Raju GN
Date: 17/7/2014                 Date:16/10/2015  
Dec:Adding fiscal year functionality
********©2013 Musqot marketing technology Pvt ltd *******************/

public with sharing class FRProjectPopupCtrl{
    public Allocation_amount__c amt{get;set;}
    public project__c plan{get;set;}
    public boolean sendRec{get;set;}
    public boolean selfApp{get;set;}
    public boolean ccApp{get;set;}
    public boolean ccRequst{get;set;}    
    public String ccId{get;set;}
    public String uname{get;set;}
    public string defaultFiscalYearName{get;set;} 
    public Costcentre__c ccRec{get;set;}
    public List<Costcentre__c>defaultCostenrList{get;set;}
    public String selectedFisicalYear{get;set;}
    
    public list<integer> projectYear=new list<integer>();
    //
    public Subproject__c subPrj {get;set;}
    String prjId;
    String planId;    
    public List<Costcentre__c> CC_Temp = new List<Costcentre__c>();
    public List<musqot__Allocation_amount__c> allcationList=new List<musqot__Allocation_amount__c>();
    //----New veriables --
    public integer planYear;
    public integer planEndDate;
    public string planname;
    public String parentName{get;set;}
    public boolean defaultplan {get;set;}
    public boolean defaultProject {get;set;}
    //public list<integer>planSpanYears=new list<integer>();
    public string sObjName;
    public Set<string> projectYearSet = new Set<string>();
    public list<integer>pronSpanYears;
    public integer projectEndYear;
    public integer projctStartdat;
    public set<id>fsyesrSet;
    public string ownerName{get;set;}
    public boolean parentShow{get;set;}
    //Constructor
    public FRProjectPopupCtrl(){
        amt = new Allocation_amount__c ();
        subPrj = new Subproject__c();
        pronSpanYears=new list<integer>();
        parentShow=true;
        prjId = ApexPages.currentPage().getParameters().get('prjID');
        defaultCostenrList=[SELECT Id, cc_Owner__c, owner.name, OwnerId, Name FROM  Costcentre__c LIMIT 1];
        try{
            subPrj = [select ID,Name,Project_del__r.OwnerId,Parent_project__c,Parent_project__r.Starts_date__c,
                      Parent_project__r.OwnerId,Parent_project__r.Ends_date__c,Subproject__c.Owner.name,
                      Subproject__c.OwnerId,Starts_date__c,Ends_date__c ,Project_del__r.id,Project_del__r.owner.name,
                      Project_del__r.Name,Parent_project__r.owner.name,Parent_project__r.id,
                      Parent_project__r.Name from Subproject__c where Id =:prjId];
            
            projctStartdat= subPrj.Starts_date__c.year();
            projectEndYear=subPrj.Ends_date__c.year();
            for(integer i=projctStartdat;i<=projectEndYear;i++){
               integer curntYear=system.today().year();
                if(i>=curntYear){
                   pronSpanYears.add(i);
                }
            }   
            
            if(defaultCostenrList.size()>0){
                if(defaultCostenrList[0].OwnerId<>UserInfo.getUserId()){
                    ccRequst=false;   
                } 
            }
            planID = ApexPages.currentPage().getParameters().get('pid');        
            amt.To_Plan__c = planId;   
            fsyesrSet=new set<id>();
            //This is Parent project allocated year----
            string parentPlanId;
            string parentProjId;
            if(subPrj.Project_del__c<>null){
                ccId=subPrj.Project_del__r.OwnerId;
                parentProjId=subPrj.Project_del__c;
                ownerName=subPrj.Project_del__r.owner.name;
            }
            //This is Parent Plan allocated year----
            
            else if(subPrj.Parent_project__c<>null){
                ccId=subPrj.Parent_project__r.OwnerId;      
                parentPlanId=subPrj.Parent_project__c;
                ownerName=subPrj.Parent_project__r.owner.name;
            }
            allcationList=[SELECT Id,plan__c,FiscalYear__c 
                           FROM Allocation_amount__c 
                           where Approved__c=true and To_Plan__c=:parentPlanId limit 10]; 
            
            for(Allocation_amount__c a:allcationList){
                if(a.FiscalYear__c<>null && a.FiscalYear__c.length()>10){
                    fsyesrSet.add(a.FiscalYear__c);
                } 
            }
        }
        catch (System.QueryException e) {}  
        //--End ---
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
                ccRec=[SELECT Id, owner.name,OwnerId,Name 
                       FROM Costcentre__c 
                       where Status__c='Active' AND Id =:CCList[0].getvalue()];                             
            }
            if(planId<>null){
                Project__c planRec=[SELECT u.id,u.Name,u.OwnerId
                                    from Project__c u 
                                    WHERE id=:planId];
                CCList.add(new SelectOption(planRec.id,planRec.Name)); 
            }
            else if(subPrj.Project_del__r.id<>null){
                CCList.add(new SelectOption(subPrj.Project_del__r.id, subPrj.Project_del__r.name));
            }
            CC_Temp = [Select u.Name, owner.name,u.Id From musqot__Costcentre__c u where Status__c='Active' limit 250];
            
            for(Costcentre__c objCos: CC_Temp ){
                CCList.add(new SelectOption(objCos.Id, objCos.Name));                
            }                     
            return CCList;
        }        
        set;
    }
    //insert Allocationamount 
     public void saveSelfAmt(){  
             Costcentre__c defaultCC=[SELECT Id,owner.name,ownerId
                                     FROM  Costcentre__c where ownerId=:UserInfo.getUserId() LIMIT 1];
             amt.Costcentre__c=defaultCC.Id;
             amt.Approved__c=true;
             amt.Approvedate__c=system.today();            
             amt.To_Project__c = prjId;      
             amt.Name = subprj.name;
             insert amt;
    }
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
        sObjName =Id.valueof(ccId).getSObjectType().getDescribe().getName();
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
    //insert Allocationamount   
    public void saveAmt(){
        if (defaultplan){
            try{ 
                list<Project__c>p=[SELECT Id,OwnerId FROM Project__c WHERE ID=:ccId limit 1]; 
                if(p[0].OwnerId==UserInfo.getUserId()){    
                    amt.musqot__Approved__c=true;  
                    amt.Approvedate__c=system.today();                    
                }
                else{
                    amt.musqot__Approved__c=false;
                    amt.Approved_Amount__c=0.00;
                } 
                amt.plan__c = subPrj.Parent_project__c ;
                amt.To_Project__c = prjId;      
                amt.Name = subprj.name;                
                insert amt;
            }catch(exception e){}
        }else if(defaultProject){
            try{
                list<SUbProject__c> pro=[SELECT ID,Name,OwnerId FROM SUbProject__c WHERE id=:ccId limit 1];
                if(pro[0].OwnerId==UserInfo.getUserId()){    
                    amt.musqot__Approved__c=true;   
                }
                else{
                    amt.musqot__Approved__c=false;
                    amt.Approved_Amount__c=0.00;
                } 
                amt.project__c = subPrj.Project_del__c ;
                amt.To_Project__c = prjId;
                amt.Name = subprj.name;
                insert amt;
            }catch(exception e){}
        }
        else{
            try{  
                Costcentre__c defaultCC=[SELECT Id,owner.name,ownerId
                                         FROM  Costcentre__c where Id =:ccId];          
               
                if(defaultCC.ownerId==UserInfo.getUserId()){
                    amt.Costcentre__c= ccRec.Id;
                    amt.musqot__Approved__c=true;
                    amt.Approvedate__c=system.today();
                }
                else{
                    amt.Costcentre__c= ccRec.Id;
                    amt.musqot__Approved__c=false;
                    amt.Approved_Amount__c=0.00;
                }
                amt.To_Project__c = subprj1.id;      
                amt.Name = subPrj1.name;
                insert amt;
            }catch(exception e){}
        }
    }
    
    //---Raju prepared fisical year dropdowen --- 
    public string fisYearCompare;
    public List<SelectOption> fisicalYearOptions
    {
        get
        {   
            list<FiscalYearSettings>queryResult= [SELECT Id, Name FROM FiscalYearSettings
                                                  order by SystemModstamp LIMIT 250];
            fisicalYearOptions= new List<SelectOption>();    
            for(FiscalYearSettings obj:queryResult)
            {  
                fisYearCompare=obj.Name;
                fisYearCompare=fisYearCompare.substring(0,4);
                if(fisYearCompare==string.valueof(system.now().year())){
                    defaultFiscalYearName=obj.Name;
                }  
                for(integer i:pronSpanYears){
                    if(fisYearCompare==string.valueof(i))
                        fisicalYearOptions.add(new SelectOption(obj.id, obj.Name));
                }
            }
            return fisicalYearOptions;
        }
        set;
    }
    //----End----
}