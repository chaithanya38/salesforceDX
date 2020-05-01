/*****************************************************************
Class Name: costcenterdetailcls
Author:Chaithanya daggumati                   Last modified by:Chaithanya daggumati
Date :23/11/2015                   			  Date :23/11/2015                    
********©2013 Musqot marketing technology Pvt ltd *****************/
public with sharing class costcenterdetailcls {    
    public String workId {get; set;}
    Public string cosid;
    String tabInFocus;
    public Id ccid;
    public List<Members__c> cosmem ;
    public Costcentre__c coscenter{get;set;}
    Public List<Costcentre__c> CCList {get; set;}
    public Map<String, Allocation_amount__c > maps;
    private ApexPages.standardController controller;
    public List<Members__c> membs ;
    private Costcentre__c cost;
    private Costcentre__c ccentid;
    public list<task> taskrecs;
    public List<String>mmemId;
    public boolean Level1{get;set;}
    public boolean Level2{get;set;}
    public boolean Level3{get;set;}
    public boolean Level4{get;set;}
    public boolean Level5{get;set;}
    
    public costcenterdetailcls (ApexPages.StandardController controller) {
    workId= controller.getRecord().Id;
    this.controller = controller;
    this.cost = (Costcentre__c)controller.getRecord();
    cosid= ApexPages.currentPage().getParameters().get('id');
    tabInFocus = System.currentPageReference().getParameters().get('tab');
    string i=ApexPages.currentPage().getParameters().get('sfdc.override');
    membs=new List<Members__c>();
    try{
            coscenter = new Costcentre__c();
            coscenter=[SELECT Id, Name,Status__c,StatusImage__c,Headline__c,OwnerId ,Description__c 
                       FROM Costcentre__c 
                       WHERE Id=:cosid];           
        }catch(exception e){}
        MusqotUtility.innerClass musIncls = MusqotUtility.securitySetting(workId);
        Level1 = musIncls.l1;
        Level2 = musIncls.l2;
        Level3 = musIncls.l3;
        Level4 = musIncls.l4;
        Level5 = musIncls.l5;
        costcenteroverview();
    }
    /********************************************
     costcenteredit():redirect to  ccedit page
    *********************************************/  
    public PageReference costcenteredit() {
       String cosid= ApexPages.currentPage().getParameters().get('id');
        PageReference pgr;
        if(cosid!=null){
        pgr =new PageReference ('/apex/costcenteredit?cosid='+EncodingUtil.urlEncode(cosid,'UTF-8')+'&cosid='+EncodingUtil.urlEncode(workId,'UTF-8'));
        return pgr;
        }
        return null;
    }
    /********************************************
     costcenterSpace():redirected to costcentere
    *********************************************/  
    Public PageReference costcenteroverview(){        
        CCList =new  List<Costcentre__c>();
        CCList=[SELECT Id, Name,Description__c,Overveiw__c,Headline__c
                FROM Costcentre__c where id=:cosid limit 1];
        if(CCList.size()>0){
        PageReference WorkSpacPage=new PageReference('/apex/costcenteroverview?id='+CCList[0].id+'&cosid='+EncodingUtil.urlEncode(workId,'UTF-8'));
        WorkSpacPage.setredirect(true);
        return WorkSpacPage;
        }
        return null;
     }
    /********************************************
      workRedirect():create  costcenter__c record
    ********************************************/
    Public PageReference workRedirect(){ 
        if (Costcentre__c.sObjectType.getDescribe().isCreateable())
        {
            insert CCList;     
        } 
        return null;
        
    }
    /********************************************************************
     getgadgetHTMLContent():This is for display contant in rich text area.
    *********************************************************************/  
    public Component.Apex.OutputText getgadgetHTMLContent(){
        Component.Apex.OutputText oppText = new Component.Apex.OutputText(escape = false);
        if(CCList.size()>0){
           oppText.value = CCList[0].Overveiw__c;       //gadgetcontent is the variable which holds the HTML content
         }
        return oppText ;
    }
    /******************************* 
     newtask(): redirect to Task page
     ********************************/       
    Public PageReference newtask(){
        taskrecs= [Select Id, WhoId, WhatId, Subject,status, ActivityDate,CreatedById, Priority, OwnerId,owner.name, Description, IsDeleted, AccountId, IsClosed,  Allocated_h__c, Outcome_h__c, Task_description__c,Task_name__c, StatusImage__c 
                   FROM Task 
                   where id=:workId limit 400];
        PageReference task1=new PageReference('/apex/Task?cosid='+EncodingUtil.urlEncode(workid,'UTF-8'));
        task1.setredirect(true);
        return task1; 
    }
    /********************************************
     gettaskrecs():it returns list of task records
    *********************************************/   
    public List<Task> gettaskrecs(){
        return [Select Id, WhoId, WhatId, CreatedById, Subject,status, ActivityDate, Status_image_id__c,StatusImage__c, Priority, OwnerId,owner.name, Description, IsDeleted, AccountId, IsClosed,  Allocated_h__c, Outcome_h__c,Task_description__c,Task_name__c 
                FROM Task 
                where whatid=:cosid order by ActivityDate limit 400];
    }
    /********************************************
     gotoTaskEdit():redirect to TaskEditpage
    *********************************************/  
    public PageReference gotoTaskEdit() {
        String taskid= ApexPages.currentPage().getParameters().get('taskid');
        PageReference pgr; 
        if(taskId!=null){
        pgr =new PageReference ('/apex/TaskEditpage?taskId='+EncodingUtil.urlEncode(taskid,'UTF-8')+'&cosid='+EncodingUtil.urlEncode(cosid,'UTF-8'));
        return pgr;
        }
        return null;
    }
     /***************************************
     newmember():redirect  to memberobj page
     ***************************************/
     Public PageReference newmember(){
        PageReference memberobj=new PageReference('/apex/Costcentermember?cosid='+EncodingUtil.urlEncode(workid,'UTF-8'));
        memberobj.setredirect(true);
        return memberobj; 
     }
     /**********************************************
      getmembers():it returns list of member records
      **********************************************/    
     public List<Members__c > getmembers(){ 
        cosmem =new  List<Members__c>();
        mmemId=new List<String>();
        maps= new Map<String, Allocation_amount__c >();
        List<Allocation_amount__c> listrec=[Select Costcentre__r.Owner.Name,Costcentre__r.ownerid, Costcentre__r.name 
                                            from Allocation_amount__c 
                                            where Costcentre__c =:cosid limit 100];
        list<Members__c> tmpList=[Select id, ProjUsers__c, Cost_center__c
                                  FROM Members__c 
                                  WHERE ProjUsers__c =:coscenter.ownerId and Role__c='owner' limit 1];
        if(listrec.size()>0){
            for(Allocation_amount__c all:listrec){
                if(all.Costcentre__r.name<>null){
                	if(tmpList.size()>0){
                    	if(tmpList<>null){
                    		if(all.Costcentre__r.OwnerId<> tmpList[0].ProjUsers__c){
                        		if(!maps.containsKey(all.Costcentre__r.OwnerId)) 
                            maps.put(all.Costcentre__r.OwnerId,all);
                     		}
                    	}
                    }
                }
            } 
         }                           
        List<Allocation_amount__c> newList = maps.values();
        for(Allocation_amount__c newre:newList){
            mmemId.add(newre.Costcentre__r.OwnerId);
            
        }
        cosmem=[Select id, ProjMembers__c, ProjUsers__r.email, Cost_center__c,ProjUsers__c, ProjUsers__r.name, SubProjMembers__c, Role__c, Type__c, ProjUsers__r.smallphotourl 
                FROM Members__c 
                where Cost_center__c=:cosid and ProjUsers__c <>:mmemId and Role__c<>'owner' limit 100 ];
        list<Members__c>membrList=[Select id, ProjMembers__c, Cost_center__c,ProjUsers__r.email ,ProjUsers__c,ProjUsers__r.name, ProjUsers__r.smallphotourl , SubProjMembers__c, Role__c, Type__c 
                                   FROM Members__c 
                                   where Cost_center__c=:cosid and Role__c='owner' limit 1];
        membrList.addAll(cosmem);
        return membrList;        
    }
	/********************************************
     gotoMemberEdit():redirect to  Membereditpage
    *********************************************/    
    public PageReference gotoMemberEdit() {
        String mbrId = ApexPages.currentPage().getParameters().get('mbrId'); 
        PageReference pgr;
        if(mbrId<>null){       
            pgr =new PageReference ('/apex/Membereditpage?cosid='+EncodingUtil.urlEncode(cosid,'UTF-8')+'&mbrId='+EncodingUtil.urlEncode(mbrId,'UTF-8'));
            return pgr;
        }
        return null;
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
}