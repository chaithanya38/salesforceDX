/*************************************************************
Class Name: approvalRequests
Author:G Janardhanreddy      Last modified by:G Janardhanreddy
Date: 15/07/2014             Date:18/03/2015
********©2013 Musqot marketing technology Pvt ltd ************/
public with sharing class approvalRequests{
    public ProcessInstanceWorkitem piw{get;set;}
    public approvalRequests(){
    }
    /*****************************************
getwrapList():retunrs list of pwiWrap 
******************************************/
    public List<pwiWrap> getwrapList(){//
        List<ProcessInstanceWorkitem> tempList= [Select Id, ProcessInstanceId,ProcessInstance.TargetObject.Name, 
                                                 ProcessInstance.Status, ProcessInstance.TargetObjectId, ActorId, 
                                                 OriginalActorId, CreatedById, CreatedDate 
                                                 from ProcessInstanceWorkitem 
                                                 where ActorId =:UserInfo.getUserId()];
        
        Set<Id> amtIds = new Set<Id>();
        Set<String>outofMusqotObjectList=new  Set<String>();
        if(tempList.size()>0){
            List<pwiWrap> tempWrpList = new List<pwiWrap>();
            for(ProcessInstanceWorkitem p : tempList){
                amtIds.add(p.ProcessInstance.TargetObjectId);
               //---This for fetching outof musqot object --
                string musqotObject= p.ProcessInstance.TargetObjectId.getSObjectType().getDescribe().getName();
                if(!musqotObject.startsWith('musqot__')){
                      outofMusqotObjectList.add(musqotObject);
                }
            }
           
            List<sObject> records=new List<sObject>();
            List<sObject> recordsList=new List<sObject>();//This list is having targetobjects records (ie,Non musqot targetobjects)
            for(string s:outofMusqotObjectList){
                String myObject = s;
                records = Database.query('Select Id, Name,LastModifiedById From ' + myObject +'');
                recordsList.addAll(records);
            }
           
            List<Allocation_amount__c> amtList = [select Id,Allocated__c,LastModifiedById from 
                                                  Allocation_amount__c where Id IN :amtIds];
            List<Allocation_resources__c> hrsList = [select Id,Requested_hours__c,LastModifiedById from 
                                                     Allocation_resources__c where Id IN :amtIds];
           
            String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
            Set<pwiWrap> setWrp = new Set<pwiWrap>();
            for(ProcessInstanceWorkitem p : tempList){
                id mmId=p.ProcessInstance.TargetObjectId;
                String sObjName = mmId.getSObjectType().getDescribe().getName();
                if(sObjName== 'musqot__Allocation_amount__c'){
                    for(Allocation_amount__c amt : amtList){
                        if(p.ProcessInstance.TargetObjectId == amt.Id){                    
                            setWrp.add(new pwiWrap(p,amt,null,null,null)); 
                            
                        }     
                    }
                }
                else if(sObjName== 'musqot__Allocation_resources__c'){
                    for(Allocation_resources__c hrs : hrsList){
                        if(p.ProcessInstance.TargetObjectId == hrs.Id){
                            setWrp.add(new pwiWrap(p,null,hrs,null,null)); 
                        }     
                    }
                }
                //---This is for approval/Reject link in home myrequests of outof musqotApp
                else{
                       for(SObject record :recordsList){  
                            string objname=record.Id.getSObjectType().getDescribe().getName();
                             if(p.ProcessInstance.TargetObjectId == record.Id){
                                  setWrp.add(new pwiWrap(p,null,null,baseUrl,objname)); 
                            }
                      }
                }
            }            
            tempWrpList.addAll(setWrp);
            return tempWrpList;
        }
        else{
            return (new List<pwiWrap>());
        }
    }
    public class pwiWrap{
        public ProcessInstanceWorkitem pw{get;set;}
        public Allocation_amount__c allocAmount{get;set;}
        public Allocation_resources__c allocResource{get;set;}  
        public string baseUrl{get;set;}
        public string objNmae{get;set;}
        public pwiWrap(ProcessInstanceWorkitem pw, Allocation_amount__c allocAmount,
                       Allocation_resources__c allocResource,string s,string objnmae){            
            this.pw = pw;
            this.allocAmount = allocAmount; 
            this.allocResource = allocResource;  
            this.objNmae=objnmae;
            this.baseUrl=s;
        }               
    }
}