/*********************************************************************
Class Name: MemberController
Author:G Janardhanreddy        Last modified by:Raju GN
Date: 26/6/2014                Date: 26/10/2015 
Dec:Display the planmember list..
********©2013 Musqot marketing technology Pvt ltd *********************/
public with sharing class MemberController{
    private ApexPages.StandardController sc;
    public String projectid{get;set;}
    public String subprjid{get;set;}
    public String mrkId{get;set;}    
    public Members__c member{get;set;}
    public list<Members__c>planMemberList;
    public List<Musqot_member__c>planMemberFilterList;
    public List<Musqot_member__c>planMemberFinalFilterList;
    public set<Musqot_member__c>planMemberFilterSet;
    public Map<id,Members__c> planMemberMap=new Map<id,Members__c>();
    public set<Id>planMemberFilterIdSet;
    public  list<Activity__c> musAct{get;set;}
    public String message{get;set;}
    public boolean memberDisply{get;set;}
    public MemberController(ApexPages.StandardController sc){
        this.sc = sc;
        listWrapper = new List<WrapperClass>();
        planMemberFilterIdSet=new set<Id>();
        planMemberFilterSet=new set<Musqot_member__c>();
        planMemberFinalFilterList=new List<Musqot_member__c>();
        projectid = ApexPages.currentPage().getParameters().get('planid');                     
        subprjid = ApexPages.currentPage().getParameters().get('subid');
        mrkId = ApexPages.currentPage().getParameters().get('mrk');
        //musAct=new List<Activity__c>();
        message = '';
        memberDisply=false;
        if(mrkId<>null){
            planMemberList= [Select id,ProjMembers__c,ProjUsers__c,SubProjMembers__c,Marketingmebers__c 
                             FROM Members__c 
                             where Marketingmebers__c=:mrkId];
            
           // projectid=musqot__Plan__c.id;
            member = new Members__c (Marketingmebers__c = mrkId); 
        }
        else if(subprjid<>null){
            planMemberList= [Select id,ProjMembers__c,ProjUsers__c,SubProjMembers__c, Marketingmebers__c  
                             FROM Members__c 
                             where SubProjMembers__c=:subprjid];
            member = new Members__c (SubProjMembers__c = subprjid);
        }
        else if(projectid<>null){ 
            planMemberList= [Select id,ProjMembers__c,ProjUsers__c,SubProjMembers__c, Marketingmebers__c 
                             FROM Members__c 
                             where ProjMembers__c=:projectid];
            member = new Members__c (ProjMembers__c = projectid ); 
        }      
        musAct=[SELECT id,Name,Use_Allocation__c,Plan_access_controll__c  
                FROM Activity__c  limit 1];
        //--RAju -To get Plan members--       
        for(Members__c m:planMemberList){
            planMemberMap.put(m.ProjUsers__c,m);
        }  
        List<Musqot_member__c>planMembersList;
        //if(musAct.Plan_access_controll__c==true){
             planMembersList=[Select id,userid__c FROM Musqot_member__c userid__c 
                         WHERE userid__c  NOT IN:planMemberMap.Keyset() AND Plan__c=:projectid Limit 1000];
       // }
        Map<Id,Musqot_member__c>unquePlanMember=new Map<Id,Musqot_member__c>();
        for(Musqot_member__c m1:planMembersList){
           unquePlanMember.put(m1.userid__c ,m1);
        }
        planMemberFilterIdSet=(unquePlanMember.Keyset());
        planMemberFilterList = [Select id,userid__c,userid__r.Name,userid__r.Email,userid__r.UserRoleId,userid__r.department,Plan__c,Plan__r.ownerid,Role__c 
                                FROM Musqot_member__c 
                                WHERE userid__c IN:planMemberFilterIdSet AND Plan__c=:projectid ORDER BY Name];  
        planMemberFilterSet.addAll(planMemberFilterList);
        Map<Id,id>planMemberRole1=new Map<Id,id>();
        for(Musqot_member__c mm1:planMemberFilterList){
            planMemberRole1.put(mm1.userid__c,mm1.id);
        }
        Map<Id,Musqot_member__c>planMemberRole=new Map<Id,Musqot_member__c>();
            for(Musqot_member__c pm:planMemberFilterSet){
                planMemberRole.put(pm.userid__r.UserRoleId,pm);
            }
            Map<Id,string>userMemberRole=new Map<Id,string>();
            list<UserRole>uRole1=[select Name from UserRole WHERE id IN:planMemberRole.keySet()];  
            for(UserRole ur:uRole1){
                userMemberRole.put(ur.id,ur.Name);
            }
            for(Musqot_member__c pm1:planMemberFilterSet){
               if(pm1.userid__r.UserRoleId<>null){
                    String memberRole=userMemberRole.get(pm1.userid__r.UserRoleId);
                    //if(planMemberFilterSet.containsAll(pm1.id)){
                       listWrapper.add(new WrapperClass(pm1,memberRole));
                  //} 
                  
               }
            }
         if(listWrapper.size()==0){
             memberDisply=true;
             message='No more members can be added to this plan';
         }
    }
    public MemberController(){        
    }
    /*************************
    Save(): insert new Members  
    **************************/
    Public Pagereference Save(){
        try{
            Pagereference PR;
            if(projectid<>null){
                List<Members__c> mbrList = [select ID,Name,ProjUsers__c,ProjUsers__r.Name from Members__c where ProjMembers__c =:projectid];
                Map<Id,Members__c> mbrMap = new Map<Id,Members__c>();
                for(Members__c m : mbrList){
                    mbrMap.put(m.ProjUsers__c,m);    
                } 
                System.debug('===User==='+member.ProjUsers__c);       
                if(mbrMap.containsKey(member.ProjUsers__c)){   
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.mem_member_exist);
                    ApexPages.addMessage(myMsg);                        
                } 
                else{   
                    if (Members__c.sObjectType.getDescribe().isCreateable())
                    {      
                        insert member;
                    }
                    String tabId = System.currentPageReference().getParameters().get('tabId');
                    string pageRef='/apex/ProjectDetails?id='+EncodingUtil.urlEncode(projectid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb4','UTF-8');
                    pr=new Pagereference (pageRef);
                   
                }        
            }
            else  if(subprjid<>null){               
                 List<Members__c> mbrParentList = [select ID,Name,ProjUsers__c,ProjUsers__r.Name from Members__c where ProjMembers__c =:projectid];
                List<Members__c> mbrList = [select ID,Name,SubProjMembers__c,ProjMembers__c ,ProjUsers__c,ProjUsers__r.Name from Members__c where  SubProjMembers__c=:subprjid];
                Map<Id,Members__c> mbrMap = new Map<Id,Members__c>();
                for(Members__c m : mbrList){
                    mbrMap.put(m.ProjUsers__c,m);    
                }
                //for(Members__c mem : mbrList){
                if(mbrList [0].ProjUsers__c==mbrParentList[0].ProjUsers__c){
                   ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.mem_member_exist);
                    ApexPages.addMessage(myMsg);  
                } 
                //}     
                if(mbrMap.containsKey(member.ProjUsers__c)){   
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.mem_member_exist);
                    ApexPages.addMessage(myMsg);    
                } 
                else{   
                     if (Members__c.sObjectType.getDescribe().isCreateable())
                    {    
                    insert member;
                    }
                    String tabId = System.currentPageReference().getParameters().get('tabId');
                    string pageRef='/apex/SubProject?id='+EncodingUtil.urlEncode(subprjid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb4','UTF-8');
                    pr=new Pagereference (pageRef);
                    //PR = new Pagereference('/apex/SubProject?id='+EncodingUtil.urlEncode(subprjid,'UTF-8'));
                }       
            }
            else if(mrkId<>null){
                List<Members__c> mbrList = [select ID,Name,SubProjMembers__c,Marketingmebers__c,ProjUsers__c,ProjUsers__r.Name from Members__c where  Marketingmebers__c=:mrkId ];
                
                Map<Id,Members__c> mbrMap = new Map<Id,Members__c>();
                for(Members__c m : mbrList){
                    mbrMap.put(m.ProjUsers__c,m);    
                }        
                if(mbrMap.containsKey(member.ProjUsers__c)){   
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.mem_member_exist);
                    ApexPages.addMessage(myMsg);                         
                } 
                else{ 
                    if (Members__c.sObjectType.getDescribe().isCreateable())
                    {      
                        insert member;
                    }
                    String tabId = System.currentPageReference().getParameters().get('tabId');
                    string pageRef='/apex/Marketingactivity?id='+EncodingUtil.urlEncode(mrkId,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb4','UTF-8');
                    pr=new Pagereference (pageRef);
                }        
            }            
            return PR;
        }
		catch(Exception ex){            
        }      
        return null;
    }
    /****************************************
    cancel(): redirect to related parent page   
    *****************************************/
    Public Pagereference cancel(){
        Pagereference PR;
        if(mrkId<>null){
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/Marketingactivity?id='+EncodingUtil.urlEncode(mrkId,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb4','UTF-8');
            pr=new Pagereference (pageRef);
        }
        else if(subprjid<>null){
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/SubProject?id='+EncodingUtil.urlEncode(subprjid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb4','UTF-8');
            pr=new Pagereference (pageRef);
        }
        else if(projectid<>null){
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/ProjectDetails?id='+EncodingUtil.urlEncode(projectid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb4','UTF-8');
                pr=new Pagereference (pageRef); 
        }        
        return PR;
    }
    public String getRedirectToTemplate() {
        return null;
    }
    public Members__c  templateInfo {get; set;}
    public Pagereference redirectToTemplate() {
        try{
            insert templateInfo;
        }catch(Exception e){
            ApexPages.addMessages(e);
        }
        return null;
    }
   // Raju--To hold user information and user role and check box--
   public List<WrapperClass> listWrapper{get;set;}
   public Boolean allBool {get;set;}    
   public class WrapperClass {
        public Boolean checked {get;set;}
        public Musqot_member__c pmem{get;set;}
        public string pmRole{get;set;}
        public WrapperClass(Musqot_member__c pmem,string pmRole){
            this.pmem = pmem;
            this.pmRole = pmRole;
        }
    }
    //-End--
    //To save selected members in plan members--
    public  List<Members__c> listMemForSave = new List<Members__c>();
    public  List<Members__c> listMemForSave1 = new List<Members__c>();
    public Pagereference saveMember(){
        Pagereference pr;
        List<Musqot_member__c>listUserForSave=new List<Musqot_member__c>();
        List<WrapperClass> listTempWrapper = new List<WrapperClass>();
        for(WrapperClass w : listWrapper) {
            if(w.checked) {
                listUserForSave.add(w.pmem);
            } else {
                listTempWrapper.add(w);
            }
        }
        if(listUserForSave.size()>0){
          if(projectid<>null && subprjid==null){
            for(Musqot_member__c u:listUserForSave){
                 Members__c  plnMem=new Members__c();
                 plnMem.ProjUsers__c=u.userid__c;
                 plnMem.ProjMembers__c=projectid;
                 plnMem.Role__c=u.Role__c;
                 listMemForSave.add(plnMem);
            } 
            insert listMemForSave;
            listWrapper = listTempWrapper;
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/ProjectDetails?id='+EncodingUtil.urlEncode(projectid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb4','UTF-8');
            pr=new Pagereference (pageRef);
          }
          else if(subprjid<>null && projectid<>null){
              for(Musqot_member__c u:listUserForSave){
                 Members__c  proMem=new Members__c();
                 proMem.ProjUsers__c=u.userid__c;
                 //proMem.ProjMembers__c=subprjid;
                 proMem.SubProjMembers__c=subprjid;
                 proMem.Role__c=u.Role__c;
                 listMemForSave.add(proMem);
            } 
               insert listMemForSave;
               listWrapper = listTempWrapper;
               String tabId = System.currentPageReference().getParameters().get('tabId');
               string pageRef='/apex/SubProject?id='+EncodingUtil.urlEncode(subprjid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb4','UTF-8');
               pr=new Pagereference (pageRef);
           } 
          if(mrkId<>null){
              for(Musqot_member__c u:listUserForSave){
                 Members__c  mrkMem=new Members__c();
                 mrkMem.ProjUsers__c=u.userid__c;
                 //mrkMem.ProjMembers__c=projectid;
                 mrkMem.Marketingmebers__c=mrkId;
                 mrkMem.Role__c=u.Role__c;
                 listMemForSave1.add(mrkMem);
               } 
               insert listMemForSave1;
               listWrapper = listTempWrapper;
               String tabId = System.currentPageReference().getParameters().get('tabId');
               string pageRef='/apex/Marketingactivity?id='+EncodingUtil.urlEncode(mrkId,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb4','UTF-8');
               pr=new Pagereference (pageRef);
           }         
    	}
         return pr;
    }
 }