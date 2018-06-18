trigger BFM_ShipmentCTEValidation on BFM_Shipment_CT_e__c (after insert, after update, after delete) {
   if(!BFM_TriggerHelper.isTriggerEnabled()) { 
        return ; 
    } 
    
    BFM_TriggerFactory.createhandler(BFM_Shipment_CT_e__c.sObjectType);  	
}