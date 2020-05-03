/*******************************************************
Class Name: Performance_setting_controller 
Author:Håkan Sjöberg              Last modified by: Narendra
Date:16/11/2014                     Date: 28/10/2015
********©2013 Musqot marketing technology Pvt ltd *******/

public with sharing class Performance_setting_controller {
    Public String socialid{get;set;} 
    Public String conid{get;set;} 
    Public String musqotids{get;set;}
    public OAuthService__c oathCon { get; set;} 
    public string deleteid{get;set;}
    public string erpId{get;set;}
    public string crmid{get;set;}
    public String contentType {get; set;}
    public Attachment attachment{get;set;}
    public boolean hide{get;set;}
    public boolean hide1{get;set;}
    public integer count;
    public integer cu;
    public Blob csvFileBody{get;set;}
    public string csvName{get;set;}
    public string csvAsString{get;set;}
    public String[] csvFileLines{get;set;}
    public String[] inputvalues{get;set;}
    public List<ERP_sales_obj__c> erpList{get;set;}  
    public List<musqot__CRM_data__c> crmList{get;set;} 
    public list<musqot__CRM_settings__c> crms{get;set;} 
    public list<musqot__ERP_Settings__c> erps{get;set;}
    public String selecteddateformat{get;set;}
    public String selectedcrmdateformat{get;set;}
    public String tabInFocus;
    public string connectionid{get;set;}
    public String fromURL;
    public String fromURL1;
    public boolean fromHome;
    public string frmup;
    public boolean text{get;set;}
    public musqot__Activity__c act{get;set;}
    public string selectedTab {get;set;}
    
    // added by Narendra -- start --
    public String selectedMediaFilter {get;set;}
    public boolean isAutoimport {get;set;}
    public boolean isNonAutoimport {get;set;}
    public List<OAuthService__c> socialMedia { get; set; }
    public List<OAuthService__c> socialMediaConnection { get; set; }
    public List<socialmedia_settings__c> socialMediaSettings { get; set; }
    public List<Socialmedia_logfile__c> socialMediaLogFiles { get; set; }
    // added by Narendra -- end --
    
    public string tab;
    public boolean tabInFocus1;
    public boolean errorMassage;
    public string selectedMedia{get;set;}
    public List<OAuthService__c> totalSocialMediaConnection;
    public Performance_setting_controller(){
        connectionid=ApexPages.currentPage().getParameters().get('connectionid');
        fromURL=ApexPages.currentPage().getParameters().get('fromHome');
        fromURL1=ApexPages.currentPage().getParameters().get('fromHome1');
        string tabname1=ApexPages.currentPage().getParameters().get('tab'); 
        tab= ApexPages.currentPage().getParameters().get('sfdc.tabName');
        tabInFocus = System.currentPageReference().getParameters().get('tab');
        string tabmassg= System.currentPageReference().getParameters().get('tab1');
        string socilMediaURL= System.currentPageReference().getParameters().get('tab2');
        string tabMilechimp=System.currentPageReference().getParameters().get('tabm');
        String para = ApexPages.CurrentPage().getParameters().get('tabname'); 
        String conName = ApexPages.CurrentPage().getParameters().get('conname');
        string startar;
        totalSocialMediaConnection=new List<OAuthService__c>();
        // added by Narendra -- start --
        list<OAuthService__c> oathCon = [SELECT Social_media__c  FROM OAuthService__c  
                                         where isdeleted = false order by Social_media__c limit 1];       
        if(oathCon.size()>0){
            selectedMediaFilter = oathCon[0].Social_media__c;
        }	
        // setting autoimport and nonautoimport default status
        isAutoimport = true;
        isNonAutoimport = true;
        // added by Narendra -- end --
        
        system.debug('=ST=='+selectedTab);
        if(tabmassg<>null){
            tabInFocus1=Boolean.valueOf(tabmassg);
            if(tab=='null' && tabInFocus1==true){
                ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.Error,conName+' is cannot be deleted , since it is associated with some social media settings');
                ApexPages.addMessage(myMsg1); 
            } 
            else if(tab=='null' && tabInFocus1==false){
                ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.info,conName+' Secussfully deleted');
                ApexPages.addMessage(myMsg1); 
            }
        }
        if(tabMilechimp<>null){
            selectedMedia=tabMilechimp; 
        }
        if(socilMediaURL<>null){
            selectedMedia=socilMediaURL;
        }
        frmup=fromURL1;
        if(fromURL<>null){
            fromHome=fromURL.contains('true');
        }
        if(tab.length()>=15){
            selectedTab='socialMediaConition'; 
        }
        if(fromHome==true){
            string tabname='socialMediaConition';
            selectedTab=tabname;//asign selected tab name.
        }else if(fromHome==false){
            string tabname='ERP_import';
            selectedTab=tabname;
            
            if(fromHome==false && frmup=='null'){
                text=true;
            }
        }
        csvFileLines = new String[]{};
            erpList = New List<ERP_sales_obj__c>();  
        crmList = New List<musqot__CRM_data__c>();  
        musqotids=ApexPages.currentPage().getParameters().get('id');  
        
        //selectOathId=new list<string>();
        act=[SELECT Id, Use_socialmedia__c,keycode__c , Use_Performance_CRM__c, Use_Performance_ERP__c 
             FROM Activity__c LIMIT 500];
        try{
            LoadDataByFilter();
        }catch(Exception e){}
        //--Raju adding to get orgId--
        orgId = UserInfo.getOrganizationId();
        orgId = orgId.substring(0,orgId.length()-2);
        applyEditionSetting();
    }
    
    // added by Narendra -- start --
    
    public void setSocialMediaValue() {
        selectedMediaFilter = Apexpages.currentPage().getParameters().get('sm');
    }
    public List<SelectOption> mediaFilterList {
        
        get
        {
            List<OAuthService__c> mediaFilterTemp = [SELECT Social_media__c  FROM OAuthService__c 
                                                     where isdeleted = false order by Social_media__c ];
            mediaFilterList = new List<SelectOption>();
            String SocMedia;
            String SocMedia2 = 'a';
            for(OAuthService__c ar : mediaFilterTemp) {
                SocMedia = (string)ar.get('Social_media__c');
                if(SocMedia<>SocMedia2){
                    mediaFilterList.add(new SelectOption(SocMedia, SocMedia)); 
                    SocMedia2 = (string)ar.get('Social_media__c');
                }
            }
            return mediaFilterList;
        }
        set;
    }
    //   public mediaFilterList(){
    //}
    /**************************************************************************************************************** 
LoadDataByFilter(): loads socialMediaConnection, socialMediaSettings & socialMediaLogFiles Data based on current
filter values.
****************************************************************************************************************/
    public void LoadDataByFilter() {
        
        // To retain current filter settiings - start -
        Cookie current_sm = ApexPages.currentPage().getCookies().get('current_sm');
        if(current_sm != null)
            if(current_sm.getValue() != '')
            selectedMediaFilter = current_sm.getValue();
        
        Cookie current_ai = ApexPages.currentPage().getCookies().get('current_ai');
        if(current_ai != null)
            if(current_ai.getValue() != '')
            isAutoimport = (current_ai.getValue()=='true'?true:false);
        
        Cookie current_nai = ApexPages.currentPage().getCookies().get('current_nai');
        if(current_nai != null)
            if(current_nai.getValue() != '')
            isNonAutoimport = (current_nai.getValue()=='true'?true:false);
        // To retain current filter settiings - end -
        
        
        // Getting socialMediaConnection -- start --
        if (isAutoimport==true && isNonAutoimport==false) {
            // fetch social media connection where Autoimport is true
            socialMediaConnection = [SELECT Id, Name, Access_Token_URL__c, Authorization_Type__c, Authorization_URL__c, musqot__Consumer_Key__c,musqot__Social_media__c,
                                     Consumer_Secret__c, Redirect_URL__c, Request_Token_URL__c, Response_Type__c, Scope__c, musqot__Signature_Method__c, Page_Id__c, 
                                     Bar_color__c, Post_ID__c, Access_Token__c, End_Date__c, Auto_import__c 
                                     FROM OAuthService__c where musqot__Social_media__c=:selectedMediaFilter and musqot__Auto_import__c=true order by name LIMIT 200];
        } else if (isAutoimport==false && isNonAutoimport==true) {
            // fetch social media connection where Autoimport is false
            socialMediaConnection = [SELECT Id, Name, Access_Token_URL__c, Authorization_Type__c, Authorization_URL__c, musqot__Consumer_Key__c,musqot__Social_media__c,
                                     Consumer_Secret__c, Redirect_URL__c, Request_Token_URL__c, Response_Type__c, Scope__c, musqot__Signature_Method__c, Page_Id__c, 
                                     Bar_color__c, Post_ID__c, Access_Token__c, End_Date__c, Auto_import__c 
                                     FROM OAuthService__c 
                                     where musqot__Social_media__c=:selectedMediaFilter and musqot__Auto_import__c=:false order by name LIMIT 200];
        } else if (isAutoimport==false && isNonAutoimport==false) {
            // make social media connection list empty
            socialMediaConnection = new List<OAuthService__c>();
        } else if (isAutoimport==true && isNonAutoimport==true) {
            // fetch social media connection where Autoimport true/false
            socialMediaConnection = [SELECT Id, Name, Access_Token_URL__c, Authorization_Type__c, Authorization_URL__c,
                                     Consumer_Key__c,  Social_media__c, Consumer_Secret__c, Redirect_URL__c, Request_Token_URL__c, Response_Type__c, Scope__c,  Signature_Method__c, Page_Id__c, Bar_color__c, Post_ID__c, Access_Token__c, End_Date__c, Auto_import__c 
                                     FROM OAuthService__c 
                                     where  Social_media__c=:selectedMediaFilter order by name LIMIT 200];
        } 
        // Getting socialMediaConnection -- end --
        
        // Getting socialMediaSettings -- start --
        socialMediaSettings = [Select id, Name, Chart__c, type__c,Import_rate__c,Watch_type__c, Socialmedia_type__c, Socialmedia__c 
                               from socialmedia_settings__c 
                               where Socialmedia__c=:socialMediaConnection order by name LIMIT 200];
        // Getting socialMediaSettings -- end --
        
        // Getting socialMediaLogFiles -- start --
        socialMediaLogFiles = [select Id,Name, Imported__c, Import_message__c, createdDate, Number_of_records__c, ownerID,owner.Name 
                               from Socialmedia_logfile__c 
                               where Connection_id__c=:socialMediaConnection Order By createdDate desc limit 80];
        // Getting socialMediaLogFiles -- end --
    }
    // added by Narendra -- end --
    
    public String Socialmedia(){
        return null;
    }
    
    /***************************************** 
DeleteSettings():delete socialmediasetting records
*****************************************/    
    public pagereference DeleteSettings(){
        /*Raju: fix for delete social media settings */
        String delId= ApexPages.currentPage().getParameters().get('deleteid'); 
        socialmedia_settings__c socialSeting=new socialmedia_settings__c() ;
        socialSeting=[Select id, Socialmedia__r.Social_media__c , name 
                      from socialmedia_settings__c  
                      where id=:delId limit 1];
        selectedMedia=socialSeting.Socialmedia__r.Social_media__c ;
        
        if (musqot__socialmedia_settings__c.sObjectType.getDescribe().isDeletable()){
            delete socialSeting;
        }
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('mpsett','UTF-8')+'&fromHome=true'+'&tab2='+selectedMedia;
        Pagereference pg=new Pagereference (pageRef);
        return pg;    
    }  
    /***************************************** 
DeleteConnection():delete socialmediaconnection records
*****************************************/  
    public string connectionName;
    public pagereference DeleteConnection(){
        String delId= ApexPages.currentPage().getParameters().get('deleteconnid'); 
        musqot__OAuthService__c socialConnection=[Select id, name, Socialmedia__c, Social_media__c 
                                                  from OAuthService__c 
                                                  where id=:delId ];  
        list<musqot__socialmedia_settings__c> socSettings=[SELECT Id, Socialmedia__c 
                                                           FROM socialmedia_settings__c 
                                                           where Socialmedia__c=:delId ];
        if(socSettings.size()>0){
            selectedMedia=socialConnection.musqot__Social_media__c;
            errorMassage=true;  
            connectionName=socialConnection.Name;      
        }  
        else{  
            errorMassage=false; 
            selectedMedia=socialConnection.musqot__Social_media__c;
            connectionName=socialConnection.Name;    
            delete socialConnection;
        }
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('mpsett','UTF-8') +'&tab1='+errorMassage+'&tab2='+selectedMedia+'&conname='+connectionName;
        Pagereference pg=new Pagereference (pageRef);
        return pg;    
    }    
    /***************************************** 
NewSocial():it redirect to Socialmedia_new page
*****************************************/
    public pagereference NewSocial(){  
        PageReference pgr;
        pgr =new PageReference ('/apex/Socialmedia_new');
        pgr.setredirect(true); 
        return pgr;
    } 
    /***************************************** 
NewConnection():it redirect to Socialmediaconnection_new page
*****************************************/
    public pagereference NewConnection(){  
        PageReference pgr;
        pgr =new PageReference ('/apex/Social_media_new_connection');
        pgr.setredirect(true); 
        return pgr;
    }  
    /***************************************** 
editPage():it redirect to Socialmedia_settings page
*****************************************/
    public PageReference editPage() {
        
        String socialId= ApexPages.currentPage().getParameters().get('socialid');   
        PageReference pgr;      
        if(socialid!=null && socialid !=' '){        
            pgr =new PageReference ('/apex/Socialmedia_settings?socialid='+EncodingUtil.urlEncode(socialId,'UTF-8'));
            pgr.setredirect(true); 
            return pgr;
        }
        return null;       
        
    }
    /***************************************** 
editConnectionPage():it redirect to Socialmedia_connection page
*****************************************/
    public PageReference editConnection(){
        String conId= ApexPages.currentPage().getParameters().get('conid');   
        PageReference pgr;      
        if(conid!=null && conid !=' '){        
            pgr =new PageReference ('/apex/Social_media_connection?conid='+EncodingUtil.urlEncode(conId,'UTF-8')+'&fb=true');
            pgr.setredirect(true); 
            return pgr;
        }
        return null;       
        
    }    
    /***************************************** 
newERP():it redirect to ERPsettingpage 
*****************************************/
    Public PageReference newERP(){
        erps = [select Id,Name,musqot__Selector__c 
                from musqot__ERP_Settings__c limit 100];
        PageReference ERPpage=new PageReference('/apex/ERPsettingpage');
        ERPpage.setredirect(true);
        return ERPpage; 
    }
    /***************************************** 
newCRM():it redirect to CRMSettingpage
*****************************************/
    Public PageReference newCRM(){
        erps = [select Id,Name,musqot__Selector__c 
                from musqot__ERP_Settings__c limit 400];
        PageReference ERPpage=new PageReference('/apex/CRMsetting');
        ERPpage.setredirect(true);
        return ERPpage; 
    }
    /**********************************************************
getERP():it returns list of musqot__ERP_Settings__c  records
***********************************************************/
    public List<musqot__ERP_Settings__c> getERP(){
        return [select Id,Name, Selector__c, erp_Chart__c, ERP_performance_type__c 
                from ERP_Settings__c  order by Name limit 400];
    }
    
    /**********************************************************
getCRM():it returns list of musqot__CRM_settings__c records
***********************************************************/
    public List<musqot__CRM_settings__c> getCRM(){
        List<musqot__CRM_settings__c> crmList=[SELECT Id,Bar_color__c,Chart__c, CRM_performance_type__c, Expression_business_area__c, Expression_business_region__c, Selector__c,Name ,Watch_type__c 
                                               FROM CRM_settings__c order by name limit 400];
        
        return  crmList;
    }
    /***************************************** 
gotoERPedit():it redirect to ERPsettingEditpage
*****************************************/
    public PageReference gotoERPedit() {
        String erpid= ApexPages.currentPage().getParameters().get('erpid'); 
        PageReference pgr;
        if(erpid<>null){       
            pgr =new PageReference ('/apex/ERPsettingEditpage?erpid='+EncodingUtil.urlEncode(erpid,'UTF-8'));
            return pgr;
        }
        return null;
    }
    
    /*****************************************  
gotoCRMedit():it redirect to CRMsettingEditpage
*****************************************/
    public PageReference gotoCRMedit() {
        String crmid= ApexPages.currentPage().getParameters().get('crmid'); 
        PageReference pgr;
        if(crmid<>null){       
            pgr =new PageReference ('/apex/CRMsettingEditpage?crmid='+EncodingUtil.urlEncode(crmid,'UTF-8'));
            return pgr;
        }
        return null;
    }
    /*********************************************************** 
deletemethod():it deletes to musqot__CRM_Settings__c  records
*************************************************************/
    public pagereference deleteCRM(){
        musqot__CRM_settings__c crm;
        try{
            crm = [SELECT Id, Bar_color__c, Chart__c, CRM_performance_type__c, Expression_business_area__c, Expression_business_region__c, Selector__c,Name 
                   FROM CRM_settings__c  
                   where id=:crmid limit 1];
        }catch(exception e){}                             
        if (musqot__CRM_settings__c.sObjectType.getDescribe().isDeletable()){
            if(crm<>null)
                delete crm;
        }
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('mpsett','UTF-8');
        Pagereference pg=new Pagereference (pageRef);
        return pg;
    }
    
    /*********************************************************** 
deletemethod():it deletes to musqot__ERP_Settings__c  records
*************************************************************/
    public pagereference deletemethod(){
        // LoadData();
        musqot__ERP_Settings__c ers= [select Id,Name, Selector__c, erp_Chart__c 
                                      from ERP_Settings__c 
                                      where id=:erpId limit 1];
        if (musqot__ERP_Settings__c.sObjectType.getDescribe().isDeletable()){
            delete ers;
        }
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('mpsett','UTF-8');
        Pagereference pg=new Pagereference (pageRef);
        return pg;
    }
    
    
    /**********************************************************
geterplogList():it returns list of ERP_logfile__c  records
***********************************************************/  
    public List<ERP_logfile__c> geterplogList(){
        return [select Id,Name,Imported__c,Import_message__c,createdDate,Number_of_records__c,ownerID,
                (Select Id, Title From NotesAndAttachments) 
                From ERP_logfile__c Order By createdDate desc limit 80];
    }
    
    /**********************************************************
Savedoc():upload the erp file
***********************************************************/     
    public Pagereference Savedoc(){
        String erpId= System.currentPagereference().getParameters().get('id');
        String record = '';
        Integer iErr=-1;
        if(csvFileBody<>null){
            text=false;
            try{ 
                csvAsString = csvFileBody.toString();
                csvFileLines = csvAsString.split('\n');       
                
                if (ERP_logfile__c.sObjectType.getDescribe().isCreateable()){
                    ERP_logfile__c erpLog = new ERP_logfile__c();
                    insert erpLog;  // record count is worng               
                    if (Schema.sObjectType.Attachment.fields.body.isCreateable()){
                        Attachment a = new Attachment(parentId = erpLog.Id, name=csvName, body = csvFileBody);       
                        insert a;
                    }  
                    iErr=0;       
                    try{           
                        string temp ='';
                        for(Integer i=1;i<csvFileLines.size();i++){
                            
                            ERP_sales_obj__c erpObj = new ERP_sales_obj__c() ;
                            string[] csvRecordData = csvFileLines[i].split(',');
                            erpObj.sales_import_id__c = csvRecordData[0] ;             
                            erpObj.Business_region__c = csvRecordData[1];
                            erpObj.Business_area__c = csvRecordData[2];
                            erpObj.Sales__c = Decimal.valueOf(csvRecordData[3].trim());
                            temp = csvRecordData[4];
                            erpObj.Sales_currency__c = temp.substring(0,3);               
                            erpObj.Sales_date__c = prepareDate(csvRecordData[5],selecteddateformat);
                            erpObj.Sales_import_date__c = system.toDay();  
                            erpObj.ERP_logfile__c = erpLog.Id;      
                            erpList.add(erpObj);
                            iErr = i;
                            record = string.valueof(erpObj.Sales_date__c) ; 
                            
                            
                        } 
                        
                        Database.SaveResult[] srList = Database.insert(erpList, true);
                        
                        Integer success =0;
                        Integer failed = 0;
                        String failedRecords;
                        for(Database.SaveResult saveresult : srList ){
                            if(saveresult.isSuccess()){
                                success = Success + 1;    
                            }
                            else{
                                
                                Integer currentRecord =  success + failed;
                                Failed = failed +1;
                                If(String.isBlank(failedRecords)){
                                    failedRecords =string.valueof(currentRecord);
                                }
                                else{
                                    failedRecords = failedRecords + ',' + currentRecord; 
                                }
                            }
                        }
                        ERP_logfile__c erpLogUpdate = new ERP_logfile__c();
                        erpLogUpdate.Id = erpLog.Id;
                        if(failed == 0){
                            erpLogUpdate.Import_message__c = 'File uploaded successfully';  
                            erpLogUpdate.Imported__c=true;
                            erpLogUpdate.Number_of_records__c = success ; 
                        }
                        else{
                            if(success != 0)
                            {
                                erpLogUpdate.Number_of_records__c = success ; 
                                erpLogUpdate.Import_message__c=failedRecords +' ' +' record numbers  failed out of'+' '+ erpList.size();
                            }
                            else{
                                
                                erpLogUpdate.Number_of_records__c = 0; 
                                erpLogUpdate.Import_message__c = 'Upload Failed, line ' + iErr + '  ' +record;
                                //   erpLogUpdate.Import_message__c = 'Upload Failed' +':'+'Duplicate Ids';
                            }
                            
                        }
                        update erpLogUpdate;
                    }catch(Exception e){
                        ERP_logfile__c erpLogUpdate = new ERP_logfile__c();
                        erpLogUpdate.Id = erpLog.Id;
                        erpLogUpdate.Number_of_records__c = 0; 
                        erpLogUpdate.Import_message__c = e.getMessage();
                        update erpLogUpdate;
                    } 
                }
            }catch(exception e){
                ERP_logfile__c erpLog = new ERP_logfile__c();
                erpLog.Import_message__c = 'Unable to read the file,' + e.getMessage()+', ' +e.getLineNumber();
                insert erpLog ;   
            } 
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('mpsett','UTF-8')+'&fromHome=false';
            Pagereference pg=new Pagereference (pageRef);
            return pg;
        }
        else{
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('mpsett','UTF-8')+'&fromHome=false'+'&fromHome1=null';
            Pagereference pg=new Pagereference (pageRef);
            return pg;
        }
    }
    
    public Date prepareDate(String dt,string selecteddateformat){           
        
        if(dt<>null){
            Date tempDate;
            String[] tempStr;
            if(dt.contains('-')){                 
                tempStr = dt.split('-');
            }
            if(dt.contains('/')){ 
                tempStr = dt.split('/'); 
            }       
            
            /***************************************/          
            Integer y;
            Integer m;
            Integer d;                
            
            if(selecteddateformat=='1') //mm/dd/yy
            {            
                m = Integer.valueOf(tempStr[0].trim());
                d = Integer.valueOf(tempStr[1].trim());
                y = Integer.valueOf(tempStr[2].trim());              
                
            }
            else if(selecteddateformat=='2') //dd/mm/yy
            {             
                d = Integer.valueOf(tempStr[0].trim());
                m = Integer.valueOf(tempStr[1].trim());
                y = Integer.valueOf(tempStr[2].trim());                                  
                
            }else //yy-mm-dd
            {
                y = Integer.valueOf(tempStr[0].trim());
                m = Integer.valueOf(tempStr[1].trim());
                d = Integer.valueOf(tempStr[2].trim());
                
            }                     
            /***************************************/
            tempDate = Date.newInstance(y,m,d);
            return tempDate;
        }
        else{
            return null;
        }        
    }  
    
    /**********************************************************
getcrmplogList():it returns list of ERP_logfile__c  records
***********************************************************/  
    public List<musqot__CRM_logfile__c> getcrmlogList(){
        return [select Id,Name, Imported__c, Import_message__c,createdDate, Number_of_records__c,ownerID,owner.Name,(Select Id,Title From NotesAndAttachments) from musqot__CRM_logfile__c Order By createdDate desc limit 40];
        
    }
    
    
    /**********************************************************
uploadcrmdoc():upload the CRM file
***********************************************************/        
    public Pagereference uploadcrmdoc(){
        
        String crmId= System.currentPagereference().getParameters().get('id');
        if(csvFileBody<>null){
            text=false;
            try{ 
                csvAsString = csvFileBody.toString();
                inputvalues= csvAsString.split('\n');            
                if (CRM_logfile__c.sObjectType.getDescribe().isCreateable()){
                    CRM_logfile__c crmLog = new CRM_logfile__c();
                    insert crmLog;               
                    if (Schema.sObjectType.Attachment.fields.body.isCreateable())
                    {
                        Attachment a = new Attachment(parentId = crmLog.Id, name=csvName, body = csvFileBody);       
                        insert a;
                    }  
                    
                    try{                                     
                        for(Integer i=1;i<inputvalues.size();i++){
                            
                            CRM_data__c crmdata = new CRM_data__c() ;
                            string[] csvRecordData = inputvalues[i].split(',');
                            crmdata.CRM_import_id__c= csvRecordData[0] ;             
                            crmdata.Business_region__c= csvRecordData[1];
                            crmdata.Business_area__c= csvRecordData[2];
                            crmdata.No_Deals__c=Integer.valueof(csvRecordData[3]);   
                            crmdata.No_Leads__c= Integer.valueof(csvRecordData[4]);              
                            crmdata.No_Opportunities__c=Integer.valueof(csvRecordData[5]);
                            crmdata.Value_Deals__c= Decimal.valueof(csvRecordData[6]);
                            crmdata.musqot__Value_w_Opportunities__c= Decimal.valueof(csvRecordData[7]);
                            crmdata.Value_Opportunities__c= Decimal.valueof(csvRecordData[8]);
                            crmdata.Date__c=prepareDate(csvRecordData[9],selectedcrmdateformat);
                            crmdata.CRM_import_date__c= system.toDay(); 
                            crmdata.CRM_logfile__c= crmLog.Id;   
                            crmdata.Name=csvName;
                            crmList.add(crmdata);  
                            
                        }                        
                        Database.SaveResult[] srList = Database.insert(crmList, false);
                        Integer success =0;
                        
                        Integer failed = 0;
                        String failedRecords;
                        for(Database.SaveResult saveresult : srList ){
                            if(saveresult.isSuccess()){
                                success = Success + 1;    
                            }
                            else{
                                
                                Integer currentRecord =  success + failed;
                                Failed = failed +1;
                                If(String.isBlank(failedRecords)){
                                    failedRecords =string.valueof(currentRecord);
                                }
                                else{
                                    failedRecords = failedRecords + ',' + currentRecord; 
                                }
                            }
                        }
                        CRM_logfile__c crmLogUpdate = new CRM_logfile__c();
                        crmLogUpdate.Id = crmLog.Id;
                        if(failed == 0){
                            crmLogUpdate.Import_message__c = 'File uploaded successfully'; 
                            crmLogUpdate.musqot__Imported__c=true; 
                            
                            crmLogUpdate.Number_of_records__c = success ; 
                        }
                        else{
                            crmLogUpdate.Number_of_records__c = (srList.size()); 
                            crmLogUpdate.Number_of_records__c = success ; 
                            if(success != 0)
                            {
                                crmLogUpdate.Number_of_records__c = success ; 
                                crmLogUpdate.Import_message__c=failedRecords +' ' +' record numbers  failed out of'+' '+ crmList.size();
                            }
                            else{
                                
                                crmLogUpdate.Number_of_records__c = 0; 
                                crmLogUpdate.Import_message__c = 'Upload Failed' +':'+'Duplicate Ids';
                            }
                            //erpLogUpdate.Import_message__c ='UploadFailed'+':'+success+' out of'+ erpList.size() +'records uploaded success';
                        }
                        update crmLogUpdate;
                        
                    }
                    catch (Exception e){
                        CRM_logfile__c crmLogUpdate = new CRM_logfile__c();
                        crmLogUpdate.Id = crmLog.Id;
                        crmLogUpdate.Number_of_records__c = 0; 
                        crmLogUpdate.Import_message__c = e.getMessage();
                        update crmLogUpdate;
                    } 
                }
            }catch(exception e){
                CRM_logfile__c crmlog = new CRM_logfile__c();
                crmlog.Import_message__c = 'File upload Failed';
                insert crmlog;  
            } 
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('mpsett','UTF-8')+'&fromHome=false';
            Pagereference pg=new Pagereference (pageRef);
            return pg;
        }
        else{
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('mpsett','UTF-8')+'&fromHome=false'+'&fromHome1=null';
            Pagereference pg=new Pagereference (pageRef);
            return pg;
        }
    }
    //--Raju--adding applyEditionSetting of creating Social media connections--
    public boolean isNumberofConnections{get;set;}
    public String orgId{get;set;}
    public void applyEditionSetting(){
        totalSocialMediaConnection = [SELECT Id, Name, Access_Token_URL__c                   
                                      FROM OAuthService__c LIMIT 2000]; 
        // get KEYCODE
        String keycode = act.keycode__c;
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
                if(totalSocialMediaConnection.size()<=10)
                    isNumberofConnections=false;
                else
                    isNumberofConnections=true;
            }
            else if(decryptedEdition=='Standard'){
                if(totalSocialMediaConnection.size()<=10)
                    isNumberofConnections=false;
                else
                    isNumberofConnections=true;
            }
            else if(decryptedEdition=='Professional'){
                if(totalSocialMediaConnection.size()<=500)
                    isNumberofConnections=false;
                else
                    isNumberofConnections=true;
            }
            else if(decryptedEdition=='Enterprise'){
                   isNumberofConnections=true;
            }
            else if(decryptedEdition=='Custom'){
                if(MusqotUtility.projectPerformance)
                    isNumberofConnections=true;
                else
                    isNumberofConnections=false;
            }
        }else{
            
        }   
    } 
}