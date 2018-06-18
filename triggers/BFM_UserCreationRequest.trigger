trigger BFM_UserCreationRequest on BFM_UserCreationRequest__c (before update) {
    BFM_TriggerFactory.createHandler(BFM_UserCreationRequest__c.sObjectType);
}