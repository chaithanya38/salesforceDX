/******************************************************************
Class Name: InvoiceController
Author:G Janardhanreddy            Last modified by: G Janardhanreddy
Date:27/8/2014                     Date:19/03/2015
********©2013 Musqot marketing technology Pvt ltd ******************/

public with sharing class InvoiceController {
    private ApexPages.StandardController sc;
    public String projectid{get;set;}
    public String markID{get;set;}
    public String subprojectid{get;set;}
    public Invoice__c invoices{get;set;}
    public Purchase_order__c objPO{get;set;}
    List<Purchase_order__c> objPO1;
    public string contenttype{get;set;}
    public string seeData{get;set;}
    public String selectedPO{get;set;}
    public string invPO;
    public boolean requrrd{get;set;}
    public boolean poRec{get;set;}
    public boolean hideValues{get;set;}
    public list<string> poWild;
    public string POdisp; 
    List<SelectOption> PoList1 =new List<SelectOption>();
    public List<Purchase_article__c> PA_Temp = new List<Purchase_article__c>();    
    public List<Purchase_order__c> Po_Temp = new List<Purchase_order__c>();
    List<SelectOption> PoList = new List<SelectOption>();
    public Boolean closePO{get;set;}
    public InvoiceController (ApexPages.StandardController controller){
        requrrd=true;
        poRec=false;
        hideValues = true;
        This.sc = sc;    
        projectid = ApexPages.currentPage().getParameters().get('planid');   
        subprojectid= ApexPages.currentPage().getParameters().get('prjId'); 
        markID=ApexPages.currentPage().getParameters().get('markID');   
        invoices= new Invoice__c ();
        invoices.Project__c= projectid;  
        invoices.subproject__c= subprojectid;
        invoices.Marketing_activity__c=markID;      
    }
    /***************************************************************************************************************
    insertinvoic():insert Invoice,Attachment and  Update Purchase orders records  and redirect to related parent page
    *****************************************************************************************************************/        
    public Pagereference insertinvoic(){
        string poPre;
        decimal poLast;
        string poName;
        if(Invoice__c.sObjectType.getDescribe().isCreateable())
        { 
            if(seeData=='SelectPO'){
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,' '+ Label.pur_Purchase_order_closed));
                return null;
            }
            if(seeData!='Wildinvoice'){
               Purchase_order__c sPO=new Purchase_order__c();
                try{
                    sPO= [Select  Id ,musqot__total_Invoice_cost__c,Purchase_order_cloesed__c,Total_cost__c  from Purchase_order__c where Project__c=:projectid AND musqot__subproject__c=:subprojectid  AND musqot__Marketing_activity__c=:markID and id=:seedata LIMIT 1];
                }catch(exception e){}
                
                hideValues=true; 
                invoices.musqot__Purchase_orders__c=sPO.Id;
                insert invoices;               
                if(invoices.musqot__Total_spent__c!=null){
                    
                    objPO =new Purchase_order__c();
                    objPO= [Select  Id ,musqot__total_Invoice_cost__c,musqot__Purchase_order_cloesed__c,musqot__Total_cost__c  from Purchase_order__c where Project__c=:projectid AND musqot__subproject__c=:subprojectid  AND musqot__Marketing_activity__c=:markID and id=:seedata limit 1];//invoices.Purchase_orders__c limit 1
                    if(closePO){
                        objPO.musqot__Purchase_order_cloesed__c=closePO;
                    }
                    
                    if(objPO.total_Invoice_cost__c==0){
                        objPO.total_Invoice_cost__c=0;
                        objPO.total_Invoice_cost__c += invoices.Total_spent__c;
                    }
                    else if(objPO.total_Invoice_cost__c!=0){    
                        objPO.total_Invoice_cost__c += invoices.Total_spent__c;
                        if(objPO.musqot__Total_cost__c <= invoices.musqot__Total_spent__c ||objPO.total_Invoice_cost__c <=invoices.musqot__Total_spent__c){ 
                            objPO.musqot__Purchase_order_cloesed__c=closePO;
                        }
                    }
                    update objPO;
                }
                
            } 
            else if(seeData=='Wildinvoice'){
               musqot__Purchase_order_setting__c pos=new musqot__Purchase_order_setting__c ();
               try{
                pos=[select id,PO_Startnumber__c,musqot__PO_Lastnumber__c ,musqot__PO_Autoprefix__c,musqot__PO_Prefix__c from musqot__Purchase_order_setting__c limit 500 ];
                poLast=pos.musqot__PO_Lastnumber__c+1;
                poPre=pos.musqot__PO_Autoprefix__c;
                pos.musqot__PO_Lastnumber__c = poLast;
                update pos;                
                }catch(exception e){               
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Create Purchase order'));
                    return null;
                } 
                Purchase_order__c objPUR=new Purchase_order__c ();
                objPUR.Name=invoices.Name;
                objPUR.musqot__Purchase_order_name__c='Wild_Inv_'+poLast;
                objPUR.musqot__Purchase_order_cloesed__c=true;
                objPUR.musqot__Description__c=invoices.Description__c;
                objPUR.Purchase_article__c=invoices.Purchase_article__c;
                objPUR.musqot__Supplier__c=invoices.supplier__c;
                objPUR.musqot__Total_cost__c=invoices.Total_spent__c; 
                objPUR.musqot__total_Invoice_cost__c=invoices.Total_spent__c;
                if(invoices.musqot__Project__c<>null||test.isrunningtest()){
                      objPUR.musqot__Project__c=invoices.musqot__Project__c;
                  }
                if(invoices.musqot__subproject__c<>null||test.isrunningtest()){  
                  objPUR.musqot__subproject__c=invoices.musqot__subproject__c;
                  }
                if(invoices.musqot__Marketing_activity__c<>null||test.isrunningtest()){  
                  objPUR.musqot__Marketing_activity__c=invoices.musqot__Marketing_activity__c;
                  }
                insert objPUR;
                
                invoices.musqot__Purchase_orders__c=objPUR.id;
                insert invoices;
                
               if(invoices.musqot__Total_spent__c!=null ){
              //      objPO1 = [Select  Id ,musqot__total_Invoice_cost__c,musqot__Purchase_order_cloesed__c,musqot__Total_cost__c  from Purchase_order__c limit 500];
                    
                    //List<Purchase_order__c> objPOUpdate = new List<Purchase_order__c>();
                   // for(Purchase_order__c PO : objPO1){
                        objPUR.musqot__total_Invoice_cost__c=invoices.Total_spent__c;
                            //PO.musqot__total_Invoice_cost__c=invoices.Total_spent__c;
                            //objPOUpdate.add(PO);                          
                          // }
                    }
                  //  if(objPUR.size() > 0)
                        update objPUR;
              //  }  
               
            }
            User u = [select Id from user where id=:userinfo.getuserid()];
            attachment.OwnerId = u.Id;
            attachment.ParentId = invoices.Id; 
            attachment.ContentType=contentType;
           //filetype fetching from utility class.
            if(attachment.body<>null){
                 string extension=MusqotUtility.fileType(contentType);
                if (Schema.sObjectType.Attachment.fields.body.isCreateable()){
                    attachment.Name = invoices.supplier__c+invoices.Name+extension;
                    insert attachment; 
                    attachment.Body=null;
                }               
            }                  
            Pagereference PR;
            if(subprojectid<>null){
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/SubProject?id='+EncodingUtil.urlEncode(subprojectid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('inv','UTF-8');
                pr=new Pagereference (pageRef);                 
            }  
            else if(projectid<>null) {
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/ProjectDetails?id='+EncodingUtil.urlEncode(projectid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('inv','UTF-8');
                pr=new Pagereference (pageRef);
            }
            else if(markID<>null){
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/Marketingactivity?id='+EncodingUtil.urlEncode(markID,'UTF-8')+'&tab='+EncodingUtil.urlEncode('inv','UTF-8');
                pr=new Pagereference (pageRef);
                
            }
            return PR;
            
        }
        return null;    
    }
    /***************************************
    cancel():redirect to related parent page
    ****************************************/  
    Public Pagereference cancel(){
        Pagereference PR;
        if(subprojectid<>null){
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/SubProject?id='+EncodingUtil.urlEncode(subprojectid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('inv','UTF-8');
            pr=new Pagereference (pageRef);
        }
        else  if(projectid<>null){
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/ProjectDetails?id='+EncodingUtil.urlEncode(projectid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('inv','UTF-8');
            pr=new Pagereference (pageRef);
        }
        else if(markID<>null){
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/Marketingactivity?id='+EncodingUtil.urlEncode(markID,'UTF-8')+'&tab='+EncodingUtil.urlEncode('inv','UTF-8');
            pr=new Pagereference (pageRef);
        }
        return PR;
        
    }
   
    public Attachment attachment {//insert the attachment
        get {
            if (attachment == null)
                attachment = new Attachment();
            return attachment;
        }
        set;
    }
    /*********************************************************************
    PAList: convert lookup to drop down list of Purchase_article__c records
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
    /***********************************************************************
    getPoList():convert the lookup to dropdown list of Purchase order records
    *************************************************************************/  
    public List<SelectOption> getPoList(){
        Po_Temp = [Select Name, Id ,Purchase_order_cloesed__c,Purchase_order_name__c From Purchase_order__c where Project__c=:projectid AND musqot__subproject__c=:subprojectid  AND musqot__Marketing_activity__c=:markID Limit 250];
        List<SelectOption> PoList = new List<SelectOption>(); 
        PoList.add(new SelectOption('SelectPO', Label.inv_Select_PO)); 
        PoList.add(new SelectOption('Wildinvoice', Label.inv_Wild_invoice));
        
        for(Purchase_order__c temp : Po_Temp){
            
            if(temp.Purchase_order_cloesed__c ==false)
                PoList.add(new SelectOption(temp.Id, temp.Purchase_order_name__c + ', ' + temp.Name));           
        }
        return PoList;
    }
    /******************************************************** 
    poDetailMethod():This is for To Get the po value based on select po dropdowen value  while page loade
    ********************************************************/  
    public pageReference poDetailMethod(){
        requrrd=false;
        poRec=true;
        hideValues = true;      
        objPO=new Purchase_order__c ();        
        if(seeData=='SelectPO'){
            invoices.supplier__c='';
            invoices.Description__c='';
            invoices.musqot__Purchase_article__c=objPO.Purchase_article__c;
            hideValues = false;    
        }        
        if(seeData!='Wildinvoice'){
            try{
                objPO=[Select Name, Id ,musqot__Total_cost__c,musqot__total_Invoice_cost__c,musqot__Purchase_order_cloesed__c,musqot__Description__c,musqot__Supplier__c,Purchase_article__c from Purchase_order__c where Project__c=:projectid AND musqot__subproject__c=:subprojectid  AND musqot__Marketing_activity__c=:markID and id=:seedata limit 1];//invoices.Purchase_orders__c                
                invoices.supplier__c=objPO.musqot__Supplier__c;
                invoices.Description__c=objPO.musqot__Description__c;
                invoices.musqot__Purchase_article__c=objPO.Purchase_article__c;
                requrrd=true;
            }catch(exception e){}
            return null;
        }else{
            invoices.supplier__c='';
            invoices.Description__c='';
            invoices.musqot__Purchase_article__c=null;
            requrrd=true;
            poRec=false;
            return null;      
        }   
    }       
}