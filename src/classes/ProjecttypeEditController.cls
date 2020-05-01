/*******************************************************
Class Name: ProjecttypeEditController 
Author:Nagaraju G               Last modified by: G Janardhanreddy
Date: 09/7/2014                   Date: 20/03/2015 
********©2013 Musqot marketing technology Pvt ltd *******/
public with sharing class ProjecttypeEditController {
    Public String PageId{get;set;}
    public String Val{get;set;}   
    Public Project_type__c ProjectType{get;set;}
    public Project_type__c NewprType{get;set;}
    public Set<String> stPlanTypes = new Set<String>();
    public List<SelectOption> planTypeOptions1 = new List<SelectOption>();
    Transient Map<string,Schema.FieldSet> FsMap ;
    public List<String> selectedPlanTypes{get;set;}
    //public List<String> planTypeOptions{get;set;}    
    public List<musqot__plantype__c> planTypeList= new List<musqot__plantype__c>();
    public ProjecttypeEditController(ApexPages.StandardController controller) {        
        PageId=ApexPages.CurrentPage().getParameters().get('id');
        NewprType=new Project_type__c();
        FsMap = new Map<string,Schema.FieldSet>();
        selectedPlanTypes = new List<String>(); 
        try{
            ProjectType=[select id,Name,Color__c,Fieldset__c,Plantype__c from Project_type__c where id=:PageId];
            if(!String.isBlank(ProjectType.Plantype__c)){
                for(String str : ProjectType.Plantype__c.split(';')){
                    stPlanTypes.add(str);
                }
            }
            planTypeList=[Select Name,id From plantype__c limit 250];
            if(!stPlanTypes.isEmpty()){
              for(musqot__plantype__c planType : planTypeList) {                  
                  if(stPlanTypes.contains(plantype.Name)){                      
                      selectedPlanTypes.add(plantype.Id);
                  }              
              } 
          }            
        }catch(exception e){}
               
    }
    //---chaithanya Prepared Plantype options---     
    public List<SelectOption>planTypeOptions
    {
        get
        {
            
            planTypeOptions= new List<SelectOption>();             
            for(plantype__c objPln: planTypeList)
            {
                planTypeOptions.add(new SelectOption(objPln.id,objPln.Name));
            } 
            planTypeOptions1.addAll(planTypeOptions);         
            return planTypeOptions;            
        }        
        set;
    }
    /**************************************
     Fieldsetlist:it returns field set list
    ***************************************/
    public List<SelectOption> Fieldsetlist
    {
        get
        {
            List<SelectOption> fieldSetListTmp = new List<SelectOption>();
            schema.DescribeSObjectResult d = musqot__Subproject__c.sObjectType.getDescribe();
            FsMap = d.fieldSets.getMap();
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
    /************************************************************************
    Save():  update the projecttype records  and redirects to MusqotAdminPage 
    *************************************************************************/
    public Pagereference Save(){ 
        if (Project_type__c.sObjectType.getDescribe().isUpdateable()){
            List<string> selVal=new list<string>();
            String selectedPlTypesStr= '';
            for(musqot__Plantype__c s:[Select id,Name From plantype__c where id IN:selectedPlanTypes]){
            selVal.add(s.name);
            }
            for(String s: selVal){
            if (selectedPlTypesStr== '') 
                selectedPlTypesStr+= s;
            else selectedPlTypesStr+= ';' + s;
            }        
            ProjectType.Plantype__c= selectedPlTypesStr;
            Update ProjectType;
        }
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('proj','UTF-8');
        Pagereference pg=new Pagereference (pageRef);
        return pg;
    }
    /************************************
    Cancel():redirects to MusqotAdminPage
    *************************************/
    public Pagereference Cancel(){
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('proj','UTF-8');
        Pagereference pg=new Pagereference (pageRef);
        return pg;
    }    
}