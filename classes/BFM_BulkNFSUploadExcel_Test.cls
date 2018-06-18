@isTest
private class BFM_BulkNFSUploadExcel_Test {
    static testmethod void BFM_BulkNFSUploadExcelTestmethod(){
        
        Id AccRecordTypeId = [Select Id, Name from RecordType where Name = 'Carrier' LIMIT 1].Id;
        Account acc = new Account(Name = 'Test Account', BFM_Plant_Code__c='123',RecordTypeId = AccRecordTypeId);
        insert acc; 
        
        BFM_ToleranceMargin__c tm = new BFM_ToleranceMargin__c();
        tm.Name = 'Tolerance_limit';
        tm.Tolerance_Percentage_Value__c = 5;
        insert tm;
        
        BFM_AbsoluteConsideration__c abs = new BFM_AbsoluteConsideration__c();
        abs.Name = 'Abs_consideration';
        abs.AbsoluteConsideration_Value__c = 5000;
        insert abs;   
        
   
        List<BFM_NFS__c>  nuer = new  List<BFM_NFS__c> ();
        nuer.add(new BFM_NFS__c(Service_Taker_CNPJ__c='test',Service_Taker__c=acc.id, Carrier__c= acc.id,NFS_Emission_Date_Time__c=system.today(),NFS_Number__c='12345678',Vendor_s_CNPJ_or_CPF__c='',Base_Value__c   =2,ISS_Aliquot__c =2,NFS_Total_Value__c=2,Is_Plant_Code_Matching_Ses__c=true,Is_POD_Reception_Ok__c=true,Is_The_FRS_Linked__c=true,Is_Gross_Value_Validation_Ok__c=true,Is_Tax_Classification_Ok__c=True  ));
        insert nuer;
       
             
        list<BFM_NFS__c> listNFS = [SELECT ID FROM BFM_NFS__c Limit 1]; 
        
        List<BFM_MIRO_Header__c> mhlist = new List<BFM_MIRO_Header__c>();
        BFM_MIRO_Header__c mh = new BFM_MIRO_Header__c(Access_Key__c='54354323', Cancellation_Flag__c=true); 
        mh.NFS__c = listNFS[0].id;                                              
        mhlist.add(mh);
        insert mhlist;
        
        Account acccte1 = new Account(Name = 'UNILEVER BRASIL',BFM_CNPJ__c = '82809088000667',BFM_Company_Code__c='4236',BFM_Carrier_Region__c='BR');
        acccte1.recordtype=new recordtype(name='BFM Unilever Account');
        insert acccte1;
        
        BFM_Withhold_Tax__c  objBFM_Withhold_Tax= new BFM_Withhold_Tax__c();
        objBFM_Withhold_Tax.Carrier_Account__c=acc.id; 
        objBFM_Withhold_Tax.External_Id__c='4578669778925';
        objBFM_Withhold_Tax.Unilever_Account__c=acccte1.id;
        objBFM_Withhold_Tax.Withholding_Tax_Code__c='456';
        objBFM_Withhold_Tax.Withholding_Tax_Flag__c=true;
        objBFM_Withhold_Tax.Withholding_Tax_Text__c='768784';
        objBFM_Withhold_Tax.Withholding_Tax_Type__c='2';
        insert objBFM_Withhold_Tax; 
        
        List<BFM_MIRO_Withhold_Tax__c> listBFM_MIRO_Withhold_Tax= new List<BFM_MIRO_Withhold_Tax__c>();
        listBFM_MIRO_Withhold_Tax.add(new BFM_MIRO_Withhold_Tax__c( Apply__c=true,Base_Amount__c=4,MIRO_Header__c=mhlist[0].id,Withhold_Tax__c = objBFM_Withhold_Tax.id));
        
        insert listBFM_MIRO_Withhold_Tax;
        
        system.debug('-------- ' + listNFS);
                
        map<string, String[]> mapRecord = new map<string,String[]>();
        
        String[] inputValues = new String[6];            
        string id = listNFS[0].id;
        id = id.substring(0,15);
        
        inputValues[0] = id;
        inputValues[1] = 'XA';
        inputValues[2] = '2';
        inputValues[3] = '';
        inputValues[4] = 'false';
        inputValues[5] = '2';
                       
        mapRecord.put(id,inputValues); 
                
        Test.startTest();
        
        String Json =' {"QueryTaxCalculationResponse": { "cteAccessKey": "35160862798780000114570010000475471003086150", "debitNoteNumber": "","itemType": "CTE", "message": "Nota Fiscal already created for the goods receipt (see long text)","sesList": [ {"cfop": "", "cofinsLaw": "", "icmsLaw": "","id": "1041318889", "ipiLaw": "","pisLaw": "","taxCode": "XA", "issLaw": ""} ],"nfsNumber": ""} } ';       
        
        Test.setMock(HttpCalloutMock.class, new BFM_MockHttpResponse(json));
        
        BFM_BulkNFSUploadExcel batchNFS =  new BFM_BulkNFSUploadExcel();
        batchNFS.mapUpload = mapRecord;
        Database.executeBatch(batchNFS, 20);
        
        
        Test.stopTest();
    
    }
}