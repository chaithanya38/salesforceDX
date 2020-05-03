/************************************************************
Class Name: MusqotAdminPageController 
Author: Nagaraju         Last modified by: Chaithanya daggumati
Date: 23/7/2014          Date: 19/3/2015  
********©2013 Musqot marketing technology Pvt ltd ************/
public with sharing class MusqotAdminPageController {
    public String getObj() {
        return null;
    }
    public Map<String,String> objInfo{get;set;}
    public String objName{get;set;}
    public boolean shwSec{get;set;}
    String tabInFocus;
    String tabId;
    public Boolean showInstallProcess{get;set;}
    public list<FiscalYearSettings> orgFiscaltYearRec;
    public boolean defaultTabShow{get;set;}
    public string fiscalYearURL{get;set;}
    public MusqotAdminPageController (){
        shwSec = false;        
        tabInFocus = System.currentPageReference().getParameters().get('tab');
        Post_Install__c pi = Post_Install__c.getInstance('Amount Approval');
        showInstallProcess = pi.Is_Approval_Crated__c; 
        defaultTabShow=true;
        orgFiscaltYearRec=[SELECT Id, Name, YearType FROM FiscalYearSettings LIMIT 1];
        if(orgFiscaltYearRec.size()==0){
              defaultTabShow=false;
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please defined Fiscal Year according to your organization');
              ApexPages.addMessage(myMsg); 
              
        }
        string s=URL.getSalesforceBaseUrl().toExternalForm();
        fiscalYearURL=s+'/_ui/core/fiscalyear/FiscalYearSetup/d?setupid=ForecastFiscalYear';
     }
    /******************************************
     getTabInFocus(): redirect to paricular tab
    *******************************************/
    public String getTabInFocus() {
        return tabInFocus;
    }
   
    public void setTabInFocus(String s ) {
        this.tabInFocus = s;
    }
    /*************************************
     getObjNames():  getting  object names 
    **************************************/
    public Map<String,String> getObjNames(){
        objInfo =  new Map<String,String>();        
        objInfo.put('Project__c','Plan');
        objInfo.put('Subproject__c','Project');    
        objInfo.put('Workspace__c','Workspaces');
        objInfo.put('Marketing_activity__c','Marketing activity');
        objInfo.put('Members__c','Members');
        objInfo.put('Task','Tasks');
        objInfo.put('createApprovalProcess','createApprovalProcess');
        return objInfo;
    }
    /***************************************
     showRecords():  show the object records  
    ****************************************/
    public pageReference showRecords(){
        if(objName==null){
            objName = 'Project_type__c';    
        }
        else{
            objName = ApexPages.currentPage().getParameters().get('oName');
        }
        shwSec = true;
        return null;    
        }
    Public PageReference redirectToMusqotFiscalYearPage(){
        string s=URL.getSalesforceBaseUrl().toExternalForm();
        PageReference pageRef= new PageReference(s+'/_ui/core/fiscalyear/FiscalYearSetup/d?setupid=ForecastFiscalYear');
        pageRef.setredirect(true);
        return pageRef;
    }    
    }