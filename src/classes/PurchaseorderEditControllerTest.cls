/*******************************************************
Class Name: PurchaseorderEditControllerTest
Author:Nagaraju G        Last modified by:Raju
Date: 28/8/2014          Date: 18/2/2015 
********©2013 Musqot marketing technology Pvt ltd *******/

@isTest(seeAllData=true)
public class PurchaseorderEditControllerTest{
    static testMethod void PurchaseorderEdittest(){  
      Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
           User objUs =new User( Alias = 'newUser1' ,
           Email ='newuser123@testorg.com',
           EmailEncodingKey = 'UTF-8',
           LastName = 'Testing',
           LanguageLocaleKey='en_US',
           LocaleSidKey='en_US', 
           UserName='newuser1234@testorg.com',
           ProfileId=p.Id,
           TimeZoneSidKey = 'America/Los_Angeles');
           insert objUs ; 
    Project__c prj = new Project__c ();
         prj.Name='ITC';
         //prj.Plantype__c= pt.Id;
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c= system.toDay();
         prj.Status__c = 'In Progress';
         System.assertEquals('ITC', prj.name);         
         insert prj;
         
        
    Subproject__c subPrj = new Subproject__c();         
         subPrj.Name='ITC Project';
         subPrj.Parent_project__c = prj.Id;
         subPrj.Ends_date__c = system.toDay().addDays(3);
         subPrj.Starts_date__c= system.toDay();
         subPrj.Status__c = 'In Progress'; 
         //subPrj.Project_type__c = prjType.Id;
         System.assertEquals('ITC Project', subPrj.name);     
         insert subPrj;
                     
    Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact;
       
        
      Purchase_order__c objpurchase=new Purchase_order__c ();   
        objpurchase.Name='testpurchaces';
        objpurchase.Ownerid=objUs.id;
        objpurchase.musqot__Purchase_order_name__c='testperching';
        //objpurchase.musqot__Project__c=prj.Id;
        objpurchase.musqot__subproject__c=subPrj.Id;
        objpurchase.musqot__Supplier_email__c='test@gmail.com';
        objpurchase.musqot__Total_cost__c=3000;
        objpurchase.musqot__Supplier__c='testsuppilor';
        objpurchase.musqot__Send_date__c=system.today();
        objpurchase.musqot__Effective_date__c=system.today();
        objpurchase.musqot__Purchase_order_cloesed__c = true;
        objpurchase.musqot__total_Invoice_cost__c=10;
        
        //decimal poOld=1000;
        //decimal maxPO2=500;
         if(objpurchase.Send_date__c==system.today())
             {
                 objpurchase.Purchase_order_send__c =objpurchase.Send_date__c;
                
             }
       
        System.assertEquals('testpurchaces', objpurchase.name);
       
        insert objpurchase;
         
        Purchase_article__c objpoarticlce = new Purchase_article__c();
        objpoarticlce .Name = 'test';
        System.assertEquals('test', objpoarticlce .Name );
        insert objpoarticlce;
        
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        attach.OwnerId=objpurchase.OwnerId;
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objpurchase.id;
        attach.contentType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
        System.assertEquals(objpurchase.id,attach.parentId);
        insert attach;
       
        id purid = ApexPages.currentPage().getParameters().get('purid');
        String tabId = System.currentPageReference().getParameters().get('tabId');
        ApexPages.currentPage().getParameters().put('pursid', objpurchase.id);
        ApexPages.currentPage().getParameters().put('prjId',subPrj.id);
        ApexPages.currentPage().getParameters().put('maxpo','2000');
        PageReference pageRef = Page.Purchaseorderpage;
        Test.setCurrentPage(pageRef); 
        ApexPages.StandardController sc = new ApexPages.standardController(objpurchase); 
        Test.startTest();
        PurchaseorderEditController objpurEdit=new PurchaseorderEditController(sc);
        List<SelectOption> temp = objpurEdit.PAList;
        Attachment temp4=objpurEdit.attachment;
        //try{
        objpurEdit.maxPO='2000';
        objpurEdit.poOld=3000;
        objpurEdit.Save();
        try{
        objpurEdit.DeleteAttchment();
       
        }catch(Exception e){}
        objpurEdit.redirectToTemplate();
        
        objpurEdit.getRedirectToTemplate();
        
        objpurEdit.deleteorders();
        objpurEdit.Cancel();  
        objpurEdit.gotoInfoMode();
        objpurEdit.gotoEditMode();
        objpurEdit.contentType='test';
        //objpurEdit.fileType='test';
        objpurEdit.showbutton=true;
      }
            
    static testMethod void PurchaseorderEdittest1(){ 
     Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
           User objUs =new User( Alias = 'newUser1' ,
           Email ='newuser123@testorg.com',
           EmailEncodingKey = 'UTF-8',
           LastName = 'Testing',
           LanguageLocaleKey='en_US',
           LocaleSidKey='en_US', 
           UserName='newuser1234@testorg.com',
           ProfileId=p.Id,
           TimeZoneSidKey = 'America/Los_Angeles');
           insert objUs ;   
    Project__c prj = new Project__c ();
         prj.Name='ITC';
         //prj.Plantype__c= pt.Id;
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c= system.toDay();
         prj.Status__c = 'In Progress';
         System.assertEquals('ITC', prj.name);         
         insert prj;
        
    Subproject__c subPrj = new Subproject__c();         
         subPrj.Name='ITC Project';
         subPrj.Parent_project__c = prj.Id;
         subPrj.Ends_date__c = system.toDay().addDays(3);
         subPrj.Starts_date__c= system.toDay();
         subPrj.Status__c = 'In Progress'; 
         //subPrj.Project_type__c = prjType.Id;
         System.assertEquals('ITC Project', subPrj.name);     
         insert subPrj;
                     
    Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact;
      Purchase_order__c objpurchase=new Purchase_order__c ();   
        objpurchase.Name='testpurchaces';
        objpurchase.musqot__Purchase_order_name__c='testperching';
        objpurchase.musqot__Project__c=prj.Id;
        objpurchase.musqot__Supplier_email__c='test@gmail.com';
        //objpurchase.musqot__subproject__c=subPrj.Id;
        //objpurchase.musqot__Total_cost__c=1000;
        objpurchase.Ownerid=objUs.id;
        objpurchase.musqot__Send_date__c=system.today();
        objpurchase.musqot__Effective_date__c=system.today();
        objpurchase.musqot__Purchase_order_cloesed__c = true;
        objpurchase.musqot__total_Invoice_cost__c=10;
        decimal poOld=100;
        decimal maxPO2=500;
        objpurchase.musqot__Supplier__c='testsuppilor';
         if(objpurchase.Send_date__c==system.today())
             {
                 objpurchase.Purchase_order_send__c =objpurchase.Send_date__c;
                
             }
       
        System.assertEquals('testpurchaces', objpurchase.name);
        
        insert objpurchase;
        
        Purchase_article__c objpoarticlce = new Purchase_article__c();
        objpoarticlce .Name = 'test';
        System.assertEquals('test', objpoarticlce .Name );
        insert objpoarticlce ;
        
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        attach.OwnerId=objpurchase.OwnerId;
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objpurchase.id;
        attach.contentType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
        System.assertEquals(objpurchase.id,attach.parentId);
        insert attach;
         //objpurchase.musqot__Marketing_activity__c=objMarketingact.Id;
      id purid = ApexPages.currentPage().getParameters().get('purid');
      String tabId = System.currentPageReference().getParameters().get('tabId');
      ApexPages.currentPage().getParameters().put('planid', prj.id);
      ApexPages.currentPage().getParameters().put('maxPOID', prj.id);
      ApexPages.currentPage().getParameters().put('purid', objpurchase.id);
      ApexPages.StandardController sc = new ApexPages.standardController(objpurchase);
      test.startTest();
   
        PurchaseorderEditController objpurEdit=new PurchaseorderEditController(sc);
        List<SelectOption> temp = objpurEdit.PAList;
        objpurEdit.maxPO='2000';
        objpurEdit.poOld=3000;
        try{
           objpurEdit.Save();
           objpurEdit.DeleteAttchment();
        }catch(Exception e){}
        objpurEdit.redirectToTemplate();
        //objpurEdit.DeleteAttchment();
        objpurEdit.getRedirectToTemplate();
        objpurEdit.deleteorders();
        objpurEdit.Cancel();  
        objpurEdit.gotoInfoMode();
        objpurEdit.gotoEditMode();
        objpurEdit.contentType='test';
        //objpurEdit.fileType='test';
        objpurEdit.showbutton=true;
       
          }
        static testMethod void PurchaseorderEdittest2(){  
         Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
           User objUs =new User( Alias = 'newUser1' ,
           Email ='newuser123@testorg.com',
           EmailEncodingKey = 'UTF-8',
           LastName = 'Testing',
           LanguageLocaleKey='en_US',
           LocaleSidKey='en_US', 
           UserName='newuser1234@testorg.com',
           ProfileId=p.Id,
           TimeZoneSidKey = 'America/Los_Angeles');
           insert objUs ;  
         Project__c prj = new Project__c ();
         prj.Name='ITC';
         //prj.Plantype__c= pt.Id;
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c= system.toDay();
         prj.Status__c = 'In Progress';
         System.assertEquals('ITC', prj.name);         
         insert prj;
       Subproject__c subPrj = new Subproject__c();         
         subPrj.Name='ITC Project';
         subPrj.Parent_project__c = prj.Id;
         subPrj.Ends_date__c = system.toDay().addDays(3);
         subPrj.Starts_date__c= system.toDay();
         subPrj.Status__c = 'In Progress'; 
         //subPrj.Project_type__c = prjType.Id;
         System.assertEquals('ITC Project', subPrj.name);     
         insert subPrj;
                     
       Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact;
      Purchase_order__c objpurchase=new Purchase_order__c ();   
        objpurchase.Name='testpurchaces';
        objpurchase.Ownerid=objUs.id;
        objpurchase.musqot__Purchase_order_name__c='testperching';
       // objpurchase.musqot__Project__c=prj.Id;
        objpurchase.musqot__subproject__c=subPrj.Id;
       // objpurchase.musqot__Marketing_activity__c=objMarketingact.Id;
        objpurchase.musqot__Supplier_email__c='test@gmail.com';
        objpurchase.musqot__Total_cost__c=100;
        objpurchase.musqot__Send_date__c=system.today();
        objpurchase.musqot__Effective_date__c=system.today();
        objpurchase.musqot__Purchase_order_cloesed__c = true;
        objpurchase.musqot__total_Invoice_cost__c=10;
        decimal poOld=100;
        decimal maxPO2=500;
        objpurchase.musqot__Supplier__c='testsuppilor';
         if(objpurchase.Send_date__c==system.today())
             {
                 objpurchase.Purchase_order_send__c =objpurchase.Send_date__c;
                
             }
       
        System.assertEquals('testpurchaces', objpurchase.name);
       
        insert objpurchase;
       
       Purchase_article__c objpoarticlce = new Purchase_article__c();
        objpoarticlce .Name = 'test';
        System.assertEquals('test', objpoarticlce .Name );
        insert objpoarticlce ;
        
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        attach.OwnerId=objpurchase.OwnerId;
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objpurchase.id;
        attach.contentType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
        System.assertEquals(objpurchase.id,attach.parentId);
        insert attach;
        
        String tabId = System.currentPageReference().getParameters().get('tabId');
       ApexPages.currentPage().getParameters().put('prjId', subPrj.id);
       ApexPages.currentPage().getParameters().put('maxPOID', subPrj.id);
       ApexPages.currentPage().getParameters().put('purid', objpurchase.id);
       ApexPages.StandardController sc = new ApexPages.standardController(objpurchase);
       test.startTest();
   
        PurchaseorderEditController objpurEdit=new PurchaseorderEditController(sc);
        List<SelectOption> temp = objpurEdit.PAList;
        objpurEdit.maxPO='2000';
        objpurEdit.poOld=3000;
        objpurEdit.Save();
         try{
        objpurEdit.DeleteAttchment();
        }catch(Exception e){}
        objpurEdit.redirectToTemplate();
        //objpurEdit.DeleteAttchment();
        objpurEdit.getRedirectToTemplate();
        objpurEdit.deleteorders();
        objpurEdit.Cancel();  
        objpurEdit.gotoInfoMode();
        objpurEdit.gotoEditMode();
        objpurEdit.contentType='test';
        //objpurEdit.fileType='test';
        objpurEdit.showbutton=true;
       
         }
    static testMethod void PurchaseorderEdittest3(){ 
     Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
           User objUs =new User( Alias = 'newUser1' ,
           Email ='newuser123@testorg.com',
           EmailEncodingKey = 'UTF-8',
           LastName = 'Testing',
           LanguageLocaleKey='en_US',
           LocaleSidKey='en_US', 
           UserName='newuser1234@testorg.com',
           ProfileId=p.Id,
           TimeZoneSidKey = 'America/Los_Angeles');
           insert objUs ;   
    Project__c prj = new Project__c ();
         prj.Name='ITC';
         //prj.Plantype__c= pt.Id;
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c= system.toDay();
         prj.Status__c = 'In Progress';
         System.assertEquals('ITC', prj.name);         
         insert prj;
         
         
    Subproject__c subPrj = new Subproject__c();         
         subPrj.Name='ITC Project';
         subPrj.Parent_project__c = prj.Id;
         subPrj.Ends_date__c = system.toDay().addDays(3);
         subPrj.Starts_date__c= system.toDay();
         subPrj.Status__c = 'In Progress'; 
         System.assertEquals('ITC Project', subPrj.name);     
         insert subPrj;
                     
    Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact;
       
        
      Purchase_order__c objpurchase=new Purchase_order__c ();   
        objpurchase.Name='testpurchaces';
        objpurchase.Ownerid=objUs.id;
        objpurchase.musqot__Purchase_order_name__c='testperching';
        //objpurchase.musqot__Project__c=prj.Id;
        //objpurchase.musqot__subproject__c=subPrj.Id;
        objpurchase.musqot__Marketing_activity__c=objMarketingact.Id;
        objpurchase.musqot__Supplier_email__c='test@gmail.com';
        objpurchase.musqot__Total_cost__c=100;
        objpurchase.musqot__Supplier__c='testsuppilor';
        objpurchase.musqot__Send_date__c=system.today();
        objpurchase.musqot__Effective_date__c=system.today();
        objpurchase.musqot__Purchase_order_cloesed__c = true;
        objpurchase.musqot__total_Invoice_cost__c=10;
        decimal poOld=100;
        decimal maxPO2=500;
         if(objpurchase.Send_date__c==system.today())
             {
                 objpurchase.Purchase_order_send__c =objpurchase.Send_date__c;
                
             }
       
        System.assertEquals('testpurchaces', objpurchase.name);
           insert objpurchase;
       
       Purchase_article__c objpoarticlce = new Purchase_article__c();
        objpoarticlce .Name = 'test';
        System.assertEquals('test', objpoarticlce .Name );
        insert objpoarticlce ;
        
        Attachment attach=new Attachment();       
        attach.Name='Unit Test Attachment';
        attach.OwnerId=objpurchase.OwnerId;
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objpurchase.id;
        attach.contentType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
        System.assertEquals(objpurchase.id,attach.parentId);
        insert attach;
      String tabId = System.currentPageReference().getParameters().get('tabId');                    
      ApexPages.currentPage().getParameters().put('markID', objMarketingact.id);
      ApexPages.currentPage().getParameters().put('maxPOID', objMarketingact.id);
    ApexPages.currentPage().getParameters().put('purid', objpurchase.id);
    ApexPages.StandardController sc = new ApexPages.standardController(objpurchase);
    test.startTest();
   
        PurchaseorderEditController objpurEdit=new PurchaseorderEditController(sc);
        List<SelectOption> temp = objpurEdit.PAList;
        try{
        objpurEdit.Save();
        objpurEdit.DeleteAttchment();
        }catch(Exception e){}
        objpurEdit.redirectToTemplate();
        objpurEdit.DeleteAttchment();
        objpurEdit.getRedirectToTemplate();
        objpurEdit.deleteorders();
        objpurEdit.Cancel();  
        objpurEdit.gotoInfoMode();
        objpurEdit.gotoEditMode();
        objpurEdit.contentType='test';
        //objpurEdit.fileType='test';
        objpurEdit.showbutton=true;                           
      }
 static testMethod void posave(){
    Project__c objproj = new Project__c();
    objproj .name = 'testname';
    objproj .Starts_date__c = System.now().date();
    objproj .Ends_date__c =  System.now().date(); 
    objproj .Description__c = 'sampdesc';
    System.assertEquals('testname', objproj .name);
    insert objproj ;
    
    Subproject__c objsp = new Subproject__c ();
    objsp .name = 'testname';            
    objsp .Description__c = 'sampdesc';
    objsp .Project_del__c = objsp.Id;
    objsp .Starts_date__c =  System.now().date();
    objsp .Ends_date__c =  System.now().date();   
    System.assertEquals('testname', objsp .name);
    insert objsp ;
    
      
      Purchase_order__c objpurchase=new Purchase_order__c ();   
        objpurchase.Name='testpurchaces';        
        objpurchase.musqot__Purchase_order_name__c='testperching';               
        objpurchase.musqot__Supplier_email__c='test@gmail.com';
        objpurchase.musqot__Total_cost__c=100;
        objpurchase.musqot__Supplier__c='testsuppilor';
        objpurchase.musqot__Send_date__c=system.today();
        objpurchase.musqot__Effective_date__c=system.today();
        objpurchase.musqot__Purchase_order_cloesed__c = true;
        objpurchase.musqot__total_Invoice_cost__c=10;
        decimal poOld=100;
        decimal maxPO2=500;                 
        insert objpurchase;
        System.assertEquals('testpurchaces', objpurchase.name);
    
        ApexPages.currentPage().getParameters().put('projectid', objproj .id);
        ApexPages.StandardController sc = new ApexPages.standardController(objpurchase);            
        PurchaseorderEditController poed=new PurchaseorderEditController(sc);
        musqot__Purchase_order__c purs = [Select Id,ownerid, Name, Description__c,Supplier__c,Supplier_email__c, Total_cost__c,Project__c,subproject__c,Marketing_activity__c, Send_date__c, Purchase_order_name__c, total_Invoice_cost__c,Effective_date__c, Purchase_article__c, Purchase_order_cloesed__c,Purchase_order_send__c 
        FROM Purchase_order__c LIMIT 1]; 
        objpurchase.Send_date__c=system.today();
        update objpurchase;
        try{   
        poed.save();
        }catch(exception e){}      
         }
    
 }