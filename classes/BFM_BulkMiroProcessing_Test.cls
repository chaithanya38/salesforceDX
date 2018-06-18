@isTest
private class BFM_BulkMiroProcessing_Test {
    public static Database.QueryLocator QL;
    public static Database.BatchableContext BC;
    public static set<Id> miroIds = new set<Id>();
    public static Id miroId;
    public static string sObjectType = 'BFM_MIRO_Header__c';
    static testmethod void BFM_BulkMiroProcessingTestmethod(){
        
        for(BFM_MIRO_Header__c miro : [SELECT Id FROM BFM_MIRO_Header__c Limit 1]){
            miroIds.add(miro.Id);
            miroId = miro.Id;
        }
        BFM_BulkMiroProcessing bulkprocess = new BFM_BulkMiroProcessing(miroIds,sObjectType);
        QL = bulkprocess.start(BC);
        List<BFM_MIRO_Header__c> miroList = new List<BFM_MIRO_Header__c>();
        Database.QueryLocatorIterator QIT =  QL.iterator();
        while (QIT.hasNext()){
            BFM_MIRO_Header__c header = (BFM_MIRO_Header__c)QIT.next();            
            System.debug(header);
            miroList.add(header);
        }
        //BFM_InvoiceProcessing.performInvoiceProcessingFromBatch(miroId, sObjectType); 
        try{       
        bulkprocess.execute(BC,miroList);
        }catch(exception e){
            system.debug('miroprocessing:');    
        }
        bulkprocess.finish(BC);
        Test.startTest();
            //BFM_BulkMiroProcessing obj = new BFM_BulkMiroProcessing(miroIds,sObjectType);
            //DataBase.executeBatch(obj);            
        Test.stopTest();
    }
}