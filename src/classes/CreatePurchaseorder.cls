/***********************************************************
Class Name: CreatePurchaseorder
Author:G Janardhanreddy     Last modified by:G Janarhanreddy
Date:  15/7/2014                 Date:19/03/2015
********©2013 Musqot marketing technology Pvt ltd **********/
public class CreatePurchaseorder{
    public Purchase_order_setting__c pos {get;set;}
    public boolean isInput{get;set;}
    public boolean isUpdt{get;set;}
    public boolean isSave{get;set;}
    public boolean iscancel{get;set;}
    public CreatePurchaseorder(){
        pos = new Purchase_order_setting__c ();
        isInput = true;
        isSave = true;
        iscancel=true;
        isUpdt = false;
        Id poid= ApexPages.currentPage().getParameters().get('poid');
        String nm = ApexPages.currentPage().getParameters().get('str');
        pos .Name= NM;  
    }    
    /******************************************************
     saveCon():create new Purchase_order_setting__c records
    ********************************************************/
    public void saveCon(){
        if (Purchase_order_setting__c.sObjectType.getDescribe().isCreateable())
        {
            insert pos ;
        }
        isInput = false;
        isSave = false;
        //isUpdt = false;
    }
    
    public void Cancel(){
        //  try{
        // }catch(exception e){}
        isInput = false;
        isSave = false;
        iscancel=false;
    }
   
    public void editCon(){//show record edit mode
        isInput = true;
        isSave = false;
        isUpdt = true;
    }
    /********************************************************
    updateCon():update the  Purchase_order_setting__c records
    *********************************************************/
    public void updateCon(){
        isSave = false;
        update pos ;
        isUpdt = false;
        isInput = false;
    }
    
}