/*******************************************************
Class Name: MarketingAcitivityController 
Author:Nagaraju G        Last modified by:Raju Gn
Date:10/9/2014           Date:23/12/2015
********©2013 Musqot marketing technology Pvt ltd *******/

public with sharing class MarketingAcitivityController {
    public musqot__Marketing_activity__c objMarket{ get;set;}
    Public string marketid;
    public List<socialmedia_settings__c> SocialFilter_Temp = new List<socialmedia_settings__c>();
    public List<ERP_Settings__c> ERPFilter_Temp = new List<ERP_Settings__c>();
    public List<CRM_Settings__c> CRMFilter_Temp = new List<CRM_Settings__c>();
    public List<musqot__Activitytype__c> ACT_Temp = new List<musqot__Activitytype__c>();
    public List<musqot__Marketing_activity__c>ObjMar;
    public String fieldSetName;
    public boolean showEdt{get;set;}
    public boolean showRec{get;set;}
    public boolean hiderec{get;set;}
    public boolean showEdtbtn{get;set;} 
    public MarketingAcitivityController(ApexPages.StandardController controller) {
        ObjMar=new list<musqot__Marketing_activity__c> ();
        marketid=ApexPages.currentPage().getParameters().get('marktid');
        String objectName = 'Musqot__Marketing_activity__c';  
        String query = ' SELECT ' ;
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        for(String s : objectFields.keySet()) {
            query += ' ' + s + ',';
        }        
        if (query.subString(query.Length()-1,query.Length()) == ','){
            query = query.subString(0,query.Length()-1);
        }
        query += ' FROM ' + objectName + ' WHERE id =:marketid'; 
        try {
            ObjMar= database.query(query);
            objMarket = ObjMar[0];
        } catch (QueryException e){
            
        } 
        getCustomSettRec();
        showEdt=true;
        showEdtbtn=false;  
        
        showRec=true;
        hiderec=false;              
    }
    /**********************************************************
ACTList: convert the lookup to dropdown of ActivitytypeList  
***********************************************************/
    public List<SelectOption> ACTList
    {
        get
        {
            ACT_Temp = [Select u.Name, u.Id From musqot__Activitytype__c u limit 250];
            ACTList= new List<SelectOption>(); 
            for(musqot__Activitytype__c objACT : ACT_Temp )
            {
                ACTList.add(new SelectOption(objACT.Id, objACT.Name));
            }
            return ACTList;
        }
        set;
    }
    public MarketingAcitivityController(){       
    }
    /***********************************
save(): Inserting Marketing activity 
************************************/
    public PageReference save(){
        
        if (Marketing_activity__c.sObjectType.getDescribe().isUpdateable())
        {
            update objMarket;
        }
        Pagereference PR;
        PR = new Pagereference('/apex/Marketingactivity?id='+EncodingUtil.urlEncode(marketid,'UTF-8'));                  
        return PR ;
    }
    /********************************************
cancel(): redirects to Marketingactivity page  
*********************************************/
    public PageReference cancel(){
        Pagereference PR;
        PR = new Pagereference('/apex/Marketingactivity?id='+EncodingUtil.urlEncode(marketid,'UTF-8'));                  
        return PR ;
    }
    /******************************************************************
gotoEditMode(): insert the fieldset into drowp down list in plantype
********************************************************************/
    Public void gotoEditMode(){ //show record edit mode            
        showRec=false;
        hiderec=true;
        showEdt=false;
        showEdtbtn=true;  
    }
    
    Public void gotoInfoMode(){ // show record edit mode through homw page
        showRec=false;
        hiderec=true;
        showEdt=false;
        showEdtbtn=true; 
    }       
    /************************************************************
getFieldsetList(String subproId): to get set of FieldsetLists 
*************************************************************/     
    @TestVisible private Musqot__Marketing_activity__c getFieldsetList(String marketid) {
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id, Name FROM Musqot__Marketing_activity__c where id = :marketid order by LastModifiedDate DESC LIMIT 1';
        return Database.query(query);
    }
    /********************************
getFields():get  field set fields
*********************************/
    public List<schema.fieldsetmember> getFields() { 
        if(!String.isBlank(fieldSetName)||test.isRunningTest()){
            Schema.FieldSet fldSet = Schema.SObjectType.Marketing_activity__c.fieldSets.getMap().get(fieldSetName); 
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
    /******************************************************************
SocialFilter(): insert the social performance 
********************************************************************/
    public List<SelectOption> SocialFilter{
        get
        {
            SocialFilter_Temp = [Select u.Name, u.Id From socialmedia_settings__c u 
                                 where type__c='Performance, marketing activity'   limit 250];
            SocialFilter= new List<SelectOption>(); 
            for(Socialmedia_settings__c objSocialFilter: SocialFilter_Temp )
            {
                SocialFilter.add(new SelectOption(objSocialFilter.Id, objSocialFilter.Name));
            }            
            return SocialFilter;
        }
        set;
    }
    public String[] SocialItems { 
        get {
            String[] selected = new List<String>();
            List<SelectOption> sos = this.SocialFilter;
            for(SelectOption s : sos) {
                if (this.objMarket.Social_media__c!=null && this.objMarket.Social_media__c.contains(s.getValue()))
                    selected.add(s.getValue());
            }
            return selected;
        }public set {
            String selectedConcat = '';
            for(String s : value) {
                if (selectedConcat == '') 
                    selectedConcat += s;
                else selectedConcat += ';' + s;
            }
            objMarket.Social_media__c= selectedConcat;
        }
    } 
    /******************************************************************
ERPFilter(): insert the erp settings
********************************************************************/
    public List<SelectOption> ERPFilter{
        get
        {
            ERPFilter_Temp = [Select u.Name, u.Id From ERP_Settings__c u 
                              where ERP_Performance_type__c='Performance, marketing activity'   limit 250];
            ERPFilter= new List<SelectOption>(); 
            for(ERP_Settings__c objERPFilter: ERPFilter_Temp )
            {
                ERPFilter.add(new SelectOption(objERPFilter.Id, objERPFilter.Name));
            }            
            return ERPFilter;
        }
        set;
    }
    public String[] ERPItems { 
        get {
            String[] selected = new List<String>();
            List<SelectOption> sos = this.ERPFilter;
            for(SelectOption s : sos) {
                if (this.objMarket.ERP__c!=null && this.objMarket.ERP__c.contains(s.getValue()))
                    selected.add(s.getValue());
            }
            return selected;
        }public set {
            String selectedConcat = '';
            for(String s : value) {
                if (selectedConcat == '') 
                    selectedConcat += s;
                else selectedConcat += ';' + s;
            }
            objMarket.ERP__c= selectedConcat;
        }
    } 
    /******************************************************************
CRMFilter(): insert the crm settings 
********************************************************************/
    public List<SelectOption> CRMFilter{
        get
        {
            CRMFilter_Temp = [Select u.Name, u.Id From CRM_Settings__c u 
                              where CRM_Performance_type__c='Performance, marketing activity'   limit 250];
            CRMFilter= new List<SelectOption>(); 
            for(CRM_Settings__c objCRMFilter: CRMFilter_Temp )
            {
                CRMFilter.add(new SelectOption(objCRMFilter.Id, objCRMFilter.Name));
            }            
            return CRMFilter;
        }
        set;
    }
    public String[] CRMItems { 
        get {
            String[] selected = new List<String>();
            List<SelectOption> sos = this.CRMFilter;
            for(SelectOption s : sos) {
                if (this.objMarket.CRM__c!=null && this.objMarket.CRM__c.contains(s.getValue()))
                    selected.add(s.getValue());
            }
            return selected;
        }public set {
            String selectedConcat = '';
            for(String s : value) {
                if (selectedConcat == '') 
                    selectedConcat += s;
                else selectedConcat += ';' + s;
            }
            objMarket.CRM__c= selectedConcat;
        }
    } 
    /******************************************************************
getCustomSettRec(): get the activity type fieldset
********************************************************************/
    public PageReference getCustomSettRec(){
        if(objMarket.musqot__Activitytype__c != null){
            Activitytype__c  actType = [SELECT Id,musqot__F__c FROM musqot__Activitytype__c 
                                        WHERE Id =:objMarket.musqot__Activitytype__c];
            if(!String.isBlank(actType.musqot__F__c)){
                fieldSetName = 'musqot__' + actType.musqot__F__c;
                
            }
            else{
                fieldSetName = ''; 
            }
        }
        return null;
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