/**************************************************************************************************************************************************
Name: workspacecreation for marketing object.
Copyright © 2014 Musqot Marketin Solutions | Salesforce Instance : Developer Org

Purpose: This trigger is when ever parent is created automatically child objects records are Created                                                  

History:                                                        
-----------------------------------------------------------------------------------------------------------
AUTHOR                DATE       DETAIL                                                       
-----------------------------------------------------------------------------------------------------------
G janardhanredy       20/6/2014    Initial Developer                                 

**************************************************************************************************************************************************/
trigger overview_creationsub on Subproject__c(After Insert,before insert,before update, after update){
    
    
    If(Trigger.isAfter){
        List<Workspace__c> WspcList = New List<Workspace__c>();
        List<Members__c> Memberslist = New List<Members__c>();
        List<Budget__c> budgetlist = new List<Budget__c>();
        List<Members__c> MemberslistUpt = New List<Members__c>();
        list<user> userlist=new list<user>();
        If(Trigger.isInsert){
            For(Subproject__c sub: Trigger.New){
                /*** workspace object record creation****/
                Workspace__c Wsp = New Workspace__c(); 
                wsp.name = sub.name;
                wsp.subproject__c= sub.id;
                wsp.description__C = sub.Description__c;
                WspcList.add(wsp);
                /*** Members object record  creation ****/
                Members__c Mem    = New Members__c();
                Mem.ProjUsers__c  = sub.ownerid;
                Mem.SubProjMembers__c = sub.Id;
                Mem.Role__c = 'Owner';
                Memberslist.add(Mem);
                /***  budget  object record  creation***/
                Budget__c bud=new Budget__c();
                bud.Name=sub.name;
                bud.Project__c=sub.Parent_project__c; 
                bud.subproject__c=sub.id;
                bud.OwnerId =sub.OwnerId ;
                budgetlist.add(bud);
            }
        }
        try{  
            if((WspcList.size()>0))
            {
                DataBase.Insert(WspcList,false);
            }
            if(Memberslist.size()>0)
            {
                DataBase.Insert(Memberslist,false);
            }
            if(Budgetlist.size()>0)
            {
                DataBase.Insert(budgetlist,false);
            }
        }
        catch (Exception err){
            System.debug('error is'+ err);
        }   
        
        
        /*****Member Creation/Updation ****/
        
        
        If(Trigger.isupdate && trigger.isAfter){
            Map<Id,Members__c> mbrMap = new Map<Id,Members__c>();  
            Map<Id,Members__c> mbrMapUsr = new Map<Id,Members__c>(); 
            List<Members__c> delMbrs = new List<Members__c>();   
            Set<ID> mbrSet = new Set<ID>();
            For(Subproject__c  Item1: [select id,Status__c,ownerid,(select Id,Role__c,ProjUsers__c from Members__r) from Subproject__c  where id in :Trigger.oldMap.keySet()]){
                
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
            
            for(Subproject__c a : Trigger.new){ 
                if (a.OwnerId != Trigger.oldMap.get(a.Id).OwnerId){
                    oldOwnerIds.put(a.Id, Trigger.oldMap.get(a.Id).OwnerId); 
                    newOwnerIds.put(a.Id, a.OwnerId); 
                    accountIds.add(a.Id); 
                }
            }
            if(!accountIds.isEmpty()) { 
                For(Subproject__c Item1: [select id,ownerid,(select Id,Role__c,ProjUsers__c from Members__r) from Subproject__c where id in :accountIds]){
                    
                    String newOwnerId = newOwnerIds.get(Item1.Id); 
                    String oldOwnerId = oldOwnerIds.get(Item1.Id); 
                    
                    system.debug('===Members=='+item1.Members__r.size());                       
                    /**Members object record  updation****/
                    
                    
                    for(Members__c mbr : item1.Members__r){
                        /* 
if(!mbrMap.containsKey(mbr.ProjUsers__c)&&Memberslist.size()==0){  

Members__c Mem2    = New Members__c();
Mem2.ProjUsers__c  = item1.ownerid;
Mem2.ProjMembers__c = item1.id;
Mem2.Role__c = 'Owner';
Memberslist.add(Mem2);
}
*/  
                        
                        if(newOwnerId <> oldOwnerId && Memberslist.size()==0){
                            system.debug('===User Exists==');                          
                            Members__c Mem2    = New Members__c();
                            Mem2.ProjUsers__c  = item1.ownerid;
                            Mem2.SubProjMembers__c = item1.id;
                            Mem2.Role__c = 'Owner';
                            Memberslist.add(Mem2);    
                        }
                        if(mbrMap.containsKey(mbr.Id)&&(mbrMap.get(mbr.Id).Role__c=='Owner') && item1.ownerid<>mbrMap.get(mbr.Id).ProjUsers__c){
                            system.debug('===Owner Change=='); 
                                                    
                            mbr.Role__c = 'Member';                       
                            MemberslistUpt.add(mbr);    
                            
                        }
                        
                        else if(mbrMap.containsKey(mbr.Id)&&(mbrMap.get(mbr.Id).Role__c=='Member') && item1.ownerid==mbrMap.get(mbr.Id).ProjUsers__c){
                            //system.debug('===Member Change==');                          
                            mbr.Role__c = 'Owner';
                            //MemberslistUpt.add(mbr);                         
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
    /*****End of Member *****/
    
    if(trigger.isBefore){
        Map<Id,Subproject__c> prjMap = new Map<Id,Subproject__c>();
        for(Subproject__c sp : [select Id,Project_del__c,Name,Parent_project__c from Subproject__c Limit 40000]){// where Id In :trigger.old])
            prjMap.put(sp.Id,sp);  
        }
        
        for(Subproject__c s : trigger.new){
            system.debug('******Parent***'+s.Project_del__c);
            if(s.Project_del__c<>null){
                if(prjMap.get(s.Project_del__c).Parent_project__c<>null){
                    system.debug('======='+prjMap.get(s.Project_del__c).Parent_project__c);
                    s.Parent_project__c = prjMap.get(s.Project_del__c).Parent_project__c;
                }
            }
        }
        
        
        if(trigger.isInsert||trigger.isUpdate){    
            Map<String,Document> docMap = new Map<String,Document>();
            List<Document> docList = [select Id,Name from Document Limit 1000];
            
            for(Document doc : docList){       
                docMap.put(doc.Name,doc);
            } 
            for(Subproject__c pr : trigger.new){  
                String sts = pr.Status__c;
                if(sts<>null){
                    if(docMap.containskey((sts).trim())){ 
                        pr.Status_Image_Id__c = docMap.get(sts).Id;                  
                    } 
                }
            }
        }
    }
    
    
}