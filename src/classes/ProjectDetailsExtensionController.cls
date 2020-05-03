/*******************************************************
Class Name: ProjectDetailsExtensionController
Author:Nagaraju G             Last modified by:Raju GN
Date:23/7/2014                Date:08/10/2015
Description:Changed Progress bar calclution from Directly Proportional
to Inversely Proportional of total and targetvaluem ,
Delete updatemilstone method,done this through trigger...
********©2013 Musqot marketing technology Pvt ltd *******/
public with sharing class ProjectDetailsExtensionController {
    public string name {get; set;}
    @Testvisible private List<Project__c > member {get; set;}
    public boolean showOwner{get;set;}
    public Project__c  pln { get; set;}
    public boolean showflist{get;set;}
    private ApexPages.standardController controller;
    Public List<Workspace__c> workSpaceList {get; set;}
    public list<NoteAndAttachMent> AttachmentsList {get; set;}
    public List<Allocation_amount__c> listrec{get;set;}
    public boolean displayPopup {get;set;}
    private Workspace__c movie;
    public String workId {get; set;}
    public Id projectid;
    private List<Id> photoIds;
    private Project__c plan;
    public List<Milestone__c> temmils;
    public List<Members__c> membs;
    public list<task> taskrecs;
    public boolean Level1{get;set;}
    public boolean Level2{get;set;}
    public boolean Level3{get;set;}
    public boolean Level4{get;set;}
    public boolean Level5{get;set;}
    public List<Profile> userprofile ;
    public List<Members__c> userrole;
    public List<Allocation_amount__c> parentid;  
    public List<Allocation_amount__c> ccid;  
    public List<user> ccowner; 
    public List<Members__c> plnMem ;
    public List<Costcentre__c> Costcenterowner;
    public List<String>mmemId;
    public Map<String, Allocation_amount__c > maps;
    Public string planid;
    public Date todate{get;set;}
    public List<progressbarClss>mrkList{get;set;}
    String tabInFocus;
    public Project__c pro{get;set;}
    public date startDate;
    public date endDate;
    public Activity__c act{get;set;}
    public List<Musqot_member__c> planMemberList ;
    public List<Milestone__c >milestoneList;
    public string sProgressText;
    public Decimal iProgress_value;
    public string displayblock;
    public map<id,id>ownerUserMap=new map<id,id>();
    
    // added by Narendra - for responsive design
    public Transient List<Attachment>atts{get;set;}
    public Transient Decimal fileSize{get;set;}
    public Transient String fileSize2{get;set;}
    public String fileType {get;set;}
    public String orgId{get;set;}
    public string workspaceId;
    public String Resp { get; 
                        set {
                            Resp = value;}
                       }
   public ProjectDetailsExtensionController (ApexPages.StandardController controller) {
        tabInFocus = System.currentPageReference().getParameters().get('tab');
        string i=ApexPages.currentPage().getParameters().get('sfdc.override');
        todate=system.today();
        this.controller = controller;
        mrkList=new List<progressbarClss>();
        deletUserNames=new List<string>();
        planMemberList=new List<Musqot_member__c>();
        this.plan = (Project__c)controller.getRecord();
        String atmid= ApexPages.currentPage().getParameters().get('atmid');
        String planid= ApexPages.currentPage().getParameters().get('id');
        workId= controller.getRecord().Id;
        showflist=false;
        ownerBool=true;
        try{
            pro = new Project__c();
            pro=[SELECT Id, ownerId,owner.name, Starts_date__c, 
                 Ends_date__c ,(SELECT Id from Workspaces_del__r)
                 FROM Project__c WHERE Id=:planid];
                
            startDate = pro.Starts_date__c;
            endDate = pro.Ends_date__c;
            for(Workspace__c w:pro.Workspaces_del__r){
                workspaceId= w.id;
            } 
        }catch(exception e){} 
        MusqotUtility.innerClass musIncls = MusqotUtility.securitySetting(workId);
        Level1 = musIncls.l1;
        Level2 = musIncls.l2;
        Level3 = musIncls.l3;
        Level4 = musIncls.l4;
        Level5 = musIncls.l5;
        workSpace();
        //--Raju fetch Plan members from Musqot_member__c---
        act=[SELECT Id, Name, Plan_access_controll__c,keycode__c FROM Activity__c limit 1];
        orgId = UserInfo.getOrganizationId();
        orgId = orgId.substring(0,orgId.length()-2);
        isProjectPerformance=false;
        applyEditionSetting();
       listWrapper = new List<WrapperClass>();
        
       planMemberList = [Select id,userid__c,userid__r.Name,userid__r.Email,userid__r.UserRoleID, 
                         userid__r.department,userid__r.smallphotourl, Plan__c,Plan__r.ownerid,Role__c 
                         FROM Musqot_member__c 
                         where Plan__c=:workId ORDER BY Name];  
      
        
        Map<Id,Musqot_member__c>planMemberRole=new Map<Id,Musqot_member__c>();
        if(planMemberList.size()>0){
            for(Musqot_member__c pm: planMemberList){
                planMemberRole.put(pm.userid__r.UserRoleId,pm);
            }
            Map<Id,string>userMemberRole=new Map<Id,string>();
            Map<Id,string>PlanOwners=new Map<Id,string>();
             list<Members__c>pOwner = [SELECT ProjUsers__c, Role__c  
                                      FROM Members__c 
                                      where Role__c = 'Owner' 
                                      and ( ProjMembers__C =:planid  or  
                                           SubProjMembers__r.Parent_project__c =:planid or  Marketingmebers__r.Plan__c=:planid )
                                      ORDER BY Name]; 
            for(Members__c PO:pOwner){
                PlanOwners.put(PO.ProjUsers__c,PO.Role__c);
            }
            list<UserRole>uRole1=[select Name from UserRole 
                                  WHERE id IN:planMemberRole.keySet()];  
            for(UserRole ur:uRole1){
                userMemberRole.put(ur.id,ur.Name);
            }
            for(Musqot_member__c pm: planMemberList){
                string memberRole;
                string projown ;
                if(PlanOwners.containsKey(pm.userid__c))
                {
                     projown = 'Owner';
                }
                else
                {
                     projown = '';
                }
                if(pm.userid__r.UserRoleId<>null){
                     memberRole=userMemberRole.get(pm.userid__r.UserRoleId);   
                }
                else
                {
                     memberRole = '';
                }
                listWrapper.add(new WrapperClass(pm,memberRole, projown));
            }
        } 
        
        Project__c pRec=[SELECT id,Name,
                         	(select Id,OwnerId,owner.name from Subproject_1__r),
                         	(SELECT Id,OwnerId,owner.name FROM Marketing_activities__r)
                         FROM Project__c 
                         WHERE id=:workId];
             for(Subproject__c s:prec.Subproject_1__r){
                 ownerUserMap.put(s.ownerId,s.id);
             } 
             for(Marketing_activity__c m:prec.Marketing_activities__r){
                ownerUserMap.put(m.ownerId,m.id);
             }                         
    }
    //redirect to  PlanEditPage
    public PageReference gotoProjectEdit() {
       String planid= ApexPages.currentPage().getParameters().get('id');
        PageReference pgr;   
        If(Resp==Null){
            Resp='';
        }
        pgr =new PageReference ('/apex/PlanEditPage'+Resp+'?ProjectId='+EncodingUtil.urlEncode(planid,'UTF-8')+'&planid='+EncodingUtil.urlEncode(workId,'UTF-8'));
        return pgr;
    }
    //redirect to TaskEditpage
    public PageReference gotoTaskEdit() {
        String taskid= ApexPages.currentPage().getParameters().get('taskid');
        PageReference pgr; 
        If (Resp==Null){
            Resp='';
        }
        pgr =new PageReference ('/apex/TaskEditpage'+Resp+'?taskId='+EncodingUtil.urlEncode(taskid,'UTF-8')+'&planid='+EncodingUtil.urlEncode(workId,'UTF-8'));
        return pgr;
    }
    //redirect to std_workspace page
    Public PageReference workSpace(){
        workSpaceList =new  List<Workspace__c>();
        workSpaceList=[select id,Name,Description__c,html_description__c,ProjectName__c,
                        (Select Id, Title From NotesAndAttachments) 
                       from Workspace__c 
                       where ProjectName__c =:workId limit 1];
        system.debug('@@@@'+workSpaceList);
        AttachmentsList = New List<NoteAndAttachMent>();
        if(workSpaceList.size()>0){
            for(Workspace__c Item: workSpaceList){
                for(NoteAndAttachMent NA :Item.NotesAndAttachments){
                    AttachmentsList.add(NA);
                }
            
        }
            
        // added by Narendra - for responsive design - start -
        List<Id> attsIds = new List<Id>();
        for(NoteAndAttachMent naa : AttachmentsList) {
            attsIds.add(naa.Id);
        }
        Decimal tempfilesize;
        atts = [Select id,Name, Description, Body,BodyLength, OwnerID,owner.name, 
                CreatedByID, IsPrivate,contentType FROM Attachment WHERE id IN :attsIds];
            if(atts.size() > 0){
                for(Attachment att : atts) {
                    tempfilesize = att.BodyLength;
                    if(att.BodyLength > (1024*1024*524)){
                        tempfilesize  = Decimal.valueOf(att.BodyLength);
                        fileSize=tempfilesize.divide(1024*1024*1024,1);
                        fileSize2=' GB';
                    }
                    else if(att.BodyLength > (1024*524)){
                        tempfilesize  = Decimal.valueOf(att.BodyLength);
                        fileSize=tempfilesize.divide(1024*1024,1);
                        fileSize2=' MB';
                    }
                    else if(att.BodyLength > 1024){
                        tempfilesize = Decimal.valueOf(att.BodyLength);
                        fileSize=tempfilesize.divide(1024,1);
                        fileSize2=' KB';             
                    }
                    else {
                        tempfilesize = Decimal.valueOf(att.BodyLength);
                        fileSize=tempfilesize.divide(1,0);
                        fileSize2=' B';             
                    }
                    // check content type
                    if(att.contentType == 'application/msword'){fileType = '.doc';} 
                    else if(att.contentType == 'application/ms-excel'){fileType = '.xls';} 
                    else if(att.contentType == 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'){fileType = '.docx';}  
                    else if(att.contentType == 'text/calendar'){fileType = '.ics';} 
                    else if(att.contentType == 'application/x-indesign'){fileType = '.indd';} 
                    else if(att.contentType == 'application/vnd.oasis.opendocument.database'){fileType = '.odb';} 
                    else if(att.contentType == 'application/vnd.oasis.opendocument.chart'){fileType = '.odc';} 
                    else if(att.contentType == 'application/vnd.oasis.opendocument.formula'){fileType = '.odf';} 
                    else if(att.contentType == 'application/vnd.oasis.opendocument.graphics'){fileType = '.odg';} 
                    else if(att.contentType == 'application/vnd.oasis.opendocument.image'){fileType = '.odi';} 
                    //else if(att.contentType == 'application/vnd.oasis.opendocument.presentation'){fileType = '.odp';} 
                    else if(att.contentType == 'application/vnd.oasis.opendocument.spreadsheet'){fileType = '.ods';}        
                    else if(att.contentType == 'application/vnd.oasis.opendocument.text'){fileType = '.odt';} 
                    else if(att.contentType == 'application/pdf'){fileType = 'PDF';} 
                    else if(att.contentType == 'application/vnd.openxmlformats-officedocument.presentationml.slideshow'){fileType = '.ppsx';} 
                    else if(att.contentType == 'application/vnd.ms-powerpoint'){fileType = '.ppt';}     
                    else if(att.contentType == 'application/vnd.openxmlformats-officedocument.presentationml.presentation'){fileType = '.pptx';} 
                    else if(att.contentType == 'application/x-mspublisher'){fileType = '.pub';}        
                    else if(att.contentType.startsWith('application/vnd.quark')){fileType = '.qxp';} 
                    else if(att.contentType == 'application/x-rar-compressed'){fileType = '.rar';} 
                    else if(att.contentType == 'application/vnd.stardivision.draw'){fileType = '.sda';} 
                    else if(att.contentType == 'application/vnd.stardivision.calc'){fileType = '.sdc';}  
                    else if(att.contentType == 'application/vnd.stardivision.impress'){fileType = '.sdd';} 
                    else if(att.contentType == 'application/vnd.stardivision.writer'){fileType = '.sdw';}        
                    else if(att.contentType == 'application/x-stuffit'){fileType = '.sit';} 
                    else if(att.contentType == 'application/vnd.openxmlformats-officedocument.presentationml.slide'){fileType = '.sldx';} 
                    else if(att.contentType == 'application/vnd.stardivision.math'){fileType = '.smf';} 
                    else if(att.contentType == 'application/x-shockwave-flash'){fileType = '.swf';}  
                    else if(att.contentType == 'application/vnd.sun.xml.calc'){fileType = '.sxc';} 
                    else if(att.contentType == 'application/vnd.sun.xml.draw'){fileType = '.sxd';} 
                    else if(att.contentType == 'application/vnd.sun.xml.impress'){fileType = '.sxi';} 
                    else if(att.contentType == 'application/vnd.sun.xml.math'){fileType = '.sxm';} 
                    else if(att.contentType == 'application/vnd.sun.xml.writer'){fileType = '.sxw';} 
                    else if(att.contentType == 'text/plain'){fileType = 'Text';} 
                    else if(att.contentType == 'application/vnd.ms-wpl'){fileType = '.wpl';} 
                    else if(att.contentType == 'application/vnd.ms-works'){fileType = '.wps';} 
                    else if(att.contentType == 'application/x-mswrite'){fileType = '.wri';} 
                    else if(att.contentType == 'application/vnd.ms-excel'){fileType = '.xls';} 
                    else if(att.contentType == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'){fileType = '.xlsx';} 
                    else if(att.contentType == 'application/vnd.ms-xpsdocument'){fileType = '.xps';}
                    else if(att.contentType == 'application/zip'){fileType = '.zip';}
                    else if(att.contentType.startsWith('audio/')){fileType = 'Audio';}
                    else if(att.contentType.startsWith('image/')){fileType = 'Image';}
                    else if(att.contentType.startsWith('video/')){fileType = 'Video';}
                    else {fileType = 'Other';}
                }
            }
        // added by Narendra - for responsive design - end -
        If(Resp==Null){
            Resp='';
        }
        PageReference WorkSpacPage=new PageReference('/apex/std_workspace'+Resp+'?id='+workSpaceList[0].id+'&plnId='+EncodingUtil.urlEncode(workId,'UTF-8'));
        WorkSpacPage.setredirect(true);
        return WorkSpacPage; 
       }
        return null;
    }
   /********************************************
      workRedirect():create  Workspace__c record
    ********************************************/
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
    /***************************************************
      gotoattchmentpage():redirect to AttachmentInfopage 
    ****************************************************/
    public PageReference gotoattchmentpage(){
        String atmid= ApexPages.currentPage().getParameters().get('atmid');
        PageReference pgr;  
        if(atmid<>null){  
            pgr =new PageReference ('/apex/AttachmentInfopage?attid='+EncodingUtil.urlEncode(atmid,'UTF-8')+'&planid='+EncodingUtil.urlEncode(workId,'UTF-8'));
            return pgr;
        }
        return null;
    }
    /**************************************************** 
      Savedoc():This is for to display the attachmentpage 
    *****************************************************/
    Public PageReference Savedoc(){
        workSpaceList =new  List<Workspace__c>();
        workSpaceList=[select id,Name,Description__c,html_description__c,ProjectName__c,
                            (Select Id, Title From NotesAndAttachments),
                            (Select Id, Name From Attachments) 
                       from Workspace__c 
                       where ProjectName__c =:workId limit 1];  
        PageReference WorkSpacPage=new PageReference('/apex/attachmentpage?id='+workSpaceList[0].id+'&plnId='+EncodingUtil.urlEncode(workId,'UTF-8'));
        WorkSpacPage.setredirect(true);
        return WorkSpacPage;
    }
     /**************************************************
      getsubRecs():it returns list of subproject records
      **************************************************/
    public List<Subproject__c> getsubRecs(){
        List<Subproject__c> tempRecs = new List<Subproject__c>();
        tempRecs = [select Id, Name, CreatedById,CreatedDate,Starts_date__c,Project_type__c,Project_type__r.name, Ends_date__c,Project_del__c,Status__c,StatusImage__c 
                    from Subproject__c 
                    where Project_del__c = null AND Parent_project__c =:workId order by Name ];
        return tempRecs;
    }    
    
   /**************************************
     newPoject():redirect to  projectpage
    **************************************/
    Public PageReference newPoject(){
        plan = [select Id,Name from Project__c where Id =:workId limit 1];
        String nm = plan.Name;         
        PageReference np = new PageReference ('/apex/projectpage?planid='+EncodingUtil.urlEncode(plan.Id,'UTF-8'));
        return np;
    }
    
     /************************************** 
      newMilstone():redirect to MilestonePage
     ***************************************/
    Public PageReference newMilstone(){
        temmils = [select Id,Name 
                   from Milestone__c 
                   where Plan__c=:workId limit 1];
        PageReference milestonepage=new PageReference('/apex/MilestonePage?&planid='+EncodingUtil.urlEncode(workId,'UTF-8'));
        milestonepage.setredirect(true);
        return milestonepage; 
    }
    
      /************************************************
      gotoMilestoneEdit():redirect to MilestoneEditpage
      **************************************************/
    public PageReference gotoMilestoneEdit(){
        String mileId= ApexPages.currentPage().getParameters().get('mileId'); 
        PageReference pgr;
        if(mileId<>null){       
            pgr =new PageReference ('/apex/MilestoneEditpage?planid='+EncodingUtil.urlEncode(workId,'UTF-8')+'&mileId='+EncodingUtil.urlEncode(mileId,'UTF-8'));
            return pgr;
        }
        return null;
    }
     /**************************************************
      getmilston():it returns list of milestone records
     **************************************************/
    public List<progressbarClss> getmilston(){
        
       milestoneList=[SELECT Id, Name, Status__c,  Target_number__c, Target_number_outcome__c,
                      Milestone_type__c, Targetdate__c
                      ,Target_Project__r.Name, Target_Marketing_activity__r.Name, Target_Socialmedia__r.Name,
                      Target_ERP_Sales__r.Name, Target_CRM_Settings__r.Name
                      FROM Milestone__c  
                      where Plan__c=:Workid  AND Project__c=null 
                      Order by targetdate__c limit 100]; 

       if(milestoneList<>null){
      
        for(Milestone__c Mile1:milestoneList){ 
            if(Mile1.Milestone_type__c ==3 || Mile1.Milestone_type__c ==4 || Mile1.Milestone_type__c ==5){ 
              
                If (Mile1.Target_number_outcome__c > 0 && Mile1.Target_number__c > 0){
                    iProgress_value = (Mile1.Target_number_outcome__c/Mile1.Target_number__c)*100;  //calclute the iProgress_value   
                    sProgressText = iProgress_value.setscale(0)+'%'; 
                    if(sProgressText.length( )>3)
                    sProgressText = sProgressText.substring(0,3)+'%';//Round the value up to 3digits
                  }
                  else{
                        iProgress_value =0;
                        sProgressText='0%';
                  }
             }
             
               else if(Mile1.Milestone_type__c ==1 || Mile1.Milestone_type__c ==2 ){
                      iProgress_value=0;
                      Mile1.Target_number__c=null;
             }
              mrkList.add(new progressbarClss(Mile1,iProgress_value,sProgressText,displayblock));
       } 
        return mrkList;
       } 
       return null;  
    } 
  // wrapper class to hold progressbar data
  public class progressbarClss{
        public String sProgressText{ get;set;}
        public musqot__Milestone__c mil{get;set;}
        public double iProgress_value{get;set;}
        public string displayblock{get;set;}
        public progressbarClss(musqot__Milestone__c ml,Decimal iPValue,String dblock,string spText){
            this.sProgressText=spText;
            this.mil=ml;
            this.iProgress_value=iPValue;
            this.displayblock=dblock;
        }
    }
    
    /***************************************
     newmember():redirect  to memberobj page
     ***************************************/
     Public PageReference newmember(){
        PageReference memberobj=new PageReference('/apex/memberobj?planid='+EncodingUtil.urlEncode(workId,'UTF-8'));
        memberobj.setredirect(true);
        return memberobj; 
     }
    
    /***************************************
     newmember():redirect  to memberobj page
     ***************************************/
     Public PageReference planNewmember(){
        PageReference memberobj=new PageReference('/apex/Planmember?planid='+EncodingUtil.urlEncode(workId,'UTF-8'));
        memberobj.setredirect(true);
        return memberobj; 
     }
     /**********************************************
      getmembers():it returns list of member records
      **********************************************/
    
     public List<Members__c > getmembers(){ 
        plnMem =new  List<Members__c>();
        mmemId=new List<String>();
        maps= new Map<String, Allocation_amount__c >();
        List<Allocation_amount__c> listrec=[Select Costcentre__r.Owner.Name,Costcentre__r.ownerid, Costcentre__r.name 
                                            from Allocation_amount__c 
                                            where To_Plan__c =:workId limit 100];
        list<Members__c> tmpList=[Select id, ProjMembers__c, ProjUsers__c 
                                  FROM Members__c 
                                  WHERE ProjUsers__c =:pro.ownerId and Role__c='owner' limit 1];
        if(listrec.size()>0){
            for(Allocation_amount__c all:listrec){
                if(all.Costcentre__r.name<>null){
                   if(tmpList<>null){
                    if(all.Costcentre__r.OwnerId<> tmpList[0].ProjUsers__c){
                        if(!maps.containsKey(all.Costcentre__r.OwnerId)) 
                            maps.put(all.Costcentre__r.OwnerId,all);
                     }
                    } 
                }
            } 
         }                           
        List<Allocation_amount__c> newList = maps.values();
        for(Allocation_amount__c newre:newList){
            mmemId.add(newre.Costcentre__r.OwnerId);
            
        }
        plnMem=[Select id, ProjMembers__c, ProjUsers__r.email, ProjUsers__c, ProjUsers__r.name, SubProjMembers__c, Role__c, Type__c,ProjUsers__r.smallphotourl 
                FROM Members__c 
                where ProjMembers__c=:workId and SubProjMembers__c=null and ProjUsers__c <>:mmemId and Role__c<>'owner' limit 100 ];
        list<Members__c>membrList=[Select id, ProjMembers__c, ProjUsers__r.email ,ProjUsers__c,ProjUsers__r.name, ProjUsers__r.smallphotourl , SubProjMembers__c, Role__c, Type__c 
                                   FROM Members__c 
                                   where ProjMembers__c=:workId AND SubProjMembers__c=null and Role__c='owner' limit 1];
        membrList.addAll(plnMem);
        return membrList; 
        
    } 
     /****************************************************************
      getparentmembers():it returns list of costcenter member records
      ***************************************************************/
   
    public list<Allocation_amount__c > getparentmembers(){
        List<Allocation_amount__c> listrec=[Select Costcentre__r.Owner.Name, Costcentre__r.cc_Owner__c,Costcentre__r.cc_Owner__r.smallphotourl,
                                            	Costcentre__r.cc_Owner__r.department, Costcentre__r.name ,Costcentre__r.Email__c  
                                            from Allocation_amount__c 
                                            where  To_Plan__c =:workId limit 100];
        list<Members__c> tmpList=[Select id, ProjMembers__c, ProjUsers__c, ProjUsers__r.name, ProjUsers__r.smallphotourl,ProjUsers__r.department, Role__c, Type__c, ProjUsers__r.Email 
                                  FROM Members__c 
                                  WHERE ProjUsers__c =:pro.ownerId and Role__c='owner'limit 1];
        
        Map<String, Allocation_amount__c > maps= new Map<String, Allocation_amount__c >();
        for(Allocation_amount__c all: listrec){
            if(all.Costcentre__r.name<>null){
            if(tmpList<>null){
                if(all.Costcentre__r.OwnerId<> tmpList[0].ProjUsers__c){
                    if(!maps.containsKey(all.Costcentre__r.OwnerId)) 
                        maps.put(all.Costcentre__r.OwnerId,all);
                 }
                } 
            }
        }                        
        List<Allocation_amount__c> newList = maps.values();
        return newlist; 
    }
    /********************************************
     gotoMemberEdit():redirect to  Membereditpage
    *********************************************/    
    public PageReference gotoMemberEdit() {
        String mbrId = ApexPages.currentPage().getParameters().get('mbrId'); 
        PageReference pgr;
        if(mbrId<>null){       
            pgr =new PageReference ('/apex/Membereditpage?planid='+EncodingUtil.urlEncode(workId,'UTF-8')+'&mbrId='+EncodingUtil.urlEncode(mbrId,'UTF-8'));
            return pgr;
        }
        return null;
    }
  
     /******************************* 
     newtask(): redirect to Task page
     ********************************/   
    Public PageReference newtask(){
        taskrecs= [Select Id, WhoId, WhatId, Subject,status, ActivityDate,CreatedById, 
                   Priority, OwnerId,owner.name, Description, IsDeleted, AccountId, 
                   IsClosed,  Allocated_h__c, Outcome_h__c, Task_description__c,
                   Task_name__c, musqot__StatusImage__c FROM Task where id=:workId limit 400];
        PageReference task1=new PageReference('/apex/Task?planid='+EncodingUtil.urlEncode(workId,'UTF-8'));
        task1.setredirect(true);
        return task1; 
    }
     /********************************************
     gettaskrecs():it returns list of task records
     *********************************************/   
    public List<Task> gettaskrecs(){
        return [Select Id, WhoId, WhatId, CreatedById, Subject,status, ActivityDate, Status_image_id__c,
                StatusImage__c,Priority, OwnerId,owner.name, Description, IsDeleted, AccountId, IsClosed,
                Allocated_h__c, Outcome_h__c,Task_description__c,Task_name__c 
                FROM Task where whatid=:workId order by ActivityDate limit 400];
    }
    
     /******************************************
     customset(): redirect to PlanOverview page
     ******************************************/   
    public PageReference customset(){
        String planid= ApexPages.currentPage().getParameters().get('id');
        PageReference pgr;   
        pgr =new PageReference ('/apex/PlanOverview?ProjectId='+EncodingUtil.urlEncode(planid,'UTF-8')+'&planid='+EncodingUtil.urlEncode(workId,'UTF-8'));
        return pgr;
    }
    /********************************************************************
     getGadgetHTMLContent():This is for display contant in rich text area.
    *********************************************************************/  
    public Component.Apex.OutputText getGadgetHTMLContent(){
        Component.Apex.OutputText oppText = new Component.Apex.OutputText(escape = false);
        if(workSpaceList.size()>0){
           oppText.value = workSpaceList[0].html_description__c;       //gadgetcontent is the variable which holds the HTML content
         }
        return oppText ;
    }
    /************************************************************************
    getTabInFocus():This is for display particular tab in project details page.
    /*************************************************************************/  
    public String getTabInFocus(){
        return tabInFocus;
    }
    public void setTabInFocus(String s ) {
        this.tabInFocus = s;
    }
  
   //Raju to add Plan members here---
  
   public List<WrapperClass> listWrapper{get;set;}
   public list<string>deletUserNames{get;set;}
   public Boolean allBool {get;set;}  
    
    public class WrapperClass {
        public Boolean checked {get;set;}
        public Musqot_member__c pmem{get;set;}
        public string powner{get;set;}
        public string pmRole{get;set;}
        public WrapperClass(Musqot_member__c pmem, string pmRole, string powner  ){
            this.pmem = pmem;
            this.pmRole = pmRole;
            this.powner = powner;
        }
    }
    //To delete selected members in a plan members list--
    public String activeTab{get;set;}
    public boolean ownerBool{get;set;}
    public  list<Members__c>tmpList;
    public List<string> selectedDelUser{get;set;}
    public String commaSepratedList{get;set;}
    public PageReference delMember(){
        selectedDelUser=new list<string>();
        List<Musqot_member__c> listMemForDel = new List<Musqot_member__c>();
        List<WrapperClass> listTempWrapper = new List<WrapperClass>();
        for(WrapperClass w:listWrapper){
            if(w.checked) {
                listMemForDel.add(w.pmem);
            }
        }
        if(listMemForDel.size()>0){
            delete listMemForDel;
            PageReference p = new Apexpages.Standardcontroller(pro).view();
            p.setRedirect(true);    
            return p;
        }
        return null;
    }
    //--End---  */
    //Process to get selected users to delet---
    
    public boolean hidetext{get;set;}
    public PageReference ownerSelected() {
        selectedDelUser=new list<string>();
        tmpList=[Select id, ProjMembers__c, ProjUsers__c ,ProjUsers__r.Name
                 FROM Members__c 
                 WHERE ProjMembers__c=:workId and Role__c='owner' limit 1];
        for(WrapperClass w:listWrapper){
            if(w.checked){
                if(w.pmem.userid__c<>tmpList[0].ProjUsers__c){
                    ownerBool=false;
                    String commaSepratedList='';
                    selectedDelUser.add(w.pmem.userid__r.Name);
                    for(string str:selectedDelUser){
                        commaSepratedList += str + ',' ;
                    }
                } 
                if(w.pmem.userid__c==tmpList[0].ProjUsers__c){
                    ownerBool=true;
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Record owner is never deleted ,'+tmpList[0].ProjUsers__r.Name+' is owner of record');
                    ApexPages.addMessage(myMsg);   
                }  
            }else
                ownerBool=false;
        }
        return null;
    }
    //--Raju--adding applyEditionSetting method--
    public boolean isProjectPerformance{get;set;}
    public void applyEditionSetting(){
        // get KEYCODE
        String keycode = act.keycode__c;
        MusqotUtility.decryptKeycode(keycode);
        boolean isValid = false;
        String decryptedEdition = MusqotUtility.edition;
        if(MusqotUtility.organizationId.equals(orgId)){
            if(!decryptedEdition.equals('Invalid')){
                isValid = true;
            }else {
                isValid = false;
            }
        }else{
            isValid = false;
        }
        if(isValid) {
            if(decryptedEdition=='Trial'){
			     isProjectPerformance=true;
			}
			else if(decryptedEdition=='Standard'){
				isProjectPerformance=false;
			}
			else if(decryptedEdition=='Professional'){
				isProjectPerformance=true;
			}
			else if(decryptedEdition=='Enterprise'){
				isProjectPerformance=true;
			}
			else if(decryptedEdition=='Custom'){
			      if(MusqotUtility.projectPerformance)
				    isProjectPerformance=true;
				 else
					isProjectPerformance=false;
			}
        }else{
           
        }   
    } 
    //--End--
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
        workspaceAttchmentList=[SELECT Id, Name FROM Attachment WHERE parentId =:workspaceId];
        for(Attachment a:workspaceAttchmentList){ 
            wc=new AttachWrapper();
            wc.Id=a.id;
            trimedName=a.name;
            if(trimedName.containsAny('.'))
                wc.Name=trimedName.substring(0,trimedName.indexOf('.'));
            else 
                wc.Name=a.name;
            AttWrperlst.add(wc);
        }
        return AttWrperlst;
    } 
    //---End----
 }