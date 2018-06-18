@isTest
private class BFM_BulkCTeUploadExcel_Test {
	public static Database.QueryLocator QL;
    public static Database.BatchableContext BC;
    static testmethod void BFM_BulkUpdate6thFlagTestmethod(){
        
        Account acccte = new Account(Name = 'TOMBINI E CIA LTDA ', BFM_Tax_Jurisdiction__c='MG 3143302', BFM_CNPJ__c = '82809088001204',BFM_Company_Code__c='4235',BFM_Carrier_Region__c='BR');
        acccte.recordtype=new recordtype(name='Carrier');
        insert acccte;
        system.assertEquals('82809088001204', acccte.BFM_CNPJ__c);
        
        BFM_ToleranceMargin__c tm = new BFM_ToleranceMargin__c();
        tm.Name = 'Tolerance_limit';
        tm.Company_Code__c = '2236';
        tm.Tolerance_Percentage_Value__c = 5;
        insert tm;
        
        BFM_AbsoluteConsideration__c abs = new BFM_AbsoluteConsideration__c();
        abs.Name = 'Abs_consideration';
        abs.AbsoluteConsideration_Value__c = 5000;
        insert abs;
        
        //List <BFM_CT_e__c> lstcte = new List<BFM_CT_e__c>();
        BFM_CT_e__c cte = new BFM_CT_e__c(Carrier_Account__c=acccte.Id, CT_e_key__c='31160610466983001262571000000611621060611690', Unilever_Account__c=acccte.Id,
                                          CNPJ_issuer__c='3258458',CNPJ_Service_Taker__c='43645645',UF_Destination__c='BR', 
                                          Is_Gross_Value_Validation_Ok__c=true, Is_POD_Reception_Ok__c=true,  CT_e_Number__c='8778877', Is_Company_Code_Ok__c=true,Cte_Status__c='101', 
                                          UF_Goods_Sender__c='SP',Vehicle_Plate__c='4385943',SEFAZ_Return_Status__c='trdt',Sefaz_Check_Status__c = '102', Is_published_on_GRC__c=true,
                                          Cte_Emission_date_time__c=System.now().addHours(4),CT_e_Type__c = '1',Is_Vendor_Code_Ok__c=true,Is_Vendor_Code_Matching_Ses__c=true,
                                          Is_Plant_Code_Matching_Ses__c=true,Is_Tax_Classification_Ok__c=false,GNR_e_Required__c = TRUE,GNRE_Uploaded_File_Name__c='yrttet' );
        
        
        insert cte;
        
        system.debug(cte);
        
        list<BFM_CT_e__c> listCTe = [SELECT ID,Carrier_Account__c,CFOP_List__c, Carrier_Account__r.BFM_Tax_Jurisdiction__c FROM BFM_CT_e__c Limit 1]; 
        
        system.debug('----' + listCTe);
            
        map<string, String[]> mapRecord = new map<string,String[]>();
        
        String[] inputValues = new String[3];            
        string id = listCTe[0].id;
        id = id.substring(0,15);
        
        inputValues[0] = id;
        inputValues[1] = 'XA';
        inputValues[2] = '';
                       
        mapRecord.put(id,inputValues);
        
        Test.startTest();
        String Json =' {"QueryTaxCalculationResponse": { "cteAccessKey": "35160862798780000114570010000475471003086150", "debitNoteNumber": "","itemType": "CTE", "message": "Nota Fiscal already created for the goods receipt (see long text)","sesList": [ {"cfop": "", "cofinsLaw": "", "icmsLaw": "","id": "1041318889", "ipiLaw": "","pisLaw": "","taxCode": "XA", "issLaw": ""} ],"nfsNumber": ""} } ';       
        Test.setMock(HttpCalloutMock.class, new BFM_MockHttpResponse(json));
        BFM_BulkCTeUploadExcel batchCTe = new BFM_BulkCTeUploadExcel();
        QL = batchCTe.start(BC);
        Database.QueryLocatorIterator QIT =  QL.iterator();
        while (QIT.hasNext()){
            BFM_CT_e__c header = (BFM_CT_e__c)QIT.next();
            listCTe.add(header);
        }  
        
        BFM_BulkCTeUploadExcel.executeClassification(cte, 'taxCode', 'CFOP') ;
        batchCTe.mapUpload = mapRecord;
        //batchCTe.execute(BC, listCTe);
        Database.executeBatch(batchCTe, 20); 	
        Test.stopTest();
                                         	
    }
}