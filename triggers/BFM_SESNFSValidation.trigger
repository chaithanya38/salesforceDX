trigger BFM_SESNFSValidation on BFM_SES_NFS__c (before insert, before update, after insert, after update, after delete) {

    
     
    if(!BFM_TriggerHelper.isTriggerEnabled()) { 
        return ; 
    } 
    
    BFM_TriggerFactory.createhandler(BFM_SES_NFS__c.sObjectType);  	
}