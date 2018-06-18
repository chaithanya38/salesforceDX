public class BFM_CceHandlerActions {
  
    public static  Integer listSizes = 0;
    public static  Integer listInsertSize = 0;
    public static  Integer listDeleteSize = 0;
    
    /*
     * Method to perform a update on cte records
     */ 
    public static void updateRelatedCTE(List<BFM_CC_e__c> cceCteRecords) {
        
        Set<String> setCceIds = new Set<String>();
        for(BFM_CC_e__c cceCte : cceCteRecords) {
            setCceIds.add(cceCte.CTe__c);
        }
        
        System.debug('BFM_CceHandlerActions updateRelatedCTE setCceIds ' + setCceIds);
        
        List<BFM_Ct_e__c> listCteToUpdate = [SELECT Id FROM BFM_Ct_e__c WHERE ID IN :setCceIds and definitive__c = false];
        System.debug('BFM_CceHandlerActions.updateRelatedCTE.listCteToUpdate >>> ' + listCteToUpdate);
        if(listCteToUpdate.size() > 0) { update listCteToUpdate; }
    }
    
    
    public static void getListInsertSize (List<BFM_CC_e__c> sesCteRecords){
        
        listInsertSize = sesCteRecords != null ? sesCteRecords.size() : 0;
        
        
    }
    
    public static void getListDeleteSize (List<BFM_CC_e__c> sesCteRecords){
        
        listDeleteSize = sesCteRecords != null ? sesCteRecords.size() : 0;
        
    }
    
    public static void getCceCteListsSizes (){
        
        listSizes = listInsertSize - listDeleteSize;
                
    }
    
    public static void linkCceToCteOrNfeDf (List<BFM_CC_e__c> sesCteRecords){
        set<string> setCTEids = new set<string>();
        set<string> setNFids = new set<string>();
        set<id> setCCeids = new set<id>();
        for(BFM_CC_e__c cc: sesCteRecords){
            setCCeids.add(cc.id);
        }
        List<BFM_CT_e__c> listCte = new List<BFM_CT_e__c>();
        List<BFM_NF_e_DF__c> listNfeDf = new List<BFM_NF_e_DF__c>();
        map<string,BFM_CT_e__c> mapcte = new map<string,BFM_CT_e__c>();
        map<string,BFM_NF_e_DF__c> mapNfeDf = new map<string,BFM_NF_e_DF__c>();
        
        for(BFM_CC_e__c cce: sesCteRecords){
            if(cce.Related_CT_e_NF_e_DF_Key__c!= null && cce.Reference_Object_Type__c!= null){
                if(cce.Reference_Object_Type__c == 'CTE'){                   
                    setCTEids.add(cce.Related_CT_e_NF_e_DF_Key__c);
                }
                if(cce.Reference_Object_Type__c == 'NFE'){
                    setNFids.add(cce.Related_CT_e_NF_e_DF_Key__c);
                }
            }
        }
        System.debug('===setCTEids' + setCTEids.size());
        
        if(!setCTEids.isEmpty()){
            listCte = [select id,CT_e_key__c,CNPJ_Service_Taker__c, Unilever_Account__c, City_Code_Service_Taker__c, City_Service_Taker__c, UF_Service_Taker__c,
                       Is_Company_Code_Ok__c, Is_Vendor_Code_Ok__c from BFM_CT_e__c where CT_e_key__c in: setCTEids];
        }
        System.debug('===listCte' + listCte.size()); 
        if(!listCte.isEmpty()){
            for(BFM_CT_e__c cte : listCte){
                mapcte.put(cte.CT_e_key__c,cte);
            }
        }        
        
        if(!setNFids.isEmpty()){   
            listNfeDf = [select id,NF_e_key__c, CNPJ_Taker__c, Unilever_Account__c, City_Taker__c, City_Code_Taker__c, UF_Taker__c, Is_Company_Code_Ok__c,
                         Is_Vendor_Code_Ok__c from BFM_NF_e_DF__c where NF_e_key__c in: setNFids];
        }
        
        System.debug('===listNfeDf' + listNfeDf);
        if(!listNfeDf.isEmpty()){
            for(BFM_NF_e_DF__c nfeDf : listNfeDf){
                mapNfeDf.put(nfeDf.NF_e_key__c,nfeDf);
            }
        }        

        for(BFM_CC_e__c cce: sesCteRecords){
            
            BFM_CT_e__c cte = mapcte.get(cce.Related_CT_e_NF_e_DF_Key__c);
            BFM_NF_e_DF__c nfeDf = mapNfeDf.get(cce.Related_CT_e_NF_e_DF_Key__c);
            
              
                System.debug('===mapcte.containsKey(cce.Related_CT_e_NF_e_DF_Key__c)' + mapcte.containsKey(cce.Related_CT_e_NF_e_DF_Key__c));
                System.debug('===mapcte.containsKey(cce.Related_CT_e_NF_e_DF_Key__c)' + mapNfeDf.containsKey(cce.Related_CT_e_NF_e_DF_Key__c));
                    
                if(cce.Reference_Object_Type__c == 'CTE' && mapcte.containsKey(cce.Related_CT_e_NF_e_DF_Key__c) && mapcte.get(cce.Related_CT_e_NF_e_DF_Key__c)!=null){
                    cce.NF_e_DF__c = null;
                    cce.CTe__c = cte.id;
                    //cce.CC_e_Link_Check_Status__c = Boolean.ValueOf('True');
                    //cce.CC_e_Status__c = 'Link Ok';
                    cce.Unilever_Account_del__c = cte.Unilever_Account__c;
                    cce.CNPJ_Service_Taker_del__c = cte.CNPJ_Service_Taker__c;
                    cce.City_Code_Service_Taker__c = cte.City_Code_Service_Taker__c;
                    cce.City_Service_Taker_del__c = cte.City_Service_Taker__c;
                    cce.UF_Service_Taker_del__c = cte.UF_Service_Taker__c;
                    cce.Is_Company_Code_Ok__c = cte.Is_Company_Code_Ok__c;
                    cce.Is_Vendor_Code_Ok__c =  cte.Is_Vendor_Code_Ok__c;

                }
                if(cce.Reference_Object_Type__c == 'NFE' && mapNfeDf.containsKey(cce.Related_CT_e_NF_e_DF_Key__c) && mapNfeDf.get(cce.Related_CT_e_NF_e_DF_Key__c)!=null){
                    cce.CTe__c = null;
                    cce.NF_e_DF__c = nfeDf.id;
                    //cce.CC_e_Link_Check_Status__c = Boolean.ValueOf('True');
                    //cce.CC_e_Status__c = 'Link Ok';                   
                    cce.Unilever_Account_del__c = nfeDf.Unilever_Account__c;
                    cce.CNPJ_Service_Taker_del__c = nfeDf.CNPJ_Taker__c;
                    cce.City_Code_Service_Taker__c = nfeDf.City_Code_Taker__c;
                    cce.City_Service_Taker_del__c = nfeDf.City_Taker__c;
                    cce.UF_Service_Taker_del__c = nfeDf.UF_Taker__c;
                    cce.Is_Company_Code_Ok__c = nfeDf.Is_Company_Code_Ok__c;
                    cce.Is_Vendor_Code_Ok__c =  nfeDf.Is_Vendor_Code_Ok__c;
                    
                }
                if(cce.CTe__c == null && cce.NF_e_DF__c == null){
                system.debug('ccehandler');
                    //cce.CC_e_Link_Check_Status__c = Boolean.ValueOf('True');
                    //cce.CC_e_Status__c = 'Pending Link';
                }                            
            }
        
    }
    
    
}