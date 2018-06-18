trigger BFM_MiroUpdate on BFM_MIRO_Header__c (After update, Before update, After insert, Before insert, Before delete, After delete) {
    
    if(!BFM_TriggerHelper.isTriggerEnabled()){ 
        return ; 
    }
    
    BFM_TriggerFactory.createhandler(BFM_MIRO_Header__c.sObjectType);  
}