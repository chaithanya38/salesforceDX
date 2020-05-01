public with sharing class ERPSalesCotroller{
    public String getData(){
        List<ERP_sales_obj__c> erpList =  [select Sales__c,Sales_date__c,sales_import_id__c,Business_area__c,Business_region__c from ERP_sales_obj__c order by Sales_date__c, Business_region__c limit 5000];      
        //preparing JSON raw data
        List<String> jsonList = new List<String>();
        JSONGenerator jsonGen = JSON.createGenerator(true);
        jsonGen.writeStartArray();
        for(ERP_sales_obj__c erp : erpList){
            jsonGen.writeStartObject();
            jsonGen.writeDateField('date',erp.Sales_date__c);
            jsonGen.writeStringField('region',erp.Business_region__c);
            jsonGen.writeNumberField('sale',erp.Sales__c);
            jsonGen.writeStringField('area',erp.Business_area__c);    
            jsonGen.writeEndObject();     
        }
        jsonGen.writeEndArray();        
        return jsonGen.getAsString();
    }
}