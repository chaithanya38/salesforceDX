@isTest
private class BFM_BulkUpdate6thFlag_Test {
    public static Database.QueryLocator QL;
    public static Database.BatchableContext BC;
    public static set<Id> shipmentIds = new set<Id>();
    public static string sObjectType = 'BFM_shipment__c';
    static testmethod void BFM_BulkUpdate6thFlagTestmethod(){
        
        for(BFM_shipment__c ship : [SELECT Id FROM BFM_shipment__c Limit 1]){
        }
        BFM_BulkUpdate6thFlag bulkprocess = new BFM_BulkUpdate6thFlag(shipmentIds);
        QL = bulkprocess.start(BC);
        List<BFM_shipment__c> shipList = new List<BFM_shipment__c>();
        Database.QueryLocatorIterator QIT =  QL.iterator();
        while (QIT.hasNext()){
            BFM_shipment__c header = (BFM_shipment__c)QIT.next();            
            System.debug(header);
            shipList.add(header);
        } 
        try{       
        bulkprocess.execute(BC,shipList);
        }catch(exception e){
          system.debug('miroprocessing:');    
        }
        bulkprocess.finish(BC);
    }
}