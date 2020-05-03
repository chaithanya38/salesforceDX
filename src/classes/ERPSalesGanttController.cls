/*****************************************************************
Class Name: ERPSalesGanttController
Author:Hussain                   Last modified by: Narendra K Jha
Date: 10/10/2014                  Date: Dec 21, 2015
Description: Class to prepare data,styles to be displayed in the performancegantt page
             In this class ERP sales data and social media data is prepared in the form of JSON
********©2013 Musqot marketing technology Pvt ltd ****************/


public with sharing class ERPSalesGanttController{
    public boolean IsDeleted {get;set;}  
    private List<Activitytype__c> actTypes;    
    public List<ERP_Settings__c> erpChartList{get;private set;}   
    public List<CRM_Settings__c> crmChartList{get;private set;} 
    public String selStr{get;set;}
    public List<Activitytype__c> PLAN_Temp;
    public List<String> selectedTypes{get;set;}
    public Map<Id,socialmedia_settings__c> mediaMap{get;set;}
    public boolean isSecondSection{get;set;} 
    public string projid{get;set;}
    public Project__c plan{get;set;}
     /* Filter Start here */
    public string selectedFilter{get;set;}
    public List<User_setting__c> Filter_Temp = new List<User_setting__c>();
    public string FilterName {get;set;}
    public string FilterZooming {get;set;}
    public date FilterStartDate {get;set;}
    public date FilterEndDate {get;set;}
    public boolean GlobalFilter {get;set;}   
    public boolean mydefaultFilter {get;set;}  
    public List<String> selectedFilterTypes{get;set;}
    public List<String> selectedFilterTypes1{get;set;}
    public List<String> FilterTypes{get;set;}
    public List<musqot__plantype__c> Filter_PLAN_Temp = new List<musqot__plantype__c>(); 
    public string lnkfilterTitle {get;set;}
    public date startDateVal {get;set;}
    public date endDateVal {get;set;}
    public string zoomingVal {get;set;}
    public string  MyProflieName{get;set;}
    public boolean isGlobaluser {get;set;} 
    public boolean Level1{get;set;}    
    public boolean addfiltersetting {get;set;} 
    public List<musqot__Activity__c> musAct;
    /* Filter End here */
    
    
    //Constructor
    public ERPSalesGanttController(){       
        projid= ApexPages.currentPage().getParameters().get('pid');
        if(projid != null){
            plan = [SELECT Id, Name, Starts_date__c, Ends_date__c FROM Project__c where Id=:projid]; 
        }
        this.actTypes = [SELECT Id, Name, Bar_color__c FROM Activitytype__c WHERE IsDeleted = false limit 250]; 
        this.erpChartList = [select Id,Name,Selector__c,erp_Chart__c,Bar_color__c 
                             from ERP_Settings__c
                             Where ERP_performance_type__c = 'Performance, general' limit 100];  
        this.crmChartList = [select Id,Name,Selector__c,Chart__c,Bar_color__c,Watch_type__c   
                             from CRM_Settings__c
                             Where CRM_performance_type__c = 'Performance, general' limit 100];
        // Social Pages
        List<socialmedia_settings__c> mediaSettigs = [select Id,Name,Bar_color__c,Chart__c,Watch_type__c,Socialmedia__c,Socialmedia_type__c,(select Id,Name,Bar_color__c from OAuth_services__r) 
                                                      from socialmedia_settings__c
                                                      where type__c = 'Performance, general' limit 100];
        
        if(erpChartList.size()>0 || crmChartList.size()>0 || mediaSettigs.size()>0) {
            isSecondSection = true;
        } else {
            isSecondSection = false;
        }
        
        mediaMap= new Map<Id,socialmedia_settings__c>();
        for(socialmedia_settings__c erp : mediaSettigs){            
            mediaMap.put(erp.Id,erp);                    
        }
        system.debug('---------linecolor---------'+mediaMap);        
        selectedTypes = new List<String>();
        PLAN_Temp = [Select u.Name, u.Id From Activitytype__c u limit 250];
        
        for(Activitytype__c  objPLA: PLAN_Temp ){
            selectedTypes.add(objPLA.Id);
        }
        
        
        // filter part
        musqot__User_setting__c get_musqot_defaultfilter = new musqot__User_setting__c();
        try{
        get_musqot_defaultfilter = [SELECT Id FROM User_setting__c 
                                    WHERE (Userid__c=:UserInfo.getUserId() or Global__c =:true ) and Gantt_type__c=:2 
                                    Order by My_default__c desc  limit 1];
        selectedFilter = get_musqot_defaultfilter.Id;          
        
        }catch (Exception e) {
            selectedFilter = '0';
            lnkfilterTitle = Label.gnt_Add;
            startDateVal = null;
            endDateVal = null;
            zoomingVal = null;
            //showPopup();
        }

        if(selectedFilter <> '0'){
            lnkfilterTitle = label.btn_Edit;
            getFilter();
            startDateVal = FilterStartDate;
            endDateVal = FilterEndDate;
            zoomingVal = FilterZooming;
        }
        
        isGlobaluser = false;
        
        List<Profile> userprofile =new List<Profile>();
        userprofile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() Limit 1];
        MyProflieName = userprofile[0].Name;   
         Profilelist__c pl= Profilelist__c.getInstance(MyProflieName); //it is Custom setting object
               if(pl<>null){            
            if(MyProflieName == 'System Administrator'||MyProflieName=='Musqot admin'){
                     Level1=True; 
               
             }   
            }
    } 
    
    /***** Convert lookup to dropdown of activity List ****/
    public List<SelectOption> PLANList{
        get{
            PLAN_Temp = [Select u.Name, u.Id From Activitytype__c u limit 250];
            PLANList = new List<SelectOption>();
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
            
        	musqot__User_setting__c musqot_filterSetting = new musqot__User_setting__c();
            try{            
                musqot_filterSetting = [SELECT Id, Name, Ganttview__c FROM User_setting__c 
                                        WHERE Id = :selectedFilter and Gantt_type__c = 2 limit 50]; 
                DOM.Document doc = new DOM.Document();      
                try 
                {   
                    doc.load(musqot_filterSetting.musqot__Ganttview__c);    
                    DOM.XMLNode root = doc.getRootElement();
                    string plantype = root.getChildElement('plantype', null).getText();
                    if(plantype.length() > 0)
                    	FilterTypes = plantype.split(','); 
                }
                catch (System.XMLException e) {                   
                }
            }catch (Exception e) {
                musqot_filterSetting = new musqot__User_setting__c();
                selectedFilter = '0';
            }
            // Something to hold the data
            
            List<Marketing_activity__c> projectList = new List<Marketing_activity__c>();
        
        	String query = 'select Id,Name,Owner.Name,Activitytype__r.Icon__c,Activitytype__r.Name,Activitytype__r.Bar_color__c,'+
                ' Ends_date__c,Starts_date__c,Project__c,StatusImage__c,Status__c,Description__c,Project__r.Name'+ 
                ' from Marketing_activity__c where Isdeleted = false';
        
        	if(selectedFilter <> '0'){
                if(FilterTypes != null) {
                    if(FilterTypes.size() > 0) {
                        query += ' and Activitytype__c IN :FilterTypes';
                    } 
                } 
            } else {
               if(selectedTypes != null) {
                    if(selectedTypes.size() > 0) {
                        query += ' and Activitytype__c IN :selectedTypes';
                    } 
                } 
            }
            if(projid != null) {
                 query += ' and Plan__c =:projid';
            }
        	query += ' order by Starts_date__c';
        	projectList = Database.query(query);
            
           
            for(Marketing_activity__c ma : projectList){
                
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
    
    
    // Filter implementation --start--
    public boolean displayPopup {get; set;}
    
    public List<SelectOption> FilterList{
        get
        {
            Filter_Temp = [Select u.Name, u.Id From User_setting__c u Where (Userid__c = :UserInfo.getUserId() or Global__c = :true) and Gantt_type__c = :2  limit 250];
            FilterList= new List<SelectOption>(); 
            FilterList.add(new SelectOption('0', label.gnt_New_filter));
            addfiltersetting = true;
            for(User_setting__c objFilterList: Filter_Temp )
            {
                FilterList.add(new SelectOption(objFilterList.Id, objFilterList.Name));
                addfiltersetting = False;
            }            
            return FilterList;
        }
        set;
    }           
    public void SaveFilter() { 
        User_setting__c Ganttviewsetting = new User_setting__c();
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null,'1.0');
        w.writeStartElement(null,'gantt',null);   
        
        w.writeStartElement(null,'gtimeSlot',null);
        w.writeCharacters(String.valueOf(FilterZooming));
        w.writeEndElement();
        
        w.writeStartElement(null,'gstartDate',null);
        w.writeCharacters(string.valueOf(FilterStartDate));
        w.writeEndElement();
        
        w.writeStartElement(null,'gendDate',null);
        w.writeCharacters(string.valueOf(FilterEndDate));
        w.writeEndElement();
        
        String filterliststring = '';
        for(String a:selectedFilterTypes) {
           filterliststring += (filterliststring==''?'':',')+a;
        }
        w.writeStartElement(null,'plantype',null);   
        w.writeCharacters(filterliststring);
        w.writeEndElement();
        
        w.writeEndElement();
        w.writeEndDocument();
        
        string xml = w.getXmlString();
        w.close(); 
        if(mydefaultFilter){
            for (musqot__User_setting__c a : [SELECT Id, My_default__c FROM User_setting__c WHERE Userid__c = :UserInfo.getUserId() and Gantt_type__c = :2 limit 250]){
               a.My_default__c = false;
               update a;
            }
            
        }
        
        if(selectedFilter == '0'){
            Ganttviewsetting = new User_setting__c(); 
            Ganttviewsetting.Name = FilterName;
            Ganttviewsetting.Userid__c = UserInfo.getUserId();
            Ganttviewsetting.Gantt_type__c = 2;
            Ganttviewsetting.Ganttview__c = xml;
            Ganttviewsetting.Global__c = GlobalFilter;
            Ganttviewsetting.My_default__c = mydefaultFilter;
            insert Ganttviewsetting;
        }else {
            Ganttviewsetting.Id = selectedFilter;
            Ganttviewsetting.Name = FilterName;
            Ganttviewsetting.Userid__c = UserInfo.getUserId();
            Ganttviewsetting.Gantt_type__c = 2;
            Ganttviewsetting.Ganttview__c = xml;
            Ganttviewsetting.Global__c = GlobalFilter;
            Ganttviewsetting.My_default__c = mydefaultFilter;
            update Ganttviewsetting;
        }
        selectedFilter = Ganttviewsetting.Id;
        startDateVal = FilterStartDate;
        endDateVal = FilterEndDate;
        zoomingVal = FilterZooming;
        displayPopUp = false;
        loadviewbyFilter();              
    } 
    public void DeleteFilter() { 
        User_setting__c Ganttviewsetting = new User_setting__c();        
        Ganttviewsetting.Id = selectedFilter;
        delete Ganttviewsetting;    
        selectedFilter = '0';
        displayPopUp = false;
        loadviewbyFilter();              
    }     
    public PageReference closePopup() { 
        PageReference pg = new PageReference(System.currentPageReference().getURL());
        pg.setRedirect(false);
        displayPopUp = false; 
        return pg;                            
    }  
    public void showPopup() {  
        getFilter();       
        displayPopup = true; 
    }   
    public void getFilter(){ 
        
        musqot__User_setting__c get_musqot_filter = new User_setting__c();        
        if(selectedFilter <> '0'){
            get_musqot_filter = [SELECT Id, Name, Ganttview__c, Global__c, My_default__c, Userid__c 
                                 FROM User_setting__c WHERE Id = :selectedFilter limit 250]; 
            FilterName = get_musqot_filter.Name;
            DOM.Document doc = new DOM.Document();      
            try 
            {
                doc.load(get_musqot_filter.Ganttview__c);    
                DOM.XMLNode root = doc.getRootElement();
                string plantype = root.getChildElement('plantype', null).getText();
                selectedFilterTypes = plantype.split(',');                    
                FilterZooming = root.getChildElement('gtimeSlot', null).getText();                  
                FilterStartDate = Date.valueOf(root.getChildElement('gstartDate', null).getText());                     
                FilterEndDate = Date.valueOf(root.getChildElement('gendDate', null).getText());    
                GlobalFilter = get_musqot_filter.Global__c;
                mydefaultFilter = get_musqot_filter.My_default__c;    
                if(get_musqot_filter.Global__c == true && get_musqot_filter.Userid__c != UserInfo.getUserId()){
                    isGlobaluser = true;
                }else{
                    isGlobaluser = false;
                }
            } 
            catch (System.XMLException e) {  // invalid XML                 
            }
        }else{            
            FilterName = null;
            selectedFilterTypes= new List<String>();
            FilterZooming = 'Days';
            FilterStartDate = System.today().addDays(-15);
            FilterEndDate = System.today().addMonths(2);
            GlobalFilter = false;
            mydefaultFilter = false;  
            isGlobaluser = false;
        }
        
    }  
    public void loadviewbyFilter(){ 
        System.debug('test debug === ' + selectedFilter);
        if(selectedFilter <> '0'){
            lnkfilterTitle = label.btn_Edit;
            displayPopup = false; 
            getFilter();
            startDateVal = FilterStartDate;
            endDateVal = FilterEndDate;
            zoomingVal = FilterZooming;
        }else IF(addfiltersetting){
            lnkfilterTitle = Label.gnt_Add;
            startDateVal = null;
            endDateVal = null;
            zoomingVal = null;
            showPopup();  
        }else{
            lnkfilterTitle = Label.gnt_Add;
            startDateVal = null;
            endDateVal = null;
            zoomingVal = null;
            //showPopup();
        }
          
    }   
    
    /****** Navigate to main gantt *****/
    public pageReference gotoGanttPage(){
        return new PageReference('/apex/GanttPage');
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
            List<ERP_sales_obj__c> erpList = new List<ERP_sales_obj__c>();
            if(projid != null) {
                 erpList =  [select Sales__c,Sales_date__c,sales_import_id__c,Business_area__c,Business_region__c from ERP_sales_obj__c where Sales_date__c >=: plan.Starts_date__c and Sales_date__c <=: plan.Ends_date__c order by Sales_date__c, Business_region__c limit 5000];
            } else {
                erpList =  [select Sales__c,Sales_date__c,sales_import_id__c,Business_area__c,Business_region__c from ERP_sales_obj__c order by Sales_date__c, Business_region__c limit 5000];
            }
            
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
            List<CRM_data__c> crmList =  new List<CRM_data__c>();
            if(projid != null) {
                 crmList =  [select No_Leads__c, No_Opportunities__c, Value_Deals__c, Value_Opportunities__c, Value_w_Opportunities__c,Date__c,CRM_import_id__c,Business_area__c,Business_region__c from CRM_data__c where Date__c >=: plan.Starts_date__c and Date__c <=: plan.Ends_date__c order by Date__c, Business_region__c limit 5000];
            } else {
                crmList =  [select No_Leads__c, No_Opportunities__c, Value_Deals__c, Value_Opportunities__c, Value_w_Opportunities__c,Date__c,CRM_import_id__c,Business_area__c,Business_region__c from CRM_data__c order by Date__c, Business_region__c limit 5000];
            }
            
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
           //hs change 
           //old   List<Social_media_data__c> smdList = [select Id,Date__c,Number_of_likes__c,Name,Socialmedia_Settings__c,Socialmedia_Settings__r.Page_Id__c from Social_media_data__c limit 20000];
            List<Social_media_data__c> smdList = new List<Social_media_data__c>();
            if(projid != null) {
                smdList = [select Id,Date__c,Number_of_likes__c,Number_of_unik_visitor__c,Number_of_member__c,Name,Connection__c,Connection__r.Page_Id__c from Social_media_data__c  where Date__c >=: plan.Starts_date__c and Date__c <=: plan.Ends_date__c limit 50000];
            } else {
                smdList = [select Id,Date__c,Number_of_likes__c,Number_of_unik_visitor__c,Number_of_member__c,Name,Connection__c,Connection__r.Page_Id__c from Social_media_data__c limit 50000];
            } 
            
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
                system.debug('likes'+smd.Number_of_likes__c);
            }
            jsonGen.writeEndArray();
            return jsonGen.getAsString(); 
        }catch(Exception e){
            return null;
        }
    }
    
}