trigger BFM_SHIPMENT_NFSValidation on BFM_Shipment_NFS__c (before insert, before update, after insert, after update, after delete) {
    
    if(!BFM_TriggerHelper.isTriggerEnabled()) { 
        return ; 
    } 
    
    BFM_TriggerFactory.createhandler(BFM_Shipment_NFS__c.sObjectType);  	
    
}