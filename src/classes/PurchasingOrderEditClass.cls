/******************************************************************
Class Name: PurchasingOrderEditClass 
Author: chaithanya daggumati    Last modified by: G Janardhanreddy
Date: 16/7/2014                 Date:24/03/2015
********©2013 Musqot marketing technology Pvt ltd *****************/

public with sharing class PurchasingOrderEditClass {
    Public Purchase_order_setting__c pos{get;set;}
   // Public Purchase_order_setting__c pos2{get;set;}
    Public list<Purchase_order_setting__c> oldposlist;
    //Public String Pageid{get;set;}
    public string insertId ='';
    public boolean showRec{get;set;}
    public boolean showEdt{get;set;}
    public string posid{get;set;}
    //public String contentType {get; set;}
    //public String fileType {get;set;}
    public PurchasingOrderEditClass(ApexPages.StandardController controller)
    {
        pos= new Purchase_order_setting__c();
        posid= ApexPages.currentPage().getParameters().get('posid');
        try{
            pos=[SELECT id,Name,PO_Startnumber__c,PO_Prefix__c,PO_Autoprefix__c,PO_External__c,PO_Lastnumber__c FROM Purchase_order_setting__c  limit 1];
        } catch(Exception e){}
        string mainStr = ApexPages.CurrentPage().getParameters().get('retURL');
        showRec=true;
        showEdt=false;
    }
    /*****************************************************************************
    Save(): insert  Purchaseordersetting records  and redirects to MusqotAdminPage
    ******************************************************************************/
    Public PageReference Save(){        
        if(pos==null||pos.Id==null){
            if (Purchase_order_setting__c.sObjectType.getDescribe().isUpdateable()){
                pos.musqot__PO_Lastnumber__c = pos.musqot__PO_Startnumber__c;                
                insert pos;                   
            }
        }
        else if (Purchase_order_setting__c.sObjectType.getDescribe().isUpdateable()){
            oldposlist= new list<Purchase_order_setting__c>();
            oldposlist=[SELECT id,Name,PO_Startnumber__c,PO_Prefix__c,PO_Autoprefix__c,PO_External__c,PO_Lastnumber__c FROM Purchase_order_setting__c  limit 1];
            // checking startnumber is change or not 
            if(pos.musqot__PO_Startnumber__c==oldposlist[0].musqot__PO_Startnumber__c )
            {
                Decimal lstNum = pos.musqot__PO_Lastnumber__c;
                oldposlist[0].musqot__PO_Startnumber__c=pos.musqot__PO_Startnumber__c;
                oldposlist[0].musqot__PO_Prefix__c=pos.musqot__PO_Prefix__c;
                oldposlist[0].musqot__PO_Autoprefix__c=pos.musqot__PO_Autoprefix__c ;
                oldposlist[0].musqot__PO_External__c=pos.musqot__PO_External__c; 
            }
            
            else if(pos.musqot__PO_Startnumber__c!=oldposlist[0].musqot__PO_Startnumber__c)
            {
                oldposlist[0].musqot__PO_Startnumber__c=pos.musqot__PO_Startnumber__c;
                oldposlist[0].musqot__PO_Prefix__c=pos.musqot__PO_Prefix__c;
                oldposlist[0].musqot__PO_Autoprefix__c=pos.musqot__PO_Autoprefix__c ;
                oldposlist[0].musqot__PO_Lastnumber__c = pos.musqot__PO_Startnumber__c - 1;
                oldposlist[0].musqot__PO_External__c=pos.musqot__PO_External__c; 
            }
            update oldposlist;
        }
        showRec=true;
        showEdt=false;       
        showRec=true;
        showEdt=false;
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('pursett','UTF-8');
        PageReference pg=new PageReference (pageRef);
        return pg;        
    } 
    /********************************************************
    gotoEditMode():  show edit mode  Purchaseordersettingrecords 
    *********************************************************/  
    Public void gotoEditMode(){        
        showRec=false;
        showEdt=true;        
    }
    /****************************************************
    gotoInfoMode(): show infomode of Purchaseordersetting 
    *****************************************************/  
    Public PageReference gotoInfoMode(){        
        showRec=true;
        showEdt=false;
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('pursett','UTF-8');
        PageReference pg=new PageReference (pageRef);
        return pg;       
    }
    /*************************************
    Cancel(): redirects to MusqotAdminPage 
    **************************************/ 
    Public PageReference Cancel(){
        String tabId = System.currentPageReference().getParameters().get('tabId');
        string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('pursett','UTF-8');
        PageReference pg=new PageReference (pageRef);
        return pg;
    }    
}