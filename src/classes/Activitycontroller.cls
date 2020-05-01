/***********************************************************
Class Name: Activitycontroller
Author:Nagaraju G           Last modified by:Raju GN
Date: 14/7/2014             Date:18/03/2015
Description:Adding select and uploade links with popupwindow 
********©2013 Musqot marketing technology Pvt ltd ***********/
public with sharing class Activitycontroller {
    public Activitytype__c act{get;set;}
    Transient Map<string,Schema.FieldSet> FsMap ;
    public string actid{get;set;}
    public boolean showMassge{get;set;}
    public string fileName{get;set;}
    public blob fileImage{get;set;}
    public integer filesize{get;set;}
    public list<StaticResource>StaticResourceList{get;set;}
    public Activitycontroller(ApexPages.StandardController controller){
        FsMap = new Map<string,Schema.FieldSet>();
        listWrapper = new List<WrapperClass>();
        StaticResourceList=new list<StaticResource>();
        actid=ApexPages.currentPage().getParameters().get('id');
        try{
            act=[SELECT id,Name,Icon__c,Bar_color__c,F__c from Activitytype__c where id=:actid];
        }catch(DmlException e){}
        showMassge=false;
        showImagePopUp =false; 
        showUploadPopUp=false;
        staticresourceLoade();
    }
    //--Raju to loade static resource records--
    public void staticresourceLoade(){
        StaticResourceList=[SELECT Id,Name,NamespacePrefix,SystemModstamp,ContentType 
                            FROM StaticResource where Description='Activity type icon'
                            OR NamespacePrefix='musqotActivity'limit 250];
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
            fieldSetListTmp .add(new SelectOption('','-None-'));
            for(Schema.FieldSet fldSet : FsMap.values()){                 
                fieldSetListTmp.add(new SelectOption(fldSet .getName(),fldSet.getLabel())); 
            }
            if(fieldSetListTmp.isEmpty()){
                fieldSetListTmp .add(new SelectOption('','--None--')); 
            }
            return fieldSetListTmp ;
        }
        set;
    } 
    
    /***********************************************************************
save():update the Activitytypes records and redirect to  MusqotAdminPage
*************************************************************************/
    public Pagereference Save()
    { 
        if (Activitytype__c.sObjectType.getDescribe().isUpdateable())
        {
            try{ 
                Update act;
            }catch(DmlException e){}
        }
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('mar','UTF-8');
        Pagereference pg=new Pagereference (pageRef);
        return pg;
    }
    public Pagereference Cancel()//redirect to  MusqotAdminPage 
    {
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('mar','UTF-8');
        Pagereference pg=new Pagereference (pageRef);
        return pg;
    } 
    public List<Activitytype__c>getActivityImages(){
        return[Select id,name,Icon__c,Bar_color__c, F__c from Activitytype__c
               order by name limit 20];
    }
    
    //---Raju added activity immage popup here---
    
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
    public void selectActivityImage(){
        String clickedImage= ApexPages.CurrentPage().getParameters().get('imgeID');
        act.Icon__c=clickedImage;
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
    //--Raju--Create Static Resource dynamically here--
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
                }
                else{
                    fileName=fileName;
                } 
                MetadataService.StaticResource staticResorceb= new MetadataService.StaticResource();
                staticResorceb.fullName =fileName;
                staticResorceb.contentType = 'image/png';
                staticResorceb.cacheControl = 'public';
                staticResorceb.description='Activity type icon';
                staticResorceb.content = EncodingUtil.base64Encode(fileImage);
                List<MetadataService.SaveResult> results =
                    service.createMetadata(
                        new MetadataService.Metadata[] { staticResorceb});
                StaticResource statiRec=[SELECT Id,Name,NamespacePrefix,SystemModstamp,ContentType 
                                         FROM StaticResource where Name=:fileName limit 1];
                string namespaceprfix=statiRec.NamespacePrefix;
                Datetime systemmodestmp=statiRec.SystemModstamp; 
                act.Icon__c='/resource/' 
                    +systemmodestmp.getTime() + '/' 
                    + (namespaceprfix != null && namespaceprfix != '' ? namespaceprfix + '__' : '') 
                    + fileName;
                
                showUploadPopUp =false;
                listWrapper.clear();
                staticresourceLoade(); 
                staticResorceb.content=null; 
                fileImage=null;
            }
        }else{
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Please choose file..');
            ApexPages.addMessage(myMsg);   
        }
    }
    //---End---
}