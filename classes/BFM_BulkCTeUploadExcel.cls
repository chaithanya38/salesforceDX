global class BFM_BulkCTeUploadExcel implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
        
    public map<String,String[]> mapUpload = new map<String,String[]>();
    public list<Database.SaveResult> results = new list<Database.SaveResult>();    
    global list<String> listRecords = new list<String>();
    global map<String, string> mapRecordsError = new map<String, string>();

    global Database.Querylocator start( Database.BatchableContext BC ){
                             
        return Database.getQueryLocator([SELECT ID, Tax_Code_id__c, Last_Tax_Classification_Update__c,
                                                Last_User_To_Update_Tax__c, Is_Tax_Classification_Ok__c,
                                                Carrier_Account__r.BFM_Tax_Jurisdiction__c, CFOP_List__c                                                                                            
                                         FROM BFM_CT_e__c WHERE ID IN: mapUpload.keySet()]);    
    }
    
    global void execute( Database.BatchableContext BC, List<sObject> scope ){
   
        list<BFM_CT_e__c > listCTe = (list<BFM_CT_e__c >) scope;
        
        for(BFM_CT_e__c CTe: listCTe){
            
            try{
            
                string id = CTe.id;
                id = id.substring(0,15);
                
                string[] inputExcel = mapUpload.get(id);           
                string taxCode = inputExcel[1];    
                string CFOP = inputExcel[2];
                
				listRecords.add(id);
                
                executeClassification(CTe, taxCode, CFOP);
                updateCTE(CTe, taxCode, CFOP);
                
            }
            catch(Exception e){
                mapRecordsError.put(CTe.id, e.getMessage());
            }
        }
        
    }
    
    public static void updateCTE(BFM_CT_e__c CTe, string taxCode, string CFOP){
        
        CTe.Tax_Code_id__c = taxCode;
        CTe.CFOP_List__c = CFOP;        
        
        DataBase.update(cte, true);
      
    } 
    
    public static void executeClassification(BFM_CT_e__c CTe, string taxCode, string CFOP){
      
        list<BFM_Miro_Header__c> listMiro = [SELECT id, Total_Amount__c, ICMS_Amount__c, ICMS_Base_Value__c,
                                                    Invoice_Date__c,Invoice_Serie_Number__c, Miro_Requested_Date__c, 
                                                    Company_Code__c, Reference_Number__c, Vendor_Code__c,
                                                    (SELECT FRS__c, SES_Net_Value__c, SES_Net_Value_Miro__c, COFINS_Aliquot__c,
                                                    Access_Key__c, Tax_Code__c, Gross_Value_net_tax__c, SES_ICMS_Base_Miro__c,
                                                    SES_ICMS_Miro__c, ICMS_Value__c, SES_Total_Value_Miro__c, FRS__r.Ses_Number__c,
                                                    PIS_Aliquot__c FROM BFM_MIRO_Items__r) FROM BFM_Miro_Header__c
                                                    WHERE CT_e__c =: CTE.id LIMIT 1];
        if(listMiro.size() > 0){         
                  
            taxCode = taxCode.left(2);
            
            List<BFM_MIRO_Item_Tax__c> taxClassificationList = BFM_Querytax.queryTaxFuture(listMiro, 'BFM_CT_e__c', BFM_QueryTax.CTE_NFCATEGORY, CTe.id, CTe.Carrier_Account__r.BFM_Tax_Jurisdiction__c,
                                                                                           taxCode, CTe.CFOP_List__c, BFM_QueryTax.TYPE_CTE);
         
            if(taxClassificationList.size() > 0) {
            
                cte.Last_Tax_Classification_Update__c = System.now();
                cte.Last_User_To_Update_Tax__c = UserInfo.getUserId();
                cte.Is_Tax_Classification_Ok__c = true;
                                
                DataBase.update(cte, false);
                DataBase.insert(taxClassificationList, false);
            }
                      
        }
    }
    
    public list<BFM_CT_e__c> getRecords(){
        
        list<BFM_CT_e__c> listCTe = new list<BFM_CT_e__c>();
   
        try{
            
            listCTe = [SELECT Id, Name, Tax_Code_id__c, CFOP_List__c, CT_e_key__c ,
                       (SELECT Error_log__c FROM Error_Logs__r Order By CreatedDate desc LIMIT 1)
                       FROM BFM_CT_e__c 
                       WHERE ID IN: listRecords
                       AND Is_Tax_Classification_Ok__c = false];
            
        }
        catch(Exception e){
            system.debug(e);
        }
        
        return listCTe;
    
    }

    global void finish( Database.BatchableContext bcMain ){
        
        string excel = '';
        
        AsyncApexJob a = [Select Id, Status,ExtendedStatus,NumberOfErrors, JobItemsProcessed,
        TotalJobItems, CreatedBy.Email
        from AsyncApexJob where Id =:bcMain.getJobId()];
   
        list<BFM_CT_e__c> listCTe = getRecords();
        
        if(listCTe.size() > 0){
            
            excel = excel + 'CTE ID, TAX CODE, CFOP, ERRO, NUMERO INTERNO, CHAVE DE ACESSO, ERRO INTERNO' + '\n';
            
            for(BFM_CT_e__c cte: listCTe){
           
                if(cte.Error_Logs__r.size() > 0){
                    
                    for(BFM_Error_Log__c error: cte.Error_Logs__r){
                    	                        
                        excel = excel + cte.Id + ',';
                        
                        if(cte.Tax_Code_id__c != null)
                            excel = excel + cte.Tax_Code_id__c + ',';
                        else{
                           excel = excel + ','; 
                        }
                        
                        if(cte.CFOP_List__c != null){
                        	excel = excel + cte.CFOP_List__c + ',';
                        }
                        else{
                            excel = excel + ','; 
                        }
                        
                        excel = excel + error.Error_log__c + ',';                                                                        
                        excel = excel + cte.Name + ',';
                        excel = excel + cte.CT_e_key__c + ',';
                        
                        if(mapRecordsError.containsKey(cte.Id)){
                            excel = excel +  mapRecordsError.get(cte.Id) ;
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
        mail.setSubject('CT-e - Tax Classification: ' + a.Status);
		
        string body = 'Total de registros carregados no arquivo: ' + listRecords.size() +'\n';
        body = body + 'Total de registros com falha interna: ' + mapRecordsError.size() +'\n';
        body = body + 'Total de registros não classificados: ' + listCTe.size() +'\n';
               
        mail.setPlainTextBody(body);
        
        if(listCTe.size() > 0){
        	mail.setFileAttachments(new Messaging.EmailFileAttachment[]{csv});            
    	}
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});        
        
    }

}