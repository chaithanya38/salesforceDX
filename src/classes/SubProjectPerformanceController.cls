/*****************************************************************
Class Name: SubProjectPerformanceController
Author:janardhan                   Last modified by:Raju 
Date: 10/10/2014                  Date:29/07/2015
//
 getting id,to page redirect purpose form gantt detail page to SubProjectPerformancepage
//
Description: Class to prepare data,styles to be displayed in the performancegantt page
In this class ERP sales data and social media data is prepared in the form of JSON
********©2013 Musqot marketing technology Pvt ltd ****************/


public with sharing class SubProjectPerformanceController{
    public boolean IsDeleted {get;set;}  
    private List<Activitytype__c> actTypes;    
    public List<ERP_Settings__c> erpChartList{get;private set;}  
    public List<CRM_Settings__c> crmChartList{get;private set;} 
    public List<socialmedia_settings__c> mediaSettigs {get;private set;} 
    //public String selStr{get;set;}
    public string projid;
    public date start_dat {get;set;} 
    public date end_dat {get;set;} 
    public string ProjName {get;set;} 
    private List<SubProject__c> proj{get;private set;} 
    public List<Activitytype__c> PLAN_Temp;
    public List<String> selectedTypes{get;set;}
    public Map<Id,socialmedia_settings__c> mediaMap{get;set;}
    public list<String>erpidList; 
    public String erpRec;
    public list<String>crmidList; 
    public String crmRec;
    public list<String>socialidList; 
    public String socialRec;
    public String fromGantt;
    public string parentProId;
    //public Boolean isTop;
    public list<subProject__c>sList;
    public string currentRecordId;
    public string parentRecordId;
    public string parentRecordId1;
    public boolean continueLoop; 
    public list<Subproject__C > SearchString;
    public String ganttdetailId;
    public String maingantt;
    public list<Marketing_activity__c> mrkAct;   
    //Constructor
    public SubProjectPerformanceController(){
        projid= ApexPages.currentPage().getParameters().get('subid');
        fromGantt= ApexPages.currentPage().getParameters().get('sfdc.override');
        ganttdetailId = ApexPages.currentPage().getParameters().get('ganttid');
        maingantt = ApexPages.currentPage().getParameters().get('maingantt');
        erpidList=new list<string>();
        crmidList=new list<string>();
        socialidList=new list<string>();
        proj =new List<subProject__c>();
        this.actTypes = [SELECT Id, Name, Bar_color__c FROM Activitytype__c WHERE IsDeleted = false limit 250]; 

        if(projid<>null){                 
            Proj = [select Id,Name,Starts_date__c, Ends_date__c, ERP__c, CRM__c, Social_media__c ,musqot__Project_del__c 
                    from subProject__c where id =:projid]; 
              for(subProject__c s:Proj){         
                    parentProId=s.musqot__Project_del__c ; 
                                       
               }
            
            try{
                mrkAct = [select Id,Name,Starts_date__c, Ends_date__c, ERP__c, CRM__c, Social_media__c FROM Marketing_activity__c where Isdeleted = false AND Project__c =:projid];                                    
            }catch(Exception e){}
         }
        
        //at the top of the hierarchy, get the Id
        currentRecordId = projid; 
        parentRecordId = projid; 
        continueLoop = true; 
        while(continueLoop) 
        { 
            SearchString =[Select id, musqot__Project_del__c, Name From Subproject__C Where Id =: parentRecordId]; 
            if(SearchString.size() == 0) 
            { 
                continueLoop = false;  //no records returned
                continue; 
            } 
            else if(SearchString [0].musqot__Project_del__c== null)  //at the top of the hierarchy, get the Id
            { 
                parentRecordId1=SearchString[0].id; 
                continueLoop=false; 
                continue; 
            } 
            parentRecordId =  SearchString[0].musqot__Project_del__c; 
        }
        
       //
        for(subProject__c s:Proj ){
            start_dat = s.Starts_date__c;
            end_dat = s.Ends_date__c;
            ProjName = s.Name;
        }
        //Prepare erpList
        if(Proj[0].ERP__c<>null){
            erpRec=Proj[0].ERP__c;
            erpidList=erpRec.split(';');
            
        }
        // Prepare crmList
        if(Proj[0].CRM__c<>null){
            crmRec=Proj[0].CRM__c;
            crmidList=crmRec.split(';');
            
        }        
        
        //Prepare socialList
        if(Proj[0].Social_media__c <>null){
            socialRec=Proj[0].Social_media__c ;
            socialidList=socialRec.split(';');     
        }
        //marketing activity--
        for(Marketing_activity__c ma : mrkAct){
            if(ma.ERP__c <>  null){
                for(String erpId: ma.ERP__c.split(';')){
                    erpidList.add(erpId);
                }
            }
            if(ma.CRM__c <>  null){
                for(String crmId: ma.CRM__c.split(';')){
                    crmidList.add(crmId);
                }                
            }
            if(ma.Social_media__c <>  null){
                for(String smId: ma.Social_media__c.split(';')){
                    socialidList.add(smId);
                }                
            }
        }        
        //--
        
        // ERP settings
        if(erpidList.size()>0){
            this.erpChartList = [select Id,Name,Selector__c,erp_Chart__c,Bar_color__c 
                                 from ERP_Settings__c
                                 where (ERP_performance_type__c = 'Performance, project' or ERP_performance_type__c = 'Performance, marketing activity') 
                                 AND Id IN:erpidList               
                                 limit 50];  
        } 
        
        // CRM settings
        if(crmidList.size()>0){
            this.crmChartList = [select Id,Name,Selector__c,Chart__c,Bar_color__c,Watch_type__c  
                                 from CRM_Settings__c
                                 where (CRM_performance_type__c = 'Performance, project' or CRM_performance_type__c = 'Performance, marketing activity') 
                                 AND Id IN: crmidList
                                 limit 50];
            
        }                
        
        // Social Pages// List<socialmedia_settings__c>
        if(socialidList.size()>0){
            this.mediaSettigs = [select Id,Name,Bar_color__c,Chart__c,Watch_type__c,Socialmedia__c,Socialmedia_type__c,(select Id,Name from OAuth_services__r) 
                                 from socialmedia_settings__c
                                 where (type__c = 'Performance, project' or type__c = 'Performance, marketing activity')  AND
                                 Id IN:socialidList               
                                 limit 50];
        }  
        
        mediaMap= new Map<Id,socialmedia_settings__c>();
        if(socialidList.size()>0){
            for(socialmedia_settings__c sc: mediaSettigs){            
                mediaMap.put(sc.Id,sc);                    
            }
        }        
        selectedTypes = new List<String>();
        PLAN_Temp = [Select u.Name, u.Id From Activitytype__c u limit 250];
        if(PLAN_Temp.size()>0){
            for(Activitytype__c  objPLA: PLAN_Temp ){
                selectedTypes.add(objPLA.Id);
            }
        }
    }  
    
    /***** Convert lookup to dropdown of activity List ****/
    public List<SelectOption> PLANList{
        get{
            PLAN_Temp = [Select u.Name, u.Id From Activitytype__c u limit 250];
            PLANList= new List<SelectOption>(); 
            for(Activitytype__c objPLA : PLAN_Temp){
                PLANList.add(new SelectOption(objPLA.Id, objPLA.Name));
            }
            return PLANList;
        }
        set;
    }
    
    /**** Displaying marketing activities based selected activity types *****/
    public void showSelectedPlanTypes(){
        getdataString();
    }
    
    /*************    Praparing style for activity types  *****/
    public String gettaskstyleString(){        
        String style = '';       
        
        if(!acttypes.isEmpty()){
            for(Activitytype__c s : acttypes){
                
                String n = String.valueOf(s.Id).replaceAll(' ','_');
                
                // Basic task style
                style = style + '.' + n + '_task{';
                style = style + 'border:2px solid ' + '#' + s.Bar_color__c + ';';
                style = style + 'color:#000;';
                style = style + 'background-color:#' + s.Bar_color__c + ';}';
                
                // Task progress style                
                style = style + '.' + n + '_task .gantt_task_progress{';                
                style = style + 'background-color:#' + s.Bar_color__c + ';}'; 
            }            
        }        
        return style;
    }
    
    /****** Praparing data style *****/ 
    public String getjsString(){ 
        String js = '';
        
        // First declare the config types & locales
        for(Activitytype__c s : acttypes){            
            String n = String.valueOf(s.Id).replaceAll(' ','_');
            n = n.replaceAll('-','_');
            js = js + 'gantt.config.types.' + n + ' = "' + n + '";';
            js = js + 'gantt.locale.labels.type_' + n + ' = "' + s.Name +'";';
        }
        
        // Then build the mapping function
        js = js + 'gantt.templates.task_class = function(start, end, task){';
        
        // Then build the ,mapping function
        for(Activitytype__c s : acttypes){
            
            String n = String.valueOf(s.Id).replaceAll(' ','_');
            n = n.replaceAll('-','_');
            
            // Basic task style         
            js = js + 'if(task.type == gantt.config.types.' + n + '){';
            js = js + 'return "' + n + '_task";}';
        }
        
        // And finally, enclose the mapping function        
        js = js + 'return "";};';
        return js;
    }
    
    
    
    /**** preparing marketing data string in json format *****/ 
    public String getdataString(){
        
        // Something to hold the data
        List<GanttRow> renderRows = new List<GanttRow>();
        
        // iterate over marketing activities to build supporting JSON       
        for(Marketing_activity__c ma : [select Id,Name,Owner.Name,Activitytype__r.Icon__c,Activitytype__r.Name,Activitytype__r.Bar_color__c,Ends_date__c,Starts_date__c,Project__c,StatusImage__c,Status__c,Description__c,Project__r.Name 
                                        FROM Marketing_activity__c 
                                        where Isdeleted = false 
                                        AND Activitytype__c IN :selectedTypes 
                                        AND  Project__c =:projid
                                        order by Starts_date__c ]){
            
            //Create a subscored name
            String ms = (ma.Activitytype__c!= null) ? String.valueOf(ma.Activitytype__c).replaceAll(' ', '_') : 'default';
            ms = ms.replaceAll('-','_');
            
            //Create a new row object
            GanttRow mr = new GanttRow();
            mr.idPH = ma.Id;
            mr.text = ma.Name;
            mr.typePH = '!!!gantt.config.types.'+ ms +'!!!';
            
            if(ma.Starts_date__c<>null && ma.Ends_date__c<>null){
                mr.setStartDate(date.newinstance(ma.Starts_date__c.year(), ma.Starts_date__c.month(), ma.Starts_date__c.day()));   //hs date fix                  
                if(date.newinstance(ma.Starts_date__c.year(), ma.Starts_date__c.month(), ma.Starts_date__c.day()-1).daysBetween(date.newinstance(ma.Ends_date__c.year(), ma.Ends_date__c.month(), ma.Ends_date__c.day()))==0){
                    mr.Duration = 1;    
                }
                else{
                    mr.setDuration(date.newinstance(ma.Starts_date__c.year(), ma.Starts_date__c.month(), ma.Starts_date__c.day()-1), date.newinstance(ma.Ends_date__c.year(), ma.Ends_date__c.month(), ma.Ends_date__c.day()));  
                }
            }
            
            mr.description = ma.Description__c;
            mr.progress = 1;
            mr.open = false;           
            mr.objType = 'activity';
            mr.actImg = '<img src=\''+ma.Activitytype__r.Icon__c+'\'title=\''+ma.Name+', '+ma.Activitytype__r.Name+'\' style=\'float:left\'/>';                    
            if(ma.StatusImage__c<>null){
                mr.img = ma.StatusImage__c.replace('alt=','title=');
            }
            mr.activityType = ma.Activitytype__r.Name;
            mr.owner = ma.Owner.Name;
            renderRows.add(mr);   
        }
        
        
        // Json Template
        JsonWrapper wrapper = new JsonWrapper();
        wrapper.data = renderRows;
        
        // Replace sf reserved object names with their realname before output.
        return JSON.serialize(wrapper).replaceAll('idPH','id').replaceAll('typePH','type').replaceAll('"!!!','').replaceAll('!!!"','');
        
    }
    
    /****** Navigate to main gantt *****/
    // modified by Narendra
    public pageReference gotoProjectPage(){
         Pagereference pg;
        if(maingantt!=null) {
            string pageRef='/apex/GanttPage';
            pg=new Pagereference (pageRef);         
        }
        else if(ganttdetailId!=null) {
            string pageRef='/apex/GanttDetailPage?id='+ganttdetailId; //+parentProId;
            pg=new Pagereference (pageRef);
                    
        }
        else {
            string pageRef='/apex/subProject?id='+projid;
            pg=new Pagereference (pageRef); 
        }
        return pg;
    }
    
    /****** Wrapper class to hold multiple json data strings *****/
    public class JsonWrapper{
        public List<GanttRow> data{get; private set;}
    } 
    
    /****** Wrapper class to prepare json data string *****/
    public class GanttRow{
        public String idPH{get;private set;}
        public String text{get;private set;}
        public String typePH{get;private set;}
        public String start_date{get;private set;}
        public String description{get;private set;}
        public Integer duration{get;private set;}
        public Integer progress{get;private set;}
        public Boolean open{get;private set;}
        public String parent{get;private set;}
        public String img{get;private set;}        
        public String objType{get;set;}
        public String actImg{get;private set;}
        public String activityType{get;private set;}
        public String owner{get;private set;}
        
        public void setStartDate(Date val){
            DateTime d = val;
            start_date =  d.format('dd-MM-yyyy');       
        }
        
        public void setDuration(Date starts, Date ends){
            duration =  starts.daysBetween(ends);   
        }
    }
    
    /**** preparing erp sales data string in json format *****/     
    
    public String getData(){
        try{
            List<ERP_sales_obj__c> erpList =  [select Sales__c,Sales_date__c,sales_import_id__c,Business_area__c,Business_region__c from ERP_sales_obj__c where Sales_date__c >=: start_dat and Sales_date__c <=: end_dat order by Sales_date__c, Business_region__c limit 5000];
            
            //preparing JSON raw data        
            List<String> jsonList = new List<String>();
            JSONGenerator jsonGen = JSON.createGenerator(true);
            jsonGen.writeStartArray();
            
            for(ERP_sales_obj__c erp : erpList){
                if(erp.Sales__c == null){
                    erp.Sales__c = 0;
                }            
                jsonGen.writeStartObject();
                jsonGen.writeDateField('date',erp.Sales_date__c);
               jsonGen.writeStringField('region',erp.Business_region__c.replaceAll(' ','_'));           
                jsonGen.writeNumberField('sale',erp.Sales__c);         
                jsonGen.writeStringField('area',erp.Business_area__c.replaceAll(' ','_'));    
                jsonGen.writeEndObject();     
            }
            jsonGen.writeEndArray();        
            return jsonGen.getAsString();
        }catch(Exception e){
            return null;
        }
    }
    
    /**** preparing crm sales data string in json format *****/     
    
    public String getCRMData(){    
        try{
            List<CRM_data__c> crmList =  [select No_Leads__c, No_Opportunities__c, Value_Deals__c, Value_Opportunities__c, Value_w_Opportunities__c,Date__c,CRM_import_id__c,Business_area__c,Business_region__c from CRM_data__c where Date__c >=: start_dat and Date__c <=: end_dat  order by Date__c, Business_region__c limit 5000];
            
            //preparing JSON raw data        
            List<String> jsonList = new List<String>();
            JSONGenerator jsonGen = JSON.createGenerator(true);
            jsonGen.writeStartArray();
            
            for(CRM_data__c crm : crmList){
                if(crm.No_Leads__c == null){
                    crm.No_Leads__c = 0;
                }
                if(crm.No_Opportunities__c == null){
                    crm.No_Opportunities__c = 0;
                }
                if(crm.Value_Deals__c == null){
                    crm.Value_Deals__c = 0;
                }
                if(crm.Value_Opportunities__c == null){
                    crm.Value_Opportunities__c = 0;
                }
                if(crm.Value_w_Opportunities__c == null){
                    crm.Value_w_Opportunities__c = 0;
                }
                jsonGen.writeStartObject();
                jsonGen.writeDateField('date',crm.Date__c);
                jsonGen.writeStringField('region',crm.Business_region__c.replaceAll(' ','_'));
                jsonGen.writeStringField('area',crm.Business_area__c.replaceAll(' ','_')); 
                jsonGen.writeNumberField('NumberLeads',crm.No_Leads__c);
                jsonGen.writeNumberField('NumberOpportunities',crm.No_Opportunities__c);
                jsonGen.writeNumberField('ValueDeals',crm.Value_Deals__c);
                jsonGen.writeNumberField('ValueOpportunities',crm.Value_Opportunities__c);
                jsonGen.writeNumberField('ValueWeightOpportunities',crm.Value_w_Opportunities__c);               
                jsonGen.writeEndObject();     
            }
            jsonGen.writeEndArray();        
            return jsonGen.getAsString();
        }catch(Exception e){
            return null;
        }
    }
    
    /**** preparing social media(facebook) data string in json format *****/ 
    
    public String getFbData(){ 
        try{
            List<Social_media_data__c> smdList = [select Id,Date__c,Number_of_likes__c,Number_of_unik_visitor__c,Number_of_member__c,Name,Connection__c,Connection__r.Page_Id__c 
                                                  from Social_media_data__c where Date__c >=: start_dat and Date__c <=: end_dat limit 20000];
            
            List<String> jsonList = new List<String>();
            JSONGenerator jsonGen = JSON.createGenerator(true);
            jsonGen.writeStartArray();
            
            for(Social_media_data__c smd : smdList){
                if(smd.Number_of_likes__c ==  null){
                    smd.Number_of_likes__c = 0;
                }            
                if(smd.Number_of_unik_visitor__c ==  null){
                    smd.Number_of_unik_visitor__c = 0;
                }            
                if(smd.Number_of_member__c ==  null){
                    smd.Number_of_member__c = 0;
                }
                jsonGen.writeStartObject();
                jsonGen.writeStringField('connection',smd.Connection__c);
                jsonGen.writeDateField('date',smd.Date__c);
                jsonGen.writeStringField('page','pg_'+smd.Connection__r.Page_Id__c);
                jsonGen.writeNumberField('likes',smd.Number_of_likes__c);
                jsonGen.writeNumberField('visitors',smd.Number_of_unik_visitor__c);
                jsonGen.writeNumberField('members',smd.Number_of_member__c);
                jsonGen.writeEndObject();     
            }
            jsonGen.writeEndArray();
            return jsonGen.getAsString(); 
        }catch(Exception e){
            return null;
        }
    }
  
    
}