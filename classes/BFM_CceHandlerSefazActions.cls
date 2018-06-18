public without sharing class BFM_CceHandlerSefazActions {
    
    /*
* Class name : checkSEFAZManually
* Description : Check the emission date from the fiscal document is greater than 6 months, if yes the user must check SEFAZ manually
*/
    public static void checkSEFAZManually(List<BFM_CC_e__c> cceRecords){        
        
        for(BFM_CC_e__c cce: cceRecords){
            if(cce.CC_e_emission_date__c != null ){
                
                Date cceEmissionDate = date.newinstance(cce.CC_e_emission_date__c.year(), cce.CC_e_emission_date__c.month(), cce.CC_e_emission_date__c.day());
                Date sixMonthsBeforeCceInsertDate = Date.today().addDays(-180);                 
                
                System.debug('BFM_CceHandlerSefazActions.checkSEFAZManually.nfedfEmissionDate >>> '  + cceEmissionDate);
                System.debug('BFM_CceHandlerSefazActions.checkSEFAZManually.sixMonthsBefore >>> '  + sixMonthsBeforeCceInsertDate);                
                
                cce.CC_e_6_Months__c = false;
                if(cceEmissionDate < sixMonthsBeforeCceInsertDate) {
                    cce.CC_e_6_Months__c = true;
                }                
            }else { //TODO: remove else
                cce.CC_e_6_Months__c = true;
            }
            System.debug('===cce.CC_e_6_Months__c ' + cce.CC_e_6_Months__c );
        }
    }    
    
    public static void checkSefazStatus(List<BFM_CC_e__c> cceRecords, Map<Id, SObject> oldMapRecords){        
        
        System.debug('BFM_CceHandlerSefazActions.checkSefazStatus()');
        Set<Id> cceIds = new Set<Id>();
        Set<Id> cceIdValidation = new Set<Id>();
        //Set<Id> cceIdValidation = new Set<Id>();
        for(BFM_CC_e__c cce : cceRecords) {
            
            // validate if GRC is update case yes we change de return date
            if(!cce.CC_e_6_Months__c && oldMapRecords.get(cce.Id).get('Sefaz_Check_Status__c') != cce.Sefaz_Check_Status__c){
                cce.Sefaz_Return_Date__c = System.now();
            }
            
            //validate check manually
            if(cce.SEFAZ_Return_Status__c != null) {
                if(cce.SEFAZ_Return_Status__c.equalsIgnoreCase('Nro. de tentativas excedido. Por favor, consulte a SEFAZ manualmente') || 
                   cce.SEFAZ_Return_Status__c.equalsIgnoreCase('Maximum attempts, manually check document in SEFAZ') || 
                   cce.SEFAZ_Return_Status__c.equalsIgnoreCase('Number of attempts already exceeds the limit. Please check this manually.') ||
                   cce.SEFAZ_Validation_Failed__c) {
                       cce.CC_e_6_Months__c = true;
                       cce.SEFAZ_Validation_Failed__c = true;
                   }
            }
            
            if(cce.SEFAZ_Validation_Failed__c && oldMapRecords.get(cce.Id).get('Sefaz_Check_Status__c') != cce.Sefaz_Check_Status__c && cce.Sefaz_Check_Status__c != null){
                cceIdValidation.add(cce.Id);             
            
            //check if manually sefaz is true and has change on Sefaz_Check_Status__c field case yes should be published 
            } else if(cce.CC_e_6_Months__c && oldMapRecords.get(cce.Id).get('Sefaz_Check_Status__c') != cce.Sefaz_Check_Status__c && cce.Sefaz_Check_Status__c != null) {
                
                cce.User_Manual_Sefaz_Check__c = UserInfo.getUserId();
                cce.Manual_Sefaz_Date_Check__c = System.now();
                cce.Sefaz_Request_Date__c = datetime.now();
                cceIds.add(cce.Id);
                
            }
        } 
        
        if(!System.isBatch() && !System.isFuture()) {
            
            if(cceIdValidation.size() > 0){
                validationCCEtoSefaz(cceIdValidation);
            }
            
            if(cceIds.size()>0){
                publishCCEtoSefaz(cceIds);
            }
            
        }
        
    }    
    
    public static void sendCCetoSefaz(List<BFM_CC_e__c> cceRecords) {
        System.debug('BFM_CceHandlerSefazActions.checkSefazStatus()');
        Set<Id> cceIds = new Set<Id>();
        for(BFM_CC_e__c cce : cceRecords) {
            if(!cce.CC_e_6_Months__c) {
                cceIds.add(cce.Id);
            }
        }
        publishCCEtoSefaz(cceIds);
    }
    
    @future(callout=true)
    public static void validationCCEtoSefaz(Set<Id> cceIds) {
        
        List<BFM_CC_e__c> lstCCeToUpdate = new List<BFM_CC_e__c>();
        List<BFM_Error_Log__c> lstError = new List<BFM_Error_Log__c>();
        
        list<BFM_CC_e__c> listCCe = [SELECT id, CC_e_Key__c, External_File_Path__c, 
                                     CC_e_6_Months__c, Sefaz_Check_Status__c 
                                     FROM BFM_CC_e__c WHERE id =: cceIds];
        
        if(listCCe.size() > 0){
            
            for(BFM_CC_e__c cce: listCCe){
                
                String objectType = 'CCE';
                String accessKey = cce.CC_e_Key__c;
                String validationCode = cce.Sefaz_Check_Status__c;
                String validationMessage = getValidationMessage(validationCode); 
                
                HttpResponse response = BFM_GeneralServiceCalls.publishFiscalDocuments(objectType, accessKey, validationCode, validationMessage);
                
                if(response.getStatusCode() == 200 || response.getStatusCode() == 201) {
                    
                    BFM_CC_e__c newCCe = new BFM_CC_e__c();
                    newCCe.Id = cce.Id;
                    newCCe.Sefaz_Request_Date__c = datetime.now();
                    
                    JSONParser parser = JSON.createParser(response.getBody());
                    system.debug('parser:'+parser);
                    while (parser.nextToken() != null) {
                        system.debug('JSONToken.FIELD_NAME:'+JSONToken.FIELD_NAME);
                        system.debug('parser.getCurrentToken():'+parser.getCurrentToken());
                        system.debug('parser.getText():'+parser.getText());
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'errorMessageCode')) {
                            
                            parser.nextToken();
                            
                            string errorMessageCode = parser.getText();                            
                            errorMessageCode = errorMessageCode.trim();
                            
                            if(errorMessageCode == '1' || errorMessageCode == '001'){
                                
                                newCCe.Is_published_on_GRC__c = true;
                                newCCe.SEFAZ_Return_Status__c = validationMessage;
                                newCCe.User_Manual_Sefaz_Check__c = UserInfo.getUserId();
                                newCCe.Manual_Sefaz_Date_Check__c = System.now();
                                newCCe.Sefaz_Request_Date__c = datetime.now();
                            } 
                        }
                    }
                    
                    lstCCeToUpdate.add(newCCe);
                    
                } else {
                    BFM_Error_Log__c error = new BFM_Error_Log__c();
                    error.Error_Log__c = response.getStatus();
                    error.Reason__c = String.valueOf(response.getStatusCode());
                    error.BFM_CC_e__r = new BFM_CC_e__c(CC_e_Key__c = cce.CC_e_Key__c);
                    lstError.add(error);
                }
                
                system.debug('----- ' + lstCCeToUpdate); 
                
                if(lstCCeToUpdate.size() > 0) {
                    BFM_TriggerHelper.updateObjectListTriggerDisabled(lstCCeToUpdate);
                }
            }    
            if(lstError.size() > 0){
                upsert lstError;
            }
        }
    }
    
    /**
* Method name : sendCCEtoSefaz
* Description : Publish XML only if the 6 months validation is Ok
* @param  Set<Id> cceIds as future callout allows only Sets
*/
    @future(callout=true)
    public static void publishCCEtoSefaz(Set<Id> cceIds) {
        System.debug('BFM_CceHandlerSefazActions.publishCCEtoSefaz()');
        System.debug('BFM_CceHandlerSefazActions.cceIds >>> ' + cceIds);
        
        BFM_Mulesoft_Endpoint__mdt customSettingEndpoint = [SELECT BFM_Host_Amazon__c,BFM_AmazonBucketName__c 
                                                            FROM BFM_Mulesoft_Endpoint__mdt 
                                                            WHERE QualifiedAPIName = 'BFM_Amazon_S3' LIMIT 1];
        
        String bucketname = customSettingEndpoint.BFM_AmazonBucketName__c;
        String host = customSettingEndpoint.BFM_Host_Amazon__c;
        
        String aURL = 'https://' + bucketname + '.' + host+'/';
        System.debug('BFM_CceHandlerSefazActions.aURL >>> ' + aURL);
        
        List<BFM_CC_e__c> lstCCeToUpdate = new List<BFM_CC_e__c>();
        
        for(BFM_CC_e__c cce: [SELECT id, CC_e_key__c, External_File_Path__c, CC_e_6_Months__c, Sefaz_Check_Status__c FROM BFM_CC_e__c WHERE id IN : cceIds]) {
            
            System.debug('BFM_CceHandlerSefazActions.publishCCEtoSefaz.cce >>> ' + cce);
            String xmlBody = BFM_AmazonConnector.getFile(aURL+cce.External_File_Path__c);
            String accessKey = cce.CC_e_key__c;
            
            //HttpResponse response = null;
            HttpResponse response = BFM_GeneralServiceCalls.publishXMLforValidation(xmlBody,accessKey);
            
            System.debug('BFM_CceHandlerSefazActions.publishCCEtoSefaz.response.getStatusCode() >>> ' + response.getStatusCode());
            if(response.getStatusCode() == 200 || response.getStatusCode() == 201) {
                BFM_CC_e__c newCCe = new BFM_CC_e__c();
                newCCe.Id = cce.Id;
                newCCe.Sefaz_Request_Date__c = datetime.now();
                lstCCeToUpdate.add(newCCe);
            } else {
                BFM_Error_Log__c error = new BFM_Error_Log__c();
                error.Error_Log__c = response.getStatus();
                error.Reason__c = String.valueOf(response.getStatusCode());
                error.BFM_CC_e__r = new BFM_CC_e__c(CC_e_key__c = cce.CC_e_key__c);
            }
            
        }
        
        System.debug('BFM_CceHandlerSefazActions.publishCCEtoSefaz.lstCCeToUpdate >>> ' + lstCCeToUpdate);
        if(lstCCeToUpdate.size() > 0) {
            BFM_TriggerHelper.updateObjectListTriggerDisabled(lstCCeToUpdate);
        }
        
    }       
    
    public static String getValidationMessage(String SefazCheckStatus){
        
        string message = '';
        
        if ( SefazCheckStatus == '135' ) {
            message = 'Evento registrado e vinculado a CT-e';
        } else if ( SefazCheckStatus == '136' ) {
            message = 'Evento registrado, mas não vinculado a CT-e';
        } else if ( SefazCheckStatus == '109' ) {
            message = 'Serviço paralisado SEFAZ';
        } else if ( SefazCheckStatus == '110' ) {
            message = 'Uso Denegado SEFAZ';
        } else if ( SefazCheckStatus == '494' ) {
            message = 'Rejeição: Chave de Acesso inexistente';
        } else if ( SefazCheckStatus == '999' ) {
            message = 'Erro SEFAZ';
        }
        
        return message;
    }
    
}