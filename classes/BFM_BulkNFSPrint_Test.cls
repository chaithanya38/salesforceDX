@isTest
private class BFM_BulkNFSPrint_Test {
    public static Database.QueryLocator QL;
    public static Database.BatchableContext BC;
    public static set<string> nfss = new set<string>();
    public static Id miroId;
    public static string sObjectType = 'BFM_NFS__c';
    public static Id AccRecordTypeId;
     static testmethod void BFM_BulkMiroProcessingTestmethod(){
        
        AccRecordTypeId = [Select Id, Name from RecordType where Name = 'Carrier'].Id;
        Account acc = new Account(Name = 'Test Account', RecordTypeId = AccRecordTypeId);
        insert acc;
         
        for(BFM_NFS__c nfs : [SELECT Id FROM BFM_NFS__c Limit 1]){
        }
        BFM_BulkNFSPrint bulkprocess = new BFM_BulkNFSPrint(nfss,acc.id);
        QL = bulkprocess.start(BC);
        List<BFM_NFS__c> nfsList = new List<BFM_NFS__c>();
        Database.QueryLocatorIterator QIT =  QL.iterator();
        while (QIT.hasNext()){
            BFM_NFS__c header = (BFM_NFS__c)QIT.next();            
            System.debug(header);
            nfsList.add(header);
        }
        try{       
        bulkprocess.execute(BC,nfsList);
        }catch(exception e){
          system.debug('miroprocessing:');    
        }
        bulkprocess.finish(BC);
    }
}