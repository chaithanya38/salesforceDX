/*****************************************************************
Class Name: costcentereditcls
Author:Chaithanya daggumati                   Last modified by:Chaithanya daggumati
Date :24/11/2015                           	  Date :24/11/2015                    
********©2013 Musqot marketing technology Pvt ltd *****************/
public with sharing class costcentereditcls {
    public List<Costcentre__c> costcent{get;set;}
    Public String costid;
	public List<socialmedia_settings__c> SocialFilter_Temp = new List<socialmedia_settings__c>();
    public List<ERP_Settings__c> ERPFilter_Temp = new List<ERP_Settings__c>();
    public List<CRM_Settings__c> CRMFilter_Temp = new List<CRM_Settings__c>();    
    public costcentereditcls(ApexPages.StandardController controller) {
        costcent = new  List<Costcentre__c>();
        costid=ApexPages.currentPage().getParameters().get('cosid');
        costcent=[SELECT Id, Name,Status__c,StatusImage__c,CRM__c,ERP__c,Social_media__c, 
                       cc_Owner__c,Description__c FROM Costcentre__c WHERE Id=:costid LIMIT 1];
            
    }    
    /******************************************************************
     SocialFilter(): insert the social performance 
    ********************************************************************/
    public List<SelectOption> SocialFilter{
        get
        {
            SocialFilter_Temp = [Select u.Name, u.Id From socialmedia_settings__c u where type__c='Performance, costcenter' limit 250];
            SocialFilter= new List<SelectOption>(); 
            for(Socialmedia_settings__c objSocialFilter: SocialFilter_Temp )
            {
                SocialFilter.add(new SelectOption(objSocialFilter.Id, objSocialFilter.Name));
            }  
              
            return SocialFilter;
        }
        set;
    }
     public String[] SocialItems { 
     get {
        String[] selected = new List<String>();
        List<SelectOption> sos = this.SocialFilter;
        for(SelectOption s : sos) {
        if (this.costcent[0].Social_media__c!=null && this.costcent[0].Social_media__c.contains(s.getValue()))
           selected.add(s.getValue());
        }
        return selected;
     }public set {
        String selectedConcat = '';
        for(String s : value) {
         if (selectedConcat == '') 
           selectedConcat += s;
         else selectedConcat += ';' + s;
        }
        costcent[0].Social_media__c= selectedConcat;
     }
   } 

    /******************************************************************
     ERPFilter(): insert the erp settings
    ********************************************************************/
    public List<SelectOption> ERPFilter{
        get
        {
            ERPFilter_Temp = [Select u.Name, u.Id From ERP_Settings__c u where ERP_Performance_type__c='Performance, costcenter' limit 250];
            ERPFilter= new List<SelectOption>(); 
            for(ERP_Settings__c objERPFilter: ERPFilter_Temp )
            {
                ERPFilter.add(new SelectOption(objERPFilter.Id, objERPFilter.Name));
            } 
           
            return ERPFilter;
        }
        set;
    }
     public String[] ERPItems { 
     get {
        String[] selected = new List<String>();
        List<SelectOption> sos = this.ERPFilter;
        for(SelectOption s : sos) {
        if (this.costcent[0].ERP__c!=null && this.costcent[0].ERP__c.contains(s.getValue()))
           selected.add(s.getValue());
        }
        return selected;
     }public set {
        String selectedConcat = '';
        for(String s : value) {
         if (selectedConcat == '') 
           selectedConcat += s;
         else selectedConcat += ';' + s;
        }
        costcent[0].ERP__c= selectedConcat;
     }
   } 

    /******************************************************************
     CRMFilter(): insert the crm settings 
    ********************************************************************/
    public List<SelectOption> CRMFilter{
        get
        {
            CRMFilter_Temp = [Select u.Name, u.Id From CRM_Settings__c u where CRM_Performance_type__c='Performance, costcenter' limit 250];
            CRMFilter= new List<SelectOption>(); 
            for(CRM_Settings__c objCRMFilter: CRMFilter_Temp )
            {
                CRMFilter.add(new SelectOption(objCRMFilter.Id, objCRMFilter.Name));
            }  
          
            return CRMFilter;
        }
        set;
    }
    public String[] CRMItems { 
     get {
        String[] selected = new List<String>();
        List<SelectOption> sos = this.CRMFilter;
        for(SelectOption s : sos) {
        if (this.costcent[0].CRM__c!=null && this.costcent[0].CRM__c.contains(s.getValue()))
           selected.add(s.getValue());
        }
        return selected;
     }public set {
        String selectedConcat = '';
        for(String s : value) {
         if (selectedConcat == '') 
           selectedConcat += s;
         else selectedConcat += ';' + s;
        }
        costcent[0].CRM__c= selectedConcat;
     }
   }
   /**************************************************************
    updcc(): update the paln and redirects to ProjectDetails page
    ***************************************************************/
    public PageReference updcc(){       
        if(Costcentre__c.sObjectType.getDescribe().isUpdateable()){
            update costcent;
        }        
        Pagereference PR;
        PR = new Pagereference('/apex/Costcenterdetail?id='+EncodingUtil.urlEncode(costid,'UTF-8'));                  
        return PR ;             
    }
    /*****************************************
    cancel(): redirects to ProjectDetails page  
    ******************************************/
    public PageReference cancel(){
        Pagereference PR;
        PR = new Pagereference('/apex/Costcenterdetail?id='+EncodingUtil.urlEncode(costid,'UTF-8'));                  
        return PR ;
    }
}