global class BFM_BulkNFSUploadExcel implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts{

    global map<String,String[]> mapUpload = new map<String,String[]>();
    global list<String> listRecords = new list<String>();
    global map<String, string> mapRecordsError = new map<String, string>();
   
    public BFM_NFS__c nfs;
    public List<BFM_NFS__c> nfsList;    
    public List<BFM_MIRO_Withhold_Tax__c> withholdTaxList;
    public List<BFM_Withhold_tax__c> withholdTaxListCarrier;
    public List<ScreenWithholdTax> listScreenWithholdTax;
    public List<BFM_MIRO_Header__c> miro;   
    public BFM_Miro_Header__c mir;
    public String taxCode;
    public String nfsId;
    public Double sesIssAliquot;
    public Double baseAmount;
    public Double fiscalDocumentIssAliquot;
           
    global Database.Querylocator start( Database.BatchableContext BC ){
                             
        return Database.getQueryLocator([SELECT Carrier__c, id, Tax_Code_id__c, NFS_Total_Value__c, Base_Value__c, 
                                        ISS_Aliquot__c, Carrier__r.BFM_Tax_Jurisdiction__c, Standard_Aliquot__c, ISS_Value__c,
                                        NFS_Key__c, Last_Tax_Classification_Update__c, Last_User_To_Update_Tax__c, Unilever_company_code__c 
                                        FROM BFM_NFS__c WHERE ID IN: mapUpload.keySet()]);    
    }
    
    global void execute( Database.BatchableContext BC, List<sObject> scope ){
       
       list<BFM_NFS__c> listNFS = (list<BFM_NFS__c>) scope;
       
       for(BFM_NFS__c NFS: listNFS){
           
           try{
       
               string id = NFS.id;
               id = id.substring(0,15);
                                                    
               string[] inputExcel = mapUpload.get(id);
                              
               string taxCode = inputExcel[1];
               
               string decAliquot = inputExcel[2];
               decAliquot = decAliquot.trim();
               
               Decimal aliquot = 0;
               
               if(decAliquot != null && decAliquot != ''){
                   decAliquot = decAliquot.replace(',', '.');               
                   aliquot = Decimal.valueOf(decAliquot);
               }
                              
               string taxCodeDescription = inputExcel[3];
               Boolean apply = false;           
               
               String strAplly = inputExcel[4];
               strAplly = strAplly.trim();
               
               if(strAplly == '1'){
                   apply = true;
               }
               
               String decBaseAmoun = inputExcel[5];
               decBaseAmoun = decBaseAmoun.trim();
               Decimal baseAmount = 0;
              
               if(decBaseAmoun != null && decBaseAmoun != ''){
                  
                   decBaseAmoun = decBaseAmoun.replace(',', '.'); 
                   system.debug('---- base' + decBaseAmoun);
                   baseAmount = Decimal.valueOf(decBaseAmoun);
                   system.debug('---- base' + baseAmount);
               }
               
               NFS.Tax_Code_Id__c = taxCode;
               NFS.Standard_Aliquot__c = aliquot;
                             
               createMiroTaxInformation(NFS);
               saveWithholdTaxes(NFS,taxCode, taxCodeDescription, baseAmount, apply, aliquot);
               
               listRecords.add(id);
           }
           catch(Exception e){
               mapRecordsError.put(NFS.id, e.getMessage());
           }
       }
        
    }
    
        
    public void createMiroTaxInformation(BFM_NFS__c NFS) {
    
        List<BFM_Withhold_tax__c> withholdTaxListCarrier = new List<BFM_Withhold_tax__c>();
        listScreenWithholdTax = new List<ScreenWithholdTax>();
    
    
        list<BFM_Miro_Header__c> listMiro = [SELECT id, Total_Amount__c, ICMS_Amount__c, ICMS_Base_Value__c,Invoice_Date__c,Invoice_Serie_Number__c, 
                                             Miro_Requested_Date__c, Company_Code__c, Reference_Number__c, Vendor_Code__c, Total_FRS_Value__c,
                                             (SELECT FRS__c, SES_Net_Value__c, SES_Net_Value_Miro__c, COFINS_Aliquot__c, FRS__r.Gross_Value_net_tax__c,
                                             Access_Key__c, Tax_Code__c, Gross_Value_net_tax__c, SES_ICMS_Base_Miro__c, SES_ICMS_Miro__c,
                                             ICMS_Value__c, SES_Total_Value_Miro__c, FRS__r.Ses_Number__c,
                                             PIS_Aliquot__c FROM BFM_MIRO_Items__r) FROM BFM_Miro_Header__c
                                             WHERE NFS__c =: NFS.id LIMIT 1];
        
        mir = listMiro[0];
                            
        withholdTaxList = [SELECT Id, Withholding_Tax_Type__c, Tax_Code_Description__c, Withholding_Tax_Code__c,  
                           Withholding_Tax_Text__c,Apply__c,
                           Withhold_Tax__r.Withholding_Tax_Code__c, Base_Amount__c
                           FROM BFM_MIRO_Withhold_Tax__c 
                           WHERE MIRO_Header__c in 
                           (SELECT Id FROM BFM_MIRO_Header__c where NFS__c =: NFS.id)];
        
        BFM_MIRO_Header__c miroLink = [SELECT Id FROM BFM_MIRO_Header__c 
                                       WHERE NFS__c =: NFS.id LIMIT 1];
        
        if(!withholdTaxList.isEmpty() && withholdTaxList != null) {
        
            for(BFM_MIRO_Withhold_Tax__c with : withholdTaxList) {
                ScreenWithholdTax tempScreenWithholdTax = new ScreenWithholdTax(with,with.Withholding_Tax_Type__c ,with.Withholding_Tax_Text__c,with.Withholding_Tax_Code__c);
                listScreenWithholdTax.add(tempScreenWithholdTax);
            }
            
        } else {
 
            for(BFM_Withhold_tax__c with : withholdTaxListCarrier) {
                BFM_MIRO_Withhold_Tax__c miroTax = new BFM_MIRO_Withhold_Tax__c();
                miroTax.MIRO_Header__c = miroLink.Id;
                miroTax.Withhold_Tax__c = with.id;
                miroTax.Base_Amount__c = NFS.NFS_Total_Value__c;

                withholdTaxList.add(miroTax);                
            }
        }
   
              
   
    } 
    
    public void saveWithholdTaxes(BFM_NFS__c nfs, string taxCode, string taxCodeDescription, Decimal baseAmount, Boolean apply, Decimal aliquot) {
    
        list<BFM_Miro_Header__c> miro = [SELECT id, Total_Amount__c, ICMS_Amount__c, ICMS_Base_Value__c,Invoice_Date__c,Invoice_Serie_Number__c, 
                                             Miro_Requested_Date__c, Company_Code__c, Reference_Number__c, Vendor_Code__c, Total_FRS_Value__c,
                                             (SELECT FRS__c, SES_Net_Value__c, SES_Net_Value_Miro__c, COFINS_Aliquot__c, FRS__r.Gross_Value_net_tax__c,
                                             Access_Key__c, Tax_Code__c, Gross_Value_net_tax__c, SES_ICMS_Base_Miro__c, SES_ICMS_Miro__c,
                                             ICMS_Value__c, SES_Total_Value_Miro__c, FRS__r.Ses_Number__c,
                                             PIS_Aliquot__c FROM BFM_MIRO_Items__r) FROM BFM_Miro_Header__c
                                             WHERE NFS__c =: nfs.id LIMIT 1];
         
        
        Double netValue = 0.0;
    
        BFM_Percentage_Values__mdt customSettingPercentsValues = [SELECT Cofins_Percent__c,PIS_Percent__c 
                                                                  FROM BFM_Percentage_Values__mdt  
                                                                  WHERE QualifiedAPIName = 'Percent_Values' LIMIT 1];
        
        Double TotalAmount = nfs.NFS_Total_Value__c;
                
        Double cofinsValue = (TotalAmount * (customSettingPercentsValues.Cofins_Percent__c / 100)).setScale(2);
        Double pisValue = (TotalAmount * (customSettingPercentsValues.PIS_Percent__c / 100)).setScale(2);                            
        Double issCityAmount = (TotalAmount * (aliquot / 100)).setScale(2);
                
        for(BFM_MIRO_Item__c miroItem : miro.get(0).BFM_MIRO_Items__r) {
            
            netValue = nfs.NFS_Total_Value__c - (cofinsValue + pisValue + miro.get(0).ICMS_Amount__c  + (issCityAmount != 0  ? issCityAmount : nfs.ISS_Value__c));

            if(netValue != null && miro.get(0).Total_FRS_Value__c != null && netValue != 0 && miro.get(0).Total_FRS_Value__c != 0 && miroItem.FRS__r.Gross_Value_net_tax__c != null) {
                miroItem.SES_Net_Value_Miro__c = ((netValue / miro.get(0).Total_FRS_Value__c) * miroItem.FRS__r.Gross_Value_net_tax__c).setScale(2);
            }
            
        }
        
        system.debug('---- ENTROU 0');
        
        List<BFM_MIRO_Item_Tax__c> taxClassificationList = BFM_Querytax.queryTaxFuture(miro, 'BFM_NFS__c', BFM_QueryTax.NFS_NFCATEGORY, nfs.id, taxCode.left(2), 
                                                                                       nfs.Carrier__r.BFM_Tax_Jurisdiction__c, BFM_QueryTax.TYPE_NFS);
        
       
        system.debug('----Entrou ' + taxClassificationList);
        
        if(taxClassificationList.size() > 0) {
           
            nfs.Last_Tax_Classification_Update__c = System.now();
            nfs.Last_User_To_Update_Tax__c = UserInfo.getUserId();
            nfs.Is_Tax_Classification_Ok__c = true;
            
            database.update(nfs,false);
            database.insert(taxClassificationList,false);
            
        }
        
         system.debug('----Entrou 2');
        List<BFM_MIRO_Withhold_Tax__c> listUpWith = new List<BFM_MIRO_Withhold_Tax__c>();
        
        for(ScreenWithholdTax sWith : listScreenWithholdTax) {
        
            BFM_MIRO_Withhold_Tax__c tempWith = new BFM_MIRO_Withhold_Tax__c();
            tempWith.Id = sWith.itemScreenMIROWithhold.Id;
            tempWith.Withhold_Tax__c = sWith.itemScreenMIROWithhold.Withhold_Tax__c;
            
            system.debug('----' + sWith.strTaxType);
			
            if(sWith.strTaxType == 'IS'){
            	tempWith.Apply__c = apply;
                tempWith.Tax_Code_Description__c = taxCodeDescription;
            }
            
            tempWith.Base_Amount__c = baseAmount;            
            listUpWith.add(tempWith);
        }
        
        system.debug('------ LISTA' + withholdTaxList);
        if(withholdTaxList.size() > 0){
            Database.upsert(withholdTaxList, true);
        }
        
        system.debug('------ LISTA' + listUpWith);
        if(listUpWith.size() > 0) {
            database.update(listUpWith,true);
        }
    
    } 
    
    public list<BFM_NFS__c> getRecords(){
        
        list<BFM_NFS__c> listNFS = new list<BFM_NFS__c>();
   
        try{
            
            listNFS = [SELECT Id, Name, NFS_Key__c,
                       (SELECT Error_log__c FROM Error_Logs__r Order By CreatedDate desc LIMIT 1)
                       FROM BFM_NFS__c 
                       WHERE ID IN: listRecords
                       AND Is_Tax_Classification_Ok__c = false];
            
        }
        catch(Exception e){
            system.debug(e);
        }
        
        return listNFS;
    
    }


    global void finish( Database.BatchableContext bcMain ){
                       
        string excel = '';
        
        AsyncApexJob a = [Select Id, Status,ExtendedStatus,NumberOfErrors, JobItemsProcessed,
        TotalJobItems, CreatedBy.Email
        from AsyncApexJob where Id =:bcMain.getJobId()];
   
        list<BFM_NFS__c> listNFS = getRecords();
        
        if(listNFS.size() > 0){
            
            excel = excel + 'NFS ID, COd.IMPOTO MIRO, ALIQUOTA ISS DA CIDADE, COD RET. USADO P/ "IS", IND. APLICACAO?, VALOR BASE CALCULO, ERRO, NUMERO INTERNO, CHAVE DE ACESSO, ERRO INTERNO' + '\n';
            
            for(BFM_NFS__c nfs: listNFS){
           
                if(nfs.Error_Logs__r.size() > 0){
                    
                    for(BFM_Error_Log__c error: nfs.Error_Logs__r){
                        
                        string id = NFS.id;
                        id = id.substring(0,15);
                        
                        excel = excel + id + ',';
                                                 
                        string[] inputExcel = mapUpload.get(id);                                                
                      
                        excel = excel + inputExcel[1] + ',';
                        
                        string decAliquot = inputExcel[2];
                        decAliquot = decAliquot.trim();
                        
                        Double dblAliquot = 0;
                        
                        if(decAliquot != null && decAliquot != ''){                        
                            decAliquot = decAliquot.replace(',', '.');                            
                            dblAliquot = double.valueOf(decAliquot);
                        }
                        
                        excel = excel + string.valueOf(dblAliquot) + ',';
                        excel = excel + inputExcel[3] + ',';
                        excel = excel + inputExcel[4] + ',';
                        
                        string base = inputExcel[5];
                        base = base.trim();
                        Double dblBase = 0;
                        
                        if(base != null && base != ''){
                            base = base.replace(',', '.');                            
                            dblBase = double.valueOf(base);
                        }
                        
                        excel = excel + string.valueOf(dblBase) + ',';                                                                 
                        excel = excel + error.Error_log__c + ',';
                        excel = excel + nfs.Name + ',';
                        excel = excel + nfs.NFS_Key__c + ','; 
                        
                        if(mapRecordsError.containsKey(nfs.Id)){
                            excel = excel +  mapRecordsError.get(nfs.Id) ;
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
        mail.setSubject('NFs - Tax Classification: ' + a.Status);
        
        string body = 'Total de registros carregados no arquivo: ' + listRecords.size() +'\n';
        body = body + 'Total de registros com falha interna: ' + mapRecordsError.size() +'\n';
        body = body + 'Total de registros não classificados: ' + listNFS.size() +'\n';
               
        mail.setPlainTextBody(body);
        
        if(listNFS.size() > 0){
            mail.setFileAttachments(new Messaging.EmailFileAttachment[]{csv});            
        }
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        
    }
    
    public class ScreenWithholdTax{
        
        public BFM_MIRO_Withhold_Tax__c itemScreenMIROWithhold {get;set;}
        public String strTaxType {get;set;}
        public String strTaxText {get;set;}
        public String strTaxCode {get;set;}
        
        public ScreenWithholdTax(BFM_MIRO_Withhold_Tax__c withHold, String taxType, String taxText, String taxCode) {
            itemScreenMIROWithhold = withHold;
            strTaxType = taxType;
            strTaxText = taxText;
            strTaxCode = taxCode;
        }
    }
}