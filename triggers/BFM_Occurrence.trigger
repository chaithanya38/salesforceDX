trigger BFM_Occurrence on BFM_Occurrence__c (before update, before insert, after insert, after update) {
    BFM_TriggerFactory.createHandler(BFM_Occurrence__c.sObjectType);
}