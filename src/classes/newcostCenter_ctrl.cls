public with sharing class newcostCenter_ctrl {
    public musqot__Costcentre__c costcen{get;set;}
    public musqot__Costcentre__c cos{get;set;}
    public String message ;
    public String cosId ;
    public boolean hidCos{get;set;}
    public newcostCenter_ctrl(ApexPages.StandardController controller) {
        costcen=new musqot__Costcentre__c(); 
        cosId=ApexPages.currentPage().getParameters().get('id');
        message =System.currentPagereference().getParameters().get('pageType');
        if(message=='new'){
        hidCos=true;
        }
        else{
        hidCos=false;
        cos=[select Name, OwnerId, Headline__c,Status__c, Description__c from Costcentre__c where id=:cosid limit 1];
        }   
    }
    Public Pagereference insertCosCenter(){
        Pagereference PR;  
            if (Members__c.sObjectType.getDescribe().isCreateable())
            {      
                insert costcen;
            }
             Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
             String objPrefix = globalDescribe.get('musqot__Costcentre__c').getDescribe().getkeyprefix();
             PageReference prRef = new PageReference('/' + objPrefix+'/o');
             prRef.setRedirect(true);
    
             return prRef;
    }
     Public Pagereference cancel(){
         Pagereference PR;  
         Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
         String objPrefix = globalDescribe.get('musqot__Costcentre__c').getDescribe().getkeyprefix();
         PageReference prRef = new PageReference('/' + objPrefix+'/o');
         prRef.setRedirect(true);

         return prRef;
    }
    Public Pagereference updateCosCenter(){
        Pagereference PR;  
            if (Members__c.sObjectType.getDescribe().isUpdateable())
            {      
                 update cos;
            }
             Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
             String objPrefix = globalDescribe.get('musqot__Costcentre__c').getDescribe().getkeyprefix();
             PageReference prRef = new PageReference('/' + objPrefix+'/o');
             prRef.setRedirect(true);
             return prRef;
    }                     
}