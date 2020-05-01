/*******************************************************
Class Name: Musqotsettingscontroller
Author:Nagaraju          Last modified by: Narendra K Jha
Date: 16/7/2014               Date: 3/11/2015
Dec:Addin Plan access controller field in Soql in Constructor.
********©2013 Musqot marketing technology Pvt ltd *******/
public with sharing class Musqotsettingscontroller{
    Public musqot__Activity__c mus{get;set;}
    public boolean showRec{get;set;}
    public boolean showEdt{get;set;}
    public string musid{get;set;}
    public boolean perGantt{get;set;}
    public string currentFisicalYear{get;set;}
    public list<FiscalYearSettings> orgFiscaltYearRec;
    public boolean licenceUpgradePopUp{get;set;}
    public String activeTab{get;set;}
    // added by Narendra - start - 
    public String orgId{get;set;}
    public String orgName{get;set;}
    public String currentEdition{get;set;}
    public String expiryDate{get;set;}
    public String additionalInfo{get;set;}
    public List<SelectOption> editionList{get;set;}
    public String selectedEdition{get;set;}
    public List<User> CurrentUser{get;set;}
    public List<PackageLicense> packageLicenses{get;set;}
    //public List<sfLma__Package_Version__c> sfLmaPackageVersions{get;set;}
    public String status{get;set;}
    public Integer allowedLicences{get;set;}
    public boolean showVerifyKeycodeBtn{get;set;}
    public boolean isSaveBtnDisabled{get;set;}
    public boolean isValidKeyCode{get;set;}
    public boolean isNotValidKeyCode{get;set;}
    public String message{get;set;}
    public boolean isPeakEdition{get;set;}
    // added by Narendra - end - 
    public boolean isholidaayList{get;set;}
    public Musqotsettingscontroller(ApexPages.StandardController controller){
        mus= new musqot__Activity__c ();
        musid= ApexPages.currentPage().getParameters().get('musid');
        try{
            mus=[SELECT id,Name,keycode__c,Use_Allocation__c,Use_Budget__c,Use_Finance1__c
                 ,Use_Forcasting__c,Forcasting_period__c,Use_milestones__c,Use_Resource__c
                 ,Use_socialmedia__c,Use_Performance_ERP__c, Use_Performance_CRM__c,Incl_Marketing_activity_Main__c
                 ,Incl_Marketing_activity_Detail__c ,Company_holidays__c,Incl_Task_main_gantt__c
                 ,Incl_Milestone_Main__c,Incl_Milestone_Detail__c,Drag_to_change_date_Main__c ,Incl_Task_Detail__c 
                 ,Performance_milestone_Detail__c,Drag_to_change_date_Detail__c,Plan_access_controll__c
                 FROM Activity__c limit 1];
        } catch(Exception e){}
        string mainStr = ApexPages.CurrentPage().getParameters().get('retURL');
        showRec=true;
        showEdt=false;
        isAdvanceMilestonedit=false;
        //--This for hide/show holidayslist in adminpage--
        Profile userprofile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId()];
        string MyProflieName = userprofile.Name;
        Profilelist__c profllist= Profilelist__c.getInstance(MyProflieName); //it is Custom setting object
        if(profllist<>null){
            if(profllist.profilename__c == 'System Administrator'){
                isholidaayList=true;
            }else
                isholidaayList=false;
        }
        
        //MyProflieName = userprofile[0].Name;
        //---Raju start--to get current fiscal year of org -- 
        orgFiscaltYearRec=[SELECT Id, Name, YearType 
                           FROM FiscalYearSettings limit 20];
        if(orgFiscaltYearRec != null) {
            if(orgFiscaltYearRec.size()>0){
                currentFisicalYear=[SELECT FiscalYearSettings.Name 
                                    FROM Period
                                    WHERE Type ='Year' AND StartDate <= TODAY AND EndDate >= TODAY].FiscalYearSettings.Name;
            }
        }
        // added by Narendra - start - 
        isPeakEdition = false;
        CurrentUser = [select Id, Name, Email, MobilePhone, Profile.Name 
                       from User 
                       where Id=:UserInfo.getUserId()];
        licenceUpgradePopUp = false;
        orgId = UserInfo.getOrganizationId();
        orgName = UserInfo.getOrganizationName();
        orgId = orgId.substring(0,orgId.length()-2);
        
        editionList= new List<SelectOption>(); 
        editionList.add(new SelectOption('Standard', 'Standard'));
        editionList.add(new SelectOption('Professional', 'Professional'));
        editionList.add(new SelectOption('Enterprise', 'Enterprise'));
        
        selectedEdition = '';
        currentEdition = '';
        packageLicenses = [SELECT ExpirationDate, Status,  AllowedLicenses 
                           FROM PackageLicense 
                           where namespaceprefix='musqot' limit 1];
        if(packageLicenses != null) {
            if(packageLicenses.size()>0) {
                Datetime dt = packageLicenses[0].ExpirationDate;
                if(dt != null)
                    expiryDate = dt.format('MMM dd, yyyy');
                status = packageLicenses[0].Status;
                allowedLicences = packageLicenses[0].AllowedLicenses;
            } 
        }
        if(expiryDate==''||expiryDate==Null)
            expiryDate = 'N/A';
        
        //sfLmaPackageVersions = [SELECT Id, Name,sfLma__Release_date__c FROM sfLma__Package_Version__c  where sfLma__Package__r.name = 'musqot' order by sfLma__Release_date__c desc limit 1];
        Organization orgInfo=[SELECT Id, Name, Division 
                              FROM Organization limit 1];
        String key = '';
        if(mus != null) {
            if(mus.keycode__c != null) {
                if(mus.keycode__c != '') {
                    key = mus.keycode__c;
                } else {
                    mus.keycode__c='XfrCZ-eXfdb-aIu5X-pyaTb';
                    key = mus.keycode__c;
                }
            } else {
                mus.keycode__c='XfrCZ-eXfdb-aIu5X-pyaTb';
                key = mus.keycode__c;
            }
        } else if(orgInfo.Division=='Musqot development'){
            mus.keycode__c='XfrCZ-eXfdb-aIu5X-pyaTb';
            key = mus.keycode__c;
        }
        MusqotUtility.decryptKeycode(key);
        currentEdition = MusqotUtility.edition;
        isAdvanceMilestone=true;
        if(currentEdition.equals('Standard')){
            editionList.remove(0);
            isResource=false;
            isPerformance=false;
            isAdvanceMilestone=false;
            isAdvanceMilestonedit=false;
        }
        else if(currentEdition.equals('Professional')) {
            editionList.remove(0);
            editionList.remove(1);
            isResource=true;
            isPerformance=true;
            isAdvanceMilestone=true;
        } else if(currentEdition.equals('Enterprise')) {
            isPeakEdition = true;
            isResource=true;
            isPerformance=true;
            isAdvanceMilestone=true;
            isAdvanceMilestonedit=true;
        }
        else if(currentEdition.equals('Trial')) {
            isResource=true;
            isPerformance=true;
            isAdvanceMilestone=true;
        }
        showVerifyKeycodeBtn = false;
        isSaveBtnDisabled = false;
        isValidKeyCode = false;
        message = '';
        isNotValidKeyCode =false;
        // added by Narendra - end -  
    }
    /*****************************************************************************
Save(): insert  musqotsetting records  and redirects to MusqotAdminPage
******************************************************************************/
    public boolean isResource{get;set;}
    public boolean isAdvanceMilestone{get;set;}
    public boolean isAdvanceMilestonedit{get;set;}
    public boolean isPerformance{get;set;}
    Public PageReference Save(){   
        
        if (musqot__Activity__c.sObjectType.getDescribe().isUpdateable()){                
            upsert mus;                   
        }     
        
        showRec=true;
        showEdt=false;  
        isAdvanceMilestonedit=false;
        //--Raju -- get KEYCODE && then updatethe musqot settings accordingly
        String keycode = mus.keycode__c;
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
                isResource=true;
                isAdvanceMilestone=true;
            }
            else if(decryptedEdition=='Standard'){
                //---Resource setting--
                mus.Use_Resource__c=false;
                //--performance setting--
                mus.Use_Finance1__c=false;
                //--Start advance milestone settings --
                mus.Use_socialmedia__c=false;
                mus.Use_Performance_CRM__c='Not used';
                mus.Use_Performance_ERP__c=false;
                isResource=false;
                isAdvanceMilestone=false;
                isPerformance=false;
            }
            else if(decryptedEdition=='Professional'){
                isResource=true;
                isAdvanceMilestone=true;
                isPerformance=true;
            }
            else if(decryptedEdition=='Enterprise'){
                isResource=true;
                isAdvanceMilestone=true;
                isPerformance=true;
            }
            else if(decryptedEdition=='Custom'){
                if(MusqotUtility.resource){
                    isResource=true;
                    isAdvanceMilestone=true;
                    isPerformance=true;
                }  
                else{
                    mus.Use_Resource__c=false;
                    mus.Use_Finance1__c=false;
                    isResource=false;
                    isPerformance=false;
                }    
            }
        }else{
            
        }  
        //--End--
        upsert mus;
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('msett','UTF-8');
        PageReference pg=new PageReference (pageRef);
        return pg;        
    } 
    /********************************************************
gotoEditMode():  show edit mode  musqotsetting editmode
*********************************************************/  
    Public void gotoEditMode(){        
        showRec=false;
        showEdt=true;
        isAdvanceMilestone=false;
        if(currentEdition.equals('Standard')){
            isAdvanceMilestonedit=false;
        }else 
            isAdvanceMilestonedit=true; 
        //defaultfisicalList=false;       
    }
    /****************************************************
gotoInfoMode(): show infomode of musqotsetting
*****************************************************/  
    Public PageReference gotoInfoMode(){        
        showRec=true;
        showEdt=false;
        isAdvanceMilestonedit=false;
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('msett','UTF-8');
        PageReference pg=new PageReference (pageRef);
        return pg;       
    }
    /*************************************
Cancel(): redirects to MusqotAdminPage 
**************************************/ 
    Public PageReference Cancel(){
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('msett','UTF-8');
        PageReference pg=new PageReference (pageRef);
        return pg;
    } 
    Public void autoSel(){
        perGantt=false;
        if(mus.Use_milestones__c==false){
            mus.Incl_Milestone_Main__c=false;
            mus.Incl_Milestone_Detail__c=false;
        }
        if(mus.Use_Performance_ERP__c==false && mus.Use_socialmedia__c==false && mus.Use_Performance_CRM__c=='Not used'){
            mus.Performance_milestone_Detail__c=false;
            perGantt=true;
        }         
    }
    //---Raju --This is for redirect to the Standerd Fiscal Year page---
    Public PageReference redirectToMusqotFiscalYearPage(){
        string s=URL.getSalesforceBaseUrl().toExternalForm();
        PageReference pageRef= new PageReference(s+'/_ui/core/fiscalyear/FiscalYearSetup/d?setupid=ForecastFiscalYear');
        pageRef.setredirect(true);
        return pageRef;
    }
    public void sendUpgradeRequest(){ 
        // sending mails
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        // mail for musqot sales
        String[] toAddresses = new String[]{'sales@musqot.com'};
            mail.setToAddresses(toAddresses); 
        mail.setSubject('Request for Musqot upgrade');
        if(additionalInfo == '')
            additionalInfo = 'None';
        // creating template
        String template = '<html><body>';
        template += '<p>A client has requested for licence upgrade. Details are as below:</p>';
        template += '<br/><br/><p><b>Organization Id: </b>'+orgId+'<br/><b>Organization Name: </b>'+orgName;
        template += '<br/><b>User Name: </b>'+CurrentUser[0].Name+'<br/><b>User Email: </b>'+CurrentUser[0].Email;
        template += '<br/><b>User Mobile: </b>'+CurrentUser[0].MobilePhone+'<br/><b>Upgrade To: </b>'+selectedEdition;
        template += '<br/><b>Status: </b>'+status+'<br/><b>Allowed Licenses: </b>'+allowedLicences;
        template += '<br/><b>Request Date: </b>'+Datetime.now().format('MMM dd, yyyy')+'<br/><b>Additional Info: </b>'+additionalInfo;
        template += '</p>';
        template += '</body></html>';
        mail.setHtmlBody(template);
        mails.add(mail);
        
        // mail for user
        mail = new Messaging.SingleEmailMessage();
        toAddresses = new String[]{CurrentUser[0].Email};
            mail.setToAddresses(toAddresses); 
        mail.setSubject('Request for Musqot upgrade');
        if(additionalInfo == '')
            additionalInfo = 'None';
        // creating template
        template = '<html><body>';
        template += '<p>You have requested for musqot product licence upgrade. Details are as below:</p>';
        template += '<br/><br/><p><b>Organization Id: </b>'+orgId+'<br/><b>Organization Name: </b>'+orgName;
        template += '<br/><b>User Name: </b>'+CurrentUser[0].Name+'<br/><b>User Email: </b>'+CurrentUser[0].Email;
        template += '<br/><b>User Mobile: </b>'+CurrentUser[0].MobilePhone+'<br/><b>Upgrade To: </b>'+selectedEdition;
        template += '<br/><b>Status: </b>'+status+'<br/><b>Allowed Licenses: </b>'+allowedLicences;
        template += '<br/><b>Request Date: </b>'+Datetime.now().format('MMM dd, yyyy')+'<br/><b>Additional Info: </b>'+additionalInfo;
        template += '</p>';
        template += '</body></html>';
        mail.setHtmlBody(template);
        mails.add(mail);
        
        // send mails        
        Messaging.SendEmail(mails);
        
        // hide popup
        licenceUpgradePopUp = false;
        activeTab = 'musqotConfig';
    }
    public void showLicenceUpgradePopUp() {
        licenceUpgradePopUp = true;
        activeTab = 'musqotConfig';
    }
    public void hideLicenceUpgradePopUp() {
        licenceUpgradePopUp = false;
        activeTab = 'musqotConfig';
    }
    public void verifyKeycode() {
        // get KEYCODE
        String keycode = mus.keycode__c;
        MusqotUtility.decryptKeycode(keycode);
        boolean isValid = false;
        String decryptedEdition = MusqotUtility.edition;
        if(MusqotUtility.organizationId.equals(orgId)) {
            if(!decryptedEdition.equals('Invalid')) {
                isValid = true;
            } else {
                isValid = false;
            }
        } else {
            isValid = false;
        }
        
        if(isValid){
            // valid key
            isValidKeyCode = true;
            isNotValidKeyCode = false;
            message = 'Keycode is valid for '+decryptedEdition.toLowerCase()+' edition!';
            isSaveBtnDisabled = false;
            showVerifyKeycodeBtn = false;
        } else {
            // invalid key
            isValidKeyCode = false;
            isNotValidKeyCode = true;
            message = 'Invalid Keycode, type in correct keycode!';
            isSaveBtnDisabled = true;
            showVerifyKeycodeBtn = true;
        }   
    }
}