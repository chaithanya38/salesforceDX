/*******************************************************
Class Name: ExpenseController	
Author:G Janardhanreddy     Last modified by:G Janarhanreddy
Date: 26/6/2014              Date:19/03/2015
********©2013 Musqot marketing technology Pvt ltd *******/
public with sharing class ExpenseController {
    private ApexPages.StandardController sc;
    public String projectid{get;set;}
    public String memberid{get;set;}
    public Members__c member{get;set;}
    public ExpenseController(ApexPages.StandardController sc) {
        this.sc = sc;
        projectid = ApexPages.currentPage().getParameters().get('SubProjectid');                     
        memberid= ApexPages.currentPage().getParameters().get('id');
        if(memberId<>''){
            try{
                member = [Select Id, Name, ProjMembers__c, ProjUsers__c, SubProjMembers__c, Role__c, User_Email__c FROM Members__c  where Id=:memberId ];
            }catch(exception e){}   
        }}
    public ExpenseController(){
        templateInfo = new Members__c();
        Members__c member = new Members__c (); 
    }
    Public Pagereference Save(){
        member = new Members__c (); 
        if (Members__c.sObjectType.getDescribe().isUpdateable())
        {
            update member;
        }
        Pagereference PR = new Pagereference('/apex/ProjectDetails?id='+EncodingUtil.urlEncode(projectid,'UTF-8'));
        return PR;
    }
    Public Pagereference cancel(){   
        Pagereference PR = new Pagereference('/apex/SubProject?id='+EncodingUtil.urlEncode(projectid,'UTF-8'));
        return PR;
    }
    public Members__c  templateInfo {get; set;} 
}