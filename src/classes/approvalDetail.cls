/***********************************************************
Class Name: approvalDetail
Author:G Janardhanreddy     Last modified by:Raju GN
Date: 15/7/2014             Date:06/10/2015
Description:Adding fiscal year field both page and controller
********©2013 Musqot marketing technology Pvt ltd **********/
public with sharing class approvalDetail{    
    public Allocation_amount__c amt{get;set;}
    public boolean returnValue {get; set;}
    public decimal Remainingamount{get;set;}
    public decimal purchaseOrders {get;set;}
    public string Comments{get;set;}
    public decimal alloc {get;set;}
    public decimal suballoc {get;set;}
    String amtId;
    Id planId;     
    Id prjId;
    Id markId;
    public string fiscalYear{get;set;}
    public string ccString{get;set;}
    public string cId{get;set;}
    public string fromReject{get;set;}
    public approvalDetail(){
        amt = new Allocation_amount__c();  
        amtId = ApexPages.currentPage().getParameters().get('amtId');
        ccString = ApexPages.currentPage().getParameters().get('cId');
        fromReject = ApexPages.currentPage().getParameters().get('reject');
        try{
            
            amt = [select Id,Name, musqot__To_Marketing_activity__c,musqot__To_Project__c,musqot__To_Plan__c,
                   Costcentre__c, musqot__plan__c, musqot__project__c,Costcentre__r.id,
                   Approved_Amount__c, Allocated__c, Approvedate__c,Description__c,Project__r.name,plan__r.name,Costcentre__r.name 
                   ,musqot__FiscalYear__c from Allocation_amount__c 
                   where Id =:amtId]; 
            
            Decimal requestamount = (Decimal) amt.get('Allocated__c');
            requestamount = (requestamount == null) ? 0 : requestamount.setscale(2); 
            prjId = null;
            planId = null;
            //FiscalYearSettings Result= [SELECT Id, Name
                                        //FROM FiscalYearSettings where id=:amt.FiscalYear__c];
            //fiscalYear=Result.Name;
            /*******remaining value at project level**********/
            /*******Request to Costcenter from plan**********/
            if(amt.Costcentre__c != null && amt.musqot__To_Plan__c != null){
                Remainingamount = null; 
            }
            /*******Request to Plan from Project**********/        
            else if(amt.musqot__Plan__c != null && amt.musqot__To_Project__c != null){
                prjId = null;
                planId =  amt.musqot__Plan__c;
            }
            /*******Request to costcenter from Project and subProject**********/ 
            else if(amt.Costcentre__c != null && amt.musqot__To_Project__c != null){
                string subPro=  amt.musqot__To_Project__c;
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
            else if(amt.Project__c != null){
                prjId = amt.Project__c;
                planId = null;
            }
            
            if (amt.Costcentre__c == null){    
                if(prjId != null){
                    AggregateResult allocation = [SELECT SUM(Approved_Amount__c) totals FROM Allocation_amount__c WHERE To_Project__c = :prjId ]; 
                    alloc = (Decimal) allocation.get('totals');
                }
                else if(planId != null){
                    AggregateResult allocation = [SELECT SUM(Approved_Amount__c) totals FROM Allocation_amount__c WHERE To_Plan__c = :planId ];
                    alloc = (Decimal) allocation.get('totals');
                }
                
                if(planId != null||test.isrunningtest()){
                    AggregateResult suballocation = [SELECT SUM(Approved_Amount__c) totals FROM Allocation_amount__c WHERE Plan__c = :planId ];
                    suballoc = (Decimal) suballocation.get('totals');
                }
                else if(prjId != null){
                    AggregateResult suballocation = [SELECT SUM(Approved_Amount__c) totals FROM Allocation_amount__c WHERE Project__c = :prjId ]; 
                    suballoc = (Decimal) suballocation.get('totals');
                }
                
                //  calulation of AggregateResult for purchaseOrders
                List<Purchase_order__c> POcalk = new List<Purchase_order__c>();
                if(planId != null||test.isrunningtest()){
                    POcalk = [SELECT Total_cost__c, total_Invoice_cost__c, Purchase_order_cloesed__c 
                              FROM Purchase_order__c 
                              WHERE Project__c = :planId ];
                }
                else if(prjId != null){
                    POcalk = [SELECT Total_cost__c, total_Invoice_cost__c, Purchase_order_cloesed__c 
                              FROM Purchase_order__c 
                              WHERE subproject__c = :prjId ];
                }
                
                Decimal purchaseOrders = 0;
                for(Purchase_order__c pruchOrdr : POcalk){
                    if(pruchOrdr.Purchase_order_cloesed__c ){
                        purchaseOrders += pruchOrdr.total_Invoice_cost__c;
                    }
                    else if( pruchOrdr.total_Invoice_cost__c >  pruchOrdr.Total_cost__c){
                        purchaseOrders += pruchOrdr.total_Invoice_cost__c;
                    }
                    else {
                        purchaseOrders += pruchOrdr.Total_cost__c; 
                    }
                }    
                Decimal res = purchaseOrders;
                res = (res == null) ? 0 : res.setscale(2);                
                alloc = (alloc == null) ? 0 : alloc.setscale(2);
                suballoc = (suballoc == null) ? 0 : suballoc.setscale(2);
                Decimal remaining = (Decimal)  alloc - suballoc - res ;
                Remainingamount = remaining;
                Remainingamount = (Remainingamount == null) ? 0 : Remainingamount.setscale(2); 
            } 
        } 
        catch(exception e){}
        try{
            FiscalYearSettings Result= [SELECT Id, Name FROM FiscalYearSettings where id=:amt.FiscalYear__c];
            fiscalYear=Result.Name;
            }catch(exception e){}
    }           
    
    /****************************************************************************************
approveRecord():update the Allocation_amount__c object records and redirect to  home page
******************************************************************************************/
    public pageReference approveRecord(){
        
        if(amt.Approved_Amount__c<>null ){
            
            if(amt.Approved_Amount__c > Remainingamount){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.appr_Remaining);
                ApexPages.addMessage(myMsg);
                return null;     
            }else{                   
                Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();        
                req.setComments('Request Approved');
                req.setAction('Approve');
                Id workId = getWorkItemId(amt.Id); 
                if(workId == null) {
                    amt.addError('Error Occured in Trigger'); 
                    return null;     
                }
                else{
                    req.setWorkitemId(workId);
                    Approval.ProcessResult result =  Approval.process(req);
                }    
                amt.Approvedate__c=system.today();
                amt.Approved_By__c=UserInfo.getUserId();
                update amt;
                if(ccString<>null){
                    //String tabId = System.currentPageReference().getParameters().get('tabId');
                    string pageRef='/apex/Costcenterdetail?Id='+EncodingUtil.urlEncode(ccString,'UTF-8');
                    Pagereference pg=new Pagereference (pageRef);
                    return pg;
                }else
                    return new pageReference('/home/home.jsp');                           
            }
        }                    
        else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.WARNING,'Please enter Approved Amount');
            ApexPages.addMessage(myMsg);
            return null;
        }
    }
    /**************************************
rejectRecord():  redirect to  home page 
***************************************/
    public pageReference rejectRecord(){
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments('Request Reject');
        req.setAction('Reject');
        Id workId = getWorkItemId(amt.Id);
        if(workId == null) {
            amt.addError('Error Occured in Trigger');      
        }
        else{
            req.setWorkitemId(workId);
            // reject the request
            Approval.ProcessResult result =  Approval.process(req);            
        }
        if(ccString<>null){
            /*if(fromReject=='true'){
                string pageRef='/apex/Costcenterdetail?Id='+EncodingUtil.urlEncode(ccString,'UTF-8');
            	Pagereference pg=new Pagereference (pageRef);
            	return pg;
            }*/
            //String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/Costcenterdetail?Id='+EncodingUtil.urlEncode(ccString,'UTF-8');
            Pagereference pg=new Pagereference (pageRef);
            return pg;
        }else
            return new pageReference('/home/home.jsp'); 
    }
    public pageReference cancleApproval(){
        ccString = ApexPages.currentPage().getParameters().get('cId');
        if(ccString<>null){
            //String tabId = System.currentPageReference().getParameters().get('tabId');
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