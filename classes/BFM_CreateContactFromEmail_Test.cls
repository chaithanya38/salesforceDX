/*************************************************************************************************************************************************************
@ Class:          BFM_CreateContactFromEmail_Test 
@ Author:         Chaithanya
@ Purpose:        Test Class for the BFM_CreateContactFromEmail Class.
--------------------------------------------------------------------------------------------------------------------------------------------------------------
@ Change history: 04.06.2017 / Manoj Kumar peta  
**************************************************************************************************************************************************************/
@isTest
public class BFM_CreateContactFromEmail_Test {
    public static RecordType carrierContact;
    public static BFM_CreateContactFromEmailInformation BFM;
    private static testMethod void BFM_CreateContactFromEmail_TestMethod(){
    carrierContact = [SELECT Id FROM RecordType WHERE DeveloperName = 'BFM_Carrier_Contact' LIMIT 1];
        Account acc = new Account();
        acc.Name = 'TestLastname';
        Insert acc;
         
        
        List<BFM_Email_Information__c> emailsInserted = new List<BFM_Email_Information__c>();
        BFM_Email_Information__c emailinfo = new BFM_Email_Information__c();
        
        emailinfo.email__c = 'test@test.com';
        emailinfo.Carrier_Account__c = acc.Id;       
        emailinfo.Remark__c = 'SF_APPROVAL';
        insert emailinfo;
        
       emailsInserted = [select name,email__c,Carrier_Account__c,Remark__c,SF_Approver__c from BFM_Email_Information__c where id =: emailinfo.id  ];
       BFM_CreateContactFromEmailInformation.createContactsFromEmails(emailsInserted);

      
    }
}