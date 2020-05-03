/**************************************************************************************************************************************************
Name: workspacecreation for plan object
Author: chaithanya daggumati    Last modified by:Raju Gn
Date: 06/7/2014                 Date:20/10/2015 
Dec:Add PlanMember object
********©2013 Musqot marketing technology Pvt ltd ****************/
trigger overview_creation on Project__c(After Insert,After update,before delete,before insert,before update){
    If(Trigger.isAfter){
        List<Workspace__c> WspcList = New List<Workspace__c>();
        List<Members__c> Memberslist = New List<Members__c>();
        List<Budget__c> Budgetlist = New List<Budget__c>();
        List<Members__c> MemberslistUpt = New List<Members__c>();
        List<Musqot_member__c>planMemberslist = New List<Musqot_member__c>();
        List<Musqot_member__c>planMemberslistUpt= New List<Musqot_member__c>();
        Set<string>planSpanYears=new set<string>();
        list<user> userlist=new list<user>();
        set<Id>planOwnerId=new set<Id>();
        
        For(Project__c p: Trigger.New){
            planOwnerId.add(p.OwnerId);
        }
        user u=[SELECT Name from user where id=:planOwnerId];
        String PlanOwnerName=u.name;
        If(Trigger.isInsert)
        {
            For(Project__c   Item: Trigger.New){
                
                /*** workspace object record creation ****/
                Workspace__c Wsp = New Workspace__c(); 
                wsp.name = item.name;
                wsp.ProjectName__c= item.id;
                wsp.description__C = item.description__C;
                WspcList.add(wsp);
                
                /*** Members object record  creation ****/
                Members__c Mem    = New Members__c();
                Mem.ProjUsers__c  = item.ownerid;
                Mem.ProjMembers__c = item.id;
                Mem.Role__c = 'Owner';
                Memberslist.add(Mem);
                
                /***PlanMembers object record  creation ****/
                Musqot_member__c plnMem= new Musqot_member__c();
                plnMem.Plan__c=item.id;
                plnMem.Name=PlanOwnerName;
                plnMem.userid__c=item.ownerid;
                plnMem.Role__c='';
                planMemberslist.add(plnMem);
         
            } 
        } 
        //
        list<Budget__c>deletExitsBudgets=new  list<Budget__c>();
        set<Id>budgetFsIds=new set<Id>();
        list<FiscalYearSettings>queryResult=new list<FiscalYearSettings>();
        If(Trigger.isInsert || Trigger.isupdate)
        {
            For(Project__c   Item: Trigger.New){
                for(integer i=item.Starts_date__c.year();i<=item.Ends_date__c.year();i++){
                    integer curntYear=system.today().year();
                    if(i>=curntYear){
                        planSpanYears.add(string.valueof(i));
                    } 
                }
                list<Budget__c> blist=[SELECT ID,FiscalYear__c,Approved__c  FROM Budget__c where 
                                       Project__c=:item.Id limit 10];                          
                for(Budget__c b:blist){
                    if(b.Approved__c==false)
                        deletExitsBudgets.add(b);
                    else
                        budgetFsIds.add(b.FiscalYear__c);
                }
                
                if(budgetFsIds<>null){
                    queryResult= [SELECT Id, Name 
                                  FROM FiscalYearSettings WHERE id NOT IN:budgetFsIds AND  Name IN:planSpanYears 
                                  order by SystemModstamp limit 10];
                    
                }else{
                    queryResult= [SELECT Id, Name 
                                  FROM FiscalYearSettings WHERE Name IN:planSpanYears 
                                  order by SystemModstamp limit 10];
                }
                for(FiscalYearSettings f:queryResult){
                    Budget__c bud = new Budget__c();
                    bud.Project__c = item.id;
                    bud.Name = item.name;
                    bud.FiscalYear__c=f.Id;
                    bud.OwnerId =item.OwnerId ;
                    Budgetlist.add(bud); 
                }
            } 
        } 
        
        try
        {  
            if(deletExitsBudgets.size()>0){
                delete deletExitsBudgets;
            }
            if((WspcList.size()>0))
            {
                DataBase.Insert(WspcList,false);
            }
            if(Memberslist.size()>0)
            {
                DataBase.Insert(Memberslist,false);
            }
            if(planMemberslist.size()>0)
            {
                DataBase.Insert(planMemberslist,false);
            }
            if(Budgetlist.size()>0)
            {
                DataBase.Insert(Budgetlist,false);
            }
        }
        catch (Exception err)         
        {
            System.debug('error is'+ err);
        }   
        
        If(Trigger.isupdate && trigger.isAfter){
            Map<Id,Members__c> mbrMap = new Map<Id,Members__c>();  
            Map<Id,Members__c> mbrMapUsr = new Map<Id,Members__c>();  
            // List<Milestone__c> milemap=[select Id,Name,Plan__c,Targetdate__c,Project__c,Status__c,Description__c, Target_Marketing_activity__c, Target_Marketing_activity__r.Name, Target_Project__c, Target_Project__r.Name, Milestone_type__c from Milestone__c limit 200];
            List<Members__c> delMbrs = new List<Members__c>();   
            Set<ID> mbrSet = new Set<ID>();
            For(Project__c   Item1: [select id,ownerid,musqot__Status__c, (select Id,Role__c,ProjUsers__c from Members__r) 
                                     from Project__c where id in :Trigger.oldMap.keySet()]){
                                         for(Members__c m : item1.Members__r){
                                             mbrMap.put(m.Id,m);    
                                             mbrSet.add(m.ProjUsers__c);
                                             mbrMapUsr.put(m.ProjUsers__c,m);
                                         }
                                     }
            
            Set<Id> accountIds = new Set<Id>(); 
            Map<Id, String> oldOwnerIds = new Map<Id, String>();
            Map<Id, String> newOwnerIds = new Map<Id, String>();
            Members__c[] contactUpdates = new Members__c[0]; 
            
            for (Project__c a : Trigger.new) 
            { 
                if (a.OwnerId != Trigger.oldMap.get(a.Id).OwnerId) 
                {
                    oldOwnerIds.put(a.Id, Trigger.oldMap.get(a.Id).OwnerId); 
                    newOwnerIds.put(a.Id, a.OwnerId); 
                    accountIds.add(a.Id); 
                }
            }
            
            if (!accountIds.isEmpty()){ 
                For(Project__c Item1: [select id,ownerid,(select Id,Role__c,ProjUsers__c from Members__r) 
                                       from Project__c where id in :accountIds]){
                                           
                                           String newOwnerId = newOwnerIds.get(Item1.Id); 
                                           String oldOwnerId = oldOwnerIds.get(Item1.Id); 
                                           
                                           system.debug('===Members=='+item1.Members__r.size());                       
                                           /**Members object record  updation****/
                                           
                                           
                                           for(Members__c mbr : item1.Members__r){
                                               
                                               if(newOwnerId<>oldOwnerId&&Memberslist.size()==0){
                                                   system.debug('===User Exists==');                          
                                                   Members__c Mem2    = New Members__c();
                                                   Mem2.ProjUsers__c  = item1.ownerid;
                                                   Mem2.ProjMembers__c = item1.id;
                                                   Mem2.Role__c = 'Owner';
                                                   Memberslist.add(Mem2);    
                                               }
                                               if(mbrMap.containsKey(mbr.Id)&&(mbrMap.get(mbr.Id).Role__c=='Owner') && item1.ownerid<>mbrMap.get(mbr.Id).ProjUsers__c){
                                                   mbr.Role__c = 'Member';                       
                                                   MemberslistUpt.add(mbr);
                                                   
                                               }
                                               else if(mbrMap.containsKey(mbr.Id)&&(mbrMap.get(mbr.Id).Role__c=='Member') && item1.ownerid==mbrMap.get(mbr.Id).ProjUsers__c){
                                                   //system.debug('===Member Change==');                          
                                                   mbr.Role__c = 'Owner';                 
                                                   delMbrs.add(mbrMap.get(mbr.Id));
                                               }
                                           }
                                           
                                       }
                if(delMbrs.size()>0){
                    delete delMbrs;
                }
                
            }
        }
        if((Memberslist.size()>0)){
            Try{    
                DataBase.insert(Memberslist);
                DataBase.insert(planMemberslist);
            }
            Catch (Exception err){
                System.debug('error is'+ err);
            }
        }
        
        if((MemberslistUpt.size()>0)){
            Try{         
                DataBase.update(MemberslistUpt);
            }
            Catch (Exception err){
                System.debug('error is'+ err);
            }
        }
    }
    if(trigger.isDelete){
        Set<ID> setids= New Set<ID>();
        List<Subproject__c> listsub = [Select Parent_project__c,Project_del__c,Description__c 
                                       From Subproject__c Where Parent_project__c  IN:trigger.oldMap.KeySet()];
        for(Subproject__c subpro : listsub)
        {
            setids.add(subpro.Parent_project__c);
        }
        For(Project__c p : trigger.old){
            
            If(setids.contains(p.ID))
                p.addError('The record cannot be deleted because there it has child record ');
        }
    }    
    if(trigger.isBefore&&trigger.isUpdate){
        MAP<id,Musqot_member__c >planMemberMap=new MAP<id,Musqot_member__c >();
        Map<String,Document> docMap = new Map<String,Document>();
        List<Document> docList = [select Id,Name from Document Limit 1000];
        string plnId;
        //--Raju to add validation rule to change owner of the plan---
        for(Project__c pr : trigger.new){
            plnId=pr.Id;
        }
        LIST<Musqot_member__c>planMemberList = [Select id,userid__c,Plan__r.ownerid,Role__c 
                                                FROM Musqot_member__c 
                                                where Plan__c=:plnId ORDER BY Name];  
        
        for(Musqot_member__c m:planMemberList ){
            planMemberMap.put(m.userid__c,m);
            
        }    
        /*for(Project__c pr : trigger.new){
if(planMemberMap.containsKey(pr.ownerid)==false){
pr.addError('The selected user not in the  Planmembers');
}
}*/
    }      
    //--End here---
    if(trigger.isBefore&&(trigger.isInsert||trigger.isUpdate)){
        Map<String,Document> docMap = new Map<String,Document>();
        List<Document> docList = [select Id,Name from Document Limit 1000];
        for(Document doc : docList){       
            docMap.put(doc.Name,doc);
        } 
        for(Project__c pr : trigger.new){  
            String sts = pr.Status__c;
            if(sts<>null){
                if(docMap.containskey((sts).trim())){ 
                    pr.Status_Image_Id__c = docMap.get(sts).Id;                  
                } 
            }
        }
    }  
}