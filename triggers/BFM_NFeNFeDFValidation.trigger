trigger BFM_NFeNFeDFValidation on BFM_NF_e_NF_e_DF__c (after insert, after update, after delete) {
    
    if(!BFM_TriggerHelper.isTriggerEnabled()){ 
        return ; 
    }
     
    BFM_TriggerFactory.createhandler(BFM_NF_e_NF_e_DF__c.sObjectType);  
}