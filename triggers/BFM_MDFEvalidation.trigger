trigger BFM_MDFEvalidation on BFM_MDF_e__c (before insert, after insert,before update, after update) {
    BFM_TriggerFactory.createhandler(BFM_MDF_e__c.sObjectType);  
}