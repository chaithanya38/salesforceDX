/****************************************************************
Class Name: Purchasearticlegroupscontroller 
Author:Håkan Sjöberg            Last modified by: G Janardhanreddy
Date: 16/7/2014                 Date: 20/03/2015 
********©2013 Musqot marketing technology Pvt ltd ***************/

public with sharing class Purchasearticlegroupscontroller {
    Public String Purchase_articleid{get;set;}
    public List<Purchase_article__c> Purchase_article { get; set; }
    //public List<Purchase_article__c> tobeDeleted{get ;set;}
    //public string SelectedPurchase_articleId { get; set;}
    public Purchasearticlegroupscontroller(){ 
    try
    {
       LoadData();
        }Catch(Exception e)
            {
        }
      }
    /*****************************************
    LoadData():  load Purchase article record
    *****************************************/
   public void LoadData() {
   try
   {
       Purchase_article = [Select id, name from Purchase_article__c order by name LIMIT 200];
    }Catch(Exception e)
    {
    }
   }
    /*************************************************************************
     DeleteAccount(): delete Purchase article and redirects to MusqotAdminPage
    **************************************************************************/
   public pageReference DeleteAccount(){      
      LoadData();
      Purchase_article__c Purchase_article;
      try{ 
      Purchase_article= [Select id, name from Purchase_article__c where id=:Purchase_articleid];
      delete Purchase_article;
      }Catch(Exception e){
      }
     String tabId = System.currentPageReference().getParameters().get('tabId');
     string pageRef='/apex/MusqotAdminPage?sfdc.tabName='+tabId+'&tab='+EncodingUtil.urlEncode('purarti','UTF-8');
     Pagereference pg=new Pagereference (pageRef);
     return pg;
       }  
    /***************************************************************************************
    NewArticle():  redirects to Newarticlegroup page and creates New Purchase article record
    ****************************************************************************************/   
   public PageReference NewArticle()
   {
   
      PageReference pg=new PageReference ('/apex/Newarticlegroup');
      pg.setredirect(true); 
       return pg;
   }
    /****************************************************************************************
    redirectPage1(): redirects to PurchaseArticleEdit page and update Purchase article record
    *****************************************************************************************/
    public PageReference redirectPage1() {
     String tabId = System.currentPageReference().getParameters().get('tabId');
        PageReference pgr=new PageReference ('/apex/PurchaseArticleEdit?id='+EncodingUtil.urlEncode(Purchase_articleid,'UTF-8')+'&tab='+EncodingUtil.urlEncode('purarti','UTF-8'));
        return pgr;
    }  
}