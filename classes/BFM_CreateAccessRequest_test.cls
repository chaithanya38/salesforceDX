/**
* Test class for the BFM_CreateAccessRequest class
* 
* @author Zanquini, Vinicius
* @date 2016/08/02
* */

@isTest
private class BFM_CreateAccessRequest_test {
    private static testMethod void testCreateAccessRequest(){
        BFM_UserCreationRequest__c userCreationRequest =new BFM_UserCreationRequest__c ();
        insert userCreationRequest;
        
        Account accountOne = new Account();
        accountOne.name = 'Carrier 1';
        accountOne.BFM_CNPJ__c ='12345678909090';
        Account accountTwo = new Account();
        accountTwo.Name = 'Carrier 2';
        List<Account> accountsList = new List<Account>{accountOne, accountTwo};
            insert accountsList;
        Test.startTest();
        new BFM_CreateAccessRequest(userCreationRequest,accountsList).createAccessRequests();
        system.assertEquals('Carrier 1', accountOne.name);
        Test.stopTest();
    }
}