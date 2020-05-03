/*******************************************************
Class Name: Socialmediacontroller
Author:Håkan Sjöberg     Last modified by:Nagaraju G 
Date:  28/11/2014           Date:7/7/2015
********©2013 Musqot marketing technology Pvt ltd *******/
public with sharing class Socialmediacontroller {
    private ApexPages.StandardController sc;
    public Socialmedia_settings__c smSet{get;set;}
    public  musqot__Activity__c  mus{get;set;}
    public Boolean isfrommrk{get;set;}
    public Boolean isshowcancel{get;set;}
    public String socialmediaSettingId{get;set;}
    public string socialMediaName;
    public Socialmediacontroller (ApexPages.StandardController controller){
        This.sc = sc;
        smSet=new Socialmedia_settings__c ();
        isfrommrk = false;
        isshowcancel = true;
        if(ApexPages.CurrentPage().getParameters().get('Name') <> null && ApexPages.CurrentPage().getParameters().get('Name') <> ''){
            smSet.Name = ApexPages.CurrentPage().getParameters().get('Name');   
        }
        
        if(ApexPages.CurrentPage().getParameters().get('Connid') <> null && ApexPages.CurrentPage().getParameters().get('Connid') <> ''){            
            smSet.Socialmedia__c = ApexPages.CurrentPage().getParameters().get('Connid'); 
            smSet.Type__c = 'Performance, marketing activity'; 
        }
        if(ApexPages.CurrentPage().getParameters().get('IsfromMrk') <> null && ApexPages.CurrentPage().getParameters().get('IsfromMrk') <> ''){            
            isfrommrk = Boolean.valueOf(ApexPages.CurrentPage().getParameters().get('IsfromMrk')); 
        }  
        
        if(isfrommrk){
            isshowcancel = false;
        }
        socialMediaName='MailChimp';//oauthService.Social_media__c; 
        mus=new musqot__Activity__c();
        mus=[SELECT id,Use_Forcasting__c,Use_milestones__c FROM musqot__Activity__c limit 1];
    }
    Public Pagereference cancel(){
        string selectedTab='smsting';
        
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('mpsett','UTF-8')+'&fromHome=true'+'&tabm='+socialMediaName;//'&selectedTab=+selectedTab';//+'&tab1='+EncodingUtil.urlEncode('smseting','UTF-8');
        Pagereference pg=new Pagereference (pageRef);//
        return pg;
    }
    public Pagereference insertsoscailmedia(){
        
        // added by Narendra -- start --
        if(smSet.Type__c == 'Milestone') {
            try{
                CronJobDetail cj = [select id, Name from CronJobDetail where Name = :'SocialMediaSettingMilestoneSchedulerJob'];
                if(cj != null) {
                    // if the job is not running
                    Date tomorrowsDate = System.today().addDays(1);
                    Integer day = tomorrowsDate.day();
                    Integer month = tomorrowsDate.month();
                    Integer year = tomorrowsDate.year();
                    String SchTimer='0 0 1 '+day+' '+month+' ? '+year;   //  next day 1:00 AM
                    System.schedule('SocialMediaSettingMilestoneSchedulerJob', SchTimer, new SocialMediaSettingMilestoneScheduler());
                }
            }catch(Exception e){
                System.debug('Exception : ' + e.getMessage());
            }
        }
        // added by Narendra -- end --
      try{
            OAuthService__c oauthService = [select id ,Name,Bar_color__c from OAuthService__c where Id =:smSet.musqot__Socialmedia__c];
            if (musqot__Socialmedia_settings__c.sObjectType.getDescribe().isCreateable()){   
                smSet.Bar_color__c = oauthService.Bar_color__c;
                insert smSet;
                socialmediaSettingId = smSet.Id;
            }
         }catch(Exception e){}  
        if(isfrommrk == false){
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('mpsett','UTF-8')+'&fromHome=true'+'&tabm='+socialMediaName;//+'&tab1='+EncodingUtil.urlEncode('smseting','UTF-8');
            Pagereference pg=new Pagereference (pageRef);
            return pg;
        }else{            
            string pageRef='/apex/Social_media_new_connection?newid='+socialmediaSettingId;
            Pagereference pg=new Pagereference (pageRef);
            return pg;
        }
     }
      public List<SelectOption> getMyOptions() {
        List<SelectOption> options = new List<SelectOption>(); 
        Schema.DescribeFieldResult field = Socialmedia_settings__c.Type__c.getDescribe();
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