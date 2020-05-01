/****************************************************************
Class Name: PurchaseArticleEditControllerTest
Author:chaithanya daggumati      Last modified by:Janardhan reddy
Date: 21/7/2014                  Date:  20/03/2015
********©2013 Musqot marketing technology Pvt ltd ****************/

@isTest
    public class PurchaseArticleEditControllerTest{
        static testMethod void PurchaseArticle(){
        Purchase_article__c po = new Purchase_article__c();
        po.name = 'testrec';
        System.assertEquals('testrec', po.name);
        insert po; 
        ApexPages.currentPage().getParameters().put('id', po.id);
        ApexPages.StandardController sc = new ApexPages.standardController(po);
        test.startTest();
        PurchaseArticleEditController pac = new PurchaseArticleEditController(sc);     
        pac.Save();
        pac.Cancel();    
        }
        }