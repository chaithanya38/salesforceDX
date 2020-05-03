public with sharing class MileStoneContrllor {
        private ApexPages.StandardController sc;
        public String projectid{get;set;}
        public String subprojectid{get;set;}
        public String mrkId{get;set;}
        public Milestone__c milestone{get;set;}
        public list<Milestone__c> upDatmilestn;
        public List<Socialmedia_settings__c> PRO_Temp = new List<Socialmedia_settings__c>();
        public List<ERP_Settings__c> sale_Temp = new List<ERP_Settings__c>();
        private date startDate;
        private date endDate;
        public musqot__Activity__c actvity{get;set;}
        public boolean hideTargetNo{get;set;}
        public MileStoneContrllor(ApexPages.StandardController controller) {
            This.sc = sc;  
            hideTargetNo=true;   
            projectid = ApexPages.currentPage().getParameters().get('planid');   
            subprojectid= ApexPages.currentPage().getParameters().get('SubId'); 
            mrkId = ApexPages.currentPage().getParameters().get('mrk');
            milestone = new Milestone__c ();
            milestone.Plan__c = projectid;  
            milestone.project__c = subprojectid;     
            milestone.Marketing_activity__c = mrkId; 

            if(projectid <>null && subprojectid<>null||test.isrunningtest()){
                try{
                    Subproject__c subPrj = [select Id, Parent_project__c, Project_del__c, planid__c, Project_del__r.id,Ends_date__c,Starts_date__c 
                                            from Subproject__c 
                                            where Id =:subprojectid limit 1];       
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
            actvity=[SELECT Id, Name, Use_Performance_CRM__c, Use_Performance_ERP__c, Use_socialmedia__c 
                     FROM Activity__c LIMIT 1];
        }    
        /*****************************************************************************
        insertMilestone(): insert newmilestone and redirects to related to parent page
        ******************************************************************************/   
        public Pagereference insertMilestone(){
           
            try{            
                if(milestone.Name <> null && milestone.Targetdate__c <> null){
                    if(Milestone__c.sObjectType.getDescribe().isCreateable()){
                        insert milestone;
                    }
                }else{
            		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter the milestone name and target date'));
            		return null;
        		}
             
            }catch(Exception e){}                               
                Pagereference PR;
                if(subprojectid<>null){
                    String tabId = System.currentPageReference().getParameters().get('tabId');
                    string pageRef='/apex/SubProject?id='+EncodingUtil.urlEncode(subprojectid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb5','UTF-8');
                    pr=new Pagereference (pageRef);                                
                }  
                else if(projectid<>null) {
                    String tabId = System.currentPageReference().getParameters().get('tabId');
                    string pageRef='/apex/ProjectDetails?id='+EncodingUtil.urlEncode(projectid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb5','UTF-8');
                    pr=new Pagereference (pageRef);
                } 
                return PR;
             
              
        }
        /********************************************************
        SocialmediaList: Convert lookup to dropdown 
        *********************************************************/
        public List<SelectOption> SocialMedia{
            get
            {
                PRO_Temp = [Select u.Name, u.Id 
                            From Socialmedia_settings__c u 
                            where type__c = 'Milestone'  limit 250 ];
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
        ERPList:ERP Convert lookup to dropdown 
        *********************************************************/
        public List<SelectOption> ERPSales  {
            get
            {
                sale_Temp = [Select u.Name, u.Id 
                             From ERP_Settings__c u  
                             where ERP_performance_type__c = 'Milestone' limit 250 ]; 
                ERPSales = new List<SelectOption>(); 
                for(ERP_Settings__c objPROT2 : sale_Temp )
                {
                    ERPSales.add(new SelectOption(objPROT2.Id, objPROT2.Name));
                }
                return ERPSales;
            }
            set;
        }
        /********************************************************
        ERPList: CRM Convert lookup to dropdown 
        *********************************************************/
       public List<SelectOption>crmSettingList{
            get
            {
                list<musqot__CRM_settings__c >crmSetting_Temp = [Select u.Name, u.Id 
                                                                 From CRM_settings__c u 
                                                                 where CRM_performance_type__c ='Milestone'  limit 250 ]; 
                crmSettingList= new List<SelectOption>(); 
                for(musqot__CRM_settings__c  objCRM : crmSetting_Temp )
                {
                    crmSettingList.add(new SelectOption(objCRM.Id, objCRM.Name));
                }
                return crmSettingList;
            }
            set;
        }
        /********************************************
        cancel(): redirects to related to parent page
        *********************************************/
        Public Pagereference cancel(){        
            Pagereference PR;        
            if(subprojectid<>null){
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/SubProject?id='+EncodingUtil.urlEncode(subprojectid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb5','UTF-8');
                pr=new Pagereference (pageRef);
            }
            else  if(projectid<>null){
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/ProjectDetails?id='+EncodingUtil.urlEncode(projectid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb5','UTF-8');
                pr=new Pagereference (pageRef);
            }        
            return PR;
        }   
            
        public String getRedirectToTemplate() {
            return null;
        }
        public Milestone__c  templateInfo {get; set;}
        public Pagereference redirectToTemplate() {
            try{
                insert templateInfo;
                
            }catch(Exception e){
                ApexPages.addMessages(e);
            }
            return null;
        }
       
        // This is for render target number field based on coditions(Milestontype)
        public void selctType(){
            IF(milestone.Milestone_type__c==4 ||milestone.Milestone_type__c==3||milestone.Milestone_type__c==5||milestone.Milestone_type__c==9)
                hideTargetNo=true; 
             else
                hideTargetNo=false;   
        }    
    }