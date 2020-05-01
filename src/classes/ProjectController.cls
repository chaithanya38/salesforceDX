/*******************************************************
Class Name: ProjectController 
Author:Nagaraju G               Last modified by: Chaithanya Daggumati
Date: 10/9/2014                     Date: 25/03/2015 
********©2013 Musqot marketing technology Pvt ltd *******/

public with sharing class ProjectController {    
    public Project__c Objprj{get;set;}
    //public Project__c  obPro { get; set; }
    public string planId;
    public List<SelectOption> PLANList{get;set;}    
    public List<musqot__plantype__c> PLAN_Temp = new List<musqot__plantype__c>();
    public String fieldSetName;
    
    public ProjectController(ApexPages.StandardController controller) { 
        Objprj=new Project__c();       
        planId = controller.getRecord().id;
        PLANList= new List<SelectOption>();
        PLAN_Temp = [Select u.Name, u.Id  From musqot__plantype__c u limit 250];
        for(musqot__plantype__c objPLA: PLAN_Temp )
        {
            PLANList.add(new SelectOption(objPLA.Id, objPLA.Name));
        }
        if(!PLAN_Temp.isEmpty()){
            Objprj.Plantype__c = PLAN_Temp[0].Id;
        }
        FieldSetName();
    }
    /**************************************
     getFields(): To get fieldsetname
    ***************************************/
    public List<schema.fieldsetmember> getFields() { 
        if(!String.isBlank(fieldSetName)){
        Schema.FieldSet fldSet = Schema.SObjectType.musqot__Project__c.fieldSets.getMap().get(fieldSetName);            
            if(fldSet<>null){
                return fldSet.getFields();
            }
            else{
                return new List<schema.fieldsetmember>();
            }
        }
        else{
            return null;//new List<schema.fieldsetmember>();
        }  
    } 
    public Project__c getProjectController() {  
        String query = 'SELECT ';  
        for(Schema.FieldSetMember f : this.getFields()) {  
            query += f.getFieldPath() + ', ';  
        }  
       query += 'Id, Name,musqot__Description__c,musqot__Ends_date__c,musqot__Starts_date__c,musqot__Status__c,musqot__StatusImage__c,musqot__Headline__c,musqot__Plantype__c   FROM Project__c LIMIT 1';  
        return Database.query(query);  
    }  
  
    public ProjectController(){
    }
     /***************************************************************************
     save(): insert the plan type records and redirect to ProjectDetails page
     ****************************************************************************/
    public PageReference save(){
    //chaithanya modified start
    List<Project__c> lstprj = [SELECT Id,Name from Project__c where Name=:Objprj.Name]; // Id=:planId AND  
        if(lstprj.size()>0){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.pt_Plan_name_already_exist));
        return null;
        }            
        else if(Objprj.Starts_date__c>Objprj.Ends_date__c){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Objprj.Name +' start date always beyond the end date'));
        return null;
        }
        else if (Project__c.sObjectType.getDescribe().isCreateable()){        
            insert Objprj;
        }
      //chaithanya modified end
        id planId=Objprj.id; 
        Pagereference PR;        
        PR = new Pagereference('/apex/ProjectDetails?id='+EncodingUtil.urlEncode(planId,'UTF-8'));                  
        return PR ;               
    }
	/*******Not Required**********/
    public PageReference save2(){
        //chaithanya modified start
        List<Project__c> lstprj = [SELECT Id,Name from Project__c where Name=:Objprj.Name]; // Id=:planId AND  
        if(lstprj.size()>0){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.pt_Plan_name_already_exist));
            return null;
        }            
        else if(Objprj.Starts_date__c>Objprj.Ends_date__c){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Objprj.Name +' start date always beyond the end date'));
            return null;
        }
        else if (Project__c.sObjectType.getDescribe().isCreateable()){        
            insert Objprj;
        }
        //chaithanya modified end
        id planId=Objprj.id; 
        Pagereference PR;        
        PR = new Pagereference('/apex/ProjectDetails_resp?id='+EncodingUtil.urlEncode(planId,'UTF-8'));                  
        return PR ;               
    }
	/*******Not Required**********/
    /**************************************
     cancel():  redirect to objPrefix page
    ***************************************/
    public PageReference cancel(){        
        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
        String objPrefix = globalDescribe.get('musqot__Project__c').getDescribe().getkeyprefix();
        PageReference prRef = new PageReference('/' + objPrefix+'/o');
        prRef.setRedirect(true);
        
        return prRef;
    }
     /***********************************************************
         getFieldSet(): Get FieldSet from Project object
     *************************************************************/
    public PageReference FieldSetName(){
        if(Objprj.Plantype__c != null){
        plantype__c planType = [SELECT Id,musqot__Fieldset__c FROM musqot__plantype__c WHERE Id =:Objprj.Plantype__c];
        if(planType.musqot__Fieldset__c<>null){
            if(!String.isBlank(planType.musqot__Fieldset__c)){
                fieldSetName = 'musqot__' + planType.musqot__Fieldset__c;
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
}