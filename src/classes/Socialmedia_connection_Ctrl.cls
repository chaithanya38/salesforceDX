public with sharing class Socialmedia_connection_Ctrl{       
    public OAuthService__c ObjSM{get;set;}
    public List<OAuthService__c> connectionList{get;set;}
    public OAuthService__c ObjSMS{get;set;}
    Public Id conid;
    public boolean connectionStatus{get;set;}
    public String fbLoginURL{get;set;}
    public String accessToken {get;set;}
    public String code {get;set;}
    public String connectionId{get;set;}
    public boolean smMessage {get;set;}
    public static boolean isApexTest = false;
    /***** extension ****/
    public Socialmedia_connection_Ctrl(ApexPages.StandardController controller) {
		ObjSM = (OAuthService__c)controller.getRecord();        
        conid = ApexPages.currentPage().getParameters().get('conid');        
        try{            
            ObjSMS = [select id, Name, Access_Token_URL__c, Authorization_Type__c, Authorization_URL__c,Page_Id__c,Post_ID__c,ad_ID__c,social_media__c,Socialmedia__c,Campaign_Id__c, Consumer_Key__c,
                       Bar_color__c,Consumer_Secret__c, Redirect_URL__c, Request_Token_URL__c, Response_Type__c, Scope__c, 
                      Signature_Method__c, Auto_import__c, End_Date__c 
                      from OAuthService__c  where id =:conid];   
            
        }catch(exception e){}   
        
        smMessage = false;
    }  
    
    /********update OAuthService__c records *******/
    public PageReference updSocial(){            
        try{
            if(ObjSMS.Auto_import__c){
                // added by Narendra -- start --
                if(ObjSMS.end_date__c > System.today()) {
                    try{
                        OAuthService__c oAuthS = [select id from OAuthService__c where id =:ObjSMS.id];
                        List<socialmedia_settings__c> sms = [select id, name from socialmedia_settings__c where Type__c =:'Milestone'
                                                            and Socialmedia__c =:oAuthS.id];                       
                        if(sms.size() != 0) {
                            Date tomorrowsDate = System.today().addDays(1);
                            Integer day = tomorrowsDate.day();
                            Integer month = tomorrowsDate.month();
                            Integer year = tomorrowsDate.year();
                            String SchTimer='0 0 1 '+day+' '+month+' ? '+year;   //  next day 1:00 AM
                            System.schedule('SocialMediaSettingMilestoneSchedulerJob', SchTimer, new SocialMediaSettingMilestoneScheduler());
                        }
                    }catch(Exception e){
                        //system.assertequals('No Error',e.getmessage()); 
                        System.debug('Exception : ' + e.getMessage());
                    }                
                    // added by Narendra -- end --
                    if(ObjSMS.Social_media__c == 'Facebook'){
                        if(ObjSMS.ad_id__c <> null){                    
                            if(facebookAdConnection() == true){
                                try{
                                    CronJobDetail cj = [select id, Name from CronJobDetail where Name = :'scheduleFacebookAdInsightsJob'];
                                    CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where CronJobDetailId = :cj.Id];
                                    system.abortJob(ct.Id);   
                                }catch(Exception e){}
                                String SchTimer='0 0 0 1/1 * ? *';   
                                //Datetime sysTime = System.now().addSeconds( 60 );      
                                //String SchTimer = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
                                if(ObjSMS.Social_media__c == 'Facebook'){
                                    system.schedule('scheduleFacebookAdInsightsJob', SchTimer, new scheduleFacebookAdInsights());
                                }                                          
                                if (OAuthService__c.sObjectType.getDescribe().isUpdateable()){   
                                    update ObjSMS;            
                                }                         
                            }
                            else{                                                               
                                return null;
                            }            
                        }
                        else if(ObjSMS.Post_Id__c<>null){
                            if(facebookPostConnection() == true){
                                
                            }else{
                                return null;
                            }
                        }
                        else if(ObjSMS.Page_Id__c<>null){                    
                            if(facebookPageConnection() == true){                        
                                try{
                                    CronJobDetail cj = [select id, Name from CronJobDetail where Name = :'scheduleFacebookInsightsJob'];
                                    CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where CronJobDetailId = :cj.Id];
                                    system.abortJob(ct.Id); 
                                }catch(Exception e){} 
                                String SchTimer='0 0 0 1/1 * ? *';   
                                //Datetime sysTime = System.now().addSeconds( 60 );      
                                //String SchTimer = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
                                if(ObjSMS.Social_media__c == 'Facebook'){
                                    system.schedule('scheduleFacebookInsightsJob', SchTimer, new scheduleFacebookInsights());
                                }                 
                                if (OAuthService__c.sObjectType.getDescribe().isUpdateable()){   
                                    update ObjSMS;            
                                }                        
                            }else{                             
                                return null;
                            }
                        }
                    }
                    else if(ObjSMS.Social_media__c == 'MailChimp'){
                        if(ObjSMS.Campaign_Id__c<>null){                    
                            if(mailchimpCampaignConnection() == true){                        
                                try{
                                    CronJobDetail cj = [select id, Name from CronJobDetail where Name = :'scheduleMailChimpCampaignInsightsJob'];
                                    CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where CronJobDetailId = :cj.Id];
                                    system.abortJob(ct.Id); 
                                }catch(Exception e){} 
                                String SchTimer='0 0 0 1/1 * ? *';   
                                //Datetime sysTime = System.now().addSeconds( 60 );      
                                //String SchTimer = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
                                if(ObjSMS.Social_media__c == 'MailChimp'){
                                    system.schedule('scheduleMailChimpCampaignInsightsJob', SchTimer, new scheduleMailChimpCampaignInsights());
                                }                 
                                if (OAuthService__c.sObjectType.getDescribe().isUpdateable()){   
                                    update ObjSMS;            
                                }                        
                            }else{                             
                                return null;
                            }
                        }
                    }
                    else if(ObjSMS.Social_media__c == 'LinkedIn'){
                        if(ObjSMS.Page_Id__c<>null && ObjSMS.Post_Id__c<>null){                    
                            if(linkedinPostConnection() == true){                        
                                try{
                                    CronJobDetail cj = [select id, Name from CronJobDetail where Name = :'scheduleLinkedInPostInsightsJob'];
                                    CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where CronJobDetailId = :cj.Id];
                                    system.abortJob(ct.Id); 
                                }catch(Exception e){} 
                                String SchTimer='0 0 0 1/1 * ? *';   
                                //Datetime sysTime = System.now().addSeconds( 60 );      
                                //String SchTimer = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
                                if(ObjSMS.Social_media__c == 'LinkedIn'){
                                    system.schedule('scheduleLinkedInPostInsightsJob', SchTimer, new scheduleLinkedInPostInsights());
                                }                 
                                if (OAuthService__c.sObjectType.getDescribe().isUpdateable()){   
                                    update ObjSMS;            
                                }                        
                            }else{                             
                                return null;
                            }
                        }else if(ObjSMS.Page_Id__c<>null){                    
                            if(linkedinPageConnection() == true){                        
                                try{
                                    CronJobDetail cj = [select id, Name from CronJobDetail where Name = :'scheduleLinkedInPageInsightsJob'];
                                    CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where CronJobDetailId = :cj.Id];
                                    system.abortJob(ct.Id); 
                                }catch(Exception e){} 
                                String SchTimer='0 0 0 1/1 * ? *';   
                                //Datetime sysTime = System.now().addSeconds( 60 );      
                                //String SchTimer = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
                                if(ObjSMS.Social_media__c == 'LinkedIn'){
                                    system.schedule('scheduleLinkedInPageInsightsJob', SchTimer, new scheduleLinkedInPageInsights());
                                }                 
                                if (OAuthService__c.sObjectType.getDescribe().isUpdateable()){   
                                    update ObjSMS;            
                                }                        
                            }else{                             
                                return null;
                            }
                        }
                    }
                }
            }
            else{
                if (OAuthService__c.sObjectType.getDescribe().isUpdateable()){   
                    update ObjSMS;            
                }                
            }            
            List<Socialmedia_settings__c> socialmediaSettings = [select id ,Name, Bar_color__c,Socialmedia__c from Socialmedia_settings__c where Socialmedia__c =:ObjSMS.Id];
            List<Socialmedia_settings__c> smsList = new List<Socialmedia_settings__c>();
            for (Socialmedia_settings__c s : socialmediaSettings) {
                Socialmedia_settings__c sms = new Socialmedia_settings__c();
                sms.Id = s.Id;
                sms.Bar_color__c = ObjSMS.Bar_color__c;                
                smsList.add(sms);
            }
            if(smsList<>null){
                if (Socialmedia_settings__c.sObjectType.getDescribe().isUpdateable()){                         
                    update (smsList);           
                }
            }
        }catch(Exception e){                        
            return null;
        }
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('mpsett','UTF-8');
        Pagereference pg=new Pagereference (pageRef);
        return pg;
    }
    
    /***** redirect to MusqotAdminPage ********/
    public PageReference cancel(){
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('mpsett','UTF-8');
        Pagereference pg=new Pagereference (pageRef);
        return pg;
    }       
    
    public void facebookConnection(){        
        if(ObjSMS.Page_Id__c<>null){
            facebookPageConnection();
        }
        else if(ObjSMS.ad_id__c <> null){
            facebookAdConnection();
        }
        else if(ObjSMS.Post_Id__c<>null){
            facebookPostConnection();
        }
    }    
    
    public boolean facebookPageConnection(){   
        try{
            if(ObjSMS.Page_Id__c <> null){               
                String appId;                
                HttpRequest appIdreq = new HttpRequest();     
                appIdreq.setEndpoint('https://graph.facebook.com/'+ ObjSMS.Page_Id__c +'?access_token=' + ObjSMS.Access_Token_URL__c + '');
                appIdreq.setMethod('GET');         
                Http appIdhttp = new Http();
                HTTPResponse appIdres = appIdhttp.send(appIdreq);      
                String appIdresult = appIdres.getBody();           
                if(appIdresult<>null && appIdresult<>''){
                    Map<String, Object> appIddata = (Map<String, Object>)JSON.deserializeUntyped(appIdresult);                             
                    if(ObjSMS.Page_Id__c == String.valueOf(appIddata.get('id'))){
                        smMessage = true;                   
                    }else{
                        smMessage = false;  
                    }
                }else{
                    smMessage = false;  
                }
            }        
        }catch(Exception e){
            smMessage = false; 
        }
        return smMessage;
    }
    
    public boolean facebookAdConnection(){   
        try{
            if(ObjSMS.ad_id__c <> null){
                String adId;                 
                HttpRequest adIdreq = new HttpRequest();     
                adIdreq.setEndpoint('https://graph.facebook.com/v2.4/'+EncodingUtil.urlEncode(ObjSMS.ad_id__c,'UTF-8')+'?access_token=' + ObjSMS.Access_Token_URL__c + '');
                adIdreq.setMethod('GET');         
                Http adIdhttp = new Http();
                HTTPResponse adIdres = adIdhttp.send(adIdreq);      
                String adIdresult = adIdres.getBody();           
                if(adIdresult<>null && adIdresult<>''){
                    Map<String, Object> adIddata = (Map<String, Object>)JSON.deserializeUntyped(adIdresult);                            
                    if(ObjSMS.ad_id__c == String.valueOf(adIddata.get('id'))){
                        smMessage = true;                   
                    }else{
                        smMessage = false;  
                    }
                }else{
                    smMessage = false;  
                }          
            }
        }catch(Exception e){
            smMessage = false; 
        }
        return smMessage;
    }
    
    public boolean facebookPostConnection(){ 
        try{
            if(ObjSMS.Post_Id__c<>null){} 
        }catch(Exception e){
            smMessage = false; 
        }
        return smMessage;
    }
    
    public void mailchimpConnection(){        
        if(ObjSMS.Campaign_Id__c<>null){
            mailchimpCampaignConnection();
        }
    }    
    
    public boolean mailchimpCampaignConnection(){
        try{
            if(ObjSMS.Campaign_Id__c <> null){               
                String mailchimpstatus;  
                List<String> dcList = ObjSMS.Access_Token_URL__c.split('-');
                String dc = String.valueOf(dcList[1]);
                String statusReqURL = 'https://'+ dc +'.api.mailchimp.com/2.0/helper/verified-domains?apikey='+ ObjSMS.Access_Token_URL__c;
                HttpRequest statusreq = new HttpRequest();     
                statusreq.setEndpoint(statusReqURL);
                statusreq.setMethod('GET');         
                Http statushttp = new Http();
                HTTPResponse statusres = statushttp.send(statusreq);      
                String statusresult = statusres.getBody();           
                if(statusresult<>null && statusresult<>''){                 
                    List<Object> data = (List<Object>)JSON.deserializeUntyped(statusresult);
                    for (Object o : data) {
                        Map<String, Object> d = (Map<String, Object>) o;                    
                        mailchimpstatus = String.valueOf(d.get('status')); 
                    }
                    if(mailchimpstatus == 'verified'){
                        smMessage = true;                   
                    }else{
                        smMessage = false;  
                    }
                }else{
                    smMessage = false;  
                }
            }                    
        }catch(Exception e){
            smMessage = false; 
        }
        return smMessage;
    }
    
    public void socialmediaConnection(){        
        if(ObjSMS.Social_media__c == 'Facebook'){
            facebookConnection();
        }else if(ObjSMS.Social_media__c == 'MailChimp'){
            mailchimpConnection();
        }else if(ObjSMS.Social_media__c == 'LinkedIn'){
            linkedinConnection();
        }
    }        
    
    public void importfacebookData(){   
        if(ObjSMS.Page_Id__c<>null){
            importfacebookPageData();
        }
        else if(ObjSMS.ad_id__c <> null){
            importfacebookAdData();
        }
        else if(ObjSMS.Post_Id__c<>null){
            importfacebookPostData();
        }
    }
    
    public void importfacebookPageData(){
        try{                                                                                            
            if(ObjSMS.Page_Id__c <> null){  
                List<Social_media_data__c> smdList = new List<Social_media_data__c>();
                Integer success = 0;                                                       
                if(facebookPageConnection() == true){                                             
                    String ReqURL;
                    String visitorReqURL;
                    String followerReqURL;
                    Date todayDate= Date.today().addDays(-1);
                    Date startDate;
                    startDate = todayDate.addMonths(-3); 
                    system.debug('abc');
                    system.debug('todayDate '+todayDate);
                    system.debug('startDate '+startDate);
                    Date dateSince = Date.newInstance(startDate.year(), startDate.month(), startDate.day());
                    Time timeSince = Time.newInstance(0, 0, 0, 0);
                    DateTime dtSince = DateTime.newInstanceGmt(dateSince, timeSince);
                    Long lSince = dtSince.getTime() / 1000;
                    Date dateUntil = Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day());
                    Time timeUntil = Time.newInstance(0,0,0,0);
                    DateTime dtUntil = DateTime.newInstanceGmt(dateUntil, timeUntil);
                    Long lUntil = dtUntil.getTime() / 1000;
                    ReqURL = 'https://graph.facebook.com/'+EncodingUtil.urlEncode(ObjSMS.Page_Id__c,'UTF-8')+'/insights/page_fan_adds_unique/day?access_token='+ObjSMS.Access_Token_URL__c+'&since='+lSince+'&until='+lUntil;                
                    visitorReqURL = 'https://graph.facebook.com/'+EncodingUtil.urlEncode(ObjSMS.Page_Id__c,'UTF-8')+'/insights/page_tab_views_login_top_unique/day?access_token='+ObjSMS.Access_Token_URL__c+'&since='+lSince+'&until='+lUntil;                
                    followerReqURL = 'https://graph.facebook.com/'+EncodingUtil.urlEncode(ObjSMS.Page_Id__c,'UTF-8')+'/insights/page_follower_adds_unique/day?access_token='+ObjSMS.Access_Token_URL__c+'&since='+lSince+'&until='+lUntil;                
                    HttpRequest req1 = new HttpRequest();                
                    req1.setMethod('GET');           
                    req1.setEndpoint(ReqURL);                
                    req1.setTimeout(60*1000);                
                    HttpResponse res1 = null;                
                    http h1= new Http();                           
                    try{
                        res1 = h1.send(req1) ;                
                    }catch(Exception e){
                        
                    }                
                    String result1 = res1.getBody();
                    
                    HttpRequest visitorreq1 = new HttpRequest();                
                    visitorreq1.setMethod('GET');           
                    visitorreq1.setEndpoint(visitorReqURL);                
                    visitorreq1.setTimeout(60*1000);                
                    HttpResponse visitorres1 = null;                
                    http visitorh1= new Http();                           
                    try{
                        visitorres1 = visitorh1.send(visitorreq1) ;                
                    }catch(Exception e){
                        
                    }                
                    String visitorresult1 = visitorres1.getBody();
                    
                    HttpRequest followerreq1 = new HttpRequest();                
                    followerreq1.setMethod('GET');           
                    followerreq1.setEndpoint(followerReqURL);                
                    followerreq1.setTimeout(60*1000);                
                    HttpResponse followerres1 = null;                
                    http followerh1= new Http();                           
                    try{
                        followerres1 = followerh1.send(followerreq1) ;                
                    }catch(Exception e){
                        
                    }                
                    String followerresult1 = followerres1.getBody(); 
                    if(result1<>null && result1<>''){
                        Map<String, Object> jsonData1 = (Map<String, Object>)JSON.deserializeUntyped(result1);                                                                                  
                        List<Object> data = (List<Object>) jsonData1.get('data');
                        for (Object o : data) {
                            Map<String, Object> d = (Map<String, Object>) o;
                            List<Object> values = (List<Object>) d.get('values');
                            for (Object v : values) {
                                success = success + 1;
                                Social_media_data__c smd = new Social_media_data__c();
                                Map<String, Object> value = (Map<String, Object>) v;                            
                                smd.Number_of_likes__c = Integer.valueOf((value.get('value')));    
                                String fbendTime = String.valueOf((value.get('end_time')));                              
                                List<String> enddate1 = fbendTime.split('T',-1);
                                List<String> enddate2 = enddate1[0].split('-',-1);                        
                                Date fbendDate = Date.newInstance(Integer.valueOf(enddate2[0]),Integer.valueOf(enddate2[1]),Integer.valueOf(enddate2[2]));                        
                                smd.Date__c = fbendDate;//.addDays(-1);                            
                                smd.Connection__c = ObjSMS.Id;
                                smd.Name = ObjSMS.Name;// ObjSMS.Socialmedia__r.Socialmedia_type__c;                                     
                                smdList.add(smd);   
                            }                       
                        }                                                            
                    }  
                    List<Social_media_data__c > sdList = [select Id from Social_media_data__c where Connection__c = :ObjSMS.Id];
                    if(sdList<>null){
                        if (Social_media_data__c.sObjectType.getDescribe().isDeletable()){                 
                            delete (sdList);
                        }
                    }
                    if (Social_media_data__c.sObjectType.getDescribe().isCreateable()){                 
                        insert (smdList);
                    }   
                    List<Social_media_data__c > sdvisitorList = [select Id, Name, Date__C, Connection__c from Social_media_data__c where Connection__c = :ObjSMS.Id];
                    List<Social_media_data__c> smdvisitorList = new List<Social_media_data__c>();
                    if(visitorresult1<>null && visitorresult1<>''){
                        Map<String, Object> visitorjsonData1 = (Map<String, Object>)JSON.deserializeUntyped(visitorresult1);                                                                                  
                        List<Object> visitordata = (List<Object>) visitorjsonData1.get('data');
                        for (Object o : visitordata) {
                            Map<String, Object> d = (Map<String, Object>) o;
                            List<Object> values = (List<Object>) d.get('values');
                            for (Object v : values) {
                                for (Social_media_data__c md : sdvisitorList){
                                    Social_media_data__c smd = new Social_media_data__c();
                                    Map<String, Object> fbvalues = (Map<String, Object>) v;                              
                                    if(String.valueOf(fbvalues.get('value')) <> '()' && String.valueOf(fbvalues.get('value')) <> ''){
                                        Map<String, Object> fbvalue = (Map<String, Object>) fbvalues.get('value');
                                        if(fbvalue<>null){                            
                                            if(fbvalue.containsKey('timeline')){
                                                smd.Number_of_unik_visitor__c = Integer.valueOf((fbvalue.get('timeline')));
                                            }else{
                                                smd.Number_of_unik_visitor__c = 0;
                                            }                            
                                        }else{
                                            smd.Number_of_unik_visitor__c = 0;
                                        } 
                                    }else{
                                        smd.Number_of_unik_visitor__c = 0;
                                    }                                                                                                      
                                    String fbendTime = String.valueOf((fbvalues.get('end_time')));                              
                                    List<String> enddate1 = fbendTime.split('T',-1);
                                    List<String> enddate2 = enddate1[0].split('-',-1);                        
                                    Date fbendDate = Date.newInstance(Integer.valueOf(enddate2[0]),Integer.valueOf(enddate2[1]),Integer.valueOf(enddate2[2]));                        
                                    smd.Date__c = fbendDate;//.addDays(-1);                            
                                    smd.Connection__c = ObjSMS.Id;
                                    smd.Name = ObjSMS.Name;// ObjSMS.Socialmedia__r.Socialmedia_type__c;                               
                                    smd.Id = md.Id;
                                    if(smd.Date__c == md.Date__c && smd.Connection__c == md.Connection__c){
                                        smdvisitorList.add(smd); 
                                    }
                                }
                            }                       
                        }                                                            
                    }
                    List<Social_media_data__c > sdfollowerList = [select Id, Name, Date__C, Connection__c from Social_media_data__c where Connection__c = :ObjSMS.Id];
                    List<Social_media_data__c> smdfollowerList = new List<Social_media_data__c>();
                    if(followerresult1<>null && followerresult1<>''){
                        Map<String, Object> followerjsonData1 = (Map<String, Object>)JSON.deserializeUntyped(followerresult1);                                                                                  
                        List<Object> followerdata = (List<Object>) followerjsonData1.get('data');
                        for (Object o : followerdata) {
                            Map<String, Object> d = (Map<String, Object>) o;
                            List<Object> values = (List<Object>) d.get('values');
                            for (Object v : values) {
                                for (Social_media_data__c md : sdfollowerList){
                                    Social_media_data__c smd = new Social_media_data__c();
                                    Map<String, Object> value = (Map<String, Object>) v;                            
                                    smd.Number_of_member__c = Integer.valueOf((value.get('value')));    
                                    String fbendTime = String.valueOf((value.get('end_time')));                              
                                    List<String> enddate1 = fbendTime.split('T',-1);
                                    List<String> enddate2 = enddate1[0].split('-',-1);                        
                                    Date fbendDate = Date.newInstance(Integer.valueOf(enddate2[0]),Integer.valueOf(enddate2[1]),Integer.valueOf(enddate2[2]));                        
                                    smd.Date__c = fbendDate;//.addDays(-1);                            
                                    smd.Connection__c = ObjSMS.Id;
                                    smd.Name = ObjSMS.Name;// ObjSMS.Socialmedia__r.Socialmedia_type__c;                                     
                                    smd.Id = md.Id;
                                    if(smd.Date__c == md.Date__c && smd.Connection__c == md.Connection__c){
                                        smdfollowerList.add(smd); 
                                    }
                                }
                            }                       
                        }                                                            
                    }
                    
                    if(sdvisitorList<>null){
                        if (Social_media_data__c.sObjectType.getDescribe().isUpdateable()){                 
                            update (smdvisitorList);
                        }
                    }
                    
                    if(sdfollowerList<>null){
                        if (Social_media_data__c.sObjectType.getDescribe().isUpdateable()){                 
                            update (smdfollowerList);
                        }
                    }
                    
                    if (OAuthService__c.sObjectType.getDescribe().isUpdateable()){                 
                        update ObjSMS;
                    }                      
                    if (Socialmedia_logfile__c.sObjectType.getDescribe().isCreateable()){
                        Socialmedia_logfile__c sml = new Socialmedia_logfile__c();
                        sml.Name = ObjSMS.Name;
                        sml.Connection_id__c = ObjSMS.Id;
                        sml.Import_message__c = 'Import data started';
                        insert sml;            
                        Socialmedia_logfile__c smlUpdate = new Socialmedia_logfile__c();  
                        smlUpdate.Id = sml.Id;                
                        smlUpdate.Import_message__c = 'All data replace with fresh data from Facebook successfully'; 
                        smlUpdate.musqot__Imported__c=true;             
                        smlUpdate.Number_of_records__c = success ; 
                        update (smlUpdate);   
                    }
                }
                else{                    
                    if (Socialmedia_logfile__c.sObjectType.getDescribe().isCreateable()){
                        Socialmedia_logfile__c sml = new Socialmedia_logfile__c();
                        sml.Name = ObjSMS.Name;
                        sml.Connection_id__c = ObjSMS.Id;
                        sml.Import_message__c = 'Import data started';
                        insert sml;            
                        Socialmedia_logfile__c smlUpdate = new Socialmedia_logfile__c();  
                        smlUpdate.Id = sml.Id;                
                        smlUpdate.Import_message__c = 'Error in setting for this connection'; 
                        smlUpdate.musqot__Imported__c=true;             
                        smlUpdate.Number_of_records__c = success ; 
                        update (smlUpdate);   
                    }
                }
            }                                                                                      
        }catch(Exception e){
            if (Socialmedia_logfile__c.sObjectType.getDescribe().isCreateable()){
                Socialmedia_logfile__c sml = new Socialmedia_logfile__c();
                sml.Name = ObjSMS.Name;
                sml.Connection_id__c = ObjSMS.Id;
                sml.Import_message__c = 'Import data started';
                insert sml;
                Socialmedia_logfile__c smlUpdate = new Socialmedia_logfile__c();  
                smlUpdate.Id = sml.Id;
                smlUpdate.Import_message__c = 'Error in import '+e.getMessage(); 
                smlUpdate.musqot__Imported__c=false;             
                smlUpdate.Number_of_records__c = 0; 
                update (smlUpdate);
            }
        }
    }
    
    public void importfacebookAdData(){
        try{                                                                                
            if(ObjSMS.ad_id__c <> null){
                List<Social_media_data__c> smdList = new List<Social_media_data__c>();
                Integer noofDays = 0;
                Integer success = 0;
                Integer i = 0;
                String adReqURL;  
                Date date_start;
                Date date_stop;
                String adId;                
                HttpRequest adIdreq = new HttpRequest();     
                adIdreq.setEndpoint('https://graph.facebook.com/v2.4/'+EncodingUtil.urlEncode(ObjSMS.ad_id__c,'UTF-8')+'?access_token='+ObjSMS.Access_Token_URL__c + '');
                adIdreq.setMethod('GET');         
                Http adIdhttp = new Http();
                HTTPResponse adIdres = adIdhttp.send(adIdreq);      
                String adIdresult = adIdres.getBody();           
                if(adIdresult<>null && adIdresult<>''){
                    Map<String, Object> adIddata = (Map<String, Object>)JSON.deserializeUntyped(adIdresult);             
                    adId = String.valueOf(adIddata.get('id'));
                }
                if(facebookAdConnection() == true){
                    adReqURL = 'https://graph.facebook.com/v2.4/'+EncodingUtil.urlEncode(ObjSMS.ad_id__c,'UTF-8')+'/insights?access_token='+ObjSMS.Access_Token_URL__c;               
                    HttpRequest adreq = new HttpRequest();                
                    adreq.setMethod('GET');           
                    adreq.setEndpoint(adReqURL);                
                    adreq.setTimeout(60*1000);                
                    HttpResponse adres = null;                
                    http adhttp= new Http();                           
                    try{
                        adres = adhttp.send(adreq) ;                
                    }catch(Exception e){
                        
                    }                
                    String adresult = adres.getBody();
                    
                    Map<String, Object> jsonadData = (Map<String, Object>)JSON.deserializeUntyped(adresult);                                                                                  
                    List<Object> data = (List<Object>) jsonadData.get('data');
                    for (Object o : data) {
                        Map<String, Object> d = (Map<String, Object>) o;
                        system.debug('start'+d);
                        system.debug('start'+d.get('date_start'));
                        system.debug('startst'+d.get('date_stop'));
                        String startdate = String.valueOf(d.get('date_start')); 
                        String stopdate = String.valueOf(d.get('date_stop')); 
                        date_start = Date.valueOf(startdate);
                        date_stop = Date.valueOf(stopdate);
                    }                                                        
                    noofDays = date_start.daysBetween(date_stop);
                    system.debug('noofdays'+noofDays);                    
                    for (i = 0; i <= noofDays; i++) {
                        Social_media_data__c smd = new Social_media_data__c();
                        String adReqURL2; 
                        success = success + 1;
                        String since = String.valueOf(date_start.addDays(i));
                        system.debug('since'+since);                    
                        adReqURL2 = 'https://graph.facebook.com/v2.4/'+EncodingUtil.urlEncode(ObjSMS.ad_id__c,'UTF-8')+'/insights?time_range={"since":"'+since+'","until":"'+since+'"}&access_token='+ObjSMS.Access_Token_URL__c;               
                        system.debug('adrequesturl'+adReqURL2);
                        HttpRequest adreq2 = new HttpRequest();                
                        adreq2.setMethod('GET');           
                        adreq2.setEndpoint(adReqURL2);                
                        adreq2.setTimeout(60*1000);                
                        HttpResponse adres2 = null;                
                        http adhttp2= new Http();                           
                        try{
                            adres2 = adhttp2.send(adreq2) ;                
                        }catch(Exception e){
                            
                        }                
                        String adresult2 = adres2.getBody();
                        
                        Map<String, Object> jsonadData2 = (Map<String, Object>)JSON.deserializeUntyped(adresult2);                                                                                  
                        List<Object> data2 = (List<Object>) jsonadData2.get('data');
                        for (Object o : data2) {
                            Map<String, Object> d = (Map<String, Object>) o;
                            String startdate = String.valueOf(d.get('date_start'));   
                            smd.Number_of_member__c = 0;
                            smd.Date__c = Date.valueOf(startdate);
                            smd.Number_of_unik_visitor__c = Integer.valueOf(d.get('unique_impressions'));
                            smd.Number_of_likes__c = Integer.valueOf(d.get('unique_clicks'));
                        }                                                                                  
                        smd.Connection__c = ObjSMS.Id;
                        smd.Name = ObjSMS.Name;// ObjSMS.Socialmedia__r.Socialmedia_type__c;                                     
                        smdList.add(smd); 
                    }
                    
                    List<Social_media_data__c > sdList = [select Id from Social_media_data__c where Connection__c = :ObjSMS.Id];
                    if(sdList<>null){
                        if (Social_media_data__c.sObjectType.getDescribe().isDeletable()){                 
                            delete (sdList);
                        }
                    }
                    if (Social_media_data__c.sObjectType.getDescribe().isCreateable()){                 
                        insert (smdList);
                    }                    
                    if (Socialmedia_logfile__c.sObjectType.getDescribe().isCreateable()){
                        Socialmedia_logfile__c sml = new Socialmedia_logfile__c();
                        sml.Name = ObjSMS.Name;
                        sml.Connection_id__c = ObjSMS.Id;
                        sml.Import_message__c = 'Import data started';
                        insert sml;            
                        Socialmedia_logfile__c smlUpdate = new Socialmedia_logfile__c();  
                        smlUpdate.Id = sml.Id;                
                        smlUpdate.Import_message__c = 'All data replace with fresh data from Facebook Ad successfully'; 
                        smlUpdate.musqot__Imported__c=true;             
                        smlUpdate.Number_of_records__c = success ; 
                        update (smlUpdate);   
                    }
                }else{                    
                    if (Socialmedia_logfile__c.sObjectType.getDescribe().isCreateable()){
                        Socialmedia_logfile__c sml = new Socialmedia_logfile__c();
                        sml.Name = ObjSMS.Name;
                        sml.Connection_id__c = ObjSMS.Id;
                        sml.Import_message__c = 'Import data started';
                        insert sml;            
                        Socialmedia_logfile__c smlUpdate = new Socialmedia_logfile__c();  
                        smlUpdate.Id = sml.Id;                
                        smlUpdate.Import_message__c = 'Error in setting for this connection'; 
                        smlUpdate.musqot__Imported__c=true;             
                        smlUpdate.Number_of_records__c = success ; 
                        update (smlUpdate);   
                    }
                }                
            }                                                                                             
        }catch(Exception e){
            if (Socialmedia_logfile__c.sObjectType.getDescribe().isCreateable()){
                Socialmedia_logfile__c sml = new Socialmedia_logfile__c();
                sml.Name = ObjSMS.Name;
                sml.Connection_id__c = ObjSMS.Id;
                sml.Import_message__c = 'Import data started';
                insert sml;
                Socialmedia_logfile__c smlUpdate = new Socialmedia_logfile__c();  
                smlUpdate.Id = sml.Id;
                smlUpdate.Import_message__c = 'Error in import '+e.getMessage(); 
                smlUpdate.musqot__Imported__c=false;             
                smlUpdate.Number_of_records__c = 0; 
                update (smlUpdate);
            }
        }
    }
    
    public void importfacebookPostData(){
        try{                                                                                            
            if(ObjSMS.Post_Id__c<>null){                
            }                                                                                              
        }catch(Exception e){            
        }
    }
    
    public void importmailchimpData(){   
        if(ObjSMS.Campaign_Id__c<>null){
            importmailchimpCampaignData();
        }
    }
    
    public void importmailchimpCampaignData(){
        try{                                                                                            
            if(ObjSMS.Campaign_Id__c <> null){  
                List<Social_media_data__c> smdList = new List<Social_media_data__c>();
                Integer success = 0;                                                       
                if(mailchimpCampaignConnection() == true){    
                    Date mcDate = Date.today();
                    List<String> dcList = ObjSMS.Access_Token_URL__c.split('-');
                    String dc = String.valueOf(dcList[1]);
                    String summaryReqURL = 'https://'+ dc +'.api.mailchimp.com/2.0/reports/summary?apikey='+ ObjSMS.Access_Token_URL__c +'&cid='+ ObjSMS.Campaign_Id__c;     
                    HttpRequest summaryreq = new HttpRequest();                
                    summaryreq.setMethod('GET');           
                    summaryreq.setEndpoint(summaryReqURL);                
                    summaryreq.setTimeout(60*1000);                
                    HttpResponse summaryres = null;                
                    http summaryh= new Http();                           
                    try{
                        summaryres = summaryh.send(summaryreq);                
                    }catch(Exception e){
                        
                    }                
                    String result1 = summaryres.getBody();
                    if(result1<>null && result1<>''){
                        Integer uniqueClikcs = 0;
                        Integer uniqueOpens = 0;
                        List<Social_media_data__c > sdmList = [select Id,Number_of_likes__c,Number_of_unik_visitor__c,Number_of_member__c from Social_media_data__c where Connection__c = :ObjSMS.Id];
                        for(Social_media_data__c sd : sdmList){
                            uniqueClikcs += Integer.valueOf(sd.Number_of_likes__c);
                            uniqueOpens += Integer.valueOf(sd.Number_of_unik_visitor__c);
                        }
                        Map<String, Object> jsonData1 = (Map<String, Object>)JSON.deserializeUntyped(result1);                                
                        Social_media_data__c smd = new Social_media_data__c();
                        success = success + 1;
                        smd.Number_of_member__c = 0;
                        smd.Number_of_likes__c = Math.abs(Integer.valueOf(jsonData1.get('unique_clicks')) - uniqueClikcs);
                        smd.Number_of_unik_visitor__c = Math.abs(Integer.valueOf(jsonData1.get('unique_opens')) - uniqueOpens);
                        smd.Date__c = mcDate;//.addDays(-1);                            
                        smd.Connection__c = ObjSMS.Id;
                        smd.Name = ObjSMS.Name;// ObjSMS.Socialmedia__r.Socialmedia_type__c;                                     
                        smdList.add(smd);                                                            
                    }
                    List<Social_media_data__c > sdList = [select Id from Social_media_data__c where Connection__c = :ObjSMS.Id and Date__c = :mcDate];
                    if(sdList.size() == 0){
                        if (Social_media_data__c.sObjectType.getDescribe().isCreateable()){                 
                        	insert (smdList);
                    	}
                    }                     
                    if (Socialmedia_logfile__c.sObjectType.getDescribe().isCreateable()){
                        Socialmedia_logfile__c sml = new Socialmedia_logfile__c();
                        sml.Name = ObjSMS.Name;
                        sml.Connection_id__c = ObjSMS.Id;
                        sml.Import_message__c = 'Import data started';
                        insert sml;            
                        Socialmedia_logfile__c smlUpdate = new Socialmedia_logfile__c();  
                        smlUpdate.Id = sml.Id;                
                        smlUpdate.Import_message__c = 'All data replace with fresh data from MailChimp successfully'; 
                        smlUpdate.musqot__Imported__c=true;             
                        smlUpdate.Number_of_records__c = success ; 
                        update (smlUpdate);   
                    }
                }
                else{                    
                    if (Socialmedia_logfile__c.sObjectType.getDescribe().isCreateable()){
                        Socialmedia_logfile__c sml = new Socialmedia_logfile__c();
                        sml.Name = ObjSMS.Name;
                        sml.Connection_id__c = ObjSMS.Id;
                        sml.Import_message__c = 'Import data started';
                        insert sml;            
                        Socialmedia_logfile__c smlUpdate = new Socialmedia_logfile__c();  
                        smlUpdate.Id = sml.Id;                
                        smlUpdate.Import_message__c = 'Error in setting for this connection'; 
                        smlUpdate.musqot__Imported__c=true;             
                        smlUpdate.Number_of_records__c = success ; 
                        update (smlUpdate);   
                    }
                }
            }                                                                                      
        }catch(Exception e){
            if (Socialmedia_logfile__c.sObjectType.getDescribe().isCreateable()){
                Socialmedia_logfile__c sml = new Socialmedia_logfile__c();
                sml.Name = ObjSMS.Name;
                sml.Connection_id__c = ObjSMS.Id;
                sml.Import_message__c = 'Import data started';
                insert sml;
                Socialmedia_logfile__c smlUpdate = new Socialmedia_logfile__c();  
                smlUpdate.Id = sml.Id;
                smlUpdate.Import_message__c = 'Error in import '+e.getMessage(); 
                smlUpdate.musqot__Imported__c=false;             
                smlUpdate.Number_of_records__c = 0; 
                update (smlUpdate);
            }
        }
    }
    
    public void importsocialmediaData(){
        if(ObjSMS.Social_media__c == 'Facebook'){
            importfacebookData();
        }else if(ObjSMS.Social_media__c == 'MailChimp'){
            importmailchimpData();
        }else if(ObjSMS.Social_media__c == 'LinkedIn'){
            importlinkedinData();
        }
    }    
    
    public void linkedinConnection(){
        if(ObjSMS.Page_Id__c<>null && ObjSMS.Post_Id__c<>null){
            linkedinPostConnection();
        }else if(ObjSMS.Page_Id__c<>null){
            linkedinPageConnection();
        }        
    }
    
    public boolean linkedinPageConnection(){
        try{
            if(ObjSMS.Page_Id__c <> null){               
                String appId;                
                HttpRequest appIdreq = new HttpRequest();     
                appIdreq.setEndpoint('https://api.linkedin.com/v1/companies/'+ ObjSMS.Page_Id__c +'?oauth2_access_token=' + ObjSMS.Access_Token_URL__c + '&format=json');
                appIdreq.setMethod('GET');         
                Http appIdhttp = new Http();
                HTTPResponse appIdres = appIdhttp.send(appIdreq);      
                String appIdresult = appIdres.getBody();           
                if(appIdresult<>null && appIdresult<>''){
                    Map<String, Object> appIddata = (Map<String, Object>)JSON.deserializeUntyped(appIdresult);                             
                    if(ObjSMS.Page_Id__c == String.valueOf(appIddata.get('id'))){
                        smMessage = true;                   
                    }else{
                        smMessage = false;  
                    }
                }else{
                    smMessage = false;  
                }
            }        
        }catch(Exception e){
            smMessage = false; 
        }
        return smMessage;
    }
    
    public boolean linkedinPostConnection(){
        try{
            if(ObjSMS.Page_Id__c <> null && ObjSMS.Post_ID__c <> null){               
                String appId;                
                HttpRequest appIdreq = new HttpRequest();     
                appIdreq.setEndpoint('https://api.linkedin.com/v1/companies/'+EncodingUtil.urlEncode(ObjSMS.Page_Id__c,'UTF-8')+'/updates/key=UPDATE-c'+EncodingUtil.urlEncode(ObjSMS.Page_Id__c,'UTF-8')+'-'+EncodingUtil.urlEncode(ObjSMS.Post_ID__c,'UTF-8')+'?oauth2_access_token='+ObjSMS.Access_Token_URL__c+'&format=json');
                appIdreq.setMethod('GET');         
                Http appIdhttp = new Http();
                HTTPResponse appIdres = appIdhttp.send(appIdreq);      
                String appIdresult = appIdres.getBody();           
                if(appIdresult<>null && appIdresult<>''){
                    Map<String, Object> appIddata = (Map<String, Object>)JSON.deserializeUntyped(appIdresult);                             
                    if(String.valueOf(appIddata.get('errorCode')) == '0'){
                        smMessage = false;                   
                    }else{
                        smMessage = true;  
                    }
                }else{
                    smMessage = false;  
                }
            }        
        }catch(Exception e){
            smMessage = false; 
        }
        return smMessage;
    }
    
    public void importlinkedinData(){
        if(ObjSMS.Page_Id__c<>null && ObjSMS.Post_Id__c<>null){
            importlinkedinPostData();
        }else if(ObjSMS.Page_Id__c<>null){
            importlinkedinPageData();
        } 
    }
    
    public void importlinkedinPageData(){
        try{                                                                                            
            if(ObjSMS.Page_Id__c <> null){  
                List<Social_media_data__c> smdList = new List<Social_media_data__c>();
                Integer success = 0;                                                       
                if(linkedinPageConnection() == true){                                             
                    String ReqURL;
                    String visitorReqURL;
                    String followerReqURL;
                    Date todayDate= Date.today().addDays(-1);
                    Date startDate;
                    startDate = todayDate.addMonths(-3); 
                    system.debug('abc');
                    system.debug('todayDate '+todayDate);
                    system.debug('startDate '+startDate);
                    Date dateSince = Date.newInstance(startDate.year(), startDate.month(), startDate.day());
                    Time timeSince = Time.newInstance(0, 0, 0, 0);
                    DateTime dtSince = DateTime.newInstanceGmt(dateSince, timeSince);
                    Long lSince = dtSince.getTime();
                    Date dateUntil = Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day());
                    Time timeUntil = Time.newInstance(0,0,0,0);
                    DateTime dtUntil = DateTime.newInstanceGmt(dateUntil, timeUntil);
                    Long lUntil = dtUntil.getTime();
                    system.debug('lSince '+lSince);
                    system.debug('lUntil '+lUntil);
                    ReqURL = 'https://api.linkedin.com/v1/companies/'+EncodingUtil.urlEncode(ObjSMS.Page_Id__c,'UTF-8')+'/historical-status-update-statistics?oauth2_access_token='+ObjSMS.Access_Token_URL__c+'&time-granularity=day&start-timestamp='+lSince+'&end-timestamp='+lUntil+'&format=json';                
                    visitorReqURL = 'https://api.linkedin.com/v1/companies/'+EncodingUtil.urlEncode(ObjSMS.Page_Id__c,'UTF-8')+'/historical-status-update-statistics?oauth2_access_token='+ObjSMS.Access_Token_URL__c+'&time-granularity=day&start-timestamp='+lSince+'&end-timestamp='+lUntil+'&format=json';                
                    followerReqURL = 'https://api.linkedin.com/v1/companies/'+EncodingUtil.urlEncode(ObjSMS.Page_Id__c,'UTF-8')+'/historical-follow-statistics?oauth2_access_token='+ObjSMS.Access_Token_URL__c+'&time-granularity=day&start-timestamp='+lSince+'&end-timestamp='+lUntil+'&format=json';                
                    HttpRequest req1 = new HttpRequest();                
                    req1.setMethod('GET');           
                    req1.setEndpoint(ReqURL);                
                    req1.setTimeout(60*1000);                
                    HttpResponse res1 = null;                
                    http h1= new Http();                           
                    try{
                        res1 = h1.send(req1) ;                
                    }catch(Exception e){
                        
                    }                
                    String result1 = res1.getBody();
                    
                    HttpRequest visitorreq1 = new HttpRequest();                
                    visitorreq1.setMethod('GET');           
                    visitorreq1.setEndpoint(visitorReqURL);                
                    visitorreq1.setTimeout(60*1000);                
                    HttpResponse visitorres1 = null;                
                    http visitorh1= new Http();                           
                    try{
                        visitorres1 = visitorh1.send(visitorreq1) ;                
                    }catch(Exception e){
                        
                    }                
                    String visitorresult1 = visitorres1.getBody();
                    
                    HttpRequest followerreq1 = new HttpRequest();                
                    followerreq1.setMethod('GET');           
                    followerreq1.setEndpoint(followerReqURL);                
                    followerreq1.setTimeout(60*1000);                
                    HttpResponse followerres1 = null;                
                    http followerh1= new Http();                           
                    try{
                        followerres1 = followerh1.send(followerreq1) ;                
                    }catch(Exception e){
                        
                    }                
                    String followerresult1 = followerres1.getBody(); 
                    if(result1<>null && result1<>''){
                        Map<String, Object> jsonData1 = (Map<String, Object>)JSON.deserializeUntyped(result1);                                                                                  
                        List<Object> values = (List<Object>) jsonData1.get('values');
                        for (Object v : values) {
                            success = success + 1;
                            Social_media_data__c smd = new Social_media_data__c();
                            Map<String, Object> value = (Map<String, Object>) v;                            
                            smd.Number_of_likes__c = Integer.valueOf((value.get('impressionCount')));    
                            Long endTime = Long.valueOf(String.valueOf(value.get('time')));  							
                            DateTime endDate = DateTime.newInstance(endTime); 
                            Date fbendDate = Date.valueOf(endDate);
                            smd.Date__c = fbendDate;//.addDays(-1);                            
                            smd.Connection__c = ObjSMS.Id;
                            smd.Name = ObjSMS.Name;// ObjSMS.Socialmedia__r.Socialmedia_type__c;                                     
                            smdList.add(smd);   
                        }                                                            
                    }  
                    List<Social_media_data__c > sdList = [select Id from Social_media_data__c where Connection__c = :ObjSMS.Id];
                    if(sdList<>null){
                        if (Social_media_data__c.sObjectType.getDescribe().isDeletable()){                 
                            delete (sdList);
                        }
                    }
                    if (Social_media_data__c.sObjectType.getDescribe().isCreateable()){                 
                        insert (smdList);
                    }   
                    List<Social_media_data__c > sdvisitorList = [select Id, Name, Date__C, Connection__c from Social_media_data__c where Connection__c = :ObjSMS.Id];
                    List<Social_media_data__c> smdvisitorList = new List<Social_media_data__c>();
                    if(visitorresult1<>null && visitorresult1<>''){
                        Map<String, Object> visitorjsonData1 = (Map<String, Object>)JSON.deserializeUntyped(visitorresult1);                                                                                  
                        List<Object> values = (List<Object>) visitorjsonData1.get('values');
                        for (Object v : values) {
                            for (Social_media_data__c md : sdvisitorList){
                                Social_media_data__c smd = new Social_media_data__c();
                                Map<String, Object> value = (Map<String, Object>) v;                              
                                smd.Number_of_unik_visitor__c = Integer.valueOf((value.get('impressionCount')));    
                                Long endTime = Long.valueOf(String.valueOf(value.get('time')));                                   
                                DateTime endDate = DateTime.newInstance(endTime);                                                                            
                                Date fbendDate = Date.valueOf(endDate);
                                smd.Date__c = fbendDate;//.addDays(-1);  
                                smd.Connection__c = ObjSMS.Id;
                                smd.Name = ObjSMS.Name;// ObjSMS.Socialmedia__r.Socialmedia_type__c;                               
                                smd.Id = md.Id;
                                if(smd.Date__c == md.Date__c && smd.Connection__c == md.Connection__c){
                                    smdvisitorList.add(smd); 
                                }
                            }
                        }                                                            
                    }
                    List<Social_media_data__c > sdfollowerList = [select Id, Name, Date__C, Connection__c from Social_media_data__c where Connection__c = :ObjSMS.Id];
                    List<Social_media_data__c> smdfollowerList = new List<Social_media_data__c>();
                    if(followerresult1<>null && followerresult1<>''){
                        Map<String, Object> followerjsonData1 = (Map<String, Object>)JSON.deserializeUntyped(followerresult1);                                                                                  
                        List<Object> values = (List<Object>) followerjsonData1.get('values');
                        for (Object v : values) {
                            for (Social_media_data__c md : sdfollowerList){
                                Social_media_data__c smd = new Social_media_data__c();
                                Map<String, Object> value = (Map<String, Object>) v;                            
                                smd.Number_of_member__c = Integer.valueOf((value.get('totalFollowerCount')));    
                                Long endTime = Long.valueOf(String.valueOf(value.get('time')));  
                                DateTime endDate = DateTime.newInstance(endTime);                                            
                                Date fbendDate = Date.valueOf(endDate);
                                smd.Date__c = fbendDate;//.addDays(-1); 
                                smd.Connection__c = ObjSMS.Id;
                                smd.Name = ObjSMS.Name;// ObjSMS.Socialmedia__r.Socialmedia_type__c;                                     
                                smd.Id = md.Id;
                                if(smd.Date__c == md.Date__c && smd.Connection__c == md.Connection__c){
                                    smdfollowerList.add(smd); 
                                }
                            }
                        }                                                            
                    }
                    
                    if(sdvisitorList<>null){
                        if (Social_media_data__c.sObjectType.getDescribe().isUpdateable()){                 
                            update (smdvisitorList);
                        }
                    }
                    
                    if(sdfollowerList<>null){
                        if (Social_media_data__c.sObjectType.getDescribe().isUpdateable()){                 
                            update (smdfollowerList);
                        }
                    }
                    
                    if (OAuthService__c.sObjectType.getDescribe().isUpdateable()){                 
                        update ObjSMS;
                    }                      
                    if (Socialmedia_logfile__c.sObjectType.getDescribe().isCreateable()){
                        Socialmedia_logfile__c sml = new Socialmedia_logfile__c();
                        sml.Name = ObjSMS.Name;
                        sml.Connection_id__c = ObjSMS.Id;
                        sml.Import_message__c = 'Import data started';
                        insert sml;            
                        Socialmedia_logfile__c smlUpdate = new Socialmedia_logfile__c();  
                        smlUpdate.Id = sml.Id;                
                        smlUpdate.Import_message__c = 'All data replace with fresh data from Linkedin successfully'; 
                        smlUpdate.musqot__Imported__c=true;             
                        smlUpdate.Number_of_records__c = success ; 
                        update (smlUpdate);   
                    }
                }
                else{                    
                    if (Socialmedia_logfile__c.sObjectType.getDescribe().isCreateable()){
                        Socialmedia_logfile__c sml = new Socialmedia_logfile__c();
                        sml.Name = ObjSMS.Name;
                        sml.Connection_id__c = ObjSMS.Id;
                        sml.Import_message__c = 'Import data started';
                        insert sml;            
                        Socialmedia_logfile__c smlUpdate = new Socialmedia_logfile__c();  
                        smlUpdate.Id = sml.Id;                
                        smlUpdate.Import_message__c = 'Error in setting for this connection'; 
                        smlUpdate.musqot__Imported__c=true;             
                        smlUpdate.Number_of_records__c = success ; 
                        update (smlUpdate);   
                    }
                }
            }                                                                                      
        }catch(Exception e){
            if (Socialmedia_logfile__c.sObjectType.getDescribe().isCreateable()){
                Socialmedia_logfile__c sml = new Socialmedia_logfile__c();
                sml.Name = ObjSMS.Name;
                sml.Connection_id__c = ObjSMS.Id;
                sml.Import_message__c = 'Import data started';
                insert sml;
                Socialmedia_logfile__c smlUpdate = new Socialmedia_logfile__c();  
                smlUpdate.Id = sml.Id;
                smlUpdate.Import_message__c = 'Error in import '+e.getMessage(); 
                smlUpdate.musqot__Imported__c=false;             
                smlUpdate.Number_of_records__c = 0; 
                update (smlUpdate);
            }
        }
    }
    
    public void importlinkedinPostData(){
        try{                                                                                            
            if(ObjSMS.Page_Id__c <> null && ObjSMS.Post_ID__c <> null){  
                List<Social_media_data__c> smdList = new List<Social_media_data__c>();
                Integer success = 0;                                                       
                if(linkedinPostConnection() == true){                                             
                    String ReqURL;
                    String visitorReqURL;
                    String followerReqURL;
                    Date todayDate= Date.today().addDays(-1);
                    Date startDate;
                    startDate = todayDate.addMonths(-3); 
                    system.debug('abc');
                    system.debug('todayDate '+todayDate);
                    system.debug('startDate '+startDate);
                    Date dateSince = Date.newInstance(startDate.year(), startDate.month(), startDate.day());
                    Time timeSince = Time.newInstance(0, 0, 0, 0);
                    DateTime dtSince = DateTime.newInstanceGmt(dateSince, timeSince);
                    Long lSince = dtSince.getTime();
                    Date dateUntil = Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day());
                    Time timeUntil = Time.newInstance(0,0,0,0);
                    DateTime dtUntil = DateTime.newInstanceGmt(dateUntil, timeUntil);
                    Long lUntil = dtUntil.getTime();
                    system.debug('lSince '+lSince);
                    system.debug('lUntil '+lUntil);
                    ReqURL = 'https://api.linkedin.com/v1/companies/'+EncodingUtil.urlEncode(ObjSMS.Page_Id__c,'UTF-8')+'/updates/key=UPDATE-c'+EncodingUtil.urlEncode(ObjSMS.Page_Id__c,'UTF-8')+'-'+EncodingUtil.urlEncode(ObjSMS.Post_ID__c,'UTF-8')+'/likes?oauth2_access_token='+ObjSMS.Access_Token_URL__c+'&format=json';                
                    visitorReqURL = 'https://api.linkedin.com/v1/companies/'+EncodingUtil.urlEncode(ObjSMS.Page_Id__c,'UTF-8')+'/historical-status-update-statistics?oauth2_access_token='+ObjSMS.Access_Token_URL__c+'&time-granularity=day&start-timestamp='+lSince+'&end-timestamp='+lUntil+'&update-key=UPDATE-c'+EncodingUtil.urlEncode(ObjSMS.Page_Id__c,'UTF-8')+'-'+EncodingUtil.urlEncode(ObjSMS.Post_ID__c,'UTF-8')+'&format=json';                
                    followerReqURL = 'https://api.linkedin.com/v1/companies/'+EncodingUtil.urlEncode(ObjSMS.Page_Id__c,'UTF-8')+'/historical-follow-statistics?oauth2_access_token='+ObjSMS.Access_Token_URL__c+'&time-granularity=day&start-timestamp='+lSince+'&end-timestamp='+lUntil+'&format=json';                
                    HttpRequest req1 = new HttpRequest();                
                    req1.setMethod('GET');           
                    req1.setEndpoint(ReqURL);                
                    req1.setTimeout(60*1000);                
                    HttpResponse res1 = null;                
                    http h1= new Http();                           
                    try{
                        res1 = h1.send(req1) ;                
                    }catch(Exception e){
                        
                    }                
                    String result1 = res1.getBody();
                    
                    HttpRequest visitorreq1 = new HttpRequest();                
                    visitorreq1.setMethod('GET');           
                    visitorreq1.setEndpoint(visitorReqURL);                
                    visitorreq1.setTimeout(60*1000);                
                    HttpResponse visitorres1 = null;                
                    http visitorh1= new Http();                           
                    try{
                        visitorres1 = visitorh1.send(visitorreq1) ;                
                    }catch(Exception e){
                        
                    }                
                    String visitorresult1 = visitorres1.getBody();
                    
                    HttpRequest followerreq1 = new HttpRequest();                
                    followerreq1.setMethod('GET');           
                    followerreq1.setEndpoint(followerReqURL);                
                    followerreq1.setTimeout(60*1000);                
                    HttpResponse followerres1 = null;                
                    http followerh1= new Http();                           
                    try{
                        followerres1 = followerh1.send(followerreq1) ;                
                    }catch(Exception e){
                        
                    }                
                    String followerresult1 = followerres1.getBody(); 
                    if(result1<>null && result1<>''){
                        Map<String, Object> jsonData1 = (Map<String, Object>)JSON.deserializeUntyped(result1);                                                                                  
                        List<Object> values = (List<Object>) jsonData1.get('values');
                        for (Object v : values) {
                            success = success + 1;
                            Social_media_data__c smd = new Social_media_data__c();
                            Map<String, Object> value = (Map<String, Object>) v;                            
                            smd.Number_of_likes__c = 1;    
                            Long endTime = Long.valueOf(String.valueOf(value.get('timestamp')));  							
                            DateTime endDate = DateTime.newInstance(endTime); 
                            Date fbendDate = Date.valueOf(endDate);
                            smd.Date__c = fbendDate;//.addDays(-1);                            
                            smd.Connection__c = ObjSMS.Id;
                            smd.Name = ObjSMS.Name;// ObjSMS.Socialmedia__r.Socialmedia_type__c;                                     
                            smdList.add(smd);   
                        }                           
                    }  
                    List<Social_media_data__c > sdList = [select Id from Social_media_data__c where Connection__c = :ObjSMS.Id];
                    if(sdList<>null){
                        if (Social_media_data__c.sObjectType.getDescribe().isDeletable()){                 
                            delete (sdList);
                        }
                    }
                    if (Social_media_data__c.sObjectType.getDescribe().isCreateable()){                 
                        insert (smdList);
                    }   
                    List<Social_media_data__c > sdvisitorList = [select Id, Name, Date__C, Connection__c from Social_media_data__c where Connection__c = :ObjSMS.Id];
                    List<Social_media_data__c> smdvisitorList = new List<Social_media_data__c>();
                    if(visitorresult1<>null && visitorresult1<>''){
                        Map<String, Object> visitorjsonData1 = (Map<String, Object>)JSON.deserializeUntyped(visitorresult1);                                                                                  
                        List<Object> values = (List<Object>) visitorjsonData1.get('values');
                        for (Object v : values) {
                            for (Social_media_data__c md : sdvisitorList){
                                Social_media_data__c smd = new Social_media_data__c();
                                Map<String, Object> value = (Map<String, Object>) v;                              
                                smd.Number_of_unik_visitor__c = Integer.valueOf((value.get('impressionCount')));    
                                Long endTime = Long.valueOf(String.valueOf(value.get('time')));                                   
                                DateTime endDate = DateTime.newInstance(endTime);                                                                            
                                Date fbendDate = Date.valueOf(endDate);
                                smd.Date__c = fbendDate;//.addDays(-1);  
                                smd.Connection__c = ObjSMS.Id;
                                smd.Name = ObjSMS.Name;// ObjSMS.Socialmedia__r.Socialmedia_type__c;                               
                                smd.Id = md.Id;
                                if(smd.Date__c == md.Date__c && smd.Connection__c == md.Connection__c){
                                    smdvisitorList.add(smd); 
                                }
                            }
                        }                                                            
                    }
                    List<Social_media_data__c > sdfollowerList = [select Id, Name, Date__C, Connection__c from Social_media_data__c where Connection__c = :ObjSMS.Id];
                    List<Social_media_data__c> smdfollowerList = new List<Social_media_data__c>();
                    if(followerresult1<>null && followerresult1<>''){
                        Map<String, Object> followerjsonData1 = (Map<String, Object>)JSON.deserializeUntyped(followerresult1);                                                                                  
                        List<Object> values = (List<Object>) followerjsonData1.get('values');
                        for (Object v : values) {
                            for (Social_media_data__c md : sdfollowerList){
                                Social_media_data__c smd = new Social_media_data__c();
                                Map<String, Object> value = (Map<String, Object>) v;                            
                                smd.Number_of_member__c = Integer.valueOf((value.get('totalFollowerCount')));    
                                Long endTime = Long.valueOf(String.valueOf(value.get('time')));  
                                DateTime endDate = DateTime.newInstance(endTime);                                            
                                Date fbendDate = Date.valueOf(endDate);
                                smd.Date__c = fbendDate;//.addDays(-1); 
                                smd.Connection__c = ObjSMS.Id;
                                smd.Name = ObjSMS.Name;// ObjSMS.Socialmedia__r.Socialmedia_type__c;                                     
                                smd.Id = md.Id;
                                if(smd.Date__c == md.Date__c && smd.Connection__c == md.Connection__c){
                                    smdfollowerList.add(smd); 
                                }
                            }
                        }                                                            
                    }
                    
                    if(sdvisitorList<>null){
                        if (Social_media_data__c.sObjectType.getDescribe().isUpdateable()){                 
                            update (smdvisitorList);
                        }
                    }
                    
                    if(sdfollowerList<>null){
                        if (Social_media_data__c.sObjectType.getDescribe().isUpdateable()){                 
                            update (smdfollowerList);
                        }
                    }
                    
                    if (OAuthService__c.sObjectType.getDescribe().isUpdateable()){                 
                        update ObjSMS;
                    }                      
                    if (Socialmedia_logfile__c.sObjectType.getDescribe().isCreateable()){
                        Socialmedia_logfile__c sml = new Socialmedia_logfile__c();
                        sml.Name = ObjSMS.Name;
                        sml.Connection_id__c = ObjSMS.Id;
                        sml.Import_message__c = 'Import data started';
                        insert sml;            
                        Socialmedia_logfile__c smlUpdate = new Socialmedia_logfile__c();  
                        smlUpdate.Id = sml.Id;                
                        smlUpdate.Import_message__c = 'All data replace with fresh data from Linkedin updates successfully'; 
                        smlUpdate.musqot__Imported__c=true;             
                        smlUpdate.Number_of_records__c = success ; 
                        update (smlUpdate);   
                    }
                }
                else{                    
                    if (Socialmedia_logfile__c.sObjectType.getDescribe().isCreateable()){
                        Socialmedia_logfile__c sml = new Socialmedia_logfile__c();
                        sml.Name = ObjSMS.Name;
                        sml.Connection_id__c = ObjSMS.Id;
                        sml.Import_message__c = 'Import data started';
                        insert sml;            
                        Socialmedia_logfile__c smlUpdate = new Socialmedia_logfile__c();  
                        smlUpdate.Id = sml.Id;                
                        smlUpdate.Import_message__c = 'Error in setting for this connection'; 
                        smlUpdate.musqot__Imported__c=true;             
                        smlUpdate.Number_of_records__c = success ; 
                        update (smlUpdate);   
                    }
                }
            }                                                                                      
        }catch(Exception e){
            if (Socialmedia_logfile__c.sObjectType.getDescribe().isCreateable()){
                Socialmedia_logfile__c sml = new Socialmedia_logfile__c();
                sml.Name = ObjSMS.Name;
                sml.Connection_id__c = ObjSMS.Id;
                sml.Import_message__c = 'Import data started';
                insert sml;
                Socialmedia_logfile__c smlUpdate = new Socialmedia_logfile__c();  
                smlUpdate.Id = sml.Id;
                smlUpdate.Import_message__c = 'Error in import '+e.getMessage(); 
                smlUpdate.musqot__Imported__c=false;             
                smlUpdate.Number_of_records__c = 0; 
                update (smlUpdate);
            }
        }
    }        
    
    /***** Scheduling Social Media Data *****/ 
    @future(callout=true)  
    public static void querySocialMediaInsights(){
        List<OAuthService__c> cntList = new List<OAuthService__c>();
        try{            
            cntList = [select id, Name, Access_Token_URL__c, Authorization_Type__c, Authorization_URL__c,Page_Id__c,Post_ID__c,ad_ID__c,social_media__c,Socialmedia__c,Campaign_Id__c, Consumer_Key__c,
                       Bar_color__c,Consumer_Secret__c, Redirect_URL__c, Request_Token_URL__c, Response_Type__c, Scope__c, 
                      Signature_Method__c, Auto_import__c, End_Date__c 
                      from OAuthService__c  where Auto_import__c = :true];   
            
        }catch(exception e){} 
        try{
            List<CronJobDetail> cj = [select id, Name from CronJobDetail where Name Like :'scheduleFacebookPageInsightsJob_%'];
            List<CronTrigger> ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where CronJobDetailId IN :cj];
            for(CronTrigger c : ct){
            	system.abortJob(c.Id);   
            }            
        }catch(Exception e){}
        for(OAuthService__c ObjSMS : cntList){     
            if(ObjSMS.Social_media__c == 'Facebook'){                
               if(ObjSMS.end_date__c > System.today()) { 
                    try{
                        if(ObjSMS.Page_Id__c <> null && ObjSMS.ad_id__c == null){                                                           
                            String SchTimer='0 0 0 1/1 * ? *';   
                            //Datetime sysTime = System.now().addSeconds( 60 );      
                            //String SchTimer = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
                            if(ObjSMS.Social_media__c == 'Facebook'){                                    
                                system.schedule('scheduleFacebookPageInsightsJob_'+ObjSMS.Id, SchTimer, new scheduleFacebookPageInsights(ObjSMS.Id));
                            }
                        }
                    }catch(Exception e){
                        if (Socialmedia_logfile__c.sObjectType.getDescribe().isCreateable()){
                            Socialmedia_logfile__c sml = new Socialmedia_logfile__c();
                            sml.Name = ObjSMS.Name;
                            sml.Connection_id__c = ObjSMS.Id;
                            sml.Import_message__c = 'Import data started';
                            insert sml;
                            Socialmedia_logfile__c smlUpdate = new Socialmedia_logfile__c();  
                            smlUpdate.Id = sml.Id;
                            smlUpdate.Import_message__c = 'Error in import '+e.getMessage(); 
                            smlUpdate.musqot__Imported__c=false;             
                            smlUpdate.Number_of_records__c = 0; 
                            update (smlUpdate);
                        }
                    }
            	}
            } 
        }
    } 
    @future(callout=true)  
    public static void querySocialMediaPageInsights(String conId){
        List<OAuthService__c> cntList = new List<OAuthService__c>();
        try{            
            cntList = [select id, Name, Access_Token_URL__c, Authorization_Type__c, Authorization_URL__c,Page_Id__c,Post_ID__c,ad_ID__c,social_media__c,Socialmedia__c,Campaign_Id__c, Consumer_Key__c,
                       Bar_color__c,Consumer_Secret__c, Redirect_URL__c, Request_Token_URL__c, Response_Type__c, Scope__c, 
                      Signature_Method__c, Auto_import__c, End_Date__c 
                      from OAuthService__c  where Id = :conId and Auto_import__c = :true];   
            
        }catch(exception e){} 
        
        for(OAuthService__c ObjSMS : cntList){     
            if(ObjSMS.Social_media__c == 'Facebook'){                
               if(ObjSMS.end_date__c > System.today()) { 
                    try{
                        if(ObjSMS.Page_Id__c <> null && ObjSMS.ad_id__c == null){                              
                            List<Social_media_data__c> smdList = new List<Social_media_data__c>();
                            Integer success = 0;
                            Date fbschedDate;
                            String appId;                
                            HttpRequest appIdreq = new HttpRequest();     
                            appIdreq.setEndpoint('https://graph.facebook.com/'+ ObjSMS.Page_Id__c +'?access_token='+ ObjSMS.Access_Token_URL__c + '');
                            appIdreq.setMethod('GET');         
                            Http appIdhttp = new Http();                         
                            HTTPResponse appIdres = appIdhttp.send(appIdreq);      
                            String appIdresult = appIdres.getBody();                         
                            if(appIdresult<>null && appIdresult<>''){
                                system.debug('appids3'+appId);    
                                Map<String, Object> appIddata = (Map<String, Object>)JSON.deserializeUntyped(appIdresult);             
                                appId = String.valueOf(appIddata.get('id'));
                            }                                                                  
                            if(appId == ObjSMS.Page_Id__c){                                
                                system.debug('appids'+appId);                                  
                                //First Request                
                                String ReqURL;
                                String visitorReqURL;
                                String followerReqURL;
                                Date todayDate= Date.today().addDays(-1);
                                Date startDate;
                                startDate = todayDate.addDays(-1); 
                                system.debug('abc');
                                system.debug('todayDate '+todayDate);
                                system.debug('startDate '+startDate);
                                Date dateSince = Date.newInstance(startDate.year(), startDate.month(), startDate.day());
                                Time timeSince = Time.newInstance(0, 0, 0, 0);
                                DateTime dtSince = DateTime.newInstanceGmt(dateSince, timeSince);
                                Long lSince = dtSince.getTime() / 1000;
                                Date dateUntil = Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day());
                                Time timeUntil = Time.newInstance(0,0,0,0);
                                DateTime dtUntil = DateTime.newInstanceGmt(dateUntil, timeUntil);
                                Long lUntil = dtUntil.getTime() / 1000;
                                ReqURL = 'https://graph.facebook.com/'+EncodingUtil.urlEncode(ObjSMS.Page_Id__c,'UTF-8')+'/insights/page_fan_adds_unique/day?access_token='+ObjSMS.Access_Token_URL__c+'&since='+lSince+'&until='+lUntil;                
                                visitorReqURL = 'https://graph.facebook.com/'+EncodingUtil.urlEncode(ObjSMS.Page_Id__c,'UTF-8')+'/insights/page_tab_views_login_top_unique/day?access_token='+ObjSMS.Access_Token_URL__c+'&since='+lSince+'&until='+lUntil;                
                                followerReqURL = 'https://graph.facebook.com/'+EncodingUtil.urlEncode(ObjSMS.Page_Id__c,'UTF-8')+'/insights/page_follower_adds_unique/day?access_token='+ObjSMS.Access_Token_URL__c+'&since='+lSince+'&until='+lUntil;                
                                HttpRequest req1 = new HttpRequest();                
                                req1.setMethod('GET');           
                                req1.setEndpoint(ReqURL);                
                                req1.setTimeout(60*1000);                
                                HttpResponse res1 = null;                
                                http h1= new Http();                           
                                try{
                                    res1 = h1.send(req1) ;                
                                }catch(Exception e){
                                    
                                }                
                                String result1 = res1.getBody();
                                
                                HttpRequest visitorreq1 = new HttpRequest();                
                                visitorreq1.setMethod('GET');           
                                visitorreq1.setEndpoint(visitorReqURL);                
                                visitorreq1.setTimeout(60*1000);                
                                HttpResponse visitorres1 = null;                
                                http visitorh1= new Http();                           
                                try{
                                    visitorres1 = visitorh1.send(visitorreq1) ;                
                                }catch(Exception e){
                                    
                                }                
                                String visitorresult1 = visitorres1.getBody();
                                
                                HttpRequest followerreq1 = new HttpRequest();                
                                followerreq1.setMethod('GET');           
                                followerreq1.setEndpoint(followerReqURL);                
                                followerreq1.setTimeout(60*1000);                
                                HttpResponse followerres1 = null;                
                                http followerh1= new Http();                           
                                try{
                                    followerres1 = followerh1.send(followerreq1) ;                
                                }catch(Exception e){
                                    
                                }                
                                String followerresult1 = followerres1.getBody(); 
                                if(result1<>null && result1<>''){
                                    Map<String, Object> jsonData1 = (Map<String, Object>)JSON.deserializeUntyped(result1);                                                                                  
                                    List<Object> data = (List<Object>) jsonData1.get('data');
                                    for (Object o : data) {
                                        Map<String, Object> d = (Map<String, Object>) o;
                                        List<Object> values = (List<Object>) d.get('values');
                                        for (Object v : values) {
                                            success = success + 1;
                                            Social_media_data__c smd = new Social_media_data__c();
                                            Map<String, Object> value = (Map<String, Object>) v;                            
                                            smd.Number_of_likes__c = Integer.valueOf((value.get('value')));    
                                            String fbendTime = String.valueOf((value.get('end_time')));                              
                                            List<String> enddate1 = fbendTime.split('T',-1);
                                            List<String> enddate2 = enddate1[0].split('-',-1);                        
                                            Date fbendDate = Date.newInstance(Integer.valueOf(enddate2[0]),Integer.valueOf(enddate2[1]),Integer.valueOf(enddate2[2]));                        
                                            smd.Date__c = fbendDate;//.addDays(-1);   
                                            fbschedDate = smd.Date__c;
                                            smd.Connection__c = ObjSMS.Id;
                                            smd.Name = ObjSMS.Name;// ObjSMS.Socialmedia__r.Socialmedia_type__c;                                     
                                            smdList.add(smd);   
                                        }                       
                                    }                                                            
                                }  
                                List<Social_media_data__c > sdList = [select Id from Social_media_data__c where Connection__c = :ObjSMS.Id and Date__c = :fbschedDate];
                                if(sdList<>null){
                                    if (Social_media_data__c.sObjectType.getDescribe().isDeletable()){                 
                                        delete (sdList);
                                    }
                                }
                                if (Social_media_data__c.sObjectType.getDescribe().isCreateable()){                 
                                    insert (smdList);
                                }   
                                List<Social_media_data__c > sdvisitorList = [select Id, Name, Date__C, Connection__c from Social_media_data__c where Connection__c = :ObjSMS.Id];
                                List<Social_media_data__c> smdvisitorList = new List<Social_media_data__c>();
                                if(visitorresult1<>null && visitorresult1<>''){
                                    Map<String, Object> visitorjsonData1 = (Map<String, Object>)JSON.deserializeUntyped(visitorresult1);                                                                                  
                                    List<Object> visitordata = (List<Object>) visitorjsonData1.get('data');
                                    for (Object o : visitordata) {
                                        Map<String, Object> d = (Map<String, Object>) o;
                                        List<Object> values = (List<Object>) d.get('values');
                                        for (Object v : values) {
                                            for (Social_media_data__c md : sdvisitorList){
                                                Social_media_data__c smd = new Social_media_data__c();
                                                Map<String, Object> fbvalues = (Map<String, Object>) v;                              
                                                if(String.valueOf(fbvalues.get('value')) <> '()' && String.valueOf(fbvalues.get('value')) <> ''){
                                                    Map<String, Object> fbvalue = (Map<String, Object>) fbvalues.get('value');
                                                    if(fbvalue<>null){                            
                                                        if(fbvalue.containsKey('timeline')){
                                                            smd.Number_of_unik_visitor__c = Integer.valueOf((fbvalue.get('timeline')));
                                                        }else{
                                                            smd.Number_of_unik_visitor__c = 0;
                                                        }                            
                                                    }else{
                                                        smd.Number_of_unik_visitor__c = 0;
                                                    } 
                                                }else{
                                                    smd.Number_of_unik_visitor__c = 0;
                                                }                                                                                                      
                                                String fbendTime = String.valueOf((fbvalues.get('end_time')));                              
                                                List<String> enddate1 = fbendTime.split('T',-1);
                                                List<String> enddate2 = enddate1[0].split('-',-1);                        
                                                Date fbendDate = Date.newInstance(Integer.valueOf(enddate2[0]),Integer.valueOf(enddate2[1]),Integer.valueOf(enddate2[2]));                        
                                                smd.Date__c = fbendDate;//.addDays(-1);                            
                                                smd.Connection__c = ObjSMS.Id;
                                                smd.Name = ObjSMS.Name;// ObjSMS.Socialmedia__r.Socialmedia_type__c;                               
                                                smd.Id = md.Id;
                                                if(smd.Date__c == md.Date__c && smd.Connection__c == md.Connection__c){
                                                    smdvisitorList.add(smd); 
                                                }
                                            }
                                        }                       
                                    }                                                            
                                }
                                List<Social_media_data__c > sdfollowerList = [select Id, Name, Date__C, Connection__c from Social_media_data__c where Connection__c = :ObjSMS.Id];
                                List<Social_media_data__c> smdfollowerList = new List<Social_media_data__c>();
                                if(followerresult1<>null && followerresult1<>''){
                                    Map<String, Object> followerjsonData1 = (Map<String, Object>)JSON.deserializeUntyped(followerresult1);                                                                                  
                                    List<Object> followerdata = (List<Object>) followerjsonData1.get('data');
                                    for (Object o : followerdata) {
                                        Map<String, Object> d = (Map<String, Object>) o;
                                        List<Object> values = (List<Object>) d.get('values');
                                        for (Object v : values) {
                                            for (Social_media_data__c md : sdfollowerList){
                                                Social_media_data__c smd = new Social_media_data__c();
                                                Map<String, Object> value = (Map<String, Object>) v;                            
                                                smd.Number_of_member__c = Integer.valueOf((value.get('value')));    
                                                String fbendTime = String.valueOf((value.get('end_time')));                              
                                                List<String> enddate1 = fbendTime.split('T',-1);
                                                List<String> enddate2 = enddate1[0].split('-',-1);                        
                                                Date fbendDate = Date.newInstance(Integer.valueOf(enddate2[0]),Integer.valueOf(enddate2[1]),Integer.valueOf(enddate2[2]));                        
                                                smd.Date__c = fbendDate;//.addDays(-1);                            
                                                smd.Connection__c = ObjSMS.Id;
                                                smd.Name = ObjSMS.Name;// ObjSMS.Socialmedia__r.Socialmedia_type__c;                                     
                                                smd.Id = md.Id;
                                                if(smd.Date__c == md.Date__c && smd.Connection__c == md.Connection__c){
                                                    smdfollowerList.add(smd); 
                                                }
                                            }
                                        }                       
                                    }                                                            
                                }
                                
                                if(sdvisitorList<>null){
                                    if (Social_media_data__c.sObjectType.getDescribe().isUpdateable()){                 
                                        update (smdvisitorList);
                                    }
                                }
                                
                                if(sdfollowerList<>null){
                                    if (Social_media_data__c.sObjectType.getDescribe().isUpdateable()){                 
                                        update (smdfollowerList);
                                    }
                                }                        
                                //smMessage = 'import';  
                                if (Socialmedia_logfile__c.sObjectType.getDescribe().isCreateable()){
                                    Socialmedia_logfile__c sml = new Socialmedia_logfile__c();
                                    sml.Name = ObjSMS.Name;
                                    sml.Connection_id__c = ObjSMS.Id;
                                    sml.Import_message__c = 'Import data started';
                                    insert sml;            
                                    Socialmedia_logfile__c smlUpdate = new Socialmedia_logfile__c();  
                                    smlUpdate.Id = sml.Id;                
                                    smlUpdate.Import_message__c = 'Data from Facebook successfully imported'; 
                                    smlUpdate.musqot__Imported__c=true;             
                                    smlUpdate.Number_of_records__c = success ; 
                                    update (smlUpdate);   
                                }
                            }
                            else{
                                //smMessage = '';
                                if (Socialmedia_logfile__c.sObjectType.getDescribe().isCreateable()){
                                    Socialmedia_logfile__c sml = new Socialmedia_logfile__c();
                                    sml.Name = ObjSMS.Name;
                                    sml.Connection_id__c = ObjSMS.Id;
                                    sml.Import_message__c = 'Import data started';
                                    insert sml;            
                                    Socialmedia_logfile__c smlUpdate = new Socialmedia_logfile__c();  
                                    smlUpdate.Id = sml.Id;                
                                    smlUpdate.Import_message__c = 'Error in setting for this connection'; 
                                    smlUpdate.musqot__Imported__c=true;             
                                    smlUpdate.Number_of_records__c = success ; 
                                    update (smlUpdate);   
                                }
                            }
                        }
                    }catch(Exception e){
                        if (Socialmedia_logfile__c.sObjectType.getDescribe().isCreateable()){
                            Socialmedia_logfile__c sml = new Socialmedia_logfile__c();
                            sml.Name = ObjSMS.Name;
                            sml.Connection_id__c = ObjSMS.Id;
                            sml.Import_message__c = 'Import data started';
                            insert sml;
                            Socialmedia_logfile__c smlUpdate = new Socialmedia_logfile__c();  
                            smlUpdate.Id = sml.Id;
                            smlUpdate.Import_message__c = 'Error in import '+e.getMessage(); 
                            smlUpdate.musqot__Imported__c=false;             
                            smlUpdate.Number_of_records__c = 0; 
                            update (smlUpdate);
                        }
                    }
            	}
            } 
        }
    } 
    @future(callout=true)  
    public static void queryfacebookAdInsights(){
        List<OAuthService__c> cntList = new List<OAuthService__c>();
        try{            
            cntList = [select id, Name, Access_Token_URL__c, Authorization_Type__c, Authorization_URL__c,Page_Id__c,Post_ID__c,ad_ID__c,social_media__c,Socialmedia__c,Campaign_Id__c, Consumer_Key__c,
                       Bar_color__c,Consumer_Secret__c, Redirect_URL__c, Request_Token_URL__c, Response_Type__c, Scope__c, 
                      Signature_Method__c, Auto_import__c, End_Date__c 
                      from OAuthService__c  where Auto_import__c = :true];   
            
        }catch(exception e){} 
        try{
            List<CronJobDetail> cj = [select id, Name from CronJobDetail where Name Like :'scheduleFacebookAdInsightsJob_%'];
            List<CronTrigger> ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where CronJobDetailId IN :cj];
            for(CronTrigger c : ct){
            	system.abortJob(c.Id);   
            }            
        }catch(Exception e){}
        for(OAuthService__c ObjSMS : cntList){     
            if(ObjSMS.Social_media__c == 'Facebook'){                
              if(ObjSMS.end_date__c > System.today()) { 
                  try{                                                                                
                        if(ObjSMS.ad_id__c <> null && ObjSMS.Page_Id__c == null){
                            String SchTimer='0 0 0 1/1 * ? *';   
                            //Datetime sysTime = System.now().addSeconds( 60 );      
                            //String SchTimer = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
                            if(ObjSMS.Social_media__c == 'Facebook'){                                     
                                system.schedule('scheduleFacebookAdInsightsJob_'+ObjSMS.Id, SchTimer, new scheduleFacebookAdsInsights(ObjSMS.Id));
                            }
                        }                                                                                                         
                }catch(Exception e){
                    if (Socialmedia_logfile__c.sObjectType.getDescribe().isCreateable()){
                        Socialmedia_logfile__c sml = new Socialmedia_logfile__c();
                        sml.Name = ObjSMS.Name;
                        sml.Connection_id__c = ObjSMS.Id;
                        sml.Import_message__c = 'Import data started';
                        insert sml;
                        Socialmedia_logfile__c smlUpdate = new Socialmedia_logfile__c();  
                        smlUpdate.Id = sml.Id;
                        smlUpdate.Import_message__c = 'Error in import '+e.getMessage(); 
                        smlUpdate.musqot__Imported__c=false;             
                        smlUpdate.Number_of_records__c = 0; 
                        update (smlUpdate);
                    }
                }
              }
            } 
        }
    } 
    @future(callout=true)  
    public static void queryfacebookAdsInsights(String conId){
        List<OAuthService__c> cntList = new List<OAuthService__c>();
        try{            
            cntList = [select id, Name, Access_Token_URL__c, Authorization_Type__c, Authorization_URL__c,Page_Id__c,Post_ID__c,ad_ID__c,social_media__c,Socialmedia__c,Campaign_Id__c, Consumer_Key__c,
                       Bar_color__c,Consumer_Secret__c, Redirect_URL__c, Request_Token_URL__c, Response_Type__c, Scope__c, 
                      Signature_Method__c, Auto_import__c, End_Date__c 
                      from OAuthService__c  where Id = : conId and Auto_import__c = :true];   
            
        }catch(exception e){} 
        
        for(OAuthService__c ObjSMS : cntList){     
            if(ObjSMS.Social_media__c == 'Facebook'){                
              if(ObjSMS.end_date__c > System.today()) { 
                  try{                                                                                
                    if(ObjSMS.ad_id__c <> null && ObjSMS.Page_Id__c == null){
                        List<Social_media_data__c> smdList = new List<Social_media_data__c>();
                        Integer noofDays = 0;
                        Integer success = 0;
                        Date fbschedDate;
                        Integer i = 0;
                        String adReqURL;  
                        Date date_start;
                        Date date_stop;
                        String adId;                
                        HttpRequest adIdreq = new HttpRequest();     
                        adIdreq.setEndpoint('https://graph.facebook.com/v2.4/'+EncodingUtil.urlEncode(ObjSMS.ad_id__c,'UTF-8')+'?access_token='+ObjSMS.Access_Token_URL__c + '');
                        adIdreq.setMethod('GET');         
                        Http adIdhttp = new Http();
                        HTTPResponse adIdres = adIdhttp.send(adIdreq);      
                        String adIdresult = adIdres.getBody();           
                        if(adIdresult<>null && adIdresult<>''){
                            Map<String, Object> adIddata = (Map<String, Object>)JSON.deserializeUntyped(adIdresult);             
                            adId = String.valueOf(adIddata.get('id'));
                        }
                        if(adId == ObjSMS.ad_id__c){
                            adReqURL = 'https://graph.facebook.com/v2.4/'+EncodingUtil.urlEncode(ObjSMS.ad_id__c,'UTF-8')+'/insights?access_token='+ObjSMS.Access_Token_URL__c;               
                            HttpRequest adreq = new HttpRequest();                
                            adreq.setMethod('GET');           
                            adreq.setEndpoint(adReqURL);                
                            adreq.setTimeout(60*1000);                
                            HttpResponse adres = null;                
                            http adhttp= new Http();                           
                            try{
                                adres = adhttp.send(adreq) ;                
                            }catch(Exception e){
                                
                            }                
                            String adresult = adres.getBody();
                            
                            Map<String, Object> jsonadData = (Map<String, Object>)JSON.deserializeUntyped(adresult);                                                                                  
                            List<Object> data = (List<Object>) jsonadData.get('data');
                            for (Object o : data) {
                                Map<String, Object> d = (Map<String, Object>) o;
                                system.debug('start'+d);
                                system.debug('start'+d.get('date_start'));
                                system.debug('startst'+d.get('date_stop'));
                                String startdate = String.valueOf(d.get('date_start')); 
                                String stopdate = String.valueOf(d.get('date_stop')); 
                                date_start = Date.valueOf(startdate);
                                date_stop = Date.valueOf(stopdate);
                            }                                                        
                            noofDays = date_start.daysBetween(date_stop);       
                            system.debug('noofdays'+noofDays);                    
                            for (i = 0; i < noofDays; i++) {
                                system.debug('datetoday'+Date.today());
                                system.debug('datestartadd'+date_start.addDays(i));
                                if(date_start.addDays(i) == Date.today()){
                                    Social_media_data__c smd = new Social_media_data__c();
                                    String adReqURL2; 
                                    success = success + 1;
                                    String since = String.valueOf(date_start.addDays(i));
                                    system.debug('since'+since);                    
                                    adReqURL2 = 'https://graph.facebook.com/v2.4/'+EncodingUtil.urlEncode(ObjSMS.ad_id__c,'UTF-8')+'/insights?time_range={"since":"'+since+'","until":"'+since+'"}&access_token='+ObjSMS.Access_Token_URL__c;               
                                    system.debug('adrequesturl'+adReqURL2);
                                    HttpRequest adreq2 = new HttpRequest();                
                                    adreq2.setMethod('GET');           
                                    adreq2.setEndpoint(adReqURL2);                
                                    adreq2.setTimeout(60*1000);                
                                    HttpResponse adres2 = null;                
                                    http adhttp2= new Http();                           
                                    try{
                                        adres2 = adhttp2.send(adreq2) ;                
                                    }catch(Exception e){
                                        
                                    }                
                                    String adresult2 = adres2.getBody();
                                    
                                    Map<String, Object> jsonadData2 = (Map<String, Object>)JSON.deserializeUntyped(adresult2);                                                                                  
                                    List<Object> data2 = (List<Object>) jsonadData2.get('data');
                                    for (Object o : data2) {
                                        Map<String, Object> d = (Map<String, Object>) o;
                                        String startdate = String.valueOf(d.get('date_start'));   
                                        smd.Number_of_member__c = 0;
                                        smd.Date__c = Date.valueOf(startdate);
                                        fbschedDate = smd.Date__c;
                                        smd.Number_of_unik_visitor__c = Integer.valueOf(d.get('unique_impressions'));
                                        smd.Number_of_likes__c = Integer.valueOf(d.get('unique_clicks'));
                                    }                                                                                  
                                    smd.Connection__c = ObjSMS.Id;
                                    smd.Name = ObjSMS.Name;// ObjSMS.Socialmedia__r.Socialmedia_type__c;                                     
                                    smdList.add(smd); 
                                }
                            }
                            
                            List<Social_media_data__c > sdList = [select Id from Social_media_data__c where Connection__c = :ObjSMS.Id and Date__c = :fbschedDate];
                            if(sdList<>null){
                                if (Social_media_data__c.sObjectType.getDescribe().isDeletable()){                 
                                    delete (sdList);
                                }
                            }
                            if (Social_media_data__c.sObjectType.getDescribe().isCreateable()){                 
                                insert (smdList);                                
                            }
                            //smMessage = 'import';  
                            if (Socialmedia_logfile__c.sObjectType.getDescribe().isCreateable()){
                                Socialmedia_logfile__c sml = new Socialmedia_logfile__c();
                                sml.Name = ObjSMS.Name;
                                sml.Connection_id__c = ObjSMS.Id;
                                sml.Import_message__c = 'Import data started';
                                insert sml;            
                                Socialmedia_logfile__c smlUpdate = new Socialmedia_logfile__c();  
                                smlUpdate.Id = sml.Id;                
                                smlUpdate.Import_message__c = 'Data from Facebook Ad successfully imported'; 
                                smlUpdate.musqot__Imported__c=true;             
                                smlUpdate.Number_of_records__c = success ; 
                                update (smlUpdate);   
                            }
                        }else{
                            //smMessage = '';
                            if (Socialmedia_logfile__c.sObjectType.getDescribe().isCreateable()){
                                Socialmedia_logfile__c sml = new Socialmedia_logfile__c();
                                sml.Name = ObjSMS.Name;
                                sml.Connection_id__c = ObjSMS.Id;
                                sml.Import_message__c = 'Import data started';
                                insert sml;            
                                Socialmedia_logfile__c smlUpdate = new Socialmedia_logfile__c();  
                                smlUpdate.Id = sml.Id;                
                                smlUpdate.Import_message__c = 'Error in setting for this connection'; 
                                smlUpdate.musqot__Imported__c=true;             
                                smlUpdate.Number_of_records__c = success ; 
                                update (smlUpdate);   
                            }
                        }                
                    }                                                                                                         
                }catch(Exception e){
                    if (Socialmedia_logfile__c.sObjectType.getDescribe().isCreateable()){
                        Socialmedia_logfile__c sml = new Socialmedia_logfile__c();
                        sml.Name = ObjSMS.Name;
                        sml.Connection_id__c = ObjSMS.Id;
                        sml.Import_message__c = 'Import data started';
                        insert sml;
                        Socialmedia_logfile__c smlUpdate = new Socialmedia_logfile__c();  
                        smlUpdate.Id = sml.Id;
                        smlUpdate.Import_message__c = 'Error in import '+e.getMessage(); 
                        smlUpdate.musqot__Imported__c=false;             
                        smlUpdate.Number_of_records__c = 0; 
                        update (smlUpdate);
                    }
                	}
              }
            } 
        }
    } 
    @future(callout=true)  
    public static void queryfacebookPostInsights(){        
        try{                                   
        }catch(exception e){} 
    } 
     @future(callout=true)  
    public static void querymailchimpcampaignInsights(){
        List<OAuthService__c> cntList = new List<OAuthService__c>();
        try{            
            cntList = [select id, Name, Access_Token_URL__c, Authorization_Type__c, Authorization_URL__c,Page_Id__c,Post_ID__c,ad_ID__c,social_media__c,Socialmedia__c,Campaign_Id__c, Consumer_Key__c,
                       Bar_color__c,Consumer_Secret__c, Redirect_URL__c, Request_Token_URL__c, Response_Type__c, Scope__c, 
                      Signature_Method__c, Auto_import__c, End_Date__c 
                      from OAuthService__c  where Auto_import__c = :true];   
            
        }catch(exception e){} 
        
        for(OAuthService__c ObjSMS : cntList){     
            if(ObjSMS.Social_media__c == 'MailChimp'){                
              if(ObjSMS.end_date__c > System.today()) { 
                  try{
                    if(ObjSMS.Campaign_Id__c <> null){                        
                        List<Social_media_data__c> smdList = new List<Social_media_data__c>();
                        Integer success = 0;
                        Date fbschedDate = Date.today();
                        String mailchimpstatus;  
                        List<String> dcList = ObjSMS.Access_Token_URL__c.split('-');
                        String dc = String.valueOf(dcList[1]);
                        String statusReqURL = 'https://'+ dc +'.api.mailchimp.com/2.0/helper/verified-domains?apikey='+ ObjSMS.Access_Token_URL__c;
                        HttpRequest statusreq = new HttpRequest();     
                        statusreq.setEndpoint(statusReqURL);
                        statusreq.setMethod('GET');         
                        Http statushttp = new Http();
                        HTTPResponse statusres = statushttp.send(statusreq);      
                        String statusresult = statusres.getBody();           
                        if(statusresult<>null && statusresult<>''){                 
                            List<Object> data = (List<Object>)JSON.deserializeUntyped(statusresult);
                            for (Object o : data) {
                                Map<String, Object> d = (Map<String, Object>) o;                    
                                mailchimpstatus = String.valueOf(d.get('status')); 
                            }                            
                        }                                                                  
                        if(mailchimpstatus == 'verified'){                                
                            Date mcDate = Date.today();
                            //List<String> dcList = ObjSMS.Access_Token_URL__c.split('-');
                            //String dc = String.valueOf(dcList[1]);
                            String summaryReqURL = 'https://'+ dc +'.api.mailchimp.com/2.0/reports/summary?apikey='+ ObjSMS.Access_Token_URL__c +'&cid='+ ObjSMS.Campaign_Id__c;  
                            HttpRequest summaryreq = new HttpRequest();                
                            summaryreq.setMethod('GET');           
                            summaryreq.setEndpoint(summaryReqURL);                
                            summaryreq.setTimeout(60*1000);                
                            HttpResponse summaryres = null;                
                            http summaryh= new Http();                           
                            try{
                                summaryres = summaryh.send(summaryreq);                
                            }catch(Exception e){
                                
                            }                
                            String result1 = summaryres.getBody();
                            if(result1<>null && result1<>''){
                                Integer uniqueClikcs = 0;
                                Integer uniqueOpens = 0;
                                List<Social_media_data__c > sdmList = [select Id,Number_of_likes__c,Number_of_unik_visitor__c,Number_of_member__c from Social_media_data__c where Connection__c = :ObjSMS.Id];
                                for(Social_media_data__c sd : sdmList){
                                    uniqueClikcs += Integer.valueOf(sd.Number_of_likes__c);
                                    uniqueOpens += Integer.valueOf(sd.Number_of_unik_visitor__c);
                                }
                                Map<String, Object> jsonData1 = (Map<String, Object>)JSON.deserializeUntyped(result1);                                
                                Social_media_data__c smd = new Social_media_data__c();
                                success = success + 1;
                                smd.Number_of_member__c = 0;
                                smd.Number_of_likes__c = Math.abs(Integer.valueOf(jsonData1.get('unique_clicks')) - uniqueClikcs);
                                smd.Number_of_unik_visitor__c = Math.abs(Integer.valueOf(jsonData1.get('unique_opens')) - uniqueOpens);
                                smd.Date__c = mcDate;//.addDays(-1);                            
                                smd.Connection__c = ObjSMS.Id;
                                smd.Name = ObjSMS.Name;// ObjSMS.Socialmedia__r.Socialmedia_type__c;                                     
                                smdList.add(smd);                                                            
                            }
                            List<Social_media_data__c > sdList = [select Id from Social_media_data__c where Connection__c = :ObjSMS.Id and Date__c = :mcDate];
                            if(sdList.size() == 0){
                                if (Social_media_data__c.sObjectType.getDescribe().isCreateable()){                 
                                    insert (smdList);
                                }
                            }                       
                            //smMessage = 'import';  
                            if (Socialmedia_logfile__c.sObjectType.getDescribe().isCreateable()){
                                Socialmedia_logfile__c sml = new Socialmedia_logfile__c();
                                sml.Name = ObjSMS.Name;
                                sml.Connection_id__c = ObjSMS.Id;
                                sml.Import_message__c = 'Import data started';
                                insert sml;            
                                Socialmedia_logfile__c smlUpdate = new Socialmedia_logfile__c();  
                                smlUpdate.Id = sml.Id;                
                                smlUpdate.Import_message__c = 'Data from MailChimp successfully imported'; 
                                smlUpdate.musqot__Imported__c=true;             
                                smlUpdate.Number_of_records__c = success ; 
                                update (smlUpdate);   
                            }
                        }
                        else{
                            //smMessage = '';
                            if (Socialmedia_logfile__c.sObjectType.getDescribe().isCreateable()){
                                Socialmedia_logfile__c sml = new Socialmedia_logfile__c();
                                sml.Name = ObjSMS.Name;
                                sml.Connection_id__c = ObjSMS.Id;
                                sml.Import_message__c = 'Import data started';
                                insert sml;            
                                Socialmedia_logfile__c smlUpdate = new Socialmedia_logfile__c();  
                                smlUpdate.Id = sml.Id;                
                                smlUpdate.Import_message__c = 'Error in setting for this connection'; 
                                smlUpdate.musqot__Imported__c=true;             
                                smlUpdate.Number_of_records__c = success ; 
                                update (smlUpdate);   
                            }
                        }
                    }
                }catch(Exception e){
                    if (Socialmedia_logfile__c.sObjectType.getDescribe().isCreateable()){
                        Socialmedia_logfile__c sml = new Socialmedia_logfile__c();
                        sml.Name = ObjSMS.Name;
                        sml.Connection_id__c = ObjSMS.Id;
                        sml.Import_message__c = 'Import data started';
                        insert sml;
                        Socialmedia_logfile__c smlUpdate = new Socialmedia_logfile__c();  
                        smlUpdate.Id = sml.Id;
                        smlUpdate.Import_message__c = 'Error in import '+e.getMessage(); 
                        smlUpdate.musqot__Imported__c=false;             
                        smlUpdate.Number_of_records__c = 0; 
                        update (smlUpdate);
                    }
                } 
              }
            } 
        }
    }   
    @future(callout=true)  
    public static void querylinkedinPageInsights(){
        List<OAuthService__c> cntList = new List<OAuthService__c>();
        try{            
            cntList = [select id, Name, Access_Token_URL__c, Authorization_Type__c, Authorization_URL__c,Page_Id__c,Post_ID__c,ad_ID__c,social_media__c,Socialmedia__c,Campaign_Id__c, Consumer_Key__c,
                       Bar_color__c,Consumer_Secret__c, Redirect_URL__c, Request_Token_URL__c, Response_Type__c, Scope__c, 
                      Signature_Method__c, Auto_import__c, End_Date__c 
                      from OAuthService__c  where Auto_import__c = :true];   
            
        }catch(exception e){} 
        
        for(OAuthService__c ObjSMS : cntList){     
            if(ObjSMS.Social_media__c == 'LinkedIn'){                
               if(ObjSMS.end_date__c > System.today()) {  
                   try{
                    if(ObjSMS.Page_Id__c <> null){  
                        List<Social_media_data__c> smdList = new List<Social_media_data__c>();
                        Integer success = 0;
                        Date fbschedDate;
                        String appId;                
                        HttpRequest appIdreq = new HttpRequest();     
                        appIdreq.setEndpoint('https://api.linkedin.com/v1/companies/'+ ObjSMS.Page_Id__c +'?oauth2_access_token=' + ObjSMS.Access_Token_URL__c + '&format=json');
                        appIdreq.setMethod('GET');         
                        Http appIdhttp = new Http();
                        HTTPResponse appIdres = appIdhttp.send(appIdreq);      
                        String appIdresult = appIdres.getBody();           
                        if(appIdresult<>null && appIdresult<>''){
                            Map<String, Object> appIddata = (Map<String, Object>)JSON.deserializeUntyped(appIdresult);             
                            appId = String.valueOf(appIddata.get('id'));
                        }
                        if(appId == ObjSMS.Page_Id__c){                                             
                            String ReqURL;
                            String visitorReqURL;
                            String followerReqURL;
                            Date todayDate= Date.today().addDays(-1);
                            Date startDate;
                            startDate = todayDate.addDays(-1); 
                            system.debug('abc');
                            system.debug('todayDate '+todayDate);
                            system.debug('startDate '+startDate);
                            Date dateSince = Date.newInstance(startDate.year(), startDate.month(), startDate.day());
                            Time timeSince = Time.newInstance(0, 0, 0, 0);
                            DateTime dtSince = DateTime.newInstanceGmt(dateSince, timeSince);
                            Long lSince = dtSince.getTime();
                            Date dateUntil = Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day());
                            Time timeUntil = Time.newInstance(0,0,0,0);
                            DateTime dtUntil = DateTime.newInstanceGmt(dateUntil, timeUntil);
                            Long lUntil = dtUntil.getTime();
                            system.debug('lSince '+lSince);
                            system.debug('lUntil '+lUntil);
                            ReqURL = 'https://api.linkedin.com/v1/companies/'+EncodingUtil.urlEncode(ObjSMS.Page_Id__c,'UTF-8')+'/historical-status-update-statistics?oauth2_access_token='+ObjSMS.Access_Token_URL__c+'&time-granularity=day&start-timestamp='+lSince+'&end-timestamp='+lUntil+'&format=json';                
                            visitorReqURL = 'https://api.linkedin.com/v1/companies/'+EncodingUtil.urlEncode(ObjSMS.Page_Id__c,'UTF-8')+'/historical-status-update-statistics?oauth2_access_token='+ObjSMS.Access_Token_URL__c+'&time-granularity=day&start-timestamp='+lSince+'&end-timestamp='+lUntil+'&format=json';                
                            followerReqURL = 'https://api.linkedin.com/v1/companies/'+EncodingUtil.urlEncode(ObjSMS.Page_Id__c,'UTF-8')+'/historical-follow-statistics?oauth2_access_token='+ObjSMS.Access_Token_URL__c+'&time-granularity=day&start-timestamp='+lSince+'&end-timestamp='+lUntil+'&format=json';                
                            HttpRequest req1 = new HttpRequest();                
                            req1.setMethod('GET');           
                            req1.setEndpoint(ReqURL);                
                            req1.setTimeout(60*1000);                
                            HttpResponse res1 = null;                
                            http h1= new Http();                           
                            try{
                                res1 = h1.send(req1) ;                
                            }catch(Exception e){
                                
                            }                
                            String result1 = res1.getBody();
                            
                            HttpRequest visitorreq1 = new HttpRequest();                
                            visitorreq1.setMethod('GET');           
                            visitorreq1.setEndpoint(visitorReqURL);                
                            visitorreq1.setTimeout(60*1000);                
                            HttpResponse visitorres1 = null;                
                            http visitorh1= new Http();                           
                            try{
                                visitorres1 = visitorh1.send(visitorreq1) ;                
                            }catch(Exception e){
                                
                            }                
                            String visitorresult1 = visitorres1.getBody();
                            
                            HttpRequest followerreq1 = new HttpRequest();                
                            followerreq1.setMethod('GET');           
                            followerreq1.setEndpoint(followerReqURL);                
                            followerreq1.setTimeout(60*1000);                
                            HttpResponse followerres1 = null;                
                            http followerh1= new Http();                           
                            try{
                                followerres1 = followerh1.send(followerreq1) ;                
                            }catch(Exception e){
                                
                            }                
                            String followerresult1 = followerres1.getBody(); 
                            if(result1<>null && result1<>''){
                                Map<String, Object> jsonData1 = (Map<String, Object>)JSON.deserializeUntyped(result1);                                                                                  
                                List<Object> values = (List<Object>) jsonData1.get('values');
                                for (Object v : values) {
                                    success = success + 1;
                                    Social_media_data__c smd = new Social_media_data__c();
                                    Map<String, Object> value = (Map<String, Object>) v;                            
                                    smd.Number_of_likes__c = Integer.valueOf((value.get('impressionCount')));    
                                    Long endTime = Long.valueOf(String.valueOf(value.get('time')));  							
                                    DateTime endDate = DateTime.newInstance(endTime); 
                                    Date fbendDate = Date.valueOf(endDate);
                                    smd.Date__c = fbendDate;//.addDays(-1);  
                                    fbschedDate = smd.Date__c;
                                    smd.Connection__c = ObjSMS.Id;
                                    smd.Name = ObjSMS.Name;// ObjSMS.Socialmedia__r.Socialmedia_type__c;                                     
                                    smdList.add(smd);   
                                }                                                            
                            }  
                            List<Social_media_data__c > sdList = [select Id from Social_media_data__c where Connection__c = :ObjSMS.Id and Date__c = :fbschedDate];
                            if(sdList<>null){
                                if (Social_media_data__c.sObjectType.getDescribe().isDeletable()){                 
                                    delete (sdList);
                                }
                            }
                            if (Social_media_data__c.sObjectType.getDescribe().isCreateable()){                 
                                insert (smdList);
                            }   
                            List<Social_media_data__c > sdvisitorList = [select Id, Name, Date__C, Connection__c from Social_media_data__c where Connection__c = :ObjSMS.Id];
                            List<Social_media_data__c> smdvisitorList = new List<Social_media_data__c>();
                            if(visitorresult1<>null && visitorresult1<>''){
                                Map<String, Object> visitorjsonData1 = (Map<String, Object>)JSON.deserializeUntyped(visitorresult1);                                                                                  
                                List<Object> values = (List<Object>) visitorjsonData1.get('values');
                                for (Object v : values) {
                                    for (Social_media_data__c md : sdvisitorList){
                                        Social_media_data__c smd = new Social_media_data__c();
                                        Map<String, Object> value = (Map<String, Object>) v;                              
                                        smd.Number_of_unik_visitor__c = Integer.valueOf((value.get('impressionCount')));    
                                        Long endTime = Long.valueOf(String.valueOf(value.get('time')));                                   
                                        DateTime endDate = DateTime.newInstance(endTime);                                                                            
                                        Date fbendDate = Date.valueOf(endDate);
                                        smd.Date__c = fbendDate;//.addDays(-1);  
                                        smd.Connection__c = ObjSMS.Id;
                                        smd.Name = ObjSMS.Name;// ObjSMS.Socialmedia__r.Socialmedia_type__c;                               
                                        smd.Id = md.Id;
                                        if(smd.Date__c == md.Date__c && smd.Connection__c == md.Connection__c){
                                            smdvisitorList.add(smd); 
                                        }
                                    }
                                }                                                            
                            }
                            List<Social_media_data__c > sdfollowerList = [select Id, Name, Date__C, Connection__c from Social_media_data__c where Connection__c = :ObjSMS.Id];
                            List<Social_media_data__c> smdfollowerList = new List<Social_media_data__c>();
                            if(followerresult1<>null && followerresult1<>''){
                                Map<String, Object> followerjsonData1 = (Map<String, Object>)JSON.deserializeUntyped(followerresult1);                                                                                  
                                List<Object> values = (List<Object>) followerjsonData1.get('values');
                                for (Object v : values) {
                                    for (Social_media_data__c md : sdfollowerList){
                                        Social_media_data__c smd = new Social_media_data__c();
                                        Map<String, Object> value = (Map<String, Object>) v;                            
                                        smd.Number_of_member__c = Integer.valueOf((value.get('totalFollowerCount')));    
                                        Long endTime = Long.valueOf(String.valueOf(value.get('time')));  
                                        DateTime endDate = DateTime.newInstance(endTime);                                            
                                        Date fbendDate = Date.valueOf(endDate);
                                        smd.Date__c = fbendDate;//.addDays(-1); 
                                        smd.Connection__c = ObjSMS.Id;
                                        smd.Name = ObjSMS.Name;// ObjSMS.Socialmedia__r.Socialmedia_type__c;                                     
                                        smd.Id = md.Id;
                                        if(smd.Date__c == md.Date__c && smd.Connection__c == md.Connection__c){
                                            smdfollowerList.add(smd); 
                                        }
                                    }
                                }                                                            
                            }
                            
                            if(sdvisitorList<>null){
                                if (Social_media_data__c.sObjectType.getDescribe().isUpdateable()){                 
                                    update (smdvisitorList);
                                }
                            }
                            
                            if(sdfollowerList<>null){
                                if (Social_media_data__c.sObjectType.getDescribe().isUpdateable()){                 
                                    update (smdfollowerList);
                                }
                            }
                            
                            if (OAuthService__c.sObjectType.getDescribe().isUpdateable()){                 
                                update ObjSMS;
                            }                      
                            if (Socialmedia_logfile__c.sObjectType.getDescribe().isCreateable()){
                                Socialmedia_logfile__c sml = new Socialmedia_logfile__c();
                                sml.Name = ObjSMS.Name;
                                sml.Connection_id__c = ObjSMS.Id;
                                sml.Import_message__c = 'Import data started';
                                insert sml;            
                                Socialmedia_logfile__c smlUpdate = new Socialmedia_logfile__c();  
                                smlUpdate.Id = sml.Id;                
                                smlUpdate.Import_message__c = 'Data from Linkedin successfully'; 
                                smlUpdate.musqot__Imported__c=true;             
                                smlUpdate.Number_of_records__c = success ; 
                                update (smlUpdate);   
                            }
                        }
                        else{                    
                            if (Socialmedia_logfile__c.sObjectType.getDescribe().isCreateable()){
                                Socialmedia_logfile__c sml = new Socialmedia_logfile__c();
                                sml.Name = ObjSMS.Name;
                                sml.Connection_id__c = ObjSMS.Id;
                                sml.Import_message__c = 'Import data started';
                                insert sml;            
                                Socialmedia_logfile__c smlUpdate = new Socialmedia_logfile__c();  
                                smlUpdate.Id = sml.Id;                
                                smlUpdate.Import_message__c = 'Error in setting for this connection'; 
                                smlUpdate.musqot__Imported__c=true;             
                                smlUpdate.Number_of_records__c = success ; 
                                update (smlUpdate);   
                            }
                        }
                    }  
                }catch(Exception e){
                    if (Socialmedia_logfile__c.sObjectType.getDescribe().isCreateable()){
                        Socialmedia_logfile__c sml = new Socialmedia_logfile__c();
                        sml.Name = ObjSMS.Name;
                        sml.Connection_id__c = ObjSMS.Id;
                        sml.Import_message__c = 'Import data started';
                        insert sml;
                        Socialmedia_logfile__c smlUpdate = new Socialmedia_logfile__c();  
                        smlUpdate.Id = sml.Id;
                        smlUpdate.Import_message__c = 'Error in import '+e.getMessage(); 
                        smlUpdate.musqot__Imported__c=false;             
                        smlUpdate.Number_of_records__c = 0; 
                        update (smlUpdate);
                    }
                }  
               }
            } 
        }
    } 
    @future(callout=true)  
    public static void querylinkedinPostInsights(){
        List<OAuthService__c> cntList = new List<OAuthService__c>();
        try{            
            cntList = [select id, Name, Access_Token_URL__c, Authorization_Type__c, Authorization_URL__c,Page_Id__c,Post_ID__c,ad_ID__c,social_media__c,Socialmedia__c,Campaign_Id__c, Consumer_Key__c,
                       Bar_color__c,Consumer_Secret__c, Redirect_URL__c, Request_Token_URL__c, Response_Type__c, Scope__c, 
                      Signature_Method__c, Auto_import__c, End_Date__c 
                      from OAuthService__c  where Auto_import__c = :true];   
            
        }catch(exception e){} 
        
        for(OAuthService__c ObjSMS : cntList){     
            if(ObjSMS.Social_media__c == 'LinkedIn'){                
             if(ObjSMS.end_date__c > System.today()) { 
                 try{
                    if(ObjSMS.Page_Id__c <> null && ObjSMS.Post_ID__c <> null){  
                        List<Social_media_data__c> smdList = new List<Social_media_data__c>();
                        Integer success = 0;
                        Date fbschedDate;
                        String appId;                
                        HttpRequest appIdreq = new HttpRequest();     
                        appIdreq.setEndpoint('https://api.linkedin.com/v1/companies/'+EncodingUtil.urlEncode(ObjSMS.Page_Id__c,'UTF-8')+'/updates/key=UPDATE-c'+EncodingUtil.urlEncode(ObjSMS.Page_Id__c,'UTF-8')+'-'+EncodingUtil.urlEncode(ObjSMS.Post_ID__c,'UTF-8')+'?oauth2_access_token='+ObjSMS.Access_Token_URL__c+'&format=json');
                        appIdreq.setMethod('GET');         
                        Http appIdhttp = new Http();
                        HTTPResponse appIdres = appIdhttp.send(appIdreq);      
                        String appIdresult = appIdres.getBody();           
                        if(appIdresult<>null && appIdresult<>''){
                            Map<String, Object> appIddata = (Map<String, Object>)JSON.deserializeUntyped(appIdresult);             
                            appId = String.valueOf(appIddata.get('errorCode'));
                        }
                        if(appId != '0'){                                             
                            String ReqURL;
                            String visitorReqURL;
                            String followerReqURL;
                            Date todayDate= Date.today().addDays(-1);
                            Date startDate;
                            startDate = todayDate.addDays(-1); 
                            system.debug('abc');
                            system.debug('todayDate '+todayDate);
                            system.debug('startDate '+startDate);
                            Date dateSince = Date.newInstance(startDate.year(), startDate.month(), startDate.day());
                            Time timeSince = Time.newInstance(0, 0, 0, 0);
                            DateTime dtSince = DateTime.newInstanceGmt(dateSince, timeSince);
                            Long lSince = dtSince.getTime();
                            Date dateUntil = Date.newInstance(todayDate.year(), todayDate.month(), todayDate.day());
                            Time timeUntil = Time.newInstance(0,0,0,0);
                            DateTime dtUntil = DateTime.newInstanceGmt(dateUntil, timeUntil);
                            Long lUntil = dtUntil.getTime();
                            system.debug('lSince '+lSince);
                            system.debug('lUntil '+lUntil);
                            ReqURL = 'https://api.linkedin.com/v1/companies/'+EncodingUtil.urlEncode(ObjSMS.Page_Id__c,'UTF-8')+'/updates/key=UPDATE-c'+EncodingUtil.urlEncode(ObjSMS.Page_Id__c,'UTF-8')+'-'+EncodingUtil.urlEncode(ObjSMS.Post_ID__c,'UTF-8')+'/likes?oauth2_access_token='+ObjSMS.Access_Token_URL__c+'&format=json';                
                            visitorReqURL = 'https://api.linkedin.com/v1/companies/'+EncodingUtil.urlEncode(ObjSMS.Page_Id__c,'UTF-8')+'/historical-status-update-statistics?oauth2_access_token='+ObjSMS.Access_Token_URL__c+'&time-granularity=day&start-timestamp='+lSince+'&end-timestamp='+lUntil+'&update-key=UPDATE-c'+EncodingUtil.urlEncode(ObjSMS.Page_Id__c,'UTF-8')+'-'+EncodingUtil.urlEncode(ObjSMS.Post_ID__c,'UTF-8')+'&format=json';                
                            followerReqURL = 'https://api.linkedin.com/v1/companies/'+EncodingUtil.urlEncode(ObjSMS.Page_Id__c,'UTF-8')+'/historical-follow-statistics?oauth2_access_token='+ObjSMS.Access_Token_URL__c+'&time-granularity=day&start-timestamp='+lSince+'&end-timestamp='+lUntil+'&format=json';                
                            HttpRequest req1 = new HttpRequest();                
                            req1.setMethod('GET');           
                            req1.setEndpoint(ReqURL);                
                            req1.setTimeout(60*1000);                
                            HttpResponse res1 = null;                
                            http h1= new Http();                           
                            try{
                                res1 = h1.send(req1) ;                
                            }catch(Exception e){
                                
                            }                
                            String result1 = res1.getBody();
                            
                            HttpRequest visitorreq1 = new HttpRequest();                
                            visitorreq1.setMethod('GET');           
                            visitorreq1.setEndpoint(visitorReqURL);                
                            visitorreq1.setTimeout(60*1000);                
                            HttpResponse visitorres1 = null;                
                            http visitorh1= new Http();                           
                            try{
                                visitorres1 = visitorh1.send(visitorreq1) ;                
                            }catch(Exception e){
                                
                            }                
                            String visitorresult1 = visitorres1.getBody();
                            
                            HttpRequest followerreq1 = new HttpRequest();                
                            followerreq1.setMethod('GET');           
                            followerreq1.setEndpoint(followerReqURL);                
                            followerreq1.setTimeout(60*1000);                
                            HttpResponse followerres1 = null;                
                            http followerh1= new Http();                           
                            try{
                                followerres1 = followerh1.send(followerreq1) ;                
                            }catch(Exception e){
                                
                            }                
                            String followerresult1 = followerres1.getBody(); 
                            if(result1<>null && result1<>''){
                                Map<String, Object> jsonData1 = (Map<String, Object>)JSON.deserializeUntyped(result1);                                                                                  
                                List<Object> values = (List<Object>) jsonData1.get('values');
                                for (Object v : values) {
                                    success = success + 1;
                                    Social_media_data__c smd = new Social_media_data__c();
                                    Map<String, Object> value = (Map<String, Object>) v;                            
                                    smd.Number_of_likes__c = 1;    
                                    Long endTime = Long.valueOf(String.valueOf(value.get('timestamp')));  							
                                    DateTime endDate = DateTime.newInstance(endTime); 
                                    Date fbendDate = Date.valueOf(endDate);
                                    smd.Date__c = fbendDate;//.addDays(-1);  
                                    fbschedDate = smd.Date__c;
                                    smd.Connection__c = ObjSMS.Id;
                                    smd.Name = ObjSMS.Name;// ObjSMS.Socialmedia__r.Socialmedia_type__c;                                     
                                    smdList.add(smd);   
                                }                                                            
                            }  
                            List<Social_media_data__c > sdList = [select Id from Social_media_data__c where Connection__c = :ObjSMS.Id and Date__c = :fbschedDate];
                            if(sdList<>null){
                                if (Social_media_data__c.sObjectType.getDescribe().isDeletable()){                 
                                    delete (sdList);
                                }
                            }
                            if (Social_media_data__c.sObjectType.getDescribe().isCreateable()){                 
                                insert (smdList);
                            }   
                            List<Social_media_data__c > sdvisitorList = [select Id, Name, Date__C, Connection__c from Social_media_data__c where Connection__c = :ObjSMS.Id];
                            List<Social_media_data__c> smdvisitorList = new List<Social_media_data__c>();
                            if(visitorresult1<>null && visitorresult1<>''){
                                Map<String, Object> visitorjsonData1 = (Map<String, Object>)JSON.deserializeUntyped(visitorresult1);                                                                                  
                                List<Object> values = (List<Object>) visitorjsonData1.get('values');
                                for (Object v : values) {
                                    for (Social_media_data__c md : sdvisitorList){
                                        Social_media_data__c smd = new Social_media_data__c();
                                        Map<String, Object> value = (Map<String, Object>) v;                              
                                        smd.Number_of_unik_visitor__c = Integer.valueOf((value.get('impressionCount')));    
                                        Long endTime = Long.valueOf(String.valueOf(value.get('time')));                                   
                                        DateTime endDate = DateTime.newInstance(endTime);                                                                            
                                        Date fbendDate = Date.valueOf(endDate);
                                        smd.Date__c = fbendDate;//.addDays(-1);  
                                        smd.Connection__c = ObjSMS.Id;
                                        smd.Name = ObjSMS.Name;// ObjSMS.Socialmedia__r.Socialmedia_type__c;                               
                                        smd.Id = md.Id;
                                        if(smd.Date__c == md.Date__c && smd.Connection__c == md.Connection__c){
                                            smdvisitorList.add(smd); 
                                        }
                                    }
                                }                                                            
                            }
                            List<Social_media_data__c > sdfollowerList = [select Id, Name, Date__C, Connection__c from Social_media_data__c where Connection__c = :ObjSMS.Id];
                            List<Social_media_data__c> smdfollowerList = new List<Social_media_data__c>();
                            if(followerresult1<>null && followerresult1<>''){
                                Map<String, Object> followerjsonData1 = (Map<String, Object>)JSON.deserializeUntyped(followerresult1);                                                                                  
                                List<Object> values = (List<Object>) followerjsonData1.get('values');
                                for (Object v : values) {
                                    for (Social_media_data__c md : sdfollowerList){
                                        Social_media_data__c smd = new Social_media_data__c();
                                        Map<String, Object> value = (Map<String, Object>) v;                            
                                        smd.Number_of_member__c = Integer.valueOf((value.get('totalFollowerCount')));    
                                        Long endTime = Long.valueOf(String.valueOf(value.get('time')));  
                                        DateTime endDate = DateTime.newInstance(endTime);                                            
                                        Date fbendDate = Date.valueOf(endDate);
                                        smd.Date__c = fbendDate;//.addDays(-1); 
                                        smd.Connection__c = ObjSMS.Id;
                                        smd.Name = ObjSMS.Name;// ObjSMS.Socialmedia__r.Socialmedia_type__c;                                     
                                        smd.Id = md.Id;
                                        if(smd.Date__c == md.Date__c && smd.Connection__c == md.Connection__c){
                                            smdfollowerList.add(smd); 
                                        }
                                    }
                                }                                                            
                            }
                            
                            if(sdvisitorList<>null){
                                if (Social_media_data__c.sObjectType.getDescribe().isUpdateable()){                 
                                    update (smdvisitorList);
                                }
                            }
                            
                            if(sdfollowerList<>null){
                                if (Social_media_data__c.sObjectType.getDescribe().isUpdateable()){                 
                                    update (smdfollowerList);
                                }
                            }
                            
                            if (OAuthService__c.sObjectType.getDescribe().isUpdateable()){                 
                                update ObjSMS;
                            }                      
                            if (Socialmedia_logfile__c.sObjectType.getDescribe().isCreateable()){
                                Socialmedia_logfile__c sml = new Socialmedia_logfile__c();
                                sml.Name = ObjSMS.Name;
                                sml.Connection_id__c = ObjSMS.Id;
                                sml.Import_message__c = 'Import data started';
                                insert sml;            
                                Socialmedia_logfile__c smlUpdate = new Socialmedia_logfile__c();  
                                smlUpdate.Id = sml.Id;                
                                smlUpdate.Import_message__c = 'Data from Linkedin updates successfully'; 
                                smlUpdate.musqot__Imported__c=true;             
                                smlUpdate.Number_of_records__c = success ; 
                                update (smlUpdate);   
                            }
                        }
                        else{                    
                            if (Socialmedia_logfile__c.sObjectType.getDescribe().isCreateable()){
                                Socialmedia_logfile__c sml = new Socialmedia_logfile__c();
                                sml.Name = ObjSMS.Name;
                                sml.Connection_id__c = ObjSMS.Id;
                                sml.Import_message__c = 'Import data started';
                                insert sml;            
                                Socialmedia_logfile__c smlUpdate = new Socialmedia_logfile__c();  
                                smlUpdate.Id = sml.Id;                
                                smlUpdate.Import_message__c = 'Error in setting for this connection'; 
                                smlUpdate.musqot__Imported__c=true;             
                                smlUpdate.Number_of_records__c = success ; 
                                update (smlUpdate);   
                            }
                        }
                    }  
                }catch(Exception e){
                    if (Socialmedia_logfile__c.sObjectType.getDescribe().isCreateable()){
                        Socialmedia_logfile__c sml = new Socialmedia_logfile__c();
                        sml.Name = ObjSMS.Name;
                        sml.Connection_id__c = ObjSMS.Id;
                        sml.Import_message__c = 'Import data started';
                        insert sml;
                        Socialmedia_logfile__c smlUpdate = new Socialmedia_logfile__c();  
                        smlUpdate.Id = sml.Id;
                        smlUpdate.Import_message__c = 'Error in import '+e.getMessage(); 
                        smlUpdate.musqot__Imported__c=false;             
                        smlUpdate.Number_of_records__c = 0; 
                        update (smlUpdate);
                    }
                }
             }
            } 
        }
    } 
}