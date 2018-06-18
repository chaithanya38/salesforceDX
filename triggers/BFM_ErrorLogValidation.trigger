trigger BFM_ErrorLogValidation on BFM_Error_Log__c (after insert, after update) {

    BFM_TriggerFactory.createhandler(BFM_Error_Log__c.sObjectType);  
}