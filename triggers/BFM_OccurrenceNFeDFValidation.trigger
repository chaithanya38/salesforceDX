trigger BFM_OccurrenceNFeDFValidation on BFM_Occurrence_NF_e_DF__c (after insert, after update, after delete) {
    
    if(!BFM_TriggerHelper.isTriggerEnabled()){ 
        return ;  
    }
     
    BFM_TriggerFactory.createhandler(BFM_Occurrence_NF_e_DF__c.sObjectType);  
}