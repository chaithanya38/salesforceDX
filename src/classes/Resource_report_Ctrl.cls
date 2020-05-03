public  with sharing class Resource_report_Ctrl{
    public date startDat{get; set;}
    public String GroupId;
    public Date sDateA;
    public Date eDateA;
    public Date sDateB;
    public Date eDateB;
    public Date sDateC;
    public Date eDateC;
    public Date sDateD;
    public Date eDateD;
    public Date sDateE;
    public Date eDateE;
    public Date sDateF;
    public Date eDateF;
    public Date sDateG;
    public Date eDateG;
    public Date sDateH;
    public Date eDateH;
    public string selectedStatus{get;set;}
    public string selectedGroup{get;set;}
    public boolean FocusA{get;set;}
    public boolean FocusB{get;set;}
    public boolean FocusL{get;set;}
    public List<Group> groupTemp = new List<Group>();
    public List<GroupMember> groupMemTemp = new List<GroupMember>();
    public list<string>gid;
    public string MyProflieName;
    public List<Task>taskUserList1{get;set;}
    private list<Resources> res;
    public List<user>UserList{get;set;}
    public List<User>UserList1{get;set;}
    public set<Id>gId1;
    public set<Id>gMemId;
    public set<Id>allGrId;
    public set<Id>uId; 
    public list<string> uId1;
    public List<GroupMember>gMemList=new List<GroupMember>();
   
    public Resource_report_Ctrl(){
        
        startDat = system.today();
        UserList=new List<user>();
        uId1=new List<string>();
    } 
    public list<SelectOption> getItems(){
        List<SelectOption> opts = new List<SelectOption>();
        opts.add(new SelectOption('-- Select --','-- Select --'));  
        opts.add(new SelectOption('Not Started','Planed'));                 
        opts.add(new SelectOption('In progress','In progress'));
        opts.add(new SelectOption('Open','Open')); 
        opts.add(new SelectOption('Completed','Completed')); 
        return opts;
    } 
    public List<SelectOption> groupList{
        get { 
            Set<string>labels = new set<string>();
            Profile userprofile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() Limit 1];
            MyProflieName = userprofile.Name;
            Profilelist__c pName = Profilelist__c.getInstance(MyProflieName); //it is Custom setting object
            gid=new list<string>();
            groupMemTemp=[SELECT GroupId,UserOrGroupId FROM GroupMember WHERE UserOrGroupId=:UserInfo.getUserId()];
            for(GroupMember g:groupMemTemp){
                gid.add(g.GroupId);
            }
            groupTemp = [SELECT  g.Name, g.Id FROM Group g where g.ID IN:gid];
            groupList = new List<SelectOption>();
            groupList.add(new SelectOption('All group','All group'));
            for(Group temp : groupTemp){ 
                groupList.add(new SelectOption(temp.Name, temp.Name));
            }
            return groupList;
        }
        set;
    }
    /******************************************************** 
Resource:This wrapper class variables declaration.
********************************************************/  
    public class Resources {
        public String rUsername{get;set;}
        public String rTitle{get;set;}
        public String rDepartment{get;set;}
        public String rEmpNr{get;set;}
        public String rManager{get;set;}
        public String rGroup{get;set;}
        public Decimal rWeekA{get;set;}
        public Decimal rWeekB{get;set;}
        public Decimal rWeekC{get;set;}
        public Decimal rWeekD{get;set;}
        public Decimal rWeekE{get;set;}
        public Decimal rWeekF{get;set;}
        public Decimal rWeekG{get;set;}
        public Decimal rWeekH{get;set;}
        public Decimal rWeekI{get;set;}
        public Decimal rWeekJ{get;set;}
        public Decimal rWeekK{get;set;}
        public Decimal rWeekL{get;set;}
    }
    Public string lWeekA{get;set;}
    Public string lWeekB{get;set;}
    Public string lWeekC{get;set;}
    Public string lWeekD{get;set;}
    Public string lWeekE{get;set;}
    Public string lWeekF{get;set;}
    Public string lWeekG{get;set;}
    Public string lWeekH{get;set;}
    Public string lWeekI{get;set;}
    Public string lWeekJ{get;set;}
    Public string lWeekK{get;set;}
    Public string lWeekL{get;set;}
    Public string FocusWeek{get;set;}
        public Decimal totWeekA{get;set;}
        public Decimal totWeekB{get;set;}
        public Decimal totWeekC{get;set;}
        public Decimal totWeekD{get;set;}
        public Decimal totWeekE{get;set;}
        public Decimal totWeekF{get;set;}
        public Decimal totWeekG{get;set;}
        public Decimal totWeekH{get;set;}
        public Decimal totWeekI{get;set;}
        public Decimal totWeekJ{get;set;}
        public Decimal totWeekK{get;set;}
        public Decimal totWeekL{get;set;}
        
    /******************************************************** 
End wrapper class variables declaration.
********************************************************/  
    public List<Resources> getres(){
        Date sDateA;
        Date eDateA;
        Date sDateB;
        Date eDateB;
        Date sDateC;
        Date eDateC;
        Date sDateD;
        Date eDateD;
        Date sDateE;
        Date eDateE;
        Date sDateF;
        Date eDateF;
        Date sDateG;
        Date eDateG;
        Date sDateH;
        Date eDateH;
        Date sDateI;
        Date eDateI;
        Date sDateJ;
        Date eDateJ;
        Date sDateK;
        Date eDateK;
        Date sDateL;
        Date eDateL;
        FocusA = false;
        FocusB = false;
        FocusL = false;
        StartDat = StartDat.toStartofWeek();
        if(selectedStatus=='Completed'){ 
            sDateA = StartDat.addDays(-70);
            StartDat = StartDat.addDays(-35);
            FocusL = true;
        }
        else if(selectedStatus=='In Progress'){ 
            sDateA = StartDat.addDays(-14);
            StartDat = StartDat.addDays(-7);
            FocusB = true;
        }
        else{ 
            sDateA = StartDat;
            FocusA = true;
        }
        
        eDateA= StartDat.addDays(6);
        sDateB = StartDat.addDays(7);
        eDateB = StartDat.addDays(13);
        sDateC = StartDat.addDays(14);
        eDateC = StartDat.addDays(20);
        sDateD = StartDat.addDays(21);
        eDateD = StartDat.addDays(27);
        sDateE = StartDat.addDays(28);
        eDateE = StartDat.addDays(34);
        sDateF = StartDat.addDays(35);
        eDateF = StartDat.addDays(41);
        sDateG = StartDat.addDays(42);
        eDateG = StartDat.addDays(48);
        sDateH = StartDat.addDays(49);
        eDateH = StartDat.addDays(55);
        sDateI = StartDat.addDays(56);
        eDateI = StartDat.addDays(62);
        sDateJ = StartDat.addDays(63);
        eDateJ = StartDat.addDays(69);
        sDateK = StartDat.addDays(70);
        eDateK = StartDat.addDays(76);
        sDateL = StartDat.addDays(77);
        eDateL= StartDat.addDays(365);
        
        Date today=StartDat;
        Date todaydate = StartDat;
        Date todaydateinstance = date.newinstance(todaydate.year(), todaydate.month(), todaydate.day());
        Integer currentyear = todaydate.year();
        Date startDate = date.newinstance(currentyear, 01, 01);
        integer numberDaysDue = startDate.daysBetween(todaydateinstance);
        Integer numberOfWeekA = math.MOD(Integer.valueof(math.FLOOR( ( numberDaysDue )/7)),52)+1;
        Integer numberOfWeekB = math.MOD(Integer.valueof(math.FLOOR( ( numberDaysDue+6 )/7)),52)+1;
        Integer numberOfWeekC = math.MOD(Integer.valueof(math.FLOOR( ( numberDaysDue+13 )/7)),52)+1;
        Integer numberOfWeekD = math.MOD(Integer.valueof(math.FLOOR( ( numberDaysDue+20 )/7)),52)+1;
        Integer numberOfWeekE = math.MOD(Integer.valueof(math.FLOOR( ( numberDaysDue+27 )/7)),52)+1;
        Integer numberOfWeekF = math.MOD(Integer.valueof(math.FLOOR( ( numberDaysDue+34 )/7)),52)+1;
        Integer numberOfWeekG = math.MOD(Integer.valueof(math.FLOOR( ( numberDaysDue+41 )/7)),52)+1;
        Integer numberOfWeekH = math.MOD(Integer.valueof(math.FLOOR( ( numberDaysDue+48 )/7)),52)+1;
        Integer numberOfWeekI = math.MOD(Integer.valueof(math.FLOOR( ( numberDaysDue+55 )/7)),52)+1;
        Integer numberOfWeekJ = math.MOD(Integer.valueof(math.FLOOR( ( numberDaysDue+62 )/7)),52)+1;
        Integer numberOfWeekK = math.MOD(Integer.valueof(math.FLOOR( ( numberDaysDue+69 )/7)),52)+1;
        Integer numberOfWeekL = math.MOD(Integer.valueof(math.FLOOR( ( numberDaysDue+76 )/7)),52)+1;
        
        lWeekA = Label.Res_W +' '+  numberOfWeekA.format();
        lWeekB = Label.Res_W +' '+  numberOfWeekB.format();
        lWeekC = Label.Res_W +' '+  numberOfWeekC.format();
        lWeekD = Label.Res_W +' '+  numberOfWeekD.format();
        lWeekE = Label.Res_W +' '+  numberOfWeekE.format();
        lWeekF = Label.Res_W +' '+  numberOfWeekF.format();
        lWeekG = Label.Res_W +' '+  numberOfWeekG.format();
        lWeekH = Label.Res_W +' '+  numberOfWeekH.format();
        lWeekI = Label.Res_W +' '+  numberOfWeekI.format();
        lWeekJ = Label.Res_W +' '+  numberOfWeekJ.format();
        lWeekK = Label.Res_W +' '+  numberOfWeekK.format();
        lWeekL = Label.Res_W +' '+  numberOfWeekL.format()+'+';
        
        List<Resources> reslist = new List<Resources>();
        //Resources resource = new Resources();
        UserList1=new list<User>();
        gId1=new set<id>();
        gMemId=new set<id>();
         totWeekA=0;
         totWeekB=0;
         totWeekC=0;
         totWeekD=0;
         totWeekE=0;
         totWeekF=0;
         totWeekG=0;
         totWeekH=0;
         totWeekI=0;
         totWeekJ=0;
         totWeekK=0;
         totWeekL=0;
         AggregateResult[] tskA;
         AggregateResult[] tskB;
         AggregateResult[] tskC;
         AggregateResult[] tskD;
         AggregateResult[] tskE;
         AggregateResult[] tskF;
         AggregateResult[] tskG;
         AggregateResult[] tskH;
         AggregateResult[] tskI;
         AggregateResult[] tskJ;
         AggregateResult[] tskK;
         AggregateResult[] tskL;
       
        if(selectedStatus<>Null){
            // select for a spceific user group
           
            if(selectedGroup !='All group' && selectedGroup <>null){  
                    GROUP grpId= [SELECT Id,Name FROM Group WHERE Name=:selectedGroup limit 1];                
                    gMemList=[SELECT Id, GroupId, UserOrGroupId FROM GroupMember WHERE GroupId=:grpId.Id limit 1000];
                    for(GroupMember gm:gMemList){                
                        gMemId.add(gm.UserOrGroupId);
                    }
                         
                List<User> UserList1=[SELECT Id, Department, Title,Name, EmployeeNumber, Manager.name FROM User WHERE ID IN:gMemId LIMIT 1000];         
                Map<String,User> maps= new Map<String,User>();
                for(User u:UserList1){
                    maps.put(u.Id,u); 
                 } 
                UserList1=maps.values();
               if(selectedStatus=='Open'){
                    tskA=[Select Sum(Allocated_h__c)tot1,Sum(Outcome_h__c) tot2, ownerId FROM Task 
                          WHERE ownerId IN:gMemId AND ActivityDate >=:sDateA AND ActivityDate<=:eDateA AND Allocated_h__c <> Null And (status='In progress' or status='Not Started')
                          Group by ownerId];
                    tskB=[Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                          WHERE ownerId IN:gMemId AND ActivityDate >=:sDateB AND ActivityDate<=:eDateB AND Allocated_h__c <> Null And (status='In progress' or status='Not Started')
                          Group by ownerId];
                    tskC=[Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                          WHERE ownerId IN:gMemId AND ActivityDate >=:sDateC AND ActivityDate<=:eDateC AND Allocated_h__c <> Null And (status='In progress' or status='Not Started')
                          Group by ownerId];
                    tskD=[Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                          WHERE ownerId IN:gMemId AND ActivityDate >=:sDateD AND ActivityDate<=:eDateD AND Allocated_h__c <> Null And (status='In progress' or status='Not Started')
                          Group by ownerId];
                    tskE=[Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                          WHERE ownerId IN:gMemId AND ActivityDate >=:sDateE AND ActivityDate<=:eDateE AND Allocated_h__c <> Null And (status='In progress' or status='Not Started')
                          Group by ownerId];
                    tskF=[Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                          WHERE ownerId IN:gMemId AND ActivityDate >=:sDateF AND ActivityDate<=:eDateF AND Allocated_h__c <> Null And (status='In progress' or status='Not Started')
                          Group by ownerId];
                    tskG=[Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                          WHERE ownerId IN:gMemId AND ActivityDate >=:sDateG AND ActivityDate<=:eDateG AND Allocated_h__c <> Null And (status='In progress' or status='Not Started')
                          Group by ownerId];
                    tskH=[Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                          WHERE ownerId IN:gMemId AND ActivityDate >=:sDateH AND ActivityDate<=:eDateH AND Allocated_h__c <> Null And (status='In progress' or status='Not Started')
                          Group by ownerId];
                    tskI=[Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                          WHERE ownerId IN:gMemId AND ActivityDate >=:sDateI AND ActivityDate<=:eDateI AND Allocated_h__c <> Null And (status='In progress' or status='Not Started')
                          Group by ownerId]; 
                    tskJ=[Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                          WHERE ownerId IN:gMemId AND ActivityDate >=:sDateJ AND ActivityDate<=:eDateJ AND Allocated_h__c <> Null And (status='In progress' or status='Not Started')
                          Group by ownerId];
                    tskK=[Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                          WHERE ownerId IN:gMemId AND ActivityDate >=:sDateK AND ActivityDate<=:eDateK AND Allocated_h__c <> Null And (status='In progress' or status='Not Started')
                          Group by ownerId];
                    tskL=[Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                          WHERE ownerId IN:gMemId AND ActivityDate >=:sDateL AND ActivityDate<=:eDateL AND Allocated_h__c <> Null And (status='In progress' or status='Not Started')
                          Group by ownerId];    
                }                
                else {
                    tskA=[Select Sum(Allocated_h__c)tot1,Sum(Outcome_h__c) tot2, ownerId FROM Task 
                          WHERE ownerId IN:gMemId AND ActivityDate >=:sDateA AND ActivityDate<=:eDateA AND status=:selectedStatus
                          Group by ownerId];
                    tskB=[Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                          WHERE ownerId IN:gMemId AND ActivityDate >=:sDateB AND ActivityDate<=:eDateB AND status=:selectedStatus
                          Group by ownerId];
                    tskC=[Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                          WHERE ownerId IN:gMemId AND ActivityDate >=:sDateC AND ActivityDate<=:eDateC AND status=:selectedStatus
                          Group by ownerId];
                    tskD=[Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                          WHERE ownerId IN:gMemId AND ActivityDate >=:sDateD AND ActivityDate<=:eDateD AND status=:selectedStatus
                          Group by ownerId];
                    tskE=[Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                          WHERE ownerId IN:gMemId AND ActivityDate >=:sDateE AND ActivityDate<=:eDateE AND status=:selectedStatus
                          Group by ownerId];
                    tskF=[Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                          WHERE ownerId IN:gMemId AND ActivityDate >=:sDateF AND ActivityDate<=:eDateF AND status=:selectedStatus
                          Group by ownerId];
                    tskG=[Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                          WHERE ownerId IN:gMemId AND ActivityDate >=:sDateG AND ActivityDate<=:eDateG AND status=:selectedStatus
                          Group by ownerId];
                    tskH=[Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                          WHERE ownerId IN:gMemId AND ActivityDate >=:sDateH AND ActivityDate<=:eDateH AND status=:selectedStatus
                          Group by ownerId];
                    tskI=[Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                          WHERE ownerId IN:gMemId AND ActivityDate >=:sDateI AND ActivityDate<=:eDateI AND status=:selectedStatus
                          Group by ownerId]; 
                    tskJ=[Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                          WHERE ownerId IN:gMemId AND ActivityDate >=:sDateJ AND ActivityDate<=:eDateJ AND status=:selectedStatus
                          Group by ownerId];
                    tskK=[Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                          WHERE ownerId IN:gMemId AND ActivityDate >=:sDateK AND ActivityDate<=:eDateK AND status=:selectedStatus
                          Group by ownerId];
                    tskL=[Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                          WHERE ownerId IN:gMemId AND ActivityDate >=:sDateL AND ActivityDate<=:eDateL AND status=:selectedStatus
                          Group by ownerId];
                } 
                
                for(User usr:UserList1){                
                    Decimal totalsA=0.0;
                    Decimal totalsB=0.0;
                    Decimal totalsC=0.0;
                    Decimal totalsD=0.0;
                    Decimal totalsE=0.0;
                    Decimal totalsF=0.0;
                    Decimal totalsG=0.0;
                    Decimal totalsH=0.0;
                    Decimal totalsI=0.0;
                    Decimal totalsJ=0.0;
                    Decimal totalsK=0.0;
                    Decimal totalsL=0.0;
                  if(!tskA.isEmpty()){
                        for(AggregateResult ar: tskA){
                            if(ar.get('ownerId')== usr.id){
                                if(selectedStatus=='Completed') {
                                    totalsA = (Decimal)ar.get('tot2');
                                } 
                                else if(selectedStatus=='Not Started') {
                                    totalsA = (Decimal)ar.get('tot1');
                                } 
                                else if(selectedStatus=='In progress'||selectedStatus=='Open') {
                                    totalsA = (Decimal)ar.get('tot1')-(Decimal)ar.get('tot2');
                                } 
                            } 
                        }
                  }
                    if(!tskB.isEmpty()){
                        for(AggregateResult ar: tskB){
                            if(ar.get('ownerId')== usr.id){
                                if(selectedStatus=='Completed') {
                                    totalsB = (Decimal)ar.get('tot2');
                                } 
                                else if(selectedStatus=='Not Started'){
                                    totalsB = (Decimal)ar.get('tot1');
                                } 
                                else if(selectedStatus=='In progress'||selectedStatus=='Open') {
                                    totalsB = (Decimal)ar.get('tot1')-(Decimal)ar.get('tot2');
                                } 
                            } 
                        }
                    }
                    if(!tskC.isEmpty()){
                        for(AggregateResult ar: tskC){
                            if(ar.get('ownerId')== usr.id){
                                if(selectedStatus=='Completed') {
                                    totalsC = (Decimal)ar.get('tot2');
                                } 
                                else if(selectedStatus=='Not Started'){
                                    totalsC = (Decimal)ar.get('tot1');
                                } 
                                else if(selectedStatus=='In progress'||selectedStatus=='Open') {
                                    totalsC = (Decimal)ar.get('tot1')-(Decimal)ar.get('tot2');
                                } 
                            } 
                        }
                    }
                    if(!tskD.isEmpty()){
                        for(AggregateResult ar: tskD){
                            if(ar.get('ownerId')== usr.id){
                                if(selectedStatus=='Completed') {
                                    totalsD = (Decimal)ar.get('tot2');
                                } 
                                else if(selectedStatus=='Not Started') {
                                    totalsD = (Decimal)ar.get('tot1');
                                } 
                                else if(selectedStatus=='In progress'||selectedStatus=='Open') {
                                    totalsD = (Decimal)ar.get('tot1')-(Decimal)ar.get('tot2');
                                } 
                            } 
                        }
                    }
                    if(!tskE.isEmpty()){
                        for(AggregateResult ar: tskE){
                            if(ar.get('ownerId')== usr.id){
                                if(selectedStatus=='Completed') {
                                    totalsE = (Decimal)ar.get('tot2');
                                } 
                                else if(selectedStatus=='Not Started') {
                                    totalsE = (Decimal)ar.get('tot1');
                                } 
                                else if(selectedStatus=='In progress'||selectedStatus=='Open') {
                                    totalsE = (Decimal)ar.get('tot1')-(Decimal)ar.get('tot2');
                                } 
                            } 
                        }
                    }
                    if(!tskF.isEmpty()){
                        for(AggregateResult ar: tskF){
                            if(ar.get('ownerId')== usr.id){
                                if(selectedStatus=='Completed') {
                                    totalsF = (Decimal)ar.get('tot2');
                                } 
                                else if(selectedStatus=='Not Started') {
                                    totalsF = (Decimal)ar.get('tot1');
                                } 
                                else if(selectedStatus=='In progress'||selectedStatus=='Open') {
                                    totalsF = (Decimal)ar.get('tot1')-(Decimal)ar.get('tot2');
                                } 
                            } 
                        }
                    }
                    if(!tskG.isEmpty()){
                        for(AggregateResult ar: tskG){
                            if(ar.get('ownerId')== usr.id){
                                if(selectedStatus=='Completed') {
                                    totalsG = (Decimal)ar.get('tot2');
                                } 
                                else if(selectedStatus=='Not Started') {
                                    totalsG = (Decimal)ar.get('tot1');
                                } 
                                else if(selectedStatus=='In progress'||selectedStatus=='Open') {
                                    totalsG = (Decimal)ar.get('tot1')-(Decimal)ar.get('tot2');
                                } 
                            } 
                        }
                    }
                    if(!tskH.isEmpty()){
                        for(AggregateResult ar: tskH){
                            if(ar.get('ownerId')== usr.id){
                                if(selectedStatus=='Completed') {
                                    totalsH = (Decimal)ar.get('tot2');
                                }
                                else if(selectedStatus=='Not Started') {
                                    totalsH = (Decimal)ar.get('tot1');
                                } 
                                else if(selectedStatus=='In progress'||selectedStatus=='Open') {
                                    totalsH = (Decimal)ar.get('tot1')- (Decimal)ar.get('tot2');
                                } 
                            } 
                        }
                    }    
                    if(!tskI.isEmpty()){
                        for(AggregateResult ar: tskI){
                            if(ar.get('ownerId')== usr.id){
                                if(selectedStatus=='Completed') {
                                    totalsI = (Decimal)ar.get('tot2');
                                } 
                                else if(selectedStatus=='Not Started') {
                                    totalsI = (Decimal)ar.get('tot1');
                                } 
                                else if(selectedStatus=='In progress'||selectedStatus=='Open') {
                                    totalsI = (Decimal)ar.get('tot1')- (Decimal)ar.get('tot2');
                                } 
                            } 
                        }
                    }
                    if(!tskJ.isEmpty()){
                        for(AggregateResult ar: tskJ){
                            if(ar.get('ownerId')== usr.id){
                                if(selectedStatus=='Completed') {
                                    totalsJ = (Decimal)ar.get('tot2');
                                } 
                                else if(selectedStatus=='Not Started') {
                                    totalsJ = (Decimal)ar.get('tot1');
                                } 
                                else if(selectedStatus=='In progress'||selectedStatus=='Open') {
                                    totalsJ = (Decimal)ar.get('tot1')- (Decimal)ar.get('tot2');
                                } 
                            } 
                        }
                    }
                    if(!tskK.isEmpty()){
                        for(AggregateResult ar: tskK){
                            if(ar.get('ownerId')== usr.id){
                                if(selectedStatus=='Completed') {
                                    totalsK = (Decimal)ar.get('tot2');
                                } 
                                else if(selectedStatus=='Not Started') {
                                    totalsK = (Decimal)ar.get('tot1');
                                } 
                                else if(selectedStatus=='In progress'||selectedStatus=='Open') {
                                    totalsK = (Decimal)ar.get('tot1')- (Decimal)ar.get('tot2');
                                } 
                            } 
                        }
                    }
                    if(!tskL.isEmpty()){
                        for(AggregateResult ar: tskL){
                            if(ar.get('ownerId')== usr.id){
                                if(selectedStatus=='Completed') {
                                    totalsL = (Decimal)ar.get('tot2');
                                } 
                                else if(selectedStatus=='Not Started') {
                                    totalsL = (Decimal)ar.get('tot1');
                                } 
                                else if(selectedStatus=='In progress'||selectedStatus=='Open') {
                                    totalsL = (Decimal)ar.get('tot1')- (Decimal)ar.get('tot2');
                                } 
                            } 
                        }
                    }
                
                    totWeekA=totWeekA+totalsA.abs();
                    totWeekB=totWeekB+totalsB.abs();
                    totWeekC=totWeekC+totalsC.abs();
                    totWeekD=totWeekD+totalsD.abs();
                    totWeekE=totWeekE+totalsE.abs();
                    totWeekF=totWeekF+totalsF.abs();
                    totWeekG=totWeekG+totalsG.abs();
                    totWeekH=totWeekH+totalsH.abs();
                    totWeekI=totWeekI+totalsI.abs();
                    totWeekJ=totWeekJ+totalsJ.abs();
                    totWeekK=totWeekK+totalsK.abs();
                    totWeekL=totWeekL+totalsL.abs();

                    totalsA = (totalsA == null) ? 0.0 : totalsA.setscale(1);
                    totalsB = (totalsB == null) ? 0.0 : totalsB.setscale(1);
                    totalsC = (totalsC == null) ? 0.0 : totalsC.setscale(1);
                    totalsD = (totalsD == null) ? 0.0 : totalsD.setscale(1);
                    totalsE = (totalsE == null) ? 0.0 : totalsE.setscale(1);
                    totalsF = (totalsF == null) ? 0.0 : totalsF.setscale(1);
                    totalsG = (totalsG == null) ? 0.0 : totalsG.setscale(1);
                    totalsH = (totalsH == null) ? 0.0 : totalsH.setscale(1);
                    totalsI = (totalsI == null) ? 0.0 : totalsI.setscale(1);
                    totalsJ = (totalsJ == null) ? 0.0 : totalsJ.setscale(1);
                    totalsK = (totalsK == null) ? 0.0 : totalsK.setscale(1);
                    totalsL = (totalsL == null) ? 0.0 : totalsL.setscale(1);
                    Resources resource = new Resources();
                    resource.rUsername = usr.Name;
                    resource.rTitle =  usr.Title;
                    resource.rDepartment = usr.Department;
                    resource.rEmpNr =  usr.EmployeeNumber;
                    resource.rManager = usr.Manager.name;
                    resource.rWeekA = totalsA;
                    resource.rWeekB = totalsB;
                    resource.rWeekC = totalsC;
                    resource.rWeekD = totalsD;
                    resource.rWeekE = totalsE;
                    resource.rWeekF = totalsF;
                    resource.rWeekG = totalsG;
                    resource.rWeekH = totalsH;
                    resource.rWeekI = totalsI;
                    resource.rWeekJ = totalsJ;
                    resource.rWeekK = totalsK;
                    resource.rWeekL = totalsL;
                    reslist.add(resource);  
                }
                return reslist;
             
            }
            else if(selectedGroup=='All group' ||selectedGroup ==null){
                List<task>tsk;
                if(selectedStatus=='Open'){
                    tsk=[SELECT ownerId FROM Task 
                         WHERE  ActivityDate >=:startDat.addDays(-30) 
                         and (Outcome_h__c > 0 or Allocated_h__c > 0 ) 
                         AND (status='In progress' or status='Not Started') Order by ownerId];
                }
                else
                {
                    tsk=[SELECT ownerId FROM Task 
                         WHERE  ActivityDate >=:startDat.addDays(-30) 
                         and (Outcome_h__c > 0 or Allocated_h__c > 0 ) 
                         AND status=:selectedStatus Order by ownerId];
                }   
                set<Id>uid=new set<Id>();
                for(task t:tsk){
                    uid.add(t.ownerId);
                }
                //change to code coverage
                UserList=[SELECT Id, Department, Title,Name, EmployeeNumber, Manager.name FROM User 
                          WHERE ID IN:uid  LIMIT 1000];         
               
                if(selectedStatus=='Open'){
                    
                    tskA = [Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                            WHERE ownerId IN:uid AND ActivityDate >=:sDateA AND ActivityDate<=:eDateA AND Allocated_h__c <> Null And (status='In progress' or status='Not Started')
                            Group by ownerId];
                    tskB = [Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                            WHERE ownerId IN:uid AND ActivityDate >=:sDateB AND ActivityDate<=:eDateB AND Allocated_h__c <> Null And (status=:'In progress' or status=:'Not Started')
                            Group by ownerId];
                    tskC = [Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                            WHERE ownerId IN:uid AND ActivityDate >=:sDateC AND ActivityDate<=:eDateC AND Allocated_h__c <> Null And (status=:'In progress' or status=:'Not Started')
                            Group by ownerId];
                    tskD = [Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                            WHERE ownerId IN:uid AND ActivityDate >=:sDateD AND ActivityDate<=:eDateD AND Allocated_h__c <> Null And (status=:'In progress' or status=:'Not Started')
                            Group by ownerId];
                    tskE = [Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                            WHERE ownerId IN:uid AND ActivityDate >=:sDateE AND ActivityDate<=:eDateE AND Allocated_h__c <> Null And (status=:'In progress' or status=:'Not Started')
                            Group by ownerId];
                    tskF = [Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                            WHERE ownerId IN:uid AND ActivityDate >=:sDateF AND ActivityDate<=:eDateF AND Allocated_h__c <> Null And (status=:'In progress' or status=:'Not Started')
                            Group by ownerId]; 
                    tskG = [Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                            WHERE ownerId IN:uid AND ActivityDate >=:sDateG AND ActivityDate<=:eDateG AND Allocated_h__c <> Null And (status=:'In progress' or status=:'Not Started')
                            Group by ownerId];
                    tskH = [Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                            WHERE ownerId IN:uid AND ActivityDate >=:sDateH AND ActivityDate<=:eDateH AND Allocated_h__c <> Null And (status=:'In progress' or status=:'Not Started')
                            Group by ownerId];
                    tskI = [Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                            WHERE ownerId IN:uid AND ActivityDate >=:sDateI AND ActivityDate<=:eDateI AND Allocated_h__c <> Null And (status=:'In progress' or status=:'Not Started')
                            Group by ownerId];
                    tskJ = [Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                            WHERE ownerId IN:uid AND ActivityDate >=:sDateJ AND ActivityDate<=:eDateJ AND Allocated_h__c <> Null And (status=:'In progress' or status=:'Not Started')
                            Group by ownerId];
                    tskK = [Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                            WHERE ownerId IN:uid AND ActivityDate >=:sDateK AND ActivityDate<=:eDateK AND Allocated_h__c <> Null And (status='In progress' or status=:'Not Started')
                            Group by ownerId];
                    tskL = [Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                            WHERE ownerId IN:uid AND ActivityDate >=:sDateL AND ActivityDate<=:eDateL AND Allocated_h__c <> Null And (status='In progress' or status=:'Not Started')
                            Group by ownerId];
                }
                else{
                    tskA = [Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                            WHERE ownerId IN:uid AND ActivityDate >=:sDateA AND ActivityDate<=:eDateA AND status=:selectedStatus
                            Group by ownerId];
                    tskB = [Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                            WHERE ownerId IN:uid AND ActivityDate >=:sDateB AND ActivityDate<=:eDateB AND status=:selectedStatus
                            Group by ownerId];
                    tskC = [Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                            WHERE ownerId IN:uid AND ActivityDate >=:sDateC AND ActivityDate<=:eDateC AND status=:selectedStatus
                            Group by ownerId];
                    tskD = [Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                            WHERE ownerId IN:uid AND ActivityDate >=:sDateD AND ActivityDate<=:eDateD AND status=:selectedStatus
                            Group by ownerId];
                    tskE = [Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                            WHERE ownerId IN:uid AND ActivityDate >=:sDateE AND ActivityDate<=:eDateE AND status=:selectedStatus
                            Group by ownerId];
                    tskF = [Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                            WHERE ownerId IN:uid AND ActivityDate >=:sDateF AND ActivityDate<=:eDateF AND status=:selectedStatus
                            Group by ownerId]; 
                    tskG = [Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                            WHERE ownerId IN:uid AND ActivityDate >=:sDateG AND ActivityDate<=:eDateG AND status=:selectedStatus
                            Group by ownerId];
                    tskH = [Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                            WHERE ownerId IN:uid AND ActivityDate >=:sDateH AND ActivityDate<=:eDateH AND status=:selectedStatus
                            Group by ownerId];
                    tskI = [Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                            WHERE ownerId IN:uid AND ActivityDate >=:sDateI AND ActivityDate<=:eDateI AND status=:selectedStatus
                            Group by ownerId];
                    tskJ = [Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                            WHERE ownerId IN:uid AND ActivityDate >=:sDateJ AND ActivityDate<=:eDateJ AND status=:selectedStatus
                            Group by ownerId];
                    tskK = [Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                            WHERE ownerId IN:uid AND ActivityDate >=:sDateK AND ActivityDate<=:eDateK AND status=:selectedStatus
                            Group by ownerId];
                    tskL = [Select Sum(Allocated_h__c)  tot1, Sum(Outcome_h__c) tot2, ownerId FROM Task 
                            WHERE ownerId IN:uid AND ActivityDate >=:sDateL AND ActivityDate<=:eDateL AND status=:selectedStatus
                            Group by ownerId];
                }
                for(User usr:UserList){
                    Decimal totalsA=0.0;
                    Decimal totalsB=0.0;
                    Decimal totalsC=0.0;
                    Decimal totalsD=0.0;
                    Decimal totalsE=0.0;
                    Decimal totalsF=0.0;
                    Decimal totalsG=0.0;
                    Decimal totalsH=0.0;
                    Decimal totalsI=0.0;
                    Decimal totalsJ=0.0;
                    Decimal totalsK=0.0;
                    Decimal totalsL=0.0;
            
                    if(!tskA.isEmpty()){
                        for(AggregateResult ar: tskA){
                            
                            if(ar.get('ownerId')== usr.id){
                                if(selectedStatus=='Completed') {
                                    totalsA = (Decimal)ar.get('tot2');
                                } 
                                else if(selectedStatus=='Not Started') {
                                    totalsA = (Decimal)ar.get('tot1');
                                } 
                                else if(selectedStatus=='In progress'||selectedStatus=='Open') {
                                    if(ar.get('tot1')<>null && ar.get('tot2')<>null)
                                    totalsA = (Decimal)ar.get('tot1') -(Decimal)ar.get('tot2');
                                } 
                            } 
                        }
                    }
                   
                    if(!tskB.isEmpty()){
                        for(AggregateResult ar: tskB){
                            if(ar.get('ownerId')== usr.id){
                                if(selectedStatus=='Completed') {
                                    totalsB = (Decimal)ar.get('tot2');
                                } 
                                else if(selectedStatus=='Not Started'){
                                    totalsB = (Decimal)ar.get('tot1');
                                } 
                                else if(selectedStatus=='In progress'||selectedStatus=='Open') {
                                    if(ar.get('tot1')<>null && ar.get('tot2')<>null)
                                    totalsB = (Decimal)ar.get('tot1')-(Decimal)ar.get('tot2');
                                } 
                            } 
                        }
                    }
                    if(!tskC.isEmpty()){
                        for(AggregateResult ar: tskC){
                            if(ar.get('ownerId')== usr.id){
                                if(selectedStatus=='Completed') {
                                    totalsC = (Decimal)ar.get('tot2');
                                } 
                                else if(selectedStatus=='Not Started'){
                                    totalsC = (Decimal)ar.get('tot1');
                                } 
                                else if(selectedStatus=='In progress'||selectedStatus=='Open') {
                                    if(ar.get('tot1')<>null && ar.get('tot2')<>null){
                                        totalsC = (Decimal)ar.get('tot1')-(Decimal)ar.get('tot2');
                                    }
                                } 
                            } 
                        }
                    }
                    if(!tskD.isEmpty()){
                        for(AggregateResult ar: tskD){
                            if(ar.get('ownerId')== usr.id){
                                if(selectedStatus=='Completed') {
                                    totalsD = (Decimal)ar.get('tot2');
                                } 
                                else if(selectedStatus=='Not Started') {
                                    totalsD = (Decimal)ar.get('tot1');
                                } 
                                else if(selectedStatus=='In progress'||selectedStatus=='Open') {
                                  if(ar.get('tot1')<>null && ar.get('tot2')<>null)
                                    totalsD = (Decimal)ar.get('tot1')-(Decimal)ar.get('tot2');
                                } 
                            } 
                        }
                    }
                    if(!tskE.isEmpty()){
                        for(AggregateResult ar: tskE){
                            if(ar.get('ownerId')== usr.id){
                                if(selectedStatus=='Completed') {
                                    totalsE = (Decimal)ar.get('tot2');
                                } 
                                else if(selectedStatus=='Not Started') {
                                    totalsE = (Decimal)ar.get('tot1');
                                } 
                                else if(selectedStatus=='In progress'||selectedStatus=='Open') {
                                    if(ar.get('tot1')<>null && ar.get('tot2')<>null)
                                    totalsE = (Decimal)ar.get('tot1')-(Decimal)ar.get('tot2');
                                } 
                            } 
                        }
                    }
                    if(!tskF.isEmpty()){
                        for(AggregateResult ar: tskF){
                            if(ar.get('ownerId')== usr.id){
                                if(selectedStatus=='Completed') {
                                    totalsF = (Decimal)ar.get('tot2');
                                } 
                                else if(selectedStatus=='Not Started') {
                                    totalsF = (Decimal)ar.get('tot1');
                                } 
                                else if(selectedStatus=='In progress'||selectedStatus=='Open') {
                                    if(ar.get('tot1')<>null && ar.get('tot1')<>null)
                                      totalsF = (Decimal)ar.get('tot1')-(Decimal)ar.get('tot2');
                                } 
                            } 
                        }
                    }
                    if(!tskG.isEmpty()){
                        for(AggregateResult ar: tskG){
                            if(ar.get('ownerId')== usr.id){
                                if(selectedStatus=='Completed') {
                                    totalsG = (Decimal)ar.get('tot2');
                                } 
                                else if(selectedStatus=='Not Started') {
                                    totalsG = (Decimal)ar.get('tot1');
                                } 
                                else if(selectedStatus=='In progress'||selectedStatus=='Open') {
                                    if(ar.get('tot1')<>null && ar.get('tot2')<>null)
                                    totalsG = (Decimal)ar.get('tot1')-(Decimal)ar.get('tot2');
                                } 
                            } 
                        }
                    }
                    if(!tskH.isEmpty()){
                        for(AggregateResult ar: tskH){
                            if(ar.get('ownerId')== usr.id){
                                if(selectedStatus=='Completed') {
                                    totalsH = (Decimal)ar.get('tot2');
                                }
                                else if(selectedStatus=='Not Started') {
                                    totalsH = (Decimal)ar.get('tot1');
                                } 
                                else if(selectedStatus=='In progress'||selectedStatus=='Open') {
                                    if(ar.get('tot1')<>null && ar.get('tot2')<>null)
                                     totalsH = (Decimal)ar.get('tot1')- (Decimal)ar.get('tot2');
                                } 
                            } 
                        }
                    }    
                    if(!tskI.isEmpty()){
                        for(AggregateResult ar: tskI){
                            if(ar.get('ownerId')== usr.id){
                                if(selectedStatus=='Completed') {
                                    totalsI = (Decimal)ar.get('tot2');
                                } 
                                else if(selectedStatus=='Not Started') {
                                    totalsI = (Decimal)ar.get('tot1');
                                } 
                                else if(selectedStatus=='In progress'||selectedStatus=='Open'){
                                    if(ar.get('tot1')<>null && ar.get('tot2')<>null)
                                    totalsI = (Decimal)ar.get('tot1')- (Decimal)ar.get('tot2');
                                } 
                            } 
                        }
                    }
                    if(!tskJ.isEmpty()){
                        for(AggregateResult ar: tskJ){
                            if(ar.get('ownerId')== usr.id){
                                if(selectedStatus=='Completed') {
                                    totalsJ = (Decimal)ar.get('tot2');
                                } 
                                else if(selectedStatus=='Not Started') {
                                    totalsJ = (Decimal)ar.get('tot1');
                                } 
                                else if(selectedStatus=='In progress'||selectedStatus=='Open') {
                                    totalsJ = (Decimal)ar.get('tot1')- (Decimal)ar.get('tot2');
                                } 
                            } 
                        }
                    }
                    if(!tskK.isEmpty()){
                        for(AggregateResult ar: tskK){
                            if(ar.get('ownerId')== usr.id){
                                if(selectedStatus=='Completed') {
                                    totalsK = (Decimal)ar.get('tot2');
                                } 
                                else if(selectedStatus=='Not Started') {
                                    totalsK = (Decimal)ar.get('tot1');
                                } 
                                else if(selectedStatus=='In progress'||selectedStatus=='Open') {
                                    if(ar.get('tot1')<>null && ar.get('tot2')<>null)
                                    totalsK = (Decimal)ar.get('tot1')- (Decimal)ar.get('tot2');
                                } 
                            } 
                        }
                    }
                    if(!tskL.isEmpty()){
                        for(AggregateResult ar: tskL){
                            if(ar.get('ownerId')== usr.id){
                                if(selectedStatus=='Completed') {
                                    totalsL = (Decimal)ar.get('tot2');
                                } 
                                else if(selectedStatus=='Not Started') {
                                    totalsL = (Decimal)ar.get('tot1');
                                } 
                                else if(selectedStatus=='In progress'||selectedStatus=='Open') {
                                    if(ar.get('tot1')<>null && ar.get('tot2')<>null)
                                       totalsL = (Decimal)ar.get('tot1')- (Decimal)ar.get('tot2');
                                } 
                            } 
                        }
                    } 
                  if(totalsA<>null ||totalsB<>null ||totalsC<>null ||totalsD<>null ||totalsE<>null ||totalsF<>null ||
                      totalsG<>null ||totalsH<>null||totalsI<>null||totalsJ<>null||totalsK<>null||totalsL<>null){
                    totWeekA=totWeekA+totalsA.abs();
                    if(totalsB<>null){
                        totWeekB=totWeekB+totalsB.abs();  
                    }
                    if(totalsC<>null){                  
                      totWeekC=totWeekC+totalsC.abs();
                    }
                    if(totalsD<>null){
                        totWeekD=totWeekD+totalsD.abs();
                    }
                    if(totalsE<>null){
                     totWeekE=totWeekE+totalsE.abs();
                    }
                    if(totalsF<>null){
                        totWeekF=totWeekF+totalsF.abs();
                    }
                    if(totalsG<>null){
                     totWeekG=totWeekG+totalsG.abs();
                    }
                    if(totalsH<>null){
                        totWeekH=totWeekH+totalsH.abs();
                    }
                    if(totalsI<>null){
                        totWeekI=totWeekI+totalsI.abs();
                    }
                    if(totalsJ<>null){
                     totWeekJ=totWeekJ+totalsJ.abs();
                    }
                    if(totalsK<>null){
                        totWeekK=totWeekK+totalsK.abs(); 
                    } 
                    if(totalsL<>null){     
                        totWeekL=totWeekL+totalsL.abs();
                    }
                    totalsA = (totalsA == null) ? 0.0 : totalsA.setscale(1);
                    totalsB = (totalsB == null) ? 0.0 : totalsB.setscale(1);
                    totalsC = (totalsC == null) ? 0.0 : totalsC.setscale(1);
                    totalsD = (totalsD == null) ? 0.0 : totalsD.setscale(1);
                    totalsE = (totalsE == null) ? 0.0 : totalsE.setscale(1);
                    totalsF = (totalsF == null) ? 0.0 : totalsF.setscale(1);
                    totalsG = (totalsG == null) ? 0.0 : totalsG.setscale(1);
                    totalsH = (totalsH == null) ? 0.0 : totalsH.setscale(1);
                    totalsI = (totalsI == null) ? 0.0 : totalsI.setscale(1);
                    totalsJ = (totalsJ == null) ? 0.0 : totalsJ.setscale(1);
                    totalsK = (totalsK == null) ? 0.0 : totalsK.setscale(1);
                    totalsL = (totalsL == null) ? 0.0 : totalsL.setscale(1);
                    Resources resource = new Resources();
                    resource.rUsername = usr.Name;
                    resource.rTitle =  usr.Title;
                    resource.rDepartment = usr.Department;
                    resource.rEmpNr =  usr.EmployeeNumber;
                    resource.rManager = usr.Manager.name;
                    resource.rWeekA = totalsA.abs();
                    resource.rWeekB = totalsB;
                    resource.rWeekC = totalsC;
                    resource.rWeekD = totalsD;
                    resource.rWeekE = totalsE;
                    resource.rWeekF = totalsF;
                    resource.rWeekG = totalsG;
                    resource.rWeekH = totalsH;
                    resource.rWeekI = totalsI;
                    resource.rWeekJ = totalsJ;
                    resource.rWeekK = totalsK;
                    resource.rWeekL = totalsL;                 
                    reslist.add(resource);
                   }
                }
            }  
        }
        
        return reslist;  
    }    
}