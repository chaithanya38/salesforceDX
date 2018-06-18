global with sharing class BFM_BulkNFSPrint implements Database.Batchable<sObject>, Database.Stateful , Database.AllowsCallouts{

    public Set<string> nfsIds;
     public Id accId;


    public BFM_BulkNFSPrint(Set<string> nfsIdList,Id aid) {
        nfsIds = nfsIdList;
        accId =aid;
        
    }

  global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'select Id, Name,External_File_Path__c,Carrier__r.BFM_CNPJ__c,Carrier__r.id,Uploaded_File_Name__c from BFM_NFS__c where id IN:nfsIds';
        return Database.getQueryLocator(query);
  }

    global void execute(Database.BatchableContext BC, List<BFM_NFS__c> scope) {
        BFM_NFS__c bnfs = new BFM_NFS__c();
        for(BFM_NFS__c bfs:scope)
        {
            if(bfs.External_File_Path__c!=null)
                bnfs = bfs;
                
        }
            
            
            BFM_AmazonConnector.getNFSFile(bnfs.External_File_Path__c,accId,bnfs.Uploaded_File_Name__c);
        
    }   

    global void finish(Database.BatchableContext BC) {
        
   
    }
}