/**
 * Method called from the Process Builder workflow that identifies one User Request has been approved
 * */

global with sharing class BFM_CreateCarrierUser {
	@InvocableMethod 
    public static void createUserShareAccounts(List<BFM_UserCreationRequest__c> userRequests){
        if(userRequests != null){
            BFM_UserCreationRequest__c userRequest = userRequests[0];
            System.enqueueJob(new BFM_CreateUserQueueable(userRequest.Id));
        } else{
            System.debug('User requests was null');
        }
    }
    
    
}