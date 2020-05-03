/***************************************************************
Class Name: ProjectEditController 
Author:Nagaraju G          Last modified by:Raju GN

Date: 9/7/2014             Date: 12/8/2015 
//duae to codecoverage edit the DeleteProject()
********©2013 Musqot marketing technology Pvt ltd ***************/

public with sharing class ProjectEditController {
    public List<Project_type__c> plan {get; set;}
    public string planid{get;set;}
    //public string SelectedPlanId {get; set;}
    Public String ProjectId{get;set;}
    public List<plantype__c> Plantype_Temp = new List<plantype__c>();
    public PageReference ProjectEdit() {
        String tabId = System.currentPageReference().getParameters().get('sfdc.tabName');        
        PageReference prj=new PageReference ('/apex/ProjecttypeEditpage?id='+EncodingUtil.urlEncode(ProjectId,'UTF-8')+'&tabid='+EncodingUtil.urlEncode(tabid,'UTF-8'));
        return prj;
    }
    /****************************************************************
     PlantypeList: Convert lookup to dropdown list of ProjecttypeList
    *****************************************************************/ 
    public List<SelectOption> PlantypeList
    {
        get
        {
            Plantype_Temp = [Select u.Name, u.Id, Fieldset__c From plantype__c u limit 250];
            PlantypeList = new List<SelectOption>(); 
            for(plantype__c temp : Plantype_Temp)
            {
                PlantypeList.add(new SelectOption(temp.Id, temp.Name));
            }
            return PlantypeList;
        }
        set;
    }
    public ProjectEditController(ApexPages.StandardController controller) {        
    }
    /*************************************
    getPln(): it returns list of plantypes
    **************************************/ 
    public String getPln() {
        return null;
    }
    public ProjectEditController () {
        LoadData();
    }
    /*************************************
    LoadData():  Load Projecttypes records
    **************************************/ 
    public void LoadData() {
        try {
            plan = [Select id, name,Color__c, Fieldset__c, Plantype__c from Project_type__c order by name limit 250];
        }
        catch (System.QueryException e) {
        }
        
    }
    
   /**********************************************************************
    NewPrtype(): create newprojecttype and redirects to NewProjectType page
    ***********************************************************************/   
    public PageReference NewPrtype()
    {
        PageReference pg=new PageReference ('/apex/NewProjectType');
        pg.setredirect(true); 
        return pg;
    }
    /**********************************************************************
    DeleteProject(): delete newprojecttype and redirects to MusqotAdminpage
    ***********************************************************************/  
    public pageReference DeleteProject(){
        Project_type__c pro;
        LoadData();
        try{
         pro = [Select id, name,Color__c from Project_type__c where id=:planid];
        }catch(Exception e){}
        if (Project_type__c.sObjectType.getDescribe().isDeletable())
        {
         if(pro<>null)
            delete pro;
        }
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('proj','UTF-8');
        Pagereference pg=new Pagereference (pageRef);
        return pg;
    }    
}