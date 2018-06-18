trigger BFM_SESNFeDFValidation on BFM_SES_NF_e_DF__c (after insert, after update, after delete) {
    
    if(!BFM_TriggerHelper.isTriggerEnabled()){ 
        return ; 
    }
    
    BFM_TriggerFactory.createhandler(BFM_SES_NF_e_DF__c.sObjectType);  
}