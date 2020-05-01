/**********************************************************
Class Name: PurchasingOrderClassTest
Author:chaithanya daggumati     Last modified by: chaithanya 
Date: 21/7/2014                  Date: 18/2/2015 
********©2013 Musqot marketing technology Pvt ltd **********/

@isTest
    public class PurchasingOrderClassTest{
        static testMethod void PurchasingOrder(){
        Purchase_order_setting__c objposo = new Purchase_order_setting__c();
        objposo .name = 'testrec';
        objposo .PO_Startnumber__c = 1;
        System.assertEquals('testrec', objposo .name);
        insert objposo ;
        ApexPages.currentPage().getParameters().put('id', objposo .id);
        ApexPages.StandardController sc = new ApexPages.standardController(objposo );
        test.startTest();
        PurchasingOrderClass pocs = new PurchasingOrderClass(sc);                    
        pocs .Editpage();
        pocs .Save();
        pocs .Cancel();
        pocs  .CloneRec();
        pocs  .DeleteRec();       
        }
        }