/*******************************************************
Class Name: PlantypePageController 
Author:Nagaraju G               Last modified by: G Janardhanreddy
Date: 22/7/2014                   Date:  20/03/2015
********©2013 Musqot marketing technology Pvt ltd *******/

public with sharing class PlantypePageController {
    Public String planid{get;set;}
    public List<plantype__c> plan{get; set;}
    //public List<plantype__c> tobeDeleted{get;set;}
    //public string SelectedPlanId {get; set;}
    public PlantypePageController() {
        LoadData();
       
    }
    /********************************
    LoadData(): load plantype records
    **********************************/
    public void LoadData() {
        plan = [Select id, name,Barcolor__c,Fieldset__c from plantype__c order by name LIMIT 200];
    }
    /************************************************************************
    DeleteAccount(): delete plantype records and redirects to MusqotAdminPage
    *************************************************************************/
    public pageReference DeleteAccount(){
        plantype__c plan;
        LoadData();
        
        //if(plan.size()>0){
            try{            
                plan = [Select id, name,Barcolor__c,Fieldset__c from plantype__c where id=:planid]; 
              }catch(Exception e){}  
            if (plantype__c.sObjectType.getDescribe().isDeletable())
            {
                if(plan<>null)
                delete plan;
            } 
          //  }
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('plns','UTF-8');
            Pagereference pg=new Pagereference (pageRef);
            return pg;            
       }
    /****************************************************************
    NewPrtype(): create newplantype and redirects to NewPlanType page
    *****************************************************************/    
    public PageReference NewPrtype()
    {
        PageReference pg=new PageReference ('/apex/NewPlanType');
        pg.setredirect(true); 
        return pg;
    }
    /*********************************************
    redirectPage1():  redirect to PlanTypeEditPage
    **********************************************/ 
    public PageReference plantypedit() {
      String tabId = System.currentPageReference().getParameters().get('sfdc.tabName');  
       PageReference pgr=new PageReference ('/apex/PlanTypeEditPage?id='+EncodingUtil.urlEncode(planid,'UTF-8')+'&tabid='+EncodingUtil.urlEncode(tabid,'UTF-8'));
        return pgr;  
         }   
}