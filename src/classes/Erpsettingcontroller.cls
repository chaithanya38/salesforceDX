/*******************************************************
Class Name: Erpsettingcontroller
Author:G Janardhanreddy     Last modified by:G Janarhanreddy
Date:  18/11/2014           Date:19/03/2015
********©2013 Musqot marketing technology Pvt ltd *******/
public with sharing class Erpsettingcontroller {
    private ApexPages.StandardController sc;
    public ERP_Settings__c erps{get;set;}
    public Summary[] Areas { get; set; }
    public Summary[] Regions { get; set; }
    public id erpid;
    public  musqot__Activity__c  mus;
    public  Erpsettingcontroller() {
        This.sc = sc;
        erps= new musqot__ERP_Settings__c ();
        
        AggregateResult[] results = [SELECT  Business_region__c name FROM ERP_sales_obj__c group by Business_region__c limit:100];
        Regions = new List<Summary>();
        for (AggregateResult ar : results) {
            Regions.add(new Summary(ar));
        }
        AggregateResult[] results2 = [SELECT  Business_Area__c name FROM ERP_sales_obj__c group by Business_Area__c limit:100];
        Areas = new List<Summary>()
            ;
        for (AggregateResult ar : results2) {
            Areas.add(new Summary(ar));
        }
      
         mus=[SELECT id,Use_milestones__c FROM musqot__Activity__c limit 1];//musqot__Activity__c -- API name for Musqot Settings
             
      }
        // wrapper class to hold aggregate data
        public class Summary {
            public String Name { get; private set; }
            public Summary(AggregateResult ar) {
               Name = (String) ar.get('name');
            }
        }
    
    /***************************************************************************************
    inserterps():create new musqot__ERP_Settings__c records and redirect to  MusqotAdminPage
    ****************************************************************************************/
    public Pagereference inserterps() {
        
        // added by Narendra -- start --
        // schedule milestone update job here
        try{
            List<ERP_Settings__c> erps = [SELECT Name, Id FROM ERP_Settings__c where ERP_performance_type__c = 'Milestone'];
            if(erps.size() > 0) {
                Date tomorrowsDate = System.today().addDays(1);
                Integer day = tomorrowsDate.day();
                Integer month = tomorrowsDate.month();
                Integer year = tomorrowsDate.year();
                String SchTimer='0 5 1 '+day+' '+month+' ? '+year;   //  next day 1:05 AM
                System.schedule('ERPMilestoneUpdateSchedulerJob', SchTimer, new ERPMilestoneUpdateScheduler());
            }
        }catch(Exception e){
            System.debug('Exception : ' + e.getMessage());
        }
        // added by Narendra -- end --
        
        if (musqot__ERP_Settings__c.sObjectType.getDescribe().isCreateable())
            if(erps.Bar_color__c<>null){
                erps.Bar_color__c = erps.Bar_color__c.replaceAll(' ','');
            }
        {
        if(erps.musqot__ERP_performance_type__c=='Performance, project'||erps.musqot__ERP_performance_type__c=='Performance, marketing activity'||erps.musqot__ERP_performance_type__c=='Milestone'){
            erps.musqot__Selector__c='';        
        }
            insert erps;
        }
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('mpsett','UTF-8');
        Pagereference pg=new Pagereference (pageRef);
        return pg;
    }
    
    Public Pagereference cancel()//redirect to  MusqotAdminPage
    {
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('mpsett','UTF-8');
        Pagereference pg=new Pagereference (pageRef);
        return pg;
    }
    public List<SelectOption> getMyOptions() {
        List<SelectOption> options = new List<SelectOption>(); 
        Schema.DescribeFieldResult field = musqot__ERP_Settings__c.musqot__ERP_performance_type__c.getDescribe();
        for (Schema.PicklistEntry f : field.getPicklistValues()){
            if(mus.Use_milestones__c ==false){
                if(f.getLabel()!='Milestone'){
                  options.add(new SelectOption(f.getLabel(), f.getLabel()));
               }
            }else
            options.add(new SelectOption(f.getLabel(), f.getLabel()));
        }   
        return options;     
   }
    
}