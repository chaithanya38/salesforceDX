/*********************************************************************
Class Name: PlanMemberController
Author:Hakan        Last modified by:Raju GN
Date:22/10/2015              Date: 26/10/2015
Dec:
********©2013 Musqot marketing technology Pvt ltd *********************/
public with sharing class PlanMemberController{
    private ApexPages.StandardController sc;
    public String planid{get;set;}
    public User User{get;set;}
    public list<musqot_Member__c>planMemberList;
    public List<User>musqotUserList;
    public Map<id,musqot_Member__c> planMemberMap=new Map<id,musqot_Member__c>();
    public  List<Musqot_member__c> listMemForSave = new List<Musqot_member__c>();
    public  List<Musqot_member__c> listFilterMemForSave = new List<Musqot_member__c>();
    public List<User>listUserForSave{get;set;}
    public Members__c PlanOwner{get;set;}
    public PlanMemberController(ApexPages.StandardController sc) {
        this.sc = sc;
        listWrapper = new List<WrapperClass>();
        planid = ApexPages.currentPage().getParameters().get('planid');
        List<User> UserRecs = new List<User>();

        planMemberList = [Select userid__c
                          FROM musqot_Member__c 
                          where Plan__c=:planid ];//to get member of plan
        
        for(musqot_Member__c m:planMemberList){
            planMemberMap.put(m.userid__c,m);
        }
        //get User with Profile System administrator and Musqot admine--
        //Start musqot dev user
        //This part is to get this work in dev org then all musqot user need to have Department = 'Musqot development'
        List<user>userList=[SELECT Id,Name, Department, Email, UserRoleId, Title, smallphotourl  
                            FROM User 
                            WHERE (Department ='Musqot development') AND (Id NOT IN:planMemberMap.keySet()) 
                            ORDER BY Name];
        // End Start musqot dev user
        
        //get a list of all user with Musqot licens and not already member of the plan.--
        musqotUserList =[SELECT Id, Name, Department, Email, UserRoleId, Title ,smallphotourl 
                         FROM User 
                         WHERE (Id NOT IN:planMemberMap.keySet() AND Id IN(SELECT UserId FROM UserPackageLicense WHERE (PackageLicense.NamespacePrefix ='musqot')))
                         ORDER BY Name];
       if(userList.size()>0){
           musqotUserList.addAll(userList); 
        } 
        
        Map<Id,User>planMemberRole=new Map<Id,User>();
        if(musqotUserList.size()>0){
            for(user pm: musqotUserList){
                planMemberRole.put(pm.UserRoleId,pm);
            }
            Map<Id,string>userMemberRole=new Map<Id,string>();
            list<UserRole>uRole1=[select Name from UserRole WHERE id IN:planMemberRole.keySet()];  
            for(UserRole ur:uRole1){
                userMemberRole.put(ur.id,ur.Name);
            }
            for(user pm: musqotUserList){
               if(pm.UserRoleId<>null){
                    String memberRole=userMemberRole.get(pm.UserRoleId);
                    listWrapper.add(new WrapperClass(pm,memberRole));
               }
            }
        }
        else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'No user with Musqot license available to add in this Plan!');
            ApexPages.addMessage(myMsg); 
        }
        //----End---
    }
   //--Raju:WrapperClass to hold the check box and user detail & User role--
   public List<WrapperClass> listWrapper{get;set;}
   public Boolean allBool {get;set;}    
   public class WrapperClass {
        public Boolean checked{get;set;}
        public User pmem{get;set;}
        public string pmRole{get;set;}
        public WrapperClass(User pmem,string pmRole){
            this.pmem = pmem;
            this.pmRole = pmRole;
        }
    }    
    //--Raju to save selected members in plan members--
    
    public Pagereference saveMember(){
        Pagereference pr;
        listUserForSave=new List<User>();
        List<WrapperClass> listTempWrapper = new List<WrapperClass>();
        for(WrapperClass w :listWrapper) {
            if(w.checked){
                listUserForSave.add(w.pmem);
            } else {
                listTempWrapper.add(w);
            }
        }
        if(listUserForSave.size()>0){
            map<id,string>userNameMap=new map<id,string>();
            for(User us:listUserForSave){
               userNameMap.put(us.id,us.Name);
            }
            for(User u:listUserForSave){
                 Musqot_member__c plnMem=new Musqot_member__c();
                 plnMem.userid__c=u.id;
                 plnMem.Name=userNameMap.get(u.id);
                 plnMem.Plan__c=planid;
                 listMemForSave.add(plnMem);
            } 
            insert listMemForSave;
            listWrapper = listTempWrapper;
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/ProjectDetails?id='+EncodingUtil.urlEncode(planid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb6','UTF-8');
            pr=new Pagereference (pageRef);
        }
         return pr;
   }
/****************************************
cancel(): redirect to related parent page   
*****************************************/
    Public Pagereference cancel(){
        Pagereference PR;
        if(planid<>null){
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/ProjectDetails?id='+EncodingUtil.urlEncode(planid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb6','UTF-8');
            pr=new Pagereference (pageRef);
        }
        
        return PR;
    }

}