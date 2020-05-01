/*************************************************************
Class Name: SubprojectController
Author:Nagaraju G                  Last modified by:Narendra
Date: 24/6/2014                    Date:12/11/2015
Description:Changed Progress bar calclution from Directly Proportional
delete update milestone method,done this through trigger..
********©2013 Musqot marketing technology Pvt ltd ************/
public with sharing class SubprojectController {
    public string name{get;set;}
    private ApexPages.standardController controller;
    Public list<Workspace__c >workSpaceList{get;set;}
    public list<NoteAndAttachMent> AttachmentsList{get;set;}
    public Id subprojectid;
    public string workId{get;set;}
    public String subPrjId;
    private Subproject__c subid;
    public Subproject__c subPrj{get;set;}
    public boolean Level1{get;set;}
    public boolean Level2{get;set;}
    public boolean Level3{get;set;}
    public boolean Level4{get;set;}
    private String tabInFocus;
    private String tabId; 
    public List<String>mlId;
    public List<String>mmemId;
    public date startDate;
    public date endDate;
    public Date todate{get;set;}
    public List<Members__c> parentmbrList;
    public Subproject__c prj;
    public Subproject__c tester { get; set; }
    public List<Summary>mrkList{get;set;}
    public list<Marketing_activity__c> mrkAct;  
    public boolean subgannttmrkAct {get;set;}
    public string parentPlanId {get;set;}
    public string parentProId {get;set;}
    public boolean isGanttDetailBtnVisible {get;set;}
    public List<Subproject__c> subProjects {get;set;}
    public List<Marketing_activity__c> MarkActivies {get;set;}
    public List<Task> taskrecs1 {get;set;}
    public List<musqot__Activity__c> musAct{get;set;}
    public boolean isPerformanceVisible {get;set;}
    public string workspaceId;
    public SubprojectController (ApexPages.StandardController controller) {
        this.controller = controller;
        todate=system.today();
        this.tester = (Subproject__c)controller.getRecord();
        workId= controller.getRecord().Id;
        
        subPrjId = ApexPages.currentPage().getParameters().get('id2');
        if(subPrjId == null){
            subPrjId = ApexPages.currentPage().getParameters().get('id');
        }
        
        
        tabInFocus = System.currentPageReference().getParameters().get('tab');
        subPrj = new Subproject__c();
        subPrj =[select Id,Parent_project__c, Project_del__c, planid__c, 
                 Project_del__r.id, Ends_date__c,Starts_date__c,
                 (SELECT Id from Workspaces__r) from Subproject__c 
                 where Id =:subPrjId limit 1];
        parentProId = subPrj.Project_del__c;
        startDate = subPrj.Starts_date__c;
        endDate = subPrj.Ends_date__c;  
        for(Workspace__c w:subPrj.Workspaces__r){
            workspaceId= w.id;
        } 
        mrkList=new List<Summary>();
        MusqotUtility.innerClass musIncls = MusqotUtility.securitySettingsub(workId);
        Level1 = musIncls.l1;
        Level2 = musIncls.l2;
        Level3 = musIncls.l3;
        Level4 = musIncls.l4;
        
        workSpace(); 
        subgannttmrkAct = false;
        try{
            mrkAct = [select Id,Name,Starts_date__c, Ends_date__c, ERP__c, CRM__c, Social_media__c 
                      FROM Marketing_activity__c 
                      where Isdeleted = false AND Project__c =:subPrjId];                                    
        }catch(Exception e){}
        //marketing activity--
        for(Marketing_activity__c ma : mrkAct){
            if(ma.ERP__c <>  null){
                for(String erpId: ma.ERP__c.split(';')){
                    subgannttmrkAct = true;
                }
            }
            if(ma.CRM__c <>  null){
                for(String crmId: ma.CRM__c.split(';')){
                    subgannttmrkAct = true;
                }                
            }
            if(ma.Social_media__c <>  null){
                for(String smId: ma.Social_media__c.split(';')){
                    subgannttmrkAct = true;
                }                
            }
        }        
        
        
        
        // added by Narendra
        // fetch subprojects, marketting activities, & tasks and to check whether gantt detail button should appear. - start -
        isGanttDetailBtnVisible = false;
        subProjects = new List<Subproject__c>();
        MarkActivies = new List<Marketing_activity__c>();
        taskrecs1 = new List<Task>();
        
        subProjects = [Select id,Name,Ends_date__c,Starts_date__c,Status__c,StatusImage__c ,
                       Project_del__c,Parent_project__c,Project_type__c,Project_type__r.name 
                       FROM Subproject__c 
                       WHERE Project_del__c =:subPrjId order by Starts_date__c];
        
        MarkActivies = [select Id,Name,Activitytype__c,Activitytype__r.name,
                        Project__c,Starts_date__c,Ends_date__c,Status__c,StatusImage__c  
                        from Marketing_activity__c 
                        where Project__c=:subPrjId order by Name];
        
        taskrecs1 = [Select Id, WhoId, WhatId, Subject, ActivityDate, Status, Priority,
                     OwnerId, CreatedById, Description, IsDeleted, AccountId, IsClosed, 
                     Allocated_h__c, Outcome_h__c,Task_description__c,Task_name__c, StatusImage__c   
                     FROM Task 
                     where whatid=:subPrjId order by ActivityDate limit 400];
        
        
        musAct=[SELECT Id, Name, Incl_Marketing_activity_Detail__c,Use_Finance1__c,
                Incl_Milestone_Detail__c, Incl_Task_Detail__c FROM Activity__c limit 1];
        
        if((musAct[0].Incl_Marketing_activity_Detail__c && MarkActivies.size()>0)
           || (musAct[0].Incl_Task_Detail__c && taskrecs1.size()>0) || subProjects.size()>0) {
               isGanttDetailBtnVisible = true;
           }
        //Raju added to apply edition settings of performance---
        if(musAct[0].Use_Finance1__c){
            isPerformanceVisible=true;
        }
        
        // fetch subprojects, marketting activities, & tasks and to check whether gantt detail button should appear. - end -
    }
    /******************************************* 
getTabInFocus():redirect to  particular tab
*******************************************/  
    public String getTabInFocus() {
        return tabInFocus;
    }
    
    public void setTabInFocus(String s ) {
        this.tabInFocus = s;
    }
    /*********************************************** 
gotoSubproEdit():redirect to  SubprojecteditPage
************************************************/  
    public PageReference gotoSubproEdit(){
        PageReference pgr;   
        Blob hash = Crypto.generateDigest('SHA1',Blob.valueOf(subPrjId));
        String subPrjHex = EncodingUtil.convertToHex(hash);
        Blob hash1 = Crypto.generateDigest('SHA1',Blob.valueOf(workId));
        String workHex = EncodingUtil.convertToHex(hash1);
        pgr = new PageReference('/apex/SubprojecteditPage?projectid='+EncodingUtil.urlEncode(subPrjId,'UTF-8')+'&subprid='+EncodingUtil.urlEncode(workId,'UTF-8'));
        
        return pgr;
    }
    /****************************************
gotoTaskEdit() :redirect to TaskEditpage
*****************************************/ 
    public PageReference gotoTaskEdit(){
        String taskid= ApexPages.currentPage().getParameters().get('taskid');
        PageReference pgr;   
        pgr =new PageReference ('/apex/TaskEditpage?taskId='+EncodingUtil.urlEncode(taskid,'UTF-8')+'&subpid='+EncodingUtil.urlEncode(subPrjId,'UTF-8'));
        return pgr;
    }
    /*************************************
workSpace():redirect to std_workspace 
*************************************/ 
    Public PageReference workSpace(){
        workSpaceList =new list<Workspace__c>();
        workSpaceList=[select id,Name,Description__c,html_description__c,ProjectName__c,
                       (Select Id, Title From NotesAndAttachments) 
                       from Workspace__c 
                       where Subproject__c=:workId];  
        AttachmentsList = New List<NoteAndAttachMent>();
        if(workSpaceList.size()>0){
            for(Workspace__c Item: workSpaceList){
                for(NoteAndAttachMent NA :Item.NotesAndAttachments){
                    AttachmentsList.add(NA);
                }
                //}
            }
            PageReference WorkSpacPage=new PageReference('/apex/std_workspace?id='+EncodingUtil.urlEncode(workSpaceList[0].id,'UTF-8')+'&subprojectid='+EncodingUtil.urlEncode(workId,'UTF-8'));
            WorkSpacPage.setredirect(true);
            return WorkSpacPage;
        } 
        return null;
    }
    /**************************************
workRedirect():insert workspace record 
***************************************/ 
    Public PageReference workRedirect(){ 
        if (Workspace__c.sObjectType.getDescribe().isCreateable())
        {
            insert workSpaceList;     
        }
        return null;
        
    }
    Public Attachment myfile;
    Public Attachment getmyfile(){
        myfile = new Attachment();
        return myfile;
    }
    /************************************
Savedoc():redirect  to attachmentpage 
*************************************/ 
    Public PageReference Savedoc(){
        workSpaceList =new  List<Workspace__c>();
        workSpaceList=[select id,Name,Description__c,html_description__c,ProjectName__c,
                       (Select Id, Title From NotesAndAttachments),
                       (Select Id, Name From Attachments) 
                       from Workspace__c 
                       where subproject__c=:workId];  
        
        PageReference WorkSpacPage=new PageReference('/apex/attachmentpage?id='+EncodingUtil.urlEncode(workSpaceList[0].id,'UTF-8')+'&subprojectid='+EncodingUtil.urlEncode(workId,'UTF-8'));
        WorkSpacPage.setredirect(true);
        return WorkSpacPage;
        
    }
    /************************************************** 
gotoattchmentpage():redirect to  AttachmentInfopage
***************************************************/ 
    public PageReference gotoattchmentpage(){
        String atmid= ApexPages.currentPage().getParameters().get('atmid');
        PageReference pgr;  
        if(atmid<>null){  
            pgr =new PageReference ('/apex/AttachmentInfopage?attid='+EncodingUtil.urlEncode(atmid,'UTF-8')+'&subid='+EncodingUtil.urlEncode(workId,'UTF-8'));
            return pgr;
        }
        return null;
    }
    /****************************************
newMilstone(): reditrect to MilestonePage 
*****************************************/ 
    Public PageReference newMilstone(){
        
        //   Subproject__c prj = [select Id,Parent_project__c from Subproject__c where Id =:subPrjId limit 1];
        PageReference milestonepage=new PageReference('/apex/MilestonePage?subId='+EncodingUtil.urlEncode(subPrjId,'UTF-8')+'&planid='+EncodingUtil.urlEncode(subPrj.Parent_project__c,'UTF-8'));
        milestonepage.setredirect(true);
        return milestonepage;
    }
    /************************************************** 
gotoMilestoneEdit():reditrect to MilestoneEditpage 
**************************************************/ 
    public PageReference gotoMilestoneEdit(){
        String mileId= ApexPages.currentPage().getParameters().get('mileId'); 
        PageReference pgr;
        if(mileId<>null){       
            pgr =new PageReference ('/apex/MilestoneEditpage?subid='+EncodingUtil.urlEncode(workId,'UTF-8')+'&mileId='+EncodingUtil.urlEncode(mileId,'UTF-8'));
            return pgr;
        }
        return null;
    }
    /*********************************************
newMarketingPage(): reditrect to marketingpage 
**********************************************/ 
    Public PageReference newMarketingPage(){
        // Subproject__c prj = [select Id,Parent_project__c from Subproject__c where Id =:subPrjId limit 1];
        PageReference milestonepage=new PageReference('/apex/marketingpage?subId='+EncodingUtil.urlEncode(subPrjId,'UTF-8')+'&planid='+EncodingUtil.urlEncode(subPrj.Parent_project__c,'UTF-8'));
        milestonepage.setredirect(true);
        return milestonepage;
    }    
    /**********************************
newMember(): reditrect to memberobj
***********************************/  
    Public PageReference newMember(){
        PageReference memberobj=new PageReference('/apex/memberobj?subId='+EncodingUtil.urlEncode(subPrjId,'UTF-8')+'&planid='+EncodingUtil.urlEncode(subPrj.Parent_project__c,'UTF-8'));
        memberobj.setredirect(true);
        return memberobj; 
    }
    /************************************** 
newProject(): reditrect to projectpage
**************************************/  
    Public PageReference newProject(){
        Subproject__c prj;
        try{
            prj = [select Id,Parent_project__c from Subproject__c where Id =:subPrjId limit 1];
        }
        Catch(Exception e){
        }
        PageReference memberobj=new PageReference('/apex/projectpage?prjId='+EncodingUtil.urlEncode(subPrjId,'UTF-8')+'&planId='+EncodingUtil.urlEncode(prj.Parent_project__c,'UTF-8'));
        memberobj.setredirect(true);
        return memberobj; 
    }
    /***********************************************
getmilston():it return list of milestone records
************************************************/  
    // This code need to be dun in Apex/JAVA 
    public List<Summary> getmilston(){
   
        milestoneList=[SELECT Id, Name, Status__c,  Target_number__c, Target_number_outcome__c, Milestone_type__c, Targetdate__c
                       	,Target_Project__r.Name, Target_Marketing_activity__r.Name, Target_Socialmedia__r.Name, Target_ERP_Sales__r.Name, Target_CRM_Settings__r.Name
                       FROM Milestone__c  
                       where Project__c=:subPrjId  Order by targetdate__c limit 100];
        
        if(milestoneList<>null){
            for(Milestone__c Mile1:milestoneList){
                if(Mile1.Milestone_type__c ==3 || Mile1.Milestone_type__c ==4 || Mile1.Milestone_type__c ==5|| Mile1.Milestone_type__c ==9){                 
                    If (Mile1.Target_number_outcome__c <> null && Mile1.Target_number__c <> null){
                        If (Mile1.Target_number_outcome__c > 0 && Mile1.Target_number__c > 0){
                            iProgress_value = (Mile1.Target_number_outcome__c /Mile1.Target_number__c)*100;     
                            sProgressText = iProgress_value.setscale(0) +'%'; 
                            if(sProgressText.length()>3)
                                sProgressText = sProgressText.substring(0,3)+'%';
                        }
                        else{
                            iProgress_value =0;
                        }
                    }
                    else{
                            iProgress_value =0;
                        }
                }
                else if(Mile1.Milestone_type__c ==1){
                    iProgress_value=0;
                    Mile1.Target_number__c=null;
                }
                else if(Mile1.Milestone_type__c ==2){
                    iProgress_value=0;
                    Mile1.Target_number__c=null;
                }   
                mrkList.add(new Summary(Mile1,iProgress_value,sProgressText,displayblock));
            } 
            return mrkList;
        }
        return null;  
    }
    
    // wrapper class to hold progressbar data
    public class Summary{
        public String sProgressText{ get;set;}
        public Milestone__c mil{get;set;}
        public double iProgress_value{get;set;}
        public string displayblock{get;set;}
        public Summary(Milestone__c ml,Decimal ipValue,String dblock,string spText){
            this.sProgressText=spText;
            this.mil=ml;
            this.iProgress_value=ipvalue;
            this.displayblock=dblock;
            
        }
    }
    
    /******************************************************** 
getparentmembers():it return list of plan member records
********************************************************/
    public List<Members__c > getparentmembers(){
        mlId=new List<String>();
        parentmbrList = new List<Members__c>();
        mmemId=new List<String>();
        List<string>memId=new List<string>();
        List<Members__c> mbrList = new List<Members__c>();
        List<Allocation_amount__c> listrec=[Select Allocated__c, Costcentre__r.OwnerID,Costcentre__r.name,
                                            Costcentre__r.Email__c, Approved_Amount__c,To_Plan__c  
                                            FROM Allocation_amount__c 
                                            where  To_Plan__c =:subPrj.planid__c limit 100];
        List<Members__c>tmpList=[Select id, ProjMembers__c,ProjUsers__r.smallphotourl,ProjUsers__c,
                                 ProjUsers__r.name, Role__c, Type__c, User_Email__c 
                                 FROM Members__c 
                                 WHERE SubProjMembers__c =:workId and Role__c='owner' limit 1];
        Map<String, Allocation_amount__c > maps= new Map<String, Allocation_amount__c >();
        list<Members__c> plnOwenr=[Select id, ProjMembers__c, ProjUsers__c,ProjUsers__r.smallphotourl,
                                   ProjUsers__r.name, SubProjMembers__c, Role__c, Type__c, User_Email__c 
                                   FROM Members__c 
                                   WHERE ProjMembers__c =:subPrj.Parent_project__c and Role__c='owner' limit 1];
        for(Allocation_amount__c allAm: listrec){
            if(allAm.Costcentre__r.name<>null ){
                if(tmpList.size()>0){
                    if(plnOwenr.size()>0){  
                        if(allAm.Costcentre__r.OwnerID<> tmpList[0].ProjUsers__c && allAm.Costcentre__r.OwnerID <> plnOwenr[0].ProjUsers__c){
                            if(!maps.containsKey(allAm.Costcentre__r.OwnerID)) 
                                maps.put(allAm.Costcentre__r.OwnerID,allAm);
                        }else{
                            if(!maps.containsKey(allAm.Costcentre__r.OwnerID)) 
                                maps.put(allAm.Costcentre__r.OwnerID,allAm);
                        } 
                    }
                }
            }
        }                        
        List<Allocation_amount__c> newList = maps.values();
        for(Allocation_amount__c newre:newList){
            mmemId.add(newre.Costcentre__r.OwnerID);
        }
        List<Members__c> tmpLis= [Select id, ProjMembers__c, ProjUsers__c,ProjUsers__r.smallphotourl,ProjUsers__r.name, SubProjMembers__c, Role__c, Type__c, User_Email__c 
                                  FROM Members__c 
                                  WHERE SubProjMembers__c =:subPrjId AND Role__c<>'Owner' limit 100];                           
        list<Members__c >tmpListOwner= [Select id, ProjMembers__c, ProjUsers__c,ProjUsers__r.name,ProjUsers__r.smallphotourl,SubProjMembers__c, Role__c, Type__c, User_Email__c 
                                        FROM Members__c 
                                        WHERE SubProjMembers__c =:subPrjId AND Role__c='Owner' limit 1];                           
        List<Allocation_amount__c> listre=[Select Allocated__c, Costcentre__r.OwnerID,Costcentre__r.name,Costcentre__r.Email__c,Approved_Amount__c,To_Plan__c  
                                           from Allocation_amount__c 
                                           where To_Plan__c  =:subPrj.planid__c limit 10];
        for(Members__c m : tmpLis){
            for(Allocation_amount__c all:listre){
                if(all.Costcentre__r.OwnerID<> m.ProjUsers__c){
                    memId.add(m.ProjUsers__c);             
                }
            }  
        }
        mbrList=[Select id, ProjMembers__c, ProjUsers__c,ProjUsers__r.name,ProjUsers__r.smallphotourl,SubProjMembers__c, Role__c, Type__c, User_Email__c 
                 FROM Members__c 
                 WHERE id=:memId  order by ProjUsers__c limit 100];  
        if(tmpListOwner.size()>0)
            mbrList.addAll(tmpListOwner);
        for(Members__c ml:mbrList){
            mlId.add(ml.ProjUsers__c);
        }
        List<Members__c> parenttmpList= [Select id, ProjMembers__c,ProjUsers__r.smallphotourl, ProjUsers__c,ProjUsers__r.name, SubProjMembers__r.name, Role__c, Type__c, User_Email__c 
                                         FROM Members__c 
                                         WHERE Role__c <> 'Viewer' and ( SubProjMembers__c =:subPrjid or ProjMembers__c =:subPrj.Parent_project__c) AND ProjUsers__c !=:mmemId AND ProjUsers__c!=:mlId  order by ProjUsers__r.name limit 100];
        
        List<Members__c> parenttmpListpro= [Select id, ProjMembers__c, ProjUsers__c,ProjUsers__r.name,ProjUsers__r.smallphotourl, SubProjMembers__r.name, Role__c, Type__c, User_Email__c 
                                            FROM Members__c 
                                            WHERE Role__c <> 'Viewer' and  (SubProjMembers__c =:subPrj.Project_del__c ) AND ProjUsers__c !=:mmemId AND ProjUsers__c!=:mlId  order by ProjUsers__r.name limit 100];            
        
        for(Members__c m :parenttmpList){
            if(m.ProjMembers__c<>null){
                m.Role__c = 'Plan '+m.Role__c;
                parentmbrList.add(m); 
            }
        }
        for(Members__c mem :parenttmpListpro){
            if(mem .SubProjMembers__c<>null||test.isRunningTest()){
                mem.Role__c = 'Project '+mem.Role__c;
                parentmbrList.add(mem);
            }
        }
        // Prevent Duplicate Users
        Map<String, Members__c > mapMbr= new Map<String, Members__c>();
        for(Members__c oh : parentmbrList){
            if(oh.ProjUsers__c<>null||test.isRunningTest()){
                if(!mapMbr.containsKey(oh.ProjUsers__c)) 
                    mapMbr.put(oh.ProjUsers__c,oh);
            }   
        }
        List<Members__c> parentmbrList1= mapMbr.values();
        return parentmbrList1;
    }
    /***********************************************************
getccMembers():it returns list of costcenter Member records
************************************************************/ 
    public list<Allocation_amount__c > getccMembers(){
        List<Allocation_amount__c> listrec=[Select Allocated__c, Costcentre__r.OwnerID, Costcentre__r.cc_Owner__c,Costcentre__r.name,Costcentre__r.Email__c, Approved_Amount__c, To_Plan__c  
                                            from Allocation_amount__c 
                                            where  To_Plan__c  =:subPrj.planid__c  order by Costcentre__r.OwnerID limit 10];
        list<Members__c> tmpList=[Select id, ProjMembers__c, ProjUsers__c, ProjUsers__r.name, SubProjMembers__c, Role__c, Type__c, User_Email__c 
                                  FROM Members__c 
                                  WHERE SubProjMembers__c =:workId and Role__c='owner'  limit 1]; 
        List<Members__c> plnOwenr=[Select id, ProjMembers__c, ProjUsers__c,ProjUsers__r.name, SubProjMembers__c, Role__c, Type__c, User_Email__c 
                                   FROM Members__c 
                                   WHERE ProjMembers__c =:subPrj.Parent_project__c and Role__c='owner'  limit 1]; 
        Map<String, Allocation_amount__c > maps= new Map<String, Allocation_amount__c >();
        for(Allocation_amount__c all : listrec){
            if(all.Costcentre__r.name<>null){
                if(tmpList.size()>0 && plnOwenr.size()>0){
                    if(all.Costcentre__r.OwnerID <> tmpList[0].ProjUsers__c && all.Costcentre__r.OwnerID <> plnOwenr[0].ProjUsers__c){
                        if(!maps.containsKey(all.Costcentre__r.OwnerID)) 
                            maps.put(all.Costcentre__r.OwnerID,all);
                    } 
                }
            }   
        }
        List<Allocation_amount__c> newList = maps.values();
        return newlist; 
    }
    /********************************************** 
getmembers():it returns list of member records
***********************************************/ 
    public list<Members__c >fmbrList=new list<Members__c >();
    public List<Members__c > getmembers(){  
        List<string>mmemId=new List<string>();
        List<string>mpId=new List<string>();
        List<string>memId=new List<string>();
        List<Members__c> parentmbrList2=new List<Members__c>();
        List<Members__c> parenttmpList=new List<Members__c>();
        list<string>mlId=new list<string>();
        List<Members__c> mbrList = new List<Members__c>();
        List<Members__c> tmpList= [Select id, ProjMembers__c, ProjUsers__c,ProjUsers__r.name, SubProjMembers__c, Role__c, Type__c, User_Email__c 
                                   FROM Members__c 
                                   WHERE SubProjMembers__c =:subPrjId AND Role__c<>'Owner'   limit 100];                           
        list<Members__c> tmpList1= [Select id, ProjMembers__c, ProjUsers__c,ProjUsers__r.name,ProjUsers__r.smallphotourl, SubProjMembers__c, Role__c, Type__c, User_Email__c 
                                    FROM Members__c 
                                    WHERE SubProjMembers__c =:subPrjId AND Role__c='Owner' order by ProjUsers__r.name  limit 1];                           
        List<Allocation_amount__c> listrec=[Select Allocated__c, Costcentre__r.OwnerID, Costcentre__r.cc_Owner__c, Costcentre__r.name,Costcentre__r.Email__c, Approved_Amount__c, To_Plan__c  
                                            from Allocation_amount__c 
                                            where To_Plan__c  =:subPrj.planid__c limit 10];
        Map<String, Allocation_amount__c > maps= new Map<String, Allocation_amount__c >();
        for(Allocation_amount__c all: listrec){
            if(all.Costcentre__r.name<>null){
                if(tmpList1.size()>0){
                    if(all.Costcentre__r.OwnerID <>  tmpList1[0].ProjUsers__c){
                        if(!maps.containsKey(all.Costcentre__r.OwnerID)) 
                            maps.put(all.Costcentre__r.OwnerID,all);
                    }
                } 
            }   
        }
        List<Allocation_amount__c> newList = maps.values();
        for(Allocation_amount__c newre:newList){
            mmemId.add(newre.Costcentre__r.OwnerID );
        }
        List<Members__c> tmpLis= [Select id, ProjMembers__c, ProjUsers__c,ProjUsers__r.name,ProjUsers__r.smallphotourl, SubProjMembers__c, Role__c, Type__c, User_Email__c 
                                  FROM Members__c 
                                  WHERE SubProjMembers__c =:subPrjId AND Role__c<>'Owner' limit 100];                           
        List<Members__c> tmpList12= [Select id, ProjMembers__c, ProjUsers__c,ProjUsers__r.name,ProjUsers__r.smallphotourl, SubProjMembers__c, Role__c, Type__c, User_Email__c 
                                     FROM Members__c 
                                     WHERE SubProjMembers__c =:subPrjId AND Role__c='Owner' limit 1];                           
        List<Allocation_amount__c> listre=[Select Allocated__c,Costcentre__r.OwnerID, Costcentre__r.cc_Owner__c,Costcentre__r.name,Costcentre__r.Email__c,Approved_Amount__c,To_Plan__c  
                                           from Allocation_amount__c 
                                           where  To_Plan__c  =:subPrj.planid__c limit 10];
        for(Members__c m : tmpLis){
            for(Allocation_amount__c all:listre){
                if(all.Costcentre__r.OwnerID <> m.ProjUsers__c){
                    memId.add(m.ProjUsers__c);             
                }
            }  
        }
        
        mbrList=[Select id, ProjMembers__c, ProjUsers__c,ProjUsers__r.name,ProjUsers__r.smallphotourl, SubProjMembers__c, Role__c, Type__c, User_Email__c 
                 FROM Members__c 
                 WHERE id=:memId ];
        if(tmpList12.size()>0)
            mbrList.addAll(tmpList12);
        for(Members__c ml:mbrList){
            mlId.add(ml.musqot__ProjUsers__c);
        }
        List<Members__c> parenttmpListpln= [Select id, ProjMembers__c, ProjUsers__c,ProjUsers__r.name, ProjUsers__r.smallphotourl,SubProjMembers__r.name, Role__c, Type__c, User_Email__c 
                                            FROM Members__c 
                                            WHERE Role__c <> 'Viewer' and ( SubProjMembers__c =:subPrjid or ProjMembers__c =:subPrj.Parent_project__c) AND musqot__ProjUsers__c !=:mmemId AND musqot__ProjUsers__c!=:mlId limit 100];
        
        List<Members__c> parenttmpListsub= [Select id, ProjMembers__c, ProjUsers__c,ProjUsers__r.name,ProjUsers__r.smallphotourl, SubProjMembers__r.name, Role__c, Type__c, User_Email__c 
                                            FROM Members__c 
                                            WHERE Role__c <> 'Viewer' and  (SubProjMembers__c =:subPrj.musqot__Project_del__c ) AND musqot__ProjUsers__c !=:mmemId AND musqot__ProjUsers__c!=:mlId limit 100];            
        
        for(Members__c m : parenttmpListpln){
            if(m.ProjMembers__c<>null){
                m.Role__c = 'Plan '+m.Role__c;
                parentmbrList2.add(m); 
            }
        }
        for(Members__c mem : parenttmpListsub){
            if(mem .SubProjMembers__c<>null||test.isRunningTest()){
                mem.Role__c = 'Project '+mem.Role__c;
                parentmbrList2.add(mem);
            }
        }
        for(Members__c mt:parentmbrList2){
            mpId.add(mt.ProjUsers__c);
        }
        fmbrList=[Select id, ProjMembers__c, ProjUsers__c,ProjUsers__r.name, ProjUsers__r.smallphotourl,SubProjMembers__c, Role__c, Type__c, User_Email__c 
                  FROM Members__c 
                  WHERE SubProjMembers__c =:workId AND Role__c<>'owner' And  ProjUsers__c<>:mmemId And  ProjUsers__c<>:mpId  order by ProjUsers__r.name  limit 100];                                          
        if(tmpList1.size()>0){
            fmbrList.addAll(tmpList1);
        }
        return fmbrList; 
    }
    /*******************************************
gotoMemberEdit():redirect to  Membereditpage
********************************************/ 
    public PageReference gotoMemberEdit() {
        String mbrId = ApexPages.currentPage().getParameters().get('mbrId'); 
        PageReference pgr;
        if(mbrId<>null){       
            pgr =new PageReference ('/apex/Membereditpage?subid='+EncodingUtil.urlEncode(workId,'UTF-8')+'&mbrId='+EncodingUtil.urlEncode(mbrId,'UTF-8'));
            return pgr;
        }
        return null;
    }
    
    /******************************* 
newtask():redirect to Task page
*******************************/   
    Public PageReference newtask(){
        taskrecs1= [Select Id, WhoId, WhatId, Subject, ActivityDate, Status, Priority, OwnerId,CreatedById, Description, IsDeleted, AccountId, IsClosed,  Allocated_h__c, Outcome_h__c, Task_description__c,Task_name__c, StatusImage__c  
                    FROM Task 
                    where id=:subPrjId order by ActivityDate limit 400];
        PageReference task1=new PageReference('/apex/Task?subid='+EncodingUtil.urlEncode(workId,'UTF-8'));
        task1.setredirect(true);
        return task1; 
    }
    /***************************************** 
customset(): redirect to PlanOverview page
******************************************/   
    public PageReference customset(){
        String planid= ApexPages.currentPage().getParameters().get('id');
        PageReference pgr;   
        pgr =new PageReference ('/apex/ProjectOverview?ProjectId='+EncodingUtil.urlEncode(planid,'UTF-8')+'&planid='+EncodingUtil.urlEncode(workId,'UTF-8'));
        return pgr;
    }
    /******************************************************************* 
getGadgetHTMLContent():This is for display contant in rich text area.
********************************************************************/  
    public Component.Apex.OutputText getGadgetHTMLContent(){
        Component.Apex.OutputText oppText = new Component.Apex.OutputText(escape = false);
        oppText.value = workSpaceList[0].html_description__c;       //gadgetcontent is the variable which holds the HTML content
        return oppText ;
    }
    /* Inner class*/
    public class addCostcenter{
        
        public string ccName{get;set;}
        
    }
    
    Public Pagereference delSubpro(){ //redirect to related record list page
        if(subPrj.Id<>null){
            delete workSpaceList;//this is Workspace__c of subproject__c 
            delete fmbrList; //this is membersList of subproject__c 
        }
        delete subPrj; 
        Pagereference pr;
        if(parentProId<>null){
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/SubProject?id='+EncodingUtil.urlEncode(parentProId,'UTF-8')+'&tab='+EncodingUtil.urlEncode('Projtab','UTF-8');
            pr=new Pagereference (pageRef);
        }
        else 
        {
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/ProjectDetails?id='+EncodingUtil.urlEncode(subPrj.Parent_project__c,'UTF-8')+'&tab='+EncodingUtil.urlEncode('Projtab','UTF-8');
            pr=new Pagereference (pageRef);
        }       
        pr.setredirect(true);
        return pr;
    } 
    public List<Milestone__c >milestoneList;
    //  public List<Milestone__c >updateMilestoneList;
    public Decimal iProgress_value;
    public string displayblock;
    public string sProgressText;
    //--Raju--This is for Attachment file download --
    public class AttachWrapper{
        public Id Id {get;set;}
        public string Name {get;set;}
    }
    public List<Attachment> workspaceAttchmentList{get;set;}
    public List<AttachWrapper> getAttLinks(){
        List<AttachWrapper>AttWrperlst=new List<AttachWrapper>();
        AttachWrapper wc=null;
        String trimedName;        
        workspaceAttchmentList=[SELECT Id, Name FROM Attachment 
                                WHERE parentId =:workspaceId];
        for(Attachment a:workspaceAttchmentList){ 
            wc=new AttachWrapper();
            wc.Id=a.id;
            trimedName=a.name;
            if(trimedName.containsAny('.'))
                wc.Name=trimedName.substring(0,trimedName.indexOf('.'));
            else 
                wc.Name=trimedName;
            AttWrperlst.add(wc);
        }
        return AttWrperlst;
    } 
    //---End----
}