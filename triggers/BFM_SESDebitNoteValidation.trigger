trigger BFM_SESDebitNoteValidation on BFM_SES_Debit_Note__c (before insert, before update, after insert, after update, after delete) {
    
    if(!BFM_TriggerHelper.isTriggerEnabled()) { 
        return ; 
    } 
    
    BFM_TriggerFactory.createhandler(BFM_SES_Debit_Note__c.sObjectType);  
}