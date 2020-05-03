/*******************************************************
Class Name: Marketingactivity 
Author:G Janardhanreddy       Last modified by:Raju
Date:27/6/2014                 Date:18/12/2015
Des:Adding attachment download functionality.(264-288)
********©2013 Musqot marketing technology Pvt ltd *******/
public with sharing class Marketingactivity {
    public string name{get;set;}
    private ApexPages.standardController controller;
    Public list<Workspace__c >workSpaceList{get;set;}
    public list<NoteAndAttachMent> AttachmentsList{get;set;}
    public boolean displayPopup {get; set;}
    public Id subprojectid;
    public String WorkId{get;set;}
    private List<Id> photoIds;
    public String marktingid;
    private Marketing_activity__c mrkid;
    public list<task> taskrecs2;
    public list<Marketing_activity_dates__c> pubdatelist;
    public boolean Level1{get;set;}
    public boolean Level2{get;set;}
    public boolean Level3{get;set;}
    public List<Profile> userprofile ;
    public List<Members__c> userrole;
    public List<Allocation_amount__c> parentid;  
    public List <Costcentre__c> Costcenterowner;
    public Marketing_activity__c marks;
    public string  subPrjId;
    String tabInFocus;
    String tabId;
    public List<Members__c> parenttmpList;
    public Map<String, musqot__Members__c> mrbMps;
    public musqot__Members__c tmpList;
    public Marketing_activity__c tester {get;set;}
    public string workspaceId;
    public string activityStartDate{get;set;}
    public string activityEndDate{get;set;}
    public Marketingactivity(ApexPages.StandardController controller) {
        this.controller = controller;
        this.tester = (Marketing_activity__c )controller.getRecord();
        workId= controller.getRecord().Id;
        tabInFocus = System.currentPageReference().getParameters().get('tab');
        subPrjId = ApexPages.currentPage().getParameters().get('id');
        marktingid = ApexPages.currentPage().getParameters().get('id');
        marks = new musqot__Marketing_activity__c();       
        marks = [select Id,Project__c,Plan__c, Starts_date__c,Ends_date__c,(SELECT Id from Workspaces__r)
                 from Marketing_activity__c where Id =:marktingid limit 1];  
        try{
            activityStartDate=string.valueOfGmt(marks.Starts_date__c);
            activityStartDate=activityStartDate.substring(0,10);
            activityEndDate=string.valueOfGmt(marks.Ends_date__c);
            activityEndDate=activityEndDate.substring(0,10);
        }catch(exception e){}
       
        for(Workspace__c w:marks.Workspaces__r){
            workspaceId= w.id;
        } 
        MusqotUtility.innerClass musIncls = MusqotUtility.markertsecuritySetting(workId);
        Level1 = musIncls.l1;
        Level2 = musIncls.l2;
        Level3 = musIncls.l3;
        workSpace();         
    }
    /****************************************************
getTabInFocus(): redirect particular  related page tab 
*****************************************************/
    public String getTabInFocus() {
        return tabInFocus;
    }
    
    public void setTabInFocus(String s ) {
        this.tabInFocus = s;
    }
    /*************************************************************
workSpace(): redirects to std_workspacepage and add attachments  
***************************************************************/
    Public PageReference workSpace()
    {
        workSpaceList =new list<Workspace__c>();
        workSpaceList=[select id,Name,Description__c,html_description__c,
                       Marketing_activity__c,(Select Id, Title From NotesAndAttachments) 
                       from Workspace__c where Marketing_activity__c=:workId];  
        AttachmentsList = New List<NoteAndAttachMent>();
        for(Workspace__c Item: workSpaceList){
            for(NoteAndAttachMent NA :Item.NotesAndAttachments){
                AttachmentsList.add(NA);
            }
        }
        PageReference WorkSpacPage=new PageReference('/apex/std_workspace?id='+workSpaceList[0].id+'&marktingid='+EncodingUtil.urlEncode(workId ,'UTF-8'));
        WorkSpacPage.setredirect(true);
        return WorkSpacPage;
    }
    /***************************************
gotoTaskEdit():Redirects to TaskEditpage
****************************************/
    public PageReference gotoTaskEdit() {
        String taskid= ApexPages.currentPage().getParameters().get('taskid');
        PageReference pgr;   
        pgr =new PageReference ('/apex/TaskEditpage?taskId='+EncodingUtil.urlEncode(taskid ,'UTF-8')+'&markid='+EncodingUtil.urlEncode(marktingid ,'UTF-8'));
        return pgr;
    }
    /********************************************
gotoattchmentpage(): redirects to AttachmentInfopage  
*********************************************/
    public PageReference gotoattchmentpage(){
        String atmid= ApexPages.currentPage().getParameters().get('atmid');
        PageReference pgr;  
        if(atmid<>null){  
            pgr =new PageReference ('/apex/AttachmentInfopage?attid='+atmid+'&mrkid='+EncodingUtil.urlEncode(workId ,'UTF-8'));
            return pgr;
        }
        return null;
    }
    /*********************************************************
gotomarketingEdit():redirects to Marketingactivityeditpage  
**********************************************************/
    public PageReference gotomarketingEdit() {
        String marktid = ApexPages.currentPage().getParameters().get('id ');
        PageReference pgr;
        pgr =new PageReference ('/apex/Marketingactivityeditpage?projectid='+subPrjId +'&marktid='+EncodingUtil.urlEncode(workId ,'UTF-8'));
        return pgr;
    }
    /***********************************
myfile: Attach new file
getmyfile(): Get the Attached files
************************************/ 
    Public Attachment myfile;
    Public Attachment getmyfile()
    {
        myfile = new Attachment();
        return myfile;
    }
    /**************************************************************
Savedoc(): redirects to attachmentpage and update the attachment
****************************************************************/
    Public PageReference Savedoc()
    {
        workSpaceList =new  List<Workspace__c>();
        workSpaceList=[select id,Name,Description__c,html_description__c,Marketing_activity__c,
                       (Select Id, Title From NotesAndAttachments),
                       (Select Id, Name From Attachments) from Workspace__c where Marketing_activity__c=:workId];  
        PageReference WorkSpacPage=new PageReference('/apex/attachmentpage?id='+workSpaceList[0].id+'&mrkId='+EncodingUtil.urlEncode(workId,'UTF-8'));
        WorkSpacPage.setredirect(true);
        return WorkSpacPage;
    }
    /*********************************************************
getmembers(): It will return members for marketingactivity
**********************************************************/
    public List<Members__c > getmembers(){
        list<string>mrId=new list<string>();
        mrbMps= new Map<String, musqot__Members__c>();                     
        list<musqot__Members__c>parList=mrbMps.values();
        for(musqot__Members__c mu:parList){
            mrId.add(mu.ProjUsers__c);
        }
        return [Select id,Name, ProjMembers__c, ProjUsers__c,ProjUsers__r.name,
                ProjUsers__r.smallphotourl, SubProjMembers__c, Role__c, Type__c,
                User_Email__c FROM Members__c WHERE Marketingmebers__c =:marktingid 
                AND ProjUsers__c<>:mrId  order by ProjUsers__r.name  limit 100];
    }
    /************************************************
getparentmembers(): returns list of parentmembers 
*************************************************/     
    public list<Members__c > getparentmembers(){
        list<string>mrId=new list<string>();
        set<Members__c>mmeSet=new set<Members__c>();
        List<Members__c>mrkMbrList=[Select id,Name, ProjMembers__c, ProjUsers__c,
                                    ProjUsers__r.name,ProjUsers__r.smallphotourl, SubProjMembers__c,
                                    Role__c, Type__c, User_Email__c FROM Members__c WHERE 
                                    Marketingmebers__c =:marktingid and musqot__Role__c<>'owner' limit 100];
        for(Members__c mrk:mrkMbrList){
            mrId.add(mrk.musqot__ProjUsers__c);
        }
        List<Members__c> parentmbrList = new List<Members__c>();
        musqot__Members__c tmpList=[Select id, musqot__ProjMembers__c, 
                                    musqot__ProjUsers__c,ProjUsers__r.smallphotourl, 
                                    musqot__SubProjMembers__c, musqot__Role__c, 
                                    musqot__Type__c, musqot__User_Email__c 
                                    FROM musqot__Members__c WHERE Marketingmebers__c =:marktingid  
                                    and musqot__Role__c='owner' ];
        
        parenttmpList= [Select id, ProjMembers__c, ProjUsers__c,ProjUsers__r.name,ProjUsers__r.smallphotourl, SubProjMembers__c, Role__c, User_Email__c 
                        FROM Members__c  
                        WHERE Role__c <> 'Viewer' and ( SubProjMembers__c =:marks.musqot__Project__c or ProjMembers__c =:marks.musqot__Plan__c+'')and (musqot__ProjUsers__c <>:tmpList.musqot__ProjUsers__c) AND musqot__ProjUsers__c<>:mrId order by ProjUsers__r.name  limit 100];//
        
        for(Members__c m : parenttmpList){
            if(m.ProjMembers__c<>null){
                m.Role__c = 'Plan '+m.Role__c;
                parentmbrList.add(m);                
            } 
            else{
                m.Role__c = 'Project '+m.Role__c;
                parentmbrList.add(m);                
            } 
        }
        Map<String, musqot__Members__c> mrbMps= new Map<String, musqot__Members__c>();
        for(musqot__Members__c mrb : parenttmpList){
            if(mrb.ProjUsers__c<>null){
                if(!mrbMps.containsKey(mrb.ProjUsers__c)) 
                    mrbMps.put(mrb.ProjUsers__c,mrb);
            } 
        }                        
        list<musqot__Members__c>parList= mrbMps.values();
        return parList;     
    }
    /***************************************
newMember(): redirects to memberobj page
****************************************/ 
    Public PageReference newMember(){
        PageReference memberobj=new PageReference('/apex/memberobj?mrk='+EncodingUtil.urlEncode(marktingid,'UTF-8')+'&planid='+EncodingUtil.urlEncode(marks.musqot__Plan__c,'UTF-8'));
        memberobj.setredirect(true);
        return memberobj;
    }
    /********************************************
gotoMemberEdit(): redirects to Membereditpage
*********************************************/ 
    public PageReference gotoMemberEdit() {
        String mbrId = ApexPages.currentPage().getParameters().get('mbrId'); 
        PageReference pgr;
        if(mbrId<>null){       
            pgr =new PageReference ('/apex/Membereditpage?mrk='+workId+'&mbrId='+EncodingUtil.urlEncode(mbrId,'UTF-8'));
            return pgr;
        }
        return null;
    }
       /**************************************************
newtask():For multipublication date on a MA  
***************************************************/
    public List<Marketing_activity_dates__c> getpubdatelist(){
        return [Select Id, Name, Start_date__c, End_date__c , Marketing_activity__c
                FROM Marketing_activity_dates__c 
                where Marketing_activity__c=:marktingid limit 100];
    }
    Public PageReference newPubdate(){
        try{
            pubdatelist= [Select Id, Name, Start_date__c, End_date__c , Marketing_activity__c
                        FROM Marketing_activity_dates__c 
                        where Marketing_activity__c=:marktingid limit 100];
        }catch(exception e){}
        PageReference pDate=new PageReference('/apex/Task?mrkid='+EncodingUtil.urlEncode(marktingid,'UTF-8'));
        pDate.setredirect(true);
        return pDate; 
    } 
   /**************************************************
newtask():redirects to Task page and create new task   
***************************************************/ 
    Public PageReference newtask(){
        try{
            taskrecs2= [Select Id, WhoId, WhatId, Subject, ActivityDate, Status, Priority, OwnerId, Description, IsDeleted, 
                        AccountId, IsClosed,  Allocated_h__c, Outcome_h__c, Task_description__c,Task_name__c, StatusImage__c 
                        FROM Task 
                        where id=:marktingid limit 400];
        }catch(exception e){}
        PageReference task1=new PageReference('/apex/Task?mrkid='+EncodingUtil.urlEncode(marktingid,'UTF-8'));
        task1.setredirect(true);
        return task1; 
    }
    /*******************************************
gettaskrecs2(): returns list of task records   
********************************************/
    public List<Task> gettaskrecs2(){
        return [Select Id, WhoId, WhatId, Subject, ActivityDate, Status,  Priority, OwnerId,CreatedById, Description, IsDeleted, 
                    AccountId, IsClosed,  Allocated_h__c, Outcome_h__c,Task_description__c, Task_name__c, StatusImage__c  
                FROM Task 
                where whatid=:marktingid  order by ActivityDate limit 400];
    }
    /********************************************************************************
getGadgetHTMLContent(): show the images are used in std_workspacepage presentation 
**********************************************************************************/
    public Component.Apex.OutputText getGadgetHTMLContent(){
        Component.Apex.OutputText oppText = new Component.Apex.OutputText(escape = false);
        oppText.value = workSpaceList[0].html_description__c;   
        return oppText ;
    }
    /**********************************************
customset(): redirects to customrelatedlist page
************************************************/
    public PageReference customset(){
        PageReference pgr;   
        pgr =new PageReference ('/apex/customrelatedlist?ProjectId='+EncodingUtil.urlEncode(subPrjId,'UTF-8')+'&marktid='+EncodingUtil.urlEncode(workId,'UTF-8'));
        return pgr;
    }
    /**********************************************
delMrkRe():redirect to related parent page
************************************************/ 
    Public Pagereference delMrkRe(){ 
        //When Parent activity is deleted child records(activity dates) also deleted..
        delete([SELECT Id From Marketing_activity_dates__c where Marketing_activity__c=:marks.id limit 100]);
        delete marks;
        PageReference pr = new PageReference('/' + String.valueOf(tester.Id).substring(0,3));
        pr.setRedirect(true);
        return pr; 
    } 
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
    //--Raju--Redirect NewActivitydatePage from Activity detail page--
     public PageReference redirectNewDatesPage(){
        String marktid = ApexPages.currentPage().getParameters().get('id ');
        PageReference pgr;
        pgr =new PageReference ('/apex/ActivityDateRecordPage?marktid='+EncodingUtil.urlEncode(marktingid ,'UTF-8'));
        return pgr;
    }
     Public Pagereference goToActivityDatEditMode(){
        String pdateid= ApexPages.currentPage().getParameters().get('pdateid');
        PageReference pgr;   
        pgr =new PageReference ('/apex/ActivityDateRecordPage?pdateid='+EncodingUtil.urlEncode(pdateid,'UTF-8')+'&marktid='+EncodingUtil.urlEncode(marktingid ,'UTF-8'));
        return pgr;
    }
}