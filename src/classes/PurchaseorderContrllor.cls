/****************************************************************
Class Name: PurchaseorderContrllor 
Author:G Janardhanreddy          Last modified by:G janardhanreddy    
Date: 27/8/2014                  Date:20/03/2015
********©2013 Musqot marketing technology Pvt ltd ****************/
public with sharing class PurchaseorderContrllor {
    private ApexPages.StandardController sc;
    public String projectid{get;set;}
    public String subprojectid{get;set;}
    // public String purchaseordersId{get;set;}
    public String markID{get;set;}
    public string contenttype{get;set;}
    public decimal a1{get;set;}
    public string a2{get;set;}
    public string a3{get;set;} 
    public musqot__Purchase_order_setting__c pos{get;set;}
    public integer i; 
    public List<Purchase_article__c> PA_Temp = new List<Purchase_article__c>();
    public Purchase_order__c orders{get;set;}
    public Static Boolean notWildInvoicePurchOrdr;
    public PurchaseorderContrllor (ApexPages.StandardController controller) {
        This.sc = sc; 
        projectid = ApexPages.currentPage().getParameters().get('planid');   
        subprojectid= ApexPages.currentPage().getParameters().get('prjId'); 
        markID=ApexPages.currentPage().getParameters().get('markID');  
        orders= new Purchase_order__c ();
        orders.Project__c= projectid;  
        orders.subproject__c= subprojectid;
        orders.Marketing_activity__c=markID;          
    }
    /***********************************************************************
PAList: convert the lookup to dropdown of Purchase articles records list
************************************************************************/
    public List<SelectOption> PAList
    {
        get
        {
            PA_Temp = [Select u.Name, u.Id From Purchase_article__c u order by u.Name limit 250];
            PAList = new List<SelectOption>(); 
            for(Purchase_article__c temp : PA_Temp)
            {
                PAList.add(new SelectOption(temp.Id, temp.Name));
            }
            return PAList;
        }
        set;
    }
    /**************************************************************
insertOrders():Insert the purchaseorder record & Attachment &
Update the musqot__Purchase_order_setting__c record also
****************************************************************/
    public Pagereference insertOrders(){
        integer i;
        try{
            if (Purchase_order__c.sObjectType.getDescribe().isCreateable())
            {
                notWildInvoicePurchOrdr = true;
                pos=[select id,PO_Startnumber__c,musqot__PO_Lastnumber__c ,musqot__PO_Prefix__c from musqot__Purchase_order_setting__c limit 250];
                if (pos.musqot__PO_Prefix__c!=null||test.isrunningtest()){                
                    a1=pos.musqot__PO_Lastnumber__c+1;
                    a2=pos.musqot__PO_Prefix__c;      
                    a3=a2 +''+''+''+a1;
                    orders.musqot__Purchase_order_name__c=a3; 
                    orders.musqot__Purchase_order_send__c=orders.musqot__Send_date__c;
                }        
                else{
                    a1=pos.musqot__PO_Lastnumber__c+1;
                    a2 =''+a1;
                    orders.musqot__Purchase_order_name__c = a2;
                    orders.musqot__Purchase_order_send__c=orders.musqot__Send_date__c;
                }
                
                insert orders;
                // update Purchase orderd settings. 
                i=[select count() from musqot__Purchase_order__c limit 250];
                if(i==i++){
                    pos=[select id,PO_Startnumber__c,musqot__PO_Lastnumber__c ,musqot__PO_Prefix__c from musqot__Purchase_order_setting__c limit 250];
                    pos.musqot__PO_Lastnumber__c=a1 ;
                    update pos;
                }
                
            }           
            //Attachment Code
            User u = [select Id from user where id=:userinfo.getuserid()];            
            attachment.OwnerId = u.Id;
            attachment.ParentId = orders.Id; 
            attachment.ContentType=contentType;
            if(attachment.ContentType<>null){
            string extension=MusqotUtility.fileType(contentType);//filetype fetching from utility class.
                if (Schema.sObjectType.Attachment.fields.body.isCreateable()){
                    attachment.Name = orders.Purchase_order_name__c+extension;
                    insert attachment;                     
                }                  
            }            
            //Once Purchase order is inserted,sendEmail will be called.If having any attachments of PO,the attachment also sended to supplier.                   
            sendEmail(orders,attachment);
            
            Pagereference PR;
            if(subprojectid<>null){  
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/SubProject?id='+EncodingUtil.urlEncode(subprojectid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('purchase','UTF-8');
                pr=new Pagereference (pageRef);              
            }
            else if(projectid<>null)
            {
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/ProjectDetails?id='+EncodingUtil.urlEncode(projectid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('purchase','UTF-8');
                pr=new Pagereference (pageRef);
            }
            else if(markID<>null)
            {
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/Marketingactivity?id='+EncodingUtil.urlEncode(markID,'UTF-8')+'&tab='+EncodingUtil.urlEncode('purchase','UTF-8');
                pr=new Pagereference (pageRef);
            }
            return PR;
        }
        catch(Exception e){
            return null;
        }
    }
    // Create attachment 
    public Attachment attachment {
        get {
            if (attachment == null)
                attachment = new Attachment();
            return attachment;
        }
        set;
    }
    /******************************************
cancel(): redirect to related parent page.
*******************************************/
    Public Pagereference cancel(){
        
        Pagereference PR;
        if(projectid<>null)
        {
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/ProjectDetails?id='+EncodingUtil.urlEncode(projectid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('purchase','UTF-8');
            pr=new Pagereference (pageRef);
        }
        
        else  if(subprojectid<>null)
        {
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/SubProject?id='+EncodingUtil.urlEncode(subprojectid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('purchase','UTF-8');
            pr=new Pagereference (pageRef);            
        }
        
        else if(markID<>null)
        {
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/Marketingactivity?id='+EncodingUtil.urlEncode(markID,'UTF-8')+'&tab='+EncodingUtil.urlEncode('purchase','UTF-8');
            pr=new Pagereference (pageRef);
        }        
        return PR;
    }
    /******************************************************************
sendEmail(Purchase_order__c orders,Attachment attachment):
This method performs Purchaseorder inserted with attachment Supplier will get the email
orders:In this hold PO record.
attachment:In this hold Attachment of PO record.
/******************************************************************/ 
    
    public void sendEmail(Purchase_order__c orders,Attachment attachment){
        List<Messaging.SingleEmailMessage> SendEmails = new List<Messaging.SingleEmailMessage>(); 
        if(orders.Send_date__c ==System.today() && orders.musqot__Supplier_email__c != null && orders.musqot__Supplier_email__c != ''||test.isRunningTest()){ 
            
            EmailTemplate template = [SELECT Id, name,Subject, HtmlValue, Body FROM EmailTemplate WHERE name= 'Purchaseorder'];
            Contact cnt = new Contact();
            cnt.LastName = 'Supplier';
            cnt.Email = orders.musqot__Supplier_email__c;
            insert cnt;
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setWhatId(orders.Id);
            mail.setTargetObjectId(cnt.Id);
            mail.setTemplateId(template.Id);
            mail.saveAsActivity = false;
            
            if(attachment.body<>null){
                //Set email file attachments
                List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                // Add to attachment file list
                Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                efa.setFileName(attachment.Name);
                efa.setBody(attachment.Body);
                efa.setContentType(attachment.ContentType);
                fileAttachments.add(efa);
                mail.setFileAttachments(fileAttachments);
            }
            //Send email
            SendEmails.add(mail);              
            Messaging.sendEmail(SendEmails); 
            delete cnt;           
        }       
    }
}