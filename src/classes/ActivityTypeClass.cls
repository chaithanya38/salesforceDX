/********************************************************************
Class Name: ActivityTypeClass
Author:chaithanya daggumati     Last modified by:Raju GN
Date: 6/7/2014                  Date:23/12/2015
Des:Adding static resource immage popup
********©2013 Musqot marketing technology Pvt ltd *******************/
public with sharing class ActivityTypeClass {
    Public Activitytype__c ActivityType{get;set;}
    Transient Map<string,Schema.FieldSet> FsMap ;
    public string banner{get;set;}
    public boolean acttab{get;set;}
    public list<StaticResource>StaticResourceList{get;set;}
    public string bgColor{get;set;}
    public url clickedImageurl{get;set;}
    public boolean showImg{get;set;}
    public string fileName{get;set;}
    public blob fileImage{get;set;}
    id queryid=ApexPages.currentPage().getParameters().get('id') ;
    public ActivityTypeClass(ApexPages.StandardController controller){
        ActivityType=new Activitytype__c();
        listWrapper = new List<WrapperClass>();
        StaticResourceList=new list<StaticResource>();
        FsMap = new Map<string,Schema.FieldSet>();
        ActivityType.Bar_color__c='CCCCCC';
        //---Raju start to get StaticResource to display images --
        filesizecheck=false;
        StaticResourceList.clear();
        staticresourceLoade();
    }
    //--Raju to loade static resource records--
    public void staticresourceLoade(){
        StaticResourceList=[SELECT Id,Name,NamespacePrefix,SystemModstamp,ContentType 
                            FROM StaticResource where Description='Activity type icon'
                            OR NamespacePrefix='musqotActivity' ORDER BY Name limit 250];
        map<string,string>resourceNameWithNamespace=new map<string,string>();
        map<string,DateTime>resourceNameWithSystemModStamp=new map<string,DateTime>();
        List<string>resourceNamesList=new List<string>();
        for(StaticResource s:StaticResourceList){
            resourceNameWithNamespace.put(s.Name,s.NamespacePrefix);
            resourceNameWithSystemModStamp.put(s.Name,s.SystemModstamp); 
            resourceNamesList.add(s.Name);
        } 
        for(string s:resourceNamesList){
            string resourceURL='';
            string rname=s;   
            string namespaceprfix=resourceNameWithNamespace.get(s); 
            Datetime systemmodestmp=resourceNameWithSystemModStamp.get(s); 
            resourceURL= '/resource/' 
                +systemmodestmp.getTime() + '/' 
                + (namespaceprfix != null && namespaceprfix != '' ? namespaceprfix + '__' : '') 
                + s; 
            listWrapper.add(new WrapperClass(rname,resourceURL));
        }
        
    }
    //--End---
    /*****************************************************************************
Fieldsetlist: This method will update plantype and redirects to MusqotAdminpage
***************************************************************************/ 
    public List<SelectOption> Fieldsetlist
    {
        get
        {
            List<SelectOption> fieldSetListTmp = new List<SelectOption>();
            schema.DescribeSObjectResult dsr = musqot__Marketing_activity__c.sObjectType.getDescribe();
            FsMap = dsr.fieldSets.getMap();
            fieldSetListTmp.add(new SelectOption('','-None-'));
            for(Schema.FieldSet fldSet : FsMap.values()){                 
                fieldSetListTmp.add(new SelectOption(fldSet .getName(),fldSet.getLabel())); 
            }
            if(fieldSetListTmp.isEmpty()){
                fieldSetListTmp.add(new SelectOption('','-None-')); 
            }
            return fieldSetListTmp ;
        }
        set;
    } 
    //Raju to get selected imageurl---
    public void selectActivityImage(){
        showImg=true;
        String clickedImageurl= ApexPages.CurrentPage().getParameters().get('imgeurl');
        bgColor=ActivityType.Bar_color__c;
        ActivityType.Icon__c=clickedImageurl;  
        showImagePopUp = false;
    }
    //--End--
    /***************************************************************************
Save(): crete new Activitytypes records and redirect to  MusqotAdminPage
****************************************************************************/
    Public PageReference Save(){
        try{
            if (Activitytype__c.sObjectType.getDescribe().isCreateable())
            {
                if(ActivityType.Icon__c==null){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select/Upload icon'));
                    return null;
                }
                else{
                    acttab=true;  
                    insert ActivityType;
                }
            }
        }
        catch(Exception e){}
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('mar','UTF-8');
        Pagereference pg=new Pagereference (pageRef);
        return pg;
    }
    /************************************
Cancel():redirect to  MusqotAdminPage
*************************************/
    Public PageReference Cancel()
    {
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('mar','UTF-8');
        Pagereference pg=new Pagereference (pageRef);
        return pg;
    }
    /***********************************
getIcon():returns ActivityType Icons
*************************************/
    public Activitytype__c getIcon() {
        if (ActivityType == null||test.isRunningTest()){ 
            ActivityType= [select Icon__c from Activitytype__c where 
                           id = :queryid];
        }
        return ActivityType ;
    }
    public static String GetResourceURL(String resourceName){        
        List<StaticResource> resourceList = [
            SELECT Name, NamespacePrefix, SystemModStamp 
            FROM StaticResource 
            WHERE Name = :resourceName
        ];
        if (resourceList.size() == 1) {
            String namespace = resourceList[0].NamespacePrefix;
            return '/resource/' 
                + resourceList[0].SystemModStamp.getTime() + '/' 
                + (namespace != null && namespace != '' ? namespace + '__' : '') 
                + resourceName; 
        } else return '';
    }
    //---Raju start static resource popup here---
    public boolean showImagePopUp{get;set;}
    public boolean showUploadPopUp{get;set;}
    
    public void showActivityImagPopUp(){
        showImagePopUp = true;
    }
    public void showUplodePopUp(){
        showUploadPopUp = true;
    }
    public void closePopUp(){
        showUploadPopUp =false;
        showImagePopUp = false;
    }
    public List<WrapperClass> listWrapper{get;set;}
    public class WrapperClass{
        public string resourceName{get;set;}
        public string resourcurl{get;set;}
        public WrapperClass (string resourceName,string resourcurl){
            this.resourceName= resourceName;
            this.resourcurl= resourcurl;   
        }
    }
    //---End----
    //---Raju Create static resource dynamically here---
    public integer filesize{get;set;}
    public boolean filesizecheck{get;set;}
    public string poptext{get;set;}
    public void createStaticResource(){
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        
        if(fileImage<>null){
            if(filesize>1048576){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Max file size bellow 1Mb'));
                fileImage=null;
            }else{
                if(fileName==null ||fileName==''){
                    fileName=poptext;
                }else{
                    fileName=fileName;
                }    
                MetadataService.StaticResource staticResorceb= new MetadataService.StaticResource();
                staticResorceb.fullName =fileName;
                staticResorceb.contentType = 'image/png';
                staticResorceb.cacheControl = 'public';
                staticResorceb.description='Activity type icon';
                //staticResorceb.nameSpaceprefix='musqotActivity';
                staticResorceb.content = EncodingUtil.base64Encode(fileImage);
                List<MetadataService.SaveResult> results =
                    service.createMetadata(
                        new MetadataService.Metadata[] { staticResorceb});
                
                showUploadPopUp=false;
                string uplodeURL=GetResourceURL(fileName);
                ActivityType.Icon__c=uplodeURL;
                showImg=true;
                filesizecheck=true;
                listWrapper.clear();
                staticresourceLoade();
                fileImage=null;
                staticResorceb.content=null; 
            }
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please choose file..');
            ApexPages.addMessage(myMsg);   
        }
    }
    //---End--
}