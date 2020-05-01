/*******************************************************
Class Name: PurchasearticlegroupscontrollerTest
Author:chaithanya daggumati      Last modified by: chaithanya daggumati
Date: 21/7/2014                     Date: 20/03/2015 
********©2013 Musqot marketing technology Pvt ltd *******/

@isTest(Seealldata = True)
    public class PurchasearticlegroupscontrollerTest{
    static testMethod void Purchasearticle(){
    Purchase_article__c objpog = new Purchase_article__c();
    objpog.name ='testrec';
    System.assertEquals('testrec', objpog.name);
    insert objpog; 
    try{ 
    Purchase_article__c   Pa= [Select id, name from Purchase_article__c where id=:objpog.id];
    delete pa;
    }catch(exception e){}
    test.startTest();
    PageReference pg=page.Purchasearticlegroups;
    pg.setRedirect(True);
    ApexPages.currentPage().getParameters().put('id', objpog.id);
    ApexPages.StandardController sc = new ApexPages.standardController(objpog);
    Purchasearticlegroupscontroller pogs= new Purchasearticlegroupscontroller();
    pogs.LoadData();
    pogs.DeleteAccount();
    pogs.NewArticle();
    //pogs.SelectedPurchase_articleId='test';
    try{
    pogs.redirectPage1();
    }
    catch(exception e){}
    pg.getParameters().put('id',objpog.id);
    test.stoptest();
    }
    }