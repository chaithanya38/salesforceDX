trigger BFM_OccurrenceNFSValidation on BFM_Occurrence_NFS__c (after insert, after update, after delete) {

    if(!BFM_TriggerHelper.isTriggerEnabled()) { 
        return ; 
    } 
    
   BFM_TriggerFactory.createhandler(BFM_Occurrence_NFS__c.sObjectType);  
}