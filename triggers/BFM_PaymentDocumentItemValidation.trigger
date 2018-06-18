trigger BFM_PaymentDocumentItemValidation on BFM_Payment_Document_Item__c(after update, after insert) {

    BFM_TriggerFactory.createhandler(BFM_Payment_Document_Item__c.sObjectType); 
    
}