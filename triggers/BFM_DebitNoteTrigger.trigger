trigger BFM_DebitNoteTrigger on BFM_Debit_Note__c (before insert, before update, after insert, after update ) {
    
    if(!BFM_TriggerHelper.isTriggerEnabled()){ 
        return ; 
    }
    
    BFM_TriggerFactory.createhandler(BFM_Debit_Note__c.sObjectType);  
}