global without sharing class BFM_BulkUpdate6thFlag implements Database.Batchable<sObject>, Database.Stateful , Database.AllowsCallouts{

    public Set<Id> shipmentIds;
    public Id shpIdToProcess;
    
    public BFM_BulkUpdate6thFlag(Set<Id> shipmentIdSet) {
        shipmentIds = shipmentIdSet;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id FROM BFM_shipment__c WHERE Id IN :shipmentIds';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<BFM_Shipment__c> scope) {
        for(BFM_Shipment__c shp:scope) {
            shpIdToProcess = shp.Id;
            system.debug('Inside batch for loop: :');
        }
        system.debug('BFM_BulkUpdate6thFlag.execute.shpIdToProcess >>> ' + shpIdToProcess);
        BFM_UpdateFreightData.send6thFlagUpdateFromBatch(shpIdToProcess);
    }   
    
    global void finish(Database.BatchableContext BC) {}

}