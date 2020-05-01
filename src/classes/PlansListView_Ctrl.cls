/*******************************************************
Class Name: PlansListView_Ctrl
Author:Nagaraju G             Last modified by:Raju GN
Date:28/10/2015               Date:28/10/2015
Desc:Adding if block to show the plan records Line no:52-66
********©2013 Musqot marketing technology Pvt ltd *******/
public  with sharing class PlansListView_Ctrl{ 
    public List<Project__c>plansRecList{get;set;}
    public List<Id>userRoleSet;
    public Activity__c musqotSettingRec{get;set;}
    public string usrProfileName;
    public string NewPlanUrl {get;set;}
    public PlansListView_Ctrl(){
        plansRecList=new list<Project__c>();
        userRoleSet=new List<Id>();
        usrProfileName = [select u.Profile.Name 
                          from User u 
                          where u.id =:Userinfo.getUserId()].Profile.Name;
        musqotSettingRec=[SELECT Id, Name, Plan_access_controll__c 
                          FROM Activity__c limit 1];
        List<Musqot_member__c>planMemberList=[SELECT Id, Name, userid__c, Plan__c 
                                              FROM Musqot_member__c 
                                              WHERE userid__c =:UserInfo.getUserId()];
        for(Musqot_member__c m:planMemberList){
            userRoleSet.add(m.Plan__c);
        }   
        NewPlanUrl = '/apex/Planpage_Resp?pageType='+ EncodingUtil.urlEncode('new','UTF-8');
    }
    //--Redirect to Planpage new plan---
    public Pagereference redirectPlanpage(){
        PageReference newPlanPage=new PageReference('/apex/Planpage?pageType='+ EncodingUtil.urlEncode('new','UTF-8'));
        newPlanPage.setredirect(true);
        return newPlanPage; 
    }
    //--Redirect to PlanDetail---
    public PageReference gotoPlanDetail() {
        String plnId= ApexPages.currentPage().getParameters().get('plnId');
        PageReference pgr;   
        pgr =new PageReference ('/apex/ProjectDetails?id='+EncodingUtil.urlEncode(plnId,'UTF-8')+'&&sfdc.override=1');
        return pgr;
    }
    
    // added by Narendra
    public PageReference gotoPlanDetailResp() {
        String plnId= ApexPages.currentPage().getParameters().get('plnId');
        PageReference pgr;   
        pgr =new PageReference ('/apex/ProjectDetails_Resp?Id='+EncodingUtil.urlEncode(plnId,'UTF-8')+'&&sfdc.override=1');
        return pgr;
    }
    //--Pegenation Start here---
    public ApexPages.StandardSetController setCon{
        get {
            if(setCon == null){
                //to check Plan access controll here 
                if(musqotSettingRec.Plan_access_controll__c==true){
                    //If logdin user profile equels to systemadminstrator,he can see all plans all time.
                    if(usrProfileName=='System Administrator'){
                       setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                          [SELECT  Name,Plantype__r.Name, Starts_date__c, Ends_date__c, Owner.Name, 
                           Status__c, StatusImage__c 
                           FROM Project__c  ORDER BY Name limit 1000]));
                    }
                    //else only see ,if logdin user owner of the plan or member of the plan(Non systemadminstrator users)
                    else{
                        setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                            [SELECT  Name,Plantype__r.Name,Starts_date__c,Ends_date__c,Owner.Name, 
                             Status__c, StatusImage__c 
                             FROM Project__c 
                             WHERE Id IN:userRoleSet OR OwnerId=:UserInfo.getUserId() ORDER BY Name limit 1000]));
                    }
                    
                }
                //If Plan access controll is uncheck
                else{
                     setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                          [SELECT  Name,Plantype__r.Name, Starts_date__c, Ends_date__c, Owner.Name, Status__c, StatusImage__c 
                           FROM Project__c  ORDER BY Name limit 1000]));
                }
            }
            return setCon;
        }
        set;
    }  
    public List<Project__c> getPlanRecs() {
         setCon.setpagesize(10);
         return (List<Project__c >)setCon.getRecords();
    }
}