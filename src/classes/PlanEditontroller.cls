/*******************************************************
Class Name: PlanEditontroller
Author:Nagaraju G               Last modified by: Chaithanya Daggumati
Date: 22/7/2014                   Date:  20/03/2015
********©2013 Musqot marketing technology Pvt ltd *******/
public with sharing class PlanEditontroller{
    public musqot__Project__c ObjPro{get; set;}
    Public String planeId;
    public boolean showEdt{get;set;}
    public boolean showRec{get;set;}
    public boolean hiderec{get;set;}
    public boolean showEdtbtn{get;set;}
    public String fieldSetName;
    public List<socialmedia_settings__c> SocialFilter_Temp = new List<socialmedia_settings__c>();
    public List<ERP_Settings__c> ERPFilter_Temp = new List<ERP_Settings__c>();
    public List<CRM_Settings__c> CRMFilter_Temp = new List<CRM_Settings__c>();
    public List<musqot__plantype__c> PLAN_Temp = new List<musqot__plantype__c>();
    public List<musqot__Project__c>ObjProj; 
   
    public PlanEditontroller(ApexPages.StandardController controller) {
        ObjProj = new  List<musqot__Project__c>();
        planeId=ApexPages.currentPage().getParameters().get('planId');
        String objectName = 'musqot__Project__c';
        String query = ' SELECT ' ;
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        for(String s : objectFields.keySet()) {
            query += ' ' + s + ',';
        }
        if (query.subString(query.Length()-1,query.Length()) == ','){
            query = query.subString(0,query.Length()-1);
        }
        query += ' FROM ' + objectName + ' WHERE id =:planeId';
        try {
            ObjProj = database.query(query);
            if(objProj.size()>0){
                ObjPro = ObjProj[0];
            }
        } catch (QueryException e){
       } 

       getFieldSet();
       showEdt=true;
       showEdtbtn=false;  
       
        showRec=true;
        hiderec=false;      
    }
    /****************************************************
    PLANList: Convert lookup to dropdown of plantype List
    ******************************************************/
    public List<SelectOption> PLANList 
    {
        get
        {
            PLAN_Temp = [Select u.Name, u.Id From musqot__plantype__c u limit 250];
            PLANList= new List<SelectOption>(); 
            for(musqot__plantype__c objPLA: PLAN_Temp )
            {
                PLANList.add(new SelectOption(objPLA.Id, objPLA.Name));
            }
            return PLANList;
        }
        set;
    }
     /******************************************************************
     SocialFilter(): insert the social performance 
    ********************************************************************/
    public List<SelectOption> SocialFilter{
        get
        {
            SocialFilter_Temp = [Select u.Name, u.Id From socialmedia_settings__c u where type__c='Performance, project' limit 250];
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
        if (this.ObjPro.Social_media__c!=null && this.ObjPro.Social_media__c.contains(s.getValue()))
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
        ObjPro.Social_media__c= selectedConcat;
     }
   } 

    /******************************************************************
     ERPFilter(): insert the erp settings
    ********************************************************************/
    public List<SelectOption> ERPFilter{
        get
        {
            ERPFilter_Temp = [Select u.Name, u.Id From ERP_Settings__c u where ERP_Performance_type__c='Performance, project' limit 250];
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
        if (this.ObjPro.ERP__c!=null && this.ObjPro.ERP__c.contains(s.getValue()))
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
        ObjPro.ERP__c= selectedConcat;
     }
   } 

    /******************************************************************
     CRMFilter(): insert the crm settings 
    ********************************************************************/
    public List<SelectOption> CRMFilter{
        get
        {
            CRMFilter_Temp = [Select u.Name, u.Id From CRM_Settings__c u where CRM_Performance_type__c='Performance, project' limit 250];
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
        if (this.ObjPro.CRM__c!=null && this.ObjPro.CRM__c.contains(s.getValue()))
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
        ObjPro.CRM__c= selectedConcat;
     }
   } 
   
    public PlanEditontroller(){
        
    }
    /**************************************************************
    updPlan(): update the paln and redirects to ProjectDetails page
    ***************************************************************/
    public PageReference updPlan(){       
        if(ObjPro.Starts_date__c>ObjPro.Ends_date__c){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ObjPro.Name +' start date always beyond the end date'));
        return null;
        }
        else if(musqot__Project__c.sObjectType.getDescribe().isUpdateable()){
            update ObjPro;
        }        
        Pagereference PR;
        PR = new Pagereference('/apex/ProjectDetails?id='+EncodingUtil.urlEncode(planeId,'UTF-8'));                  
        return PR ;             
    }
    public PageReference updPlan2(){       
        if(ObjPro.Starts_date__c>ObjPro.Ends_date__c){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ObjPro.Name +' start date always beyond the end date'));
        return null;
        }
        else if(musqot__Project__c.sObjectType.getDescribe().isUpdateable()){
            update ObjPro;
        }        
        Pagereference PR;
        PR = new Pagereference('/apex/ProjectDetails_Resp?id='+EncodingUtil.urlEncode(planeId,'UTF-8'));                  
        return PR ;             
    }
    /*****************************************
    cancel(): redirects to ProjectDetails page  
    ******************************************/
    public PageReference cancel(){
        Pagereference PR;
        PR = new Pagereference('/apex/ProjectDetails?id='+EncodingUtil.urlEncode(planeId,'UTF-8'));                  
        return PR ;
    }
    public PageReference cancel2(){
        Pagereference PR;
        PR = new Pagereference('/apex/ProjectDetails_Resp?id='+EncodingUtil.urlEncode(planeId,'UTF-8'));                  
        return PR ;
    }
    /*************************************
    getFields(): return to  fielset fields
    **************************************/
    public List<schema.fieldsetmember> getFields() { 
        if(!String.isBlank(fieldSetName)){
        Schema.FieldSet fldSet = Schema.SObjectType.Project__c.fieldSets.getMap().get(fieldSetName); 
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
     getFieldsetList(): get the fieldsets 
    ********************************************************************/
        @TestVisible private Project__c getFieldsetList(String planeId) {
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id, Name FROM Project__c where id = :planeId order by LastModifiedDate DESC LIMIT 1';
        return Database.query(query);
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
    /******************************************************************
     getFieldSet(): insert the fieldset into drowp down list in plantype
    ********************************************************************/
    public PageReference getFieldSet(){     
        if(ObjPro.plantype__c != null){
        plantype__c  planType= [SELECT Id,musqot__Fieldset__c FROM musqot__Plantype__c WHERE Id =:ObjPro.musqot__Plantype__c ];
        if(!String.isBlank(planType.musqot__Fieldset__c)){
            fieldSetName = 'musqot__' + planType.musqot__Fieldset__c;
        }
        else{
           fieldSetName = ''; 
        }
        }
        return null;
    }  
}