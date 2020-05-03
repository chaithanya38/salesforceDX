/*****************************************************************
Class Name: ProjectPerformanceController
Author:janardhan                   Last modified by: janardhan
Date: 10/10/2014                  Date:/22/2015
Description: Class to prepare data,styles to be displayed in the performancegantt page
             In this class ERP sales data and social media data is prepared in the form of JSON
********©2013 Musqot marketing technology Pvt ltd ****************/
public with sharing class ProjectPerformanceController{
    public boolean IsDeleted {get;set;}  
    private List<Activitytype__c> actTypes;    
    public List<ERP_Settings__c> erpChartList{get;private set;}  
    public List<CRM_Settings__c> crmChartList{get;private set;} 
    public List<socialmedia_settings__c> mediaSettigs {get;private set;} 
    //public String selStr{get;set;}
    public List<Activitytype__c> PLAN_Temp;
    public List<String> selectedTypes{get;set;}
    public Map<Id,socialmedia_settings__c> mediaMap{get;set;}
    public string planid;
    public date start_dat {get;set;} 
    public date end_dat {get;set;} 
     public string PlanName {get;set;} 
    private List<Project__c> plan{get;private set;} 
    public list<String>erpidList; 
    public String erpRec;
    public list<String>crmidList; 
    public String crmRec;
    public list<String>socialidList; 
    public String socialRec;
    //Constructor
    public ProjectPerformanceController(){     
        planid= ApexPages.currentPage().getParameters().get('planid');
        erpidList=new list<string>();
        crmidList=new list<string>();
        socialidList=new list<string>();
        plan =new List<Project__c>();
        plan = [select Id,Name,Starts_date__c, Ends_date__c, ERP__c, CRM__c, Social_media__c 
                from Project__c
                where id =:planid];
        
            start_dat = plan[0].Starts_date__c;
            end_dat = plan[0].Ends_date__c;
            PlanName = plan[0].Name;
        //Prepare erpList
        if(plan[0].ERP__c<>null){
               erpRec=plan[0].ERP__c;
               erpidList=erpRec.split(';');
             
         }
       // Prepare crmList
            if(plan[0].CRM__c<>null){
               crmRec=plan[0].CRM__c;
               crmidList=crmRec.split(';');
               
            }
   
       //Prepare socialList
            if(plan[0].Social_media__c <>null){
               socialRec=plan[0].Social_media__c ;
               socialidList=socialRec.split(';');     
            }
        this.actTypes = [SELECT Id, Name, Bar_color__c FROM Activitytype__c WHERE IsDeleted = false limit 250]; 
               
        // ERP settings
            if(erpidList.size()>0){
                 this.erpChartList = [select Id,Name,Selector__c,erp_Chart__c,Bar_color__c 
                                     from ERP_Settings__c
                                     where ERP_performance_type__c = 'Performance, project'
                                     AND Id IN:erpidList               
                                     limit 50];  
               }                         
                    
        // CRM settings
        if(crmidList.size()>0){
            this.crmChartList = [select Id,Name,Selector__c,Chart__c,Bar_color__c 
                             from CRM_Settings__c
                             where CRM_performance_type__c = 'Performance, project'
                             AND Id IN: crmidList
                             limit 50];
                              
               }
                        
        // Social Pages// List<socialmedia_settings__c>
        if(socialidList.size()>0){
            this.mediaSettigs = [select Id,Name,Bar_color__c,Chart__c,(select Id,Name from OAuth_services__r) 
                                 from socialmedia_settings__c
                                 where type__c = 'Performance, project' AND
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
        for(Marketing_activity__c ma : [select Id,Name,Activitytype__r.Icon__c,Activitytype__r.Name,Activitytype__r.Bar_color__c,Ends_date__c,Starts_date__c,Project__c,StatusImage__c,Status__c,Description__c,Project__r.Name 
                                        from Marketing_activity__c 
                                        where Isdeleted = false and Plan__c =:planid
                                        AND Activitytype__c IN :selectedTypes order by Starts_date__c ]){
            
            //Create a subscored name
            String ms = (ma.Activitytype__c!= null) ? String.valueOf(ma.Activitytype__c).replaceAll(' ', '_') : 'default';
            ms = ms.replaceAll('-','_');
            
            //Create a new row object
            GanttRow mr = new GanttRow();
            mr.idPH = ma.Id;
            mr.text = ma.Name;
            mr.typePH = '!!!gantt.config.types.'+ ms +'!!!';
            
            if(ma.Starts_date__c<>null && ma.Ends_date__c<>null){
                mr.setStartDate(date.newinstance(ma.Starts_date__c.year(), ma.Starts_date__c.month(), ma.Starts_date__c.day()));               
                if(date.newinstance(ma.Starts_date__c.year(), ma.Starts_date__c.month(), ma.Starts_date__c.day()).daysBetween(date.newinstance(ma.Ends_date__c.year(), ma.Ends_date__c.month(), ma.Ends_date__c.day()))==0){
                    mr.Duration = 1;    
                }
                else{
                    mr.setDuration(date.newinstance(ma.Starts_date__c.year(), ma.Starts_date__c.month(), ma.Starts_date__c.day()), date.newinstance(ma.Ends_date__c.year(), ma.Ends_date__c.month(), ma.Ends_date__c.day()));  
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
            renderRows.add(mr);   
        }
        
        
        // Json Template
        JsonWrapper wrapper = new JsonWrapper();
        wrapper.data = renderRows;
        
        // Replace sf reserved object names with their realname before output.
        return JSON.serialize(wrapper).replaceAll('idPH','id').replaceAll('typePH','type').replaceAll('"!!!','').replaceAll('!!!"','');
        
    }
    
    /****** Navigate to main gantt *****/
    public pageReference gotoPlanPage(){
        //tofix utl encoding
        //return new PageReference('/apex/ProjectDetails?id='+planid);
        string pageRef='/apex/ProjectDetails?id='+planid;
        Pagereference pg=new Pagereference (pageRef);
        return pg;  
    }
    
    /****** Wrapper class to hold multiple json data strings *****/
    public class JsonWrapper{
        public List<GanttRow> data{get; private set;}
    } 
    
    /****** Wrapper class to prepare json data string *****/
    public class GanttRow{
        @TestVisible public String idPH{get;private set;}
        @TestVisible public String text{get;private set;}
        @TestVisible public String typePH{get;private set;}
        @TestVisible public String start_date{get;private set;}
        @TestVisible public String description{get;private set;}
        @TestVisible public Integer duration{get;private set;}
        @TestVisible public Integer progress{get;private set;}
        @TestVisible public Boolean open{get;private set;}
        @TestVisible public String parent{get;private set;}
        @TestVisible public String img{get;private set;}        
        public String objType{get;set;}
        @TestVisible public String actImg{get;private set;}
        
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
        List<ERP_sales_obj__c> erpList =  [select Sales__c,Sales_date__c,sales_import_id__c,Business_area__c,Business_region__c from ERP_sales_obj__c order by Sales_date__c, Business_region__c limit 5000];
        
        //preparing JSON raw data        
        List<String> jsonList = new List<String>();
        JSONGenerator jsonGen = JSON.createGenerator(true);
        jsonGen.writeStartArray();
        
        for(ERP_sales_obj__c erp : erpList){
            jsonGen.writeStartObject();
            jsonGen.writeDateField('date',erp.Sales_date__c);
            jsonGen.writeStringField('region',erp.Business_region__c);
            jsonGen.writeNumberField('sale',erp.Sales__c);
            jsonGen.writeStringField('area',erp.Business_area__c.replaceAll(' ','_'));    
            jsonGen.writeEndObject();     
        }
        jsonGen.writeEndArray();        
        return jsonGen.getAsString();
    }
    
    /**** preparing social media(facebook) data string in json format *****/ 
    
    public String getFbData(){ 
        
        List<Social_media_data__c> smdList = [select Id,Date__c,Number_of_likes__c,Name,Connection__c,Connection__r.Page_Id__c from Social_media_data__c limit 20000];
        
        List<String> jsonList = new List<String>();
        JSONGenerator jsonGen = JSON.createGenerator(true);
        jsonGen.writeStartArray();
        
        for(Social_media_data__c erp : smdList){
            jsonGen.writeStartObject();
            jsonGen.writeDateField('date',erp.Date__c);
            jsonGen.writeStringField('page','pg_'+erp.Connection__r.Page_Id__c);
            jsonGen.writeNumberField('likes',erp.Number_of_likes__c);
            jsonGen.writeEndObject();     
        }
        jsonGen.writeEndArray();
        return jsonGen.getAsString();                
    }
    
}