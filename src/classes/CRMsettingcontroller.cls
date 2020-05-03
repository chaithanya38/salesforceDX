/*******************************************************
Class Name: CRMsettingcontroller
Author:G Janardhanreddy     Last modified by:G Janarhanreddy
Date:  03/07/2015           Date:03/07/2015
********©2013 Musqot marketing technology Pvt ltd *******/
public with sharing class CRMsettingcontroller{
    private ApexPages.StandardController sc;
    public CRM_settings__c  Objcrm{get; set;}
    public CRM_settings__c crms{get;set;}
    public Lead leadsrce{get;set;}
    public List<Lead> leadtemp = new List<Lead>();
    //public Summary[] Campaigns { get; set; }
    public Summary[] Leads { get; set; }
    public Activity__c  musact;
    public boolean level1{get;set;}
    public id crmid;
    public boolean stdObjectLead {get;set;}
    //public boolean stdObjectCampaign {get;set;}
    
    public CRMsettingcontroller() {
        This.sc = sc;
        Objcrm= new  CRM_settings__c  ();
        crms= new musqot__CRM_settings__c();
        AggregateResult[] results = [SELECT Business_region__c name 
                                     FROM CRM_data__c group by Business_region__c limit:100];
        Leads = new List<Summary>();
        for (AggregateResult ar : results) {
            Leads.add(new Summary(ar));
        }
        AggregateResult[] results2 = [SELECT  Business_area__c name 
                                      FROM CRM_data__c group by Business_Area__c limit:100];
        /*Campaigns = new List<Summary>();            
        for (AggregateResult ar : results2) {
            Campaigns.add(new Summary(ar));
        }*/
        
        musact=[SELECT id, Use_milestones__c, Use_Performance_CRM__c 
                FROM Activity__c limit 1]; // musqot__Activity__c == API name for musqot settings 
        stdObjectLead=False;
        //stdObjectCampaign=False;
        level1=false;
        
        if(musact.Use_Performance_CRM__c=='Salesforce (in same org)'){
            level1=true;
            //To check if Lead and Campaign object excist            
            for ( Schema.SObjectType typ : Schema.getGlobalDescribe().values()){
                String sobjSF = String.valueOf(typ);
                if (sobjSF.equals('Lead')){
                    stdObjectLead= true;
                }
                //if (sobjSF.equals('Campaign')){
                    //Campaigns();
                //    stdObjectCampaign= true;
                //}
            }
        } 
    }
    
    // wrapper class to hold aggregate data
   public class Summary {
        public String Name { get; private set; }
        public Summary(AggregateResult ar) {
            Name = (String) ar.get('name');
        }
    }
    
    /***************************************************************************************
insertcrms():create new musqot__CRM_settings__crecords and redirect to  MusqotAdminPage
****************************************************************************************/
    public Pagereference insertcrms() {
        
        // added by Narendra -- start --
        // schedule milestone update job here
        try{
            List<CRM_settings__c> cmrs = [SELECT Id, name from CRM_settings__c where CRM_performance_type__c= 'Milestone'];
            if(cmrs.size() > 0) {
                Date tomorrowsDate = System.today().addDays(1);
                Integer day = tomorrowsDate.day();
                Integer month = tomorrowsDate.month();
                Integer year = tomorrowsDate.year();
                String SchTimer='0 10 1 '+day+' '+month+' ? '+year;   //  next day 1:10 AM
                System.schedule('CRMMilestoneUpdateSchedulerJob', SchTimer, new CRMMilestoneUpdateScheduler());
            }
        }catch(Exception e){
            System.debug('Exception : ' + e.getMessage());
        }
        // added by Narendra -- end --
        
        if (CRM_settings__c.sObjectType.getDescribe().isCreateable())
            if(crms.Bar_color__c<>null){
                crms.Bar_color__c = crms.Bar_color__c.replaceAll(' ','');
            }
        {
            if(crms.CRM_performance_type__c!='Performance, General'){
                crms.Selector__c='';
            }
            insert crms;
        }
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('mpsett','UTF-8');
        Pagereference pg=new Pagereference (pageRef);
        return pg;
    }
    /***************************************************************************************
cancel():redirect to  MusqotAdminPage
****************************************************************************************/
    Public Pagereference cancel()
    {
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('mpsett','UTF-8');
        Pagereference pg=new Pagereference (pageRef);
        return pg;
    }
    /***************************************************************************************
getMyOptions():select options from musqot admin page
****************************************************************************************/
    public List<SelectOption> getMyOptions() {
        List<SelectOption> options = new List<SelectOption>(); 
        Schema.DescribeFieldResult field = CRM_Settings__c.CRM_performance_type__c.getDescribe();
        for (Schema.PicklistEntry f : field.getPicklistValues()){
            if(musact.Use_milestones__c ==false){
                if(f.getLabel()!='Milestone'){
                    options.add(new SelectOption(f.getLabel(), f.getLabel()));
                }
            }else
                options.add(new SelectOption(f.getLabel(), f.getLabel()));
        }   
        return options;     
    }
    /***************************************************************************************
getwatchtype():select options from musqot admin page
****************************************************************************************/
    public List<SelectOption> getwatchtype()
    {
        List<SelectOption>options = new List<SelectOption>();    
        Schema.DescribeFieldResult fieldResult =CRM_settings__c.Watch_type__c.getDescribe();
        List<Schema.PicklistEntry> crmwatch= fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f:crmwatch)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }
    /***************************************************************************************
getleadsources():get the leadsources from lead object
****************************************************************************************/
    public List<SelectOption> getleadsources{
        get
        { 
            if(stdObjectLead){
                //
                leadtemp=[SELECT Id, Name FROM Lead limit 250];
                Schema.DescribeFieldResult leadPickList =Lead.Leadsource.getDescribe();
                List<Schema.PicklistEntry> leadsourceList= leadPickList.getPicklistValues();
                getleadsources = new List<SelectOption>();
                for( Schema.PicklistEntry le:leadsourceList){
                    
                    getleadsources .add(new SelectOption(le.getLabel(), le.getValue()));
                }       
                return getleadsources;
            } 
            return null;  
        }
        set;               
    } 
    public String[] LeadItems { 
        get {
            String[] selected = new List<String>();
      //    List<SelectOption> sos = this.getleadsources;
            for(SelectOption s : this.getleadsources){
                if(this.Objcrm.Expression_business_region__c!=null && this.Objcrm.Expression_business_region__c.contains(s.getValue()))
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
            Objcrm.Expression_business_region__c = selectedConcat;
        }
    }
    /***************************************************************************************
getCampaigns():get the Campaign names from Campaigns object
****************************************************************************************/
   
   // public List<SelectOption> getCampaigns{
   //     get
   //     {
   //         if(stdObjectCampaign){
            /* 
            ------- this need to be fixed same way without get campaign obj requered in the package   ----
               List<Campaign> camptemp = new List<Campaign>();

                camptemp=[SELECT  Name FROM Campaign where EndDate>=:system.today() limit 100];
                getCampaigns = new List<SelectOption>();
                for(Campaign objld : camptemp){
                    if(objld.name!=null||test.isrunningtest()){ 
                        getCampaigns.add(new SelectOption(objld.name,objld.name));  
                    }  
                }
                return getCampaigns;
                
              */
    //              return null; 
     //       }
     //       return null;    
     //   }
    //    set;               
   // } 
  
    //public String[] campItems { 
    //    get {
     //       String[] selected = new List<String>();
         //   List<SelectOption> sos = this.getCampaigns;
     //       for(SelectOption s : this.getCampaigns) {
     //           if (this.Objcrm.Expression_business_area__c!=null && this.Objcrm.Expression_business_area__c.contains(s.getValue()))
     //               selected.add(s.getValue());
      //      }
      //      return selected;
      //  }public set {
      //      String selectedConcat = '';
     //       for(String s : value) {
     //           if (selectedConcat == '') 
//                    selectedConcat += s;
     //           else selectedConcat += ';' + s;
     //       }
     //       Objcrm.Expression_business_area__c= selectedConcat;
     //   }
   // } 
}