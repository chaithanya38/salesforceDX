/********************************************************************
Class Name: Hoursplanpopupcls 
Author:chaithanya daggumati         Last modified by:Raju GN
Date: 03/04/2015                    Date:03/04/2015 
Dec: Adding fiscal year functionality-- 
********©2013 Musqot marketing technology Pvt ltd *******************/
public with sharing class Hoursplanpopupcls {  
    public Allocation_resources__c hrs{get;set;}
    public project__c plan{get;set;}
    public boolean sendRec{get;set;}
    public string defaultFiscalYearId{get;set;}
    public boolean selfApp{get;set;}
    public boolean ccRequst{get;set;}    
    public boolean ccApp{get;set;}
    public String ccId{get;set;}
    public String uname{get;set;}
    public Costcentre__c ccRec{get;set;}
    public List<Costcentre__c>defaultCostenrList{get;set;}
    String planID;
    //--
    public String selectedFisicalYear{get;set;}
    public integer planYear;
    public integer planEndDate;
    public string PlanName;
    public list<integer>planSpanYears=new list<integer>();
    public List<Costcentre__c> CC_Temp = new List<Costcentre__c>();
    public Hoursplanpopupcls(){
        hrs= new Allocation_resources__c ();
        defaultCostenrList=[SELECT Id, cc_Owner__c, owner.name, OwnerId, Name FROM  Costcentre__c LIMIT 1];
        if(defaultCostenrList.size()>0){
            if(defaultCostenrList[0].OwnerId<>UserInfo.getUserId()){
                ccRequst=false;   
            } 
        }
        planID = ApexPages.currentPage().getParameters().get('pid');        
        hrs.To_Plan__c = planId;
        //ccRequst=true;
        List<Activity__c> musAct=[SELECT id,Use_Allocation__c  
                                  FROM Activity__c limit 1];
        if(musAct.size() > 0) {
            if(musAct[0].Use_Allocation__c==true){         
                selfApp=true;
                ccApp=false;
            }else{
                ccApp=true;
                ccRequst=false;
            }
        }
        if(CCList.isEmpty())  
        {
            sendRec=true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.cc_createcc);
            ApexPages.addMessage(myMsg);
        }  
        //----Raju To get Parent Plan Span Years---
        try{
            project__c plan = [SELECT Id,Name, Starts_date__c, Ends_date__c 
                               FROM project__c 
                               WHERE id =:planId limit 1];
            If(plan.name<>null) {
                planYear=plan.Starts_date__c.year();
                planEndDate=plan.Ends_date__c.year();
                PlanName=plan.Name;
            }
            
        }catch(Exception e){}
        for(integer i=planYear;i<=planEndDate;i++){
            integer currentYear=system.today().year();
            if(i>=currentYear){
              planSpanYears.add(i);
            }
        }  
        //----------End----
    }
    /*****************************************************
CCList: Convert lookup to dropdown of Costcentres list
******************************************************/
    public List<SelectOption> CCList
    {
        get
        {
            CC_Temp = [Select u.Name, u.Id 
                       From Costcentre__c u where Status__c='Active' limit 250];
            CCList= new List<SelectOption>(); 
            for(Costcentre__c objPLA: CC_Temp )
            {
                CCList.add(new SelectOption(objPLA.Id, objPLA.Name));
            }
            if(!CCList.isEmpty() && ccId==null){
                ccRec=[SELECT Id, cc_Owner__c, owner.name, OwnerId, Name 
                       FROM Costcentre__c 
                       where Id =:CCList[0].getvalue()];
            }
            return CCList;
        }
        set;
    }
    //insert Allocationresorces 
     public void Selfhrs(){
             try{  
             Costcentre__c defaultCC=[SELECT Id,owner.name,ownerId
                                     FROM  Costcentre__c where ownerId=:UserInfo.getUserId()];
             hrs.Cost_center__c=defaultCC.Id;
             hrs.Approved__c=true;
             hrs.Approved_date__c=system.today();            
             hrs.To_Plan__c = planId;      
             hrs.Name = planname;
             insert hrs;
             }catch(exception e){}
    }
    //
    
    public void saveHrs(){
         system.debug('@@@saveHrs@@@@');
        try{
            Costcentre__c defaultCC=[SELECT Id,owner.name,ownerId
                                     FROM  Costcentre__c where Id =:ccId];
            if (Allocation_resources__c.sObjectType.getDescribe().isCreateable()){
                if(ccId<>null){
                    if(defaultCC.ownerId==UserInfo.getUserId()){
                        hrs.Cost_center__c= ccRec.Id;
                        hrs.musqot__Approved__c=true;
                        hrs.musqot__Approved_date__c=system.today();
                    }else{
                        hrs.Cost_center__c= ccRec.Id;
                        hrs.musqot__Approved__c=false;
                        hrs.Approved_houver__c=0.0;
                    }            
                }           
                hrs.To_Plan__c = planId;      
                hrs.Name = planname;
                insert hrs;
            }
        }catch(exception e){}
    }
    public void ccUserRec(){
        try{
            ccRec=[SELECT Id, cc_Owner__c, owner.name, OwnerId, Name 
                   FROM Costcentre__c 
                   where Id =:ccId];        
            if(ccRec.OwnerId== UserInfo.getUserId()){                                      
                ccRequst=false;  
            }
            else{                        
                ccRequst=true;  
            }
        }catch(exception e){}
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
            for(FiscalYearSettings obj:queryResult)
            {  
                fisYearCompare=obj.Name;
                fisYearCompare=fisYearCompare.substring(0,4);
                if(fisYearCompare==string.valueof(system.now().year())){
                    defaultFiscalYearId=obj.Name;
                }  
                for(integer i:planSpanYears){
                    if(fisYearCompare==string.valueof(i))
                        fisicalYearOptions.add(new SelectOption(obj.id,obj.Name));
                }
            }
            return fisicalYearOptions;
        }
        set;
    }
    //----End----
}