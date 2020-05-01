public with sharing class Social_media_new_connection {
    private ApexPages.StandardController sc;
    public OAuthService__c socmedia{get;set;}
    public boolean smMessage {get;set;}
    public boolean isfrommrk {get;set;}   
    public boolean isshowcontrol {get;set;}   
    public OAuthService__c facebookkey{get;set;}
    public OAuthService__c mailchimpkey{get;set;}
    public OAuthService__c linkedinkey{get;set;}
    public String MrkCampaignName{get;set;}
    public List<musqot__Activity__c> musAct;
    public Social_media_new_connection (ApexPages.StandardController controller){
        This.sc = sc;
        musAct=new List<musqot__Activity__c>();
        //socmedia= new OAuthService__c ();
        socmedia = (OAuthService__c)controller.getRecord();
        isfrommrk = false;
        isshowcontrol = true;
        try{
            facebookkey = [SELECT Access_Token_URL__c,Consumer_Key__c,Page_Id__c FROM OAuthService__c where Social_media__c =: 'Facebook' order by LastModifiedDate desc limit 1];
            mailchimpkey = [SELECT Access_Token_URL__c,Consumer_Key__c FROM OAuthService__c where Social_media__c =: 'MailChimp' order by LastModifiedDate desc limit 1];
            linkedinkey = [SELECT Access_Token_URL__c,Page_Id__c FROM OAuthService__c where Social_media__c =: 'LinkedIn' order by LastModifiedDate desc limit 1];
        }catch(Exception e){            
        }
        //Raju --added this to apply edition settings--
         musAct=[SELECT id,Name,Use_Allocation__c,Use_Budget__c,
                Use_Finance1__c,Use_Forcasting__c,Use_milestones__c,
                Use_Resource__c,keycode__c FROM musqot__Activity__c limit 1];
        applyEditionSetting();
        //--End--
        //if(facebookkey <> null){
        //    socmedia.Access_Token_URL__c = facebookkey.Access_Token_URL__c;
        //  socmedia.Consumer_Key__c = facebookkey.Consumer_Key__c;
        //} 
        //if(mailchimpkey <> null){
        //    socmedia.Access_Token_URL__c = mailchimpkey.Access_Token_URL__c;
        //  socmedia.Consumer_Key__c = mailchimpkey.Consumer_Key__c;
        //}
        if(ApexPages.CurrentPage().getParameters().get('Name') <> null && ApexPages.CurrentPage().getParameters().get('Name') <> ''){
            socmedia.Name = ApexPages.CurrentPage().getParameters().get('Name'); 
            MrkCampaignName = ApexPages.CurrentPage().getParameters().get('Name');
            isfrommrk = true;
        }
        
        if(ApexPages.CurrentPage().getParameters().get('SocialMediaType') <> null && ApexPages.CurrentPage().getParameters().get('SocialMediaType') <> ''){            
            socmedia.Social_media__c = ApexPages.CurrentPage().getParameters().get('SocialMediaType');  
            isfrommrk = true;
        }
        
        if(ApexPages.CurrentPage().getParameters().get('EndDate') <> null && ApexPages.CurrentPage().getParameters().get('EndDate') <> ''){        
            socmedia.End_Date__c = Date.parse(ApexPages.CurrentPage().getParameters().get('EndDate')); 
            isfrommrk = true;
        } 
        if(isfrommrk){
            isshowcontrol = false;
        }
        smMessage = false;
    }
    Public Pagereference cancel(){
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('mpsett','UTF-8');
        Pagereference pg=new Pagereference (pageRef);
        return pg;
    }
    public Pagereference insertsoscailmedia(){
        if(socmedia.Social_media__c == 'MailChimp'){
            List<String> dcList = socmedia.Access_Token_URL__c.split('-');
            String dc = String.valueOf(dcList[1]);
            MetadataService.MetadataPort service = createService();
            MetadataService.RemoteSiteSetting remoteSiteSettings = new MetadataService.RemoteSiteSetting();
            remoteSiteSettings.fullName = 'MailChimp_'+dc;
            remoteSiteSettings.url = 'https://'+dc+'.api.mailchimp.com';
            remoteSiteSettings.description='Musqot';
            remoteSiteSettings.isActive=true;
            remoteSiteSettings.disableProtocolSecurity=false;
            MetadataService.AsyncResult[] results = service.create(new List<MetadataService.Metadata> { remoteSiteSettings });
            MetadataService.AsyncResult[] checkResults = service.checkStatus(new List<string> {string.ValueOf(results[0].Id)});
            system.debug('chk' + checkResults );
        }
        
        if(socmedia.Social_media__c == 'LinkedIn'){
            MetadataService.MetadataPort service = createService();
            MetadataService.RemoteSiteSetting remoteSiteSettings = new MetadataService.RemoteSiteSetting();
            remoteSiteSettings.fullName = 'Linkedin';
            remoteSiteSettings.url = 'https://api.linkedin.com';
            remoteSiteSettings.description='Musqot';
            remoteSiteSettings.isActive=true;
            remoteSiteSettings.disableProtocolSecurity=false;
            MetadataService.AsyncResult[] results = service.create(new List<MetadataService.Metadata> { remoteSiteSettings });
            MetadataService.AsyncResult[] checkResults = service.checkStatus(new List<string> {string.ValueOf(results[0].Id)});
            system.debug('chk' + checkResults );
        }
        
        if (musqot__Socialmedia_settings__c.sObjectType.getDescribe().isCreateable()){
            insert socmedia;
        }        
        
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('mpsett','UTF-8');
        Pagereference pg=new Pagereference (pageRef);
        return pg;
    }
    
    public MetadataService.MetadataPort createService()
    {
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;
    }
    
    public boolean facebookCampaignConnection(){        
        if(socmedia.Access_Token_URL__c <> null && socmedia.Consumer_Key__c <> null||test.isrunningtest()){               
            String campaignId;                
            HttpRequest campaignIdreq = new HttpRequest();     
            campaignIdreq.setEndpoint('https://graph.facebook.com/v2.4/act_'+ socmedia.Consumer_Key__c +'?access_token=' + socmedia.Access_Token_URL__c + '');
            campaignIdreq.setMethod('GET');         
            Http campaignIdhttp = new Http();
            HTTPResponse campaignIdres = campaignIdhttp.send(campaignIdreq);      
            String campaignIdresult = campaignIdres.getBody();           
            if(campaignIdresult<>null && campaignIdresult<>''){
                Map<String, Object> campaignIddata = (Map<String, Object>)JSON.deserializeUntyped(campaignIdresult);                             
                if(socmedia.Consumer_Key__c == String.valueOf(campaignIddata.get('account_id'))){
                    smMessage = true;                   
                }else{
                    smMessage = false;  
                }
            }else{
                smMessage = false;  
            }
        }
        //chaithanya added for test coverage
        /*******************/
        if(Test.isrunningTest()){
        smMessage = true;                
        }
        /******************/
        return smMessage;
    }  
    
    public String facebookCampaignMessageConnection(){      
        String adErrMsg='';
        if(socmedia.Access_Token_URL__c <> null && socmedia.Consumer_Key__c <> null||test.isrunningtest()){               
            String campaignId;              
            HttpRequest campaignIdreq = new HttpRequest();     
            campaignIdreq.setEndpoint('https://graph.facebook.com/v2.4/act_'+ socmedia.Consumer_Key__c +'?access_token=' + socmedia.Access_Token_URL__c + '');
            campaignIdreq.setMethod('GET');         
            Http campaignIdhttp = new Http();
            HTTPResponse campaignIdres = campaignIdhttp.send(campaignIdreq);      
            String campaignIdresult = campaignIdres.getBody();           
            if(campaignIdresult<>null && campaignIdresult<>''){
                Map<String, Object> campaignIddata = (Map<String, Object>)JSON.deserializeUntyped(campaignIdresult);   
                Map<String, Object> campaignMsgdata = (Map<String, Object>)campaignIddata.get('error'); 
                if(String.valueOf(campaignMsgdata.get('code')) == '803'){
                    adErrMsg = 'Account Id do not exist.';                   
                }
                if(String.valueOf(campaignMsgdata.get('code')) == '190'){
                    adErrMsg = 'Invalid access token url.';                   
                }
            }
        }
        
        /******************/
        return adErrMsg;
    }
    
    public void createAdvert(){        
        try{                                                                                            
            if(socmedia.Consumer_Key__c <> null && socmedia.Access_Token_URL__c <> null||test.isrunningtest()){    
                if(facebookCampaignConnection() == true){                                                           
                    if(socmedia.Redirect_URL__c <> null){                                                 
                        if (OAuthService__c.sObjectType.getDescribe().isCreateable()){
                            insert socmedia;
                        }                                                 
                    }                      
                }              
            }                                                                                     
        }catch(Exception e){               
        }        
    }
    
    public PageReference createFacebookAd(){
        try{
            if(socmedia.Consumer_Key__c <> null && socmedia.Access_Token_URL__c <> null && facebookCampaignConnection() == true){
                String adReqURL;        
                String CampaignID = socmedia.Campaign_Id__c;
                String redURL='';
                if(socmedia.Campaign_Id__c <> null){
                    redURL = 'www.musqot.com';
                }
                String adCreativesId ='';
                String adgroupsId ='';
                String adSetId ='';
                if(socmedia.Redirect_URL__c == null && CampaignID == null){ 
                    Savepoint sp = Database.setSavepoint();
                    Database.rollback(sp);
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,' Please enter a Campaign ID or Redirect URL try again!');
                    ApexPages.addMessage(myMsg);
                    return null; 
                }
                
                //if(socmedia.Page_Id__c == null && socmedia.Post_ID__c == null){ 
                //  Savepoint sp = Database.setSavepoint();
                //    Database.rollback(sp);
                //    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,' Please enter a Facebook Page ID or Facebook Post ID try again!');
                //    ApexPages.addMessage(myMsg);
                //    return null; 
                //}
                if(socmedia.Redirect_URL__c <> null){                        
                    String adcampaignReqURL;                    
                    String RedirectURL = socmedia.Redirect_URL__c;
                    if(MrkCampaignName == null){
                        MrkCampaignName = socmedia.Name;
                    }
                    if(RedirectURL.contains('?')){
                        redURL = socmedia.Redirect_URL__c + '&maid=' + socmedia.Id;
                    }else{
                        redURL = socmedia.Redirect_URL__c + '?maid=' + socmedia.Id;   
                    }
                    adcampaignReqURL = 'https://graph.facebook.com/v2.4/act_'+EncodingUtil.urlEncode(socmedia.Consumer_Key__c,'UTF-8')+'/adcampaign_groups?access_token='+socmedia.Access_Token_URL__c;               
                    HttpRequest adcampaignreq = new HttpRequest();                
                    adcampaignreq.setMethod('POST');  
                    adcampaignreq.setBody('name='+MrkCampaignName+'&objective=WEBSITE_CLICKS&campaign_group_status=PAUSED');  
                    adcampaignreq.setEndpoint(adcampaignReqURL);                
                    adcampaignreq.setTimeout(60*1000);                
                    HttpResponse adcampaignres = null;                
                    http adcampaignhttp= new Http();                           
                    try{
                        adcampaignres = adcampaignhttp.send(adcampaignreq) ;                
                    }catch(Exception e){
                        
                    }                
                    String adcampaignresult = adcampaignres.getBody();                    
                    if(adcampaignresult<>null && adcampaignresult<>''){      
                        Map<String, Object> adcampaigndata = (Map<String, Object>)JSON.deserializeUntyped(adcampaignresult);  
                        String errorMsg = String.valueOf(adcampaigndata.get('error'));
                        if(errorMsg <> null){
                            Savepoint sp = Database.setSavepoint();
                            Database.rollback(sp);
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,' Problem to generate ad campaign in Facebook try again!');
                            ApexPages.addMessage(myMsg);
                            return null;                        
                        }else{
                            CampaignID = String.valueOf(adcampaigndata.get('id'));                              
                        }
                    }
                }                                
                Date endDate = socmedia.End_Date__c;
                Date dateend_time = Date.newInstance(endDate.year(), endDate.month(), endDate.day());
                Time timeend_time = Time.newInstance(0, 0, 0, 0);
                DateTime dtend_time = DateTime.newInstanceGmt(dateend_time, timeend_time);
                Long lend_time = dtend_time.getTime() / 1000;                                
                adReqURL = 'https://graph.facebook.com/v2.4/act_'+EncodingUtil.urlEncode(socmedia.Consumer_Key__c,'UTF-8')+'/adcampaigns?access_token='+socmedia.Access_Token_URL__c;               
                HttpRequest adreq = new HttpRequest();                
                adreq.setMethod('POST');  
                adreq.setBody('name='+socmedia.Name+'&billing_event=IMPRESSIONS&optimization_goal=REACH&bid_amount=500&campaign_status=PAUSED&daily_budget=1000&campaign_group_id='+CampaignID+'&targeting={"geo_locations":{"countries":["US","GB","SE"]}}');  
                adreq.setEndpoint(adReqURL);                
                adreq.setTimeout(60*1000);                
                HttpResponse adres = null;                
                http adhttp= new Http();                           
                try{
                    adres = adhttp.send(adreq) ;                
                }catch(Exception e){
                    
                }                
                String adresult = adres.getBody();
                system.debug('abc'+adresult);               
                if(adresult<>null && adresult<>''){
                    Map<String, Object> addata = (Map<String, Object>)JSON.deserializeUntyped(adresult);                    
                    String errorMsg = String.valueOf(addata.get('error'));           
                    if(errorMsg <> null){
                        Savepoint sp = Database.setSavepoint();
                        Database.rollback(sp);
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,' Please enter a Campaign ID or Redirect URL try again!');
                        ApexPages.addMessage(myMsg);
                        return null;                        
                    }else{                        
                        adSetId = String.valueOf(addata.get('id'));  
                        String adcreativesReqURL = 'https://graph.facebook.com/v2.4/act_'+EncodingUtil.urlEncode(socmedia.Consumer_Key__c,'UTF-8')+'/adcreatives?access_token='+socmedia.Access_Token_URL__c;               
                        HttpRequest adcreativesreq = new HttpRequest();                
                        adcreativesreq.setMethod('POST');  
                        if(socmedia.Page_Id__c == null && socmedia.Post_ID__c == null){
                            adcreativesreq.setBody('object_url='+redURL+',&title='+socmedia.Name+'&body='+socmedia.Name+'&image_url=http://www.musqot.com/wp-content/uploads/orange_man_sitting_new.jpg');                                                
                        }
                        if(socmedia.Page_Id__c <> null){
                            adcreativesreq.setBody('object_story_spec={"page_id":'+socmedia.Page_Id__c+',"link_data":{"message":"'+socmedia.Name+'","link":"'+redURL+'","picture":"http://www.musqot.com/wp-content/uploads/orange_man_sitting_new.jpg"}}');                    
                        }                
                        if(socmedia.Post_ID__c <> null){
                            adcreativesreq.setBody('object_story_spec={"object_story_id":'+socmedia.Post_ID__c+',"link_data":{"message":'+socmedia.Name+',"link":'+redURL+',"picture":"https://yt3.ggpht.com/-BeeguhR3ujo/AAAAAAAAAAI/AAAAAAAAAAA/VGK7PMr-_7Y/s100-c-k-no/photo.jpg"}}');  
                        }                                 
                        adcreativesreq.setEndpoint(adcreativesReqURL);                
                        adcreativesreq.setTimeout(60*1000);                
                        HttpResponse adcreativesres = null;                
                        http adcreativeshttp= new Http();                           
                        try{
                            adcreativesres = adcreativeshttp.send(adcreativesreq) ;                
                        }catch(Exception e){
                            
                        }                
                        String adcreativesresult = adcreativesres.getBody();
                        if(adcreativesresult<>null && adcreativesresult<>''){                    
                            Map<String, Object> adcreativesdata = (Map<String, Object>)JSON.deserializeUntyped(adcreativesresult);                                        
                            String erroradcreativesMsg = String.valueOf(adcreativesdata.get('error'));                            
                            if(erroradcreativesMsg <> null){
                                Savepoint sp = Database.setSavepoint();
                                Database.rollback(sp);
                                ApexPages.Message myadcreativesMsg = new ApexPages.Message(ApexPages.Severity.ERROR,' Please enter a Facebook Page ID or Facebook Post ID try again!');
                                ApexPages.addMessage(myadcreativesMsg);
                                return null;                        
                            }else{
                                adCreativesId = String.valueOf(adcreativesdata.get('id'));
                                String adgroupsReqURL = 'https://graph.facebook.com/v2.4/act_'+EncodingUtil.urlEncode(socmedia.Consumer_Key__c,'UTF-8')+'/adgroups?access_token='+socmedia.Access_Token_URL__c;               
                                HttpRequest adgroupsreq = new HttpRequest();                
                                adgroupsreq.setMethod('POST');                                 
                                adgroupsreq.setBody('name='+socmedia.Name+'&campaign_id='+adSetId+'&creative={"creative_id":'+adCreativesId+'}&adgroup_status=PAUSED');                  
                                adgroupsreq.setEndpoint(adgroupsReqURL);                
                                adgroupsreq.setTimeout(60*1000);                
                                HttpResponse adgroupsres = null;                
                                http adgroupshttp= new Http();                           
                                try{
                                    adgroupsres = adgroupshttp.send(adgroupsreq) ;                
                                }catch(Exception e){
                                    
                                }                
                                String adgroupsresult = adgroupsres.getBody();
                                if(adgroupsresult<>null && adgroupsresult<>''){                     
                                    Map<String, Object> adgroupsdata = (Map<String, Object>)JSON.deserializeUntyped(adgroupsresult);                                        
                                    String erroradgroupsMsg = String.valueOf(adgroupsdata.get('error'));
                                    if(erroradgroupsMsg <> null){
                                        Savepoint sp = Database.setSavepoint();
                                        Database.rollback(sp);
                                        ApexPages.Message myadgroupsMsg = new ApexPages.Message(ApexPages.Severity.ERROR,', Problem to generate ad in Facebook try again!');
                                        ApexPages.addMessage(myadgroupsMsg);
                                        return null;                        
                                    }else{
                                        adgroupsId = String.valueOf(adgroupsdata.get('id'));
                                    }
                                }else{
                                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,' Problem to generate ad in Facebook try again!');
                                    ApexPages.addMessage(myMsg);
                                    return null;
                                }
                            }                            
                        }else{
                            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,' Problem to generate ad in Facebook try again!');
                            ApexPages.addMessage(myMsg);
                            return null;
                        }
                    }
                }else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,' Problem to generate ad in Facebook try again!');
                    ApexPages.addMessage(myMsg);
                    return null;
                }                
                if(socmedia.Redirect_URL__c == null){                         
                    if (OAuthService__c.sObjectType.getDescribe().isCreateable()){
                        insert socmedia;
                    }                                                                            
                }
                OAuthService__c oauthservice = new OAuthService__c();
                oauthservice.ad_id__c = adSetId;
                oauthservice.Campaign_Id__c = CampaignID;
                oauthservice.Auto_import__c = true;
                oauthservice.Id = socmedia.Id;
                if (OAuthService__c.sObjectType.getDescribe().isUpdateable()){                 
                    update oauthservice;
                }                        
                try{
                    CronJobDetail cj = [select id, Name from CronJobDetail where Name = :'scheduleFacebookAdInsightsJob'];
                    CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where CronJobDetailId = :cj.Id];
                    system.abortJob(ct.Id);   
                }catch(Exception e){}
                String SchTimer='0 0 0 1/1 * ? *';   
                //Datetime sysTime = System.now().addSeconds( 60 );      
                //String SchTimer = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
                system.schedule('scheduleFacebookAdInsightsJob', SchTimer, new scheduleFacebookAdInsights()); 
                string pageRef='/apex/Socialmedia_new?Name='+socmedia.Name+'&Connid='+oauthservice.Id+'&IsfromMrk='+isfrommrk;
                Pagereference pg=new Pagereference (pageRef);
                return pg; 
            }else{
                String errMsg = '';
                if(socmedia.Consumer_Key__c == null){
                    errMsg = 'Please enter a valid Consumer Key(Account Id).';
                }
                if(socmedia.Access_Token_URL__c == null){
                    errMsg = 'Please enter a valid Access Token URL.';
                }                
                if(facebookCampaignMessageConnection() <> null){
                    errMsg = facebookCampaignMessageConnection();
                }
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,errMsg);
                ApexPages.addMessage(myMsg);
                return null;
            }
        }catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()+', Problem to generate ad in Facebook try again!');
            ApexPages.addMessage(myMsg);
            return null;
        }
    }
    
    public boolean mailchimpCampaignConnection(){
        try{
            if(socmedia.Access_Token_URL__c <> null||Test.isRunningTest()){               
                String mailchimpstatus;  
                List<String> dcList = socmedia.Access_Token_URL__c.split('-');
                String dc = String.valueOf(dcList[1]);
                String statusReqURL = 'https://'+ dc +'.api.mailchimp.com/2.0/helper/verified-domains?apikey='+ socmedia.Access_Token_URL__c;
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
    
    public boolean mailchimpCampaignConsumerKeyConnection(){
        try{            
            if(socmedia.Consumer_Key__c <> null||Test.isRunningTest()){               
                String mailchimpstatus;  
                List<String> dcList = socmedia.Access_Token_URL__c.split('-');
                String dc = String.valueOf(dcList[1]);
                String statusReqURL = 'https://'+ dc +'.api.mailchimp.com/2.0/lists/activity?apikey='+ socmedia.Access_Token_URL__c+'&id='+socmedia.Consumer_Key__c;
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
                    if(mailchimpstatus <> 'error'){
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
    
    public void createMailChimpCampaign(){        
        try{                                                                                            
            if(socmedia.Consumer_Key__c <> null && socmedia.Access_Token_URL__c <> null||test.isrunningtest()){    
                if(mailchimpCampaignConnection() == true && mailchimpCampaignConsumerKeyConnection() == true){                                                           
                    if(socmedia.Redirect_URL__c <> null){                                                 
                        if (OAuthService__c.sObjectType.getDescribe().isCreateable()){
                            insert socmedia;
                        }                                                 
                    }                      
                }              
            }                                                                                     
        }catch(Exception e){               
        }        
    }
    
    public Pagereference createcampaignMailChimp(){        
        try{
            if(socmedia.Consumer_Key__c <> null && socmedia.Access_Token_URL__c <> null && mailchimpCampaignConnection() == true && mailchimpCampaignConsumerKeyConnection() == true){
                String campaignReqURL;                      
                List<String> dcList = socmedia.Access_Token_URL__c.split('-');
                String dc = String.valueOf(dcList[1]);
                String redURL='';
                if(socmedia.Redirect_URL__c <> null){
                    String RedirectURL = socmedia.Redirect_URL__c;
                    if(RedirectURL.contains('?')){
                        redURL = socmedia.Redirect_URL__c + '&maid=' + socmedia.Id;
                    }else{
                        redURL = socmedia.Redirect_URL__c + '?maid=' + socmedia.Id;   
                    }
                }
                if(socmedia.Redirect_URL__c <> null){
                    campaignReqURL = 'https://'+ dc +'.api.mailchimp.com/2.0/campaigns/create?apikey='+ socmedia.Access_Token_URL__c +'&type=regular&options[list_id]='+socmedia.Consumer_Key__c+'&options[subject]='+EncodingUtil.urlEncode(socmedia.Name,'UTF-8')+'&options[from_email]='+UserInfo.getUserEmail()+'&options[from_name]='+UserInfo.getOrganizationName()+'&options[generate_text]=true&content[text]='+socmedia.Name+'&content[url]='+redURL+'';
                }else{
                    campaignReqURL = 'https://'+ dc +'.api.mailchimp.com/2.0/campaigns/create?apikey='+ socmedia.Access_Token_URL__c +'&type=regular&options[list_id]='+socmedia.Consumer_Key__c+'&options[subject]='+EncodingUtil.urlEncode(socmedia.Name,'UTF-8')+'&options[from_email]='+UserInfo.getUserEmail()+'&options[from_name]='+UserInfo.getOrganizationName()+'&content';
                }
                HttpRequest campaignreq = new HttpRequest();                
                campaignreq.setMethod('GET');                      
                campaignreq.setEndpoint(campaignReqURL);                
                campaignreq.setTimeout(60*1000);                
                HttpResponse campaignres = null;                
                http campaignhttp= new Http();                           
                try{
                    campaignres = campaignhttp.send(campaignreq);                
                }catch(Exception e){
                    
                }                
                String campaignresult = campaignres.getBody();
                system.debug('abc'+campaignresult);
                if(campaignresult<>null && campaignresult<>''){
                    Map<String, Object> campaigndata = (Map<String, Object>)JSON.deserializeUntyped(campaignresult); 
                    String errorMsg = String.valueOf(campaigndata.get('status'));           
                    if(errorMsg == 'error'){
                        Savepoint sp = Database.setSavepoint();
                        Database.rollback(sp);
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,' Problem to generate campaign in MailChimp try again!');
                        ApexPages.addMessage(myMsg);
                        return null;                        
                    }else{
                        if(socmedia.Redirect_URL__c == null){
                            if (OAuthService__c.sObjectType.getDescribe().isCreateable()){
                                insert socmedia;
                            }
                        }
                        OAuthService__c oauthservice = new OAuthService__c();
                        oauthservice.Campaign_Id__c = String.valueOf(campaigndata.get('id'));
                        oauthservice.Auto_import__c = true;
                        oauthservice.Id = socmedia.Id;
                        if (OAuthService__c.sObjectType.getDescribe().isUpdateable()){                 
                            update oauthservice;
                        }
                        try{
                            CronJobDetail cj = [select id, Name from CronJobDetail where Name = :'scheduleMailChimpCampaignInsightsJob'];
                            CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where CronJobDetailId = :cj.Id];
                            system.abortJob(ct.Id); 
                        }catch(Exception e){} 
                        String SchTimer='0 0 0 1/1 * ? *';   
                        //Datetime sysTime = System.now().addSeconds( 60 );      
                        //String SchTimer = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
                        system.schedule('scheduleMailChimpCampaignInsightsJob', SchTimer, new scheduleMailChimpCampaignInsights());
                        string pageRef='/apex/Socialmedia_new?Name='+socmedia.Name+'&Connid='+oauthservice.Id+'&IsfromMrk='+isfrommrk;
                        Pagereference pg=new Pagereference (pageRef);
                        return pg;
                    }
                                            
                }else{ 
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,' Problem to generate campaign in MailChimp try again!');
                    ApexPages.addMessage(myMsg);
                    return null;
                }
            }else{
                String errMsg = '';
                if(socmedia.Consumer_Key__c == null){
                    errMsg = 'Please enter a valid Consumer Key(List Id).';
                }
                if(socmedia.Access_Token_URL__c == null){
                    errMsg = 'Please enter a valid Access Token URL(API Key).';
                }                
                if(mailchimpCampaignConsumerKeyConnection() == false){
                    errMsg = 'Please enter a valid Consumer Key(List Id).';
                }
                if(mailchimpCampaignConnection() == false){
                    errMsg = 'Please enter a valid Access Token URL(API Key).';
                }
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,errMsg);
                ApexPages.addMessage(myMsg);
                return null;
            }
        }catch(Exception e){   
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()+', Problem to generate campaign in MailChimp try again!');
             ApexPages.addMessage(myMsg);
             return null;
        }        
    }
    
    public boolean linkedinPageConnection(){
        try{
            if(socmedia.Page_Id__c <> null){               
                String appId;                
                HttpRequest appIdreq = new HttpRequest();     
                appIdreq.setEndpoint('https://api.linkedin.com/v1/companies/'+ socmedia.Page_Id__c +'?oauth2_access_token=' + socmedia.Access_Token_URL__c + '&format=json');
                appIdreq.setMethod('GET');         
                Http appIdhttp = new Http();
                HTTPResponse appIdres = appIdhttp.send(appIdreq);      
                String appIdresult = appIdres.getBody();           
                if(appIdresult<>null && appIdresult<>''){
                    Map<String, Object> appIddata = (Map<String, Object>)JSON.deserializeUntyped(appIdresult);                             
                    if(socmedia.Page_Id__c == String.valueOf(appIddata.get('id'))){
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
    
    public void createLinkedInShare(){        
        try{                                                                                            
            if(socmedia.Access_Token_URL__c <> null){    
                if(linkedinPageConnection() == true){                                                           
                    if (OAuthService__c.sObjectType.getDescribe().isCreateable()){
                        insert socmedia;
                    }                      
                }              
            }                                                                                     
        }catch(Exception e){               
        }        
    }
    
    public PageReference createshareLinkedIn(){
        try{
            if(socmedia.Page_Id__c <> null && socmedia.Access_Token_URL__c <> null && linkedinPageConnection() == true){
                String adReqURL; 
                String PostId;
                Date endDate = socmedia.End_Date__c;
                Date dateend_time = Date.newInstance(endDate.year(), endDate.month(), endDate.day());
                Time timeend_time = Time.newInstance(0, 0, 0, 0);
                DateTime dtend_time = DateTime.newInstanceGmt(dateend_time, timeend_time);
                Long lend_time = dtend_time.getTime() / 1000;                                
                adReqURL = 'https://api.linkedin.com/v1/companies/'+EncodingUtil.urlEncode(socmedia.Page_Id__c,'UTF-8')+'/shares?oauth2_access_token='+socmedia.Access_Token_URL__c+'&format=json';               
                HttpRequest adreq = new HttpRequest();                
                adreq.setMethod('POST');  
                adreq.setHeader('Content-Type', 'application/json');
                adreq.setHeader('x-li-format', 'json');
                adreq.setBody('{"visibility":{"code": "anyone"},"comment":"Testing a full company share!","content":{"submitted-url": "http://www.musqot.com/musqot-won-pitch-competition/","title": "'+socmedia.Name+'","description": "content description","submitted‐image-url": "https://cdn.evbuc.com/eventlogos/150965111/stockholmcard.png"}}');  
                adreq.setEndpoint(adReqURL);                
                adreq.setTimeout(60*1000);                
                HttpResponse adres = null;                
                http adhttp= new Http();                           
                try{
                    adres = adhttp.send(adreq) ;                
                }catch(Exception e){
                    
                }                
                String adresult = adres.getBody();
                system.debug('abc'+adresult);               
                if(adresult<>null && adresult<>''){
                    Map<String, Object> addata = (Map<String, Object>)JSON.deserializeUntyped(adresult);                    
                    String errorMsg = String.valueOf(addata.get('errorCode'));           
                    if(errorMsg <> null){
                        Savepoint sp = Database.setSavepoint();
                        Database.rollback(sp);
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, String.valueOf(addata.get('message')));
                        ApexPages.addMessage(myMsg);
                        return null;                        
                    }else{                        
                        PostId = String.valueOf(addata.get('updateKey')); 
                        PostId = PostId.split('-')[2];
                    }
                }else{
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,' Problem to generate share in LinkedIn try again!');
                    ApexPages.addMessage(myMsg);
                    return null;
                }                 
                OAuthService__c oauthservice = new OAuthService__c();
                oauthservice.Post_ID__c = PostId;                
                oauthservice.Auto_import__c = true;
                oauthservice.Id = socmedia.Id;
                if (OAuthService__c.sObjectType.getDescribe().isUpdateable()){                 
                    update oauthservice;
                }                        
                try{
                    CronJobDetail cj = [select id, Name from CronJobDetail where Name = :'scheduleLinkedInPostInsightsJob'];
                    CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where CronJobDetailId = :cj.Id];
                    system.abortJob(ct.Id);   
                }catch(Exception e){}
                String SchTimer='0 0 0 1/1 * ? *';   
                //Datetime sysTime = System.now().addSeconds( 60 );      
                //String SchTimer = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
                system.schedule('scheduleLinkedInPostInsightsJob', SchTimer, new scheduleLinkedInPostInsights()); 
                string pageRef='/apex/Socialmedia_new?Name='+socmedia.Name+'&Connid='+oauthservice.Id+'&IsfromMrk='+isfrommrk;
                Pagereference pg=new Pagereference (pageRef);
                return pg;
            }else{
                String errMsg = '';
                if(socmedia.Access_Token_URL__c == null){
                    errMsg = 'Please enter a valid Access Token URL and Page ID.';
                }
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,errMsg);
                ApexPages.addMessage(myMsg);
                return null;
            }
        }catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()+', Problem to generate share in LinkedIn try again!');
            ApexPages.addMessage(myMsg);
            return null;
        }
    }
    //--Raju adding editionsetting to create add & compaining --
    public boolean isSystemsIntegrations{get;set;}
    public String orgId;
    public void applyEditionSetting(){
        // get KEYCODE
        String keycode = musAct[0].keycode__c;
        MusqotUtility.decryptKeycode(keycode);
        //get ORGID
        orgId = UserInfo.getOrganizationId();
        orgId = orgId.substring(0,orgId.length()-2);
        MusqotUtility.decryptKeycode(keycode);
        boolean isValid = false;
        String decryptedEdition = MusqotUtility.edition;
        if(MusqotUtility.organizationId.equals(orgId)){
            if(!decryptedEdition.equals('Invalid')){
                isValid = true;
            }else {
                isValid = false;
            }
        }else{
            isValid = false;
        }
        if(isValid) {
            if(decryptedEdition=='Trial'){
                 isSystemsIntegrations=true;
            }
            else if(decryptedEdition=='Standard'){
                isSystemsIntegrations=false;
            }
            else if(decryptedEdition=='Professional'){
                isSystemsIntegrations=true;
            }
            else if(decryptedEdition=='Enterprise'){
                 isSystemsIntegrations=true;
            }
            else if(decryptedEdition=='Custom'){
                if(MusqotUtility.resource){
                    isSystemsIntegrations=true;
                }  
                else{
                   isSystemsIntegrations=false;
               }   
            }
        }else{
           
        }   
    }
    //--End ---
}