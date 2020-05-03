/*****************************************************************
Class Name: SubprojecteditEditontroller
Author:Nagaraju G               Last modified by: G Janardhanreddy
Date: 10/9/2014                 Date: 16/03/2015 
********©2013 Musqot marketing technology Pvt ltd ****************/

public with sharing class SubprojecteditEditontroller{
    ApexPages.Standardcontroller controller;
    public Subproject__c objSubpro{get;set;}
    public Project__c objpro{get;set;}
    Public String subproId;
    Public String proId;
    Public String PlanType;
    public boolean showEdt{get;set;}
    public boolean showRec{get;set;}
    public boolean hiderec{get;set;}
    public boolean showEdtbtn{get;set;}
    public List<socialmedia_settings__c> SocialFilter_Temp = new List<socialmedia_settings__c>();
    public List<ERP_Settings__c> ERPFilter_Temp = new List<ERP_Settings__c>();
    public List<CRM_Settings__c> CRMFilter_Temp = new List<CRM_Settings__c>();
    public List<musqot__Project_type__c> PRO_Temp = new List<musqot__Project_type__c>();    
    public List<musqot__Subproject__c>Objsubproj;
    public List<Project__c>Objproj; 
    public String fieldSetName;
    
    public SubprojecteditEditontroller(ApexPages.StandardController controller){
    this.objSubpro= (Subproject__c)controller.getRecord();   
        Objsubproj=new list<musqot__Subproject__c>();        
        //Objproj=new list<Project__c>();                     
        subproId=ApexPages.currentPage().getParameters().get('projectid');                               
                String objectName = 'musqot__Subproject__c';  // modify as needed
                String query = ' SELECT ' ;
            Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        // Grab the fields from the describe method and append them to the queryString one by one.
        for(String s : objectFields.keySet()) {
            query += ' ' + s + ',';
        }        
        // Strip off the last comma if it exists.
        if (query.subString(query.Length()-1,query.Length()) == ','){
            query = query.subString(0,query.Length()-1);
        }
                query += ' FROM ' + objectName + ' WHERE id =:subproId';
        try {
            Objsubproj= database.query(query);
            objSubpro= Objsubproj[0];
            
        } catch (QueryException e){
            //perform exception handling
        }       
         Objproj=new list<Project__c>(); 
         Objproj = [Select  name, plantype__r.name From Project__c where id =:objSubpro.Parent_project__c limit 1 ];
        if(Objproj.size() > 0) {
        PlanType = Objproj[0].plantype__r.name;
        }
        getCustomSettRec();
        showEdt=true;
        showEdtbtn=false;  
       
      showRec=true;
      hiderec=false;              
    } 
    /********************************************************
    PROTList: Convert lookup to dropdown list of Project type
    *********************************************************/
    public List<SelectOption> PROTList
        
    {
        get
        {
            PRO_Temp = [Select u.Name, u.Id, plantype__c From Project_type__c u Order by Name limit 250 ];
            PROTList= new List<SelectOption>(); 

            string pt ='';
            for(musqot__Project_type__c objSubproT : PRO_Temp )
            {
                pt = objSubproT.plantype__c +'';
                if(pt.contains(PlanType) || pt.contains('null')) {
                    PROTList.add(new SelectOption(objSubproT.Id, objSubproT.Name));
               }
            }
            return PROTList;
        }
        set;
    }
    public SubprojecteditEditontroller(){
        
    }
    /*************************************************************
    save(): update the Subproject and redirects to Subproject page
    **************************************************************/
    public PageReference save(){
    //chaithanya modified start
    List<Subproject__c> sbp =[SELECT Id,Name,Project_del__r.Starts_date__c,Project_del__r.Name,Parent_project__c,Parent_project__r.Name,Parent_project__r.Starts_date__c,
                                Starts_date__c,Ends_date__c from Subproject__c where Id=:subproId];
    //chaithanya modified end                                                                                
        if(subproId<>null){
            if(objSubpro.musqot__Ends_date__c<sbp[0].Parent_project__r.Starts_date__c){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, objSubpro.Name + ' should not end before ' + sbp[0].Parent_project__r.Name+ ' startdate'));
            return null;
                }
         else if(objSubpro.musqot__Ends_date__c<sbp[0].Project_del__r.Starts_date__c){
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, objSubpro.Name + ' should not end before ' + sbp[0].Project_del__r.Name+ ' startdate'));
            return null;
         }
         else if (musqot__Subproject__c.sObjectType.getDescribe().isUpdateable()){
            update objSubpro;
            } 
       }
        Pagereference PR;
        PR = new Pagereference('/apex/SubProject?id='+EncodingUtil.urlEncode(subproId,'UTF-8'));                  
        return PR ;        
    }
    /***************************************
      cancel(): redirects to Subproject page
    ****************************************/
    public PageReference cancel(){
        Pagereference PR;
        PR = new Pagereference('/apex/SubProject?id='+EncodingUtil.urlEncode(subproId,'UTF-8'));                  
        return PR ;
    }
    
    /************************************************************
    getFieldsetList(String subproId): to get set of FieldsetLists 
    *************************************************************/
    @TestVisible private musqot__Subproject__c getFieldsetList(String subproId) {
        String query = 'SELECT ';
        for(Schema.FieldSetMember f : this.getFields()) {
            query += f.getFieldPath() + ', ';
        }
        query += 'Id, Name FROM Subproject__c where id = :subproId order by LastModifiedDate DESC LIMIT 1';
        return Database.query(query);
    }
     public List<schema.fieldsetmember> getFields() { 
        if(!String.isBlank(fieldSetName)){
        Schema.FieldSet fldSet = Schema.SObjectType.Subproject__c.fieldSets.getMap().get(fieldSetName); 
         if(fldSet<>null){
                return fldSet.getFields();
            }
            else{
                return new List<schema.fieldsetmember>();
            }
      }
      else {
            return new List<schema.fieldsetmember>();
        }  
     }
/******************************************************************
     Performance(): insert the performance 
********************************************************************/
    public List<SelectOption> SocialFilter{
        get
        {
            SocialFilter_Temp = [Select u.Name, u.Id From socialmedia_settings__c u where type__c='Performance, project'   limit 250];
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
        if (this.objSubpro.Social_media__c!=null && this.objSubpro.Social_media__c.contains(s.getValue()))
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
        objSubpro.Social_media__c= selectedConcat;
     }
   } 
    public List<SelectOption> ERPFilter{
        get
        {
            ERPFilter_Temp = [Select u.Name, u.Id From ERP_Settings__c u where ERP_Performance_type__c='Performance, project'   limit 250];
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
        if (this.objSubpro.ERP__c!=null && this.objSubpro.ERP__c.contains(s.getValue()))
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
        objSubpro.ERP__c= selectedConcat;
     }
   } 
    public List<SelectOption> CRMFilter{
        get
        {
            CRMFilter_Temp = [Select u.Name, u.Id From CRM_Settings__c u where CRM_Performance_type__c='Performance, project'   limit 250];
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
        if (this.objSubpro.CRM__c!=null && this.objSubpro.CRM__c.contains(s.getValue()))
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
        objSubpro.CRM__c= selectedConcat;
     }
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
     getCustomSettRec(): get the customsetting record
********************************************************************/      
      public PageReference getCustomSettRec(){        
        if(objSubpro.musqot__Project_type__c != null){
        Project_type__c  proType = [SELECT Id, Fieldset__c FROM Project_type__c  WHERE Id =:objSubpro.musqot__Project_type__c  ];
        if(!String.isBlank(proType.Fieldset__c)){
            fieldSetName = 'musqot__' + proType.Fieldset__c;
        }
        else{
           fieldSetName = ''; 
        }       
        }
        return null;
    }  
}