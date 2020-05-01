/*******************************************************
Class Name: taskEditController
Author:Nagaraju G            Last modified by:Nagaraju G
Date: 16/9/2014              Date:18/03/2015
********©2013 Musqot marketing technology Pvt ltd ******/
public with sharing class taskEditController {
    public String planid{get;set;}
    public String subpid{get;set;}
    public String taskid{get;set;}
    public String mrkId{get;set;}
    public String cosid{get;set;}
    public string mtaskId {get; set;}
    public String attsid{get;set;}
    public String contentType {get; set;}
    public String fileName {get; set;}
    Public task tsk{get;set;}
    public boolean chekE{get;set;}
    public boolean RenderTaskDocumentSection{get;set;}
    public boolean showRec{get;set;}
    public boolean showEdt{get;set;}
    public boolean showEdtbtn{get;set;}
    public boolean showDetail{get;set;}
    public boolean editDetail{get;set;}
    public boolean showdel{get;set;}
    public musqot__Project__c objPrjct {get;set;}
    public musqot__Subproject__c sub{get;set;}
    public task templateInfo {get; set;}
    public transient List<Attachment> atts{get;set;}
    transient Attachment att{get;set;}
    private Attachment atsid; 
    public String fileType {get;set;}
    public list<task> taks {get;set;}
    public boolean isPlanCreatedUser {get;set;}
    public boolean isPlanOwner{get;set;}
    public boolean isTaskAssignedtoUser {get;set;}
    public boolean isTaskCreatedUser {get;set;}
    public boolean issubprojectCreateduser {get;set;}
    public boolean issubowner{get;set;}
    public boolean ismarkowner{get;set;}
    public boolean ismarketingCreateduser {get;set;}
    public musqot__Project__c plaOwner {get;set;}
    public musqot__Subproject__c subOwner{get;set;}
    public musqot__Marketing_activity__c  mrkOwner{get;set;}
    public Project__c prjct = new Project__c ();
    public Subproject__c sprjct = new Subproject__c ();
    public Marketing_activity__c markact = new Marketing_activity__c();
    public Costcentre__c cosen = new Costcentre__c();
    public String fromHomePage;
    public boolean fromHome;
    public String ganttdetailId;
    public String mainGantt;
    public string pageending;
    public taskEditController (ApexPages.StandardController controller){
        isPlanCreatedUser = false;
        isTaskAssignedtoUser = false;
        isTaskCreatedUser = false;
        issubprojectCreateduser=false;
        ismarketingCreateduser =false;
        issubowner=false;
        ismarkowner=false;
        isPlanOwner=false;
        showDetail=true;
        editDetail=false;
        tsk = (Task)Controller.getRecord();
        this.attachment= new Attachment();       
        planid= ApexPages.currentPage().getParameters().get('planid'); 
        subpid= ApexPages.currentPage().getParameters().get('subpid');       
        mrkId= ApexPages.currentPage().getParameters().get('markid'); 
        cosid = ApexPages.currentPage().getParameters().get('cosid');
        ganttdetailId = ApexPages.currentPage().getParameters().get('ganttid');
        mainGantt = ApexPages.currentPage().getParameters().get('maingantt');
        taskid= ApexPages.currentPage().getParameters().get('taskid');        
        attsid=ApexPages.currentPage().getParameters().get('attsid');
        fromHomePage=ApexPages.currentPage().getParameters().get('fromHome');
        pageending='';
        if(ApexPages.currentPage().getParameters().get('pageending')<>null){
            pageending=ApexPages.currentPage().getParameters().get('pageending');
        }
        if(fromHomePage<>null){
            fromHome=fromHomePage.contains('true');
        }
        try{
            tsk=[select id,task_name__c,LastModifiedById,CreatedById,musqot__Task_description__c,
                 OwnerId,ActivityDate,Status,musqot__Status_image_id__c,StatusImage__c,Subject,
                 Priority,WhatId,Description ,Allocated_h__c, Outcome_h__c 
                 from task  
                 where id=:taskid limit 1];
            mTaskId = tsk.WhatId;
            
        }catch(exception e){} 
        if(mTaskId!=null||test.isrunningtest()){
            try{
                musqot__Subproject__c subOwner=[SELECT id,OwnerId,musqot__Starts_date__c,musqot__Ends_date__c From musqot__Subproject__c where id=:mTaskId limit 1];
                if(subOwner.OwnerId!=null){
                    if(Userinfo.getUserId()==subOwner.OwnerId ){
                        issubowner=true;
                    }
                }
            }catch(exception e){} 
            try{
                musqot__Marketing_activity__c mrkOwner=[SELECT id,OwnerId,musqot__Starts_date__c,musqot__Ends_date__c From musqot__Marketing_activity__c where id=:mTaskId limit 1];
                if(mrkOwner.OwnerId!=null){
                    if(Userinfo.getUserId()==mrkOwner.OwnerId ){
                        ismarkowner=true;
                    }
                }
            }catch(exception e){}  
            try{
                musqot__Project__c plaOwner=[SELECT id,OwnerId,musqot__Starts_date__c,musqot__Ends_date__c From musqot__Project__c where id=:mTaskId limit 1];
                if(plaOwner.OwnerId!=null){
                    if(Userinfo.getUserId()==plaOwner.OwnerId){
                        isPlanOwner=true;
                    }
                }
            }catch(exception e){}   
        }
        
        if(tsk!=null){
            if(Userinfo.getUserId() == tsk.OwnerID ){
                isTaskAssignedtoUser = true;
                showRec=false;
                showEdt=true;
                showEdtbtn=true;
                showDetail=true;
                editDetail=false;
            }
            if(Userinfo.getUserId() == tsk.CreatedByID|| isPlanOwner == true || issubowner == true|| ismarkowner == true){
                isTaskCreatedUser = true;
                showRec=false;
                showEdt=true;
                showEdtbtn=true;
                editDetail=true;
                showDetail=false;
            }
        }
        
        try{
            musqot__project__c objPrjct = [select id,LastModifiedById,CreatedById,OwnerId from musqot__project__c where id=:planid limit 1];
            musqot__Subproject__c objsub=[select id,name,musqot__Starts_date__c,musqot__Ends_date__c,LastModifiedById,CreatedById,OwnerId from musqot__Subproject__c where id=:subpid  limit 1] ;   
            musqot__Marketing_activity__c mrk=[select id,owner.name,name,musqot__Starts_date__c,musqot__Ends_date__c,musqot__Project__c,LastModifiedById,CreatedById,OwnerId  from musqot__Marketing_activity__c where id=:mrkId limit 1];        
            if(objPrjct != null||test.isrunningtest()){
                if(Userinfo.getUserId() == objPrjct.CreatedById ||Userinfo.getUserId()==objPrjct.OwnerId  ){
                    isPlanCreatedUser = true;
                    showRec=false;
                    showEdt=true;
                    showEdtbtn=false;
                    editDetail=true;
                    showDetail=false;
                }
                
            }else if(objsub!=null){
                if(Userinfo.getUserId() == objsub.CreatedById ||Userinfo.getUserId()==objsub.OwnerId ){
                    issubprojectCreateduser = true;
                    showRec=false;
                    showEdt=true;
                    showEdtbtn=true;
                    editDetail=true;
                    showDetail=false;
                }
            }   
            else if(mrk!=null){
                if(Userinfo.getUserId() == mrk.CreatedById ||Userinfo.getUserId()==mrk.OwnerId   ){
                    ismarketingCreateduser = true;
                    showRec=false;
                    showEdt=true;
                    showEdtbtn=true;
                    editDetail=true;
                    showDetail=false;
                }  
            }
            
        }catch(exception e){}
        string mainStr = ApexPages.CurrentPage().getParameters().get('retURL');
        
        list<Project__c> tplans=[select id,name,musqot__Starts_date__c,musqot__Ends_date__c,OwnerId,CreatedBy.name from Project__c where id=:planid limit 1];
        list<musqot__Subproject__c> tsub=[select id,name,musqot__Starts_date__c,musqot__Ends_date__c, ownerid,musqot__planid__c,Parent_project__c from musqot__Subproject__c where id=:subpid and Parent_project__c =:planid limit 1];
        list<musqot__Marketing_activity__c> tmrk=[select id,owner.name,name,LastModifiedById,CreatedById,OwnerId,musqot__Project__c,musqot__Plan__c  from musqot__Marketing_activity__c where id=:mrkId and musqot__Plan__c=:planid and musqot__Project__c=:subpid limit 1];
        atts = [SELECT id,Name,description,parent.id,CreatedBy.name,createdbyid,parent.name, parent.type,Body,BodyLength,contentType from Attachment where Parent.id =:Taskid ];
        showRec=true;
        showEdt=false;
        
        //    if(isPlanCreatedUser|| isTaskCreatedUser ||isTaskAssignedtoUser||issubprojectCreateduser||ismarketingCreateduser){
        //        showEdtbtn=true;
        //    }
        
        try{
            if(Userinfo.getUserId()==tmrk[0].OwnerId||Userinfo.getUserId()==tplans[0].OwnerId||Userinfo.getUserId()==tsub[0].OwnerId){
                isPlanCreatedUser=true;
                isTaskCreatedUser =true;
                issubprojectCreateduser=true;
                ismarketingCreateduser=true;
                isPlanOwner=true;
                issubowner=true;
                ismarkowner=true;
                showRec=true;
                showEdt=false;
                showEdtbtn=true;
                editDetail=true;
                showDetail=false;
            }
        }catch(exception e){}  
        if(isPlanCreatedUser||isTaskCreatedUser||issubowner || isPlanOwner||ismarkowner||issubprojectCreateduser||ismarketingCreateduser){
            editDetail=true;
        }
        
        else {
            editDetail=false;
        }
        
        if(atts.isEmpty() == false){
            RenderTaskDocumentSection=true;
        }
        else{
            RenderTaskDocumentSection=false;
        }
        
        taks=[select id,task_name__c, Status_image_id__c,StatusImage__c,LastModifiedById,CreatedById, Task_description__c,OwnerId,ActivityDate,Status,Subject,Priority,WhatId,Description 
              from task 
              where id=:taskid];
        try{
            if(fromHome==false){
                gotoInputMode();
            }
        }catch(exception e){}        
        if(mrkId<>null){        
        markact = [select Id,Owner.Id ,Starts_date__c, Ends_date__c 
                   from Marketing_activity__c 
                   where Id =:mrkId];
        }
        else if(subpid<>null){        
        sprjct = [select Id, Owner.Id, Starts_date__c, Ends_date__c 
                  from Subproject__c 
                  where Id =:subpid];
       }
       else if(planid<>null){       
        prjct = [select Id, Owner.Id, Starts_date__c, Ends_date__c 
                 from Project__c  
                 where Id =:planid];
        }
      else if(cosid<>null){       
        cosen = [select Id, Owner.Id,Name 
                 from Costcentre__c  
                 where Id =:cosid];
        }
    }
    /*************************************************************
	save():update  task record and redirect to  related to parent page
	**************************************************************/
    Public PageReference Save(){
        if(mrkId<>null){                        
            /*   if(tsk.ActivityDate>markact.Ends_date__c || tsk.ActivityDate<markact.Starts_date__c){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Duedate with in the span of marketning activity startdate and enddate'));
            return null;
            
            }   
            
            else 
            */
            if (Task.sObjectType.getDescribe().isUpdateable())            
            {            
                if((tsk.Outcome_h__c >0||tsk.Description!=null)&&tsk.Status=='Not started')
                {
                    tsk.Status='In Progress';
                }               
                update tsk;
                Map<String,StaticResource> stMap = new Map<String,StaticResource>();
                List<StaticResource> strList = [select Id, Name from StaticResource Limit 1000];                                      
            
            for(StaticResource str : strList){       
                stMap.put(str.Name,str);
            } 
            
            Task tsks= [select id,Status from Task  where id=:tsk.id limit 1];      
            String ts = tsks.Status;
            if(ts<>null){
                if(stMap.containskey((ts).trim())){ 
                    tsks.Status_Image_Id__c = stMap.get(ts).Id;                 
                }
                update tsks;
            }             
        }
     }
     else if(subpid<>null){
          /*commented by chaithanya on 18th dec'15-----start
         if(tsk.ActivityDate>sprjct.Ends_date__c || tsk.ActivityDate<sprjct.Starts_date__c){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Duedate with in the span of subproject startdate and enddate'));
                return null;
            }
         commented by chaithanya -----end*/
       //else 
           if (Task.sObjectType.getDescribe().isUpdateable())            
        {            
            if((tsk.Outcome_h__c >0||tsk.Description!=null)&&tsk.Status=='Not started')
            {
                tsk.Status='In Progress';
            }               
            update tsk;
            Map<String,StaticResource>resMap = new Map<String,StaticResource>();
            List<StaticResource>resList = [select Id,Name from StaticResource Limit 1000];
            
            for(StaticResource s: resList){       
                resMap.put(s.Name,s);
            } 
            
            Task tsks= [select id,Status from Task where id=:tsk.id limit 1];
            String ts = tsks.Status;
            if(ts<>null){
                if(resMap.containskey((ts).trim())){ 
                    tsks.Status_Image_Id__c = resMap.get(ts).Id;                 
                }
                update tsks;
            }             
        }
     }
    else if(planid<>null){
         /*commented by chaithanya on 18th dec'15-----start
         if(tsk.ActivityDate>prjct.Ends_date__c || tsk.ActivityDate<prjct.Starts_date__c){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Duedate with in the span of plan startdate and enddate'));
                return null;
            }
		commented by chaithanya -----end*/
       //else 
		if (Task.sObjectType.getDescribe().isUpdateable())            
        	{            
            if((tsk.Outcome_h__c >0||tsk.Description!=null)&&tsk.Status=='Not started')
            {
                tsk.Status='In Progress';
            }               
            update tsk;
            Map<String,StaticResource> stMap = new Map<String,StaticResource>();
            List<StaticResource> strList = [select Id,Name from StaticResource Limit 1000];
            
            for(StaticResource str : strList){       
                stMap.put(str.Name,str);
            } 
            
            Task tsks= [select id,Status from Task where id=:tsk.id limit 1];
            String ts = tsks.Status;
            if(ts<>null){
                if(stMap.containskey((ts).trim())){ 
                    tsks.Status_Image_Id__c = stMap.get(ts).Id;                 
                }
                update tsks;
            }             
        }
     }
   else if(cosid<>null){
       if (Task.sObjectType.getDescribe().isUpdateable()){           
       }
        update tsk;
   }
        
        //Attachment Code
        attachment.Ownerid = tsk.ownerid;
        attachment.ParentId = tsk.Id; // the record the file is attached to        
        attachment.ContentType=ContentType;
        attachment.name = fileName;
        if(attachment.body<>null){
            if (Schema.sObjectType.Attachment.fields.body.isCreateable()){
                insert attachment;   
            }                
        }
        Pagereference PR;
        if(!String.isBlank(fromHomePage)){
            string pageRef;
            if(pageending.contains('esp')) {
                pageRef='/apex/Musqottask_Resp';
            }
            else {
                pageRef='/home/home.jsp';
            }
            pr=new Pagereference (pageRef);
        }
        else{                   
            if(ganttdetailId <> null){                
                string pageRef='/apex/GanttDetailPage'+EncodingUtil.urlEncode(pageending,'UTF-8')+'?id='+EncodingUtil.urlEncode(ganttdetailId,'UTF-8');
                pr=new Pagereference (pageRef);
            }else if(mainGantt <> null){                
                string pageRef='/apex/GanttPage';
                pr=new Pagereference (pageRef);
            }else if(mrkId<>null){
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/Marketingactivity'+EncodingUtil.urlEncode(pageending,'UTF-8')+'?id='+EncodingUtil.urlEncode(mrkId,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb3','UTF-8');
                pr=new Pagereference (pageRef);
                // PR = new Pagereference('/apex/Marketingactivity'+EncodingUtil.urlEncode(pageending,'UTF-8')+'?id='+EncodingUtil.urlEncode(mrkId,'UTF-8'));
            }
            else if(subpid<>null){
                
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/SubProject'+EncodingUtil.urlEncode(pageending,'UTF-8')+'?id='+EncodingUtil.urlEncode(subpid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb3','UTF-8');
                pr=new Pagereference (pageRef);
                // PR = new Pagereference('/apex/SubProject'+EncodingUtil.urlEncode(pageending,'UTF-8')+'?id='+EncodingUtil.urlEncode(subpid,'UTF-8'));
            }
            else if(planid<>null){
                
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/ProjectDetails'+EncodingUtil.urlEncode(pageending,'UTF-8')+'?id='+EncodingUtil.urlEncode(planid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb3','UTF-8');
                pr=new Pagereference (pageRef);
                
            }
            else if(cosid<>null){                
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/Costcenterdetail'+EncodingUtil.urlEncode(pageending,'UTF-8')+'?id='+EncodingUtil.urlEncode(cosid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb3','UTF-8');
                pr=new Pagereference (pageRef);
				system.debug('####'+pr);                
            }
            else if(mtaskId<>null){
                
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/ProjectDetails'+EncodingUtil.urlEncode(pageending,'UTF-8')+'?id='+EncodingUtil.urlEncode(mtaskId,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb3','UTF-8');
                pr=new Pagereference (pageRef);            
            }   
        }     
        return pr;        
    }
    public Attachment attachment {
        get {
            if (attachment == null)
                attachment = new Attachment();
            return attachment;
        }
        set;
    }  
    
    Public void gotoEditMode(){ //show record edit mode
        RenderTaskDocumentSection=true;     
        showRec=false;
        showEdt=true;
        showEdtbtn=false;  
        if(mtaskId<>null){
            showEdtbtn =false;    
        }      
    }
    
    Public void gotoInputMode(){ // show record edit mode through homw page
        showRec=false;
        showEdt=true;
        showEdtbtn=false;
        tsk.Status='Completed';
        
    } 
    Public PageReference gotoInfoMode(){//show record Detail mode
        List<Attachment> atts=new List<Attachment>();
        if(atts.isEmpty() == false){
            RenderTaskDocumentSection=true;
        }else{
            RenderTaskDocumentSection=false;
        }
        
        showRec=true;
        showEdt=false;
        Pagereference pr;
        
        if(!String.isBlank(fromHomePage)){
            string pageRef;
            if(pageending.contains('esp')) {
                pageRef='/apex/Musqottask_Resp';
            }
            else {
                pageRef='/home/home.jsp';
            }
            pr=new Pagereference (pageRef);
        }
        else{
            if(ganttdetailId <> null){                
                string pageRef='/apex/GanttDetailPage'+EncodingUtil.urlEncode(pageending,'UTF-8')+'?id='+EncodingUtil.urlEncode(ganttdetailId,'UTF-8');
                pr=new Pagereference (pageRef);
            }else if(mainGantt <> null){                
                string pageRef='/apex/GanttPage';
                pr=new Pagereference (pageRef);
            }else if(planid<>null){
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/ProjectDetails'+EncodingUtil.urlEncode(pageending,'UTF-8')+'?id='+EncodingUtil.urlEncode(planid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb3','UTF-8');
                pr=new Pagereference (pageRef);
            }
            else if(subpid<>null){
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/SubProject'+EncodingUtil.urlEncode(pageending,'UTF-8')+'?id='+EncodingUtil.urlEncode(subpid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb3','UTF-8');
                pr=new Pagereference (pageRef);
            }
            else if(mrkId<>null){
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/Marketingactivity'+EncodingUtil.urlEncode(pageending,'UTF-8')+'?id='+EncodingUtil.urlEncode(mrkId,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb3','UTF-8');
                pr=new Pagereference (pageRef);                
            }
            else if(cosid<>null){                
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/Costcenterdetail'+EncodingUtil.urlEncode(pageending,'UTF-8')+'?id='+EncodingUtil.urlEncode(cosid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb3','UTF-8');                
                pr=new Pagereference (pageRef);                
            }
        }
        return pr;
    } 
    /*********************************************
gotoeditpage(): redirect to attachmenteditpage
***********************************************/
    public PageReference gotoeditpage() {
        String mrbid= ApexPages.currentPage().getParameters().get('attsid');
        PageReference pgr;
        if(planid<>null){       
            if(!String.isBlank(fromHomePage)){
                pgr =new PageReference ('/apex/attachmenteditpage'+EncodingUtil.urlEncode(pageending,'UTF-8')+'?planid='+EncodingUtil.urlEncode(planid,'UTF-8')+'&taskid='+EncodingUtil.urlEncode(taskid,'UTF-8')+'&attsid='+EncodingUtil.urlEncode(attsid,'UTF-8') + '&fromHome=true');
            }
            else{
                pgr =new PageReference ('/apex/attachmenteditpage'+EncodingUtil.urlEncode(pageending,'UTF-8')+'?planid='+EncodingUtil.urlEncode(planid,'UTF-8')+'&taskid='+EncodingUtil.urlEncode(taskid,'UTF-8')+'&attsid='+EncodingUtil.urlEncode(attsid,'UTF-8'));
            }
            return pgr;
        }
        else  if(subpid<>null){       
            if(!String.isBlank(fromHomePage)){
                pgr =new PageReference ('/apex/attachmenteditpage'+EncodingUtil.urlEncode(pageending,'UTF-8')+'?subpid='+EncodingUtil.urlEncode(subpid,'UTF-8')+'&taskid='+EncodingUtil.urlEncode(taskid,'UTF-8')+'&attsid='+EncodingUtil.urlEncode(attsid,'UTF-8')+ '&fromHome=true');            }
            else{
                pgr =new PageReference ('/apex/attachmenteditpage'+EncodingUtil.urlEncode(pageending,'UTF-8')+'?subpid='+EncodingUtil.urlEncode(subpid,'UTF-8')+'&taskid='+EncodingUtil.urlEncode(taskid,'UTF-8')+'&attsid='+EncodingUtil.urlEncode(attsid,'UTF-8'));
                
            }
            return pgr;
        }
        else if(mrkId<>null){       
            if(!String.isBlank(fromHomePage)){
                pgr =new PageReference ('/apex/attachmenteditpage'+EncodingUtil.urlEncode(pageending,'UTF-8')+'?markId='+EncodingUtil.urlEncode(mrkId,'UTF-8')+'&taskid='+EncodingUtil.urlEncode(taskid,'UTF-8')+'&attsid='+EncodingUtil.urlEncode(attsid,'UTF-8')+ '&fromHome=true');
            }
            else{
                pgr =new PageReference ('/apex/attachmenteditpage'+EncodingUtil.urlEncode(pageending,'UTF-8')+'?markId='+EncodingUtil.urlEncode(mrkId,'UTF-8')+'&taskid='+EncodingUtil.urlEncode(taskid,'UTF-8')+'&attsid='+EncodingUtil.urlEncode(attsid,'UTF-8'));
            }
            return pgr;
        }
        return null;
    }
    
    Public Pagereference cancel(){ //redirect to related parent page
        Pagereference pr;
        if(!String.isBlank(fromHomePage)){
            string pageRef;
            if(pageending.contains('esp')) {
                pageRef='/apex/Musqottask_Resp';
            }
            else {
                pageRef='/home/home.jsp';
            }
            pr=new Pagereference (pageRef);
        }
        else{
            
            if(ganttdetailId <> null){                
                string pageRef='/apex/GanttDetailPage'+EncodingUtil.urlEncode(pageending,'UTF-8')+'?id='+EncodingUtil.urlEncode(ganttdetailId,'UTF-8');
                pr=new Pagereference (pageRef);
            }else if(mainGantt <> null){                
                string pageRef='/apex/GanttPage';
                pr=new Pagereference (pageRef);
            }else if(planid<>null){
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/ProjectDetails'+EncodingUtil.urlEncode(pageending,'UTF-8')+'?id='+EncodingUtil.urlEncode(planid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb3','UTF-8');
                pr=new Pagereference (pageRef);
            }
            else if(subpid<>null){
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/SubProject'+EncodingUtil.urlEncode(pageending,'UTF-8')+'?id='+EncodingUtil.urlEncode(subpid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb3','UTF-8');
                pr=new Pagereference (pageRef);
            }
            else if(mrkId<>null){
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/Marketingactivity'+EncodingUtil.urlEncode(pageending,'UTF-8')+'?id='+EncodingUtil.urlEncode(mrkId,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb3','UTF-8');
                pr=new Pagereference (pageRef);            
            }
            else if(cosid<>null){                
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/Costcenterdetail'+EncodingUtil.urlEncode(pageending,'UTF-8')+'?id='+EncodingUtil.urlEncode(cosid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb3','UTF-8');
                pr=new Pagereference (pageRef);                
            }
            else if(mtaskId <> null){
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/ProjectDetails'+EncodingUtil.urlEncode(pageending,'UTF-8')+'?id='+EncodingUtil.urlEncode(mtaskId,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb3','UTF-8');
                pr=new Pagereference (pageRef);
            }            
        }
        return pr;
    } 
    public void DeleteAttchment(){//Delete Attachments
        string atid;
        atid= ApexPages.currentPage().getParameters().get('atsid');
        Attachment ats=new Attachment(id=atid);
        
        if (Schema.sObjectType.Attachment.isDeletable())
            
        {
            delete ats;
        }
    }
    
    public String getRedirectToTemplate() {
        return null;
    }
    
    public Pagereference redirectToTemplate() {
        try{
            insert templateInfo;
        }catch(Exception e){
            ApexPages.addMessages(e);
        }
        return null;
    }
    /**********************************************************
WrapperClass:This Class will show attachamnet type and size
***********************************************************/
    public class WrapperClass{
        public Id Id {get;set;}
        public string Description {get;set;}
        public string Name {get;set;}
        public String Size {get;set;}
        public String contentType {get;set;}
        public string ownerid{get;set;}
        public string CreatedBy{get;set;}
        public String fileType {get;set;}
        public Datetime LastModifiedDate {get;set;}
        public boolean isVisible {get; set;}
    }
    
    public List<WrapperClass> getListWrapper{
        get{
            List<WrapperClass> lstW=new List<WrapperClass>();
            taskid= ApexPages.currentPage().getParameters().get('taskid');
            atts=[SELECT id,LastModifiedDate,Owner.name,LastModifiedById,CreatedById,CreatedBy.name,Name,description,parent.id, parent.name, parent.type,Body,BodyLength,contentType from Attachment where Parent.id =:Taskid ];
            WrapperClass wc=null;
            Decimal kb;
            for(Attachment att : atts){
                wc=new WrapperClass();
                if(Userinfo.getUserId() == att.CreatedById){
                    wc.isvisible = true;
                }
                else{
                    wc.isvisible = FALSE;
                }
                wc.Id=att.Id;
                wc.OwnerId=att.owner.name;
                if(att.Name.containsAny('.'))
              		wc.name=att.Name.substring(0,att.Name.indexOf('.'));
                else 
                	wc.name=att.Name;
                wc.Description=att.description;
                wc.CreatedBy = att.createdby.name;
                wc.contentType = att.contentType;
                wc.lastModifiedDate = att.LastModifiedDate.date();
                if(att.contentType == 'application/msword'){wc.fileType = '.doc';} 
                else if(att.contentType == 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'){wc.fileType = '.docx';}  
                else if(att.contentType == 'text/calendar'){wc.fileType = '.ics';} 
                else if(att.contentType == 'application/x-indesign'){wc.fileType = '.indd';} 
                else if(att.contentType == 'application/vnd.oasis.opendocument.database'){wc.fileType = '.odb';} 
                else if(att.contentType == 'application/vnd.oasis.opendocument.chart'){wc.fileType = '.odc';} 
                else if(att.contentType == 'application/vnd.oasis.opendocument.formula'){wc.fileType = '.odf';} 
                else if(att.contentType == 'application/vnd.oasis.opendocument.graphics'){wc.fileType = '.odg';} 
                else if(att.contentType == 'application/vnd.oasis.opendocument.image'){wc.fileType = '.odi';} 
                else if(att.contentType == 'application/vnd.oasis.opendocument.presentation'){wc.fileType = '.odp';} 
                else if(att.contentType == 'application/vnd.oasis.opendocument.spreadsheet'){wc.fileType = '.ods';}        
                else if(att.contentType == 'application/vnd.oasis.opendocument.text'){wc.fileType = '.odt';} 
                else if(att.contentType == 'application/pdf'){wc.fileType = 'PDF';} 
                else if(att.contentType == 'application/vnd.openxmlformats-officedocument.presentationml.slideshow'){wc.fileType = '.ppsx';} 
                else if(att.contentType == 'application/vnd.ms-powerpoint'){wc.fileType = '.ppt';}      
                else if(att.contentType == 'application/vnd.openxmlformats-officedocument.presentationml.presentation'){wc.fileType = '.pptx';} 
                else if(att.contentType == 'application/x-mspublisher'){wc.fileType = '.pub';}        
                else if(att.contentType.startsWith('application/vnd.quark')){wc.fileType = '.qxp';} 
                else if(att.contentType == 'application/x-rar-compressed'){wc.fileType = '.rar';} 
                else if(att.contentType == 'application/vnd.stardivision.draw'){wc.fileType = '.sda';} 
                else if(att.contentType == 'application/vnd.stardivision.calc'){wc.fileType = '.sdc';}  
                else if(att.contentType == 'application/vnd.stardivision.impress'){wc.fileType = '.sdd';} 
                else if(att.contentType == 'application/vnd.stardivision.writer'){wc.fileType = '.sdw';}        
                else if(att.contentType == 'application/x-stuffit'){wc.fileType = '.sit';} 
                else if(att.contentType == 'application/vnd.openxmlformats-officedocument.presentationml.slide'){wc.fileType = '.sldx';} 
                else if(att.contentType == 'application/vnd.stardivision.math'){wc.fileType = '.smf';} 
                else if(att.contentType == 'application/x-shockwave-flash'){wc.fileType = '.swf';}  
                else if(att.contentType == 'application/vnd.sun.xml.calc'){wc.fileType = '.sxc';} 
                else if(att.contentType == 'application/vnd.sun.xml.draw'){wc.fileType = '.sxd';} 
                else if(att.contentType == 'application/vnd.sun.xml.impress'){wc.fileType = '.sxi';} 
                else if(att.contentType == 'application/vnd.sun.xml.math'){wc.fileType = '.sxm';} 
                else if(att.contentType == 'application/vnd.sun.xml.writer'){wc.fileType = '.sxw';} 
                else if(att.contentType == 'text/plain'){wc.fileType = 'Text';} 
                else if(att.contentType == 'application/vnd.ms-wpl'){wc.fileType = '.wpl';} 
                else if(att.contentType == 'application/vnd.ms-works'){wc.fileType = '.wps';} 
                else if(att.contentType == 'application/x-mswrite'){wc.fileType = '.wri';} 
                else if(att.contentType == 'application/vnd.ms-excel'){wc.fileType = '.xls';} 
                else if(att.contentType == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'){wc.fileType = '.xlsx';} 
                else if(att.contentType == 'application/vnd.ms-xpsdocument'){wc.fileType = '.xps';}
                else if(att.contentType == 'application/zip'){wc.fileType = '.zip';}
                else if(att.contentType.startsWith('audio/')){wc.fileType = 'Audio';}
                else if(att.contentType.startsWith('image/')){wc.fileType = 'Image';}
                else if(att.contentType.startsWith('video/')){wc.fileType = 'Video';}
                else {wc.fileType = 'Other';}
                
                if(att.BodyLength > (1024*1024*524)){
                    kb = Decimal.valueOf(att.BodyLength);
                    wc.Size = kb.divide(1024*1024*1024,1)+ ' GB';
                }
                else if(att.BodyLength > (1024*524)){
                    kb  = Decimal.valueOf(att.BodyLength);
                    wc.Size = kb.divide(1024*1024,1)+ ' MB';
                }
                else if(att.BodyLength >1024){
                    kb = Decimal.valueOf(att.BodyLength);
                    wc.Size = kb.divide(1024,1)+ ' KB';             
                }
                else {
                    kb = Decimal.valueOf(att.BodyLength);
                    wc.Size = kb.divide(1,0)+ ' B';             
                }
                
                lstW.add(wc);
            }
            return lstW;
        }
    }
    //--------End convert----------
}