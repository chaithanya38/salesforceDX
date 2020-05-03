/****************************************************************
Class Name: PlanEditController 
Author:chaithanya daggumati     Last modified by: G Janardhanreddy
Date: 10/7/2014                 Date: 7/1/2015  
********©2013 Musqot marketing technology Pvt ltd ****************/

public with sharing class PlanEditController {
    Public String Planid{get;set;}
    Public plantype__c Plans{get;set;}
    Transient Map<string,Schema.FieldSet> FsMap ;
    public PlanEditController(ApexPages.StandardController controller) {
    FsMap = new Map<string,Schema.FieldSet>();
        planid=ApexPages.currentPage().getParameters().get('id');
        try{
            Plans=[SELECT id,Name,Barcolor__c,musqot__Fieldset__c from plantype__c where id=:Planid];
        }catch(Exception e){}
    }
    /************************************************
    Fieldsetlist: it return list of Field set records
    *************************************************/ 
     public List<SelectOption> Fieldsetlist
     {
     get
        {
            List<SelectOption> fieldSetListTmp = new List<SelectOption>();
            schema.DescribeSObjectResult dsr = musqot__Project__c.sObjectType.getDescribe();
            FsMap = dsr.fieldSets.getMap();
            fieldSetListTmp.add(new SelectOption('','--None--'));
            for(Schema.FieldSet fldSet : FsMap.values()){                 
                fieldSetListTmp.add(new SelectOption(fldSet .getName(),fldSet.getLabel())); 
            }
            if(fieldSetListTmp.isEmpty()){
                fieldSetListTmp .add(new SelectOption('','--None--')); 
            }
            return fieldSetListTmp ;
        }
        set;
    } 
    
    /********************************************************
    save():  update plantype and redirects to MusqotAdminpage
    *********************************************************/    
    public Pagereference save(){ 
        if (plantype__c.sObjectType.getDescribe().isUpdateable())
        {  
            Update Plans;
        }
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('plns','UTF-8');
            Pagereference pg=new Pagereference (pageRef);
            return pg;
       
        }
    
     /************************************
    Cancel(): redirects to MusqotAdminpage
    **************************************/ 
    public Pagereference Cancel(){
      String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('plns','UTF-8');
        Pagereference pg=new Pagereference (pageRef);
        return pg;
      /*  string pageRef='/apex/MusqotAdminPage';  
        Pagereference PR = new Pagereference(pageRef);                  
        return PR ;*/
    }     
}