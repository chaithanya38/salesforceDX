/*************************************************************************************************************************************************************
@ Class:          BFM_CommunitiesSelfRegController_CC_Test
@ Author:         Chaithanya
@ Purpose:        Test Class for the BFM_CTeSearch_CC Class.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 04.03.2017 / Manoj Kumar peta  
**************************************************************************************************************************************************************/
@isTest
private class BFM_CommunitiesSelfRegController_CC_Test {
    public static BFM_SendEmailToCarrierApprover emailSender;   
    private static testMethod void testControllerWithMatchingAccount(){
        Test.startTest();
        List<RecordType> recordtypeList = [select id,Name,DeveloperName from Recordtype where sobjecttype = 'Account' and developername ='BFM_Carrier' limit 1];
        Account acc = new Account();
        acc.name='carrier';
        acc.BFM_CNPJ__c = '03189042000100';
        acc.recordtypeid = recordTypeList[0].id;
        insert acc;
        string testname = 'testname';
        
        list<BFM_UserCreationRequest__c> userlist=new list<BFM_UserCreationRequest__c>();
        BFM_UserCreationRequest__c userreq = new BFM_UserCreationRequest__c();
        userreq.FirstName__c =testname;
        userreq.CPF__c='24671829673';
        userreq.Email__c='test@capg.com';
        userreq.CommunityNickname__c='test879';
        userreq.CNPJ__c='031890420001019';        
        
        userlist.add(userreq );
        insert userlist;
        system.assertEquals(testname, userreq.FirstName__c );      
        BFM_UserCreationRequest__c userreq2 = new BFM_UserCreationRequest__c();
        userreq2.FirstName__c =testname;
        userreq2.CPF__c='12345678';
        userreq2.Email__c='test@capg.com';
        userreq2.CommunityNickname__c='test';
        userreq2.CNPJ__c='0318';
        insert userreq2;     
        system.assertEquals(testname,userreq2.FirstName__c);
        
        // BFM_CommunitiesSelfRegController_CC controller = new BFM_CommunitiesSelfRegController_CC();
        BFM_CommunitiesSelfRegController_CC controller = new BFM_CommunitiesSelfRegController_CC();
        BFM_CommunitiesSelfRegController_CC controller1 = new BFM_CommunitiesSelfRegController_CC();
        
        // controller.requestLines.get(acc.Id).isSelected =true;
        controller.firstName='xyz';
        controller.lastName='G';
        controller.cnpj = '031890720';
        controller.cpf='24671829673';
        controller.communityNickname='xyz';
        controller.email='xyz@unilever.com';
        
        
        controller1.firstName='xyz';
        controller1.lastName='G';
        controller1.cnpj = '03189032';
        controller1.cpf='1234567';
        controller1.communityNickname='rajs';
        controller1.email='xyz@unilever';
        
        controller1.operationalUser = True;
        controller1.financialUser = True;
        
        controller1.cnpj = '03189042000108';
        controller1.fetchBranches();
        
        controller1.fetchBranches();
        controller1.validateCarrierRequest(userreq);
        controller1.submitNewUserRequest();
        controller1.clearBranchSelection();
        controller1.getDesiredCarriers();
        controller1.resetVF();
        controller1.validateEmail('email');
        List<Account> desiredCarriers = new List<Account> ();
        desiredCarriers.add(acc);
        emailSender = new BFM_SendEmailToCarrierApprover(userreq,desiredCarriers);
        
        BFM_CommunitiesSelfRegController_CC.RequestLine wrapreq = new BFM_CommunitiesSelfRegController_CC.RequestLine(true,acc);
        wrapreq.isSelected = true;
        wrapreq.branch = acc;
        
        // controller1.fetchBranches();
        
        BFM_CPFValidator cpfvalidcon = new BFM_CPFValidator('24671829673');
        cpfvalidcon.validateCPF();
        
        controller.operationalUser = True;
        controller.financialUser = True;
        BFM_AccountDAO.getAccountsWithCNPJPrefix('03189042000107');
        controller.fetchBranches();
        controller.validateCarrierRequest(userreq);
        controller.submitNewUserRequest();
        controller.clearBranchSelection();
        //controller.getDesiredCarriers();
        controller.resetVF();
        controller.validateEmail('email');
        controller.cnpj = '03189042000106';
        controller.fetchBranches();
        //List<RecordType> recordTypeList =[select Id, Name, DeveloperName from RecordType where SobjectType='Account' and DeveloperName='BFM_Carrier' Limit 1];
        //  List<RecordType> recordtypeList = [select id,Name,DeveloperName from Recordtype where sobjecttype = 'Account' and developername ='BFM_Carrier' limit 1];
        //  acc.recordtypeid = recordTypeList[0].id;
        //  update acc;
        
        Test.stopTest();
    }
    
    
}