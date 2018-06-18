trigger BFM_CTEvalidation on BFM_CT_e__c (before insert, before update, after insert, after update, after delete) {
    
    if(!BFM_TriggerHelper.isTriggerEnabled()) { 
        return ; 
    } 
    
   BFM_TriggerFactory.createhandler(BFM_CT_e__c.sObjectType);  
}