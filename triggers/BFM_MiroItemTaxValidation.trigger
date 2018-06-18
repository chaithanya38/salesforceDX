trigger BFM_MiroItemTaxValidation on BFM_MIRO_Item_Tax__c (before insert, before update, after insert, after update) {
    BFM_TriggerFactory.createHandler(BFM_MIRO_Item_Tax__c.sObjectType);
}