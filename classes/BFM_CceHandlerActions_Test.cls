@isTest
private class BFM_CceHandlerActions_Test{
    
    public static set<id> ccid = new set<id>();
    
    private static testMethod void testBFM_CceHandlerActions(){
        test.starttest();
        Id AccRecordTypeId = [Select Id, Name from RecordType where Name = 'Carrier'].Id;
        Account acc = new Account(Name = 'Test Account', RecordTypeId = AccRecordTypeId);   //,Carrier_Account__c = '
        insert acc;  
        
        Map<Id,SObject> newMapRecords = new Map<Id,SObject>();
        Map<Id,SObject> oldMapRecords = new Map<Id,SObject>();
        
        BFM_ToleranceMargin__c bfmt = new BFM_ToleranceMargin__c();
        bfmt.Name='Tolerance_limit';
        bfmt.Company_Code__c='2236';
        bfmt.Tolerance_Percentage_Value__c=5;
        insert bfmt;
        
        BFM_AbsoluteConsideration__c bfma = new BFM_AbsoluteConsideration__c();
        bfma.Name='Abs_consideration';
        bfma.AbsoluteConsideration_Value__c= 5000;
        insert bfma;
        
        String json = '{ "validateFiscalDocumentResponse": { "cce": [ { "accessKey": "42170382809088000232570010000032721000032721", "validationMessage": "Autorizado o uso do CT-e", "validationStatusCode": "100" } ] } } ';
        Test.setMock(HttpCalloutMock.class, new BFM_MockPodHttpResponse(json)); 
        
        BFM_CT_e__c cte = new BFM_CT_e__c();
        cte.Carrier_Account__c=acc.Id;
        cte.CT_e_key__c='54354364565465';
        cte.Unilever_Account__c=acc.Id;
        cte.CNPJ_issuer__c='3258458';
        cte.CNPJ_Service_Taker__c='43645645';
        cte.UF_Destination__c='BR';
        cte.UF_Goods_Sender__c='SP';
        cte.Vehicle_Plate__c='4385943';
        cte.Cte_Emission_date_time__c = system.now();
        
        insert cte;

        BFM_NF_e_DF__c nfe = new BFM_NF_e_DF__c();
        nfe.Carrier_Account__c=acc.id;
        nfe.NF_e_key__c = '123456789012122';
        insert nfe;
        
        List<BFM_CC_e__c> ccelist = new List<BFM_CC_e__c> ();
        
            
            ccelist.add(new BFM_CC_e__c(Related_CT_e_NF_e_DF_Key__c='54354364565465',Reference_Object_Type__c='CTE',CNPJ_Issuer__c='01615814006487',CC_e_emission_date__c =system.today(),CC_e_Key__c = '35161210449909000509570030002300021034523213'/*,CC_e_Link_Check_Status__c='Approved'*/,Cce_Status_c__c='ret',Cce_Status_description__c='testdata',Carrier_Account__c=acc.id,City_Code_Service_Taker__c='data',City_Service_Taker_del__c='data1',CNPJ_Service_Taker_del__c='data2',CTe__c=cte.id,Event__c='data3',Is_Company_Code_Ok__c=false,Is_published_on_GRC__c=true,Is_Vendor_Code_Ok__c=true,Manual_Sefaz_Date_Check__c=system.today(),NF_e_DF__c=nfe.id,Sefaz_Request_Date__c=system.today())); 
            ccelist.add(new BFM_CC_e__c(Related_CT_e_NF_e_DF_Key__c='123456789012122',Reference_Object_Type__c='NFE',CNPJ_Issuer__c='01615814006482',CC_e_emission_date__c =system.today(),CC_e_Key__c = '35161210449909000509570030002300021034523214'/*,CC_e_Link_Check_Status__c='Pending'*/,Cce_Status_c__c='ret',Cce_Status_description__c='testdata1',Carrier_Account__c=acc.id,City_Code_Service_Taker__c='data7',City_Service_Taker_del__c='data6',CNPJ_Service_Taker_del__c='data5',CTe__c=cte.id,Event__c='data4',Is_Company_Code_Ok__c=true,Is_published_on_GRC__c=false,Is_Vendor_Code_Ok__c=false,Manual_Sefaz_Date_Check__c=system.today(),NF_e_DF__c=nfe.id,Sefaz_Request_Date__c=system.today())); 
            //ccelist.add(new BFM_CC_e__c(Reference_Object_Type__c='CTE',CNPJ_Issuer__c='01615814006485',CC_e_emission_date__c =system.today(),CC_e_Key__c = '35161210449909000509570030002300021034523214',CC_e_Link_Check_Status__c='Pending',Cce_Status_c__c='ret',CC_e_Status__c='approved',Cce_Status_description__c='testdata1',Carrier_Account__c=acc.id,City_Code_Service_Taker__c='data7',City_Service_Taker_del__c='data6',CNPJ_Service_Taker_del__c='data5',CTe__c=cte.id,Document_Status__c='Validações OK.',Event__c='data4',Is_CNPJ_Invalid__c=false,Is_Company_Code_Ok__c=true,Is_Duplicated__c=false,Is_published_on_GRC__c=false,Is_Vendor_Code_Ok__c=false,Manual_Sefaz_Date_Check__c=system.today(),NF_e_DF__c=nfe.id,Sefaz_Request_Date__c=system.today())); 
            
        
        insert ccelist;
        BFM_TriggerHelper.triggerEnabled = false; 
        
        ccid.add(ccelist[0].id);
        ccelist[0].Related_CT_e_NF_e_DF_Key__c='12445654677657';
        
        update ccelist[0];
        
        oldMapRecords.put(ccelist[0].id,ccelist[0]);
        newMapRecords.put(ccelist[0].id,ccelist[0]);
        
        List<BFM_CC_e__c> UpdatedCceRecords = new List<BFM_CC_e__c>();
        for(BFM_CC_e__c bc : ccelist)
        {
            bc.Related_CT_e_NF_e_DF_Key__c = '01615834006123';
            UpdatedCceRecords.add(bc);
        }
        update UpdatedCceRecords;
        
        New BFM_CceHandlerActions();
        BFM_CceHandlerActions.updateRelatedCTE(ccelist);
        BFM_CceHandlerActions.getListInsertSize(ccelist);
        BFM_CceHandlerActions.getListDeleteSize(ccelist);
        BFM_CceHandlerActions.getCceCteListsSizes();
        Test.stopTest();
        
    }
}