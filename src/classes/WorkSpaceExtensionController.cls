/****************************************************************
Class Name: WorkSpaceExtensionController 
Author:G Janardhanreddy         Last modified by: G janardhanreddy
Date: 16/7/2014                 Date:  20/03/2015
********©2013 Musqot marketing technology Pvt ltd ***************/
public with sharing class WorkSpaceExtensionController {
    private ApexPages.StandardController sc;
    public String projectid{get;set;}
    public String plnId{get;set;}
    public String workspaceId {get;set;}
    public String markId{get;set;}
    public Workspace__c workSpace{get;set;}
    Public WorkSpaceExtensionController(ApexPages.StandardController sc){
        This.sc = sc;   
        projectid = ApexPages.currentPage().getParameters().get('SubProjectid');                     
        plnId = ApexPages.currentPage().getParameters().get('plnId');                     
        workspaceId = ApexPages.currentPage().getParameters().get('id');
        markId= ApexPages.currentPage().getParameters().get('marktingid');                     
        if(workspaceId<>''){
            try {
                workSpace = [select Id,Name,ProjectName__c,subproject__c,Description__c,html_description__c from Workspace__c where Id =:workspaceId];   
            }
            catch (System.QueryException e) {
            }
        }         
    }
    public WorkSpaceExtensionController(){
        templateInfo = new Workspace__c();
        workSpace = new Workspace__c ();          
    }
    /***********************************************************************
	Save(): update the workspace record and redirects to related parent page
	************************************************************************/
    Public Pagereference Save(){
        if (Workspace__c.sObjectType.getDescribe().isUpdateable())
        {
            update workSpace;
        }        
        Pagereference PR;
        if(projectid<>null){            
            PR = new Pagereference('/apex/SubProject?id='+EncodingUtil.urlEncode(projectid,'UTF-8'));                  
        }        
        if(plnId<>null){
            PR = new Pagereference('/apex/ProjectDetails?id='+EncodingUtil.urlEncode(plnId,'UTF-8'));                              
        }
        if(markId<>null){
            PR = new Pagereference('/apex/Marketingactivity?id='+EncodingUtil.urlEncode(markId,'UTF-8'));
        }         
        return PR;
    }
     Public Pagereference Save2(){
        if (Workspace__c.sObjectType.getDescribe().isUpdateable())
        {
            update workSpace;
        }        
        Pagereference PR;
        if(projectid<>null){            
            PR = new Pagereference('/apex/SubProject_Resp?id='+EncodingUtil.urlEncode(projectid,'UTF-8'));                  
        }        
        if(plnId<>null){
            PR = new Pagereference('/apex/ProjectDetails_Resp?id='+EncodingUtil.urlEncode(plnId,'UTF-8'));                              
        }
        if(markId<>null){
            PR = new Pagereference('/apex/Marketingactivity_Resp?id='+EncodingUtil.urlEncode(markId,'UTF-8'));
        }         
        return PR;
    }
    /*****************************************************
	cancel():redirects to redirects to related parent pag
	******************************************************/
    Public Pagereference cancel(){
        Pagereference PR;        
        if(projectid<>null){            
            PR = new Pagereference('/apex/SubProject?id='+EncodingUtil.urlEncode(projectid,'UTF-8'));            
        }
        else if(plnId<>null){            
            PR = new Pagereference('/apex/ProjectDetails?id='+EncodingUtil.urlEncode(plnId,'UTF-8'));            
        }
        if(markId<>null){
            PR = new Pagereference('/apex/Marketingactivity?id='+EncodingUtil.urlEncode(markId,'UTF-8'));
        }		       
        return PR;        
    }
    Public Pagereference cancel2(){
        Pagereference PR;        
        if(projectid<>null){            
            PR = new Pagereference('/apex/SubProject_Resp?id='+EncodingUtil.urlEncode(projectid,'UTF-8'));            
        }
        else if(plnId<>null){            
            PR = new Pagereference('/apex/ProjectDetails_Resp?id='+EncodingUtil.urlEncode(plnId,'UTF-8'));            
        }
        if(markId<>null){
            PR = new Pagereference('/apex/Marketingactivity_Resp?id='+EncodingUtil.urlEncode(markId,'UTF-8'));
        }		       
        return PR;        
    }
    public String getRedirectToTemplate() {
        return null;
    }
    public Workspace__c templateInfo {get; set;}
    public Pagereference redirectToTemplate() {
        try{
            if(templateinfo !=null){
                insert templateInfo;
            }
        }catch(Exception e){
            
        }
        return null;
    }
}