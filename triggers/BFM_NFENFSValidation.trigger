trigger BFM_NFENFSValidation on BFM_NF_e_NFS__c (after insert, after update, after delete) {

    if(!BFM_TriggerHelper.isTriggerEnabled()) { 
        return ; 
    } 
    
    BFM_TriggerFactory.createhandler(BFM_NF_e_NFS__c.sObjectType); 
    
}