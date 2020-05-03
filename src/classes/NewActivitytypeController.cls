/**********************************************************
Class Name: NewActivitytypeController 
Author:Nagaraju       Last modified by: Chaithanya daggumati
Date :15/7/2014       Date : 20/3/2015                    
********©2013 Musqot marketing technology Pvt ltd **********/
public with sharing class NewActivitytypeController {
    public plantype__c Newact{get;set;}    
    Transient Map<string,Schema.FieldSet> FsMap ;
    public NewActivitytypeController(ApexPages.StandardController controller) {
        Newact=new plantype__c();
        FsMap = new Map<string,Schema.FieldSet>();
    }
    public List<SelectOption> Fieldsetlist
     {
     get
        {
            List<SelectOption> fieldSetListTmp = new List<SelectOption>();
            schema.DescribeSObjectResult dsr = musqot__Project__c.sObjectType.getDescribe();
            FsMap = dsr.fieldSets.getMap();
            fieldSetListTmp .add(new SelectOption('','-None-'));
            for(Schema.FieldSet fldSet : FsMap.values()){             
            fieldSetListTmp .add(new SelectOption(fldSet .getName(),fldSet.getLabel())); 
            }
             if(fieldSetListTmp.isEmpty()){
                fieldSetListTmp.add(new SelectOption('','--None--')); 
            }
            return fieldSetListTmp ;
        }
        set;
    } 
    /************************************************************
    Newrec(): insert new plantype and redirects to MusqotAdminPage
    **************************************************************/
    Public Pagereference  Newrec() 
    {  
        if (plantype__c.sObjectType.getDescribe().isCreateable())
        {
            insert Newact;
        }
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('plns','UTF-8');
        Pagereference pg=new Pagereference (pageRef);
        return pg;        
    }
     /************************************
    Cancel():redirect to MusqotAdminPage
    *************************************/
    Public Pagereference  Cancel()
    {
    String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('plns','UTF-8');
        Pagereference pg=new Pagereference (pageRef);
        return pg;
    }   
}