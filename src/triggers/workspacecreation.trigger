/*******************************************************
Class Name: workspacecreation 
Author:G Janardhanreddy               Last modified by: Chaithanya Daggumati 
Date: 30/6/2014                       Date: 19/3/2015  
********©2013 Musqot marketing technology Pvt ltd *******/

trigger workspacecreation on Marketing_activity__c (After Insert,before insert,before update, after update) 
{
    If(Trigger.isAfter)
    {
        List<Workspace__c> WspcList = New List<Workspace__c>();
        List<Members__c> Memberslist = New List<Members__c>();
        List<Members__c> MemberslistUpt = New List<Members__c>();
        If(Trigger.isInsert)
        {
            For(Marketing_activity__c mark: Trigger.New)
            {
                /*** workspace object record  creation ****/
                Workspace__c Wsp = New Workspace__c(); 
                wsp.name = mark.name;
                wsp.Marketing_activity__c= mark.id;
                wsp.description__C = mark.Description__c;
                WspcList.add(wsp);
                /*** Members object record creation ****/
                Members__c Mem    = New Members__c();
                Mem.ProjUsers__c  = mark.ownerid;
                Mem.Role__c = 'Owner';
                Mem.Marketingmebers__c = mark.Id;
                Memberslist.add(Mem);
                
            }
        }
        if((WspcList.size()>0)&&(Memberslist.size()>0)){
            Try{
                DataBase.Insert(WspcList);
                DataBase.Insert(Memberslist);
            }
            Catch (Exception err) {
                System.debug('error is'+ err);
            }
            
            
            
        }
        
        
        /****** Members on Update ******/
        
        
        If(Trigger.isupdate && trigger.isAfter){
            Map<Id,Members__c> mbrMap = new Map<Id,Members__c>();  
            Map<Id,Members__c> mbrMapUsr = new Map<Id,Members__c>();  
            List<Members__c> delMbrs = new List<Members__c>(); 
            Set<ID> mbrSet = new Set<ID>();
            For(Marketing_activity__c Item1: [select id,ownerid,musqot__Status__c,(select Id,Role__c,ProjUsers__c from Members__r) from Marketing_activity__c where id in :Trigger.oldMap.keySet()]){
                
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
            
            for (Marketing_activity__c a : Trigger.new) 
            { 
                if (a.OwnerId != Trigger.oldMap.get(a.Id).OwnerId) 
                {
                    oldOwnerIds.put(a.Id, Trigger.oldMap.get(a.Id).OwnerId); 
                    newOwnerIds.put(a.Id, a.OwnerId); 
                    accountIds.add(a.Id); 
                }
            }
            if (!accountIds.isEmpty()) { 
                For(Marketing_activity__c Item1: [select id,ownerid,(select Id,Role__c,ProjUsers__c from Members__r) from Marketing_activity__c where id in :accountIds]){
                    
                    String newOwnerId = newOwnerIds.get(Item1.Id); 
                    String oldOwnerId = oldOwnerIds.get(Item1.Id);                     
                    /**Members object record  updation****/
                    
                    
                    for(Members__c mbr : item1.Members__r){
                
                        if(newOwnerId<>oldOwnerId&&Memberslist.size()==0){                         
                            Members__c Mem2    = New Members__c();
                            Mem2.ProjUsers__c  = item1.ownerid;
                            Mem2.Marketingmebers__c = item1.id;
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
        
        /****** End of Members****/
        
    }
    if(trigger.isBefore&&(trigger.isInsert||trigger.isUpdate)){
        Map<String,Document> docMap = new Map<String,Document>();
        List<Document> docList = [select Id,Name from Document Limit 1000];
        
        for(Document doc : docList){       
            docMap.put(doc.Name,doc);
        } 
        for(Marketing_activity__c ma : trigger.new){  
            String sts = ma.Status__c;
            if(sts<>null){
                if(docMap.containskey((sts).trim())){ 
                    ma.Status_Image_Id__c = docMap.get(sts).Id;                  
                }
            } 
        }
    }
}