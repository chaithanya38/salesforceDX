trigger BFM_MIROItemTrigger on BFM_MIRO_Item__c (before insert, after insert, before update, after update) {
    
    if(!BFM_TriggerHelper.isTriggerEnabled()) { 
        return ; 
    }
    
    BFM_TriggerFactory.createhandler(BFM_MIRO_Item__c.sObjectType);  
}