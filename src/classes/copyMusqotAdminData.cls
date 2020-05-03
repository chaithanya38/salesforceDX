global class copyMusqotAdminData implements InstallHandler {
    global void onInstall(InstallContext context) {
        Map<String,String> plnMap = new Map<String,String>{'APAC' => 'C84F7C', 'North America' => '792271','EMEA' => '2D0F73','Latin America' => '234282','Other' => 'CECECE'};
            List<plantype__c> plnList = new List<plantype__c> ();
        
        Map<String,String> prjMap = new Map<String,String>{'Stategic marketing' => 'FFB92E', 'Tactical marketing' => 'FF9933','Product ABC' => 'FF6D2E','Product DEF' => 'FF858D','Co-branding' => 'F52C3D','Other' => 'CECECE'};
            List<Project_type__c> prjList = new List<Project_type__c> ();       
        
        List<String> paValues = new List<String>{'Agency services','Printing services','Media','Consulting services','Catering','Other'};
            List<Purchase_article__c> paList = new List<Purchase_article__c>();
          
            
            List<String> ptValues=new List<String>{'Musqot_admin','Musqot_global_user','Musqot_user','Musqot_user_sf','Musqot_admin_sf','Musqot_global_user_sf'};
            List<Permissionlist__c> perlist=new List<Permissionlist__c>();
            
           List<String> ctValues=new List<String>{'Administrador del sistema','Administrateur système','Amministratore del sistema','Järjestelmän pääkäyttäjä','Systeembeheerder','System Administrator','Systemadministrator','systemadministrator','Systemadministratör','Musqot admin','Musqot global user','Musqot user'};
            List<Profilelist__c> pflist=new List<Profilelist__c>();
        
          
        
        Map<String,String> atMap = new Map<String,String>{'Radio' => '00BFFF,Radio,1408689770000', 'Social media' => 'A700DF,Social,1408684282000','Event' => '006BA6,Event,1408689085000','Web ad' => 'BFE100,Banner,1404979766000','E-mail' => '369E2B,Mail,1404979791000','Sponsorship' => 'F07800,Sponsor,1408689790000','Billboard' => 'F00078,Billboard,1404980007000','Postal mail' => 'F0F000,Papermail,1404975316000'};
            
        Map<String,StaticResource> srMap = new Map<String,StaticResource>();
        List<StaticResource> srList = new List<StaticResource>([Select body, Name, SystemModStamp from StaticResource Limit 250]);
        for(StaticResource sr : srList){
            srMap.put(sr.Name,sr);
        }
       
        
        List<Activitytype__c> actTypeList = new List<Activitytype__c>();
      //  String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
      //  if (baseURL.startsWith('http:')){
      //      baseURL = baseURL.replaceFirst('http:', 'https:');
       // }
        
        if(context.previousVersion() == null) {    
            for(String p : plnMap.keySet()){
                plantype__c pl = new plantype__c();
                pl.Barcolor__c = plnMap.get(p);
                pl.Name = p;
                plnList.add(pl);
            }
            
            for(String p : prjMap.keySet()){
                Project_type__c pr = new Project_type__c();
                pr.Color__c = prjMap.get(p);
                pr.Name = p;
                prjList.add(pr);
            }
            
           for(String p1:ctValues)
                {
            Profilelist__c pf=new Profilelist__c();
            pf.name=p1;
            pflist.add(pf);
            
                }
            for(String p1:ptValues)
                {
            Permissionlist__c per=new Permissionlist__c();
            per.name=p1;
            perlist.add(per);
            
                }    
           
            for(String p : paValues){
                Purchase_article__c pa = new Purchase_article__c();
                pa.Name = p;
                paList.add(pa);
            }
            
            for(String a : atMap.keySet()){         
                Activitytype__c at = new Activitytype__c();             
                at.Name = a;
                at.Bar_color__c = atMap.get(a).split(',')[0]; 
                if(srMap.containsKey(atMap.get(a).split(',')[1].trim())){
           // icons in Admin for Plan/project/MA types
                     at.Icon__c = '/resource/'+srMap.get(atMap.get(a).split(',')[1].trim()).SystemModStamp.getTime()+'/musqot__'+atMap.get(a).split(',')[1].trim();
                }
                actTypeList.add(at);
            }
            
            Post_Install__c pi = new Post_Install__c();
           pi.Name = 'Amount Approval';
           Activity__c st=new musqot__Activity__c();
           st.Use_Allocation__c=true;
           st.Use_Finance1__c=true;
           st.Use_Budget__c=true;
           st.Incl_Marketing_activity_Main__c=true;
           st.Incl_Task_Detail__c=true;
           st.Use_Performance_CRM__c='Not used';
            if (Activity__c.sObjectType.getDescribe().isCreateable())
            {
            insert st;
            }
            if (Post_Install__c.sObjectType.getDescribe().isCreateable())
            {
                insert pi;
            }
            if (Profilelist__c.sObjectType.getDescribe().isCreateable())
                    {
                insert pflist;
                    } 
            if (Permissionlist__c.sObjectType.getDescribe().isCreateable())
                    {
                insert perlist;
                    }  
            
               try{
                if (plantype__c.sObjectType.getDescribe().isCreateable())
                {
                    insert plnList;
                }
                
               
                if (Project_type__c.sObjectType.getDescribe().isCreateable())
                {
                    insert prjList;
                }
                if (Purchase_article__c.sObjectType.getDescribe().isCreateable())
                {
                    insert paList;
                }
              
                if (Activitytype__c.sObjectType.getDescribe().isCreateable())
                {
                    insert actTypeList;
                }
                
            }catch(Exception e){
                
            }
            
        }
    }
}