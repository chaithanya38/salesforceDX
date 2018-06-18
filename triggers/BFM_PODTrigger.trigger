trigger BFM_PODTrigger on BFM_POD__c (Before insert, Before update, After insert, After update, After delete) {
    
    if(!BFM_TriggerHelper.isTriggerEnabled()){
        return ; 
    } 
    BFM_TriggerFactory.createhandler(BFM_POD__c.sObjectType);  
}