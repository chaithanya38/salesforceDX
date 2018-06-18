@isTest
private class BFM_CCeHandler_Test{
    private static testMethod void testBFM_CCeHandler(){
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
        
        //   BFM_CT_e__c  cte = new BFM_CT_e__c();
        //   cte.Carrier_Account__c=acc.id;
        //  cte.Name='CTE-00025555';
        //    cte.CT_e_key__c='35161210449909000509570030002300021034523214';
        //    insert cte;
        
        
        //   List<BFM_Ct_e__c> cte = new List<BFM_Ct_e__c>();
        
        String json = '{ "validateFiscalDocumentResponse": { "cce": [ { "accessKey": "42170382809088000232570010000032721000032721", "validationMessage": "Autorizado o uso do CT-e", "validationStatusCode": "100" } ] } } ';
        Test.setMock(HttpCalloutMock.class, new BFM_MockPodHttpResponse(json)); 
        
        BFM_CT_e__c cte= new BFM_CT_e__c(Carrier_Account__c=acc.Id, CT_e_key__c='54354364565465', Unilever_Account__c=acc.Id,
                                         CNPJ_issuer__c='3258458',CNPJ_Service_Taker__c='43645645',UF_Destination__c='BR',
                                         UF_Goods_Sender__c='SP',Vehicle_Plate__c='4385943',Cte_Emission_date_time__c = system.now());
        
        insert cte;
        
        
        BFM_NF_e_DF__c nfe = new BFM_NF_e_DF__c();
        nfe.Carrier_Account__c=acc.id;
        nfe.NF_e_key__c = '123456789012122';
        //  nfe.Name='NFE00025555';
        insert nfe;
        
        List<BFM_CC_e__c> cceRecords = new List<BFM_CC_e__c> ();
        cceRecords.add(new BFM_CC_e__c(CNPJ_Issuer__c='01615814006487',CC_e_emission_date__c =system.today(),CC_e_Key__c = '35161210449909000509570030002300021034523213'/*CC_e_Link_Check_Status__c='Approved'*/,Cce_Status_c__c='ret',Cce_Status_description__c='testdata',Carrier_Account__c=acc.id,City_Code_Service_Taker__c='data',City_Service_Taker_del__c='data1',CNPJ_Service_Taker_del__c='data2',CTe__c=cte.id,Event__c='data3',Is_Company_Code_Ok__c=false,Is_published_on_GRC__c=true,Is_Vendor_Code_Ok__c=true,Manual_Sefaz_Date_Check__c=system.today(),NF_e_DF__c=nfe.id,Sefaz_Request_Date__c=system.today())); 
        cceRecords.add(new BFM_CC_e__c(CNPJ_Issuer__c='01615814006487',CC_e_emission_date__c =system.today(),CC_e_Key__c = '35161210449909000509570030002300021034523214'/*CC_e_Link_Check_Status__c='Pending'*/,Cce_Status_c__c='ret',Cce_Status_description__c='testdata1',Carrier_Account__c=acc.id,City_Code_Service_Taker__c='data7',City_Service_Taker_del__c='data6',CNPJ_Service_Taker_del__c='data5',CTe__c=cte.id,Event__c='data4',Is_Company_Code_Ok__c=true,Is_published_on_GRC__c=false,Is_Vendor_Code_Ok__c=false,Manual_Sefaz_Date_Check__c=system.today(),NF_e_DF__c=nfe.id,Sefaz_Request_Date__c=system.today())); 
        insert cceRecords;
        system.debug('----->111'+cceRecords);
        BFM_CTeHandler.recursiveBefore = false;
        BFM_CTeHandler.recursiveAfter = false;
        cceRecords[0].CNPJ_Issuer__c='01615814006488';
        update cceRecords[0];
        system.debug('----->222'+cceRecords[0]);
        
        oldMapRecords.put(cceRecords[0].id,cceRecords[0]);
        newMapRecords.put(cceRecords[0].id,cceRecords[0]);
        
        List<BFM_CC_e__c> UpdatedcceRecords = new List<BFM_CC_e__c>();
        for(BFM_CC_e__c bc : cceRecords)
        {
            bc.City_Code_Service_Taker__c='data7';
            UpdatedcceRecords.add(bc);
        }
        update UpdatedcceRecords;
        
        delete UpdatedcceRecords[0];
        
        
        BFM_CCeHandler bfmc = new BFM_CCeHandler();
        BFM_CCeHandlerActions.linkCceToCteOrNfeDf(cceRecords);   
        //BFM_CTeHandlerActions.defineUnileverAccount(UpdatedCteRecords); 
        


        
        System.debug('===cceRecords' + cceRecords.size());
        
        bfmc.beforeInsert(cceRecords[0]);
        bfmc.beforeUpdate(cceRecords[0],cceRecords[0]);
        bfmc.beforeDelete(cceRecords[0]);
        bfmc.afterInsert(cceRecords[0]);
        bfmc.afterUpdate(cceRecords[0],cceRecords[0]);
        bfmc.afterDelete(cceRecords[1]);
        bfmc.andFinally();
        

        
      
        
        test.stoptest();
        
    }
}