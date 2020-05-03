/***********************************************************
Class Name: approvalhourdetailcont
Author:Chaithanya daggumati     Last modified by:Raju GN
Date: 06/04/2015                Date:06/10/2015
Description:Adding fiscal year field both page and controller
********©2013 Musqot marketing technology Pvt ltd **********/
public with sharing class approvalhourdetailcont{    
    //public ProcessInstanceStep piw{get;set;}
    public Allocation_resources__c hrs{get;set;}
    public boolean returnValue {get; set;}    
    public decimal Remaininghours{get;set;}
    public decimal Estimate{get;set;}
    public string Comments{get;set;}
    public decimal alloc {get;set;}
    public decimal suballoc {get;set;}
    String hrsId;
    //String piwID;
    Id planId;     
    Id prjId;
    Id markId;
    public string fiscalYear{get;set;}
    public string ccString{get;set;}
    public string ccId{get;set;}
    public approvalhourdetailcont(){
       // piw = new ProcessInstanceStep();
        hrs = new Allocation_resources__c();  
       // piwID = ApexPages.currentPage().getParameters().get('id');
        hrsId = ApexPages.currentPage().getParameters().get('arsId');
        ccString = ApexPages.currentPage().getParameters().get('ccId');
        try{
             //   piw = [Select ActorId,Comments,OriginalActorId,StepStatus from ProcessInstanceStep where ProcessInstanceId =:piwId];
            hrs = [select Id,Name, musqot__To_Marketing_activity__c,musqot__To_Project__c,musqot__To_Plan__c,
                   Cost_center__c, musqot__plan__c, musqot__project__c, 
                   Approved_houver__c, Requested_hours__c, Approved_date__c,Description__c,
                   Project__r.name,plan__r.name,Cost_center__r.name ,FiscalYear__c 
                   from Allocation_resources__c where Id =:hrsId]; 
                          
            Decimal requesthours = (Decimal) hrs.get('Requested_hours__c');
            requesthours = (requesthours == null) ? 0 : requesthours.setscale(2); 
            prjId = null;
            planId = null;
			//FiscalYearSettings Result= [SELECT Id, Name
                                        //FROM FiscalYearSettings where id=:hrs.FiscalYear__c];
            //fiscalYear=Result.Name;            
            /*******remaining value at project level**********/
            /*******Request to Costcenter from plan**********/
            if(hrs.Cost_center__c!= null && hrs.musqot__To_Plan__c != null){
                Remaininghours = null; 
            }
            /*******Request to Plan from Project**********/        
            else if(hrs.musqot__Plan__c != null && hrs.musqot__To_Project__c != null){
                prjId = null;
                planId =  hrs.musqot__Plan__c;
            }
              /*******Request to costcenter from Project and subProject**********/ 
            else if(hrs.Cost_center__c != null && hrs.musqot__To_Project__c != null){
                    string subPro=  hrs.musqot__To_Project__c;
                    subproject__c parentPlanId=[SELECT id,Parent_project__c,Project_del__c FROM subproject__c WHERE id=:subPro];
                    if(parentPlanId.Project_del__c==null){
                         prjId = null;
                         planId=parentPlanId.Parent_project__c;
                    }else{
                          planId = null;
                          prjId=parentPlanId.Project_del__c;
                    }     
            }
            /*******Request to Project from subProject or marketing activity**********/ 
            else if(hrs.musqot__Project__c != null ){
                prjId = hrs.musqot__Project__c;
                planId = null;
            }
            
            if (hrs.Cost_center__c == null){    
                if(prjId != null){
                    AggregateResult allocation = [SELECT SUM(Approved_houver__c) totals FROM Allocation_resources__c WHERE To_Project__c = :prjId ]; 
                    alloc = (Decimal) allocation.get('totals');
                }
                else if(planId != null){
                    AggregateResult allocation = [SELECT SUM(Approved_houver__c) totals FROM Allocation_resources__c WHERE To_Plan__c = :planId ];
                    alloc = (Decimal) allocation.get('totals');
                }
                
                if(planId != null){
                    AggregateResult suballocation = [SELECT SUM(Approved_houver__c) totals FROM Allocation_resources__c WHERE Plan__c = :planId ];
                    suballoc = (Decimal) suballocation.get('totals');
                }
                else if(prjId != null){
                    AggregateResult suballocation = [SELECT SUM(Approved_houver__c) totals FROM Allocation_resources__c WHERE Project__c = :prjId ]; 
                    suballoc = (Decimal) suballocation.get('totals');
                }
                
                
                List<Task> tsk = new List<Task>();
                if(planId != null){
                    tsk = [Select Id,ownerId,CreatedByid,owner.name,WhatId, Remaining__c, IsClosed, 
                            Allocated_h__c, Outcome_h__c,Task_name__c FROM Task where whatid=:planId];
                }
                else if(prjId != null){
                    tsk = [Select Id,ownerId,CreatedByid,owner.name,WhatId, Remaining__c, IsClosed, 
                            Allocated_h__c, Outcome_h__c,Task_name__c FROM Task where whatid=:prjId];
                }
                
                 Decimal estimate= 0;
                
                for(task t1: tsk){
                estimate +=t1.Allocated_h__c;
                }
                Decimal Est=estimate;
                Est = (Est == null) ? 0 : Est.setscale(1);
                alloc = (alloc == null) ? 0 : alloc.setscale(1);
                suballoc = (suballoc == null) ? 0 : suballoc.setscale(1);
                Decimal remaining = (Decimal)alloc - suballoc-Est;
                Remaininghours = remaining;
                Remaininghours = (Remaininghours == null) ? 0 : Remaininghours.setscale(1);
              }               
             }                 
              catch(exception e){}
             try{
              FiscalYearSettings Result= [SELECT Id,Name FROM FiscalYearSettings where id=:hrs.FiscalYear__c];                                        
                fiscalYear=Result.Name;
            }catch(exception e){}
          }    
    /****************************************************************************************
    approverec():update the Allocation_resources__c object records and redirect to  home page
    ******************************************************************************************/
    public pageReference approverec(){        
        if(hrs.Approved_houver__c<>null)
        {            
            if(hrs.Approved_houver__c > Remaininghours){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You cant approve hours within your remaining hours.');
                ApexPages.addMessage(myMsg);
                return null;     
            }else{                    
                Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();        
                req.setComments('Request Approved');
                req.setAction('Approve');
                Id workId = getWorkItemId(hrs.Id); 
                if(workId == null) {
                    hrs.addError('Error Occured in Trigger'); 
                    return null;     
                }
                else{
                    req.setWorkitemId(workId);
                    Approval.ProcessResult result =  Approval.process(req);
                }   
                hrs.Approved_date__c=system.today();
                update hrs;
                if(ccString<>null){
                    string pageRef='/apex/Costcenterdetail?Id='+EncodingUtil.urlEncode(ccString,'UTF-8');
                    Pagereference pg=new Pagereference (pageRef);
                    return pg;
                }else    
                return new pageReference('/home/home.jsp');                           
            }
        }                    
        else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'Please enter Approved Hours');
            ApexPages.addMessage(myMsg);
            return null;
        }
    }
    /**************************************
    rejectrec():  redirect to  home page 
    ***************************************/
    public pageReference rejectrec(){
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments('Request Reject');
        req.setAction('Reject');
        Id workId = getWorkItemId(hrs.Id);
        if(workId == null) {
            hrs.addError('Error Occured in Trigger');      
        }
        else{
            req.setWorkitemId(workId);
            // reject the request
            Approval.ProcessResult result =  Approval.process(req);            
        }
        if(ccString<>null){
            string pageRef='/apex/Costcenterdetail?Id='+EncodingUtil.urlEncode(ccString,'UTF-8');
            Pagereference pg=new Pagereference (pageRef);
            return pg;
        }else
                return new pageReference('/home/home.jsp'); 
    }
    public pageReference cancleApproval(){
        ccString = ApexPages.currentPage().getParameters().get('ccId');
        if(ccString<>null){
            string pageRef='/apex/Costcenterdetail?Id='+EncodingUtil.urlEncode(ccString,'UTF-8');
            Pagereference pg=new Pagereference (pageRef);
            return pg;
        }else
            return new pageReference('/home/home.jsp'); 
    }
    public Id getWorkItemId(Id targetObjectId){
        Id retVal = null;
        for(ProcessInstanceWorkitem workItem  : [Select Id from ProcessInstanceWorkitem  where ProcessInstance.TargetObjectId =:targetObjectId]){
            retVal  =  workItem.Id;
        }
        return retVal;
    }        
}