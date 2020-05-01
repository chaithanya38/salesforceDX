/*****************************************************************
Class Name: NewProjectTypeClass 
Author: chaithanya daggumati    Last modified by:Raju Gn
Date: 06/7/2014                 Date:24/03/2015 
Dec:Add Plantype checkbox list
********©2013 Musqot marketing technology Pvt ltd ****************/
public with sharing class NewProjectTypeClass {
    public Project_type__c NewprType{get;set;}
    Transient Map<string,Schema.FieldSet> FsMap ;   
    public List<musqot__plantype__c> planTypeList= new List<musqot__plantype__c>();
    public NewProjectTypeClass(ApexPages.StandardController controller) {
        NewprType=new Project_type__c();
        FsMap = new Map<string,Schema.FieldSet>();              
    }
    /***********************************************************************
    Newrec():  insert newprojecttype record and redirects to MusqotAdminPage
    ************************************************************************/
    Public Pagereference  Newrec()
    {
        if (Project_type__c.sObjectType.getDescribe().isCreateable())
        { 
            
            insert NewprType;
        }
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('proj','UTF-8');
        Pagereference pg=new Pagereference (pageRef);
        return pg;
    }
    /**************************************
    Cancel():  redirects to MusqotAdminPage
    ***************************************/
    Public Pagereference  Cancel()
    {
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('proj','UTF-8');
        Pagereference pg=new Pagereference (pageRef);
        return pg;
    }
     
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
    
    //---Raju Prepared Plantype options---    
    public List<SelectOption>planTypeOptions
    {
        get
        {
            planTypeList=[Select Name,id From plantype__c limit 250];
            planTypeOptions= new List<SelectOption>(); 
            for(plantype__c objPln: planTypeList)
            {
                planTypeOptions.add(new SelectOption(objPln.id,objPln.Name));
            }
            return planTypeOptions;
        }
        set;
    }
 
   public String[] selectedPlanTypes{ 
     get {
          String[] selected = new List<String>();
          List<SelectOption>selectTypes= this.planTypeOptions;
          for(SelectOption s : selectTypes) {
          if (this.NewprType.Plantype__c!=null && this.NewprType.Plantype__c.contains(s.getValue()))
              selected.add(s.getLabel());
          }
          return selected;
       }
    set{
          List<string> selVal=new list<string>();
          String selectedPlTypes= '';
          for(musqot__Plantype__c s:[Select Name From plantype__c where id IN:value]){          
            selVal.add(s.name);
         }
         for(String s: selVal){
            if (selectedPlTypes== '') 
                selectedPlTypes+= s;
            else selectedPlTypes+= ',' + s;
         }
         NewprType.musqot__Plantype__c= selectedPlTypes;
      }
    } 
    
    //-----End---
}