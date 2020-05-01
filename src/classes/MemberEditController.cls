/*******************************************************
Class Name: MemberEditController
Author:G Janardhanreddy         Last modified by: Chaithanya daggumati
Date: 25/8/2014                 Date: 19/3/2015 
********©2013 Musqot marketing technology Pvt ltd *******/

public with sharing class MemberEditController{
    public String projectid{get;set;}
    public String mbrId{get;set;}
    public String subprjid{get;set;}
    public String mrkId{get;set;}
    public String cosid{get;set;}
    Public Members__c Mems{get;set;}
    public String mbrRole{get;set;}
    public MemberEditController(ApexPages.StandardController controller) {
        projectid = ApexPages.currentPage().getParameters().get('planid');
        subprjid = ApexPages.currentPage().getParameters().get('subid');
        mrkId = ApexPages.currentPage().getParameters().get('mrk');
        mbrId = ApexPages.currentPage().getParameters().get('mbrId');
        cosid = ApexPages.currentPage().getParameters().get('cosid');
        try {
            Mems = [Select id,Name, ProjMembers__c, ProjUsers__c,Cost_center__c,ProjUsers__r.name, musqot__Email_del__c,SubProjMembers__c, Role__c, Type__c, User_Email__c FROM Members__c  where id =:mbrId];        
        }
        catch (System.QueryException e) {
        } 
    }
    /****************
    Save(): This method will perform to update the member
    *******************/  
    public Pagereference Save(){ 
        Pagereference pr;
        if(Mems<>null){
            if (Members__c.sObjectType.getDescribe().isUpdateable())
            {
                Update Mems;
            }
            if(projectid<>null){
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/ProjectDetails?id='+EncodingUtil.urlEncode(projectid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb4','UTF-8');
                pr=new Pagereference (pageRef);
            }
            else if(subprjid<>null){
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/SubProject?id='+EncodingUtil.urlEncode(subprjid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb4','UTF-8');
                pr=new Pagereference (pageRef);
            }
            else if(mrkId<>null){
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/Marketingactivity?id='+EncodingUtil.urlEncode(mrkId,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb4','UTF-8');
                pr=new Pagereference (pageRef);
            }
			else if(cosid<>null){                
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/Costcenterdetail?id='+EncodingUtil.urlEncode(cosid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb4','UTF-8');
                pr=new Pagereference (pageRef);
            }            
        }
        return pr;
    }
    /****************
    deleteMember(): This method will perform to delete the member
    *******************/ 
    public Pagereference deleteMember(){
        if (Members__c.sObjectType.getDescribe().isDeletable())
        {
            delete Mems;
        }
        Pagereference pr;
        if(projectid<>null){
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/ProjectDetails?id='+EncodingUtil.urlEncode(projectid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb4','UTF-8');
            pr=new Pagereference (pageRef);
        }
        else if(subprjid<>null){
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/SubProject?id='+EncodingUtil.urlEncode(subprjid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb4','UTF-8');
            pr=new Pagereference (pageRef);
            pr= new Pagereference('/apex/SubProject?id='+EncodingUtil.urlEncode(subprjid,'UTF-8'));
        }
        else if(mrkId<>null){
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/Marketingactivity?id='+EncodingUtil.urlEncode(mrkId,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb4','UTF-8');
            pr=new Pagereference (pageRef);
        }
        else if(cosid<>null){                
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/Costcenterdetail?id='+EncodingUtil.urlEncode(cosid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb4','UTF-8');
                pr=new Pagereference (pageRef);
            }
        return pr;
    }   
    /****************
    Cancel(): This method will perform to cancel from the Membereditpage
    *******************/ 
    public Pagereference Cancel(){
        Pagereference pr;
        if(projectid<>null){
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/ProjectDetails?id='+EncodingUtil.urlEncode(projectid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb4','UTF-8');
            pr=new Pagereference (pageRef);
        }
        else if(subprjid<>null){
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/SubProject?id='+EncodingUtil.urlEncode(subprjid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb4','UTF-8');
            pr=new Pagereference (pageRef);
        }
        else if(mrkId<>null){
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/Marketingactivity?id='+EncodingUtil.urlEncode(mrkId,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb4','UTF-8');
            pr=new Pagereference (pageRef);
        }
        else if(cosid<>null){                
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/Costcenterdetail?id='+EncodingUtil.urlEncode(cosid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb4','UTF-8');
                pr=new Pagereference (pageRef);
            }
        return pr;
        } 
    }