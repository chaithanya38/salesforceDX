/***************************************************************
Class Name: tasktablecontroller
Author: G Janardhanreddy        Last modified by:G Janardhanreddy 
Date  :  27/1/2015              Date:18/03/2015
 ********©2013 Musqot marketing technology Pvt ltd **************/
public with sharing class tasktablecontroller{
    public String planid{get;set;}
    public String subpid{get;set;}
    public String markid{get;set;}
    Public list<Task> Task{get;set;}
    Public list<Task> TaskByFilter{get;set;}
    public task tsk {get;set;}
    public String taskid{get;set;}
    public String regionValue{get;set;}    
    public List<SelectOption> regionOptions{get;set;}
    public string tabInFocus {get;set;}
    public String selectedTask{get;set;}
    public String newtaskpage{get;set;}
    public Boolean refreshPage{get;set;}
    public tasktablecontroller(ApexPages.StandardController controller){
         regionOptions= new List<SelectOption>();
         TaskByFilter = new List<Task>();
         regionOptions.add(new SelectOption('Today',Label.mtask_Today));
         regionOptions.add(new SelectOption('Overdue',Label.mtask_Overdue));      
         regionOptions.add(new SelectOption('Today+Overdue',Label.mtask_Today_Overdue));
         regionOptions.add(new SelectOption('Tomorrow',Label.mtask_Tomorrow));
         regionOptions.add(new SelectOption('Next 7 Days',Label.mtask_Next_7_Days));
         regionOptions.add(new SelectOption('Next 7 Days+Overdue',Label.mtask_Next_7_Days_Overdue));
         regionOptions.add(new SelectOption('This Month',Label.mtask_This_Month));
         regionOptions.add(new SelectOption('All Open',Label.mtask_All_Open));
         regionOptions.add(new SelectOption('Completed',Label.mtask_Completed));      
           
        taskid= ApexPages.currentPage().getParameters().get('taskid'); 
        try{
       /***Added What.Name and Owner.Name in the fields***/
        TaskByFilter =[Select Id, WhoId,who.firstname,who.lastname,WhatId,What.Name,CreatedById,Subject, 
                       CreatedBy.name,ActivityDate, Status,StatusImage__c, Priority, OwnerId,Owner.Name,
                       Description, IsDeleted, AccountId, IsClosed,  Allocated_h__c, 
                       Outcome_h__c,Task_description__c,Task_name__c  
                       FROM Task 
                       where OwnerId=:UserInfo.getUserId() AND IsClosed =:false AND ActivityDate =:system.toDay()];                                  
        }catch (exception e){}
        if(TaskByFilter .isEmpty())
        {
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'You have no open tasks scheduled for this period.'));
        }
        //--
        if(regionValue==null){
         regionValue='Today';
        }
        else
           regionValue=regionValue;
        
       
   }
   public void tasklist(){   
         if(regionValue=='Today'){
                 TaskByFilter = [Select Id, WhoId,who.firstname,who.lastname,WhatId,What.Name,CreatedById,
                                 CreatedBy.name,Subject, ActivityDate, Status,StatusImage__c, Priority, 
                                 OwnerId,Owner.Name, Description, IsDeleted, AccountId, IsClosed,  
                                 Allocated_h__c, Outcome_h__c,Task_description__c,Task_name__c
                                 FROM Task 
                                 where OwnerId=:UserInfo.getUserId() AND 
                                  IsClosed =:false AND ActivityDate =:system.toDay()];                 
                 if(TaskByFilter .isEmpty())
                    {
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'You have no open tasks scheduled for this period.'));
                    }
            }
            
        if(regionValue=='Overdue'){
                TaskByFilter = [Select Id, WhoId,who.firstname,who.lastname,WhatId,What.Name,CreatedById,Subject, ActivityDate,
                                Status,StatusImage__c, Priority, OwnerId,Owner.Name, Description, IsDeleted, AccountId, IsClosed,
                                CreatedBy.name, Allocated_h__c, Outcome_h__c,Task_description__c,Task_name__c  
                                FROM Task
                                where  OwnerId=:UserInfo.getUserId() AND IsClosed =:false AND ActivityDate <=:system.toDay()];
                if(TaskByFilter.isEmpty()){
              
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'You have no open tasks scheduled for this period.'));
                }
            }
       if(regionValue=='Today+Overdue'){
                 TaskByFilter = [Select Id, WhoId,who.firstname,who.lastname,WhatId,What.Name,CreatedById,
                                 Subject, ActivityDate, Status,StatusImage__c, Priority, OwnerId,Owner.Name, 
                                 Description, IsDeleted, AccountId, IsClosed,CreatedBy.name,  
                                 Allocated_h__c, Outcome_h__c,Task_description__c,Task_name__c  
                                 FROM Task 
                                 where OwnerId=:UserInfo.getUserId() AND IsClosed =:false AND
                                 ActivityDate <=:system.toDay()];
                if(TaskByFilter .isEmpty()){
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'You have no open tasks scheduled for this period.'));
                }
            }
            
        if(regionValue=='Tomorrow'){        
                   TaskByFilter = [Select Id, WhoId,who.firstname,who.lastname,WhatId,What.Name,CreatedById,Subject, ActivityDate, Status,StatusImage__c, Priority, OwnerId,Owner.Name, Description, IsDeleted, AccountId, IsClosed, CreatedBy.name, Allocated_h__c, Outcome_h__c,Task_description__c,Task_name__c  
                   FROM Task 
                   where OwnerId=:UserInfo.getUserId() AND IsClosed =:false AND ActivityDate =:system.toDay().addDays(1)];
                   if(TaskByFilter .isEmpty()) {
                   
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'You have no open tasks scheduled for this period.'));
                }
            }
            
      if(regionValue=='Next 7 Days'){
               TaskByFilter = [Select Id, WhoId,who.firstname,who.lastname,WhatId,What.Name,CreatedById,Subject,
                               ActivityDate, Status,StatusImage__c, Priority, OwnerId,Owner.Name, Description,
                               IsDeleted, AccountId, IsClosed, CreatedBy.name, Allocated_h__c, Outcome_h__c,
                               Task_description__c,Task_name__c  
                               FROM Task 
                               where OwnerId=:UserInfo.getUserId() AND IsClosed =:false AND ActivityDate >=:system.toDay() AND ActivityDate<:system.toDay().addDays(7)];
               if(TaskByFilter .isEmpty())
                {
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'You have no open tasks scheduled for this period.'));
                }
            }
            
       if(regionValue=='Next 7 Days+Overdue'){
                    TaskByFilter = [Select Id, WhoId,who.firstname,who.lastname,WhatId,What.Name,CreatedById,Subject, ActivityDate, Status,StatusImage__c, Priority, OwnerId,Owner.Name, Description, IsDeleted, AccountId,  CreatedBy.name,IsClosed,  Allocated_h__c, Outcome_h__c,Task_description__c,Task_name__c  
                    FROM Task
                    where  OwnerId=:UserInfo.getUserId() AND IsClosed =:false AND (ActivityDate =:system.toDay().addDays(6) OR ActivityDate <=:system.toDay())];
                 if(TaskByFilter .isEmpty())
                {
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'You have no open tasks scheduled for this period.'));
                }
            }
       if(regionValue=='This Month'){
                    TaskByFilter = [Select Id, WhoId,who.firstname,who.lastname,WhatId,What.Name,CreatedById,Subject, ActivityDate, Status,StatusImage__c, Priority, OwnerId,Owner.Name, Description, IsDeleted,CreatedBy.name, AccountId, IsClosed,  Allocated_h__c, Outcome_h__c,Task_description__c,Task_name__c  
                    FROM Task 
                    where OwnerId=:UserInfo.getUserId() AND IsClosed =:false AND  ActivityDate =THIS_MONTH];                 
                 if(TaskByFilter .isEmpty())
                {
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'You have no open tasks scheduled for this period.'));
                }
            }
       if(regionValue=='All Open'){
                   TaskByFilter = [Select Id, WhoId,who.firstname,who.lastname,WhatId,What.Name,CreatedById,Subject, ActivityDate, Status,StatusImage__c, Priority, OwnerId,Owner.Name, Description, CreatedBy.name,IsDeleted, AccountId, IsClosed,  Allocated_h__c, Outcome_h__c,Task_description__c,Task_name__c  
                   FROM Task 
                   where (OwnerId=:UserInfo.getUserId() AND  IsClosed =:false)] ;
                   
                 if(TaskByFilter .isEmpty())
                {
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'You have no open tasks scheduled for this period.'));
                }
            }
       if(regionValue=='Completed'){
                   TaskByFilter = [Select Id, WhoId,who.firstname,who.lastname,WhatId,What.Name,CreatedById,Subject, ActivityDate, Status,StatusImage__c, Priority, OwnerId,Owner.Name, Description, CreatedBy.name,IsDeleted, AccountId, IsClosed,  Allocated_h__c, Outcome_h__c,Task_description__c,Task_name__c  
                   FROM Task 
                   where (OwnerId=:UserInfo.getUserId() AND  IsClosed =:true) LIMIT 49 OFFSET 0] ;
                   
                 if(TaskByFilter .isEmpty())
                {
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'You have no open tasks scheduled for this period.'));
                }
            }
    }
    public pagereference gotoTaskEdit(){   // record edit mode 
        
        string pageEnding = 'TaskEditpage' ;
        if(ApexPages.currentPage().getParameters().get('pageending')<> null){
            pageEnding = 'TaskEditpage' + ApexPages.currentPage().getParameters().get('pageending');} 
        string taskid = ApexPages.currentPage().getParameters().get('taskid');        
        List<Task> tasks = [SELECT Id, WhatId FROM Task WHERE Id = :taskid];
        
        if(!tasks.isEmpty()){
        Task tsk = tasks[0];
        Id tskId = tsk.WhatId ;
        
        String fromObj = tskId.getSObjectType().getDescribe().getLocalName();
        String url;
        if(fromObj == 'Project__c'){      //plan
            url= '/apex/'+EncodingUtil.urlEncode(pageEnding,'UTF-8')+'?taskId='+EncodingUtil.urlEncode(tsk.Id,'UTF-8')+'&planid='+EncodingUtil.urlEncode(tsk.WhatId,'UTF-8') + '&fromHome=true';
        }
        else if(fromObj == 'Subproject__c'){   //project
            url= '/apex/'+EncodingUtil.urlEncode(pageEnding,'UTF-8')+'?taskId='+EncodingUtil.urlEncode(tsk.Id,'UTF-8')+'&subpid='+EncodingUtil.urlEncode(tsk.WhatId,'UTF-8')+ '&fromHome=true';
        }
        else if(fromObj == 'Marketing_activity__c'){
            url= '/apex/'+EncodingUtil.urlEncode(pageEnding,'UTF-8')+'?taskId='+EncodingUtil.urlEncode(tsk.Id ,'UTF-8')+'&markid='+EncodingUtil.urlEncode(tsk.WhatId ,'UTF-8')+ '&fromHome=true';
        }
        else if(fromObj=='Account')
        { 
            PageReference newPage = New PageReference('/'+ taskid);
            newPage.setRedirect(true);
            return newPage;
            
        }
        if(!String.ISBLANK(url)){              
            pageReference nxtPg = new pageReference(url);
            nxtPg.setRedirect(true); 
            return nxtPg;
        }
        else{
            return null;
        }
        
        }
        else{
        return null;
        }
    }
    public pageReference gotoeditmode(){// record input mode
        string taskid = ApexPages.currentPage().getParameters().get('taskid');        
        List<Task> tasks = [SELECT Id, WhatId FROM Task WHERE Id = :taskid];
        Task tsk = tasks[0];
        Id tskId = tsk.WhatId ;
        String fromObj = tskId.getSObjectType().getDescribe().getLocalName();
        String url;
         string pageEnding = 'TaskEditpage' ;
        if(ApexPages.currentPage().getParameters().get('pageending')<> null){
            pageEnding = 'TaskEditpage' + ApexPages.currentPage().getParameters().get('pageending');} 
        
        if(fromObj == 'Project__c'){
        url= '/apex/'+ EncodingUtil.urlEncode(pageEnding, 'UTF-8') +'?taskId='+EncodingUtil.urlEncode(tsk.Id, 'UTF-8')+'&planid='+EncodingUtil.urlEncode(tsk.WhatId,'UTF-8')+'&fromHome=false';   
        }
        else if(fromObj == 'Subproject__c'){
            url= '/apex/'+ EncodingUtil.urlEncode(pageEnding, 'UTF-8') +'?taskId='+EncodingUtil.urlEncode(tsk.Id,'UTF-8')+'&subpid='+EncodingUtil.urlEncode(tsk.WhatId,'UTF-8')+ '&fromHome=false';
        }
        else if(fromObj == 'Marketing_activity__c'){
            url= '/apex/'+ EncodingUtil.urlEncode(pageEnding, 'UTF-8') +'?taskId='+EncodingUtil.urlEncode(tsk.Id ,'UTF-8')+'&markid='+EncodingUtil.urlEncode(tsk.WhatId ,'UTF-8')+ '&fromHome=false';
        }
        else if(fromObj=='Account')
        {    
        url='/'+taskid +'/e?close=1&retURL=%2Fhome%2Fhome.jsp';
               }
        if(!String.ISBLANK(url)){              
        pageReference nxtPg = new pageReference(url);
        nxtPg.setRedirect(true); 
        return nxtPg;
        }
        else{
        return null;
        }    
    }
    public PageReference gotoParent(){
        refreshPage = true;
        return null;
    }
}