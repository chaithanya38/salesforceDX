trigger BFM_SESCTEValidation on BFM_SES_CT_e__c (after insert, after update, after delete, before update) {
    
    if(!BFM_TriggerHelper.isTriggerEnabled()) { 
        return ; 
    } 
    
    BFM_TriggerFactory.createhandler(BFM_SES_CT_e__c.sObjectType);  
    
}