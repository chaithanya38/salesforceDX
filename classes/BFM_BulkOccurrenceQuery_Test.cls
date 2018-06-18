@isTest
public class BFM_BulkOccurrenceQuery_Test {
    private static testMethod void BFM_BulkOccurrenceQueryTestMethod(){
        Account acc = new Account();
        acc.Name = 'TestAccount';
        insert acc;
        BFM_Occurrence__c occ = new BFM_Occurrence__c();
        occ.Occurrence_Number__c = '12345';
        occ.CreatedDate = datetime.now();
        occ.Last_Occurrence_Update__c= datetime.now();
        occ.LastModifiedDate = datetime.now();
        occ.Carrier_Account__c = acc.id;
        insert occ;
        Set<Id> occurrenceIds = new Set<Id>();
        occurrenceIds.add(occ.Id);
        Test.startTest();
        BFM_BulkOccurrenceQuery c = new BFM_BulkOccurrenceQuery(occurrenceIds);
        Database.executeBatch(c);
        Test.stopTest();
    }
}