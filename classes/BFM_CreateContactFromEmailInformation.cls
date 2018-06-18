public with sharing class BFM_CreateContactFromEmailInformation {
    public static void createContactsFromEmails(List<BFM_Email_Information__c> emailsInserted){
        List<Contact> contacts = new LisT<Contact>();
        RecordType carrierContact = [SELECT Id FROM RecordType WHERE DeveloperName = 'BFM_Carrier_Contact' LIMIT 1];
        for(BFM_Email_Information__c emailInserted: emailsInserted){
            Contact c;
            if(emailInserted.email__c != null){
                c = new Contact();
                c.accountId = emailInserted.carrier_account__c;
                c.LastName = emailInserted.name;
                c.email = emailInserted.email__c;
                if(emailInserted.SF_Approver__c){
                    c.Title = 'SF_APPROVAL';
                }
                c.RecordTypeId = carrierContact.Id;
                contacts.add(c);
            }
        }
        insert contacts;
    }
}