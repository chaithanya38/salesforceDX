trigger BFM_DeliveryValidation on BFM_Delivery__c (before insert, before update, after insert, after update) {
    
    if(!BFM_TriggerHelper.isTriggerEnabled()){ 
        return ; 
    } 
    
    BFM_TriggerFactory.createhandler(BFM_Delivery__c.sObjectType);  

}