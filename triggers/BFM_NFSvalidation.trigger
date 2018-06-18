trigger BFM_NFSvalidation on BFM_NFS__c (before insert, before update, After Insert, After update, After delete) {
    
    if(!BFM_TriggerHelper.isTriggerEnabled()) { 
        return ; 
    } 
    
    BFM_TriggerFactory.createhandler(BFM_NFS__c.sObjectType);  
    
}