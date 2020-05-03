/*********************************************************
Class Name: TaskController
Author:chaithanya daggumati    Last modified by:Nagaraju G
Date:  14/7/2014                          Date:27/11/2015
Dsc:add some code to prevent view state error 
********©2013 Musqot marketing technology Pvt ltd ********/
public with sharing class TaskController {
    private ApexPages.StandardController sc;
    public String projectid{get;set;}
    public String subprjid{get;set;}
    public String mrkId{get;set;}
    public String cosid{get;set;}
    Public Task Task{get;set;}
    public List<Members__c> mbrs;
    public Map<Id,Members__c> mbrsMap;
    private Marketing_activity__c ma = new Marketing_activity__c();
    private Project__c prj = new Project__c ();
    private Subproject__c sp = new Subproject__c ();
    private Costcentre__c cosen = new Costcentre__c ();
    public string contenttype{get;set;} 
    public Date myRemaid{get;set;}
    public string selectedTime{get;set;}
    String PermissionSet;
    public TaskController(){}
    public TaskController (ApexPages.StandardController sc) {
        this.sc = sc;
        //this.attachment= new Attachment(); 
        mbrs = new List<Members__c>();
        mbrsMap = new Map<Id,Members__c>();
        projectid = ApexPages.currentPage().getParameters().get('planid'); 
        subprjid = ApexPages.currentPage().getParameters().get('subid');
        mrkId = ApexPages.currentPage().getParameters().get('mrkid');
        cosid = ApexPages.currentPage().getParameters().get('cosid');
        string mainStr = ApexPages.CurrentPage().getParameters().get('retURL');
        if(mrkId<>null){
            Task= new Task(WhatId= mrkId);
            ma = [select Id,Owner.Id ,musqot__Starts_date__c,musqot__Ends_date__c 
                  from Marketing_activity__c where Id  =:mrkId];
            mbrs = [select Id,ProjUsers__c from Members__c where Marketingmebers__c =:mrkId]; 
            if(!mbrs.isEmpty()){
                for(Members__c m : mbrs){
                    mbrsMap.put(m.ProjUsers__c,m);   
                }
            }
        }
        else if(projectid<>null){ 
            Task= new Task(WhatId= projectid);
            prj = [select Id, Owner.Id,musqot__Starts_date__c,musqot__Ends_date__c 
                   from Project__c  where Id  =:projectid];
            mbrs = [select Id,ProjUsers__c from Members__c where ProjMembers__c =:projectid];
            if(!mbrs.isEmpty()){
                for(Members__c m : mbrs){
                    mbrsMap.put(m.ProjUsers__c,m);   
                }
            }
        }
        else if(subprjid<>null) {
            Task= new Task(WhatId= subprjid);
            sp = [select Id, Owner.Id,musqot__Starts_date__c,musqot__Ends_date__c 
                  from Subproject__c where Id  =:subprjid];
            mbrs = [select Id,ProjUsers__c from Members__c where SubProjMembers__c =:subprjid];
            if(!mbrs.isEmpty()){
                for(Members__c m : mbrs){
                    mbrsMap.put(m.ProjUsers__c,m);   
                }
            }
        }
       else if(cosid<>null) {
            Task= new Task(WhatId= cosid);
            cosen = [select Id, Owner.Id,name 
                  from Costcentre__c where Id  =:cosid];
            mbrs = [select Id,ProjUsers__c,Cost_center__c from Members__c where Cost_center__c =:cosid];
            if(!mbrs.isEmpty()){
                for(Members__c m : mbrs){
                    mbrsMap.put(m.ProjUsers__c,m);   
                }
            }
        }
    }
    /*************************************************************
    save():create new task and redirect to  related to parent page
    **************************************************************/
    Public PageReference Save(){ 
         if(projectid <>null){
             Map<Id,Musqot_member__c>planMemberMap1= new Map<Id,Musqot_member__c>();
             list<Activity__c> act=[SELECT Id, Name,Plan_access_controll__c FROM Activity__c limit 1];            
             for(Musqot_member__c pm:[Select id,userid__c FROM Musqot_member__c where Plan__c=:projectid]){
                 planMemberMap1.put(pm.userid__c,pm);
             }
            if(act[0].Plan_access_controll__c==true){
             if(planMemberMap1.keyset().contains(Task.OwnerID)== false){
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'The selected member is not in Plan members');
                 ApexPages.addMessage(myMsg); 
                 return null;
               } 
            }
            /*commented by chaithanya on 18th dec'15-----start
            else if(Task.ActivityDate>prj.musqot__Ends_date__c || Task.ActivityDate < prj.musqot__Starts_date__c){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Duedate with in the span of plan startdate and enddate'));
                return null;
            }
			commented by chaithanya -----end*/
            //else{
            if (Schema.sObjectType.Task.isCreateable()) {
                if(myRemaid<>null && selectedTime<>null){
                    Task.ReminderDateTime = getConvertDateTime(myRemaid+' '+selectedTime);                      
                    insert Task;
                }
            }
            //}
         }
          else if(subprjid <>null){
            /*commented by chaithanya on 18th dec'15-----start
            if(Task.ActivityDate>sp.musqot__Ends_date__c || Task.ActivityDate < sp.musqot__Starts_date__c){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Duedate with in the span of project startdate and enddate'));
                return null;
            }
            commented by chaithanya -----end*/
            //else 
            if (Schema.sObjectType.Task.isCreateable()) {
                if(myRemaid<>null && selectedTime<>null){
                    Task.ReminderDateTime = getConvertDateTime(myRemaid+' '+selectedTime);                        
                    insert Task;
                }
            }
          }  
          else if(mrkId <>null){
              /*commented by chaithanya on 18th dec'15-----start
              if(Task.ActivityDate>ma.Ends_date__c||Task.ActivityDate<ma.Starts_date__c){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Duedate with in the span of marketning activity startdate and enddate'));
                return null;
            }
			commented by chaithanya -----end*/
            //else 
			if (Schema.sObjectType.Task.isCreateable()) {
                if(myRemaid<>null && selectedTime<>null){
                    Task.ReminderDateTime = getConvertDateTime(myRemaid+' '+selectedTime);            
                    insert Task;
                }
            }
          }
         else if(cosid <>null){
             Map<Id,Members__c>cosmem= new Map<Id,Members__c>();                     
             for(Members__c cm:[Select id,ProjUsers__c FROM Members__c where Cost_center__c=:cosid]){
                 cosmem.put(cm.ProjUsers__c,cm);
             }
             if(cosmem.keyset().contains(Task.OwnerID)== false){
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'The selected member is not in members');
                 ApexPages.addMessage(myMsg); 
                 return null;
               } 
             if (Schema.sObjectType.Task.isCreateable()) {
                 insert Task;
             }
         }
            if(Task.id<>null){
                Map<String,StaticResource>resourceMap = new Map<String,StaticResource>();
                List<StaticResource> resList = [select Id,Name from StaticResource Limit 1000];
                for(StaticResource s: resList){       
                    resourceMap.put(s.Name,s);
                } 
                Task tsk=[select id,status from task where id=:Task.id limit 1];
                String ts = tsk.Status;
                if(ts<>null){
                    if(resourceMap.containskey((ts).trim())){ 
                        tsk.Status_Image_Id__c = resourceMap.get(ts).Id; 
                        update tsk;                 
                    }
                } 
            }
      //  }
        User u = [select Id from user where id=:userinfo.getuserid()];
        //Attachment Code
        attachment.OwnerId = task.OwnerId;
        attachment.ParentId = task.Id; // the record the file is attached to
        attachment.ContentType=contentType;
        
        String usrProfileName ;
        try{
            usrProfileName=[select u.Profile.Name from User u where u.id = :Task.OwnerID].Profile.Name;
        }catch(exception e){}
        List<PermissionSetAssignment> lstcurrentUserPerSet =[SELECT PermissionSet.Name,AssigneeId 
                                                             FROM PermissionSetAssignment
                                                             WHERE AssigneeId = :Task.OwnerID ];
        
        for(PermissionSetAssignment p1:lstcurrentUserPerSet){
            if(p1.permissionSet.Name=='Musqot_admin'||p1.permissionSet.Name=='Musqot_admin_sf'||p1.permissionSet.Name=='Musqot_global_user'||p1.permissionSet.Name=='Musqot_global_user_sf'||p1.permissionSet.Name=='Musqot_Read_Only'||p1.permissionSet.Name=='Musqot_Read_Only_sf'||p1.permissionSet.Name=='Musqot_user'|| p1.permissionSet.Name=='Musqot_user_sf'){
                PermissionSet = p1.permissionSet.Name;
              }  
                
        }      
        try {
            if(mbrsMap.keySet().size()>0){
                if(!mbrsMap.containsKey(Task.OwnerID)){
                    Members__c Mem = New Members__c(); 
                    Mem.Role__c = 'Free user'; 
                        if(mrkId<>null){
                            Mem.Marketingmebers__c= mrkId;   
                            Mem.ProjUsers__c  = task.OwnerId;   
                        }
                    Permissionlist__c pset=Permissionlist__c.getInstance(PermissionSet);
                    if(usrProfileName=='Musqot admin'||usrProfileName=='Musqot user'||usrProfileName=='Musqot global user'||usrProfileName=='System Administrator'||permissionset=='Musqot_admin'||permissionset=='Musqot_admin_sf'||permissionset=='Musqot_global_user'||permissionset=='Musqot_global_user_sf'||permissionset=='Musqot_Read_Only'||permissionset=='Musqot_Read_Only_sf'||permissionset=='Musqot_user'|| permissionset=='Musqot_user_sf'){                           
                          Mem.Role__c = 'Viewer';                
                    }
                    if(projectid<>null){
                        Mem.ProjMembers__c = projectid;
                        Mem.ProjUsers__c  = task.OwnerId;
                    }
                    else if(subprjid<>null){
                        Mem.SubProjMembers__c = subprjid;
                        Mem.ProjUsers__c  = task.OwnerId;
                    }  
                    if (Members__c.sObjectType.getDescribe().isCreateable())
                    {
                        insert mem; 
                    }     
                }
            }
            if(attachment.body<>null||test.isrunningtest()){
                if (Schema.sObjectType.attachment.fields.body.isCreateable()) {
                    
                    insert attachment;  
                    attachment.Body=null;// Raju ---Ensure that the view state error; 
                }                 
            }
            Pagereference PR;                   
            if(mrkId<>null){
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/Marketingactivity?id='+EncodingUtil.urlEncode(mrkId,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb3','UTF-8');
                pr=new Pagereference (pageRef);
            }
            if(projectid<>null){
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/ProjectDetails?id='+EncodingUtil.urlEncode(projectid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb3','UTF-8');
                pr=new Pagereference (pageRef);
            }
            else if(subprjid<>null){
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/SubProject?id='+EncodingUtil.urlEncode(subprjid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb3','UTF-8');
                pr=new Pagereference (pageRef);
            }
            else if(cosid<>null){
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/Costcenterdetail?id='+EncodingUtil.urlEncode(cosid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb3','UTF-8');
                pr=new Pagereference (pageRef);
         }
            return PR;  
        }
        catch(Exception ex){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error,'Duplicate User For Member'); 
            return null;      
        }
    }
    public Attachment attachment {
        get {
            if (attachment == null)
                attachment = new Attachment();
                return attachment;
        }
        set;
    }  
    /********************************************
    cancel(): redirect to related to parent page
    *********************************************/
    Public Pagereference cancel(){
        Pagereference PR;
        if(mrkId<>null){
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/Marketingactivity?id='+EncodingUtil.urlEncode(mrkId,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb3','UTF-8');
            pr=new Pagereference (pageRef);
        }
        else  if(subprjid<>null){
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/SubProject?id='+EncodingUtil.urlEncode(subprjid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb3','UTF-8');
            pr=new Pagereference (pageRef);
        }
        else  if(projectid<>null){
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/ProjectDetails?id='+EncodingUtil.urlEncode(projectid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb3','UTF-8');
            pr=new Pagereference (pageRef);
        }
        else  if(cosid<>null){
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/Costcenterdetail?id='+EncodingUtil.urlEncode(cosid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb3','UTF-8');
            pr=new Pagereference (pageRef);
        }
        return PR;
    }
    public String getRedirectToTemplate() {
        return null;
    }
    public Task templateInfo {get; set;}
    public Pagereference redirectToTemplate() {
        try{
            insert templateInfo;
        }catch(Exception e){
            ApexPages.addMessages(e);
        }
        return null;
    }
   public void dauDateMethod(){
        
         task.ReminderDateTime=task.ActivityDate;
        
    }
     string S = 'mins ';
     public string getSelectedItem(){
          return s;
     }
     public void setSelectedItem(String s){
         this.s = s;
     }
     public list<SelectOption> getItems (){
         String ampm;
         List<SelectOption> opts = new List<SelectOption>();
            opts.add(new SelectOption('00:00','12:00 AM'));                 
            opts.add(new SelectOption('00:30','12:30 AM'));                 
            for(Integer i=1;i<=11;i++){           
                String mins = '00';
                string mam='AM';
                for(Integer j=0;j<=1;j++){
                    opts.add(new SelectOption(i+':'+mins,i+':'+mins+' '+mam));                 
                    if(mins=='00'){   
                        mins = '30';
                    }
                }
           }  
           opts.add(new SelectOption('12:00','12:00 PM'));                 
           opts.add(new SelectOption('12:30','12:30 PM')); 
           for(Integer i=13;i<=23;i++){           
                String mins = '00';
                Integer k = i-12;
                string evm='PM';
         
                for(Integer j=0;j<=1;j++){
                    opts.add(new SelectOption(i+':'+mins,k+':'+mins+' '+evm));                 
                    if(mins=='00'){   
                        mins = '30';
                    }
                }
                
           } 
         return opts;
     }
    
    /** 
     String Datetime to Datetime
    */
    
    public DateTime getConvertDateTime(string strDT){
        String[] DTSplitted = strDT.split(' ');
        string year = DTSplitted.get(0).split('-').get(0);
        string month = DTSplitted.get(0).split('-').get(1);
        string day = DTSplitted.get(0).split('-').get(2);
        string hour = DTSplitted.get(2).split(':').get(0);
        string minute = DTSplitted.get(2).split(':').get(1);
        Map <String, Integer> monthNames = new Map <String, Integer> {'Jan'=>1, 'Feb'=>2, 'Mar'=>3, 'Apr'=>4, 'May'=>5, 'Jun'=>6, 'Jul'=>7, 'Aug'=>8, 'Sep'=>9, 'Oct'=>10, 'Nov'=>11, 'Dec'=>12};
        DateTime yourDateVariable = DateTime.newInstanceGmt(Integer.valueOf(year), Integer.valueOf(month), Integer.valueOf(day), Integer.valueOf(hour), Integer.valueOf(minute), Integer.valueOf('00'));       
        return yourDateVariable;
      }
           
}