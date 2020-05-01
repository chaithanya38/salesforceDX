/******************************************************************
Class Name: newPurchaseArticleTest
Author:Chaithanya daggumati       Last modified by: Janardhan reddy
Date :22/7/2014                   Date: 19/3/2105                     
********©2013 Musqot marketing technology Pvt ltd *****************/

@isTest
    public class newPurchaseArticleTest{
        static testMethod void newPurchaseArticle(){
        Purchase_article__c objpart = new Purchase_article__c();
        objpart.name = 'testrec'; 
        System.assertEquals('testrec', objpart.name);
        insert objpart; 
        ApexPages.currentPage().getParameters().put('id', objpart.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objpart);
        test.startTest();
        newPurchaseArticle npart = new newPurchaseArticle (sc);     
        npart .Newrec();
        npart .Cancel();
        }
        }