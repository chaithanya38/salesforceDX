/*********************************************************************
Class Name: marketingClass 
Author: G Janardhanreddy        Last modified by:Raju GN
Date: 30/6/2014                  Date: 24/3/2015  
********©2013 Musqot marketing technology Pvt ltd ********************/
public with sharing virtual class marketingClass extends MusqotUtility{
    public Marketing_activity__c mr{get;set;}
    String subid;
    public musqot__Subproject__c planid;
    String mrId;
    public string fieldSetName; 
    public List<SelectOption> ACTList{get;set;}
    public musqot__Activity__c actvity{get;set;}
    public boolean addvancedIntragition{get;set;}
    public List<musqot__Activitytype__c> ACT_Temp = new List<musqot__Activitytype__c>();    
    
    public marketingClass (ApexPages.StandardController sc){
        mr = new Marketing_activity__c ();        
        subid = ApexPages.CurrentPage().getParameters().get('subid');
        string mainStr = ApexPages.CurrentPage().getParameters().get('retURL');        
        planid = new musqot__Subproject__c();
        try {
            planid = [select Id, Parent_project__c  
                      from Subproject__c 
                      where Id =:subid limit 1];  
        }
        catch (System.QueryException e) {
        }
        ACTList= new List<SelectOption>();
        ACT_Temp = [Select u.Name, u.Id From Activitytype__c u limit 250];
        for(Activitytype__c objACT : ACT_Temp)
        {
            ACTList.add(new SelectOption(objACT.Id, objACT.Name));
        }
        if(!ACT_Temp.isEmpty()){
            mr.Activitytype__c = ACT_Temp[0].Id;
        }
        FieldSet();
        actvity=[SELECT Id, Name, Use_socialmedia__c,keycode__c  
                 FROM Activity__c limit 1];
        applyEditionSetting();
    }
    /**************************************
getFields(): To get fieldsetname
***************************************/
    public List<schema.fieldsetmember> getFields() { 
        if(!String.isBlank(fieldSetName)){            
            Schema.FieldSet fldSet = Schema.SObjectType.Musqot__Marketing_activity__c.fieldSets.getMap().get(fieldSetName); 
            if(fldSet<>null){                
                return fldSet.getFields();
            }
            else{
                return new List<schema.fieldsetmember>();
            }
        }
        else{
            return new List<schema.fieldsetmember>();
        }  
    }
    /*****************************************************
getFieldsetList(String marketid): To get fieldsetList
******************************************************/  
    
    @TestVisible private Musqot__Marketing_activity__c getFieldsetList(String marketid) {
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id, Name FROM Marketing_activity__c where id = :marketid order by LastModifiedDate DESC LIMIT 1';
        return Database.query(query);
    }
    
    public marketingClass (){        
    }
    /***************************************************************************
save(): insert the marketing activity records and redirect to SubProject page
****************************************************************************/
    public PageReference save(){
        List<Marketing_activity__c> lstmact = [SELECT Id, name from Marketing_activity__c where name=:mr.name];
        mr.Project__c= subid; 
        mr.Plan__c= planid.musqot__Parent_project__c;
        
        if(lstmact.size()>0){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.mrk_Marketing_activity_name_already_exist));
            return null;
        }       
        else if (Marketing_activity__c.sObjectType.getDescribe().isCreateable())
        {
            insert mr;
        }
        Pagereference PR;
        if(subId<>null){  
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/SubProject?id='+EncodingUtil.urlEncode(subId,'UTF-8')+'&tab='+EncodingUtil.urlEncode('mark','UTF-8');
            pr=new Pagereference (pageRef);
        }
        return pr;
    }
    /**************************************
cancel():  redirect to SubProject page
***************************************/
    public PageReference cancel(){
        Pagereference PR;
        if(subId<>null){  
            
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/SubProject?id='+EncodingUtil.urlEncode(subId,'UTF-8')+'&tab='+EncodingUtil.urlEncode('mark','UTF-8');
            pr=new Pagereference (pageRef);
        }
        return pr;
    }
    /***********************************************************
getFieldSet(): Get FieldSet from Marketing activity object
*************************************************************/
    public PageReference FieldSet(){
        if(mr.Activitytype__c == null||mr.Activitytype__c != null){
            Activitytype__c  actType = [SELECT Id,musqot__F__c FROM musqot__Activitytype__c WHERE Id =:mr.Activitytype__c];
            if(actType.musqot__F__c<>null){
                if(!String.isBlank(actType.musqot__F__c)){
                    fieldSetName = 'musqot__' + actType.musqot__F__c;
                }
                else{
                    fieldSetName = ''; 
                }                
            } 
            else{
                fieldSetName = ''; 
            }
        }
        return null;
    }
    //public String orgId{get;set;}
    public void applyEditionSetting(){
        // get KEYCODE
        String keycode = actvity.keycode__c;
        decryptKeycode(keycode);
        boolean isValid = false;
        //String decryptedEdition = MusqotUtility.edition;
        system.debug('==='+extendedSystemsIntegrations);
        addvancedIntragition=extendedSystemsIntegrations;
    }
    //--Raju--To get picklist vaalues dynamically---
    public List<SelectOption> getActivityColors()
    {
        List<SelectOption> options = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult =
        Marketing_activity__c.Activity_Class__c.getDescribe();
        List<Schema.PicklistEntry>colors= fieldResult.getPicklistValues();
        options.add(new SelectOption('','-None-'));
        for( Schema.PicklistEntry c: colors)
        {
            options.add(new SelectOption(c.getValue(),c.getLabel()));
        } 
        return options;
    }
    //---End---
}