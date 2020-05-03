/**************************************************************
Class Name: InvoiceEditController
Author:G Janardhanreddy         Last modified by:Raju GN    
Date:27/8/2014                  Date:18/12/2015
********©2013 Musqot marketing technology Pvt ltd *************/
public with sharing class InvoiceEditController{
    public String projectid{get;set;}
    public String invid{get;set;}
    public String subprjid{get;set;}
    public String mrkId{get;set;}
    public boolean showRec{get;set;}
    public boolean showEdt{get;set;}         
    public Attachment atts{get;set;}
    Public Invoice__c invs{get;set;}
    private Invoice__c myChild;
    public string Download{get;set;}
    public string contentType{get;set;}
    public Purchase_order__c objPO{get;set;}
    public boolean validshowRec{get;set;}
    public List<Purchase_article__c> PA_Temp = new List<Purchase_article__c>();  
    
    public InvoiceEditController(ApexPages.StandardController controller) {
        this.myChild = (Invoice__c)controller.getRecord();
        projectid = ApexPages.currentPage().getParameters().get('planid');
        subprjid = ApexPages.currentPage().getParameters().get('prjid');
        mrkId = ApexPages.currentPage().getParameters().get('markID');
        invid = ApexPages.currentPage().getParameters().get('invid');
        
        // Fetch PO to identify if its a vaild or a Wild Invoice   
        try{
            invs= [Select Id,ownerid, Name, Description__c, Marketing_activity__c,Project__c,
                   Purchase_orders__c,Purchase_article__c,Purchase_orders__r.Purchase_order_name__c,
                   Purchase_orders__r.total_Invoice_cost__c,Purchase_orders__r.Purchase_order_cloesed__c, 
                   subproject__c,Purchase_orders__r.musqot__Total_cost__c,Total_spent__c,
                   supplier__c FROM Invoice__c  where Id =:invid limit 1];        
            string name = invs.Purchase_orders__r.Purchase_order_name__c;
            If(name.substringBeforeLast('_')!='Wild_Inv'){
                validshowRec=true;
            }
        }
        catch (System.QueryException e) {}
        
        string mainStr = ApexPages.CurrentPage().getParameters().get('retURL');
        atts= attch();
        showRec=true;
        showEdt=false;
        //showRec1=false;
        Download='';
    }
    /***************************************
attch():Insert the Attachment of Invoice
/***************************************/   
    public Attachment attch(){
        Attachment att;
        try{
            att= [SELECT id,ownerid,Name,description,parent.id, parent.name,
                  parent.type,Body,BodyLength,contentType from Attachment where Parent.id =:invid limit 1];
        }catch(exception e){}
        
        return att;
    }
    /**************************************** 
gotoEdit():This is for to go to inputmode
*****************************************/        
    Public void gotoEdit(){        
        showRec=false;
        showEdt=true;        
    }
    /*********************************************************************************************
Save():This is for Update Invoicerecords, Update Purchase orders records and Insert Attachment 
**********************************************************************************************/        
    public Pagereference Save(){ 
        Pagereference pr;
        if(invs<>null){
            if(Invoice__c.sObjectType.getDescribe().isUpdateable()){
                if(invs.musqot__Total_spent__c >invs.Purchase_orders__r.Total_cost__c)
                {    
                    invs.Purchase_orders__r.Purchase_order_cloesed__c=true;
                    Purchase_order__c purOrdr = new Purchase_order__c();
                    purOrdr = [SELECT Id,Purchase_order_cloesed__c FROM Purchase_order__c
                               WHERE Id =:invs.musqot__Purchase_orders__c];  
                    if(purOrdr != null){
                        purOrdr.Purchase_order_cloesed__c = true;
                        update purOrdr;
                    }
                }
                Update invs;
            }
            //Attachment Code
            attachment.OwnerId = invs.OwnerId;
            attachment.ParentId = invs.Id;        
            attachment.ContentType=ContentType;
            string extension=MusqotUtility.fileType(contentType);//filetype fetching from utility class.
            if(attachment.body<>null){
                if (Schema.sObjectType.Attachment.fields.body.isCreateable()){
                    attachment.Name = invs.supplier__c+invs.Name+extension;
                    
                    if(atts<>null){
                        delete atts;
                    }                    
                    insert attachment;  
                    atts = attch();                    
                }                
            }
            
            if(projectid<>null){
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/ProjectDetails?id='+EncodingUtil.urlEncode(projectid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('inv','UTF-8');
                pr=new Pagereference (pageRef);
            }
            else if(subprjid<>null){
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/SubProject?id='+EncodingUtil.urlEncode(subprjid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('inv','UTF-8');
                pr=new Pagereference (pageRef);
            }
            else if(mrkId<>null){
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/Marketingactivity?id='+EncodingUtil.urlEncode(mrkId,'UTF-8')+'&tab='+EncodingUtil.urlEncode('inv','UTF-8');
                pr=new Pagereference (pageRef);
            }
            
        }
        return pr;
    }
    /******************************************************************** 
PAList: convert lookup to drop down list of Purchase_article__c recors
**********************************************************************/  
    public List<SelectOption> PAList 
    {
        get
        {   
            PA_Temp = [Select u.Name, u.Id From Purchase_article__c u   limit 250];
            PAList = new List<SelectOption>(); 
            for(Purchase_article__c temp : PA_Temp)
            {
                PAList.add(new SelectOption(temp.Id, temp.Name));
            }
            return PAList;
        }
        set;
    }
    /******************************************************************************** 
deleteinvoice(): delete the selected invoic record & Redirect related parent page
*********************************************************************************/  
    public Pagereference deleteinvoice(){
        if (Invoice__c.sObjectType.getDescribe().isDeletable()){
            try{ 
                delete invs;
            }catch(exception e){}  
        }
        Pagereference pr;
        if(projectid<>null){
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/ProjectDetails?id='+EncodingUtil.urlEncode(projectid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('inv','UTF-8');
            pr=new Pagereference (pageRef);
            
        }
        else if(subprjid<>null){
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/SubProject?id='+EncodingUtil.urlEncode(subprjid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('inv','UTF-8');
            pr=new Pagereference (pageRef);
        }
        else if(mrkId<>null){
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/Marketingactivity?id='+EncodingUtil.urlEncode(mrkId,'UTF-8')+'&tab='+EncodingUtil.urlEncode('inv','UTF-8');
            pr=new Pagereference (pageRef);
        }
        
        return pr;
        
    }
    
    public Attachment attachment {
        get {
            if (attachment == null)
                attachment = new Attachment();
            return attachment;
        }
        set;
    }  
    /******************************************
cancel(): Redirect to related parent  page.
*******************************************/  
    public Pagereference Cancel(){
        Pagereference pr;
        if(projectid<>null){
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/ProjectDetails?id='+EncodingUtil.urlEncode(projectid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('inv','UTF-8');
            pr=new Pagereference (pageRef);
        }
        else if(subprjid<>null){
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/SubProject?id='+EncodingUtil.urlEncode(subprjid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('inv','UTF-8');
            pr=new Pagereference (pageRef);
        }
        else if(mrkId<>null){
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/Marketingactivity?id='+EncodingUtil.urlEncode(mrkId,'UTF-8')+'&tab='+EncodingUtil.urlEncode('inv','UTF-8');
            pr=new Pagereference (pageRef);
        }
        return pr;
    }
    /***********************************
DeleteAttchment():delete aatachments
************************************/  
    public void DeleteAttchment(){
        if (Schema.sObjectType.Attachment.isDeletable())            
        { try{
            delete atts;
        }catch(exception e){}
         atts = null;
        }
    }
}