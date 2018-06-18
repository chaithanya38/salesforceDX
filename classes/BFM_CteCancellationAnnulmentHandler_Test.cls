@isTest
public class BFM_CteCancellationAnnulmentHandler_Test {
    
    private static testMethod void TestCNPJvalidationTEST(){
        
        Id AccRecordTypeId = [Select Id, Name from RecordType where Name = 'Carrier'].Id;
        Account acc = new Account(Name = 'Test Account', RecordTypeId = AccRecordTypeId);
        insert acc;   

        BFM_ToleranceMargin__c objBFMToleranceMargin = new BFM_ToleranceMargin__c ();
        objBFMToleranceMargin.Company_Code__c='2236';
        objBFMToleranceMargin.Tolerance_Percentage_Value__c=5;
        objBFMToleranceMargin.Name='Tolerance_limit';
        insert objBFMToleranceMargin ;

        BFM_AbsoluteConsideration__c objBFMAbsoluteConsideration =new BFM_AbsoluteConsideration__c ();
        objBFMAbsoluteConsideration .name= 'Abs_consideration';
        objBFMAbsoluteConsideration .AbsoluteConsideration_Value__c =5000;
        insert objBFMAbsoluteConsideration ;
        Map<Id, SObject> oldMapRecords = new Map<Id, SObject>();
        Test.startTest();
        String json = '{ "validateFiscalDocumentResponse": { "cte": [ { "accessKey": "42170382809088000232570010000032721000032721", "validationMessage": "Autorizado o uso do CT-e", "validationStatusCode": "100" } ] } } ';
        Test.setMock(HttpCalloutMock.class, new BFM_MockPodHttpResponse(json)); 
        
        List<BFM_CT_e__c> cteRecords = new List<BFM_CT_e__c>();
        cteRecords.add(new BFM_CT_e__c (Unilever_Account__c=acc.id,Cte_Emission_date_time__c = system.now(),CT_e_key__c='35360805574135000120570021001115021001115029',
                                        CT_e_Request_for_Annulment__c=TRUE,Is_Company_Code_Ok__c=true, Is_Vendor_Code_Ok__c=true, Is_Vendor_Code_Matching_Ses__c=true, 
                                        Is_Plant_Code_Matching_Ses__c=true, Is_POD_Reception_Ok__c=true, Is_Tax_Classification_Ok__c=true, Sefaz_Check_Status__c = '200', 
                                        Is_published_on_GRC__c=true, CT_e_Request_for_Cancel__c=true, Carrier_Account__c=acc.id,CC_e_Key__c='351612104'));
        
        insert cterecords ;
        
        List<BFM_MIRO_Header__c> lstMIRO = new List<BFM_MIRO_Header__c> ();
        lstMIRO.add(new BFM_MIRO_Header__c(Annulment_Fiscal_Posting_Date__c=NULL,Access_Key__c='35161282809088000666570250000137791000137792',Miro_Requested_Date__c=system.today(),
                                           Cancellation_Posting_Date__c=null,Annulment_Flag__c=false,Cancellation_Flag__c=false,CT_e__c=cteRecords[0].id));
        insert lstMIRO ;
        
        oldMapRecords.put(cteRecords[0].id,cteRecords[0]);
        
        BFM_CteCancellationAnnulmentHandler.annulMiro(cteRecords[0].id,'test');
        BFM_CteCancellationAnnulmentHandler.taxRequired(cteRecords[0].id);
        BFM_CteCancellationAnnulmentHandler.cancelMiro(cteRecords);
        BFM_CteCancellationAnnulmentHandler.cancelMiro(cteRecords,oldMapRecords);
        BFM_CteCancellationAnnulmentHandler.checkPermissionSetAssignment(cteRecords[0].id);
        Test.stopTest();
    }
    
}