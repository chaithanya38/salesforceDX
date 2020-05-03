/********************************************************************
Class Name: MilestoneEditController
Author:G Janardhanreddy         Last modified by: Chaithanya Daggumati
Date: 25/8/2014                 Date: 19/3/2015 
********©2013 Musqot marketing technology Pvt ltd ********************/
public with sharing class MilestoneEditController{
        public String projectid{get;set;}
        public String mileId{get;set;}
        public String subprjid{get;set;}
        public String mrkId{get;set;}
        Public Milestone__c Miles{get;set;}
        public boolean showRec{get;set;}
        public boolean hiderec{get;set;}
        public boolean showEdt{get;set;}
        public boolean showEdtbtn{get;set;}
        public boolean hideTargetNo{get;set;}
    	public boolean hideOutTargetNo{get;set;}
    
        private date startDate;
        private date endDate;
        public musqot__Activity__c actRec{get;set;}
        public boolean erpSetting{get;set;}
        public List<Socialmedia_settings__c> PRO_Temp = new List<Socialmedia_settings__c>();
        public List<ERP_Settings__c> sale_Temp = new List<ERP_Settings__c>();
        public MilestoneEditController(ApexPages.StandardController controller) {
            projectid = ApexPages.currentPage().getParameters().get('planid');
            subprjid = ApexPages.currentPage().getParameters().get('subid');
            mrkId = ApexPages.currentPage().getParameters().get('mrk');
            mileId= ApexPages.currentPage().getParameters().get('mileId');
            String MyProflieName;
            List<Profile> userprofile =new List<Profile>();
            userprofile = [SELECT Id, Name 
                           FROM Profile 
                           WHERE Id=:userinfo.getProfileId() Limit 1];
            MyProflieName = userprofile[0].Name;
            Miles= [select Id,Name, ownerid, Plan__c, Targetdate__c, Target_number__c, Target_number_outcome__c, Project__c, Status__c, Description__c, 
                        Target_Marketing_activity__c, Target_Marketing_activity__r.Name, Target_Project__c, 
                        Target_Project__r.Name ,Target_Socialmedia__c,Target_Socialmedia__r.Name,
                        Target_ERP_Sales__r.Name,Target_ERP_Sales__r.Expression_business_region__c,Target_ERP_Sales__r.Expression_business_area__c ,Milestone_type__c,Target_CRM_settings__r.Watch_type__c,Target_CRM_settings__r.Expression_business_region__c,Target_CRM_settings__r.Expression_business_area__c 
                    from Milestone__c 
                    where id =:mileId];
            if(miles.Milestone_type__c==3||miles.Milestone_type__c==4||miles.Milestone_type__c==5||miles.Milestone_type__c==9)
                hideTargetNo=true; 
            if(miles.Milestone_type__c==9)
                hideOutTargetNo=true; 
            if(mileId<>null && subprjid <>null){
                    try{
                       Subproject__c subPrj = [select Id,Parent_project__c, Project_del__c, planid__c, Project_del__r.id,Ends_date__c,Starts_date__c 
                                               from Subproject__c 
                                               where Id =:subprjid limit 1]; 
                       startDate = subPrj.Starts_date__c;
                       endDate = subPrj.Ends_date__c;  
                    }catch(Exception e){}           
                }
                else{
                    try{
                         musqot__Project__c  proRec=[SELECT Id, Starts_date__c, Ends_date__c 
                                                     FROM Project__c 
                                                     WHERE Id=:projectid LIMIT 1];
                         startDate = proRec.Starts_date__c;
                         endDate = proRec.Ends_date__c;
                    }catch(Exception e){} 
               }           
            if(miles.ownerid==UserInfo.getUserId()|| MyProflieName =='System Administrator'){     
                showEdt=true;
                showEdtbtn=false;  
            }
                showRec=true;
                hiderec=false;
            actRec=[SELECT Id, Name, Use_Performance_CRM__c, Use_socialmedia__c, Use_Performance_ERP__c 
                    FROM Activity__c  LIMIT 1 ]; 
            if(miles.Milestone_type__c==4){         
                if(actRec.musqot__Use_Performance_ERP__c==true){
                    erpSetting=false;
                }else
                    erpSetting=true;
            }
            if(miles.Milestone_type__c==3){         
                if(actRec.musqot__Use_socialmedia__c==true){
                    erpSetting=false;
                }else
                    erpSetting=true;
            }
            if(miles.Milestone_type__c==5){         
                if(actRec.musqot__Use_Performance_CRM__c<>'Not used'){
                    erpSetting=false;
                }else
                    erpSetting=true;
            }
            
            
        }
        /****************************************************************
        Save(): update the milestone and redirects to related parent page
        *****************************************************************/
        public Pagereference Save(){ 
            Pagereference pr;
            if(Miles<>null){ 
                IF( Miles.Targetdate__c > system.today() && Miles.Target_number__c <= Miles.Target_number_outcome__c && Miles.Status__c <> 'Reach delayed'){
                    Miles.Status__c = 'Reach on time';
                }
                else if(Miles.Targetdate__c > system.today() ){
                    Miles.Status__c = 'Open';
                }                    
               if (Milestone__c.sObjectType.getDescribe().isUpdateable()){           
                    Update Miles;
                }
                if(projectid<>null){
                    String tabId = System.currentPageReference().getParameters().get('tabId');
                    string pageRef='/apex/ProjectDetails?id='+EncodingUtil.urlEncode(projectid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb5','UTF-8');
                    pr=new Pagereference (pageRef);
                }
                else if(subprjid<>null){
                    String tabId = System.currentPageReference().getParameters().get('tabId');
                    string pageRef='/apex/SubProject?id='+EncodingUtil.urlEncode(subprjid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb5','UTF-8');
                    pr=new Pagereference (pageRef);
                }           
            }
            return pr;
        }
        Public void gotoEditMode(){ //show record edit mode
            hideTargetNo=false;  
            hideOutTargetNo=false; 
            if(miles.Milestone_type__c==9){
                hideOutTargetNo=true; 
                hideTargetNo=true;
            }
            
            showRec=false;
            hiderec=true;
            showEdt=false;
            showEdtbtn=true; 
            
        }      
        Public void gotoInfoMode(){ // show record edit mode through homw page
            showRec=false;
            hiderec=true;
            showEdt=false;
            showEdtbtn=true; 
         
        } 
        /*************************************************************************************************
        deleteMilestone(): delete milestone from the MilestoneEditpage and redirects to related parent page
        **************************************************************************************************/
        public Pagereference deleteMilestone(){
            if (Milestone__c.sObjectType.getDescribe().isDeletable())
            {  
                delete miles;
            }
            Pagereference pr;
            if(projectid<>null){
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/ProjectDetails?id='+EncodingUtil.urlEncode(projectid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb5','UTF-8');
                pr=new Pagereference (pageRef);
            }
            else if(subprjid<>null){
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/SubProject?id='+EncodingUtil.urlEncode(subprjid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb5','UTF-8');
                pr=new Pagereference (pageRef);
            }
            return pr;
        } 
        /********************************************************
        SocialmediaList: Convert lookup to dropdown 
        *********************************************************/
        public List<SelectOption> SocialMedia  {
            get
            {
                PRO_Temp = [Select u.Name, u.Id From Socialmedia_settings__c u where type__c = 'Milestone'  limit 250 ];
                SocialMedia= new List<SelectOption>(); 
                for(Socialmedia_settings__c objPROT : PRO_Temp )
                {
                    SocialMedia.add(new SelectOption(objPROT.Id, objPROT.Name));
                }
                return SocialMedia;
            }
            set;
        }
      /********************************************************
        ERPList: Convert lookup to dropdown 
        *********************************************************/
        public List<SelectOption> ERPSales  {
            get
            {
                sale_Temp = [Select u.Name, u.Id 
                             From ERP_Settings__c u 
                             where ERP_performance_type__c = 'Milestone'  limit 250 ]; 
                ERPSales = new List<SelectOption>(); 
                for(ERP_Settings__c objPROT2 : sale_Temp )
                {
                    ERPSales.add(new SelectOption(objPROT2.Id, objPROT2.Name));
                }
                return ERPSales;
            }
            set;
        }    
        /****************************************
        Cancel():redirects to related parent page
        *****************************************/
        public Pagereference Cancel(){
            Pagereference pr;
            if(projectid<>null){
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/ProjectDetails?id='+EncodingUtil.urlEncode(projectid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb5','UTF-8');
                pr=new Pagereference (pageRef);
            }
            else if(subprjid<>null){
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/SubProject?id='+EncodingUtil.urlEncode(subprjid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb5','UTF-8');
                pr=new Pagereference (pageRef);
                }       
            return pr;
         }
          // This is for render target number field based on coditions(Milestontype)
        public void selctType(){
            IF(miles.Milestone_type__c==4 ||miles.Milestone_type__c==3||miles.Milestone_type__c==5||miles.Milestone_type__c==9)
                hideTargetNo=true; 
             else
                hideTargetNo=false;  
            
            IF(miles.Milestone_type__c==9)
                hideOutTargetNo=false; 
             else
                hideOutTargetNo=true; 
        }  
      
    }