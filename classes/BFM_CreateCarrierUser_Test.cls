@isTest
private class BFM_CreateCarrierUser_Test {
    private static testMethod void myTest(){
        BFM_UserCreationRequest__c userCreationRequest = BFM_TestUtils.createUserCreationRequest();
        userCreationRequest.Operational_User__c = true;
        insert userCreationRequest;
        
        BFM_UserCreationRequest__c userCreationRequestDuplicatedNickname = BFM_TestUtils.createUserCreationRequest();
        userCreationRequestDuplicatedNickname.communityNickname__c = userCreationRequest.CommunityNickname__c;
        userCreationRequest.Operational_User__c = true;
        insert userCreationRequestDuplicatedNickname;
        
        Account carrierAccount = BFM_TestUtils.createCarrierAccount();
        insert carrierAccount;
        
        BFM_AccountAccessRequest__c accessRequest = BFM_TestUtils.createAccountAccessRequest(userCreationRequest.Id, 
                                                                                             carrierAccount.Id);
        insert accessRequest;
        system.assertEquals('userCreationRequest.Id','userCreationRequest.Id');
        
        BFM_AccountAccessRequest__c accessRequestDuplicatedNickname = BFM_TestUtils.createAccountAccessRequest(userCreationRequestDuplicatedNickname.Id, 
                                                                                             carrierAccount.Id);
        insert accessRequestDuplicatedNickname;
        
        Test.startTest();
        BFM_CreateCarrierUser.createUserShareAccounts(new List<BFM_UserCreationRequest__c>{userCreationRequest});
        BFM_CreateCarrierUser.createUserShareAccounts(new List<BFM_UserCreationRequest__c>{userCreationRequestDuplicatedNickname});
        
        Test.stopTest();
    }
}