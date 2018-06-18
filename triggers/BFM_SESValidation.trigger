trigger BFM_SESValidation on BFM_SES__c (before insert, before update, before delete, after insert, after update, after delete) {
    
    if(!BFM_TriggerHelper.isTriggerEnabled()){ 
        return ; 
    }
    
    BFM_TriggerFactory.createhandler(BFM_SES__c.sObjectType);  
}