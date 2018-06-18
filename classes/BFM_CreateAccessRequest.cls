/**
 * This class creates Access Requests based on the information provided on the Self-Registration page.
 * Those Access Requests will be linked to one User Request, that will be provided as a constructor parameter.
 * Created Access Requests will be immediately submitted for approval of internal Unilever user, who has to contact the Carrier.
 * @author Zanquini, Vinicius
 * @date 02/08/2016
 * */
public without sharing class BFM_CreateAccessRequest {
    
    private BFM_UserCreationRequest__c newUserRequest;
    private List<Account> accounts;
    public Approval.ProcessResult result;
    public BFM_CreateAccessRequest(BFM_UserCreationRequest__c newUserRequest, List<Account> accounts){
        this.accounts = accounts;
        this.newUserRequest = newUserRequest;
    }
    
    public void createAccessRequests(){
        List<BFM_AccountAccessRequest__c> accessRequests = new List<BFM_AccountAccessRequest__c>();
        
        for(Account carrierBranch: accounts){
            BFM_AccountAccessRequest__c newAccessRequest = new BFM_AccountAccessRequest__c(
                                        Account__c = carrierBranch.Id,
                                        UserCreationRequest__c = newUserRequest.Id);
            accessRequests.add(newAccessRequest);
        }
        insert accessRequests;
        
        // Create an approval request for the account
        Approval.ProcessSubmitRequest req1 = 
            new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(newUserRequest.id);
        result = Approval.process(req1);

    }

    
}