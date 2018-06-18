@isTest
private class BFM_CceHandlerSefazActions_Test {
    public static Map<Id, SObject> oldMapRecs;
    public static Set<Id> cceIdsset =  new Set<Id>();
    public static string SefazStatus = 'sefazcheck';
    static testmethod void ccehandlersefazmethod(){
        
        RecordType unileverAccount  = [SELECT id from RecordType where DeveloperName like '%Carrier' Limit 1];
        Account acc = new Account();
        acc.RecordTypeId = unileverAccount.id;
        acc.Name ='BILECA TRANSP E LOGISTICA LTDA ME';
        acc.BFM_Vendor__c='11';
        insert acc;
        
        List<BFM_CC_e__c> ccelist = new List<BFM_CC_e__c>();
        Map<Id, SObject> cceOldlist = new Map<Id, SObject>();
        
        BFM_CC_e__c cce = new BFM_CC_e__c(CC_e_Key__c='4243354325353', CC_e_6_Months__c =True, Sefaz_Check_Status__c='101', SEFAZ_Return_Status__c='Maximum attempts, manually check document in SEFAZ', CC_e_emission_date__c = date.today()-185, 
                                          SEFAZ_Validation_Failed__c = true,Carrier_Account__c=acc.id);
        ccelist.add(cce);
        
        BFM_CC_e__c cce2 = new BFM_CC_e__c(CC_e_Key__c='4243354325353', CC_e_6_Months__c =True, Sefaz_Check_Status__c='101', SEFAZ_Return_Status__c='Maximum attempts, manually check document in SEFAZ', CC_e_emission_date__c = date.today(), 
                                          SEFAZ_Validation_Failed__c = true,Carrier_Account__c=acc.id);
        cceOldlist.put(cce.Id,cce2);
        
        BFM_CceHandlerSefazActions.checkSEFAZManually(ccelist);
        BFM_CceHandlerSefazActions.checkSefazStatus(ccelist, cceOldlist);
        ccelist[0].CC_e_6_Months__c = true;
        ccelist[0].Sefaz_Check_Status__c = '100';
        BFM_CceHandlerSefazActions.checkSefazStatus(ccelist, cceOldlist);
		SefazStatus = '135';    ///line added for code coverage
        BFM_CceHandlerSefazActions.getValidationMessage(SefazStatus);
        SefazStatus = '136';    ///line added for code coverage
        BFM_CceHandlerSefazActions.getValidationMessage(SefazStatus);
        SefazStatus = '109';    ///line added for code coverage
        BFM_CceHandlerSefazActions.getValidationMessage(SefazStatus);
        SefazStatus = '110';    ///line added for code coverage
        BFM_CceHandlerSefazActions.getValidationMessage(SefazStatus);
        SefazStatus = '494';    ///line added for code coverage
        BFM_CceHandlerSefazActions.getValidationMessage(SefazStatus);
        SefazStatus = '999';    ///line added for code coverage
        BFM_CceHandlerSefazActions.getValidationMessage(SefazStatus);        
    }
    
    static testmethod void ccehandlersefazmethod2(){
        
        
        BFM_TriggerHelper.disableTrigger();
        RecordType unileverAccount  = [SELECT id from RecordType where DeveloperName like '%Carrier' Limit 1];
        
        Account acc = new Account();
        acc.RecordTypeId = unileverAccount.id;
        acc.Name ='BILECA TRANSP E LOGISTICA LTDA ME';
        acc.BFM_Vendor__c='11';
        insert acc;
        system.assertEquals('BILECA TRANSP E LOGISTICA LTDA ME', acc.Name);
        
        BFM_ToleranceMargin__c tm = new BFM_ToleranceMargin__c();
        tm.Name = 'Tolerance_limit';
        tm.Company_Code__c = '2236';
        tm.Tolerance_Percentage_Value__c = 5;
        insert tm;
        
        BFM_AbsoluteConsideration__c abs = new BFM_AbsoluteConsideration__c();
        abs.Name = 'Abs_consideration';
        abs.AbsoluteConsideration_Value__c = 5000;
        insert abs; 
        
        BFM_CC_e__c bcce = new BFM_CC_e__c();
        bcce.Carrier_Account__c = acc.Id;
        bcce.CC_e_Key__c = '1101105016100291626500776855004000045715128092916001';
        insert bcce;
        
        BFM_Error_Log__c errorlog = new BFM_Error_Log__c();
        errorlog.Error_Log__c = 'Response code 400 mapped as failure.';
        errorlog.Reason__c = 'file upload';
        errorlog.BFM_CC_e__c = bcce.Id;
        insert errorlog;
        
        String namedCredential = 'My_Named_Credential';
        String path = '/some/path';
        String uri;
        if(Test.isRunningTest()) {
            uri = 'http://callout.' + namedCredential + '.com' + path; 
        } else {
            uri = 'callout:' + namedCredential + path;
        }
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(uri);
        //String json = '{ "validateFiscalDocumentResponse": { "cte": [ { "accessKey": "42170382809088000232570010000032721000032721", "validationMessage": "Autorizado o uso do CT-e", "validationStatusCode": "100" } ] } } ';
    
        
        
        List<BFM_CC_e__c> ccelist = new List<BFM_CC_e__c>();
        BFM_CC_e__c cce = new BFM_CC_e__c(CC_e_Key__c='4243354325353', CC_e_6_Months__c =True, Sefaz_Check_Status__c='101', SEFAZ_Return_Status__c='Maximum attempts, manually check document in SEFAZ', CC_e_emission_date__c = date.today(), 
                                          SEFAZ_Validation_Failed__c = true,Carrier_Account__c=acc.id);
        ccelist.add(cce);
        insert ccelist;
        
        cceIdsset = new Set<Id>();
        cceIdsset.add(ccelist[0].Id);
        
        Map<Id, SObject> oldMap = new Map<Id, SObject>();
        oldMap.put(cce.Id, cce);
        
        BFM_CC_e__c cce1 = new BFM_CC_e__c(Carrier_Account__c=acc.id);
        insert cce1;
        BFM_TriggerHelper.disableTrigger();
        Test.startTest();
        String json = '{ "validateFiscalDocumentResponse": { "cte": [ { "accessKey": "42170382809088000232570010000032721000032721", "validationMessage": "Autorizado o uso do CT-e", "validationStatusCode": "100","errorMessageCode":"1" } ] } } ';
        //BFM_CceHandlerSefazActions ccesefaz = new BFM_CceHandlerSefazActions();
        Test.setMock(HttpCalloutMock.class, new BFM_MockHttpResponse(json));
        BFM_CceHandlerSefazActions.publishCCEtoSefaz(cceIdsset);
        BFM_CceHandlerSefazActions.getValidationMessage(SefazStatus);
        BFM_CceHandlerSefazActions.sendCCetoSefaz(ccelist);
        BFM_CceHandlerSefazActions.validationCCEtoSefaz(cceIdsset);
        if(ccelist.size()>0){
            ccelist[0].CC_e_6_Months__c =False;    
        }
        Test.stopTest();
    }
    static testmethod void parseJSONString() {
    Test.startTest();
        RecordType unileverAccount  = [SELECT id from RecordType where DeveloperName like '%Carrier' Limit 1];
        Account acc = new Account();
        acc.RecordTypeId = unileverAccount.id;
        acc.Name ='BILECA TRANSP E LOGISTICA LTDA ME';
        acc.BFM_Vendor__c='11';
        insert acc;
        
        List<BFM_CC_e__c> ccelist1 = new List<BFM_CC_e__c>();
        BFM_CC_e__c cce = new BFM_CC_e__c(CC_e_Key__c='4243354325353', CC_e_6_Months__c =True, Sefaz_Check_Status__c='101', SEFAZ_Return_Status__c='Number of attempts already exceeds the limit. Please check this manually', CC_e_emission_date__c = date.today(), 
                                          SEFAZ_Validation_Failed__c = true,Carrier_Account__c=acc.id);
        ccelist1.add(cce);
        
    /*String jsonStr = '{ "validateFiscalDocumentResponse": { "cte": [ { "accessKey": "42170382809088000232570010000032721000032721", "validationMessage": "Autlozudio", "validationStatusCode": "100", "errorMessageCode":"001" } ] } } ';
    Test.setMock(HttpCalloutMock.class, new BFM_MockHttpResponseGenerator(jsonStr));
         JSONParser parser = JSON.createParser(jsonStr);
                while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&  (parser.getText() == 'errorMessageCode' )) {          
                    break;
                    }
                }*/
    
    BFM_CceHandlerSefazActions.validationCCEtoSefaz(cceIdsset);
    Test.stopTest();
    }
}