trigger BFM_NFECTEValidation on BFM_NF_e_CT_e__c (after insert, after update, after delete) {

    if(!BFM_TriggerHelper.isTriggerEnabled()) { 
        return ; 
    }
    
   BFM_TriggerFactory.createhandler(BFM_NF_e_CT_e__c.sObjectType);  	
}