/******************************************************************
Class Name: PurchaseorderContrllorTest
Author:Nagaraju G             Last modified by: chaithanya daggumati
Date: 28/8/2014               Date: 18/2/2015 
********©2013 Musqot marketing technology Pvt ltd ******************/

@isTest(seeAllData=true)
public class PurchaseorderContrllorTest{
   static testMethod void Purchaseordertest(){ 
        Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
        User u2 =new User( Alias = 'newUser1' ,
        Email ='newuser123@testorg.com',
        EmailEncodingKey = 'UTF-8',
        LastName = 'Testing',
        LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', 
        UserName='newuser1234@testorg.com',
        ProfileId=p.Id,
        TimeZoneSidKey = 'America/Los_Angeles');
        insert u2;
    Contact c = new Contact(firstname='test',lastname='test',email='no@email.com');
    insert c;  
   Project__c prj = new Project__c ();
         prj.Name='ITC';
         prj.Plantype__c=  prj.Id;
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
         subPrj.Parent_project__c = prj.Id;
         //subPrj.Project_del__c = prj.Id;         
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
        objpurchase.musqot__Purchase_order_name__c='testperchage';
        objpurchase.musqot__Project__c=prj.Id;
        objpurchase.musqot__subproject__c=subPrj.Id;
        objpurchase.musqot__Total_cost__c=100;
        objpurchase.musqot__Supplier__c='testsuppilor';
        System.assertEquals('testsuppilor', objpurchase.musqot__Supplier__c);
        insert objpurchase;
        
        Purchase_order_setting__c objpoorderset = new Purchase_order_setting__c();
        objpoorderset .musqot__PO_Startnumber__c = 10;
        objpoorderset.musqot__PO_Lastnumber__c =15;
        objpoorderset.musqot__PO_Prefix__c = 'test';
        objpoorderset.musqot__PO_Autoprefix__c = 'test';
        objpoorderset.musqot__PO_External__c = 'test';
        System.assertEquals(10, objpoorderset .musqot__PO_Startnumber__c);
        insert objpoorderset ;
        
        Attachment attachment=new Attachment();
        attachment.OwnerId = u2.Id;
        attachment.OwnerId = userinfo.getuserid();
        attachment.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attachment.body=bodyBlob;
        attachment.ParentId = objpurchase.Id ;
        insert attachment;
        if(objpurchase.Send_date__c ==System.today() && objpurchase.musqot__Supplier_email__c != null && objpurchase.musqot__Supplier_email__c != ''){ 
        Purchase_order__c  purchOrdr = [SELECT Id,musqot__Purchase_order_name__c,musqot__Supplier_email__c,Name,musqot__Total_cost__c,musqot__Description__c, OwnerId FROM Purchase_order__c WHERE Id = :objpurchase.Id];
          EmailTemplate template = [SELECT Id, name,Subject, HtmlValue, Body FROM EmailTemplate WHERE name= 'Purchaseorder'];  
           Contact cnt = new Contact();
            cnt.LastName = 'Supplier';
            cnt.Email = purchOrdr .musqot__Supplier_email__c;
            insert cnt;
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setWhatId(purchOrdr .Id);
            mail.setTargetObjectId(cnt.Id);
            mail.setTemplateId(template.Id);
            mail.saveAsActivity = false;
            
              if(attachment.body<>null){
                //Set email file attachments
                List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                // Add to attachment file list
                Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                efa.setFileName(attachment.Name);
                efa.setBody(attachment.Body);
                efa.setContentType(attachment.ContentType);
                fileAttachments.add(efa);
                mail.setFileAttachments(fileAttachments);
            }
            //Send email
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
            delete cnt;           
        }       
          
           
        Purchase_article__c objpoarticlce = new Purchase_article__c();
        objpoarticlce .Name = 'test';
        System.assertEquals('test', objpoarticlce .Name );
        insert objpoarticlce ;
        
        ApexPages.currentPage().getParameters().put('id', objpurchase.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objpurchase); 
        test.startTest();
        PurchaseorderContrllor objpur=new PurchaseorderContrllor (sc);
        List<SelectOption> temp = objpur.PAList;
        try{
        objpur.insertOrders();
        objpur.cancel();   
         } catch(exception e){}         
        try{
        objpur.sendEmail(objpurchase, attachment);
        }catch(exception e){}
        objpur.contenttype='test';
        objpur.a1=0.1;
        objpur.a2='test';
        objpur.a3='test';
        test.stoptest();
               }
     static  testMethod void Purchaseordertest1(){   
   Project__c prj = new Project__c ();
         prj.Name='ITC';
         prj.Plantype__c=  prj.Id;
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
         subPrj.Parent_project__c = prj.Id;
         //subPrj.Project_del__c = prj.Id;         
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
        objpurchase.musqot__Purchase_order_name__c='testperchage';
        objpurchase.musqot__Project__c=prj.Id;
        objpurchase.musqot__subproject__c=subPrj.Id;
        objpurchase.musqot__Total_cost__c=100;
        objpurchase.musqot__Supplier__c='testsuppilor';
        System.assertEquals('testsuppilor', objpurchase.musqot__Supplier__c);
        insert objpurchase;
        
        Purchase_order_setting__c objpoorderset = new Purchase_order_setting__c();
        objpoorderset .musqot__PO_Startnumber__c = 10;
        objpoorderset.musqot__PO_Lastnumber__c =15;
        objpoorderset.musqot__PO_Prefix__c = 'test';
        objpoorderset.musqot__PO_Autoprefix__c = 'test';
        objpoorderset.musqot__PO_External__c = 'test';
        System.assertEquals(10, objpoorderset .musqot__PO_Startnumber__c);
        insert objpoorderset ;
        
        Attachment attachment=new Attachment();
        attachment.OwnerId = userinfo.getuserid();
        attachment.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attachment.body=bodyBlob;
        attachment.ParentId = objpurchase.Id ;
        insert attachment;
         if(objpurchase.Send_date__c ==System.today() && objpurchase.musqot__Supplier_email__c != null && objpurchase.musqot__Supplier_email__c != ''){ 
        Purchase_order__c  purchOrdr = [SELECT Id,musqot__Purchase_order_name__c,musqot__Supplier_email__c,Name,musqot__Total_cost__c,musqot__Description__c, OwnerId FROM Purchase_order__c WHERE Id = :objpurchase.Id];
          EmailTemplate template = [SELECT Id, name,Subject, HtmlValue, Body FROM EmailTemplate WHERE name= 'Purchaseorder'];  
           Contact cnt = new Contact();
            cnt.LastName = 'Supplier';
            cnt.Email = purchOrdr .musqot__Supplier_email__c;
            insert cnt;
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           // String[] toAddresses = new String[]{orders.musqot__Supplier_email__c};
            //system.debug('toadresses--->'+toAddresses);
            //mail.setToAddresses(toAddresses);
            mail.setWhatId(purchOrdr .Id);
            mail.setTargetObjectId(cnt.Id);
            mail.setTemplateId(template.Id);
            mail.saveAsActivity = false;
            
              if(attachment.body<>null){
                //Set email file attachments
                List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                // Add to attachment file list
                Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                efa.setFileName(attachment.Name);
                efa.setBody(attachment.Body);
                efa.setContentType(attachment.ContentType);
                fileAttachments.add(efa);
                mail.setFileAttachments(fileAttachments);
            }
            //Send email
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
            delete cnt;           
        }       
          
           
        Purchase_article__c objpoarticlce = new Purchase_article__c();
        objpoarticlce .Name = 'test';
        System.assertEquals('test', objpoarticlce .Name );
        insert objpoarticlce ;
        
        ApexPages.currentPage().getParameters().put('planid', prj.id);
         String tabId = System.currentPageReference().getParameters().get('tabId');
          
        ApexPages.StandardController sc = new ApexPages.standardController(objpurchase); 
        test.startTest();
        PurchaseorderContrllor objpur=new PurchaseorderContrllor (sc);
        List<SelectOption> temp = objpur.PAList;
        objpur.insertOrders();
        objpur.cancel();
        try{
        objpur.sendEmail(objpurchase, attachment);
        }catch(exception e){}
        objpur.contenttype='test';
        objpur.a1=0.1;
        objpur.a2='test';
        objpur.a3='test'; 
        //objpur.getRedirectToTemplate();
        //objpur.redirectToTemplate(); 
        test.stoptest();  
               }
     static testMethod void Purchaseordertest2(){   
   Project__c prj = new Project__c ();
         prj.Name='ITC';
         prj.Plantype__c=  prj.Id;
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
         subPrj.Parent_project__c = prj.Id;
         //subPrj.Project_del__c = prj.Id;         
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
        objpurchase.musqot__Purchase_order_name__c='testperchage';
        objpurchase.musqot__Project__c=prj.Id;
        objpurchase.musqot__subproject__c=subPrj.Id;
        objpurchase.musqot__Total_cost__c=100;
        objpurchase.musqot__Supplier__c='testsuppilor';
        System.assertEquals('testsuppilor', objpurchase.musqot__Supplier__c);
        insert objpurchase;
        
        Purchase_order_setting__c objpoorderset = new Purchase_order_setting__c();
        objpoorderset .musqot__PO_Startnumber__c = 10;
        objpoorderset.musqot__PO_Lastnumber__c =15;
        objpoorderset.musqot__PO_Prefix__c = 'test';
        objpoorderset.musqot__PO_Autoprefix__c = 'test';
        objpoorderset.musqot__PO_External__c = 'test';
        System.assertEquals(10, objpoorderset .musqot__PO_Startnumber__c);
        insert objpoorderset ;
        
        Attachment attachment=new Attachment();
        attachment.OwnerId = userinfo.getuserid();
        attachment.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attachment.body=bodyBlob;
        attachment.ParentId = objpurchase.Id ;
        insert attachment;
         if(objpurchase.Send_date__c ==System.today() && objpurchase.musqot__Supplier_email__c != null && objpurchase.musqot__Supplier_email__c != ''){ 
        Purchase_order__c  purchOrdr = [SELECT Id,musqot__Purchase_order_name__c,musqot__Supplier_email__c,Name,musqot__Total_cost__c,musqot__Description__c, OwnerId FROM Purchase_order__c WHERE Id = :objpurchase.Id];
          EmailTemplate template = [SELECT Id, name,Subject, HtmlValue, Body FROM EmailTemplate WHERE name= 'Purchaseorder'];  
           Contact cnt = new Contact();
            cnt.LastName = 'Supplier';
            cnt.Email = purchOrdr .musqot__Supplier_email__c;
            insert cnt;
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           // String[] toAddresses = new String[]{orders.musqot__Supplier_email__c};
            //system.debug('toadresses--->'+toAddresses);
            //mail.setToAddresses(toAddresses);
            mail.setWhatId(purchOrdr .Id);
            mail.setTargetObjectId(cnt.Id);
            mail.setTemplateId(template.Id);
            mail.saveAsActivity = false;
            
              if(attachment.body<>null){
                //Set email file attachments
                List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                // Add to attachment file list
                Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                efa.setFileName(attachment.Name);
                efa.setBody(attachment.Body);
                efa.setContentType(attachment.ContentType);
                fileAttachments.add(efa);
                mail.setFileAttachments(fileAttachments);
            }
            //Send email
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
            delete cnt;           
        }       
          
           
        Purchase_article__c objpoarticlce = new Purchase_article__c();
        objpoarticlce .Name = 'test';
        System.assertEquals('test', objpoarticlce .Name );
        insert objpoarticlce ;
        
        ApexPages.currentPage().getParameters().put('prjId', subPrj.id);
         String tabId = System.currentPageReference().getParameters().get('tabId');  
        ApexPages.StandardController sc = new ApexPages.standardController(objpurchase); 
        test.startTest();
        PurchaseorderContrllor objpur=new PurchaseorderContrllor (sc);
        List<SelectOption> temp = objpur.PAList;
        objpur.insertOrders();
        objpur.cancel();
         try{
        objpur.sendEmail(objpurchase, attachment);
        }catch(exception e){}
        //objpur.getRedirectToTemplate();
        //objpur.redirectToTemplate(); 
        test.stoptest();  
               }
    static testMethod void Purchaseordertest3(){   
   Project__c prj = new Project__c ();
         prj.Name='ITC';
         prj.Plantype__c=  prj.Id;
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
         subPrj.Parent_project__c = prj.Id;
         //subPrj.Project_del__c = prj.Id;         
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
        objpurchase.musqot__Purchase_order_name__c='testperchage';
        objpurchase.musqot__Project__c=prj.Id;
        objpurchase.musqot__subproject__c=subPrj.Id;
        objpurchase.musqot__Total_cost__c=100;
        objpurchase.musqot__Supplier__c='testsuppilor';
        System.assertEquals('testsuppilor', objpurchase.musqot__Supplier__c);
        insert objpurchase;
        Attachment attachment=new Attachment();
        attachment.OwnerId = userinfo.getuserid();
        attachment.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attachment.body=bodyBlob;
        attachment.ParentId = objpurchase.Id ;
        insert attachment;
         if(objpurchase.Send_date__c ==System.today() && objpurchase.musqot__Supplier_email__c != null && objpurchase.musqot__Supplier_email__c != ''){ 
        Purchase_order__c  purchOrdr = [SELECT Id,musqot__Purchase_order_name__c,musqot__Supplier_email__c,Name,musqot__Total_cost__c,musqot__Description__c, OwnerId FROM Purchase_order__c WHERE Id = :objpurchase.Id];
          EmailTemplate template = [SELECT Id, name,Subject, HtmlValue, Body FROM EmailTemplate WHERE name= 'Purchaseorder'];  
          Contact cnt = new Contact();
          cnt.LastName = 'Supplier';
          cnt.Email = purchOrdr .musqot__Supplier_email__c;
          insert cnt;
          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setWhatId(purchOrdr .Id);
        mail.setTargetObjectId(cnt.Id);
        mail.setTemplateId(template.Id);
        mail.saveAsActivity = false;
        
          if(attachment.body<>null){
            //Set email file attachments
            List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
            // Add to attachment file list
            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
            efa.setFileName(attachment.Name);
            efa.setBody(attachment.Body);
            efa.setContentType(attachment.ContentType);
            fileAttachments.add(efa);
            mail.setFileAttachments(fileAttachments);
         }
            //Send email
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
            delete cnt;           
        }       
          
        
        Purchase_order_setting__c objpoorderset = new Purchase_order_setting__c();
        objpoorderset .musqot__PO_Startnumber__c = 10;
        System.assertEquals(10, objpoorderset .musqot__PO_Startnumber__c);
        insert objpoorderset ;
           
        Purchase_article__c objpoarticlce = new Purchase_article__c();
        objpoarticlce .Name = 'test';
        System.assertEquals('test', objpoarticlce .Name );
        insert objpoarticlce ;
        
        contact objcont = new contact();
        objcont .LastName = 'testname';
        objcont .Email = 'newuser123@testorg.com';
        System.assertEquals('testname', objcont .LastName);
        insert objcont ; 
        
        ApexPages.currentPage().getParameters().put('markID', objMarketingact.id);
         String tabId = System.currentPageReference().getParameters().get('tabId');  
        ApexPages.StandardController sc = new ApexPages.standardController(objpurchase); 
        test.startTest();
        PurchaseorderContrllor objpur=new PurchaseorderContrllor (sc);
        //objpur.SingleEmailMessage ;
        List<SelectOption> temp = objpur.PAList;
        objpur.insertOrders();
        objpur.cancel();
        try{
        objpur.sendEmail(objpurchase, attachment);
        }catch(exception e){}
        objpur.contenttype='test';
        objpur.a1=0.1;
        objpur.a2='test';
        objpur.a3='test';
        //objpur.getRedirectToTemplate();
         //objpur.redirectToTemplate(); 
        test.stoptest();  
      }
   static testMethod void Purchaseorderinsert(){
       Project__c prj = new Project__c ();
         prj.Name='ITC';
         prj.Plantype__c=  prj.Id;
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
         subPrj.Parent_project__c = prj.Id;
         //subPrj.Project_del__c = prj.Id;         
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
        objpurchase.musqot__Purchase_order_name__c='testperchage';
        objpurchase.musqot__Project__c=prj.Id;
        objpurchase.musqot__subproject__c=subPrj.Id;
        objpurchase.musqot__Total_cost__c=100;
        objpurchase.musqot__Supplier__c='testsuppilor';
        System.assertEquals('testsuppilor', objpurchase.musqot__Supplier__c);
        insert objpurchase;
         EmailTemplate template = new EmailTemplate();
         template .name='test';
         template.subject='test';
       
            
           Contact cnt = new Contact();
            cnt.LastName = 'Supplier';
            cnt.Email = objpurchase.musqot__Supplier_email__c;
            insert cnt;
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setWhatId(objpurchase.Id);
            mail.setTargetObjectId(cnt.Id);
            mail.setTemplateId(template.Id);
            mail.saveAsActivity = false;
        ApexPages.currentPage().getParameters().put('markID', objMarketingact.id); 
        ApexPages.StandardController sc = new ApexPages.standardController(objpurchase);
        PurchaseorderContrllor purinsert=new PurchaseorderContrllor (sc);
        purinsert.insertOrders();
           }
    static testMethod void Purchaseorderinsert1(){
        Project__c prj = new Project__c ();
         prj.Name='ITC';
         prj.Ends_date__c = system.toDay().addDays(3);
         prj.Starts_date__c= system.toDay();
         prj.Status__c = 'In Progress';
         System.assertEquals('ITC', prj.name);         
         insert prj;
        
        Purchase_order_setting__c objpoorderset = new Purchase_order_setting__c();
        objpoorderset .PO_Startnumber__c = 10;
        objpoorderset .PO_Lastnumber__c = 5;
        //objpoorderset .PO_Prefix__c = null;
        System.assertEquals(10, objpoorderset .PO_Startnumber__c);
        insert objpoorderset ;
        PageReference pageRef = Page.ProjectDetails;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('projectid', prj.id);
        ApexPages.StandardController sc = new ApexPages.standardController(prj);
        PurchaseorderContrllor purinsert1=new PurchaseorderContrllor (sc);
        purinsert1.insertOrders();
    }    
 }