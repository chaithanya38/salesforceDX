global with sharing class BFM_BulkOccurrenceQuery implements Database.Batchable<sObject>, Database.Stateful , Database.AllowsCallouts{

    public Set<Id> occurrenceIds;
    public String returnMessage;
    global List<BFM_Occurrence__c> roccurrencesIdList = new List<BFM_Occurrence__c>();

    public BFM_BulkOccurrenceQuery(Set<Id> occurrenceIdList) {
        occurrenceIds = occurrenceIdList;	
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Occurrence_Number__c ,Last_Occurrence_Update__c,LastModifiedDate FROM BFM_Occurrence__c WHERE Id IN :occurrenceIds';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<BFM_Occurrence__c> scope) {
        Set<string> occIds = new Set<String>();
        for(BFM_Occurrence__c bfms:scope)
        {
            occIds.add(bfms.Occurrence_Number__c);
            roccurrencesIdList.add(bfms);
            
        }
        BFM_QueryOccurrence queryoccurrences = new BFM_QueryOccurrence(occIds);
        
        returnMessage = Label.BFM_Freight_Ok;
        try{
            queryoccurrences.callQueryOccurrencesIssuing();
          
        } catch(Exception ex){
            System.debug('message:');
      }
    }   

    global void finish(Database.BatchableContext BC) {
        
     /*   if(roccurrencesIdList.size()>0)
        {
            List<BFM_Shipment__c> uShiplList = new List<BFM_Shipment__c>();
            for(BFM_Shipment__c bfs:rshipmentIdList)
            {
                BFM_Shipment__c ship = new BFM_Shipment__c();
                ship.Id = bfs.id;
                ship.Last_Shipment_Update__c = system.now(); 
                uShiplList.add(ship);
            }
            if(uShiplList.size()>0)
            update uShiplList;
   
        }*/
    }
}