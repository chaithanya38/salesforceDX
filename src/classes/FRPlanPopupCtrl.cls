/********************************************************************
Class Name: FRPlanPopupCtrl
Author:G Janardhanreddy         Last modified by:Raju GN
Date: 17/7/2014                 Date:16/10/2015  
Dec:Adding fiscal year functionality
********©2013 Musqot marketing technology Pvt ltd *******************/

public with sharing class FRPlanPopupCtrl{
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
    Public musqot__Activity__c musAct{get;set;}
    public List<Costcentre__c>defaultCostenrList{get;set;}
    public String selectedFisicalYear{get;set;}
    String planID;
    public List<Costcentre__c> CC_Temp = new List<Costcentre__c>();
    //----New veriables --
    public integer planYear;
    public integer planEndDate;
    public string planname;
    public list<integer>planSpanYears=new list<integer>();
    //Constructor
    public FRPlanPopupCtrl(){
        amt = new Allocation_amount__c ();       
        defaultCostenrList=[SELECT Id, cc_Owner__c, owner.name, OwnerId, Name FROM  Costcentre__c LIMIT 1];
        if(defaultCostenrList.size()>0){
            if(defaultCostenrList[0].OwnerId<>UserInfo.getUserId()){
                ccRequst=false;   
            } 
        }
        planID = ApexPages.currentPage().getParameters().get('pid');        
        amt.To_Plan__c = planId;
        if(CCList.isEmpty())  
        {
            sendRec=true;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.cc_createcc);
            ApexPages.addMessage(myMsg);
        }  
        //----Raju To get Parent Plan Span Years---
        try{
            project__c plan = [SELECT Id, Name, Starts_date__c, Ends_date__c 
                               FROM project__c 
                               WHERE id =:planId limit 1];  
            if(plan.Starts_date__c<>null) {  
                planYear=plan.Starts_date__c.year();
                planEndDate=plan.Ends_date__c.year();
                planname=plan.Name;
            }
        }catch(Exception e){}
        for(integer i=planYear;i<=planEndDate;i++){
            integer curntYear=system.today().year();
            if(i>=curntYear){
                planSpanYears.add(i);
           } 
        }  
        //----------End----
        Activity__c musAct=[SELECT id,Name,Use_Allocation__c  
                            FROM Activity__c limit 1];
        if(musAct.Use_Allocation__c==true){         
            selfApp=true;
            ccApp=false;
        }else{
            ccApp=true;
            ccRequst=false; 
        }
    }
    /*****************************************************
CCList: Convert lookup to dropdown of Costcentres list
******************************************************/
    public List<SelectOption> CCList
    {
        get
        {
            CC_Temp = [Select u.Name, owner.name,u.Id From Costcentre__c u where Status__c='Active' limit 250];                       
            CCList= new List<SelectOption>(); 
            for(Costcentre__c objPLA: CC_Temp ){
                CCList.add(new SelectOption(objPLA.Id, objPLA.Name));
            }            
            if(!CCList.isEmpty() && ccId==null){
                ccRec=[SELECT Id, owner.name, OwnerId, Name FROM Costcentre__c 
                       where Id =:CCList[0].getvalue()];                       
            }
            return CCList;
        }
        set;
    }
      //insert Allocationamount 
     public void saveSelfAmt(){  
             Costcentre__c defaultCC=[SELECT Id,owner.name,ownerId
                                     FROM  Costcentre__c where ownerId=:UserInfo.getUserId() limit 1];
             amt.Costcentre__c=defaultCC.Id;
             amt.Approved__c=true;
             amt.Approvedate__c=system.today();            
             amt.To_Plan__c = planId;      
             amt.Name = planname;
             insert amt;
    }
    //
    public void saveAmt(){         
        try{
            Costcentre__c defaultCC=[SELECT Id,owner.name,ownerId
                                     FROM  Costcentre__c where Id =:ccId];          
            if (Allocation_amount__c.sObjectType.getDescribe().isCreateable()){
                if(ccId<>null){
                    // this is for autoapproved
                    if(defaultCC.ownerId==UserInfo.getUserId()){
                        amt.Costcentre__c= ccRec.Id;
                        amt.Approved__c=true;
                        amt.Approvedate__c=system.today();
                    }else{
                        amt.Costcentre__c= ccRec.Id;
                        amt.Approved__c=false;
                        amt.Approved_Amount__c=0.00;
                    }            
                }           
                amt.To_Plan__c = planId;      
                amt.Name = planname;
                insert amt;
            }
        }catch(exception e){}
    }
    //this method used at cost center onchange event-----
    public void ccUserRec(){               
        try{
            ccRec=[SELECT Id,  owner.name, OwnerId, Name 
                   FROM  Costcentre__c 
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
                    defaultFiscalYearName=obj.Name;
                }  
                for(integer i:planSpanYears){
                    if(fisYearCompare==string.valueof(i))
                        fisicalYearOptions.add(new SelectOption(obj.id, obj.Name));
                }
            }
            if(fisicalYearOptions.size()==0){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Fiscal year exist not in the organization');
                ApexPages.addMessage(myMsg); 
                return null; 
            }
            else
                return fisicalYearOptions;
        }
        set;
    }
    //----End----
}