global without sharing class BFM_BulkMiroProcessing implements Database.Batchable<sObject>, Database.Stateful , Database.AllowsCallouts{
    
    public Set<Id> miroIds;
    public String sObjectType;
    public String returnMessage;
    public Id miroIdToProcess;
    
    public BFM_BulkMiroProcessing(Set<Id> miroIdSet,String objectType) {
        miroIds = miroIdSet;
        sObjectType = objectType;
        System.debug('===miroIds' + miroIds);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, CT_e__r.CT_e_Type__c, CT_e__c, CT_e__r.Service_Rendering_Value__c, CT_e__r.ICMS_Value__c, CT_e__r.Complementary_CTe_of_ICMS__c FROM BFM_MIRO_Header__c WHERE Id IN :miroIds';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<BFM_MIRO_Header__c> scope) {
        
       for(BFM_MIRO_Header__c miro:scope){
                    
            if(miro.CT_e__r.Complementary_CTe_of_ICMS__c){
                BFM_InvoiceProcessing.performInvoiceProcessingFromBatchICMS(miro.id, sObjectType);
            }
            else{
                BFM_InvoiceProcessing.performInvoiceProcessingFromBatch(miro.id, sObjectType);
            }
       }
   
    }   
    
    global void finish(Database.BatchableContext BC) {}
}