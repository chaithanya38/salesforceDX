/*********************************************************************
Class Name: costcentermembercls
Author:Chaithanya daggumati        Last modified by: Chaithanya daggumati
Date: 12/11/2015                Date: 12/11/2015 
********©2013 Musqot marketing technology Pvt ltd *********************/
public with sharing class costcentermembercls{
    private ApexPages.StandardController sc;
    public String cosid{get;set;}
    public Members__c member{get;set;}
    public costcentermembercls(ApexPages.StandardController sc) {
        this.sc = sc;
        cosid = ApexPages.currentPage().getParameters().get('cosid');
        if(cosid<>null){
            member = new Members__c (Cost_center__c = cosid); 
        }        
    }    
    /*************************
    Save(): insert new Members  
    **************************/
    Public Pagereference Save(){
        try{
            Pagereference PR;
            if(cosid<>null){
                List<Members__c> mbrList = [select ID,Name,ProjUsers__c,Role__c,ProjUsers__r.Name from Members__c where Cost_center__c =:cosid];               
                Map<Id,Members__c> mbrMap = new Map<Id,Members__c>();
                for(Members__c m : mbrList){
                    mbrMap.put(m.ProjUsers__c,m);    
                }
                 
                if(mbrMap.containsKey(member.ProjUsers__c)){                    
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.mem_member_exist);
                    ApexPages.addMessage(myMsg);    
                }
                else{ 
                    if (Members__c.sObjectType.getDescribe().isCreateable()){  
                    insert member;
                    }
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/Costcenterdetail?id='+EncodingUtil.urlEncode(cosid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb4','UTF-8');
                pr=new Pagereference (pageRef);
                }
            }
             return PR; 
        }
        catch(Exception ex){}      
        return null;
    }
    /****************************************
    cancel(): redirect to related parent page   
    *****************************************/
    Public Pagereference cancel(){        
        Pagereference PR;        
        if(cosid<>null){
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/Costcenterdetail?id='+EncodingUtil.urlEncode(cosid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb4','UTF-8');
                pr=new Pagereference (pageRef); 
        }        
        return PR;
        }
    }