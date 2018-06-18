trigger BFM_STAGEvalidation on BFM_Stage__c (before insert, before update, after insert,after update) {
    
    if(!BFM_TriggerHelper.isTriggerEnabled()){ 
        return ; 
    }
    
    BFM_TriggerFactory.createhandler(BFM_Stage__c.sObjectType);  
}