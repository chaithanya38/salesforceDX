/***************************************************************
Class Name: MusqotUtility
Author:Hussain Peera         Last modified by: Narenndra K Jha
Date: 22/11/2014             Date: 4/11/2015
********©2013 Musqot marketing technology Pvt ltd *******/
public without sharing virtual class MusqotUtility{
    public static innerClass incls;
    public static innerClass incls1;
    public static innerClass incls2;
    public static innerClass incls3;
    public static innerclass incls4;
    public static innerclass incls5;
    public List<Profile> userprofile ;
    public List<Profilelist__c> p1; 
    public  List<Allocation_amount__c> parentid;
    private static Integer carryOut = 0;
    //Globals  for keycode 
    public static String organizationId;
    public static String edition;
    public static boolean resource;
    public static boolean advanceMilestone;
    public static boolean projectPerformance;
    public static boolean extendedSystemsIntegrations{get;set;}
    public static boolean forecasting;
    public static boolean ganttRelation;
    public static boolean multipleCurrencies;
    public static Integer noOfSocialMediaConnections;
    public boolean checkboolean=true;
   
    /***********************************************************
	securitySetting: gives security for costcenterdetail page
	**************************************************************/
    
    public static innerClass securitySettingcoscenter(Id workId){
        String MyProflieName;
        String Mypermissionsetname;
        String ownerrole;
        String userid;
        String planid;
        String myuserrole;
        Boolean Level1;
        Boolean Level2;
        Boolean Level3;
        Boolean Level4;
        Boolean Level5;
        String PermissionSet;
        List<Profile> userprofile =new List<Profile>();
        userprofile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() Limit 1];
        MyProflieName = userprofile[0].Name;
        
        //Permission Set start
        List<PermissionSetAssignment> lstcurrentUserPerSet =[SELECT PermissionSet.Name,AssigneeId FROM PermissionSetAssignment
                                                             WHERE AssigneeId = :Userinfo.getUserId() ];        
        for(PermissionSetAssignment p1:lstcurrentUserPerSet)
        { 
            if(p1.permissionSet.Name == 'Musqot_admin' ||  p1.permissionSet.Name =='Musqot_global_user' ||p1.permissionSet.Name =='Musqot_user'||p1.permissionSet.Name =='Musqot_admin_sf'||p1.permissionSet.Name =='Musqot_global_user_sf'||p1.permissionSet.Name =='Musqot_user_sf'||test.isrunningtest())
            { 
                PermissionSet = p1.permissionSet.Name;   
            }       
        }
        List<Members__c > userrole=new List<Members__c>();
        userrole = [Select Role__c 
                    	from Members__c where Cost_center__c=:workId AND ProjUsers__c=:UserInfo.getUserId() limit 1]; 
                      
        if(!userrole.isEmpty()){
            myuserrole = userrole[0].Role__c; 
            
        }
        List<Allocation_amount__c>  parentid =new List<Allocation_amount__c>();
        parentid = [Select Costcentre__r.OwnerID,Costcentre__r.name  
                    from Allocation_amount__c 
                    where To_Plan__c =:workId limit 25];                               
        String myuserid;
        if(!parentid.isEmpty()){
            myuserid = parentid[0].Costcentre__r.OwnerID;
        }
        If(myuserid == Userinfo.getUserId()){
            ownerrole = 'Owner';
        }
        //not used in costcenterdetail level
        /*List<musqot__Activity__c> musAct=new  List<musqot__Activity__c>();
               musAct=[SELECT Id, Use_Budget__c, Use_Finance1__c, Use_milestones__c 
                       FROM Activity__c limit 1];
      
            if(musAct[0].Use_milestones__c ==true ){      
                level4=true;
            }
            if(musAct[0].Use_Finance1__c==true){     
                level5=true;
            }*/ 
        //not used in costcenterdetail level
       
        Permissionlist__c pset=Permissionlist__c.getInstance(PermissionSet);
        
        Profilelist__c pl= Profilelist__c.getInstance(MyProflieName); //it is Custom setting object
        if(pl<>null)
        {  
            if(pl.profilename__c == 'System Administrator'|| myuserrole == 'Owner'||ownerrole == 'Owner'){
                Level1=True; 
                Level2=True;
                Level3=True;   
            }
              else if(MyProflieName == 'Musqot global user'||MyProflieName=='Musqot admin'||myuserrole=='Member'||ownerrole=='Member'||PermissionSet=='Musqot_admin'||PermissionSet=='Musqot_global_user'){
                Level1=True; 
                Level2=True;
                Level3=False;   
            }
            else if(myuserrole=='Viewer'){            
                Level1=True; 
                Level2=False;
                Level3=False;
                
            }
            else  {
                Level1=False; 
                Level2=False;
                Level3=False; 
            }   
        }
        else if(pset<>null){
        
        if( myuserrole == 'Owner'||ownerrole == 'Owner'){
                Level1=True; 
                Level2=True;
                Level3=True;
                }
           else  if(PermissionSet=='Musqot_admin'||PermissionSet=='Musqot_global_user'||PermissionSet=='Musqot_admin_sf'||PermissionSet=='Musqot_global_user_sf' ||myuserrole=='Member'||ownerrole=='Member'){ 
                    
                Level1=True; 
                Level2=True;
                Level3=False;                
            }           
            else  {
                Level1=False; 
                Level2=False;
                Level3=False; 
            }            
        }                
        incls = new innerClass(Level1,Level2,Level3,level4,level5); 
        return incls;         
    }
    /***********************************************************
	securitySetting: gives security for projectDetails page

	@ param: workid- >id of the plan record
	**************************************************************/
    public static innerClass securitySetting(Id workId){
        String MyProflieName;
        String Mypermissionsetname;
        String ownerrole;
        String userid;
        String planid;
        String myuserrole;
        Boolean Level1;
        Boolean Level2;
        Boolean Level3;
        Boolean Level4;
        Boolean Level5;
        String PermissionSet;

        List<Profile> userprofile =new List<Profile>();
        userprofile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() Limit 1];
        MyProflieName = userprofile[0].Name;      
        
        
        //Permission Set start
        List<PermissionSetAssignment> lstcurrentUserPerSet =[SELECT PermissionSet.Name,AssigneeId FROM PermissionSetAssignment
                                                             WHERE AssigneeId = :Userinfo.getUserId() ];
        
        for(PermissionSetAssignment p1:lstcurrentUserPerSet)
        {
            
            if(p1.permissionSet.Name == 'Musqot_admin' ||  p1.permissionSet.Name =='Musqot_global_user' ||p1.permissionSet.Name =='Musqot_user'||p1.permissionSet.Name =='Musqot_admin_sf'||p1.permissionSet.Name =='Musqot_global_user_sf'||p1.permissionSet.Name =='Musqot_user_sf'||test.isrunningtest())
            { 
                PermissionSet = p1.permissionSet.Name;   
            }       
        }
        List<musqot__Members__c > userrole=new List<musqot__Members__c>();
        userrole = [Select Role__c 
                    from Members__c 
                    where ProjMembers__c=:workid AND ProjUsers__c=:UserInfo.getUserId() limit 1];  
        if(!userrole.isEmpty()){
            myuserrole = userrole[0].musqot__Role__c; 
            
        }
        List<Allocation_amount__c>  parentid =new List<Allocation_amount__c>();
        parentid = [Select Costcentre__r.OwnerID,Costcentre__r.name  
                    from Allocation_amount__c 
                    where To_Plan__c =:workId limit 25];                               
        String myuserid;
        if(!parentid.isEmpty()){
            myuserid = parentid[0].Costcentre__r.OwnerID;
        }
        If(myuserid == Userinfo.getUserId()){
            ownerrole = 'Owner';
        }
      List<musqot__Activity__c> musAct=new  List<musqot__Activity__c>();
      	
        	musAct=[SELECT Id, Use_Budget__c, Use_Finance1__c, Use_milestones__c 
                       FROM Activity__c limit 1];
      if(musAct.size() > 0) {
          if(musAct[0].Use_milestones__c ==true ){      
              level4=true;
          }
          if(musAct[0].Use_Finance1__c==true){     
              level5=true;
          } 
      } 
        Permissionlist__c pset=Permissionlist__c.getInstance(PermissionSet);
        
        Profilelist__c pl= Profilelist__c.getInstance(MyProflieName); //it is Custom setting object
        if(pl<>null)
        {  
            if(pl.profilename__c == 'System Administrator'|| myuserrole == 'Owner'||ownerrole == 'Owner'){
                Level1=True; 
                Level2=True;
                Level3=True;
                
            }
              else if(MyProflieName == 'Musqot global user'||MyProflieName=='Musqot admin'||myuserrole=='Member'||ownerrole=='Member'||PermissionSet=='Musqot_admin'||PermissionSet=='Musqot_global_user'){
                Level1=True; 
                Level2=True;
                Level3=False;
                
                
            }
            else if(myuserrole=='Viewer'){            
                Level1=True; 
                Level2=False;
                Level3=False;
                
            }
            
            else  {
                Level1=False; 
                Level2=False;
                Level3=False; 
            }
            
        }
        else if(pset<>null){
        
        if( myuserrole == 'Owner'||ownerrole == 'Owner'){
        
        
                Level1=True; 
                Level2=True;
                Level3=True;
                }
           else  if(PermissionSet=='Musqot_admin'||PermissionSet=='Musqot_global_user'||PermissionSet=='Musqot_admin_sf'||PermissionSet=='Musqot_global_user_sf' ||myuserrole=='Member'||ownerrole=='Member'){ 
                    
                Level1=True; 
                Level2=True;
                Level3=False;
                
            }
           
            else  {
                Level1=False; 
                Level2=False;
                Level3=False; 
            }
            
        }        
        
        incls = new innerClass(Level1,Level2,Level3,level4,level5); 
        return incls;  
    } 
    /***********************************************************
securitySetting:gives security for subproject page

@ param: workid- >id of the project record 
**************************************************************/
    
    public static innerClass securitySettingsub(Id workId){
        String myuserrole;
        String MyProflieName;
        List<Profile> userprofile ;
        String subPrjId;
        String ccRole;
        String planRole;
        String parentRole ;
        String userid ;
        String parentplanid ;
        List<Allocation_amount__c> parentid; 
        list<Subproject__c> parentpID;
        String parentprojID ;
        list<Subproject__c> planID;
        Boolean Level1;
        Boolean Level2;
        Boolean Level3;
        Boolean Level4;
        Boolean Level5;
       
        String PermissionSet;
        
        // check user Profile
        userprofile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() Limit 1];
        MyProflieName = userprofile[0].Name;
        
        List<PermissionSetAssignment> lstcurrentUserPerSet =[SELECT PermissionSet.Name,AssigneeId FROM PermissionSetAssignment
                                                             WHERE AssigneeId = :Userinfo.getUserId() ];
        
        for(PermissionSetAssignment p1:lstcurrentUserPerSet)
        {
            
            
            if(p1.permissionSet.Name == 'Musqot_admin' ||  p1.permissionSet.Name =='Musqot_global_user' ||p1.permissionSet.Name =='Musqot_user'||p1.permissionSet.Name =='Musqot_admin_sf'||p1.permissionSet.Name =='Musqot_global_user_sf'||p1.permissionSet.Name =='Musqot_user_sf'||test.isrunningtest())
            { 
                
                PermissionSet = p1.permissionSet.Name;
                
                
            }       
        }
        List<musqot__Activity__c> musAct=new  List<musqot__Activity__c>();
        musAct=[SELECT Id, musqot__Use_Budget__c, musqot__Use_Finance1__c, musqot__Use_milestones__c FROM musqot__Activity__c  limit 1];
        List<musqot__Members__c> userrole=new List<musqot__Members__c>();
        // check Project user Role
        userrole = [Select Role__c 
                    from Members__c 
                    where musqot__SubProjMembers__c=:workid and ProjUsers__c=:UserInfo.getUserId() limit 1];
        if(!userrole.isEmpty()){
            myuserrole = userrole[0].musqot__Role__c;
        }
        try{
            planID = [select Id, Parent_project__c 
                      from Subproject__c 
                      where Id =:workId limit 1];
        }Catch(Exception e){
            
        }
        if(!planID.isEmpty()){
            parentplanid = planID[0].Parent_project__c;
            
        }
        parentid = [Select  Costcentre__r.OwnerID, Costcentre__r.name 
                    from Allocation_amount__c 
                    where To_Plan__c =:parentplanid  limit 1];                               
        String myuserid;
        if(!parentid.isEmpty()){
            myuserid = parentid[0].Costcentre__r.OwnerID;
        }
        If (myuserid ==Userinfo.getUserId()){
            ccRole = 'Owner';
        }
        
        // Check Plan Owner
        userrole = [Select Id,Role__c 
                    from Members__c 
                    where ProjMembers__c=:parentplanid AND ProjUsers__c =:UserInfo.getUserId() limit 1];
        if(!userrole.isEmpty()){
            planRole = userrole[0].musqot__Role__c;
        }
        
        // Check Parent Owner
        try{
            parentpID = [select id, Parent_project__c 
                         from Subproject__c 
                         where Parent_project__c =:parentplanid limit 1];
        }
        Catch(Exception e){
        }
        if(!parentpID.isEmpty()){
            parentprojID = parentpID [0].Parent_project__c ;
        }
        userrole = [Select Id, Role__c 
                    from Members__c 
                    where SubProjMembers__c=:parentprojID AND musqot__ProjUsers__c =:UserInfo.getUserId() limit 1];
        if(!userrole.isEmpty()){
            parentRole = userrole[0].Role__c;
        }
       
        if(musAct[0].musqot__Use_milestones__c ==true){         
            level4=true;
        }  
       
        Permissionlist__c pset1=Permissionlist__c.getInstance(PermissionSet);
        
        Profilelist__c p2 = Profilelist__c.getInstance(MyProflieName);  
        if(p2<>null)
        { 
            If(MyProflieName=='System Administrator'||myuserrole == 'Owner'||ccRole == 'Owner'||parentRole == 'Owner'||planRole == 'Owner')
            {
           
                Level1=True; 
                Level2=True;
                Level3=True;
            }
            
            else if(MyProflieName=='Musqot global user'||MyProflieName=='Musqot admin'||myuserrole=='Member'||planRole=='Member'||parentRole=='Member'){
              
                Level1=True; 
                Level2=True;
                Level3=False;
            }
            else if(myuserrole=='Viewer'){
           
                Level1=True; 
                Level2=False;
                Level3=False;
                
            }
            else {
           
                Level1=False; 
                Level2=False;
                Level3=False; 
            }
        }
        else if(pset1<>null){
          if( myuserrole == 'Owner'||ccRole == 'Owner'||parentRole == 'Owner'||planRole == 'Owner'){
        
        
                Level1=True; 
                Level2=True;
                Level3=True;
                }
           else if(PermissionSet=='Musqot_admin'||PermissionSet=='Musqot_global_user'||PermissionSet=='Musqot_admin_sf'||PermissionSet=='Musqot_global_user_sf'||myuserrole=='Member'||planRole=='Member'||parentRole=='Member' ){  
                Level1=True; 
                Level2=True;
                Level3=False;
                
            }
            else  {
                Level1=False; 
                Level2=False;
                Level3=False; 
            }
            
        }       
        incls1 = new innerClass(Level1,Level2,Level3,level4,level5); 
        return incls1;  
        
    } 
    /***********************************************************
securitySetting: gives security for marketingactivity page

@ param: workid- >id of the marketingactivity record 
************************************************************/
        public static innerClass markertsecuritySetting(Id workId){
        String myuserrole;
        String MyProflieName;
        String ccRole;
        String marktingid;
        String planRole;
        List<Profile> userprofile ;
        String parentRole ;
        String userid ;
        String parentplanid ;
        String subprojectid ;
        list<musqot__Subproject__c> parentpID;
        List<Allocation_amount__c> parentid; 
        String parentprojID ;
        list<musqot__Marketing_activity__c > markID;
        Boolean Level1;
        Boolean Level2;
        Boolean Level3;
        Boolean Level4;
        Boolean Level5;
        Boolean CustomPermissionSet;
        String PermissionSet;
        
        
        // check user Profile
        userprofile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() Limit 1];
        MyProflieName = userprofile[0].Name;
        List<PermissionSetAssignment> lstcurrentUserPerSet =[SELECT PermissionSet.Name,AssigneeId FROM PermissionSetAssignment
                                                             WHERE AssigneeId = :Userinfo.getUserId() ];
        
        for(PermissionSetAssignment p1:lstcurrentUserPerSet)
        {
            
            if(p1.permissionSet.Name == 'Musqot_admin' ||  p1.permissionSet.Name =='Musqot_global_user' ||p1.permissionSet.Name =='Musqot_user'||p1.permissionSet.Name =='Musqot_admin_sf'||p1.permissionSet.Name =='Musqot_global_user_sf'||p1.permissionSet.Name =='Musqot_user_sf')
            { 
                PermissionSet = p1.permissionSet.Name;
                
            }       
        }
        List<musqot__Members__c> userrole=new List<musqot__Members__c>();
        // check Project Logined user Role in Member
        userrole = [Select musqot__Role__c from musqot__Members__c where musqot__Marketingmebers__c=:Workid AND musqot__ProjUsers__c =:UserInfo.getUserId() limit 1];
        if(!userrole.isEmpty()){
            myuserrole = userrole[0].musqot__Role__c;
        }
        // check CC owner
        try{
            markID= [select Id, Plan__c 
                     from Marketing_activity__c 
                     where Id =:workId limit 1];
        }
        Catch(Exception e){
        }
        if(!markID.isEmpty()){
            parentplanid = markID[0].musqot__Plan__c ;
        }
        parentid = [Select  Costcentre__r.OwnerID ,Costcentre__r.name 
                    from Allocation_amount__c 
                    where To_Plan__c =:parentplanid  limit 1];                               
        String myuserid;
        if(!parentid.isEmpty()){
            myuserid = parentid[0].Costcentre__r.Ownerid;
        }
        If (myuserid == Userinfo.getUserId() ){
            ccRole = 'Owner';
        }
        // Check Plan Owner
        userrole = [Select id, Role__c from Members__c 
                    where ProjMembers__c=:parentplanid AND ProjUsers__c =:UserInfo.getUserId() limit 1];
        if(!userrole.isEmpty()){
            planRole = userrole[0].Role__c;
        }
        // Check Parent Owner
        try{
            parentpID = [select Parent_project__c    
                         from Subproject__c 
                         where Parent_project__c  =:parentplanid limit 1];
            
        }
        Catch(Exception e){
        }
        if(!parentpID.isEmpty()){
            parentprojID = parentpID [0].Parent_project__c ;
            
        }
        userrole = [Select Id, Role__c 
                    from Members__c 
                    where SubProjMembers__c=:parentprojID AND ProjUsers__c =:UserInfo.getUserId()];
        
        if(!userrole.isEmpty()){
            parentRole = userrole[0].Role__c;
        }
        Permissionlist__c pset2=Permissionlist__c.getInstance(PermissionSet);
        Profilelist__c p3 = Profilelist__c.getInstance(MyProflieName);  
        if(p3<>null){
            
            If(MyProflieName=='System Administrator'||myuserrole == 'Owner'||ccRole == 'Owner'||parentRole == 'Owner'||planRole == 'Owner'){
                Level1=True; 
                Level2=True;
                Level3=True;
            }
            else if(MyProflieName=='Musqot global user'||MyProflieName=='Musqot admin'||myuserrole=='Member'||planRole=='Member'||parentRole=='Member'){
                Level1=True; 
                Level2=True;
                Level3=False;
            }
            else if(myuserrole=='Viewer'){
                Level1=True; 
                Level2=False;
                Level3=False;
            }
            else {
                Level1=False; 
                Level2=False;
                Level3=False; 
            }
        }
        else if(pset2<>null){
          if( myuserrole == 'Owner'||ccRole == 'Owner'||parentRole == 'Owner'||planRole == 'Owner'){
        
        
                Level1=True; 
                Level2=True;
                Level3=True;
                }
           else  if(PermissionSet=='Musqot_admin'||PermissionSet=='Musqot_global_user'||PermissionSet=='Musqot_admin_sf'||PermissionSet=='Musqot_global_user_sf'||myuserrole=='Member'||planRole=='Member'||parentRole=='Member'){           
                Level1=True; 
                Level2=True;
                Level3=False;
                
            }
            else  {
                Level1=False; 
                Level2=False;
                Level3=False; 
            }
            
        }       
        incls2 = new innerClass(Level1,Level2,Level3,level4,level5); 
        return incls2;  
    } 
    public class innerClass{
        public boolean l1; 
        public boolean l2;
        public boolean l3;
        public boolean l4;
        public boolean l5;
        public innerClass(boolean l1,boolean l2,boolean l3,boolean l4,boolean l5){
            this.l1 = l1;
            this.l2 = l2;
            this.l3 = l3;
            this.l4 = l4;
            this.l5 = l5;
            
        }
    }
    
    
    // -- keycode decryption --  -- added by Narendra K Jha -- -- start--
    public static boolean decryptKeycode(String keycode) {
        // remove hyphens
        keycode = keycode.replace('-', '');
        Integer keycodeLength = keycode.length();
        if(keycodeLength < 20) {
            organizationId = '';
            edition = 'Invalid';
            return false;
        }
        // unshift
		String result = '';
		Integer k = 7;
		for(Integer i=0; i<keycodeLength; i++) {
			result += unshift(keycode.substring(i, i+1),k);
		}
        
        // Create masking key 
		String key = '';
		Integer kc = (keycodeLength/6)+1; // how many repetition
		for(Integer i=1; i<=kc; i++)
			key += 'MUSQOT';
		Integer kc1 = 6-(math.mod(keycodeLength,6)); // how much to trim off
		key = key.substring(0, key.length()-kc1);
		
		// Unmasking ...
		String intermediateResult = '';
		for(Integer i=result.length()-1; i>-1; i--) {
			intermediateResult += unmask(result.substring(i, i+1),key.substring(i, i+1));
		}
		intermediateResult = intermediateResult.reverse();
		
		// get edition
		edition = intermediateResult.substring(16,17);
        
		if((keycodeLength != 20 && !edition.equals('C')) || (edition.equals('C') && keycodeLength >= 25)) {
            organizationId = '';
            edition = 'Invalid';
            return false;
        }
        
		// unshift further
		if(edition.equals('T')) k = 4; else if(edition.equals('S')) k = 11;
        else if(edition.equals('P')) k = 16;  else if(edition.equals('E')) k =22;
        else k = 0;
		if(!edition.equals('C')) {
			intermediateResult = result;
			result = '';
			for(Integer i=0; i<16; i++) {
				result += unshift(intermediateResult.substring(i,i+1),k);
			}
			result += intermediateResult.substring(16,intermediateResult.length());
			
			// Unmasking ...
			intermediateResult = '';
			for(Integer i=result.length()-1; i>-1; i--) {
				intermediateResult += unmask(result.substring(i,i+1),key.substring(i, i+1));
			}
			intermediateResult = intermediateResult.reverse();
		}
		result = intermediateResult;
        if(keycodeLength == 20 && !edition.equals('C')) {
            if(result.substring(17,20) != '000') {
                organizationId = '';
                edition = 'Invalid';
                return false;
            }
        }
        
		// removing extra padded zeros
		if(keycodeLength == 20) {
			// remove 3 chars from end
			result = result.substring(0,result.length()-3);
		} else if(keycodeLength > 25) {
			// remove 2 chars from end
			result = result.substring(0,result.length()-2);
		}
		
		organizationId = result.substring(0,16);
		edition = getEdition(edition);
		if(edition.equals('Custom')) {
			resource = result.substring(17,18)=='1'?true:false;
			advanceMilestone = result.substring(18,19)=='1'?true:false;
			projectPerformance = result.substring(19,20)=='1'?true:false;
			extendedSystemsIntegrations = result.substring(20,21)=='1'?true:false;
			forecasting = result.substring(21,22)=='1'?true:false;
			ganttRelation = result.substring(22,23)=='1'?true:false;
			multipleCurrencies = result.substring(23,24)=='1'?true:false;
			noOfSocialMediaConnections = Integer.valueOf(result.substring(24,result.length()));
		}
        else if(edition.equals('Trial')){
            extendedSystemsIntegrations=true;
             resource=true;            
        } 
         else if(edition.equals('Standard')) {
             extendedSystemsIntegrations=false;
              resource=false;
         } 
         else if(edition.equals('Professional')) {
              extendedSystemsIntegrations=true;
              resource=true;
         } 
         else if(edition.equals('Enterprise')) {
              extendedSystemsIntegrations=true;
              resource=true;
         } 
        return true;
    }
    
    private static String unshift(String c, Integer k) {
		return charOf(math.mod((valueOf(c)-k+62),62));
	}
    
    public static String unmask(String c1, String c2) {
		Integer diff = (valueOf(c1) - carryOut) - valueOf(c2);
		carryOut = diff<0?1:0;
		return charOf(math.mod((diff+62),62));
	}
    
    public static String getEdition(String edChar) {
        String edition2 = '';
        if(edChar.equals('T')) edition2 = 'Trial'; else if(edChar.equals('S')) edition2 = 'Standard';
        else if(edChar.equals('P')) edition2 = 'Professional';  else if(edChar.equals('E')) edition2 = 'Enterprise';
        else if(edChar.equals('C')) edition2 = 'Custom'; else edition2 = 'Invalid';
		
		return edition2;
    }
    
    public static Integer valueOf(String ch){
		Integer chVal = 0;
        if(ch.equals('0')) chVal = 0; else if(ch.equals('1')) chVal = 1;
        else if(ch.equals('2')) chVal = 2; else if(ch.equals('3')) chVal = 3;
        else if(ch.equals('4')) chVal = 4; else if(ch.equals('5')) chVal = 5;
        else if(ch.equals('6')) chVal = 6; else if(ch.equals('7')) chVal = 7;
        else if(ch.equals('8')) chVal = 8; else if(ch.equals('9')) chVal = 9;
        else if(ch.equals('A')) chVal = 10; else if(ch.equals('B')) chVal = 11;
        else if(ch.equals('C')) chVal = 12; else if(ch.equals('D')) chVal = 13;
        else if(ch.equals('E')) chVal = 14; else if(ch.equals('F')) chVal = 15;
        else if(ch.equals('G')) chVal = 16; else if(ch.equals('H')) chVal = 17;
        else if(ch.equals('I')) chVal = 18; else if(ch.equals('J')) chVal = 19;
        else if(ch.equals('K')) chVal = 20; else if(ch.equals('L')) chVal = 21;
        else if(ch.equals('M')) chVal = 22; else if(ch.equals('N')) chVal = 23;
        else if(ch.equals('O')) chVal = 24; else if(ch.equals('P')) chVal = 25;
        else if(ch.equals('Q')) chVal = 26; else if(ch.equals('R')) chVal = 27;
        else if(ch.equals('S')) chVal = 28; else if(ch.equals('T')) chVal = 29;
        else if(ch.equals('U')) chVal = 30; else if(ch.equals('V')) chVal = 31;
        else if(ch.equals('W')) chVal = 32; else if(ch.equals('X')) chVal = 33;
        else if(ch.equals('Y')) chVal = 34; else if(ch.equals('Z')) chVal = 35;
        else if(ch.equals('a')) chVal = 36; else if(ch.equals('b')) chVal = 37;
        else if(ch.equals('c')) chVal = 38; else if(ch.equals('d')) chVal = 39;
        else if(ch.equals('e')) chVal = 40; else if(ch.equals('f')) chVal = 41;
        else if(ch.equals('g')) chVal = 42; else if(ch.equals('h')) chVal = 43;
        else if(ch.equals('i')) chVal = 44; else if(ch.equals('j')) chVal = 45;
        else if(ch.equals('k')) chVal = 46; else if(ch.equals('l')) chVal = 47;
        else if(ch.equals('m')) chVal = 48; else if(ch.equals('n')) chVal = 49;
        else if(ch.equals('o')) chVal = 50; else if(ch.equals('p')) chVal = 51;
        else if(ch.equals('q')) chVal = 52; else if(ch.equals('r')) chVal = 53;
        else if(ch.equals('s')) chVal = 54; else if(ch.equals('t')) chVal = 55;
        else if(ch.equals('u')) chVal = 56; else if(ch.equals('v')) chVal = 57;
        else if(ch.equals('w')) chVal = 58; else if(ch.equals('x')) chVal = 59;
        else if(ch.equals('y')) chVal = 60; else if(ch.equals('z')) chVal = 61;
        else chVal = 0;
		
		return chVal;
	}
    
    public static String charOf(Integer value){
		String ch = ' ';
        if(value == 0) ch = '0'; else if(value == 1) ch = '1';
        else if(value == 2) ch = '2'; else if(value == 3) ch = '3';
        else if(value == 4) ch = '4'; else if(value == 5) ch = '5';
        else if(value == 6) ch = '6'; else if(value == 7) ch = '7';
        else if(value == 8) ch = '8'; else if(value == 9) ch = '9';
        else if(value == 10) ch = 'A'; else if(value == 11) ch = 'B';
        else if(value == 12) ch = 'C'; else if(value == 13) ch = 'D';
        else if(value == 14) ch = 'E'; else if(value == 15) ch = 'F';
        else if(value == 16) ch = 'G'; else if(value == 17) ch = 'H';
        else if(value == 18) ch = 'I'; else if(value == 19) ch = 'J';
        else if(value == 20) ch = 'K'; else if(value == 210) ch = 'L';
        else if(value == 22) ch = 'M'; else if(value == 23) ch = 'N';
        else if(value == 24) ch = 'O'; else if(value == 25) ch = 'P';
        else if(value == 26) ch = 'Q'; else if(value == 27) ch = 'R';
        else if(value == 28) ch = 'S'; else if(value == 29) ch = 'T';
        else if(value == 30) ch = 'U'; else if(value == 31) ch = 'V';
        else if(value == 32) ch = 'W'; else if(value == 33) ch = 'X';
        else if(value == 34) ch = 'Y'; else if(value == 35) ch = 'Z';
        else if(value == 36) ch = 'a'; else if(value == 37) ch = 'b';
        else if(value == 38) ch = 'c'; else if(value == 39) ch = 'd';
        else if(value == 40) ch = 'e'; else if(value == 41) ch = 'f';
        else if(value == 42) ch = 'g'; else if(value == 43) ch = 'h';
        else if(value == 44) ch = 'i'; else if(value == 45) ch = 'j';
        else if(value == 46) ch = 'k'; else if(value == 45) ch = 'l';
        else if(value == 48) ch = 'm'; else if(value == 49) ch = 'n';
        else if(value == 50) ch = 'o'; else if(value == 51) ch = 'p';
        else if(value == 52) ch = 'q'; else if(value == 53) ch = 'r';
        else if(value == 54) ch = 's'; else if(value == 55) ch = 't';
        else if(value == 56) ch = 'u'; else if(value == 57) ch = 'v';
        else if(value == 58) ch = 'w'; else if(value == 59) ch = 'x';
        else if(value == 60) ch = 'y'; else if(value == 61) ch = 'z';
        else ch = ' ';
		
		return ch;
	}
     // -- keycode decryption --  -- added by Narendra K Jha -- -- end --
    
     // ---Raju adding this .---For adding extension with attached file ---
    public static String fileType(string contentType){
        string fileType;
        if(contentType == 'application/msword'){fileType = '.doc';} 
        else if(contentType== 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'){fileType = '.docx';}  
        else if(contentType == 'text/calendar'){fileType = '.ics';} 
        else if(contentType== 'application/x-indesign'){fileType = '.indd';} 
        else if(contentType== 'application/vnd.oasis.opendocument.database'){fileType = '.odb';} 
        else if(contentType == 'application/vnd.oasis.opendocument.chart'){fileType = '.odc';} 
        else if(contentType == 'application/vnd.oasis.opendocument.formula'){fileType = '.odf';} 
        else if(contentType == 'application/vnd.oasis.opendocument.graphics'){fileType = '.odg';} 
        else if(contentType == 'application/vnd.oasis.opendocument.image'){fileType = '.odi';} 
        else if(contentType == 'application/vnd.oasis.opendocument.presentation'){fileType = '.odp';} 
        else if(contentType == 'application/vnd.oasis.opendocument.spreadsheet'){fileType = '.ods';}        
        else if(contentType == 'application/vnd.oasis.opendocument.text'){fileType = '.odt';} 
        else if(contentType == 'application/pdf'){fileType = 'PDF';} 
        else if(contentType == 'application/vnd.openxmlformats-officedocument.presentationml.slideshow'){fileType = '.ppsx';} 
        else if(contentType == 'application/vnd.ms-powerpoint'){fileType = '.ppt';}      
        else if(contentType == 'application/vnd.openxmlformats-officedocument.presentationml.presentation'){fileType = '.pptx';} 
        else if(contentType == 'application/x-mspublisher'){fileType = '.pub';}        
        else if(contentType.startsWith('application/vnd.quark')){fileType = '.qxp';} 
        else if(contentType == 'application/x-rar-compressed'){fileType = '.rar';} 
        else if(contentType == 'application/vnd.stardivision.draw'){fileType = '.sda';} 
        else if(contentType == 'application/vnd.stardivision.calc'){fileType = '.sdc';}  
        else if(contentType == 'application/vnd.stardivision.impress'){fileType = '.sdd';} 
        else if(contentType == 'application/vnd.stardivision.writer'){fileType = '.sdw';}        
        else if(contentType == 'application/x-stuffit'){fileType = '.sit';} 
        else if(contentType == 'application/vnd.openxmlformats-officedocument.presentationml.slide'){fileType = '.sldx';} 
        else if(contentType == 'application/vnd.stardivision.math'){fileType = '.smf';} 
        else if(contentType == 'application/x-shockwave-flash'){fileType = '.swf';}  
        else if(contentType == 'application/vnd.sun.xml.calc'){fileType = '.sxc';} 
        else if(contentType == 'application/vnd.sun.xml.draw'){fileType = '.sxd';} 
        else if(contentType == 'application/vnd.sun.xml.impress'){fileType = '.sxi';} 
        else if(contentType == 'application/vnd.sun.xml.math'){fileType = '.sxm';} 
        else if(contentType == 'application/vnd.sun.xml.writer'){fileType = '.sxw';} 
        else if(contentType == 'text/plain'){fileType = '.txt';} 
        else if(contentType == 'application/vnd.ms-wpl'){fileType = '.wpl';} 
        else if(contentType == 'application/vnd.ms-works'){fileType = '.wps';} 
        else if(contentType == 'application/x-mswrite'){fileType = '.wri';} 
        else if(contentType == 'application/vnd.ms-excel'){fileType = '.xls';} 
        else if(contentType == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'){fileType = '.xlsx';} 
        else if(contentType == 'application/vnd.ms-xpsdocument'){fileType = '.xps';}
        else if(contentType == 'application/zip'){fileType = '.zip';}
        else if(contentType.startsWith('audio/')){fileType = 'Audio';}
        else if(contentType=='image/jpeg'){fileType = '.jpeg';}
        else if(contentType=='image/png'){fileType = '.png';}
        else if(contentType.startsWith('video/')){fileType = 'Video';}
        else {fileType = 'Other';}
        return fileType;
    }
   //---End---
   
    
    public static Map<String, Schema.DescribeFieldResult> getFieldMetaData(  
          Schema.DescribeSObjectResult dsor, Set<String> fields) {
        
          // the map to be returned with the final data
          Map<String,Schema.DescribeFieldResult> finalMap = 
            new Map<String, Schema.DescribeFieldResult>();
          // map of all fields in the object
          Map<String, Schema.SObjectField> objectFields = dsor.fields.getMap();
        
          // iterate over the requested fields and get the describe info for each one. 
          // add it to a map with field name as key
          for(String field : fields){
            // skip fields that are not part of the object
            if (objectFields.containsKey(field)) {
              Schema.DescribeFieldResult dr = objectFields.get(field).getDescribe();
              // add the results to the map to be returned
              finalMap.put(field, dr); 
            }
          }
          return finalMap;
    }
    
}