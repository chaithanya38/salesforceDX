/*******************************************************
Class Name: GanttDetailPageController 
Author:Hussain        Last modified by: Narendra
Date:4/7/2014        Date: Nov 24, 2015
********©2013 Musqot marketing technology Pvt ltd *******/

public with sharing class GanttDetailPageController {
    public boolean IsDeleted {get; set;}
    private List<Project_type__c> ptypes;
    private List<plantype__c> plntypes;
    private List<Activitytype__c> actTypes;  
    public Project__c ObjPro{get; set;}
    public List<String> selectedTypes{get;set;}
    public boolean showBtn{get;set;}
    public List<musqot__plantype__c> PLAN_Temp = new List<musqot__plantype__c>();
    public Subproject__c subpro{get;set;}
    /* Filter Start here */
    public string selectedFilter{get;set;}
    public List<User_setting__c> Filter_Temp = new List<User_setting__c>();
    public List<musqot__Project_type__c> PROJECT_Temp = new List<musqot__Project_type__c>(); 
    public string FilterName {get;set;}
    public string FilterZooming {get;set;}
    public date FilterStartDate {get;set;}
    public date FilterEndDate {get;set;}
    public boolean GlobalFilter {get;set;}   
    public boolean mydefaultFilter {get;set;}  
    public List<String> selectedFilterTypes{get;set;}
    public List<String> selectedFilterProjectTypes{get;set;}
    public List<String> selectedFilterProjectTypes1{get;set;}
    public List<String> FilterTypes{get;set;}
    public List<musqot__plantype__c> Filter_PLAN_Temp = new List<musqot__plantype__c>(); 
    public List<musqot__Project_type__c> Filter_PROJECT_Temp = new List<musqot__Project_type__c>(); 
    public string lnkfilterTitle {get;set;}
    public date startDateVal {get;set;}
    public date endDateVal {get;set;}
    public string zoomingVal {get;set;}
    public boolean isGlobaluser {get;set;} 
    public string  MyProflieName{get;set;}
    public boolean Level1{get;set;} 
    public boolean addfiltersetting {get;set;} 
    public List<musqot__Activity__c> musAct {get;set;}
    public string projectName{get;set;}
    public static String prid;
    public String fromProject{get;set;}
    
    /* Filter End here */
    
    /* Gantt Menu start*/
    
    public String subprojectId;
    
    /* Gantt Menu end*/
    
    
    //Constructor
    public GanttDetailPageController(){
        fromProject=ApexPages.currentPage().getParameters().get('proid');
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
       
        selectedTypes = new List<String>();
        PLAN_Temp = [Select u.Name, u.Id From plantype__c u limit 250];   
        for(plantype__c objPLA: PLAN_Temp ){
            selectedTypes.add(objPLA.Id);
        }
        /* Filter Starts here */  
        this.selectedFilterProjectTypes1= new List<String>();
        selectedFilterTypes = new List<String>();
        Filter_PLAN_Temp = [Select u.Name, u.Id From plantype__c u limit 250];   
        for(plantype__c objFilterType: Filter_PLAN_Temp ){
            selectedFilterTypes.add(objFilterType.Id);
        }   
        selectedFilterProjectTypes = new List<String>();
        Filter_PROJECT_Temp = [Select u.Name, u.Id From Project_type__c u limit 250];   
        for(Project_type__c objFilterType: Filter_PROJECT_Temp ){
           selectedFilterProjectTypes.add(objFilterType.Id);
        } 
        musqot__User_setting__c get_musqot_defaultfilter = new musqot__User_setting__c();
        try{
            get_musqot_defaultfilter = [SELECT Id FROM User_setting__c 
                                        WHERE (Userid__c=:UserInfo.getUserId() or Global__c =:true ) and Gantt_type__c=:1 
                                        Order by My_default__c desc limit 1];
            selectedFilter = get_musqot_defaultfilter.Id;            
        }catch (Exception e){
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
        /* Filter End here */
        musAct=[SELECT Id, Name, Incl_Marketing_activity_Detail__c, Plan_access_controll__c,
                Incl_Milestone_Detail__c, Incl_Task_Detail__c,Drag_to_change_date_Detail__c, 
                Use_Finance1__c FROM Activity__c limit 1];
        /* Gantt Menu strart */
        subprojectId = ApexPages.currentPage().getParameters().get('id');
        
        try{
            subpro=[SELECT id,Name,Parent_project__c from Subproject__c where id=:subprojectId];
            projectName=subpro.Name;
        }catch(exception e){} 
        /* Gantt Menu end */
        
    } 
    
    /* Filter Starts here */
    public List<SelectOption> FilterList{
        get
        {
            Filter_Temp = [Select u.Name, u.Id From User_setting__c u 
                           Where (Userid__c = :UserInfo.getUserId() or Global__c = :true) and Gantt_type__c = :1  limit 250];
            FilterList= new List<SelectOption>(); 
            FilterList.add(new SelectOption('0',  label.gnt_New_filter));
            addfiltersetting = true;
            for(User_setting__c objFilterList: Filter_Temp )
            {
                addfiltersetting = false;
                FilterList.add(new SelectOption(objFilterList.Id, objFilterList.Name));
            }            
            return FilterList;
        }
        set;
    }
    public List<SelectOption> PROJECTList
    {
        get
        {
            try{
            project__c plantype3 = [select plantype__r.Name from project__c where Id=:subpro.Parent_project__c];
            PROJECT_Temp = [Select u.Name, u.Id,Plantype__c From Project_type__c u limit 250];
            PROJECTList= new List<SelectOption>(); 
            for(Project_type__c objPLA: PROJECT_Temp )
            {
                String pt = objPLA.Plantype__c;
                if(musAct[0].Plan_access_controll__c==true) {
                    if(pt != null) {
                        if(pt.length()==0)
                            PROJECTList.add(new SelectOption(objPLA.Id, objPLA.Name));
                        else {
                            List<String> pts = pt.split(';');
                            for(String pt1 : pts) {
                                if(pt1==plantype3.plantype__r.Name)
                                    PROJECTList.add(new SelectOption(objPLA.Id, objPLA.Name));
                            }
                        }
                    } else{
                        PROJECTList.add(new SelectOption(objPLA.Id, objPLA.Name));
                    }
                } else{
                    PROJECTList.add(new SelectOption(objPLA.Id, objPLA.Name));
                }
            }
            }catch(exception e){}
            return PROJECTList;        	
        }
        set;
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
        for(String a:selectedFilterProjectTypes) {
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
            for (User_setting__c a : [SELECT Id, My_default__c FROM User_setting__c 
                                      WHERE Userid__c = :UserInfo.getUserId() and Gantt_type__c = :1 limit 250]){
                                          a.My_default__c = false;
                                          update a;
                                      }
            
        }
        if(selectedFilter == '0'){
            Ganttviewsetting = new User_setting__c(); 
            Ganttviewsetting.Name = FilterName;
            Ganttviewsetting.Userid__c = UserInfo.getUserId();
            Ganttviewsetting.Gantt_type__c = 1;
            Ganttviewsetting.Ganttview__c = xml;
            Ganttviewsetting.Global__c = GlobalFilter;
            Ganttviewsetting.My_default__c = mydefaultFilter;
            insert Ganttviewsetting;
        }else {
            Ganttviewsetting.Id = selectedFilter;
            Ganttviewsetting.Name = FilterName;
            Ganttviewsetting.Userid__c = UserInfo.getUserId();
            Ganttviewsetting.Gantt_type__c = 1;
            Ganttviewsetting.Ganttview__c = xml;
            Ganttviewsetting.Global__c = GlobalFilter;
            Ganttviewsetting.My_default__c = mydefaultFilter;
            update Ganttviewsetting;
        }
        selectedFilter = Ganttviewsetting.Id;
        startDateVal = FilterStartDate;
        endDateVal = FilterEndDate;
        zoomingVal = FilterZooming;
        displayPopup = false;
        loadganttviewbyFilter();              
    } 
    public void DeleteFilter() { 
        User_setting__c Ganttviewsetting = new User_setting__c();        
        Ganttviewsetting.Id = selectedFilter;
        delete Ganttviewsetting;        
        selectedFilter = '0';
        displayPopup = false;
        loadganttviewbyFilter();              
    }     
    public PageReference closePopup() { 
        PageReference pg = new PageReference(System.currentPageReference().getURL());
        pg.setRedirect(false);
        displayPopup = false; 
        return pg;                            
    }  
    public void showPopup() {  
        getFilter();       
        displayPopup = true; 
    }  
    public void getFilter(){ 
        musqot__User_setting__c get_musqot_filter = new User_setting__c();
        if(selectedFilter <> '0'){
            get_musqot_filter = [SELECT Id, Name, Ganttview__c, Global__c, My_default__c,Userid__c 
                                 FROM User_setting__c WHERE Id = :selectedFilter  and Gantt_type__c =:1  limit 250]; 
            FilterName = get_musqot_filter.Name;            
            DOM.Document doc = new DOM.Document();      
            try 
            {
                doc.load(get_musqot_filter.musqot__Ganttview__c);    
                DOM.XMLNode root = doc.getRootElement();
                string plantype = root.getChildElement('plantype', null).getText();
                selectedFilterProjectTypes= plantype.split(',');                       
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
            selectedFilterProjectTypes= new List<String>();
            FilterZooming = 'Days';
            FilterStartDate = System.today().addDays(-15);
            FilterEndDate = System.today().addMonths(2);
            GlobalFilter = false;
            mydefaultFilter = false;
            isGlobaluser = false;
        }
        
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
            //showPopup();
        }
        //getdataString();      
    } 
    
    public string getganttviewbyFilter(){
        musqot__User_setting__c musqot_filterSetting = new User_setting__c();
        try{            
            musqot_filterSetting = [SELECT Id, Name, Ganttview__c FROM User_setting__c 
                                    WHERE Id = :selectedFilter and Gantt_type__c = 1 limit 50]; 
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
                List<Project__c> projectList =[SELECT Id, Name, Status__c, StatusImage__c, Plantype__r.Name, CreatedById, Starts_date__c, Ends_date__c, Description__c,
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
                
                List<Subproject__c> spList = [select Id,Name,
                                              (select Id,Name,Activitytype__r.Icon__c,Activitytype__r.Name,Activitytype__r.Bar_color__c,Ends_date__c,Starts_date__c,Project__c,StatusImage__c,Status__c,Description__c,Project__r.Name 
                                               from Marketing_activities__r order by Starts_date__c) 
                                              from Subproject__c where Id IN :prjSet ];
                for(Subproject__c sPrj : spList){
                    mrkMap.put(sPrj.Id,sPrj.Marketing_activities__r);
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
                                mr.setStartDate(date.newinstance(ma.Starts_date__c.year(), ma.Starts_date__c.month(), ma.Starts_date__c.day()));                     
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
               //   style = style + 'background-color:#222;}';
                
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
    @TestVisible
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
        musqot__User_setting__c musqot_filterSetting = new musqot__User_setting__c();
        try{            
            musqot_filterSetting = [SELECT Id, Name, Ganttview__c FROM User_setting__c 
                                    WHERE Id = :selectedFilter and Gantt_type__c = 1 limit 50]; 
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
        List<Subproject__c> projectList = new List<Subproject__c>();
        List<Subproject__c> subprojectList = new List<Subproject__c>();
        
        
        
         String query = 'SELECT Id, Name, Owner.Name, CreatedById, Status__c, StatusImage__c,Starts_date__c, Ends_date__c,Project_del__c, Description__c, Parent_project__c, Project_type__r.Name'+   
                          ' FROM Subproject__c'+ 
                          ' WHERE IsDeleted = false'+ 
                          ' and Id = :subprojectId';
        
        query += ' order by Starts_date__c limit 25000';
        projectList = Database.query(query);
        
        if(projectList.size()>0) {
            String parentProId = projectList[0].Parent_project__c;
            // for subproject
            query = 'select Id, Name,Owner.Name, CreatedById, Status__c, StatusImage__c,Starts_date__c, Ends_date__c,Project_del__c, Description__c, Parent_project__c, Project_type__r.Name'+   
                                 ' FROM Subproject__c'+ 
                                 ' WHERE IsDeleted = false'+  
                                 ' and Parent_project__c = :parentProId ';
            if(selectedFilter <> '0'){
                if(FilterTypes != null) {
                    if(FilterTypes.size() > 0) {
                        query += ' and Project_type__c IN :FilterTypes';
                    } 
                } 
            }
            //selectedTypes
            query += ' order by Starts_date__c limit 25000';
            subprojectList = Database.query(query);
        }
            
        // query marketing activities
        Set<Id> prjSet = new Set<Id>();
        for(Subproject__c sp : subprojectList){                 
            prjSet.add(sp.Id);                
        }
        Map<Id,List<Marketing_activity__c>> mrkMap = new Map<Id,List<Marketing_activity__c>>();
        
        List<Subproject__c> spList = [select Id,Name,
                                      (select Id,Name,Owner.Name,Activitytype__r.Icon__c,Activitytype__r.Name,Activitytype__r.Bar_color__c,
                                       Ends_date__c,Starts_date__c,Project__c,StatusImage__c,Status__c,Description__c,
                                      Project__r.Name 
                                       from Marketing_activities__r order by Starts_date__c) 
                                      from Subproject__c where Id IN :prjSet ];
        
        Set<Id> maSet = new Set<Id>();
        if(musAct[0].Incl_Marketing_activity_Detail__c==true){
            for(Subproject__c sPrj : spList){
                mrkMap.put(sPrj.Id,sPrj.Marketing_activities__r);
                for(Marketing_activity__c ma : sPrj.Marketing_activities__r){
                    maSet.add(ma.Id);
                }
            }                                
        }
        
        List<Task> tasksForSp = [Select Id,Owner.Name, WhoId, WhatId, Subject, ActivityDate, Status, Priority, OwnerId,CreatedById, Description, IsDeleted, AccountId, IsClosed,  Allocated_h__c, Outcome_h__c,Task_description__c,Task_name__c, StatusImage__c   
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
         
        List<Task> tasksForMa = [Select Id,Owner.Name, WhoId, WhatId, Subject, ActivityDate, Status, Priority, OwnerId,CreatedById, Description, IsDeleted, AccountId, IsClosed,  Allocated_h__c, Outcome_h__c,Task_description__c,Task_name__c, StatusImage__c   
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
        // Iterate over Projects to build supporting JSON
        for( Subproject__c p : projectList){
            // Create a subscored name
            string n = (p.Project_type__c!= null) ? String.valueOf(p.Project_type__c).replaceAll(' ', '_') : 'default';
            n = n.replaceAll('-','_');
            
            // Create a new row object
            GanttRow rp = new GanttRow();
            rp.idPH = p.Id;
            rp.text = escapeSpecialChars(p.Name);
            rp.typePH = '!!!gantt.config.types.'+ n +'!!!';
            rp.setStartDate(date.newinstance(p.Starts_date__c.year(), p.Starts_date__c.month(), p.Starts_date__c.day()));
            rp.description = escapeSpecialChars(p.Description__c);
            rp.setDuration(date.newinstance(p.Starts_date__c.year(), p.Starts_date__c.month(), p.Starts_date__c.day()-1), p.Ends_date__c);
            rp.progress = 1;
            rp.open = true;
            rp.objType = 'subproject';
            if(p.StatusImage__c<>null){
                rp.img = p.StatusImage__c.replace('alt=','title=');     
            }
            rp.projectType = p.Project_type__r.Name;
            rp.owner = p.Owner.Name;
            // Add it into the renderRows list
            renderRows.add(rp);
            
            // Iterate over sub projects
            for( Subproject__c sp : subprojectList){
                // Create a subscored name
                string sn = (sp.Project_type__c!= null) ? String.valueOf(sp.Project_type__c).replaceAll(' ', '_') : 'default';
                sn = sn.replaceAll('-','_');
                
                // Create a new row object
                GanttRow rsp = new GanttRow();
                rsp.idPH = sp.Id;
                rsp.text = escapeSpecialChars(sp.Name);
                rsp.typePH = '!!!gantt.config.types.'+ sn +'!!!';
                rsp.setStartDate(date.newinstance(sp.Starts_date__c.year(), sp.Starts_date__c.month(), sp.Starts_date__c.day()));
                rsp.setDuration(date.newinstance(sp.Starts_date__c.year(), sp.Starts_date__c.month(), sp.Starts_date__c.day()-1), sp.Ends_date__c);
                rsp.description = escapeSpecialChars(sp.Description__c);                
                rsp.progress = 1;
                rsp.open = true;
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
                // Add it into the renderRows list
                renderRows.add(rsp);                                
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
                            mr.setStartDate(date.newinstance(ma.Starts_date__c.year(), ma.Starts_date__c.month(), ma.Starts_date__c.day()));                     
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
                        // Add it into the renderRows list
                        renderRows.add(mr);
                        
                        // tasks under marketing activities
                        if(tasksForMaMap.containsKey(ma.Id)) {
                        	for( Task t : tasksForMaMap.get(ma.Id)){
                                String ts = 'default';
                                // Create a new row object
                                GanttRow rtp = new GanttRow();
                                rtp.idPH = t.Id;
                                rtp.text = escapeSpecialChars(t.Task_name__c);
                                rtp.typePH = '!!!gantt.config.types.'+ ts +'!!!';
                                rtp.setStartDate(date.newinstance(t.ActivityDate.year(), t.ActivityDate.month(), t.ActivityDate.day()));
                                rtp.description = escapeSpecialChars(t.Task_description__c);
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
                                // Add it into the renderRows list
                                renderRows.add(rtp);
                            }
                        }
                    }
                }
                
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
                        rtp.description = escapeSpecialChars(t.Task_description__c);
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
        return new PageReference('/apex/SubprojectPerformance?backid='+subprojectId+'&subid=');
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
        public String projectType{get;private set;}
        public String owner{get;private set;}
        
        
        public void setStartDate(Date val){
            DateTime d = val;
            start_date =  d.format('dd-MM-yyyy');       
        }
        
        public void setDuration(Date starts, Date ends){
            duration =  starts.daysBetween(ends);   
        }
    }
    public pageReference gotoGanttPage(){
        
        Pagereference pg;
        string pageRef='';
        if(fromProject != null) {
            if(fromProject.length()==0)
                pageRef='/apex/GanttPage';
            else
                pageRef='/apex/SubProject?id='+fromProject;
        } else {
            pageRef='/apex/GanttPage';
        }
        pg=new Pagereference (pageRef);
        return pg;
    }
     public static string getParentId(){
        string subproId=ApexPages.currentPage().getParameters().get('id');
        prId=subproId;
        return prId;
    }
    
    public List<String> getselectedFilterProjectTypes() {
            return selectedFilterProjectTypes;
    }
    /* Raju commented --
     public void setCountries(List<String> selectedFilterProjectTypes) {
             this.selectedFilterProjectTypes= selectedFilterProjectTypes;
         }*/

}