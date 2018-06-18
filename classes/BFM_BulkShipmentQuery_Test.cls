@isTest
public class BFM_BulkShipmentQuery_Test {
    public static Database.BatchableContext bc; 
    private static testMethod void BFM_BulkShipmentQueryTestMethod(){        
        Account acc = new Account();
        acc.Name = 'TestAccount';
        insert acc;
        Set<String> shipIds = new Set<String>();
        BFM_Shipment__c ship = new BFM_Shipment__c();
        ship.Shipment_Number__c = '12345678';
        ship.CreatedDate = datetime.now();
        ship.LastModifiedDate = datetime.now();
        ship.Last_Shipment_Update__c = datetime.now();
        ship.Carrier_Account__c = acc.id;
        insert ship;
        shipIds.add(ship.Id);
        List<BFM_Shipment__c> bfmship = new List<BFM_Shipment__c>();
        bfmship.add(ship);
        Test.startTest();
        BFM_BulkShipmentQuery c = new BFM_BulkShipmentQuery(shipIds);
        Database.executeBatch(c);
        //Database.BatchableContext bc; 
        c.execute(bc, bfmship);
        Test.stopTest();
    }
}