trigger BFM_ShipmentNFeDFValidation on BFM_Shipment_NF_e_DF__c (after insert, after update, after delete) {
    
    if(!BFM_TriggerHelper.isTriggerEnabled()){ 
        return ;  
    }
     
    BFM_TriggerFactory.createhandler(BFM_Shipment_NF_e_DF__c.sObjectType);  
}