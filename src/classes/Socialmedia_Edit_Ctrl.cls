public with sharing class Socialmedia_Edit_Ctrl{
    public Socialmedia_settings__c ObjSMS{get;set;}
    public  musqot__Activity__c  mus;
    Public Id socialId;
    public OAuthService__c oauthService;
    public string socialMediaName;
    public Socialmedia_Edit_Ctrl(ApexPages.StandardController controller) {        
        socialid = ApexPages.currentPage().getParameters().get('socialId');
        mus=[SELECT id,Use_Forcasting__c,Use_milestones__c FROM musqot__Activity__c limit 1];
       try{            
            ObjSMS = [select id ,Name, Import_rate__c,Type__c,Socialmedia_type__c,Chart__c,Socialmedia__c,Watch_type__c
                       from Socialmedia_settings__c where id =:socialId];   
       }catch(exception e){}
       oauthService = [select id ,Name,Bar_color__c,Social_media__c  from OAuthService__c 
                                            where Id =:ObjSMS.Socialmedia__c];
               socialMediaName=oauthService.Social_media__c; 
    }

    /********update  Socialmedia_settings__c records ********/
    
    public PageReference updSocial(){
        try{
              // OAuthService__c oauthService = [select id ,Name,Bar_color__c,Social_media__c  from OAuthService__c 
                                        //    where Id =:ObjSMS.Socialmedia__c];
               //socialMediaName=oauthService.Social_media__c;
            
            // added by Narendra -- start --
            if(ObjSMS.Type__c == 'Milestone') {
                try{
                    CronJobDetail cj = [select id, Name from CronJobDetail where Name = :'SocialMediaSettingMilestoneSchedulerJob'];
                    if(cj == null) {
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
            
            if (musqot__Socialmedia_settings__c.sObjectType.getDescribe().isUpdateable()){ 
                ObjSMS.Bar_color__c = oauthService.Bar_color__c;
                update ObjSMS;            
            }
        }catch(exception e){}
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('mpsett','UTF-8')+'&fromHome=true'+'&tabm='+socialMediaName;
        Pagereference pg=new Pagereference (pageRef);
        return pg;
    }
    /***** redirect to MusqotAdminPage ********/
    public PageReference cancel(){
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('mpsett','UTF-8')+'&fromHome=true'+'&tabm='+socialMediaName;
        Pagereference pg=new Pagereference (pageRef);
        return pg;
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