/*******************************************************
Trigger Name: UpdateTotalInvoice 
Author:Chaithanya Daggumati               Last modified by: Chaithanya Daggumati
Date:  5/1/2015                			  Date:19/3/2015
********©2013 Musqot marketing technology Pvt ltd *******/

trigger UpdateTotalInvoice on Invoice__c (after insert,after update,after delete) {
    public Set<Id> poIds = new Set<Id>();
    public Set<Id> poIdProcesd = new Set<Id>();
    public List<musqot__Purchase_order__c> lstPurchaseOrdersToUpdate = new List<musqot__Purchase_order__c>();
    Map<Id,Decimal> mapPoIdwithTotalInvoice = new Map<Id,Decimal>();
    Map<Id,musqot__Purchase_order__c> mapIdWithPurchOrder = new Map<Id,musqot__Purchase_order__c>();
    if(trigger.isInsert || trigger.isUpdate){
        for(musqot__Invoice__c inv:trigger.new){
            poIds.add(inv.musqot__Purchase_orders__c);  
        }
    }
    if(trigger.isdelete){
        for(musqot__Invoice__c inv:trigger.old){
            poIds.add(inv.musqot__Purchase_orders__c);  
        }
    }
    if(poIds.size() > 0){
        for(musqot__Purchase_order__c purchOrdr : [SELECT Id, musqot__total_Invoice_cost__c, (SELECT Id,musqot__Total_spent__c FROM Invoiced__r) FROM musqot__Purchase_order__c WHERE Id IN:poIds]){
            mapIdWithPurchOrder.put(purchOrdr.Id,purchOrdr);
            Decimal totInv = 0;
            for(musqot__Invoice__c inv :purchOrdr.Invoiced__r){
                totInv = totInv + inv.musqot__Total_spent__c;   
            }       
            mapPoIdwithTotalInvoice.put(purchOrdr.Id,totInv);
        }
        
    }
    
    if(trigger.isInsert || trigger.isUpdate){
        for(musqot__Invoice__c inv:trigger.new){
            if(mapIdWithPurchOrder != null && mapIdWithPurchOrder.get(inv.musqot__Purchase_orders__c) != null && !poIdProcesd.contains(inv.musqot__Purchase_orders__c)){
                musqot__Purchase_order__c purOrdr = new   musqot__Purchase_order__c();  
                purOrdr = mapIdWithPurchOrder.get(inv.musqot__Purchase_orders__c);
                if(trigger.isInsert){
                    purOrdr.musqot__total_Invoice_cost__c= mapPoIdwithTotalInvoice.get(inv.musqot__Purchase_orders__c) - inv.musqot__Total_spent__c;
                }
                else{
                    purOrdr.musqot__total_Invoice_cost__c= mapPoIdwithTotalInvoice.get(inv.musqot__Purchase_orders__c);
                 }
                poIdProcesd.add(inv.musqot__Purchase_orders__c);
                lstPurchaseOrdersToUpdate.add(purOrdr);
            }    
        }
    }
    
 /* if(trigger.isDelete){
        for(musqot__Invoice__c inv:trigger.old){
            if(mapIdWithPurchOrder != null && mapIdWithPurchOrder.get(inv.musqot__Purchase_orders__c) != null && !poIdProcesd.contains(inv.musqot__Purchase_orders__c)){
                musqot__Purchase_order__c purOrdr = new   musqot__Purchase_order__c();  
                purOrdr = mapIdWithPurchOrder.get(inv.musqot__Purchase_orders__c);
                purOrdr.musqot__total_Invoice_cost__c= mapPoIdwithTotalInvoice.get(inv.musqot__Purchase_orders__c);
                poIdProcesd.add(inv.musqot__Purchase_orders__c);
                lstPurchaseOrdersToUpdate.add(purOrdr);
            }    
        }
    }*/
    if(lstPurchaseOrdersToUpdate.size() > 0){
        update lstPurchaseOrdersToUpdate;
    }
}