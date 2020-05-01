/*******************************************************
Class Name: GanttPageController 
Author: Hussain        Last modified by: Narendra K Jha
Date: 4/7/2014        Date: Dec 21, 2015
Dec: Adding Plan access controll Field in SOQL (line no:114 to 122)
********©2013 Musqot marketing technology Pvt ltd *******/


global with sharing class GanttPageController {
    public boolean IsDeleted {get; set;}
    private List<Project_type__c> ptypes;
    private List<plantype__c> plntypes;
    private List<Activitytype__c> actTypes;  
    public musqot__Project__c ObjPro{get; set;}
    public List<String> selectedTypes{get;set;}
    public boolean showBtn{get;set;}
    public List<musqot__plantype__c> PLAN_Temp = new List<musqot__plantype__c>();
    
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
    public List<String> selectedPriorityLevels{get;set;}
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
    public List<musqot__Activity__c> musAct{get;set;}
    public boolean performanceButtonView{get;set;} 
    public String pid_ap{get;set;}
    public String pc_npn_ap{get;set;}
    public String pc_np_sd_ap{get;set;}
    public List<FiscalYearSettings> fys{get;set;}
    public List<selectOption> plList{get;set;}
    /* Filter End here */
    
    //Constructor
    public GanttPageController(){
       
        plList = getPickValues(new Subproject__c(), 'Priority_level__c');
        // field to return -- skips fields not actually part of the sobject
        Set<String> fields = new Set<String>{'status'};
        
        Map<String, Schema.DescribeFieldResult> finalMap =  
          MusqotUtility.getFieldMetaData(Task.getSObjectType().getDescribe(), fields);
        
        Schema.DescribeFieldResult sObj = finalMap.get('status');
        System.debug(sObj.getPicklistValues());
        
        
        List<Profile> userprofile =new List<Profile>();
        userprofile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() Limit 1];
        MyProflieName = userprofile[0].Name;   
         Profilelist__c pl= Profilelist__c.getInstance(MyProflieName); //it is Custom setting object
               if(pl<>null){            
            if(MyProflieName == 'System Administrator'||MyProflieName=='Musqot admin'){
                     Level1=True; 
               
             }   
            }   
        this.ptypes = [SELECT Id, Name, musqot__Color__c FROM Project_type__c WHERE IsDeleted = false limit 250]; 
        this.plntypes = [SELECT Id, Name, Barcolor__c FROM plantype__c WHERE IsDeleted = false limit 250];        
        this.actTypes = [SELECT Id, Name, Bar_color__c FROM Activitytype__c WHERE IsDeleted = false limit 250]; 
       
        // Hide Performance Button 
        // unnecessary validation, commented by Narendra
        /*showBtn = false;
        List<Social_media_data__c> smdList = [select Id from Social_media_data__c limit 1];
        List<ERP_sales_obj__c> erpList =  [select Id from ERP_sales_obj__c limit 1];
        List<CRM_data__c> crmList =  [select Id from CRM_data__c limit 1];
        if((crmList==null || crmList.isEmpty()) && (smdList==null || smdList.isEmpty()) && (erpList==null || erpList.isEmpty())){
            showBtn = true;
        }*/
                
        selectedTypes = new List<String>();
        PLAN_Temp = [Select u.Name, u.Id From plantype__c u limit 250];   
        for(plantype__c objPLA: PLAN_Temp ){
            selectedTypes.add(objPLA.Id);
        } 
        
        /* Filter Starts here */  
        this.selectedFilterTypes1=new List<String>();
        selectedFilterTypes = new List<String>();
        Filter_PLAN_Temp = [Select u.Name, u.Id From plantype__c u limit 250];   
        for(plantype__c objFilterType: Filter_PLAN_Temp ){
            selectedFilterTypes.add(objFilterType.Id);
        } 
        
        selectedPriorityLevels = new List<String>();
        /*List<Subproject__c> TempPriorityLevel = [Select Priority_level__c From Subproject__c limit 250];   
        for(Subproject__c pl2: TempPriorityLevel ){
            selectedPriorityLevels.add(pl2.Priority_level__c);
        }*/
        
        musqot__User_setting__c get_musqot_defaultfilter = new musqot__User_setting__c();
        try{
        get_musqot_defaultfilter = [SELECT Id FROM User_setting__c 
                                    WHERE (Userid__c=:UserInfo.getUserId() or Global__c =:true ) and Gantt_type__c=:0 
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
        //
         musAct=[SELECT Id, Name, Company_holidays__c,Incl_Marketing_activity_Main__c, Incl_Milestone_Main__c, Incl_Marketing_activity_Detail__c,
                Incl_Milestone_Detail__c, Incl_Task_Detail__c,Incl_Task_main_gantt__c, Drag_to_change_date_Detail__c,Drag_to_change_date_Main__c
                ,Plan_access_controll__c,Use_Finance1__c FROM Activity__c limit 1];
       //Raju adding condition for Performance image in gantt page---        
        if(musAct[0].Plan_access_controll__c==false){
           if(musAct[0].Incl_Marketing_activity_Detail__c==false){
                performanceButtonView=false;
            }
            else if(musAct[0].Incl_Marketing_activity_Detail__c==true){
                 performanceButtonView=true;  
             }  
        } else
           performanceButtonView=false;    
        /* Filter End here */
        
        fys = [SELECT Id, Name FROM FiscalYearSettings where EndDate>:System.today() order by Name];        
    } 
    
    /* Filter Starts here */
    public List<SelectOption> FilterList{
        get
        {
            Filter_Temp = [Select u.Name, u.Id From User_setting__c u Where (Userid__c = :UserInfo.getUserId() or Global__c = :true) and Gantt_type__c = :0  limit 250];
            
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
    
    public List<selectOption> getPickValues(Sobject object_name, String field_name) {
          List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
          
          Schema.sObjectType sobject_type = object_name.getSObjectType(); //grab the sobject that was passed
          Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
          Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
          List<Schema.PicklistEntry> pick_list_values = field_map.get(field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
          for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
                      
                options.add(new selectOption(a.getValue(), a.getLabel())); //add the value and label to our final list
          }
          return options; //return the List
    }
    
    public boolean displayPopup {get; set;}              
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
        for(String a : selectedFilterTypes) {
           filterliststring += (filterliststring==''?'':',')+a;
        }
        String plliststring = '';
        for(String a : selectedPriorityLevels) {
           plliststring += (plliststring==''?'':',')+a;
        }
        w.writeStartElement(null,'plantype',null);   
        w.writeCharacters(filterliststring);
        w.writeEndElement();
		w.writeStartElement(null,'prioritylevel',null);   
        w.writeCharacters(plliststring);
        w.writeEndElement();        
        w.writeEndElement();
        w.writeEndDocument();
        string xml = w.getXmlString();
        w.close(); 
        if(mydefaultFilter){
            List<User_setting__c> muss = [SELECT Id, My_default__c FROM User_setting__c WHERE Userid__c = :UserInfo.getUserId() and Gantt_type__c = :0 limit 250];
            for (User_setting__c a : muss){
               a.My_default__c = false;
               update a;
            }
            
        }
        
        if(selectedFilter == '0'){
            Ganttviewsetting = new User_setting__c(); 
            Ganttviewsetting.Name = FilterName;
            Ganttviewsetting.Userid__c = UserInfo.getUserId();
            Ganttviewsetting.Gantt_type__c = 0;
            Ganttviewsetting.Ganttview__c = xml;
            Ganttviewsetting.Global__c = GlobalFilter;
            Ganttviewsetting.My_default__c = mydefaultFilter;
            insert Ganttviewsetting;
        }else {
            Ganttviewsetting.Id = selectedFilter;
            Ganttviewsetting.Name = FilterName;
            Ganttviewsetting.Userid__c = UserInfo.getUserId();
            Ganttviewsetting.Gantt_type__c = 0;
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
        loadganttviewbyFilter();
    } 
    public void DeleteFilter() { 
        User_setting__c Ganttviewsetting = new User_setting__c();        
        Ganttviewsetting.Id = selectedFilter;
        delete Ganttviewsetting;    
        selectedFilter = '0';
        displayPopUp = false;
        loadganttviewbyFilter();              
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
                String filterString = get_musqot_filter.Ganttview__c;
                if(!filterString.contains('<prioritylevel>')) {
                    root.addChildElement('prioritylevel', null, null);
                }
                string prioritylevel = root.getChildElement('prioritylevel', null).getText();
                selectedPriorityLevels = prioritylevel.split(',');
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
            selectedPriorityLevels= new List<String>();
            FilterZooming = 'Weeks';
            FilterStartDate = System.today().addMonths(-1);
            FilterEndDate = System.today().addMonths(3);
            GlobalFilter = false;
            mydefaultFilter = false;  
            isGlobaluser = false;
        }
        
    }  
    
    // node info block
    public boolean displayInfoPopup {get; set;}
    public string projectName {get; set;}
    public string projectDescription {get; set;}
    public string projectStatus {get; set;}
    public date projectStartDate {get;set;}
    public date projectEndDate {get;set;}
    public string projectOwner {get; set;}
    
    public List<SelectOption> getProjectStatusList() {
        List<SelectOption> options = new List<SelectOption>(); 
        Schema.DescribeFieldResult field = Project__c.Status__c.getDescribe();
        for (Schema.PicklistEntry f : field.getPicklistValues()){
            options.add(new SelectOption(f.getLabel(), f.getLabel()));
        }   
        return options;     
    }
    
    public void loadganttviewbyFilter(){ 
        if(selectedFilter <> '0'){
            lnkfilterTitle = label.btn_Edit;
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
            selectedPriorityLevels = new List<String>();
            //showPopup();
        }
        //getdataString();      
    } 
    
    
    public string getganttviewbyFilter(){
        musqot__User_setting__c musqot_filterSetting = new musqot__User_setting__c();
        try{            
            musqot_filterSetting = [SELECT Id, Name, Ganttview__c FROM User_setting__c WHERE Id = :selectedFilter and Gantt_type__c = 0 limit 50]; 
            DOM.Document doc = new DOM.Document();      
            try 
            {   
                doc.load(musqot_filterSetting.musqot__Ganttview__c);    
                DOM.XMLNode root = doc.getRootElement();
                string plantype = root.getChildElement('plantype', null).getText();
                FilterTypes = plantype.split(',');                                            
                // Something to hold the data
                List<GanttRow> renderRows = new List<GanttRow>();
                
                // Fetch project list
                List<Project__c> projectList = [SELECT Id, Name, Status__c, StatusImage__c, Plantype__r.Name, CreatedById, Starts_date__c, Ends_date__c, Description__c,
                                                   (select Id, Name, CreatedById, Status__c, StatusImage__c,Starts_date__c, Ends_date__c,Project_del__c, Description__c, Parent_project__c, Project_type__r.Name 
                                                    from Subproject_1__r order by Starts_date__c)
                                               FROM Project__c 
                                               WHERE IsDeleted = false 
                                               and Plantype__c IN :FilterTypes
                                               order by Starts_date__c limit 25000];
                
                
                // query marketing activities
                Set<Id> prjSet = new Set<Id>();
                for(Project__c pr : projectList){
                    for(Subproject__c sp : pr.Subproject_1__r){
                        prjSet.add(sp.Id);
                    }
                }
                Map<Id,List<Marketing_activity__c>> mrkMap = new Map<Id,List<Marketing_activity__c>>();
                
                List<Subproject__c> spList = [select Id,Name,(select Id,Name,multi_pubication__c,Activitytype__r.Icon__c,Activitytype__r.Name,Activitytype__r.Bar_color__c,Ends_date__c,Starts_date__c,Project__c,StatusImage__c,Status__c,Description__c,Project__r.Name 
                                                              from Marketing_activities__r order by Starts_date__c) 
                                              from Subproject__c where Id IN :prjSet ];
                //if(musAct[0].musqot__Incl_Marketing_activity_Main__c==true){
                    for(Subproject__c sPrj : spList){
                        mrkMap.put(sPrj.Id,sPrj.Marketing_activities__r);
                    }
               // }
                
                
                // Iterate over Projects to build supporting JSON
                for( Project__c p : projectList ){
                    
                    // Create a subscored name
                    string n = (p.Plantype__c != null) ? String.valueOf(p.Plantype__c).replaceAll(' ', '_') : 'default';
                    n =  n.replaceAll('-','_');
                    
                    // Create a new row object
                    GanttRow rp = new GanttRow();
                    rp.idPH = p.Id;
                    rp.text = escapeSpecialChars(p.Name);
                    rp.typePH = '!!!gantt.config.types.'+ n +'!!!';
                    rp.setStartDate(date.newinstance(p.Starts_date__c.year(), p.Starts_date__c.month(), p.Starts_date__c.day()));  // hs fix start date
                    rp.description = escapeSpecialChars(p.Description__c);
                    rp.setDuration(date.newinstance(p.Starts_date__c.year(), p.Starts_date__c.month(), p.Starts_date__c.day()-1), p.Ends_date__c);
                    rp.progress = 1;
                    rp.open = true;
                    rp.objType = 'project';
                    if(p.StatusImage__c<>null){
                        rp.img = p.StatusImage__c.replace('alt=','title=');     
                    }
                    
                    // Add it into the renderRows list
                    renderRows.add(rp);
                    
                    // Iterate over sub projects
                    for( Subproject__c sp : p.Subproject_1__r){
                        
                        // Create a subscored name
                        string sn = (sp.Project_type__c!= null) ? String.valueOf(sp.Project_type__c).replaceAll(' ', '_') : 'default';
                        sn = sn.replaceAll('-','_');
                        
                        // Create a new row object
                        GanttRow rsp = new GanttRow();
                        rsp.idPH = sp.Id;
                        rsp.text = escapeSpecialChars(sp.Name);
                        rsp.typePH = '!!!gantt.config.types.'+ sn +'!!!';
                        rsp.setStartDate(date.newinstance(sp.Starts_date__c.year(), sp.Starts_date__c.month(), sp.Starts_date__c.day()));  // hs fix startdate
                		rsp.setDuration(date.newinstance(sp.Starts_date__c.year(), sp.Starts_date__c.month(), sp.Starts_date__c.day()-1), sp.Ends_date__c);
                        rsp.description = escapeSpecialChars(sp.Description__c);                
                        rsp.progress = 1;
                        rsp.open = false;
                        rsp.objType = 'subproject';
                        if(sp.Project_del__c <> null){
                            rsp.parent = sp.Project_del__c;
                        }
                        else{
                            rsp.parent = sp.Parent_project__c;
                        }
                        if(sp.StatusImage__c<>null){
                            rsp.img = sp.StatusImage__c.replace('alt=','title=');
                        }
                        
                        // Add it into the renderRows list
                        renderRows.add(rsp);   
                        
                        for(Marketing_activity__c ma : mrkMap.get(sp.Id)){
                            
                            //Create a subscored name
                            String ms = (ma.Activitytype__c!= null) ? String.valueOf(ma.Activitytype__c).replaceAll(' ', '_') : 'default';
                            ms = ms.replaceAll('-','_');
                            
                            //Create a new row object
                            GanttRow mr = new GanttRow();
                            mr.idPH = ma.Id;
                            mr.text = escapeSpecialChars(ma.Name);
                            mr.typePH = '!!!gantt.config.types.'+ ms +'!!!';  
                            
                            if(ma.Starts_date__c<>null && ma.Ends_date__c<>null){                  
                                mr.setStartDate(date.newinstance(ma.Starts_date__c.year(), ma.Starts_date__c.month(), ma.Starts_date__c.day()));   // hs fix start date                  
                                if(date.newinstance(ma.Starts_date__c.year(), ma.Starts_date__c.month(), ma.Starts_date__c.day()-1).daysBetween(date.newinstance(ma.Ends_date__c.year(), ma.Ends_date__c.month(), ma.Ends_date__c.day()))==0){
                                    mr.Duration = 1;    
                                }
                                else{
                                    mr.setDuration(date.newinstance(ma.Starts_date__c.year(), ma.Starts_date__c.month(), ma.Starts_date__c.day()-1), date.newinstance(ma.Ends_date__c.year(), ma.Ends_date__c.month(), ma.Ends_date__c.day()));  
                                } 
                            }                 
                            mr.description = escapeSpecialChars(ma.Description__c);                    
                            mr.progress = 1;
                            mr.open = false;
                            mr.parent = ma.Project__c;
                            mr.objType = 'activity';
                            mr.actImg = '<img src=\''+ma.Activitytype__r.Icon__c+'\'title=\''+ma.Name+', '+ma.Activitytype__r.Name+'\' style=\'float:left\'/>';
                            if(ma.StatusImage__c<>null){
                                mr.img = ma.StatusImage__c.replace('alt=','title=');
                            } 
                            
                            // Add it into the renderRows list
                            renderRows.add(mr);   
                        }
                    }                 
                }   
                
                // Json Template
                JsonWrapper wrapperfilter = new JsonWrapper();
                wrapperfilter.data = renderRows;
                
                // Replace sf reserved object names with their realname before output.
                return JSON.serialize(wrapperfilter).replaceAll('idPH','id').replaceAll('typePH','type').replaceAll('"!!!','').replaceAll('!!!"','');
            }
            catch (System.XMLException e) {   
                return null;
            }
        }
        catch (Exception e) {
            musqot_filterSetting = new musqot__User_setting__c();
            return null;
        }
    }
    /* Filter End here */
    
    /****** Convert lookup to dropdown of plantype List *****/     
    
    public List<SelectOption> PLANList
    {
        get
        {
            PLAN_Temp = [Select u.Name, u.Id From plantype__c u limit 250];
            PLANList= new List<SelectOption>(); 
            for(plantype__c objPLA: PLAN_Temp )
            {
                PLANList.add(new SelectOption(objPLA.Id, objPLA.Name));
            }
            return PLANList;
        }
        set;
    }
    
    /**** Displaying plans based selected plan types *****/
    
    public void showSelectedPlanTypes(){        
        getdataString();
    }
    
    /************* Praparing style for projects types *****/ 
    public String getstyleString(){
        
        String style = '';
        if(ptypes.isEmpty() == false){
            for(Project_type__c s : ptypes ){
                
                String n = String.valueOf(s.Id).replaceAll(' ','_');          
                // Basic task style
                style = style + '.' + n + '_task{';
                style = style + 'border:2px solid ' + '#' + s.Color__c + ';';
                style = style + 'color:#000;';
                style = style + 'background:#' + s.Color__c + ';}';
                
                // Task progress style
                style = style + '.' + n + '_task .gantt_task_progress{';
                style = style + 'background:#' + s.Color__c + ';}';
            }
        }
        return style;
    }
    
    /****** Praparing style for Plans *****/
    public String gettaskstyleString(){        
        String style = '';        
        if(!plntypes.isEmpty()){
            for( plantype__c s : plntypes){
                String n = String.valueOf(s.Id).replaceAll(' ','_');
                
                // Basic task style
                style = style + '.' + n + '_task{';
                style = style + 'border:2px solid ' + '#' + s.Barcolor__c + ';';
                style = style + 'color:#000;';
                style = style + 'background-color:#' + s.Barcolor__c + ';}';
                
                // Task progress style
                style = style + '.' + n + '_task .gantt_task_progress{';
                style = style + 'background-color:#' + s.Barcolor__c + ';}';
            }
            
        } 
        
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
        for( Project_type__c s : ptypes ){            
            String n = String.valueOf(s.Id).replaceAll(' ','_');
            n = n.replaceAll('-','_');            
            js = js + 'gantt.config.types.' + n + ' = "' + n + '";';
            js = js + 'gantt.locale.labels.type_' + n + ' = "' + s.Name +'";';
        }
        
        // First declare the config types & locales
        for( plantype__c s : plntypes ){
            String n = String.valueOf(s.Id).replaceAll(' ','_');           
            n = n.replaceAll('-','_');
            js = js + 'gantt.config.types.' + n + ' = "' + n + '";';
            js = js + 'gantt.locale.labels.type_' + n + ' = "' + String.valueOf(s.Id) +'";';
        }
        
        for(Activitytype__c s : acttypes){            
            String n = String.valueOf(s.Id).replaceAll(' ','_');
            n = n.replaceAll('-','_');
            js = js + 'gantt.config.types.' + n + ' = "' + n + '";';
            js = js + 'gantt.locale.labels.type_' + n + ' = "' + s.Name +'";';
        }
        
        // Then build the ,mapping function
        js = js + 'gantt.templates.task_class = function(start, end, task){';
        for( Project_type__c s : ptypes ){            
            String n = String.valueOf(s.Id).replaceAll(' ','_');
            n = n.replaceAll('-','_');
            
            // Basic task style         
            js = js + 'if(task.type == gantt.config.types.' + n + '){';
            js = js + 'return "' + n + '_task";}';
        }
        
        for( plantype__c s : plntypes ){            
            String n = String.valueOf(s.Id).replaceAll(' ','_');
            n = n.replaceAll('-','_');
            
            // Basic task style         
            js = js + 'if(task.type == gantt.config.types.' + n + '){';
            js = js + 'return "' + n + '_task";}';
        }
        
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
    
    /******** replacing special characters with html codes********/ 
    
    private String escapeSpecialChars(String str){
        if(str <> null){
            str = str.replaceAll('<','&lt;');
            str = str.replaceAll('>','&gt;');
        }else{
            str = '';
        }
        
        return str;
    }
    
    /**** preparing plan, sub project and marketing data string in json format *****/
    public String getdataString(){
        Set<String> selectedPriorityLevelsSet = new Set<String>();
        for(String pl : selectedPriorityLevels)
            selectedPriorityLevelsSet.add(pl);
        
        musqot__User_setting__c musqot_filterSetting = new musqot__User_setting__c();
        try{            
            musqot_filterSetting = [SELECT Id, Name, Ganttview__c FROM User_setting__c 
                                    WHERE Id = :selectedFilter and Gantt_type__c = 0 limit 50]; 
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
        List<GanttRow> renderRows = new List<GanttRow>();
        List<Project__c> projectList = new List<Project__c>();
        
        // added/modified by Narendra - start -
        List<Musqot_member__c> allPlans = [SELECT Id, Plan__c FROM Musqot_member__c where userid__c =:UserInfo.getUserId()];
        List<Id> plansToFetch = new List<Id>();
        for(Musqot_member__c member : allPlans)
			plansToFetch.add(member.Plan__c);
        
        
        String query = 'SELECT Id,  Name,Owner.Name, Status__c, StatusImage__c, Plantype__r.Name, CreatedById, Starts_date__c, Ends_date__c, Description__c,'+
                       '(select Id, Owner.Name,Priority_level__c, Name, CreatedById, Status__c, StatusImage__c,Starts_date__c, Ends_date__c,Project_del__c, Description__c, Parent_project__c, Project_type__r.Name '+
                       'from Subproject_1__r order by Starts_date__c) FROM Project__c WHERE IsDeleted = false'; 
       
        if(selectedFilter <> '0'){
            if(FilterTypes != null) {
                if(FilterTypes.size() > 0) {
                    query += ' and Plantype__c IN :FilterTypes';
                } 
            } 
        } else {
           if(selectedTypes != null) {
                if(selectedTypes.size() > 0) {
                    query += ' and Plantype__c IN :selectedTypes';
                } 
            } 
        }
        if(musAct[0].Plan_access_controll__c==true && MyProflieName != 'System Administrator'){
            query += ' and Id IN :plansToFetch';
        }
        query += ' order by Starts_date__c limit 25000';
        
        projectList = Database.query(query);
        
        
        // query marketing activities
        Set<Id> prjSet = new Set<Id>();
        for(Project__c pr : projectList){
            for(Subproject__c sp : pr.Subproject_1__r){
                prjSet.add(sp.Id);
            }
        }
        Map<Id,List<Marketing_activity__c>> mrkMap = new Map<Id,List<Marketing_activity__c>>();
        
        List<Subproject__c> spList = [select Id,Name,
                                        (select Id,Name,Owner.Name,multi_pubication__c,Activitytype__r.Icon__c,Activitytype__r.Name,Activitytype__r.Bar_color__c,Ends_date__c,Starts_date__c,Project__c,StatusImage__c,Status__c,Description__c,Project__r.Name 
                                         from Marketing_activities__r order by Starts_date__c)
                                      from Subproject__c where Id IN :prjSet ];
        // added/modified by Narendra
        Set<Id> maSet = new Set<Id>();
        if(musAct[0].musqot__Incl_Marketing_activity_Main__c==true){
            for(Subproject__c sPrj : spList){
                mrkMap.put(sPrj.Id,sPrj.Marketing_activities__r);
                for(Marketing_activity__c ma : sPrj.Marketing_activities__r){
                    maSet.add(ma.Id);
                }
            }
         }
        
        List<Task> tasksForSp = [Select Id, Owner.Name, WhoId, WhatId, Subject, ActivityDate, Status, Priority, OwnerId,CreatedById, Description, IsDeleted, AccountId, IsClosed,  Allocated_h__c, Outcome_h__c,Task_description__c,Task_name__c, StatusImage__c   
                                       FROM Task where whatid IN :prjSet limit 400];
        
        Map<Id,List<Task>> tasksForSpMap = new Map<Id,List<Task>>();
        List<Task> currTaskList  = new List<Task>();
        Id currTaskWhatId = null;
        for(Integer i=0; i<tasksForSp.size(); i++) {
            Task t = tasksForSp.get(i);
            if(currTaskWhatId != null) {
                if(currTaskWhatId != t.WhatId) {
                    tasksForSpMap.put(currTaskWhatId, currTaskList);
                    currTaskList = new List<Task>();
                }
            }
            currTaskWhatId = t.WhatId;
            currTaskList.add(t);
            if(i == (tasksForSp.size()-1)) {
                tasksForSpMap.put(currTaskWhatId, currTaskList);
                currTaskList = new List<Task>();
                currTaskWhatId = null;
            }   
        }
        
        List<Task> tasksForMa = [Select Id, Owner.Name, WhoId, WhatId, Subject, ActivityDate, Status, Priority, OwnerId,CreatedById, Description, IsDeleted, AccountId, IsClosed,  Allocated_h__c, Outcome_h__c,Task_description__c,Task_name__c, StatusImage__c   
                                       FROM Task where whatid IN :maSet limit 400];
        
        Map<Id,List<Task>> tasksForMaMap = new Map<Id,List<Task>>();
        for(Integer i=0; i<tasksForMa.size(); i++) {
            Task t = tasksForMa.get(i);
            if(currTaskWhatId != null) {
                if(currTaskWhatId != t.WhatId) {
                    tasksForMaMap.put(currTaskWhatId, currTaskList);
                    currTaskList = new List<Task>();
                }
            }
            currTaskWhatId = t.WhatId;
            currTaskList.add(t);
            if(i == (tasksForMa.size()-1)) {
                tasksForMaMap.put(currTaskWhatId, currTaskList);
                currTaskList = new List<Task>();
                currTaskWhatId = null;
            }   
        }
        
        List<Marketing_activity_dates__c> subMAs = [SELECT Id, Name, Owner.Name, Start_date__c, 
                                                    End_date__c, Marketing_activity__c FROM Marketing_activity_dates__c 
                                                    where Marketing_activity__c IN:maSet limit 400];
        
        Map<Id,List<Marketing_activity_dates__c>> subMAsMap = new Map<Id,List<Marketing_activity_dates__c>>();
        List<Marketing_activity_dates__c> currMaList  = new List<Marketing_activity_dates__c>();
        Id currMaRefId = null;
        for(Integer i=0; i<subMAs.size(); i++) {
            Marketing_activity_dates__c ma = subMAs.get(i);
            if(currMaRefId != null) {
                if(currMaRefId != ma.Marketing_activity__c) {
                    subMAsMap.put(currMaRefId, currMaList);
                    currMaList = new List<Marketing_activity_dates__c>();
                }
            }
            currMaRefId = ma.Marketing_activity__c;
            currMaList.add(ma);
            if(i == (subMAs.size()-1)) {
                subMAsMap.put(currMaRefId, currMaList);
                currMaList = new List<Marketing_activity_dates__c>();
                currMaRefId = null;
            }   
        }

        // Iterate over Projects to build supporting JSON
        for( Project__c p : projectList ){
        
            // Create a subscored name
            string n = (p.Plantype__c != null) ? String.valueOf(p.Plantype__c).replaceAll(' ', '_') : 'default';
            n =  n.replaceAll('-','_');
            
            // Create a new row object
            GanttRow rp = new GanttRow();
            rp.idPH = p.Id;
            rp.text = escapeSpecialChars(p.Name);
            rp.typePH = '!!!gantt.config.types.'+ n +'!!!';
            rp.setStartDate(date.newinstance(p.Starts_date__c.year(), p.Starts_date__c.month(), p.Starts_date__c.day()));  // hs fix start date
            rp.description = escapeSpecialChars(p.Description__c);
            rp.setDuration(date.newinstance(p.Starts_date__c.year(), p.Starts_date__c.month(), p.Starts_date__c.day()-1), p.Ends_date__c);
            rp.progress = 1;
            rp.open = true;
            rp.objType = 'project';
            if(p.StatusImage__c<>null){
                rp.img = p.StatusImage__c.replace('alt=','title=');     
            }
            rp.projectType = p.Plantype__r.Name;
            rp.owner = p.Owner.Name;
            rp.status = p.Status__c;
            // Add it into the renderRows list
            renderRows.add(rp);
            
            // Iterate over sub projects
            for( Subproject__c sp : p.Subproject_1__r){
                            
                // Create a subscored name
                string sn = (sp.Project_type__c!= null) ? String.valueOf(sp.Project_type__c).replaceAll(' ', '_') : 'default';
                sn = sn.replaceAll('-','_');
                
                // Create a new row object
                GanttRow rsp = new GanttRow();
                rsp.idPH = sp.Id;
                rsp.text = escapeSpecialChars(sp.Name);
                rsp.typePH = '!!!gantt.config.types.'+ sn +'!!!';
                rsp.setStartDate(date.newinstance(sp.Starts_date__c.year(), sp.Starts_date__c.month(), sp.Starts_date__c.day())); // hs fix start date
                rsp.setDuration(date.newinstance(sp.Starts_date__c.year(), sp.Starts_date__c.month(), sp.Starts_date__c.day()-1), sp.Ends_date__c);
                rsp.description = escapeSpecialChars(sp.Description__c);                
                rsp.progress = 1;
                rsp.open = false;
                rsp.objType = 'subproject';
                if(sp.Project_del__c <> null){
                    rsp.parent = sp.Project_del__c;
                }
                else{
                    rsp.parent = sp.Parent_project__c;
                }
                if(sp.StatusImage__c<>null){
                    rsp.img = sp.StatusImage__c.replace('alt=','title=');
                }
                rsp.projectType = sp.Project_type__r.Name;
                rsp.owner = sp.Owner.Name;
                rsp.priorityLevel = sp.Priority_level__c;
                rsp.isPriority = selectedPriorityLevelsSet.contains(sp.Priority_level__c);
                rsp.status = sp.Status__c;
                // Add it into the renderRows list
                renderRows.add(rsp);   
                //
                if(mrkMap<>null &&  mrkMap.containsKey(sp.Id) == true){
                    for(Marketing_activity__c ma : mrkMap.get(sp.Id)){
                        
                        //Create a subscored name
                        String ms = (ma.Activitytype__c!= null) ? String.valueOf(ma.Activitytype__c).replaceAll(' ', '_') : 'default';
                        ms = ms.replaceAll('-','_');
                        
                        //Create a new row object
                        GanttRow mr = new GanttRow();
                        mr.idPH = ma.Id;
                        mr.text = escapeSpecialChars(ma.Name);
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
                        mr.description = escapeSpecialChars(ma.Description__c);                    
                        mr.progress = 1;
                        mr.open = false;
                        mr.parent = ma.Project__c;
                        mr.objType = 'activity';
                        mr.actImg = '<img src=\''+ma.Activitytype__r.Icon__c+'\'title=\''+ma.Name+', '+ma.Activitytype__r.Name+'\' style=\'float:left\'/>';
                        if(ma.StatusImage__c<>null){
                            mr.img = ma.StatusImage__c.replace('alt=','title=');
                        } 
                        mr.projectType = ma.Activitytype__r.Name;
                		mr.owner = ma.Owner.Name;
                        mr.status = ma.Status__c;
                        // Add it into the renderRows list
                        renderRows.add(mr);
                        
                        // sub activities
                        if(ma.multi_pubication__c) {
                            if(subMAsMap.containsKey(ma.Id)) {
                                for(Marketing_activity_dates__c subma : subMAsMap.get(ma.Id)){
                                    //Create a new row object
                                    GanttRow submar = new GanttRow();
                                    submar.idPH = subma.Id;
                                    submar.text = escapeSpecialChars(subma.Name); 
                                    submar.typePH = '!!!gantt.config.types.'+ ms +'!!!'; 
                                    if(subma.Start_date__c<>null && subma.End_date__c<>null){                  
                                        submar.setStartDate(subma.Start_date__c);                
                                        if(date.newinstance(subma.Start_date__c.year(), subma.Start_date__c.month(), subma.Start_date__c.day()-1).daysBetween(date.newinstance(subma.End_date__c.year(), subma.End_date__c.month(), subma.End_date__c.day()))==0){
                                            submar.Duration = 1;    
                                        }
                                        else{
                                            submar.setDuration(date.newinstance(subma.Start_date__c.year(), subma.Start_date__c.month(), subma.Start_date__c.day()-1), date.newinstance(subma.End_date__c.year(), subma.End_date__c.month(), subma.End_date__c.day()));  
                                        } 
                                    }                    
                                    submar.progress = 1;
                                    submar.open = false;
                                    submar.parent = subma.Marketing_activity__c;
                                    submar.objType = 'subactivity';
                                    submar.actImg = '<img src=\''+ma.Activitytype__r.Icon__c+'\'title=\''+ma.Name+', '+ma.Activitytype__r.Name+'\' style=\'float:right\'/>';
                                    if(ma.StatusImage__c<>null){
                                        submar.img = ma.StatusImage__c.replace('alt=','title=');
                                    } 
                                    submar.projectType = ma.Activitytype__r.Name;
                                    submar.owner = ma.Owner.Name;
                                    submar.status = ma.Status__c;
                                    // Add it into the renderRows list
                                    renderRows.add(submar);
                                }
                            }
                        }
                        // getting tasks so that it can be updated whenever its parent nodes are moved
                		// tasks are not shown on gantt page
                        // tasks under marketing activities
                        if(tasksForMaMap.containsKey(ma.Id)) {
                            for(Task t : tasksForMaMap.get(ma.Id)){
                                String ts = 'default';
                                // Create a new row object
                                GanttRow rtp = new GanttRow();
                                rtp.idPH = t.Id;
                                rtp.text = escapeSpecialChars(t.Task_name__c);
                                rtp.typePH = '!!!gantt.config.types.'+ ts +'!!!';
                                rtp.setStartDate(date.newinstance(t.ActivityDate.year(), t.ActivityDate.month(), t.ActivityDate.day()));
                                rtp.description = escapeSpecialChars(t.Description);
                                rtp.Duration = 1;
                                //rtp.setDuration(t.ActivityDate, t.ActivityDate);
                                rtp.progress = 1;
                                rtp.open = false;
                                rtp.parent = t.WhatId;
                                rtp.objType = 'task';
                                rtp.actImg = '<img src=\'/resource/1439451905000/musqot__Task_icon\' title=\''+t.Task_name__c+'\' style=\'float:left\'/>';
                                if(t.StatusImage__c<>null){
                                    rtp.img = t.StatusImage__c.replace('alt=','title=');     
                                }
                                rtp.projectType = t.Subject;
                				rtp.owner = t.Owner.Name;
                                rtp.status = t.Status;
                                // Add it into the renderRows list
                                renderRows.add(rtp);
                            }
                        }
                    }
               }
                // getting tasks so that it can be updated whenever its parent nodes are moved
                // tasks are not shown on gantt page
				// tasks under projects, subprojects
                if(tasksForSpMap.containsKey(sp.Id)) {
                    for( Task t : tasksForSpMap.get(sp.Id)){  
                        // Create a subscored name
                        // This  ts should be colort for task
                        String ts = 'default';
                        // Create a new row object
                        GanttRow rtp = new GanttRow();
                        rtp.idPH = t.Id;
                        rtp.text = escapeSpecialChars(t.Task_name__c);
                        rtp.typePH = '!!!gantt.config.types.'+ ts +'!!!';
                        rtp.setStartDate(date.newinstance(t.ActivityDate.year(), t.ActivityDate.month(), t.ActivityDate.day()));
                        rtp.description = escapeSpecialChars(t.Description);
                        rtp.Duration = 1;
                        //rtp.setDuration(t.ActivityDate, t.ActivityDate);
                        rtp.progress = 1;
                        rtp.open = false;
                        rtp.parent = sp.Id;
                        rtp.objType = 'task';
                        rtp.actImg = '<img src=\'/resource/1439451905000/musqot__Task_icon\' title=\''+t.Task_name__c+'\' style=\'float:left\'/>';
                        if(t.StatusImage__c<>null){
                            rtp.img = t.StatusImage__c.replace('alt=','title=');     
                        }
                        rtp.projectType = t.Subject;
                		rtp.owner = t.Owner.Name;
                        rtp.status = t.Status;
                        // Add it into the renderRows list
                        renderRows.add(rtp);
                    }
                }
            }                 
        }   
        
        // Json Template
        JsonWrapper wrapper = new JsonWrapper();
        wrapper.data = renderRows;
        
        // Replace sf reserved object names with their realname before output.
        return JSON.serialize(wrapper).replaceAll('idPH','id').replaceAll('typePH','type').replaceAll('"!!!','').replaceAll('!!!"','');
        
    }
    
    
    
    /****** Navigate to Gantt Performance *****/    
    public pageReference gotoPerformancePage(){
        return new PageReference('/apex/GanttPerformance');
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
        public String projectType{get;private set;}
        public String owner{get;private set;}
        public String priorityLevel{get;private set;}
        public Boolean isPriority{get;private set;}
        public String status{get;private set;}
        
        public void setStartDate(Date val){
            DateTime d = val;
            start_date =  d.format('dd-MM-yyyy');       
        }
        
        public void setDuration(Date starts, Date ends){
            duration =  starts.daysBetween(ends);   
        }
    }
        
     public List<String> getselectedFilterTypes() {
            return selectedFilterTypes;
     }

    public void selectedFilterTypes(List<String> selectedFilterTypes) {
        this.selectedFilterTypes= selectedFilterTypes;
    }
    
    public List<String> getselectedPriorityLevels() {
            return selectedPriorityLevels;
     }

    public void selectedPriorityLevels(List<String> selectedPriorityLevels) {
        this.selectedPriorityLevels= selectedPriorityLevels;
    }
    
    /****** Method to create plan copy. *****/
    webService static String createPlanCopy(String id, String name, Date sd, boolean subsub, boolean activities, 
                                            boolean ownernmember, boolean budget, boolean overnattach, boolean milestonenp,
                                           String fydd) {
        Datetime dt = System.now();
        Project__c newPlan = [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, 
                              LastModifiedById, SystemModstamp, LastActivityDate, LastViewedDate, LastReferencedDate, 
                              Description__c, Starts_date__c, Ends_date__c, Status_Image_Id__c, ERP__c, Status__c, Headline__c,
                              CRM__c, Social_media__c, Plantype__c, StatusImage__c  
                              FROM Project__c where id =:id limit 1];
        newPlan.id = null;
        newPlan.Name = name;
        Integer difference = newPlan.Starts_date__c.daysBetween(sd);
        newPlan.Ends_date__c = newPlan.Ends_date__c.addDays(difference);
        newPlan.Starts_date__c = sd;
        newPlan.Status__c = 'Not Started';
        if(!milestonenp) {
            newPlan.ERP__c = null;
            newPlan.CRM__c = null;
            newPlan.Social_media__c = null;
        }
        insert newPlan;
        
        Map<String,String> subProsOldNew = new Map<String,String>();
        Map<String,String> subProsNewOld = new Map<String,String>();
        if(subsub) {
            List<Subproject__c> spsToUpdateOldId = [SELECT Id, tempId__c FROM Subproject__c where Parent_project__c =:id];
            for(Subproject__c sp : spsToUpdateOldId) {
                sp.tempId__c = sp.Id;
            }
            update spsToUpdateOldId;
            
            List<Subproject__c> sps = [SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, 
                                   LastModifiedById, SystemModstamp, LastActivityDate, Parent_project__c, Ends_date__c, 
                                   Starts_date__c, Description__c, Project_type__c, planid__c, Project_del__c, Status__c, 
                                   Status_Image_Id__c, StatusImage__c, Priority_level__c, CRM__c, ERP__c, Social_media__c,  
                                   oldId__c,tempId__c FROM Subproject__c where Parent_project__c =:id];
            
            List<String> oldIds = new List<String>();
            for(Subproject__c sp : sps) {
                sp.id = null;
                sp.Ends_date__c = sp.Ends_date__c.addDays(difference);
                sp.Starts_date__c = sp.Starts_date__c.addDays(difference);
                sp.Status__c = 'Not Started';
                sp.Parent_project__c = newPlan.id;
                if(!milestonenp) {
                    sp.ERP__c = null;
                    sp.CRM__c = null;
                    sp.Social_media__c = null;
                }
                sp.oldId__c = sp.tempId__c;
                oldIds.add(sp.tempId__c);
                sp.tempId__c = null;
            }
            insert sps; 
            List<Subproject__c> sps1 = [SELECT Id, oldId__c,Project_del__c FROM Subproject__c where oldId__c IN:oldIds and CreatedDate>=:dt];
            for(Subproject__c sp : sps1) {
                subProsOldNew.put(sp.oldId__c, sp.id);
                subProsNewOld.put(sp.id, sp.oldId__c);
            }

            for(Subproject__c sp : sps1) {
                if(sp.Project_del__c != null)
                	sp.Project_del__c = subProsOldNew.get(sp.Project_del__c);
            }
            update sps1;
        } else {
            List<Subproject__c> spsToUpdateOldId = [SELECT Id, tempId__c FROM Subproject__c where Parent_project__c =:id and Project_del__c=null];
            for(Subproject__c sp : spsToUpdateOldId) {
                sp.tempId__c = sp.Id;
            }
            update spsToUpdateOldId;
            
            List<Subproject__c> directChildSPs = [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, 
                                   LastModifiedById, SystemModstamp, LastActivityDate, Parent_project__c, Ends_date__c, 
                                   Starts_date__c, Description__c, Project_type__c, planid__c, Project_del__c, Status__c, 
                                   Status_Image_Id__c, StatusImage__c, Priority_level__c, CRM__c, ERP__c, Social_media__c, oldId__c,tempId__c 
                                   FROM Subproject__c where Parent_project__c =:id and Project_del__c=null];
            
            List<String> oldIds = new List<String>();
            for(Subproject__c sp : directChildSPs) {
                sp.id = null;
                sp.Ends_date__c = sp.Ends_date__c.addDays(difference);
                sp.Starts_date__c = sp.Starts_date__c.addDays(difference);
                sp.Status__c = 'Not Started';
                sp.Parent_project__c = newPlan.id;
                if(!milestonenp) {
                    sp.ERP__c = null;
                    sp.CRM__c = null;
                    sp.Social_media__c = null;
                }
                sp.oldId__c = sp.tempId__c;
                oldIds.add(sp.tempId__c);
                sp.tempId__c = null;
            }
            
            insert directChildSPs;
            List<Subproject__c> sps1 = [SELECT Id, oldId__c FROM Subproject__c where oldId__c IN:oldIds and CreatedDate>=:dt];
            for(Subproject__c sp : sps1) {
                subProsOldNew.put(sp.oldId__c, sp.id);
                subProsNewOld.put(sp.id, sp.oldId__c);
            }
            
            spsToUpdateOldId = [SELECT Id, tempId__c FROM Subproject__c where Project_del__c IN:subProsOldNew.keySet()];
            for(Subproject__c sp : spsToUpdateOldId) {
                sp.tempId__c = sp.Id;
            }
            update spsToUpdateOldId;
            List<Subproject__c> secondLevelSPS = [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, 
                                   LastModifiedById, SystemModstamp, LastActivityDate, Parent_project__c, Ends_date__c, 
                                   Starts_date__c, Description__c, Project_type__c, planid__c, Project_del__c, Status__c, 
                                   Status_Image_Id__c, StatusImage__c, Priority_level__c, CRM__c, ERP__c, Social_media__c,oldId__c,tempId__c  
                                   FROM Subproject__c where Project_del__c IN:subProsOldNew.keySet()];
            
            oldIds = new List<String>();
            for(Subproject__c sp : secondLevelSPS) {
                sp.id = null;
                sp.Ends_date__c = sp.Ends_date__c.addDays(difference);
                sp.Starts_date__c = sp.Starts_date__c.addDays(difference);
                sp.Status__c = 'Not Started';
                sp.Parent_project__c = newPlan.id;
                sp.Project_del__c = subProsOldNew.get(sp.Project_del__c);
                if(!milestonenp) {
                    sp.ERP__c = null;
                    sp.CRM__c = null;
                    sp.Social_media__c = null;
                }
                sp.oldId__c = sp.tempId__c;
                oldIds.add(sp.tempId__c);
                sp.tempId__c = null;
                
            }
			insert secondLevelSPS;
			sps1 = [SELECT Id, oldId__c FROM Subproject__c where oldId__c IN:oldIds and CreatedDate>=:dt];
            for(Subproject__c sp : sps1) {
                subProsOldNew.put(sp.oldId__c, sp.id);
                subProsNewOld.put(sp.id, sp.oldId__c);
            }            
        }
        
        Map<String,String> masOldNew = new Map<String,String>();
        Map<String,String> masNewOld = new Map<String,String>();
        if(activities) {
            List<Marketing_activity__c> masToUpdateOldId = [SELECT Id, tempId__c FROM Marketing_activity__c where Project__c IN:subProsOldNew.keySet()];
            for(Marketing_activity__c ma : masToUpdateOldId) {
                ma.tempId__c = ma.Id;
            }
            update masToUpdateOldId;
            
            List<Marketing_activity__c> activitiesList = [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, 
                                                          LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate,
                                                          Activitytype__c, Description__c, Status__c, Status_Image_Id__c, 
                                                          Priority_level__c, Project__c, Plan__c, Ends_date__c, Starts_date__c,
                                                          StatusImage__c, ERP__c, CRM__c, Social_media__c, Activity_Class__c, 
                                                          oldId__c,tempId__c, multi_pubication__c 
                                                          FROM Marketing_activity__c where Project__c IN:subProsOldNew.keySet()];
            List<String> oldIds = new List<String>();
            for(Marketing_activity__c ma : activitiesList) {
                ma.id = null;
                ma.Ends_date__c = ma.Ends_date__c.addDays(difference);
                ma.Starts_date__c = ma.Starts_date__c.addDays(difference);
                ma.Status__c = 'Not Started';
                ma.Plan__c = newPlan.id;
                ma.Project__c = subProsOldNew.get(ma.Project__c);
                if(!milestonenp) {
                    ma.ERP__c = null;
                    ma.CRM__c = null;
                    ma.Social_media__c = null;
                }
                ma.oldId__c = ma.tempId__c;
                oldIds.add(ma.tempId__c);
                ma.tempId__c = null;
            }
            insert activitiesList;
            
            List<Marketing_activity__c> mas1 = [SELECT Id, oldId__c FROM Marketing_activity__c where oldId__c IN:oldIds and CreatedDate>=:dt];
            for(Marketing_activity__c ma : mas1) {
                masOldNew.put(ma.oldId__c, ma.id);
                masNewOld.put(ma.id, ma.oldId__c);
            }
            
            List<Marketing_activity_dates__c> subMAs = [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, 
                                                        LastModifiedDate, LastModifiedById, SystemModstamp, Start_date__c, 
                                                        End_date__c, Marketing_activity__c FROM Marketing_activity_dates__c
                                                       where Marketing_activity__c IN:masOldNew.keySet()];
            for(Marketing_activity_dates__c subMA : subMAs) {
                subMA.Id = null;
                subMA.Start_date__c = subMA.Start_date__c.addDays(difference);
                subMA.End_date__c = subMA.End_date__c.addDays(difference);
                subMA.Marketing_activity__c = masOldNew.get(subMA.Marketing_activity__c);
            }
            insert subMAs;
        }
        
        if(ownernmember){
            List<Members__c> members = [SELECT Id, OwnerId, IsDeleted, Name, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate,
                                    LastModifiedById, SystemModstamp, ProjMembers__c, ProjUsers__c, SubProjMembers__c, 
                                    Role__c, Type__c, User_Email__c, Email_del__c, Marketingmebers__c, Cost_center__c 
                                    FROM Members__c where (ProjMembers__c=:id or SubProjMembers__c IN:subProsOldNew.keySet() or Marketingmebers__c IN:masOldNew.keySet()) and Role__c!='Owner'];
            for(Members__c member : members) {
                member.id = null;
                if(member.ProjMembers__c != null)
                	member.ProjMembers__c = newPlan.id;
                if(member.SubProjMembers__c != null)
                	member.SubProjMembers__c = subProsOldNew.get(member.SubProjMembers__c);
                if(member.Marketingmebers__c != null)
                	member.Marketingmebers__c = masOldNew.get(member.Marketingmebers__c);
            }
            insert members;
            
            Activity__c musAct2 = [SELECT Id, Name, Plan_access_controll__c FROM Activity__c limit 1];
            if(musAct2.Plan_access_controll__c) {
                List<Musqot_member__c> musqotPlanMembers = [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, 
                                                            LastModifiedDate, LastModifiedById, SystemModstamp, userid__c, 
                                                            Role__c, Plan__c, project__c, Marketing_activity__c, User_type__c 
                                                            FROM Musqot_member__c where Plan__c=:id and Role__c!=null and Role__c!='Owner'];
                for(Musqot_member__c mpm : musqotPlanMembers) {
                    mpm.id = null;
                    mpm.Plan__c = newPlan.id;
                }
                insert musqotPlanMembers;
            }
        } else {
            List<Members__c> members = [SELECT Id, OwnerId, IsDeleted, Name, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate,
                                    LastModifiedById, SystemModstamp, ProjMembers__c, ProjUsers__c, SubProjMembers__c, 
                                    Role__c, Type__c, User_Email__c, Email_del__c, Marketingmebers__c, Cost_center__c 
                                    FROM Members__c where (ProjMembers__c=:newPlan.id or SubProjMembers__c IN:subProsOldNew.values() or Marketingmebers__c IN:masOldNew.values()) and Role__c='Owner'];
            for(Members__c member : members) {
                member.OwnerId = UserInfo.getUserId();
                member.ProjUsers__c = UserInfo.getUserId();
                member.User_Email__c = UserInfo.getUserEmail();
            }
            update members;
        }
                                               
        if(budget) { 
            List<Budget__c> tbd = [SELECT Id FROM Budget__c WHERE Project__c=:newPlan.id];
            delete tbd; 
            List<Budget__c> budgetObjList = [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, 
                                LastModifiedById, SystemModstamp, Description__c, Project__c, Budget__c, user__c,subproject__c,
                                Approved__c, Approved_date__c, Budget_h__c, FiscalYear__c 
                                FROM Budget__c
                         		WHERE Project__c= :id order by CreatedDate limit 1];
            if(budgetObjList!=null) {
                if(budgetObjList.size()>0) {
                    Budget__c budgetObj = budgetObjList.get(0);
                    budgetObj.id = null;
                    budgetObj.Project__c = newPlan.id;
                    budgetObj.Approved__c = false;
                    budgetObj.Approved_date__c = null;
                    budgetObj.FiscalYear__c = fydd;
                    insert budgetObj;
                }
            }
            
            budgetObjList = [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, 
                             LastModifiedById, SystemModstamp, Description__c, Project__c, Budget__c, user__c,subproject__c,
                             Approved__c, Approved_date__c, Budget_h__c, FiscalYear__c 
                             FROM Budget__c
                             WHERE subproject__c IN:subProsOldNew.keySet()];
            for(Budget__c budgetObj : budgetObjList) {
                budgetObj.id = null;
                if(budgetObj.Project__c!=null)
                    budgetObj.Project__c = newPlan.id;
                budgetObj.subproject__c = subProsOldNew.get(budgetObj.subproject__c);
                budgetObj.Approved__c = false;
                budgetObj.Approved_date__c = null;
                budgetObj.FiscalYear__c = fydd;
            }
            insert budgetObjList;
        }
                                               
        if(overnattach) {
            String htmlDescription = '';
            
            List<Workspace__c> wssToUpdateOldId = [SELECT Id, tempId__c FROM Workspace__c where ProjectName__c=:newPlan.id or subproject__c IN:subProsNewOld.keySet() or Marketing_activity__c IN:masNewOld.keySet()];
            for(Workspace__c ws : wssToUpdateOldId) {
                ws.tempId__c = ws.Id;
            }
            update wssToUpdateOldId;
            
            List<Workspace__c> wss = [SELECT Id, oldId__c,tempId__c, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, 
                               LastModifiedById, SystemModstamp, Description__c, html_description__c, ProjectName__c, 
                               subproject__c, Marketing_activity__c FROM Workspace__c
                              where ProjectName__c=:newPlan.id or subproject__c IN:subProsNewOld.keySet() or Marketing_activity__c IN:masNewOld.keySet()];
            
            
            List<Workspace__c> oldWSs = [SELECT Id, ProjectName__c, subproject__c, Marketing_activity__c, html_description__c from Workspace__c where 
                                         ProjectName__c=:id or subproject__c IN:subProsNewOld.values() or 
                                         Marketing_activity__c IN:masNewOld.values()];
            
            Map<String,String> WShtmls = new Map<String,String>();
            Map<String,String> oldWSIds = new Map<String,String>();
            for(Workspace__c ws : oldWSs) {
                String mapperId = '';
                if(ws.ProjectName__c != null)
                    mapperId = id;
                else if(ws.subproject__c != null)
                    mapperId = ws.subproject__c;
                else if(ws.Marketing_activity__c != null)
                    mapperId = ws.Marketing_activity__c;
                WShtmls.put(mapperId, ws.html_description__c);
                oldWSIds.put(mapperId, ws.Id);
            }
            
            Map<String,String> newWSIds = new Map<String,String>();
            List<String> oldIds = new List<String>();
            for(Workspace__c ws : wss){
                String mapperId = '';
                if(ws.ProjectName__c != null)
                    mapperId = id;
				else if(ws.subproject__c != null)
                	mapperId = subProsNewOld.get(ws.subproject__c);
                else if(ws.Marketing_activity__c != null)
                    mapperId = masNewOld.get(ws.Marketing_activity__c);
                ws.html_description__c = WShtmls.get(mapperId);
                ws.oldId__c = ws.tempId__c;
                oldIds.add(ws.tempId__c);
                ws.tempId__c = null;
                //newWSIds.put(mapperId, ws.Id);
            }
            update wss;
            List<Workspace__c> wss1 = [SELECT Id, oldId__c,ProjectName__c, subproject__c, Marketing_activity__c FROM Workspace__c where oldId__c IN:oldIds and CreatedDate>=:dt];
            for(Workspace__c ws : wss1) {
                String mapperId = '';
                if(ws.ProjectName__c != null)
                    mapperId = id;
				else if(ws.subproject__c != null)
                	mapperId = subProsNewOld.get(ws.subproject__c);
                else if(ws.Marketing_activity__c != null)
                    mapperId = masNewOld.get(ws.Marketing_activity__c);
                newWSIds.put(mapperId, ws.Id);
            }
            
            Map<String,String> oldNewWSIds = new Map<String,String>();
            for(String m : oldWSIds.keySet()) {
                oldNewWSIds.put(oldWSIds.get(m), newWSIds.get(m));
            }
            List<Attachment> attachs = [SELECT Id, IsDeleted, ParentId, Name, IsPrivate, ContentType, BodyLength, Body,
                                            OwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, 
                                            SystemModstamp, Description FROM Attachment where ParentId IN:oldWSIds.values()];
            
            List<Attachment> attachs2 = new List<Attachment>();
            for(Attachment attach : attachs) {
                attach.id = null;
                attach.ParentId = oldNewWSIds.get(attach.ParentId);
                if(attach.ParentId!=null)
                	attachs2.add(attach);
            }
            insert attachs2;
        }
                                               
        if(milestonenp) {
            List<Milestone__c> mileStons = [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, 
                                            LastModifiedById, SystemModstamp, Plan__c, Project__c, Description__c, 
                                            Target_Marketing_activity__c, Targetdate__c, Status__c, Target_Project__c, 
                                            Milestone_type__c, Target_Socialmedia__c, Marketing_activity__c, Target_number__c, 
                                            Target_ERP_Sales__c, Target_CRM_settings__c, Target_number_outcome__c, 
                                            Target_Achieved__c FROM Milestone__c WHERE Plan__c=:id];
            
            boolean shouldInsert = true;
            List<Milestone__c> mileStons2 = new List<Milestone__c>();
            for(Milestone__c m : mileStons) {
                m.id = null;
                m.Plan__c = newPlan.id;
                shouldInsert = true;
                if(m.Project__c != null) {
                    m.Project__c = subProsOldNew.get(m.Project__c);
                    if(m.Project__c == null)
                        shouldInsert = false;
                }  
                if(shouldInsert)
                	mileStons2.add(m);
            }
            insert mileStons2;
        }
        return newPlan.id;
    }
    
    /****** Method to create project copy. *****/
    webService static String createProjectCopy(String id, String targetId, String targetType, String targetPlanId, String name,
                                               Date sd, List<String> subProIds, boolean activities, boolean tasks, 
                                               boolean ownernmember, boolean budget, boolean overnattach, boolean milestonenp, 
                                               String fydd) {

        Datetime dt = System.now();                                           
        boolean isTargetProject = targetType=='subproject'?true:false;
        Map<String,String> subProsOldNew = new Map<String,String>();
        Map<String,String> subProsNewOld = new Map<String,String>();
                                                   
        Subproject__c mainSP = [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, 
                                   LastModifiedById, SystemModstamp, LastActivityDate, Parent_project__c, Ends_date__c, 
                                   Starts_date__c, Description__c, Project_type__c, planid__c, Project_del__c, Status__c, 
                                   Status_Image_Id__c, StatusImage__c, Priority_level__c, CRM__c, ERP__c, Social_media__c 
                                   FROM Subproject__c where Id=:id];
                                                   
        Integer difference = mainSP.Starts_date__c.daysBetween(sd);
        mainSP.id = null;
        mainSP.Name = name;
        mainSP.Ends_date__c = mainSP.Ends_date__c.addDays(difference);
        mainSP.Starts_date__c = mainSP.Starts_date__c.addDays(difference);
        mainSP.Status__c = 'Not Started';
        mainSP.Parent_project__c = targetPlanId;
        if(isTargetProject)
            mainSP.Project_del__c = targetId;
        if(!milestonenp) {
            mainSP.ERP__c = null;
            mainSP.CRM__c = null;
            mainSP.Social_media__c = null;
        }
        insert mainSP;
        subProsOldNew.put(id, mainSP.id);
        subProsNewOld.put(mainSP.id, id);              
        
       // if(subProIds.size()>1) {
            List<Subproject__c> spsToUpdateOldId = [SELECT Id, tempId__c FROM Subproject__c where Id IN:subProIds];
            for(Subproject__c sp : spsToUpdateOldId) {
                sp.tempId__c = sp.Id;
            }
            update spsToUpdateOldId;
            List<Subproject__c> sps = [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, 
                                       LastModifiedById, SystemModstamp, LastActivityDate, Parent_project__c, Ends_date__c, 
                                       Starts_date__c, Description__c, Project_type__c, planid__c, Project_del__c, Status__c, 
                                       Status_Image_Id__c, StatusImage__c, Priority_level__c, CRM__c, ERP__c, Social_media__c, 
                                       oldId__c,tempId__c FROM Subproject__c where Id IN:subProIds];
            
            List<String> oldIds = new List<String>();
            for(Subproject__c sp : sps) {
                sp.id = null;
                sp.Ends_date__c = sp.Ends_date__c.addDays(difference);
                sp.Starts_date__c = sp.Starts_date__c.addDays(difference);
                sp.Status__c = 'Not Started';
                sp.Parent_project__c = targetPlanId;
                if(!milestonenp) {
                    sp.ERP__c = null;
                    sp.CRM__c = null;
                    sp.Social_media__c = null;
                }
                sp.oldId__c = sp.tempId__c;
                oldIds.add(sp.tempId__c);
                sp.tempId__c = null;
            }
            insert sps; 
            List<Subproject__c> sps1 = [SELECT Id, oldId__c,Project_del__c FROM Subproject__c where oldId__c IN:oldIds and CreatedDate>=:dt];
            for(Subproject__c sp : sps1) {
                subProsOldNew.put(sp.oldId__c, sp.id);
                subProsNewOld.put(sp.id, sp.oldId__c);
            }
            
            for(Subproject__c sp : sps1) {
                if(sp.Project_del__c != null)
                    sp.Project_del__c = subProsOldNew.get(sp.Project_del__c);
            }
            update sps1;
        //}
        
        Map<String,String> masOldNew = new Map<String,String>();
        Map<String,String> masNewOld = new Map<String,String>();
        if(activities) {
            List<Marketing_activity__c> masToUpdateOldId = [SELECT Id, tempId__c FROM Marketing_activity__c where Project__c IN:subProsOldNew.keySet()];
            for(Marketing_activity__c ma : masToUpdateOldId) {
                ma.tempId__c = ma.Id;
            }
            update masToUpdateOldId;
            List<Marketing_activity__c> activitiesList = [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, 
                                                          LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate,
                                                          Activitytype__c, Description__c, Status__c, Status_Image_Id__c, 
                                                          Priority_level__c, Project__c, Plan__c, Ends_date__c, Starts_date__c,
                                                          StatusImage__c, ERP__c, CRM__c, Social_media__c, Activity_Class__c, 
                                                          oldId__c,tempId__c, multi_pubication__c 
                                                          FROM Marketing_activity__c where Project__c IN:subProsOldNew.keySet()];

            List<String> oldIds1 = new List<String>();
            for(Marketing_activity__c ma : activitiesList) {
                ma.id = null;
                ma.Ends_date__c = ma.Ends_date__c.addDays(difference);
                ma.Starts_date__c = ma.Starts_date__c.addDays(difference);
                ma.Status__c = 'Not Started';
                ma.Plan__c = targetPlanId;
                ma.Project__c = subProsOldNew.get(ma.Project__c);
                if(!milestonenp) {
                    ma.ERP__c = null;
                    ma.CRM__c = null;
                    ma.Social_media__c = null;
                }
                ma.oldId__c = ma.tempId__c;
                oldIds1.add(ma.tempId__c);
                ma.tempId__c = null;
            }
            insert activitiesList;
            
            List<Marketing_activity__c> mas1 = [SELECT Id, oldId__c FROM Marketing_activity__c where oldId__c IN:oldIds1 and CreatedDate>=:dt];
            for(Marketing_activity__c ma : mas1) {
                masOldNew.put(ma.oldId__c, ma.id);
                masNewOld.put(ma.id, ma.oldId__c);
            }
            
            List<Marketing_activity_dates__c> subMAs = [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, 
                                                        LastModifiedDate, LastModifiedById, SystemModstamp, Start_date__c, 
                                                        End_date__c, Marketing_activity__c FROM Marketing_activity_dates__c
                                                       where Marketing_activity__c IN:masOldNew.keySet()];
            for(Marketing_activity_dates__c subMA : subMAs) {
                subMA.Id = null;
                subMA.Start_date__c = subMA.Start_date__c.addDays(difference);
                subMA.End_date__c = subMA.End_date__c.addDays(difference);
                subMA.Marketing_activity__c = masOldNew.get(subMA.Marketing_activity__c);
            }
            insert subMAs;
        }
        
        Map<String,String> tasksOldNew = new Map<String,String>();
        if(tasks) {
            // tasks under projects
            List<Task> tasksToUpdateOldId = [SELECT Id, tempId__c FROM Task where WhatId IN:subProsOldNew.keySet()];
            for(Task t : tasksToUpdateOldId) {
                t.tempId__c = t.Id;
            }
            update tasksToUpdateOldId;
            
            List<Task> taskObjs = [SELECT Id, WhoId, WhatId, Subject, ActivityDate, Status, Priority, IsHighPriority, OwnerId, 
                                 Description, IsDeleted, AccountId, IsClosed, CreatedDate, CreatedById, LastModifiedDate, 
                                 LastModifiedById, SystemModstamp, IsArchived, CallDurationInSeconds, CallType, 
                                 CallDisposition, CallObject, ReminderDateTime, IsReminderSet, RecurrenceActivityId, 
                                 IsRecurrence, RecurrenceStartDateOnly, RecurrenceEndDateOnly, RecurrenceTimeZoneSidKey, 
                                 RecurrenceType, RecurrenceInterval, RecurrenceDayOfWeekMask, RecurrenceDayOfMonth, 
                                 RecurrenceInstance, RecurrenceMonthOfYear, RecurrenceRegeneratedType,
                                 Allocated_h__c, Outcome_h__c, Task_description__c, Task_name__c, sendEmail__c, StatusImage__c,
                                 Status_image_id__c, Remaining__c, oldId__c,tempId__c
                                 FROM Task where WhatId IN:subProsOldNew.keySet()];
        	
            List<String> oldIds1 = new List<String>();
            for(Task task : taskObjs) {
                task.id = null;
                task.ActivityDate = task.ActivityDate.addDays(difference);
                task.WhatId = subProsOldNew.get(task.WhatId);
                task.Status = 'Not Started';
                task.Outcome_h__c = 0;
                if(!ownernmember){
                	task.OwnerId = UserInfo.getUserId();
                }
                task.oldId__c = task.tempId__c;
                oldIds1.add(task.tempId__c);
                task.tempId__c = null;
            }
            insert taskObjs;
            
            List<Task> tasks1 = [SELECT Id, oldId__c FROM Task where oldId__c IN:oldIds1 and CreatedDate>=:dt];
            for(Task t : tasks1) {
                tasksOldNew.put(t.oldId__c, t.id);
            }
            
            // tasks under MAs
            tasksToUpdateOldId = [SELECT Id, tempId__c FROM Task where WhatId IN:masOldNew.keySet()];
            for(Task t : tasksToUpdateOldId) {
                t.tempId__c = t.Id;
            }
            update tasksToUpdateOldId;
            taskObjs = [SELECT Id, WhoId, WhatId, Subject, ActivityDate, Status, Priority, IsHighPriority, OwnerId, 
                                 Description, IsDeleted, AccountId, IsClosed, CreatedDate, CreatedById, LastModifiedDate, 
                                 LastModifiedById, SystemModstamp, IsArchived, CallDurationInSeconds, CallType, 
                                 CallDisposition, CallObject, ReminderDateTime, IsReminderSet, RecurrenceActivityId, 
                                 IsRecurrence, RecurrenceStartDateOnly, RecurrenceEndDateOnly, RecurrenceTimeZoneSidKey, 
                                 RecurrenceType, RecurrenceInterval, RecurrenceDayOfWeekMask, RecurrenceDayOfMonth, 
                                 RecurrenceInstance, RecurrenceMonthOfYear, RecurrenceRegeneratedType,
                                 Allocated_h__c, Outcome_h__c, Task_description__c, Task_name__c, sendEmail__c, StatusImage__c,
                                 Status_image_id__c, Remaining__c, oldId__c,tempId__c
                        FROM Task where WhatId IN:masOldNew.keySet()];

            oldIds1 = new List<String>();
            for(Task task : taskObjs) {
                task.id = null;
                task.ActivityDate = task.ActivityDate.addDays(difference);
                task.WhatId = masOldNew.get(task.WhatId);
                task.Status = 'Not Started';
                task.Outcome_h__c = 0;
                if(!ownernmember){
                	task.OwnerId = UserInfo.getUserId();
                }
                task.oldId__c = task.tempId__c;
                oldIds1.add(task.tempId__c);
                task.tempId__c = null;
            }
            insert taskObjs;
            
            tasks1 = [SELECT Id, oldId__c FROM Task where oldId__c IN:oldIds1 and CreatedDate>=:dt];
            for(Task t : tasks1) {
                tasksOldNew.put(t.oldId__c, t.id);
            }
        }
        
        if(ownernmember){
            List<Members__c> members = [SELECT Id, OwnerId, IsDeleted, Name, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate,
                                    LastModifiedById, SystemModstamp, ProjMembers__c, ProjUsers__c, SubProjMembers__c, 
                                    Role__c, Type__c, User_Email__c, Email_del__c, Marketingmebers__c, Cost_center__c 
                                    FROM Members__c where (SubProjMembers__c IN:subProsOldNew.keySet() or Marketingmebers__c IN:masOldNew.keySet()) and Role__c!='Owner'];
            for(Members__c member : members) {
                member.id = null;
                if(member.SubProjMembers__c != null)
                	member.SubProjMembers__c = subProsOldNew.get(member.SubProjMembers__c);
                if(member.Marketingmebers__c != null)
                	member.Marketingmebers__c = masOldNew.get(member.Marketingmebers__c);
            }
            insert members;
        } else {
            List<Members__c> members = [SELECT Id, OwnerId, IsDeleted, Name, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate,
                                    LastModifiedById, SystemModstamp, ProjMembers__c, ProjUsers__c, SubProjMembers__c, 
                                    Role__c, Type__c, User_Email__c, Email_del__c, Marketingmebers__c, Cost_center__c 
                                    FROM Members__c where (SubProjMembers__c IN:subProsOldNew.values() or Marketingmebers__c IN:masOldNew.values()) and Role__c='Owner'];
            for(Members__c member : members) {
                member.OwnerId = UserInfo.getUserId();
                member.ProjUsers__c = UserInfo.getUserId();
                member.User_Email__c = UserInfo.getUserEmail();
            }
            update members;
        }
                                                   
        if(budget) {
            List<Budget__c> tbd = [SELECT Id FROM Budget__c WHERE subproject__c=:subProsOldNew.values()];
            delete tbd;
            	
            List<Budget__c> budgetObjList = [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, 
                             LastModifiedById, SystemModstamp, Description__c, Project__c, Budget__c, user__c,subproject__c,
                             Approved__c, Approved_date__c, Budget_h__c, FiscalYear__c 
                             FROM Budget__c WHERE subproject__c IN:subProsOldNew.keySet()];
            for(Budget__c budgetObj : budgetObjList) {
                budgetObj.id = null;
                if(budgetObj.Project__c!=null)
                    budgetObj.Project__c = targetPlanId;
                budgetObj.subproject__c = subProsOldNew.get(budgetObj.subproject__c);
                budgetObj.Approved__c = false;
                budgetObj.Approved_date__c = null;
                budgetObj.FiscalYear__c = fydd;
            }
            insert budgetObjList;
        }
                                                   
        if(overnattach) {
            String htmlDescription = '';
            
            List<Workspace__c> wssToUpdateOldId = [SELECT Id, tempId__c FROM Workspace__c where subproject__c IN:subProsNewOld.keySet() or Marketing_activity__c IN:masNewOld.keySet()];
            for(Workspace__c ws : wssToUpdateOldId) {
                ws.tempId__c = ws.Id;
            }
            update wssToUpdateOldId;
            List<Workspace__c> wss = [SELECT Id, oldId__c,tempId__c, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, 
                               LastModifiedById, SystemModstamp, Description__c, html_description__c, ProjectName__c, 
                               subproject__c, Marketing_activity__c FROM Workspace__c
                              where subproject__c IN:subProsNewOld.keySet() or Marketing_activity__c IN:masNewOld.keySet()];
            
            List<Workspace__c> oldWSs = [SELECT Id, subproject__c, Marketing_activity__c, html_description__c
                                         from Workspace__c where subproject__c IN:subProsNewOld.values() or 
                                         Marketing_activity__c IN:masNewOld.values()];
            Map<String,String> WShtmls = new Map<String,String>();
            Map<String,String> oldWSIds = new Map<String,String>();
            for(Workspace__c ws : oldWSs) {
                String mapperId = '';
                if(ws.subproject__c != null)
                    mapperId = ws.subproject__c;
                else if(ws.Marketing_activity__c != null)
                    mapperId = ws.Marketing_activity__c;
                WShtmls.put(mapperId, ws.html_description__c);
                oldWSIds.put(mapperId, ws.Id);
            }
            
            Map<String,String> newWSIds = new Map<String,String>();
            List<String> oldIds1 = new List<String>();
            for(Workspace__c ws : wss){
                String mapperId = '';
				if(ws.subproject__c != null)
                	mapperId = subProsNewOld.get(ws.subproject__c);
                else if(ws.Marketing_activity__c != null)
                    mapperId = masNewOld.get(ws.Marketing_activity__c);
                ws.html_description__c = WShtmls.get(mapperId);
                ws.oldId__c = ws.tempId__c;
                oldIds1.add(ws.tempId__c);
                ws.tempId__c = null;
            }
            update wss;
            List<Workspace__c> wss1 = [SELECT Id, oldId__c,ProjectName__c, subproject__c, Marketing_activity__c FROM Workspace__c where oldId__c IN:oldIds1 and CreatedDate>=:dt];
            for(Workspace__c ws : wss1) {
                String mapperId = '';
                if(ws.subproject__c != null)
                	mapperId = subProsNewOld.get(ws.subproject__c);
                else if(ws.Marketing_activity__c != null)
                    mapperId = masNewOld.get(ws.Marketing_activity__c);
                newWSIds.put(mapperId, ws.Id);
            }
            
            Map<String,String> oldNewWSIds = new Map<String,String>();
            for(String m : oldWSIds.keySet()) {
                oldNewWSIds.put(oldWSIds.get(m), newWSIds.get(m));
            }
            List<Attachment> attachs = [SELECT Id, IsDeleted, ParentId, Name, IsPrivate, ContentType, BodyLength, Body,
                                            OwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, 
                                            SystemModstamp, Description FROM Attachment where ParentId IN:oldWSIds.values()];
            List<Attachment> attachs2 = new List<Attachment>();
            for(Attachment attach : attachs) {
                attach.id = null;
                attach.ParentId = oldNewWSIds.get(attach.ParentId);
                if(attach.ParentId!=null)
                	attachs2.add(attach);
            }
            insert attachs2;
            
            attachs2 = new List<Attachment>();
            // attachments for tasks
            attachs = [SELECT Id, IsDeleted, ParentId, Name, IsPrivate, ContentType, BodyLength, Body,
                                            OwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, 
                                            SystemModstamp, Description FROM Attachment where ParentId IN:tasksOldNew.keySet()];
            for(Attachment attach : attachs) {
                attach.id = null;
                attach.ParentId = tasksOldNew.get(attach.ParentId);
                if(attach.ParentId!=null)
                	attachs2.add(attach);
            }
            insert attachs2;
        }
                                                   
        if(milestonenp) {
            List<Milestone__c> mileStons = [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, 
                                            LastModifiedById, SystemModstamp, Plan__c, Project__c, Description__c, 
                                            Target_Marketing_activity__c, Targetdate__c, Status__c, Target_Project__c, 
                                            Milestone_type__c, Target_Socialmedia__c, Marketing_activity__c, Target_number__c, 
                                            Target_ERP_Sales__c, Target_CRM_settings__c, Target_number_outcome__c, 
                                            Target_Achieved__c FROM Milestone__c WHERE Project__c IN:subProsOldNew.keySet()];
            for(Milestone__c m : mileStons) {
                m.id = null;
                m.Plan__c = targetPlanId;
                m.Project__c = subProsOldNew.get(m.Project__c);
            }
            insert mileStons;
        }
    	return mainSP.id;
    }
    
    /****** Method to create activity copy. *****/
    webService static String createActivityCopy(String id, String targetSubProId, String targetPlanId, String name, Date sd, boolean tasks, 
                                                boolean ownernmember, boolean overnattach, boolean performance) {
                                                    
        Datetime dt = System.now(); 
    	Marketing_activity__c ma = [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, multi_pubication__c, 
                                                          LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate,
                                                          Activitytype__c, Description__c, Status__c, Status_Image_Id__c, 
                                                          Priority_level__c, Project__c, Plan__c, Ends_date__c, Starts_date__c,
                                                          StatusImage__c, ERP__c, CRM__c, Social_media__c, Activity_Class__c
                                                          FROM Marketing_activity__c where Id =:id];
        ma.id = null;
        Integer difference = Date.valueOf(ma.Starts_date__c).daysBetween(sd);
        ma.Name = name;
        ma.Ends_date__c = ma.Ends_date__c.addDays(difference);
        ma.Starts_date__c = ma.Starts_date__c.addDays(difference);
        ma.Status__c = 'Not Started';
        ma.Plan__c = targetPlanId;
        ma.Project__c = targetSubProId;
        if(!performance) {
            ma.ERP__c = null;
            ma.CRM__c = null;
            ma.Social_media__c = null;
        }
        insert ma;
        
        List<Marketing_activity_dates__c> subMAs = [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, 
                                                    LastModifiedDate, LastModifiedById, SystemModstamp, Start_date__c, 
                                                    End_date__c, Marketing_activity__c FROM Marketing_activity_dates__c
                                                   where Marketing_activity__c=:id];
        for(Marketing_activity_dates__c subMA : subMAs) {
            subMA.Id = null;
            subMA.Start_date__c = subMA.Start_date__c.addDays(difference);
            subMA.End_date__c = subMA.End_date__c.addDays(difference);
            subMA.Marketing_activity__c = ma.Id;
        }
        insert subMAs;
        
        Map<String,String> tasksOldNew = new Map<String,String>();
        if(tasks) {
            List<Task> tasksToUpdateOldId = [SELECT Id, tempId__c FROM Task where WhatId =:id];
            for(Task t : tasksToUpdateOldId) {
                t.tempId__c = t.Id;
            }
            update tasksToUpdateOldId;
            
            List<Task> taskObjs = [SELECT Id, WhoId, WhatId, Subject, ActivityDate, Status, Priority, IsHighPriority, OwnerId, 
                                 Description, IsDeleted, AccountId, IsClosed, CreatedDate, CreatedById, LastModifiedDate, 
                                 LastModifiedById, SystemModstamp, IsArchived, CallDurationInSeconds, CallType, 
                                 CallDisposition, CallObject, ReminderDateTime, IsReminderSet, RecurrenceActivityId, 
                                 IsRecurrence, RecurrenceStartDateOnly, RecurrenceEndDateOnly, RecurrenceTimeZoneSidKey, 
                                 RecurrenceType, RecurrenceInterval, RecurrenceDayOfWeekMask, RecurrenceDayOfMonth, 
                                 RecurrenceInstance, RecurrenceMonthOfYear, RecurrenceRegeneratedType,
                                 Allocated_h__c, Outcome_h__c, Task_description__c, Task_name__c, sendEmail__c, StatusImage__c,
                                 Status_image_id__c, Remaining__c, oldId__c,tempId__c 
                                 FROM Task where WhatId =:id];

            List<String> oldIds1 = new List<String>();
            for(Task task : taskObjs) {
                task.id = null;
                task.ActivityDate = task.ActivityDate.addDays(difference);
                task.WhatId = ma.Id;
                task.Status = 'Not Started';
                task.Outcome_h__c = 0;
                if(!ownernmember){
                	task.OwnerId = UserInfo.getUserId();
                }
                task.oldId__c = task.tempId__c;
                oldIds1.add(task.tempId__c);
                task.tempId__c = null;
            }
            insert taskObjs;
            
            List<Task> tasks1 = [SELECT Id, oldId__c FROM Task where oldId__c IN:oldIds1 and CreatedDate>=:dt];
            for(Task t : tasks1) {
                tasksOldNew.put(t.oldId__c, t.id);
            }
        }
        
        if(ownernmember){
            List<Members__c> members = [SELECT Id, OwnerId, IsDeleted, Name, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate,
                                    LastModifiedById, SystemModstamp, ProjMembers__c, ProjUsers__c, SubProjMembers__c, 
                                    Role__c, Type__c, User_Email__c, Email_del__c, Marketingmebers__c, Cost_center__c 
                                    FROM Members__c where Marketingmebers__c=:id and Role__c!='Owner'];
            for(Members__c member : members) {
                member.id = null;
                if(member.Marketingmebers__c != null)
                	member.Marketingmebers__c = ma.Id;
            }
            insert members;
        } else {
            List<Members__c> members = [SELECT Id, OwnerId, IsDeleted, Name, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate,
                                    LastModifiedById, SystemModstamp, ProjMembers__c, ProjUsers__c, SubProjMembers__c, 
                                    Role__c, Type__c, User_Email__c, Email_del__c, Marketingmebers__c, Cost_center__c 
                                    FROM Members__c where Marketingmebers__c=:ma.Id and Role__c='Owner'];
            for(Members__c member : members) {
                member.OwnerId = UserInfo.getUserId();
                member.ProjUsers__c = UserInfo.getUserId();
                member.User_Email__c = UserInfo.getUserEmail();
            }
            update members;
        }
                                                    
        if(overnattach) {
            String htmlDescription = '';
            
            List<Workspace__c> wssToUpdateOldId = [SELECT Id, tempId__c FROM Workspace__c where Marketing_activity__c =:ma.Id];
            for(Workspace__c ws : wssToUpdateOldId) {
                ws.tempId__c = ws.Id;
            }
            update wssToUpdateOldId;
            
            List<Workspace__c> wss = [SELECT Id, oldId__c,tempId__c, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, 
                               LastModifiedById, SystemModstamp, Description__c, html_description__c, ProjectName__c, 
                               subproject__c, Marketing_activity__c FROM Workspace__c
                              where Marketing_activity__c =:ma.Id];
            
            List<Workspace__c> oldWSs = [SELECT Id, Marketing_activity__c, html_description__c
                                         from Workspace__c where Marketing_activity__c=:id];
            Map<String,String> WShtmls = new Map<String,String>();
            Map<String,String> oldWSIds = new Map<String,String>();
            for(Workspace__c ws : oldWSs) {
                String mapperId = '';
                if(ws.Marketing_activity__c != null)
                    mapperId = ws.Marketing_activity__c;
                WShtmls.put(mapperId, ws.html_description__c);
                oldWSIds.put(mapperId, ws.Id);
            }
            Map<String,String> newWSIds = new Map<String,String>();
            List<String> oldIds = new List<String>();
            for(Workspace__c ws : wss){
                String mapperId = '';
                if(ws.Marketing_activity__c != null)
                    mapperId = id;
                ws.html_description__c = WShtmls.get(mapperId);
                ws.oldId__c = ws.tempId__c;
                oldIds.add(ws.tempId__c);
                ws.tempId__c = null;
            }
            update wss;
            List<Workspace__c> wss1 = [SELECT Id, oldId__c,ProjectName__c, subproject__c, Marketing_activity__c FROM Workspace__c where oldId__c IN:oldIds and CreatedDate>=:dt];
            for(Workspace__c ws : wss1) {
                String mapperId = '';
                if(ws.Marketing_activity__c != null)
                    mapperId = id;
                newWSIds.put(mapperId, ws.Id);
            }
            
            Map<String,String> oldNewWSIds = new Map<String,String>();
            for(String m : oldWSIds.keySet()) {
                oldNewWSIds.put(oldWSIds.get(m), newWSIds.get(m));
            }
            List<Attachment> attachs = [SELECT Id, IsDeleted, ParentId, Name, IsPrivate, ContentType, BodyLength, Body,
                                            OwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, 
                                            SystemModstamp, Description FROM Attachment where ParentId IN:oldWSIds.values()];
            List<Attachment> attachs2 = new List<Attachment>();
            for(Attachment attach : attachs) {
                attach.id = null;
                attach.ParentId = oldNewWSIds.get(attach.ParentId);
                if(attach.ParentId!=null)
                	attachs2.add(attach);
            }
            insert attachs2;
            
            // attachments for tasks
            attachs = [SELECT Id, IsDeleted, ParentId, Name, IsPrivate, ContentType, BodyLength, Body,
                                            OwnerId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, 
                                            SystemModstamp, Description FROM Attachment where ParentId IN:tasksOldNew.keySet()];
            
            attachs2 = new List<Attachment>();
            for(Attachment attach : attachs) {
                attach.id = null;
                attach.ParentId = tasksOldNew.get(attach.ParentId);
                if(attach.ParentId!=null)
                	attachs2.add(attach);
            }
            insert attachs2;
        }
        return ma.id;
    }
}