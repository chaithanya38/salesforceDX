@isTest
private class BFM_CheckPod_Test {
    static testmethod void checkpodtest(){

        List<BFM_CT_e__c> ctelist = new List<BFM_CT_e__c>();
        List<BFM_NF_e__c> nfelist = new List<BFM_NF_e__c>();
        List<BFM_POD__c> podlist = new List<BFM_POD__c>();
        List<BFM_Debit_Note__c> dbnlist = new List<BFM_Debit_Note__c>();
        List<BFM_NF_e_DF__c> nfdflist = new List<BFM_NF_e_DF__c>();
        Account acccte = new Account(Name = 'TOMBINI & CIA LTDA',BFM_CNPJ__c = '82809088000666',BFM_Company_Code__c='4235',BFM_Carrier_Region__c='BR');
        acccte.recordtype=new recordtype(name='Carrier');
        insert acccte;
        
        system.assertEquals('TOMBINI & CIA LTDA', acccte.Name);
        BFM_ToleranceMargin__c tm = new BFM_ToleranceMargin__c();
        tm.Name = 'Tolerance_limit';
        tm.Company_Code__c = '2236';
        tm.Tolerance_Percentage_Value__c = 5;
        insert tm;
        
        BFM_AbsoluteConsideration__c abs = new BFM_AbsoluteConsideration__c();
        abs.Name = 'Abs_consideration';
        abs.AbsoluteConsideration_Value__c = 5000;
        insert abs;
        BFM_CT_e__c cte = new BFM_CT_e__c(Carrier_Account__c=acccte.Id, CT_e_key__c='54354364565465', Unilever_Account__c=acccte.Id,
                                          CNPJ_issuer__c='3258458',CNPJ_Service_Taker__c='43645645',UF_Destination__c='BR',Cte_Emission_date_time__c=system.now(),
                                          UF_Goods_Sender__c='SP',Vehicle_Plate__c='4385943',Is_Company_Code_Ok__c=true,Is_Vendor_Code_Ok__c=true, Is_Plant_Code_Matching_Ses__c=true,
                                          Is_Vendor_Code_Matching_Ses__c=true, Is_POD_Reception_Ok__c=true, /*Is_All_Nfes_Linked__c=true,*/
                                          Is_Gross_Value_Validation_Ok__c=true, Is_Tax_Classification_Ok__c=true,Sefaz_Check_Status__c='100');
        ctelist.add(cte);        
        //insert ctelist;
        BFM_TriggerHelper.insertObjectListTriggerDisabled(ctelist);
        
        BFM_SES__c ses = new BFM_SES__c(SES_Number__c='32432');
        insert ses;
        
        BFM_Occurrence__c occdb = new BFM_Occurrence__c(Occurrence_Number__c='testship', Carrier_Account__c=acccte.id);
        insert occdb;
        BFM_Debit_Note__c dbn = new BFM_Debit_Note__c(DN_Number__c='9274325435435435',File_Name__c='testfile',Carrier_Account__c=acccte.id,  
                                                      DN_Emission_date_time__c=system.now(), 
                                                      DN_total_value__c=10.0, Service_Detailed_Info__c='testservice');
        dbnlist.add(dbn);
        insert dbnlist;
        
        BFM_NF_e_DF__c nfdf1 = new BFM_NF_e_DF__c(NF_e_key__c='42433543253543', Carrier_Account__c=acccte.id, /*Taker_Type__c='2',*/
                                                  Is_Plant_Code_Matching_Ses__c=true, Is_POD_Reception_Ok__c=true, Is_All_The_SESs_Linked__c=true,
                                                  Is_Gross_Value_Validation_Ok__c=true, Is_Tax_Classification_Ok__c=true, Sefaz_Check_Status__c='100',
                                                  Is_Vendor_Code_Matching_Ses__c=true);
        nfdflist.add(nfdf1);
        insert nfdflist;
        
        BFM_NF_e__c nfe = new BFM_NF_e__c(NF_e_access_key__c = '543532423', NF_e_number__c='32143243');
        nfelist.add(nfe); 
        insert nfelist;
        
        BFM_POD__c pod = new BFM_POD__c(Carrier_Account__c=acccte.id, Physical_Reception_User__c=userinfo.getUserId(), 
                                        NF_e_Access_Key__c='26170261068276000791550010003984971436313600');
        podlist.add(pod);
        insert podlist;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new BFM_MockHttpResponse());
        
        Test.stopTest();
    }
}