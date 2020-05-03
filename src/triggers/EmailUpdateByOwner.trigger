/*******************************************************
Trigger Name: EmailUpdateByOwner 
Author:G Janardhanreddy         Last modified by: Chaithanya daggumati
Date: 18/6/2014                 Date: 19/3/2015 
********©2013 Musqot marketing technology Pvt ltd *******/

trigger EmailUpdateByOwner on Members__c (before insert , before update){
    
    Set<ID> Ownerids= new Set<ID>();
    
    for(Members__c mem : trigger.new){
        if(mem.ProjUsers__c!= null)Ownerids.add(mem.ProjUsers__c);
    }
    MAP<ID , User> ownerMap = new MAP<ID , User>([Select Id,Email,Phone from User where id in: Ownerids]);
    
    If(Trigger.IsBefore){
        If(Trigger.IsInsert){
            for(Members__c mem : trigger.new){
                if(mem.ProjUsers__c!= null)
                {
                    User Us = ownerMap.get(mem.ProjUsers__c);
                    mem.User_Email__c = Us.Email;
                    //Similarly you can assign Address fields as well, just add those field in Contact SOQL as well
                }
            }
            
            
        }
    }
    If(Trigger.IsBefore){
        If(Trigger.IsUpdate){
            for(Members__c mem : trigger.new){
                if(mem.ProjUsers__c!= null)
                {
                    User Us = ownerMap.get(mem.ProjUsers__c);
                    mem.User_Email__c = Us.Email;
                    //Similarly you can assign Address fields as well, just add those field in Contact SOQL as well
                }
            }
        }
    }
    
    
   /* Map<Id, Members__c  > memUserMap = new Map<Id, Members__c  >();
    Set<Id> Plans = new Set<Id>();
    for (Members__c  memUser : System.Trigger.new) {
        if ((memUser.ProjUsers__c != null) && (System.Trigger.isInsert ||
                                               (memUser .ProjUsers__c != System.Trigger.oldMap.get(memUser .Id).ProjUsers__c ))) {
                                                   Plans.add(memUser.ProjMembers__c);
                                                   memUserMap.put(memUser.ProjUsers__c , memUser );
                                                   
                                               }
    }
    for (Members__c memUser : [SELECT ProjUsers__c FROM Members__c WHERE ProjMembers__c IN :Plans]) {
        Members__c newMemUser = memUserMap.get(memUser.ProjUsers__c );
        if(newMemUser!=null){
            newMemUser .ProjUsers__c .addError('This User already exists.');}
    }
    
     Map<Id, Members__c  > memUserMap1 = new Map<Id, Members__c  >();
    Set<Id> Projects = new Set<Id>();
    for (Members__c  memUser : System.Trigger.new) {
        if ((memUser.musqot__SubProjMembers__c!= null) && (System.Trigger.isInsert ||
                                               (memUser .ProjUsers__c != System.Trigger.oldMap.get(memUser .Id).ProjUsers__c ))) {
                                                   Projects.add(memUser.musqot__SubProjMembers__c);
                                                   memUserMap1.put(memUser.ProjUsers__c , memUser );
                                                   
                                               }
    }
    for (Members__c memUser : [SELECT ProjUsers__c FROM Members__c WHERE musqot__SubProjMembers__c IN :projects]) {
        Members__c newMemUser = memUserMap1.get(memUser.ProjUsers__c );
        if(newMemUser!=null){
            newMemUser .ProjUsers__c .addError('This User already exists.');}
    }*/
    
}