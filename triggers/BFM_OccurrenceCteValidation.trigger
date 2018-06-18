trigger BFM_OccurrenceCteValidation on BFM_Occurrence_CT_e__c (after insert, after update, after delete) {
    
    if(!BFM_TriggerHelper.isTriggerEnabled()) { 
        return ; 
    } 
    
    BFM_TriggerFactory.createhandler(BFM_Occurrence_CT_e__c.sObjectType);  

}