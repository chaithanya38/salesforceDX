@isTest
private class BFM_BulkNFeDFUploadExcel_Test {
    static testmethod void BFM_BulkNFeDFUploadExcelTestmethod(){
        
        Account acccte = new Account(Name = 'TOMBINI E CIA LTDA ',BFM_CNPJ__c = '82809088001204',BFM_Company_Code__c='4235',BFM_Carrier_Region__c='BR');
        acccte.recordtype=new recordtype(name='Carrier');
        insert acccte;
        
        BFM_ToleranceMargin__c tm = new BFM_ToleranceMargin__c();
        tm.Name = 'Tolerance_limit';
        tm.Company_Code__c = '2236';
        tm.Tolerance_Percentage_Value__c = 5;
        insert tm;
        
        BFM_AbsoluteConsideration__c abs = new BFM_AbsoluteConsideration__c();
        abs.Name = 'Abs_consideration';
        abs.AbsoluteConsideration_Value__c = 5000;
        insert abs;
       
        BFM_NF_e_DF__c nfedf_Insert = new BFM_NF_e_DF__c(CNPJ_issuer__c = 'test Issuer',CNPJ_Taker__c = 'test tracker',City_Code_Issuer__c = '5300108',
                                                        NF_e_Number__c = '151413',NF_e_key__c = '55160801456021000189550010001514131001381324',
                                                        NFe_Emission_date_time__c = System.today(),NFe_Status__c = '100',Vehicle_Plate__c = 'Vehicle',
                                                        NFe_DF_6_Months__c = true,Is_Vendor_Code_Matching_Ses__c = true,Is_Plant_Code_Matching_Ses__c = true,
                                                        Sefaz_Check_Status__c = '100',SEFAZ_Return_Status__c = 'Autorizado o uso da NF-e',
                                                        Is_Gross_Value_Validation_Ok__c = true,Is_Tax_Classification_Ok__c = false,Is_All_The_SESs_Linked__c = true,
                                                        Is_published_on_GRC__c = true,Carrier_Account__c = acccte.Id,Unilever_Account__c = acccte.Id);
        insert nfedf_Insert;
        
        list<BFM_NF_e_DF__c> listNFeDF = [SELECT ID, NF_e_key__c FROM BFM_NF_e_DF__c Limit 1]; 
        
        System.debug('===listNFeDF' + listNFeDF);
        map<string, String[]> mapRecord = new map<string,String[]>();
        
        String[] inputValues = new String[3];            
        string id = listNFeDF[0].id;
        id = id.substring(0,15);
        
        inputValues[0] = id;
        inputValues[1] = 'XA';
        inputValues[2] = '';
                       
        mapRecord.put(id,inputValues);
        
        Test.startTest();
        
        String Json =' {"QueryTaxCalculationResponse": { "cteAccessKey": "35160862798780000114570010000475471003086150", "debitNoteNumber": "","itemType": "CTE", "message": "Nota Fiscal already created for the goods receipt (see long text)","sesList": [ {"cfop": "", "cofinsLaw": "", "icmsLaw": "","id": "1041318889", "ipiLaw": "","pisLaw": "","taxCode": "XA", "issLaw": ""} ],"nfsNumber": ""} } ';       
        
        Test.setMock(HttpCalloutMock.class, new BFM_MockHttpResponse(json));
        
        BFM_BulkNFeDFUploadExcel batchCTe = new BFM_BulkNFeDFUploadExcel();
        batchCTe.mapUpload = mapRecord;
        Database.executeBatch(batchCTe, 20);           
        
        
        Test.stopTest();
        
    }
}