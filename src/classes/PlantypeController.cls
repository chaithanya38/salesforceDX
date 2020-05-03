/************************************************************
Class Name: PlantypeController
Author:Nagaraju G            Last modified by:G Janardhanreddy   
Date:2/7/2014                         Date: 17/3/2015  
********©2013 Musqot marketing technology Pvt ltd ***********/
public with sharing class PlantypeController {
    Public String planid{get;set;}
    public List<plantype__c> plan { get; set; }
    //public List<plantype__c> tobeDeleted{get ;set;}
    //public string SelectedPlanId { get; set; }
    public PlantypeController() {
        //load account data into our DataTable
        LoadData();
    }
    
    public void LoadData() {//loads plantye records
        
        plan = [Select id, name,Barcolor__c from plantype__c order by name LIMIT 200];
    }
    /***********************************************************************
    DeleteAccount():Delete plantype records and redirect to  MusqotAdminPage
    ************************************************************************/
    public pageReference DeleteAccount(){
        
        LoadData();
        if(plan.size()>0){      
            plantype__c plan = [Select id, name,Barcolor__c from plantype__c where id=:planid]; 
            if (plantype__c.sObjectType.getDescribe().isDeletable())
            {
                delete plan;
            }
        }
        pagereference ref =new pagereference('/apex/MusqotAdminPage');
        ref.setredirect(true);
        return ref;
    }   
    /*******************************************
    NewPrtype():redirect to  related NewPlanType
    ********************************************/
    public PageReference NewPrtype()
    {
        PageReference pg=new PageReference ('/apex/NewPlanType');
        pg.setredirect(true); 
        return pg;
    } 
    /*******************************************
    redirectPage1():redirect to PlanTypeEditPage
    ********************************************/
    public PageReference redirectPage1() {
        PageReference pgr=new PageReference ('/apex/PlanTypeEditPage?id='+EncodingUtil.urlEncode(planid,'UTF-8'));
        return pgr;
    }
    
}