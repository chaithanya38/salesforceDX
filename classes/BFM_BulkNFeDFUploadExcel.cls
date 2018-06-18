global class BFM_BulkNFeDFUploadExcel implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts{

    public map<String,String[]> mapUpload = new map<String,String[]>();
    global list<String> listRecords = new list<String>();
    global map<String, string> mapRecordsError = new map<String, string>();
   
    global Database.Querylocator start( Database.BatchableContext BC ){
                             
        return Database.getQueryLocator([SELECT ID, Tax_Code_id__c, Last_Tax_Classification_Update__c,
                                         Last_User_To_Update_Tax__c, Is_Tax_Classification_Ok__c,
                                         Carrier_Account__r.BFM_Tax_Jurisdiction__c                                                                                            
                                         FROM BFM_NF_e_DF__c WHERE ID IN: mapUpload.keySet()]);    
    }
    
    global void execute( Database.BatchableContext BC, List<sObject> scope ){
       
       list<BFM_NF_e_DF__c > listNFeDF = (list<BFM_NF_e_DF__c >) scope;
       
       for(BFM_NF_e_DF__c NFeDF: listNFeDF){ 
            
            try{
                   
               string id = NFeDF.id;
               id = id.substring(0,15);
                      
               string[] inputExcel = mapUpload.get(id);           
               string taxCode = inputExcel[1];  
                           
               executeClassification(NFeDF, taxCode);
               updateNFeDF(NFeDF, taxCode);
               listRecords.add(id);
               
            }
            catch(Exception e){
                mapRecordsError.put(NFeDF.id, e.getMessage());
            }                
       }
        
    }
    
    public static void updateNFeDF(BFM_NF_e_DF__c NFeDF, string taxCode){
        
        taxCode = taxCode.left(2);
        
        NFeDF.Tax_Code_id__c = taxCode;
        
        DataBase.update(NFeDF, false);
        
    } 
    
    public static void executeClassification(BFM_NF_e_DF__c NFeDF, string taxCode){
      
        list<BFM_Miro_Header__c> listMiro = [SELECT id, Total_Amount__c, ICMS_Amount__c, ICMS_Base_Value__c,Invoice_Date__c,Invoice_Serie_Number__c, Miro_Requested_Date__c, Company_Code__c, Reference_Number__c,
                                             Vendor_Code__c,
                                             (SELECT FRS__c, SES_Net_Value__c, SES_Net_Value_Miro__c, COFINS_Aliquot__c,
                                              Access_Key__c, Tax_Code__c, Miro_Header__r.Company_Code__c, Gross_Value_net_tax__c, SES_ICMS_Base_Miro__c, SES_ICMS_Miro__c,
                                              ICMS_Value__c, SES_Total_Value_Miro__c, FRS__r.Ses_Number__c,
                                              Miro_Header__r.Vendor_Code__c, PIS_Aliquot__c FROM BFM_MIRO_Items__r) FROM BFM_Miro_Header__c
                                             WHERE NF_e_DF__c =: NFeDF.Id LIMIT 1];
        if(listMiro.size() > 0){         
                  
            taxCode = taxCode.left(2);
            
            List<BFM_MIRO_Item_Tax__c> taxClassificationList = BFM_Querytax.queryTaxFuture(listMiro, 'BFM_NF_e_DF__c', BFM_QueryTax.NFEDF_NFCATEGORY, NFeDF.id, taxCode,
                                                                                              NFeDF.Carrier_Account__r.BFM_Tax_Jurisdiction__c, BFM_QueryTax.TYPE_NFEDF);
         
            if(taxClassificationList.size() > 0) {
            
                NFeDF.Last_Tax_Classification_Update__c = System.now();
                NFeDF.Last_User_To_Update_Tax__c = UserInfo.getUserId();
                NFeDF.Is_Tax_Classification_Ok__c = true;
                                
                DataBase.update(NFeDF, false);
                DataBase.insert(taxClassificationList, false);
            }
                      
        }
    }
    
    public list<BFM_NF_e_DF__c> getRecords(){
        
        list<BFM_NF_e_DF__c> listNFDF= new list<BFM_NF_e_DF__c>();
   
        try{
            
            listNFDF = [SELECT Id, Name, Tax_Code_id__c, NF_e_key__c,
                       (SELECT Error_log__c FROM Error_Logs__r Order By CreatedDate desc LIMIT 1)
                       FROM BFM_NF_e_DF__c 
                       WHERE ID IN: listRecords
                       AND Is_Tax_Classification_Ok__c = false];
            
        }
        catch(Exception e){
            system.debug(e);
        }
        
        return listNFDF;
    
    }

    global void finish( Database.BatchableContext bcMain ){
 		       
        string excel = '';
        
        AsyncApexJob a = [Select Id, Status,ExtendedStatus,NumberOfErrors, JobItemsProcessed,
        TotalJobItems, CreatedBy.Email
        from AsyncApexJob where Id =:bcMain.getJobId()];
   
        list<BFM_NF_e_DF__c> listNFeDF = getRecords();
        
        if(listNFeDF.size() > 0){
            
            excel = excel + 'NF-e DF ID, TAX CODE, ERRO, NUMERO INTERNO, CHAVE DE ACESSO, ERRO INTERNO' + '\n';
            
            for(BFM_NF_e_DF__c nfedf: listNFeDF){
           
                if(nfedf.Error_Logs__r.size() > 0){
                    
                    for(BFM_Error_Log__c error: nfedf.Error_Logs__r){
                    	                        
                        excel = excel + nfedf.Id + ',';
                        
                        if(nfedf.Tax_Code_id__c != null)
                            excel = excel + nfedf.Tax_Code_id__c + ',';
                        else{
                           excel = excel + ','; 
                        }
						
                        System.debug('===nfedf.NF_e_key__c' + nfedf.NF_e_key__c);
                            
                        excel = excel + error.Error_log__c + ',';
                        excel = excel + nfedf.Name + ',';
                        excel = excel + nfedf.NF_e_key__c + ',';
                        
                        
                        if(mapRecordsError.containsKey(nfedf.Id)){
                            excel = excel +  mapRecordsError.get(nfedf.Id) ;
                        }
                        else{
                            excel = excel + '';
                        }
                        
                        excel = excel +'\n'; 
                    }                    
                }
            }            
        }
        
        Messaging.EmailFileAttachment csv = new Messaging.EmailFileAttachment();
        blob xlsxBlob = Blob.valueOf(excel);        
        csv.setFileName('TaxClassification.csv');
        csv.setBody(xlsxBlob);
        csv.setContentType('text/csv');  
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};
        mail.setToAddresses(toAddresses);        
        mail.setSubject('NF-e DF - Tax Classification: ' + a.Status);
		
        string body = 'Total de registros carregados no arquivo: ' + listRecords.size() +'\n';
        body = body + 'Total de registros com falha interna: ' + mapRecordsError.size() +'\n';
        body = body + 'Total de registros não classificados: ' + listNFeDF.size() +'\n';
               
        mail.setPlainTextBody(body);
        
        if(listNFeDF.size() > 0){
        	mail.setFileAttachments(new Messaging.EmailFileAttachment[]{csv});            
    	}
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});    
        
    }
}