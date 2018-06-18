trigger BFM_CCEvalidation on BFM_CC_e__c (before insert, before update, after insert, after update, after delete) {
     
    if(!BFM_TriggerHelper.isTriggerEnabled()) { 
        return ; 
    } 
    
    BFM_TriggerFactory.createhandler(BFM_CC_e__c.sObjectType);  
}