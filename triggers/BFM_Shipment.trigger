trigger BFM_Shipment on BFM_Shipment__c (before update, before insert, after insert, after update, before delete, after delete) {
    BFM_TriggerFactory.createHandler(BFM_Shipment__c.sObjectType);
}