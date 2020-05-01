/**********************************************************************
Class Name: PurchaseorderEditController
Author:G Janardhanreddy            Last modified by:Raju GN
Date:27/8/2014                     Date:18/2/2015
********©2013 Musqot marketing technology Pvt ltd **********************/
public with sharing class PurchaseorderEditController{
    private String projectid;
    private String purid;
    private String subprjid;
    private String mrkId;
    private String attsid;
    public String maxPO{get;set;}
    private  decimal maxPO2;
    public decimal poOld;
    public String contentType{get;set;}
    public Attachment atts{get;set;}
    Public Purchase_order__c purs{get;set;}
    //public profile usrProfileName{get;set;}
    public task templateInfo {get; set;}
    public boolean showRec{get;set;}
    public boolean showEdt{get;set;}
    public boolean showrec1{get;set;}
    public boolean showbutton{get;set;}
    public string Download{get;set;}
    private Purchase_order__c pursoldCost;
    public string attachmentName{get;set;}
    public List<Purchase_article__c> PA_Temp = new List<Purchase_article__c>();
    public PurchaseorderEditController(ApexPages.StandardController controller) {
        projectid = ApexPages.currentPage().getParameters().get('planid');
        subprjid = ApexPages.currentPage().getParameters().get('prjId');
        mrkId = ApexPages.currentPage().getParameters().get('markID');
        purid = ApexPages.currentPage().getParameters().get('purid');
        maxPO= ApexPages.currentPage().getParameters().get('maxPO'); 
        
        try {
            purs = [Select Id,ownerid, Name, Description__c,Supplier__c,Supplier_email__c,
                    Total_cost__c,Project__c,subproject__c,Marketing_activity__c, 
                    Send_date__c, Purchase_order_name__c, total_Invoice_cost__c,
                    Effective_date__c, Purchase_article__c, Purchase_order_cloesed__c,Purchase_order_send__c 
                    FROM Purchase_order__c  
                    where Id =:purid limit 1];        
        }
        catch (System.QueryException e) {}  
        if(purid<>null){
            try {
                pursoldCost = [Select  Total_cost__c, total_Invoice_cost__c 
                               FROM Purchase_order__c  where Id =:purid limit 1];  
            }
            catch (System.QueryException e) {}  
            if(pursoldCost.Total_cost__c<>null){
                poOld = pursoldCost.Total_cost__c;
            }
            else{
                poOld = 0;
            }
            if(pursoldCost.total_Invoice_cost__c<>null){
                showEdt=false;
            }
        }
        string mainStr = ApexPages.CurrentPage().getParameters().get('retURL');
        atts= attch();
        if(atts<>null){
            if(atts.Name.containsAny('.'))
                attachmentName=atts.Name.substring(0,atts.Name.indexOf('.'));
            else 
                attachmentName=atts.Name;
        }
        showRec=true;
        showEdt=false;
        showRec1=false;
        Download='';
    }
    /*****************************************************************************
attch():This returns the Attachment details belongs to the Purchase order
att:This return the attachment details(Namee,decription etc..)
*****************************************************************************/
    public Attachment attch(){
        Attachment att;
        try{
            att= [SELECT id,ownerid,Name,description,parent.id,
                  parent.name,parent.type,Body,BodyLength,contentType 
                  from Attachment where Parent.id =:purid  limit 1];
        }catch(exception e){}
        
        return att;
    }
    /*****************************************************************
PAList: convert the lookup to dropdown of Purchase articles records.
.******************************************************************/
    public List<SelectOption> PAList
    {
        get
        {
            PA_Temp = [Select u.Name, u.Id From Purchase_article__c u limit 250];
            PAList = new List<SelectOption>(); 
            for(Purchase_article__c temp : PA_Temp)
            {
                PAList.add(new SelectOption(temp.Id, temp.Name));
            }
            return PAList;
        }
        set;
    }
    /************************************************************************************************
Save():Update the purchaseorder record & Insert Attachment & Then redirect to ralated parent page
**************************************************************************************************/
    public Pagereference Save(){ 
        Pagereference pr;
        Decimal maxPO2  = Decimal.valueOf(maxPO);
        try{
            if((maxPO2 - poOld) < purs.Total_cost__c ){
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,' '+ Label.finov_nofounds));
                return null;
            }
        }catch(exception e){}
        if(purs<>null){
            if (Purchase_order__c.sObjectType.getDescribe().isUpdateable())
            {                
                if(purs.Send_date__c==system.today() ){
                    purs.Purchase_order_send__c =purs.Send_date__c;                   
                    Update purs;
                }
                else {
                    Update purs;
                }
            }
            
            Purchase_order__c pOrder = [Select Id,ownerid, Name, Description__c,
                                        Supplier__c,Supplier_email__c, Total_cost__c,Project__c,
                                        subproject__c,Marketing_activity__c, Send_date__c, Purchase_order_name__c,
                                        total_Invoice_cost__c,Effective_date__c, Purchase_article__c, Purchase_order_cloesed__c,Purchase_order_send__c 
                                        FROM Purchase_order__c 
                                        where Id =:purid limit 1];        
            if(pOrder.musqot__Purchase_order_cloesed__c == true && pOrder.musqot__total_Invoice_cost__c == null){
                pOrder.musqot__total_Invoice_cost__c = 0;
                update pOrder;
            }
            
            
            //Attachment Code
            attachment.OwnerId = purs.OwnerId;
            attachment.ParentId = purs.Id; // the record the file is attached to        
            attachment.ContentType=ContentType;
            string extension=MusqotUtility.fileType(contentType);//filetype fetching from utility class.
            if(attachment.body<>null){
                if (Schema.sObjectType.Attachment.fields.body.isCreateable()){
                    attachment.Name = purs.Purchase_order_name__c+extension;
                    if(atts<>null){
                        delete atts;
                    }
                    insert attachment;  
                    atts = attch();
                    
                }                
            }
            
            
            if(projectid<>null){
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/ProjectDetails?id='+EncodingUtil.urlEncode(projectid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('purchase','UTF-8');
                pr=new Pagereference (pageRef);
            }
            else if(subprjid<>null){
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/SubProject?id='+EncodingUtil.urlEncode(subprjid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('purchase','UTF-8');
                pr=new Pagereference (pageRef);
            }
            else if(mrkId<>null){
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/Marketingactivity?id='+EncodingUtil.urlEncode(mrkId,'UTF-8')+'&tab='+EncodingUtil.urlEncode('purchase','UTF-8');
                pr=new Pagereference (pageRef);
            }
            
        }
        return pr;
    }
    /******************************************************
gotoEditMode():show edit mode of Purchase order record
******************************************************/
    Public void gotoEditMode(){ 
        showRec=false;
        showEdt=true;
        
    }
    /******************************************************** 
gotoInfoMode():show detail mode of  Purchase order record
********************************************************/
    Public void gotoInfoMode(){
        showRec=true;
        showEdt=false;
        
    }
    // Create Attachment 
    public Attachment attachment {
        get {
            if (attachment == null)
                attachment = new Attachment();
            return attachment;
        }
        set;
    }
    /*********************************************************************************** 
deleteorders() : Delete the Purchase orders and Then redirect to related parent  page
***************************************************************************************/  
    public Pagereference deleteorders(){
        Pagereference pr;
        if(purs<>null){
            if (Purchase_order__c.sObjectType.getDescribe().isDeletable())
            {
                delete purs;
            }
            if(projectid<>null){
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/ProjectDetails?id='+EncodingUtil.urlEncode(projectid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('purchase','UTF-8');
                pr=new Pagereference (pageRef);
            }
            else if(subprjid<>null){
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/SubProject?id='+EncodingUtil.urlEncode(subprjid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('purchase','UTF-8');
                pr=new Pagereference (pageRef);
            }
            else if(mrkId<>null){
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/Marketingactivity?id='+EncodingUtil.urlEncode(mrkId,'UTF-8')+'&tab='+EncodingUtil.urlEncode('purchase','UTF-8');
                pr=new Pagereference (pageRef);
            }
            
        }
        return pr;
        
    }   
    /****************************************************************************
DeleteAttchment(): delete the Attachments 
/****************************************************************************/
    public void DeleteAttchment(){    
        if (Schema.sObjectType.Attachment.isDeletable())    
        {
            delete atts;
            atts = null;
        }       
    }    
    public String getRedirectToTemplate() {
        return null;
    }
    
    
    public Pagereference redirectToTemplate() {
        try{
            insert templateInfo;
        }catch(Exception e){
            ApexPages.addMessages(e);
        }
        return null;
    }
    /*********************************************
Cancel():redirect to related parent page page
**********************************************/
    public Pagereference Cancel(){
        Pagereference pr;
        if(projectid<>null){
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/ProjectDetails?id='+EncodingUtil.urlEncode(projectid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('purchase','UTF-8');
            pr=new Pagereference (pageRef);
        }
        else if(subprjid<>null){
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/SubProject?id='+EncodingUtil.urlEncode(subprjid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('purchase','UTF-8');
            pr=new Pagereference (pageRef);       
        }
        else if(mrkId<>null){
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/Marketingactivity?id='+EncodingUtil.urlEncode(mrkId,'UTF-8')+'&tab='+EncodingUtil.urlEncode('purchase','UTF-8');
            pr=new Pagereference (pageRef);
        }
        return pr;
    } 
}