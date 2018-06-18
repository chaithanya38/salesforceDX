/**
* @author Sridhar valiveti
* @date 02/03/2017
* @description: CT-e Handler for Actions and Business Rules from trigger for handling Annulment and cancellation
*
* Modification Log    :
* ------------------------------------------------------------------------------------------------
* Developer                          Date                    Description
* ---------------                   -----------             ----------------------------------------------
* Sridhar Valiveti                  03 March 2017             Original Version
*/

global without sharing class BFM_CteCancellationAnnulmentHandler {
    /**
    * Method name : BFM_cancelMiro
    * Description : Method to Invalidate ct-e and cancel Miro  before 168h
    */
    public final static string sefazStatus = '100';
    public static void cancelMiro(List<BFM_CT_e__c> cteRecords, Map<Id, SObject> oldMapRecords) {
        
        Map<Id, BFM_CT_e__c> mapCTeByID = new Map<Id, BFM_CT_e__c>();
        List<BFM_MIRO_Header__c> updateMiroList = new List<BFM_MIRO_Header__c>();
        
        for(BFM_CT_e__c cte : cteRecords) {

            if(cte.CT_e_Request_for_Cancel__c) {
                if(cte.Cancel_Annul_Sefaz_Check__c != null && cte.Cancel_Annul_Sefaz_Check__c != sefazStatus) {
                    mapCTeByID.put(cte.Id, cte);
                } else if (cte.Sefaz_Check_168_Status__c != null && cte.Sefaz_Check_168_Status__c != sefazStatus) {
                    mapCTeByID.put(cte.Id, cte);
                }
            }
        }

        List<BFM_MIRO_Header__c> lstMIRO = [SELECT Id, Miro_Requested_Date__c, Cancellation_Posting_Date__c, Annulment_Flag__c, CT_e__c,CT_e__r.id 
                                            FROM BFM_MIRO_Header__c 
                                            WHERE CT_e__c IN: mapCTeByID.keySet() 
                                            AND Cancellation_Posting_Date__c = null];
        Set<Id> miroIdToBePosted = new Set<Id>();
        for(BFM_MIRO_Header__c miro : lstMIRO) {
            
            BFM_MIRO_Header__c bfmMiro = new BFM_MIRO_Header__c(id = miro.id);
            bfmMiro.Cancellation_flag__c = true;
            
            System.debug('miro.id' + miro.id);
            miroIdToBePosted.add(miro.Id);
            //BFM_InvoiceProcessing.performInvoiceProcessing(miro.Id, 'BFM_CT_e__c');
            
            updateMiroList.add(bfmMiro);
        }
        
        if(updateMiroList.size() > 0) {
            update updateMiroList;
        }
        
                
        if(miroIdToBePosted.size() > 0 && !System.isBatch() ) {
            Database.executeBatch(new BFM_BulkMiroProcessing(miroIdToBePosted,'BFM_CT_e__c'),1);
        }
        
    }
    
    public static void cancelMiro(List<BFM_CT_e__c> cteRecords) {
        
        Map<Id, BFM_CT_e__c> mapCTeByID = new Map<Id, BFM_CT_e__c>();
        List<BFM_MIRO_Header__c> updateMiroList = new List<BFM_MIRO_Header__c>();
        
        for(BFM_CT_e__c cte : cteRecords) {

            if(cte.CT_e_Request_for_Cancel__c) {
                if(cte.Cancel_Annul_Sefaz_Check__c != null && cte.Cancel_Annul_Sefaz_Check__c != sefazStatus) {
                    mapCTeByID.put(cte.Id, cte);
                } else if (cte.Sefaz_Check_168_Status__c != null && cte.Sefaz_Check_168_Status__c != sefazStatus) {
                    mapCTeByID.put(cte.Id, cte);
                }
            }
        }

        List<BFM_MIRO_Header__c> lstMIRO = [SELECT Id, Miro_Requested_Date__c, Cancellation_Posting_Date__c, Annulment_Flag__c, CT_e__c,CT_e__r.id 
                                            FROM BFM_MIRO_Header__c 
                                            WHERE CT_e__c IN: mapCTeByID.keySet() 
                                            AND Cancellation_Posting_Date__c = null];
        Set<Id> miroIdToBePosted = new Set<Id>();
        for(BFM_MIRO_Header__c miro : lstMIRO) {
            
            BFM_MIRO_Header__c bfmMiro = new BFM_MIRO_Header__c(id = miro.id);
            bfmMiro.Cancellation_flag__c = true;
            
            System.debug('miro.id' + miro.id);
            miroIdToBePosted.add(miro.Id);
            //BFM_InvoiceProcessing.performInvoiceProcessing(miro.Id, 'BFM_CT_e__c');
            
            updateMiroList.add(bfmMiro);
        }
        
        if(updateMiroList.size() > 0) {
            update updateMiroList;
        }
        if(miroIdToBePosted.size() > 0 && !System.isBatch() ) {
            Database.executeBatch(new BFM_BulkMiroProcessing(miroIdToBePosted,'BFM_CT_e__c'),1);
        }
    }
    
    webservice static string taxRequired(Id cteId) {
        String strRet = '';
        
        BFM_CT_e__c cte = [SELECT Id, Tax_Code_id__c, Tax_Code_Annulment__c FROM BFM_CT_e__c Where Id =: cteId];   
        
        if(String.isBlank(cte.Tax_Code_id__c) && String.isBlank(cte.Tax_Code_Annulment__c)){
                strRet = 'Tax code para anulação do CT-e ainda não definido.';
        }else{
            
            if(String.isBlank(cte.Tax_Code_Annulment__c)){
                BFM_CT_e__c newCte = new BFM_CT_e__c();
                newCte.id = cte.Id;
                newCte.Tax_Code_Annulment__c = cte.Tax_Code_id__c;
                BFM_TriggerHelper.updateObjectTriggerDisabled(newCte);
            }
            
        }
            
        /* 11/07 Tax cade must have to be from CTe
        List<BFM_MIRO_Item__c> listMiroItem = [SELECT Id, Tax_Code__c
                                               FROM BFM_MIRO_Item__c 
                                               WHERE MIRO_Header__c in (SELECT Id from BFM_MIRO_Header__c where CT_e__c =:cteId)];
        
        List<BFM_MIRO_Header__c> lstMIRO = [SELECT Id, MIRO_Number__c
                                            FROM BFM_MIRO_Header__c 
                                            where CT_e__c =:cteId];
        
        String strRet = '';
        if(listMiroItem.size() > 0){
            if(String.isBlank(listMiroItem.get(0).Tax_Code__c)){
                strRet = 'Miro Item sem tax code.';
            }
        }else{
            if(String.isBlank(cte.Tax_Code_Annulment__c)){
                strRet = 'Por favor, selecionar um tax code de anulação do CT-e.';
            }
        }
        
        if(lstMIRO.size() > 0){
             if(String.isBlank(lstMIRO.get(0).MIRO_Number__c) && String.isBlank(cte.Tax_Code_Annulment__c)){
                strRet = 'Por favor, selecionar um tax code de anulação do CT-e.';
            }
        }*/
        return strRet;
    }
    
    
    webservice static string annulMiro(Id cteId, String anullmentReason) {
        
        Map<Id, BFM_CT_e__c> mapCTeByID = new Map<Id, BFM_CT_e__c>();
        List<BFM_MIRO_Header__c> updateMiroList = new List<BFM_MIRO_Header__c>(); 
        String strReturn = '';
        
        List<BFM_CT_e__c> cteRecords = [SELECT CT_e_Request_for_Annulment__c, Tax_Code_Annulment__c, Tax_Code_id__c FROM BFM_CT_e__c WHERE id =: cteId];
        
        for(BFM_CT_e__c cte : cteRecords) {
            mapCTeByID.put(cte.Id, cte);
        }
        
        List<BFM_CT_e__c> listCteToUpdate = new List<BFM_CT_e__c>();
        for(BFM_CT_e__c cte : mapCTeByID.values()) {
            BFM_CT_e__c newCte = new BFM_CT_e__c();
            newCte.id = cte.id;
            newCte.CT_e_Request_for_Annulment__c = true;
            newCte.Annulment_Reason__c = anullmentReason;
            newCte.User_Tax_Reviewer__c = UserInfo.getUserId();
            newCte.User_Tax_Reviewer_Date__c = System.now();
            
            if(String.isBlank(cte.Tax_Code_Annulment__c)){
                newCte.Tax_Code_Annulment__c = cte.Tax_Code_id__c;
            }
            listCteToUpdate.add(newCte);
        }
        
        
        
        List<BFM_MIRO_Header__c> lstMIRO = [SELECT Id, Miro_Requested_Date__c, Annulment_Flag__c, Annulment_Reason__c, CT_e__r.Annulment_Reason__c,
                                                   Annulment_Fiscal_Doc_No__c, Annulment_Status_Code__c
                                            FROM BFM_MIRO_Header__c 
                                            WHERE CT_e__c IN: mapCTeByID.keySet() ];
        
        if(lstMIRO.size() > 0){
            if(lstMIRO.get(0).Annulment_Status_Code__c == null || lstMIRO.get(0).Annulment_Status_Code__c != sefazStatus){
                for(BFM_MIRO_Header__c miro : lstMIRO) {
                    BFM_MIRO_Header__c bfmMiro = new BFM_MIRO_Header__c (id=miro.id);
                    bfmMiro.Annulment_Flag__c = true;
                    bfmMiro.Annulment_Reason__c = anullmentReason;
                    
                    updateMiroList.add(bfmMiro);
                    
                    strReturn = BFM_InvoiceProcessing.performInvoiceProcessingAnnulment(miro.id, 'BFM_CT_e__c', anullmentReason);
                }
            }
        } else {
            strReturn = 'Este documento já foi solicitado anulação.';
        }
        
        List<BFM_MIRO_Header__c> miroAnnul = [SELECT Id,CT_e__c, Annulment_Fiscal_Doc_No__c, Annulment_Status_Code__c 
                                              FROM BFM_MIRO_Header__c 
                                              WHERE CT_e__c IN: mapCTeByID.keySet() 
                                              AND Annulment_Fiscal_Doc_No__c != '' AND Annulment_Status_Code__c =: sefazStatus];
        system.debug('BFM_CteCancellationAnnulmentHandler annulMiro miroAnnul: ' + miroAnnul);
       
         if(listCteToUpdate.size() > 0) {
            BFM_TriggerHelper.updateObjectListTriggerDisabled(listCteToUpdate);
        }
        
        if(updateMiroList.size() > 0) {
            update updateMiroList;   
        }

        return strReturn;
    }
    
    webservice static String checkPermissionSetAssignment(Id cteId){
        String validApprover = 'false'; 
        
        list<PermissionSetAssignment> listPermissionSetAssignment = new list<PermissionSetAssignment>();
        set<String> setPermissionSetAssignment = new set<String>();
        BFM_CT_e__c CTe = new BFM_CT_e__c();
        
        try{
            CTe = [SELECT Id, Annulment_Required__c FROM BFM_CT_e__c WHERE Id =: cteId];
            
            
            
            listPermissionSetAssignment = [SELECT PermissionSet.Name 
                                           FROM PermissionSetAssignment 
                                           WHERE Assignee.Id =: UserInfo.getUserId()];
            
            
            if(listPermissionSetAssignment.size() > 0){
                
                for(PermissionSetAssignment perm: listPermissionSetAssignment){
                    setPermissionSetAssignment.add(perm.PermissionSet.Name);
                }
                
            }
            
            if(setPermissionSetAssignment.contains('BFM_Tax_Unilever')){
                System.debug('setPermissionSetAssignment.contains(BFM_Tax_Unilever)' + setPermissionSetAssignment);
                Cte.Annulment_Required__c = false;
                validApprover = 'true';
                
            }//else{
                //Cte.Annulment_Required__c = true;
            //}
            
           // BFM_TriggerHelper.updateObjectTriggerDisabled(Cte);
            
        }
        catch(exception e){
            System.debug('Error ' + e);
        }
        
        return  validApprover;                                                               
    }
    
    
}