public with sharing class ERPSettingsEditController {
    private ApexPages.StandardController sc;
    Public ERP_Settings__c erps{get;set;}
    public Summary[] Areas { get; set; }
    public Summary[] Regions { get; set; }
    public  musqot__Activity__c  mus;
    public id erpid;
    public ERPSettingsEditController(ApexPages.StandardController sc){
        This.sc = sc;
        erps= new musqot__ERP_Settings__c();  
        erpid= ApexPages.currentPage().getParameters().get('erpid');
        try{
            erps= [select Id,Name,Expression_business_area__c,Expression_business_region__c,ERP_performance_type__c, Selector__c,Bar_color__c, erp_Chart__c 
                    from ERP_Settings__c where Id =:erpid ];
        }catch(exception e){}
        
        AggregateResult[] results = [SELECT  Business_region__c name FROM ERP_sales_obj__c group by Business_region__c limit:100];
        Regions = new List<Summary>();
        for (AggregateResult ar : results) {
            Regions.add(new Summary(ar));
        }
        AggregateResult[] results2 = [SELECT  Business_Area__c name FROM ERP_sales_obj__c group by Business_Area__c limit:100];
        Areas = new List<Summary>();
        for (AggregateResult ar : results2) {
            Areas.add(new Summary(ar));
        }
         mus=[SELECT id,Use_Forcasting__c,Use_milestones__c FROM musqot__Activity__c limit 1];
        
    }
     // wrapper class to hold aggregate data
        public class Summary {
            public String Name { get; private set; }
            public Summary(AggregateResult ar) {
               Name = (String) ar.get('name');
            }
        }
    /**********************************************************************************
    save():update the  musqot__ERP_Settings__c records and redirect to  MusqotAdminPage
    ***********************************************************************************/
    public Pagereference Save(){ 
        
        // added by Narendra -- start --
        // schedule milestone update job here
       try{
            List<CronJobDetail> cj = [select id, Name from CronJobDetail where Name = :'ERPMilestoneUpdateSchedulerJob'];
            System.debug('testing erp sch '+cj.size());
            if(cj.size() == 0) {
                // if the job is not running
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
        
        if (ERP_Settings__c.sObjectType.getDescribe().isUpdateable())
        {  
            if(erps.Bar_color__c<>null){
                erps.Bar_color__c = erps.Bar_color__c.replaceAll(' ','');
            }
            if(erps.musqot__ERP_performance_type__c=='Performance, project'||erps.musqot__ERP_performance_type__c=='Performance, marketing activity'||erps.musqot__ERP_performance_type__c=='Milestone'){
            erps.musqot__Selector__c='';   
            }
            Update erps;
        }
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('mpsett','UTF-8');
        Pagereference pg=new Pagereference (pageRef);
        return pg;
    }
     public Pagereference Cancel(){//redirect to  MusqotAdminPage 
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