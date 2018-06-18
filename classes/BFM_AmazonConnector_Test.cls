@isTest
private class BFM_AmazonConnector_Test {
    public static BFM_Percentage_Values__mdt PercentsValues;
    public static string prid;
    static testmethod void amazonconnectortest(){
        Account accdbn = new Account(Name = 'JSL S A',BFM_CNPJ__c = '52548435019783',BFM_Company_Code__c='4235',BFM_Carrier_Region__c='BR');
        accdbn.recordtype=new recordtype(name='Carrier');
        insert accdbn;
        system.assertEquals('JSL S A', accdbn.Name);
        BFM_ToleranceMargin__c tm = new BFM_ToleranceMargin__c();
        tm.Name = 'Tolerance_limit';
        tm.Company_Code__c = '2236';
        tm.Tolerance_Percentage_Value__c = 5;
        insert tm;
        
        BFM_AbsoluteConsideration__c abs = new BFM_AbsoluteConsideration__c();
        abs.Name = 'Abs_consideration';
        abs.AbsoluteConsideration_Value__c = 5000;
        insert abs;
        
        PercentsValues = [SELECT Cofins_Percent__c,PIS_Percent__c FROM BFM_Percentage_Values__mdt  WHERE QualifiedAPIName = 'Percent_Values' LIMIT 1];
        
        BFM_Occurrence__c occdb = new BFM_Occurrence__c(Occurrence_Number__c='testship', Carrier_Account__c=accdbn.id);
        insert occdb;
        BFM_Debit_Note__c dbn = new BFM_Debit_Note__c(DN_Number__c='4545',File_Name__c='20161122151000_NFS_JSL_RIO_00188936.pdf',Carrier_Account__c=accdbn.id,  
                                                      DN_Emission_date_time__c=system.now(), 
                                                      DN_total_value__c=1.000, Service_Detailed_Info__c='uy');
        insert dbn;
        system.debug('--->debitnote'+dbn);
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId = dbn.id;    
        attach.contentType = 'application/pdf';
        insert attach;    
        System.assertEquals(dbn.id,attach.parentId);
        
        prid=attach.Id;
        
        BFM_AmazonConnector amazoncon = new BFM_AmazonConnector();
        amazoncon.sendFile(attach, '82809088000543', 'filename', 'DebitNote');
        amazoncon.sendFile(attach, '82809088000981', 'filename1', 'PODReceipt');
        amazoncon.sendFile(attach, '82809088000037', 'filename2', 'gnre');
        Test.startTest();
         String json = '{ "Response": { "cte": [ { "accessKey": "42170382809088000232570010000032721000032721", "validationMessage": "Autorizado o uso do CT-e", "validationStatusCode": "100" } ] } } ';
        Test.setMock(HttpCalloutMock.class, new BFM_MockHttpResponse(json));
        String url = 'https://file-mgmt-qa-v1.eu.cloudhub.io/api/freight_document/pod';
        BFM_AmazonConnector.getFile(url);
        BFM_AmazonConnector.getBlobFile(url);
        BFM_AmazonConnector.getPDFFile(url,'pid','fileName3');
        BFM_AmazonConnector.getPODFile(url,'82809088000710','fileName4');
        //BFM_AmazonConnector.insertAttachment(Blob.ValueOf('filename'),prid,'fileName3');
        BFM_AmazonConnector.deleteAttachment(attach.id);
        BFM_AmazonConnector.getNFSFile(url,'pid','fileName3');
        Test.stopTest();
    }
}