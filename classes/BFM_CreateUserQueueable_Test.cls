@isTest
public class BFM_CreateUserQueueable_Test {
    private static testMethod void BFM_CreateUserQueueable_TestMethod(){
        BFM_UserCreationRequest__c bfmuser = new BFM_UserCreationRequest__c();
        bfmuser.userName__c = 'TestUsername';
        bfmuser.email__c = 'Testuseremail@test.com';
        bfmuser.firstName__c = 'first';
        bfmuser.cnpj__c = '';
        bfmuser.Operational_User__c = True;
        bfmuser.lastName__c = 'last';
        bfmuser.communityNickname__c = '';
        insert bfmuser;
        
        Account acc = new Account();
        acc.Name = 'TestAccount';
        insert acc;
        
        BFM_AccountAccessRequest__c accReq = new BFM_AccountAccessRequest__c();
        accReq.Account__c = acc.Id;
        accReq.UserCreationRequest__c = bfmuser.Id;
        insert accReq;
                
        
        Test.startTest();       
        System.enqueueJob(new BFM_CreateUserQueueable(bfmuser.Id));
        Test.stopTest();
    }
}