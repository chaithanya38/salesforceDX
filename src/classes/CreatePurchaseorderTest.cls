/*******************************************************
Class Name: CreatePurchaseorderTest
Author:Nagaraju G   		Last modified by:G Janarhanreddy
Date:  22/07/2014           Date:19/03/2015
********©2013 Musqot marketing technology Pvt ltd *******/
@isTest
    public class CreatePurchaseorderTest{
    static testmethod void CreatePurchaseorderTestMethod(){    
    Purchase_order_setting__c objPurchaseOrder = new Purchase_order_setting__c();
    
    objPurchaseOrder.name= 'musqot';
    objPurchaseOrder.PO_Startnumber__c= 1;
    System.assertEquals('musqot', objPurchaseOrder.name);
      try {
    Test.startTest();
    //Call your class in a way that causes the exception
    Test.stopTest();
    } catch (Exception e) {
    System.assertEquals('Incorrect bSomeTestCondition', e.getMessage());
    }
    ApexPages.currentPage().getParameters().put('poid', objPurchaseOrder.id);
    CreatePurchaseorder objcrePurchase = new CreatePurchaseorder();
    objcrePurchase.pos= objPurchaseOrder;
    objcrePurchase.saveCon();
    objcrePurchase.Cancel();
    objcrePurchase.editCon();
    objcrePurchase.updateCon();
    
    }
    }