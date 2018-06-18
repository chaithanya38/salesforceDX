trigger BFM_Email_Information on BFM_Email_Information__c (after insert) {
    
    if(Trigger.isAfter && trigger.isInsert) {
        System.debug('BFM_Email_Information isAfter BEGIN');
        List<Contact> contacts = new LisT<Contact>();
        List<RecordType> listCarrierContact = [SELECT Id FROM RecordType WHERE DeveloperName = 'BFM_Carrier_Contact' LIMIT 1];
        
        if(listCarrierContact.size() > 0){
            for(BFM_Email_Information__c emailInserted: trigger.new){
                Contact c;
                if(emailInserted.email__c != null){
                    c = new Contact();
                    c.accountId = emailInserted.carrier_account__c;
                    c.LastName = emailInserted.name;
                    c.email = emailInserted.email__c;
                    if(emailInserted.Remark__c!=null && emailInserted.Remark__c.containsIgnoreCase('SF_APPROVAL')){
                        c.Title = 'SF_APPROVAL';
                    }
                    c.RecordTypeId = listCarrierContact[0].Id;
                    contacts.add(c);
                }
            }
        } else {
            for(BFM_Email_Information__c emailInserted: trigger.new){
                emailInserted.addError('There is no Carrier Contact Record Type at Organization, please contact a administrator.');
            }
        }
        System.debug('contacts ' + contacts);
        insert contacts;
    }
}