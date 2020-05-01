/*******************************************************
Class Name: InvoiceEditControllerTest
Author:Nagaraju G              Last modified by: G Janardhanreddy
Date:28/8/2014                 Date:19/03/2015
********©2013 Musqot marketing technology Pvt ltd **********/
@isTest//(seeAllData=true)
public class InvoiceEditControllerTest{
    
    static testMethod void InvoiceeditControlleratplan(){
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
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=u2.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
        
        Project__c prj = new Project__c ();
        prj.Name='ITC';
        //prj.Plantype__c= pt.Id;
        prj.Ends_date__c = system.toDay().addDays(3);
        prj.Starts_date__c= system.toDay();
        prj.Status__c = 'In Progress';
        prj.OwnerId=plm.userid__c;
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
        
        Purchase_order__c objpo = new Purchase_order__c();
        objpo.Name = 'testname';
        objpo.Purchase_order_name__c = 'test';
        objpo.Total_cost__c  = 1000;
        objpo.Description__c = 'test';
        objpo.Effective_date__c = Date.Today();
        objpo.Send_date__c = Date.Today();
        objpo.Supplier__c = 'test';
        objpo.Project__c = prj.Id;
        objpo.Purchase_order_cloesed__c=false;
        objpo.musqot__subproject__c = subprj.Id;
        objpo.musqot__Marketing_activity__c = objMarketingact.Id;
        objpo.Supplier_email__c = 'standarduser@abc.com';
        System.assertEquals('testname', objpo .Name);
        insert objpo ; 
        
        Purchase_article__c objpog = new Purchase_article__c();
        objpog.name ='testrec';
        System.assertEquals('testrec', objpog.name);
        insert objpog;
        
        Invoice__c  objInvoice=new Invoice__c();
        objInvoice.Name='testinvoice';
        objInvoice.musqot__Total_spent__c = 4000;                
        objInvoice.musqot__supplier__c='testsupplier'; 
        objInvoice.OwnerId=u2.id;    
        objInvoice.musqot__Project__c=prj.Id;
        //objInvoice.musqot__subproject__c=subprj.Id;
        //objInvoice.musqot__Marketing_activity__c=objMarketingact.Id;
        objInvoice.musqot__Purchase_orders__c=objpo.Id;
        objInvoice.musqot__Description__c='This for testing';
        System.assertEquals('testinvoice', objInvoice.Name);
        insert objInvoice;
        
        Attachment attach=new Attachment();
        attach.OwnerId = u2.Id;       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objInvoice.id;
        attach.contentType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
        System.assertEquals(objInvoice.id,attach.parentId);
        insert attach;
        
        Purchase_order__c purOrdr = [SELECT Id,Purchase_order_cloesed__c FROM Purchase_order__c where id=:objInvoice.musqot__Purchase_orders__c limit 1];  
        if(purOrdr != null){
            purOrdr.Purchase_order_cloesed__c = true;
            update purOrdr;
        }
        Invoice__c  objINV=[SELECT Name,musqot__supplier__c from Invoice__c  where id=:objInvoice.Id limit 1]; 
        objINV.Name='musqot';
        objINV.musqot__supplier__c='amazon';
        Update objINV;  
        
        test.starttest();
        ApexPages.currentPage().getParameters().put('invid', objINV.id);
        ApexPages.currentPage().getParameters().put('planid', prj.id);
       // ApexPages.currentPage().getParameters().put('prjid', subPrj.id);
        //ApexPages.currentPage().getParameters().put('markID', objMarketingact.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objINV);
        InvoiceEditController objinvedit = new InvoiceEditController(sc);
        objinvedit.subprjid= subPrj.Id;
        objinvedit.projectid= prj.Id;
        objinvedit.mrkId= objMarketingact.Id;
        Attachment att= objinvedit.attachment;
        objinvedit.subprjid= subPrj.Id;
        List<SelectOption> temp=objinvedit.PAList;
        objinvedit.attch();
        objinvedit.gotoEdit();
        objinvedit.contentType='test';
        objinvedit.Save();
        objinvedit.deleteinvoice();
        objinvedit.Cancel();
        objinvedit.DeleteAttchment();
        test.stoptest();
    }
    static testMethod void InvoiceeditControlleratproject(){
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
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=u2.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
        
        Project__c prj = new Project__c ();
        prj.Name='ITC';
        //prj.Plantype__c= pt.Id;
        prj.Ends_date__c = system.toDay().addDays(3);
        prj.Starts_date__c= system.toDay();
        prj.Status__c = 'In Progress';
        prj.OwnerId=plm.userid__c;
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
        
        Purchase_order__c objpo = new Purchase_order__c();
        objpo.Name = 'testname';
        objpo.Purchase_order_name__c = 'test';
        objpo.Total_cost__c  = 1000;
        objpo.Description__c = 'test';
        objpo.Effective_date__c = Date.Today();
        objpo.Send_date__c = Date.Today();
        objpo.Supplier__c = 'test';
        objpo.Project__c = prj.Id;
        objpo.Purchase_order_cloesed__c=false;
        objpo.musqot__subproject__c = subprj.Id;
        objpo.musqot__Marketing_activity__c = objMarketingact.Id;
        objpo.Supplier_email__c = 'standarduser@abc.com';
        System.assertEquals('testname', objpo .Name);
        insert objpo ; 
        
        Purchase_article__c objpog = new Purchase_article__c();
        objpog.name ='testrec';
        System.assertEquals('testrec', objpog.name);
        insert objpog;
        
        Invoice__c  objInvoice=new Invoice__c();
        objInvoice.Name='testinvoice';
        objInvoice.musqot__Total_spent__c = 4000;                
        objInvoice.musqot__supplier__c='testsupplier'; 
        objInvoice.OwnerId=u2.id;    
        //objInvoice.musqot__Project__c=prj.Id;
        objInvoice.musqot__subproject__c=subprj.Id;
        //objInvoice.musqot__Marketing_activity__c=objMarketingact.Id;
        objInvoice.musqot__Purchase_orders__c=objpo.Id;
        objInvoice.musqot__Description__c='This for testing';
        System.assertEquals('testinvoice', objInvoice.Name);
        insert objInvoice;
        
        Attachment attach=new Attachment();
        attach.OwnerId = u2.Id;       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objInvoice.id;
        attach.contentType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
        System.assertEquals(objInvoice.id,attach.parentId);
        insert attach;
        
        Purchase_order__c purOrdr = [SELECT Id,Purchase_order_cloesed__c FROM Purchase_order__c where id=:objInvoice.musqot__Purchase_orders__c limit 1];  
        if(purOrdr != null){
            purOrdr.Purchase_order_cloesed__c = true;
            update purOrdr;
        }
        Invoice__c  objINV=[SELECT Name,musqot__supplier__c from Invoice__c  where id=:objInvoice.Id limit 1]; 
        objINV.Name='musqot';
        objINV.musqot__supplier__c='amazon';
        Update objINV;  
        
        test.starttest();
        ApexPages.currentPage().getParameters().put('invid', objINV.id);
        ApexPages.currentPage().getParameters().put('subprjid', subPrj.id);
       // ApexPages.currentPage().getParameters().put('planid', prj.id);
       // ApexPages.currentPage().getParameters().put('markID', objMarketingact.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objINV);
        InvoiceEditController objinvedit = new InvoiceEditController(sc);
        objinvedit.subprjid= subPrj.Id;
        objinvedit.projectid= prj.Id;
        objinvedit.mrkId= objMarketingact.Id;
        Attachment att= objinvedit.attachment;
        objinvedit.subprjid= subPrj.Id;
        List<SelectOption> temp=objinvedit.PAList;
        objinvedit.attch();
        objinvedit.gotoEdit();
        objinvedit.contentType='test';
        objinvedit.Save();
        objinvedit.deleteinvoice();
        objinvedit.Cancel();
        objinvedit.DeleteAttchment();
        test.stoptest();
    }
    static testMethod void InvoiceeditControlleratmark(){
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
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=u2.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
        Project__c prj = new Project__c ();
        prj.Name='ITC';
        //prj.Plantype__c= pt.Id;
        prj.Ends_date__c = system.toDay().addDays(3);
        prj.Starts_date__c= system.toDay();
        prj.Status__c = 'In Progress';
        prj.OwnerId=plm.userid__c;
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
        
        Purchase_order__c objpo = new Purchase_order__c();
        objpo.Name = 'testname';
        objpo.Purchase_order_name__c = 'test';
        objpo.Total_cost__c  = 1000;
        objpo.Description__c = 'test';
        objpo.Effective_date__c = Date.Today();
        objpo.Send_date__c = Date.Today();
        objpo.Supplier__c = 'test';
        objpo.Project__c = prj.Id;
        objpo.Purchase_order_cloesed__c=false;
        objpo.musqot__subproject__c = subprj.Id;
        objpo.musqot__Marketing_activity__c = objMarketingact.Id;
        objpo.Supplier_email__c = 'standarduser@abc.com';
        System.assertEquals('testname', objpo .Name);
        insert objpo ; 
        
        Purchase_article__c objpog = new Purchase_article__c();
        objpog.name ='testrec';
        System.assertEquals('testrec', objpog.name);
        insert objpog;
        
        Invoice__c  objInvoice=new Invoice__c();
        objInvoice.Name='testinvoice';
        objInvoice.musqot__Total_spent__c = 4000;                
        objInvoice.musqot__supplier__c='testsupplier'; 
        objInvoice.OwnerId=u2.id;    
        //objInvoice.musqot__Project__c=prj.Id;
        //objInvoice.musqot__subproject__c=subprj.Id;
        objInvoice.musqot__Marketing_activity__c=objMarketingact.Id;
        objInvoice.musqot__Purchase_orders__c=objpo.Id;
        objInvoice.musqot__Description__c='This for testing';
        System.assertEquals('testinvoice', objInvoice.Name);
        insert objInvoice;
        
        Attachment attach=new Attachment();
        attach.OwnerId = u2.Id;       
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=objInvoice.id;
        attach.contentType = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
        System.assertEquals(objInvoice.id,attach.parentId);
        insert attach;
        
        Purchase_order__c purOrdr = [SELECT Id,Purchase_order_cloesed__c FROM Purchase_order__c where id=:objInvoice.musqot__Purchase_orders__c limit 1];  
        if(purOrdr != null){
            purOrdr.Purchase_order_cloesed__c = true;
            update purOrdr;
        }
        Invoice__c  objINV=[SELECT Name,musqot__supplier__c from Invoice__c  where id=:objInvoice.Id limit 1]; 
        objINV.Name='musqot';
        objINV.musqot__supplier__c='amazon';
        Update objINV;  
        
        test.starttest();
        ApexPages.currentPage().getParameters().put('invid', objINV.id);
        ApexPages.currentPage().getParameters().put('mrkId', objMarketingact.id);
        //ApexPages.currentPage().getParameters().put('planid', prj.id);
       // ApexPages.currentPage().getParameters().put('planid', prj.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objINV);
        InvoiceEditController objinvedit = new InvoiceEditController(sc);
        objinvedit.subprjid= subPrj.Id;
        Purchase_order__c temp2=objinvedit.objPO;
        objinvedit.projectid= prj.Id;
        objinvedit.mrkId= objMarketingact.Id;
        Attachment att= objinvedit.attachment;
        objinvedit.subprjid= subPrj.Id;
        List<SelectOption> temp=objinvedit.PAList;
        objinvedit.attch();
        objinvedit.gotoEdit();
        objinvedit.contentType='test';
        objinvedit.Save();
        objinvedit.deleteinvoice();
        objinvedit.Cancel();
        objinvedit.DeleteAttchment();
        test.stoptest();
    }
  static testMethod void InvoiceeditControllersubpro(){
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
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=u2.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
        Project__c prj = new Project__c ();
        prj.Name='ITC';
        //prj.Plantype__c= pt.Id;
        prj.Ends_date__c = system.toDay().addDays(3);
        prj.Starts_date__c= system.toDay();
        prj.Status__c = 'In Progress';
      	prj.OwnerId=plm.userid__c;
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
        
        Invoice__c  objInvoice=new Invoice__c();
        objInvoice.Name='testinvoice';
        objInvoice.musqot__Total_spent__c = 4000;                
        objInvoice.musqot__supplier__c='testsupplier'; 
        objInvoice.musqot__Description__c='This for testing';
        System.assertEquals('testinvoice', objInvoice.Name);
        insert objInvoice;
        
        ApexPages.currentPage().getParameters().put('prjid', subPrj.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objInvoice);
        InvoiceEditController invedit = new InvoiceEditController(sc);
        invedit.Save();       
              }
 static testMethod void InvoiceeditControllermark(){
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
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=u2.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
        Project__c prj = new Project__c ();
        prj.Name='ITC';
        //prj.Plantype__c= pt.Id;
        prj.Ends_date__c = system.toDay().addDays(3);
        prj.Starts_date__c= system.toDay();
        prj.Status__c = 'In Progress';
     	prj.OwnerId=plm.userid__c;
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
                
        Invoice__c  objInvoice=new Invoice__c();
        objInvoice.Name='testinvoice';
        objInvoice.musqot__Total_spent__c = 4000;                
        objInvoice.musqot__supplier__c='testsupplier'; 
        objInvoice.musqot__Description__c='This for testing';
        System.assertEquals('testinvoice', objInvoice.Name);
        insert objInvoice;
        
        ApexPages.currentPage().getParameters().put('mrkId', objMarketingact.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objInvoice);
        InvoiceEditController invedit1 = new InvoiceEditController(sc);
        invedit1.deleteinvoice();
            }
 static testMethod void InvoiceeditControllercancel(){
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
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=u2.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
        Project__c prj = new Project__c ();
        prj.Name='ITC';
        //prj.Plantype__c= pt.Id;
        prj.Ends_date__c = system.toDay().addDays(3);
        prj.Starts_date__c= system.toDay();
        prj.Status__c = 'In Progress';
     	prj.OwnerId=plm.userid__c;
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
        
        Invoice__c  objInvoice=new Invoice__c();
        objInvoice.Name='testinvoice';
        objInvoice.musqot__Total_spent__c = 4000;                
        objInvoice.musqot__supplier__c='testsupplier'; 
        objInvoice.musqot__Description__c='This for testing';
        System.assertEquals('testinvoice', objInvoice.Name);
        insert objInvoice;
        
        ApexPages.currentPage().getParameters().put('prjid', subPrj.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objInvoice);
        InvoiceEditController invedit = new InvoiceEditController(sc);
        invedit.Cancel();       
              }
 static testMethod void InvoiceeditControllercancel1(){
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
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=u2.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
        Project__c prj = new Project__c ();
        prj.Name='ITC';
        //prj.Plantype__c= pt.Id;
        prj.Ends_date__c = system.toDay().addDays(3);
        prj.Starts_date__c= system.toDay();
        prj.Status__c = 'In Progress';
     	prj.OwnerId=plm.userid__c;
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
        
        Invoice__c  objInvoice=new Invoice__c();
        objInvoice.Name='testinvoice';
        objInvoice.musqot__Total_spent__c = 4000;                
        objInvoice.musqot__supplier__c='testsupplier'; 
        objInvoice.musqot__Description__c='This for testing';
        System.assertEquals('testinvoice', objInvoice.Name);
        insert objInvoice;
        
        ApexPages.currentPage().getParameters().put('mrkId', objMarketingact.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objInvoice);
        InvoiceEditController invedit = new InvoiceEditController(sc);
        invedit.Cancel();       
              }
static testMethod void InvoiceeditControllerdeleteinv(){
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
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=u2.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
        Project__c prj = new Project__c ();
        prj.Name='ITC';
        //prj.Plantype__c= pt.Id;
        prj.Ends_date__c = system.toDay().addDays(3);
        prj.Starts_date__c= system.toDay();
        prj.Status__c = 'In Progress';
    	prj.OwnerId=plm.userid__c;
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
        
        Invoice__c  objInvoice=new Invoice__c();
        objInvoice.Name='testinvoice';
        objInvoice.musqot__Total_spent__c = 4000;                
        objInvoice.musqot__supplier__c='testsupplier'; 
        objInvoice.musqot__Description__c='This for testing';    
        System.assertEquals('testinvoice', objInvoice.Name);
        insert objInvoice;
        
        ApexPages.currentPage().getParameters().put('prjid', subPrj.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objInvoice);
        InvoiceEditController invedit = new InvoiceEditController(sc);
        invedit.deleteinvoice();       
              }
 static testMethod void InvoiceeditControllerdeleteinv1(){
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
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=u2.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
        Project__c prj = new Project__c ();
        prj.Name='ITC';
        //prj.Plantype__c= pt.Id;
        prj.Ends_date__c = system.toDay().addDays(3);
        prj.Starts_date__c= system.toDay();
        prj.Status__c = 'In Progress';
     	prj.OwnerId=plm.userid__c;
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
                
        Invoice__c  objInvoice=new Invoice__c();
        objInvoice.Name='testinvoice';
        objInvoice.musqot__Total_spent__c = 4000;                
        objInvoice.musqot__supplier__c='testsupplier'; 
        objInvoice.musqot__Description__c='This for testing';    
        System.assertEquals('testinvoice', objInvoice.Name);
        insert objInvoice;
        
        ApexPages.currentPage().getParameters().put('mrkId', objMarketingact.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objInvoice);
        InvoiceEditController invedit = new InvoiceEditController(sc);
        invedit.deleteinvoice();       
              }
  static testMethod void Invoicesave(){
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
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=u2.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
        Project__c prj = new Project__c ();
        prj.Name='ITC';
        prj.Ends_date__c = system.toDay().addDays(3);
        prj.Starts_date__c= system.toDay();
        prj.Status__c = 'In Progress';
      	prj.OwnerId=plm.userid__c;
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
        
        Invoice__c  objInvoice=new Invoice__c();       
        objInvoice.Name='testinvoice';             
        objInvoice.musqot__supplier__c='testsupplier';        
        objInvoice.musqot__Total_spent__c = 4000;
        System.assertEquals('testinvoice', objInvoice.Name);
        insert objInvoice;
        
        PageReference pageRef = Page.ProjectDetails;
        Test.setCurrentPage(pageRef);
        String tabId = System.currentPageReference().getParameters().get('tabId');
        ApexPages.currentPage().getParameters().put('projectid', prj.id);
        ApexPages.currentPage().getParameters().put('markID', objMarketingact.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objInvoice);
        InvoiceEditController objinvcont = new InvoiceEditController(sc);
        objinvcont.Save();
      }
}