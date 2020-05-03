/****************************************************************
Class Name: ActivityEditController
Author:Nagaraju G               Last modified by:Raju GN
Date:  10/7/2014                Date:18/03/2015
Description:Remove unnecessry veriables and comments and debug statements
********©2013 Musqot marketing technology Pvt ltd ***************/
public with sharing class ActivityEditController{  
   Public String planid{get;set;}
   public List <Activitytype__c> plan { get; set;}
   public PageReference redirectPage1(){
     String tabId = System.currentPageReference().getParameters().get('sfdc.tabName'); 
     PageReference pgr=new PageReference ('/apex/ActivityEditPage?id='+EncodingUtil.urlEncode(planid,'UTF-8')+'&tabid='+EncodingUtil.urlEncode(tabid,'UTF-8')); 
     return pgr;
    }
    /************************************
    LoadData():  load Activitytype records
    *************************************/
    public void LoadData()
    {
        plan = [Select id,name,Icon__c,Bar_color__c, F__c from Activitytype__c order by name limit 20];
    }
    public String getPln(){
        return null;
    }
    public ActivityEditController(ApexPages.StandardController controller) {
        planid=ApexPages.currentPage().getParameters().get('id');
        List<Activitytype__c >Plans=[SELECT id,Name,Icon__c,Bar_color__c, F__c from Activitytype__c where id=:Planid ];
        if (Plans.size() > 0)
        {
            Activitytype__c a = Plans.get(0);
        }
        LoadData();
    }
    //load  Activity data into our DataTable
    public ActivityEditController() {
        planid=ApexPages.currentPage().getParameters().get('id');
        LoadData();
    }
    /*******************************************************************************
    DeleteAccount():Delete the Activitytype records and redirect to  MusqotAdminPage
    ********************************************************************************/
    public pageReference DeleteAccount(){
        LoadData();
        List<Activitytype__c> act = [Select id, name,Icon__c,Bar_color__c from Activitytype__c where id=:planid];
        if (act.size() > 0)
        {
            Activitytype__c a = act.get(0);
        }
        if (Activitytype__c.sObjectType.getDescribe().isDeletable())
        {
            delete act; 
        }
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('mar','UTF-8');
        Pagereference pg=new Pagereference (pageRef);
        return pg;
    } 
    /******************************************
    NewPrtype():create new Activitytype records
    *******************************************/
    public PageReference NewPrtype(){
        PageReference pg=new PageReference ('/apex/NewActivityType');
        pg.setredirect(true); 
        return pg;
    } 
    /*********************************************************************
    Save():update  Activitytype records and redirect to  ActivitytypesPage
    **********************************************************************/
    public Pagereference Save(){ 
    string Plansid;
    Activitytype__c  actty=new Activitytype__c ();
    try {
            actty= [Select id, name,Icon__c,Bar_color__c from Activitytype__c where id=:Plansid limit 1];
            if (Activitytype__c.sObjectType.getDescribe().isUpdateable())
            {
                Update actty;
            }
        }
        catch(exception e){}
        Pagereference pg=new Pagereference ('/apex/ActivitytypesPage');
        return pg;
    }
    //redirect to  ActivitytypesPage
    public Pagereference Cancel(){
    Pagereference pg=new Pagereference ('/apex/ActivitytypesPage');
    return pg;
    }
   public static String GetResourceURL(String resourceName){
    List<StaticResource> resourceList = [
        SELECT Name, NamespacePrefix, SystemModStamp 
        FROM StaticResource 
        WHERE Name = :resourceName];
    if (resourceList.size() == 1) {
            String namespace = resourceList[0].NamespacePrefix;
            return '/resource/' 
                + resourceList[0].SystemModStamp.getTime() + '/' 
                + (namespace != null && namespace != '' ? namespace + '__' : '') 
                + resourceName; 
        } else return '';
        
    }
    
}