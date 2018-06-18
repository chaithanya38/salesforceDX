public with sharing class BFM_CCeHandler implements ITrigger{ 
    
    public List<BFM_CC_e__c> newMap;
    public List<BFM_CC_e__c> oldMap;
    public Map<Id, SObject> oldMapRecords;
    
    private static Boolean recursive = false;
    
    public BFM_CCeHandler() {
        this.newMap = (List<BFM_CC_e__c>) Trigger.New;
        this.oldMap = (List<BFM_CC_e__c>) Trigger.Old;
        this.oldMapRecords = Trigger.OldMap;
        
        
    }
    
    public void bulkBefore() { 
        
        if(trigger.isInsert) {
            if(!recursive) {    
                BFM_CceHandlerActions.linkCceToCteOrNfeDf(newMap);
                // BFM_ValidateCNPJ.CCeCNPJvalidation(newMap); /*Company Code Check within CNPJS in Account */
                // BFM_ValidateEmissionDate.validateCCeEmissionDate(newMap); /* CCE is Sefaz Valid (6 months validation)*/
                BFM_CceHandlerSefazActions.checkSEFAZManually(newMap); //validate on field "CT_e_6_Months__c"
            }
        }
        
        if(trigger.isupdate) {
            system.debug('CCehandler_bulkBefore');
            if(!recursive) {    
                BFM_CceHandlerActions.linkCceToCteOrNfeDf(newMap);
                // BFM_ValidateCNPJ.CCeCNPJvalidation(newMap); /*Company Code Check within CNPJS in Account */
                // BFM_ValidateSEFAZResponse.checkCCeSefazValidationResponses(newMap);  /* Validate the SEFAZ status after Mulesoft operation*/
                
                // SEFAZ Action
                BFM_CceHandlerSefazActions.checkSEFAZManually(newMap); //validate on field "CT_e_6_Months__c"
                BFM_CceHandlerSefazActions.checkSefazStatus(newMap, oldMapRecords); //check sefaz status and post to GRC
            }
        }
    }
    
    public void bulkAfter() {
        
        if(trigger.isInsert){
            if(!recursive) {             
                // BFM_Sefazvalidation_CC.sendCCEtoSefaz(Trigger.newMap.keySet()); /* Sending to Sefaz after insert the document for the first time */
                BFM_CceHandlerActions.getListInsertSize(newMap);
                BFM_CceHandlerActions.getCceCteListsSizes();
                BFM_CceHandlerActions.updateRelatedCTE(newMap);
                //SEFAZ Actions
                BFM_CceHandlerSefazActions.sendCCetoSefaz(newMap); // Sending to Sefaz after insert the document for the first time
                     
            }
        }
        if(trigger.isupdate) {
            if(!recursive) {  
                // BFM_Sefazvalidation_CC.sendCCEtoSefaz(Trigger.newMap.keySet()); /* Sending to Sefaz after insert the document for the first time */
                //    BFM_SESCTEHandlerActions.updateRelatedCTE(newMap);
                //    
                //    
            }
            
            
        }
        if(trigger.isDelete) {
            if(!recursive) {             
                // BFM_Sefazvalidation_CC.sendCCEtoSefaz(Trigger.newMap.keySet()); /* Sending to Sefaz after insert the document for the first time */
                BFM_CceHandlerActions.getListDeleteSize(oldMap);
                BFM_CceHandlerActions.getCceCteListsSizes();
                BFM_CceHandlerActions.updateRelatedCTE(oldMap);
            }
            
            
        }
    }    
    
    public void beforeInsert(SObject so) {
        system.debug('BFM_CCeHandler.beforeInsert');
    }
    
    public void beforeUpdate(SObject oldSo, SObject so) {
        system.debug('BFM_CCeHandler.beforeUpdate');
    }
    
    public void beforeDelete(SObject so) {
        system.debug('BFM_CCeHandler.beforeDelete');
    }
    
    public void afterInsert(SObject so)  {	
        system.debug('BFM_CCeHandler.afterInsert');
    }
    
    public void afterUpdate(SObject oldSo, SObject so) {
        system.debug('BFM_CCeHandler.afterUpdate');
    }
    
    public void afterDelete(SObject so) {
        system.debug('BFM_CCeHandler.afterDelete');
    }
    
    public void andFinally() {
        system.debug('BFM_CCeHandler.andFinally');
    }
    
}