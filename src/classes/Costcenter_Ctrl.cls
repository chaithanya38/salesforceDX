/*******************************************************
Class Name: Costcenter_Ctrl
Author:Nagaraju G             Last modified by:Poornima
Date:23/7/2014                Date:28/10/2015
********©2013 Musqot marketing technology Pvt ltd *******/
public  with sharing class Costcenter_Ctrl{  
 public boolean ccRec{get;set;}
 public string cosid{get;set;}
 public List<Id>userRole;
 public string usrProfileName;
 public list<Activity__c> act{get;set;}
    public Costcenter_Ctrl() {
      userRole=new List<Id>();
      usrProfileName = [select u.Profile.Name 
                          from User u 
                          where u.id =:Userinfo.getUserId()].Profile.Name;
      act=[SELECT Id, Use_Allocation__c 
           FROM Activity__c limit 1];
      if(act[0].Use_Allocation__c ==true){
          ccRec=true; 
        }
      if(act[0].Use_Allocation__c ==false){
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Musqot is configurated to not use Cost Centers');
          ApexPages.addMessage(myMsg); 
      }
      List<Members__c>MemberList=[SELECT Id, Name, ProjUsers__c, Cost_center__c 
                                              FROM Members__c 
                                              WHERE ProjUsers__c =:UserInfo.getUserId()];
        for(Members__c m:MemberList){
            userRole.add(m.Cost_center__c);
        }
    }    
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                if(usrProfileName=='System Administrator'){
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                      [SELECT Id, Name,Status__c ,StatusImage__c,cc_Owner__c, Owner.name 
                       FROM  Costcentre__c ORDER BY CreatedDate ASC limit 500]));
                }
                
                else{
                 setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                      [SELECT Id, Name,Status__c ,StatusImage__c,cc_Owner__c, Owner.name 
                       FROM  Costcentre__c WHERE Id IN:userRole OR OwnerId=:UserInfo.getUserId() ORDER BY CreatedDate ASC limit 500]));                      
                }
             }
            return setCon;
        }
        set;
    }  
    public List<Costcentre__c> getCostcenters() {
         setCon.setpagesize(10);
         return (List<Costcentre__c>) setCon.getRecords();
    }
    Public PageReference newCostcenter(){
        PageReference NewCostcenter=new PageReference('/apex/NewCostcenter?pageType=new');
        NewCostcenter.setredirect(true);
        return NewCostcenter; 
    }
    public pageReference DeleteCostcen(){
        try{
        musqot__Costcentre__c cos = [Select id, name,StatusImage__c,Status__c ,ownerId from Costcentre__c where id=:cosid];       
        list<Allocation_amount__c> allocat=[Select Id, Costcentre__c 
                                            from  Allocation_amount__c 
                                            where Approved__c=true and Costcentre__c=:cos.id];          
           if(allocat.isEmpty()){ 
               delete cos;    
            }else{
               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Musqot can´t delete the Cost center, ');
               ApexPages.addMessage(myMsg); 
         }
        }catch(Exception e){}
         Pagereference PR;  
         Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
         String objPrefix = globalDescribe.get('musqot__Costcentre__c').getDescribe().getkeyprefix();
         PageReference prRef = new PageReference('/' + objPrefix+'/o');
         prRef.setRedirect(true);
         return prRef;
         
    }
    public pageReference editCostcen(){
        PageReference prj=new PageReference ('/apex/NewCostcenter?id='+EncodingUtil.urlEncode(cosid,'UTF-8'));
        return prj;
    }
     //--Redirect to coscenterDetail---
    public PageReference gotoccDetail() {
        String cosId= ApexPages.currentPage().getParameters().get('cosId');
        PageReference pgr;   
        pgr =new PageReference ('/apex/Costcenterdetail?Id='+EncodingUtil.urlEncode(cosId,'UTF-8')+'&&sfdc.override=1');
        return pgr;
    }
}