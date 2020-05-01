@isTest(seeAllData=true)
public class InvoiceControllerTest{
    static testMethod void InvoiceControllerplan(){
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
        
        Purchase_article__c objpog = new Purchase_article__c();
        objpog.name ='testrec';
        System.assertEquals('testrec', objpog.name);
        insert objpog; 
        
        Purchase_order__c objpo = new Purchase_order__c();
        objpo.Name = 'testname';
        objpo.Purchase_order_name__c = 'test';
        objpo.Total_cost__c  = 1000;
        objpo.musqot__total_Invoice_cost__c = 100;
        objpo.Description__c = 'test';
        objpo.Effective_date__c = Date.Today();
        objpo.Send_date__c = Date.Today();
        objpo.Supplier__c = 'test';
        objpo.Project__c = prj.Id;
        objpo.musqot__subproject__c = subprj.Id;
        objpo.musqot__Marketing_activity__c = objMarketingact.Id;
        objpo.musqot__Purchase_order_cloesed__c = true;
        objpo.Supplier_email__c = 'standarduser@abc.com';
        System.assertEquals('testname', objpo .Name);
        insert objpo ; 
                
        ApexPages.currentPage().getParameters().put('seedata.id', objpo.id);
        musqot__Purchase_order_setting__c objPUR=new musqot__Purchase_order_setting__c();
        objPUR.name='testPO';
        objPUR.musqot__PO_Startnumber__c=01;
        objPUR.musqot__PO_Lastnumber__c=10;
        objPUR.musqot__PO_Prefix__c='mus';
        objPUR.musqot__PO_Autoprefix__c='MMTS';
        insert objPUR;
        
        Invoice__c  objInvoice=new Invoice__c();
        objInvoice.musqot__Purchase_orders__c=objpo.id;
        objInvoice.Name='testinvoice';  
        objInvoice.musqot__Purchase_article__c=objpog.id;            
        objInvoice.musqot__supplier__c='testsupplier';        
        objInvoice.musqot__Total_spent__c = 4000;
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
        String tabId = System.currentPageReference().getParameters().get('tabId');
        ApexPages.currentPage().getParameters().put('planid', prj.id);
        PageReference pageRef = Page.ProjectDetails;
        Test.setCurrentPage(pageRef); 
        ApexPages.StandardController sc = new ApexPages.standardController(objInvoice);
        InvoiceController objinvcont = new InvoiceController (sc);
        Purchase_order__c objPUR1=[SELECT ID ,Name,musqot__total_Invoice_cost__c from Purchase_order__c limit 1];
        objPUR1.musqot__total_Invoice_cost__c=objInvoice.Total_spent__c;
        update objPUR1;
        
        List<Purchase_article__c> temp2=objinvcont.PA_Temp;    
        List<Purchase_order__c> temp3=objinvcont.Po_Temp;
        List<SelectOption> sop = objinvcont.PAList;
        objinvcont.subprojectid = subPrj.Id;
        objinvcont.projectid = prj.Id;
        objinvcont.markID = objMarketingact.Id;
        objinvcont.seedata = objpo.Id;
        attachment att = objinvcont.attachment;
        objinvcont.subprojectid = subPrj.Id;
        objinvcont.seeData = 'SelectPO';
        objinvcont .cancel();
        objinvcont .getPoList();
        objinvcont .poDetailMethod();
        objinvcont .contenttype='test';
        objinvcont .selectedPO='test';
        objinvcont .closePO=true;
       
        //try{              
            objinvcont .insertinvoic();
            List<ApexPages.Message> msgList = ApexPages.getMessages();
        //}catch(Exception e){}
    }
    static testMethod void InvoiceControllerplan1(){
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
        
        Purchase_article__c objpog = new Purchase_article__c();
        objpog.name ='testrec';
        System.assertEquals('testrec', objpog.name);
        insert objpog; 
        
        Purchase_order__c objpo = new Purchase_order__c();
        objpo.Name = 'testname';
        objpo.Purchase_order_name__c = 'test';
        objpo.Total_cost__c  = 1000;
        objpo.musqot__total_Invoice_cost__c = 100;
        objpo.Description__c = 'test';
        objpo.Effective_date__c = Date.Today();
        objpo.Send_date__c = Date.Today();
        objpo.Supplier__c = 'test';
        objpo.Project__c = prj.Id;
        objpo.musqot__subproject__c = subprj.Id;
        objpo.musqot__Marketing_activity__c = objMarketingact.Id;
        objpo.musqot__Purchase_order_cloesed__c = true;
        objpo.Supplier_email__c = 'standarduser@abc.com';
        System.assertEquals('testname', objpo .Name);
        insert objpo ;  
               
        ApexPages.currentPage().getParameters().put('seedata.id', objpo.id);
        musqot__Purchase_order_setting__c objPUR=new musqot__Purchase_order_setting__c();
        objPUR.name='testPO';
        objPUR.musqot__PO_Startnumber__c=01;
        objPUR.musqot__PO_Lastnumber__c=10;
        objPUR.musqot__PO_Prefix__c='mus';
        objPUR.musqot__PO_Autoprefix__c='MMTS';
        insert objPUR;
        
        Invoice__c  objInvoice=new Invoice__c();
        objInvoice.musqot__Purchase_orders__c=objpo.id;
        objInvoice.Name='testinvoice';  
        objInvoice.musqot__Purchase_article__c=objpog.id;            
        objInvoice.musqot__supplier__c='testsupplier';        
        objInvoice.musqot__Total_spent__c = 4000;
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
        ApexPages.currentPage().getParameters().put('markID', objMarketingact.id);
        PageReference pageRef = Page.ProjectDetails;
        Test.setCurrentPage(pageRef); 
        ApexPages.StandardController sc = new ApexPages.standardController(objInvoice);
        InvoiceController objinvcont = new InvoiceController (sc);
        List<Purchase_article__c> temp2=objinvcont.PA_Temp;    
        List<Purchase_order__c> temp3=objinvcont.Po_Temp;
        List<SelectOption> sop = objinvcont.PAList;
        objinvcont.subprojectid = subPrj.Id;
        objinvcont.projectid = prj.Id;
        objinvcont.markID = objMarketingact.Id;
        objinvcont.seedata = objpo.Id;
        attachment att = objinvcont.attachment;
        objinvcont.subprojectid = subPrj.Id;
        objinvcont.seeData = 'Wildinvoice';
        objinvcont .cancel();
        objinvcont .getPoList();
        objinvcont .poDetailMethod();
        objinvcont .contenttype='test';
        objinvcont .selectedPO='test';
        objinvcont .closePO=true;
        try{              
            objinvcont .insertinvoic();
            List<ApexPages.Message> msgList = ApexPages.getMessages();
       }catch(Exception e){}
   }
   static testMethod void InvoiceControllerplan12(){
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
        
        Purchase_article__c objpog = new Purchase_article__c();
        objpog.name ='testrec';
        System.assertEquals('testrec', objpog.name);
        insert objpog; 
        
        Purchase_order__c objpo = new Purchase_order__c();
        objpo.Name = 'testname';
        objpo.Purchase_order_name__c = 'test';
        objpo.Total_cost__c  = 1000;
        objpo.musqot__total_Invoice_cost__c=100;
        objpo.Description__c = 'test';
        objpo.Effective_date__c = Date.Today();
        objpo.Send_date__c = Date.Today();
        objpo.Supplier__c = 'test';
        objpo.Project__c = prj.Id;
        objpo.musqot__subproject__c = subprj.Id;
        objpo.musqot__Marketing_activity__c = objMarketingact.Id;
        objpo.musqot__Purchase_order_cloesed__c = true;
        objpo.Supplier_email__c = 'standarduser@abc.com';
        System.assertEquals('testname', objpo .Name);
        insert objpo; 
        update objpo; 
               
        ApexPages.currentPage().getParameters().put('seedata.id', objpo.id);
        musqot__Purchase_order_setting__c objPUR=new musqot__Purchase_order_setting__c();
        objPUR.name='testPO';
        objPUR.musqot__PO_Startnumber__c=01;
        objPUR.musqot__PO_Lastnumber__c=10;
        objPUR.musqot__PO_Prefix__c='mus';
        objPUR.musqot__PO_Autoprefix__c='MMTS';
        insert objPUR;
        
        Invoice__c  objInvoice=new Invoice__c();
        objInvoice.musqot__Purchase_orders__c=objpo.id;
        objInvoice.Name='testinvoice';  
        objInvoice.musqot__Purchase_article__c=objpog.id;            
        objInvoice.musqot__supplier__c='testsupplier';        
        objInvoice.musqot__Total_spent__c = 4000;
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
        String tabId = System.currentPageReference().getParameters().get('tabId');
        ApexPages.currentPage().getParameters().put('markID', objMarketingact.id);
        PageReference pageRef = Page.ProjectDetails;
        Test.setCurrentPage(pageRef); 
        ApexPages.StandardController sc = new ApexPages.standardController(objInvoice);
        InvoiceController objinvcont = new InvoiceController (sc);
        List<Purchase_article__c> temp2=objinvcont.PA_Temp;    
        List<Purchase_order__c> temp3=objinvcont.Po_Temp;
        List<SelectOption> sop = objinvcont.PAList;
        objinvcont.subprojectid = subPrj.Id;
        objinvcont.projectid = prj.Id;
        objinvcont.markID = objMarketingact.Id;
        objinvcont.seedata = objpo.Id;
        attachment att = objinvcont.attachment;
        objinvcont.subprojectid = subPrj.Id;
        objinvcont.seeData = 'TestPo';
        objinvcont .cancel();
        objinvcont .getPoList();
        objinvcont .poDetailMethod();
        objinvcont .contenttype='test';
        objinvcont .selectedPO='test';
        objinvcont .closePO=true;
        //try{              
            objinvcont .insertinvoic();
            List<ApexPages.Message> msgList = ApexPages.getMessages();
       // }catch(Exception e){}
   }
   static testMethod void InvoiceControllerplan3(){
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
        
        Purchase_article__c objpog = new Purchase_article__c();
        objpog.name ='testrec';
        System.assertEquals('testrec', objpog.name);
        insert objpog; 
        
        Purchase_order__c objpo = new Purchase_order__c();
        objpo.Name = 'testname';
        objpo.Purchase_order_name__c = 'test';
        objpo.Total_cost__c  = 1000;
        objpo.musqot__total_Invoice_cost__c = 100;
        objpo.Description__c = 'test';
        objpo.Effective_date__c = Date.Today();
        objpo.Send_date__c = Date.Today();
        objpo.Supplier__c = 'test';
        objpo.Project__c = prj.Id;
        objpo.musqot__subproject__c = subprj.Id;
        objpo.musqot__Marketing_activity__c = objMarketingact.Id;
        objpo.musqot__Purchase_order_cloesed__c = true;
        objpo.Supplier_email__c = 'standarduser@abc.com';
        System.assertEquals('testname', objpo .Name);
        insert objpo ;  
        musqot__Purchase_order_setting__c objPUR=new musqot__Purchase_order_setting__c();
        objPUR.name='testPO';
        objPUR.musqot__PO_Startnumber__c=01;
        objPUR.musqot__PO_Lastnumber__c=10;
        objPUR.musqot__PO_Prefix__c='mus';
        objPUR.musqot__PO_Autoprefix__c='MMTS';
        insert objPUR;
        
        Invoice__c  objInvoice=new Invoice__c();
        objInvoice.musqot__Purchase_orders__c=objpo.id;
        objInvoice.Name='testinvoice';  
        objInvoice.musqot__Purchase_article__c=objpog.id;            
        objInvoice.musqot__supplier__c='testsupplier';        
        objInvoice.musqot__Total_spent__c = 4000;
        System.assertEquals('testinvoice', objInvoice.Name);
        insert objInvoice;
        String tabId = System.currentPageReference().getParameters().get('tabId');
        ApexPages.currentPage().getParameters().put('markID', objMarketingact.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objInvoice);
        InvoiceController objinvcont = new InvoiceController (sc);
        objinvcont .cancel();  
       
   }
    static testMethod void InvoiceControllerplan4(){
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
        
        Purchase_article__c objpog = new Purchase_article__c();
        objpog.name ='testrec';
        System.assertEquals('testrec', objpog.name);
        insert objpog; 
        
        Purchase_order__c objpo = new Purchase_order__c();
        objpo.Name = 'testname';
        objpo.Purchase_order_name__c = 'test';
        objpo.Total_cost__c  = 1000;
        objpo.musqot__total_Invoice_cost__c = 100;
        objpo.Description__c = 'test';
        objpo.Effective_date__c = Date.Today();
        objpo.Send_date__c = Date.Today();
        objpo.Supplier__c = 'test';
        objpo.Project__c = prj.Id;
        objpo.musqot__subproject__c = subprj.Id;
        objpo.musqot__Marketing_activity__c = objMarketingact.Id;
        objpo.musqot__Purchase_order_cloesed__c = true;
        objpo.Supplier_email__c = 'standarduser@abc.com';
        System.assertEquals('testname', objpo .Name);
        insert objpo ;  
        musqot__Purchase_order_setting__c objPUR=new musqot__Purchase_order_setting__c();
        objPUR.name='testPO';
        objPUR.musqot__PO_Startnumber__c=01;
        objPUR.musqot__PO_Lastnumber__c=10;
        objPUR.musqot__PO_Prefix__c='mus';
        objPUR.musqot__PO_Autoprefix__c='MMTS';
        insert objPUR;
        
        Invoice__c  objInvoice=new Invoice__c();
        objInvoice.musqot__Purchase_orders__c=objpo.id;
        objInvoice.Name='testinvoice';  
        objInvoice.musqot__Purchase_article__c=objpog.id;            
        objInvoice.musqot__supplier__c='testsupplier';        
        objInvoice.musqot__Total_spent__c = 4000;
        System.assertEquals('testinvoice', objInvoice.Name);
        insert objInvoice;
        String tabId = System.currentPageReference().getParameters().get('tabId');
        ApexPages.currentPage().getParameters().put('subprojectid', subPrj.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objInvoice);
        InvoiceController objinvcont = new InvoiceController (sc);
        objinvcont .cancel();
        objinvcont .poDetailMethod();     
   }
 static testMethod void InvoiceControllercancel(){
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
        ApexPages.StandardController sc = new ApexPages.standardController(objInvoice);
        InvoiceController objinvcont = new InvoiceController (sc);
        objinvcont.cancel();
             }
  static testMethod void Invoiceinsertinvoic(){
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
        ApexPages.currentPage().getParameters().put('subprjid', subPrj.id);
        ApexPages.currentPage().getParameters().put('mrkId', objMarketingact.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objInvoice);
        InvoiceController objinvcont = new InvoiceController (sc);
        try{
        objinvcont.insertinvoic();
        }catch(Exception e){}
      }
 static testMethod void Invoiceinsertinvoic1(){
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

        PageReference pageRef = Page.Marketingactivity;
        Test.setCurrentPage(pageRef);
        String tabId = System.currentPageReference().getParameters().get('tabId');
        ApexPages.currentPage().getParameters().put('mrkId', objMarketingact.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objInvoice);
        InvoiceController objinvcont = new InvoiceController (sc);        
        Purchase_order__c porder = new Purchase_order__c();
        try{
        porder= [Select  Id ,musqot__total_Invoice_cost__c,musqot__Purchase_order_cloesed__c,musqot__Total_cost__c  from Purchase_order__c where Project__c=:prj.id AND musqot__subproject__c=:subPrj.id  AND musqot__Marketing_activity__c=:objMarketingact.id];        
        }catch(Exception e){}
        porder.total_Invoice_cost__c=0;
        porder.total_Invoice_cost__c += objInvoice.Total_spent__c;
        objInvoice.supplier__c=porder.musqot__Supplier__c;
        objInvoice.Description__c=porder.musqot__Description__c;
        objInvoice.musqot__Purchase_article__c=porder.Purchase_article__c;        
        try{
        objinvcont.insertinvoic();
        }catch(Exception e){}
      } 
  static testMethod void Invoiceinsertinvoic2(){
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
     
        Purchase_order__c objpo = new Purchase_order__c();
        objpo.Name = 'testname';
        objpo.Purchase_order_name__c = 'test';
        objpo.Total_cost__c  = 1000;
        objpo.musqot__total_Invoice_cost__c = 100;
        objpo.Description__c = 'test';
        objpo.Effective_date__c = Date.Today();
        objpo.Send_date__c = Date.Today();
        objpo.Supplier__c = 'test';
        objpo.Project__c = prj.Id;
        objpo.musqot__subproject__c = subprj.Id;
        objpo.musqot__Marketing_activity__c = objMarketingact.Id;
        objpo.musqot__Purchase_order_cloesed__c = true;
        objpo.Supplier_email__c = 'standarduser@abc.com';
        System.assertEquals('testname', objpo .Name);
        insert objpo ; 
        
        Invoice__c  objInvoice=new Invoice__c();       
        objInvoice.Name='testinvoice';             
        objInvoice.musqot__supplier__c='testsupplier';        
        objInvoice.musqot__Total_spent__c = 100;
        System.assertEquals('testinvoice', objInvoice.Name);
        insert objInvoice;
        
        ApexPages.StandardController sc = new ApexPages.standardController(objInvoice);
        InvoiceController invcls = new InvoiceController (sc);
        objpo.musqot__total_Invoice_cost__c=objInvoice.Total_spent__c; 
        update objpo;
        try{
        invcls .insertinvoic();
        }catch(Exception e){}       
          }
   static testMethod void Invoiceinsertinvoic3(){
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
     
        Purchase_order__c objpo = new Purchase_order__c();
        objpo.Name = 'testname';
        objpo.Purchase_order_name__c = 'test';
        objpo.Total_cost__c  = 1000;
        objpo.musqot__total_Invoice_cost__c = 100;
        objpo.Description__c = 'test';
        objpo.Effective_date__c = Date.Today();
        objpo.Send_date__c = Date.Today();
        objpo.Supplier__c = 'test';
        objpo.Project__c = prj.Id;
        objpo.musqot__subproject__c = subprj.Id;
        objpo.musqot__Marketing_activity__c = objMarketingact.Id;
        objpo.musqot__Purchase_order_cloesed__c = true;
        objpo.Supplier_email__c = 'standarduser@abc.com';       
        insert objpo;
        update objpo; 
        System.assertEquals('testname', objpo .Name);
        
        Invoice__c  objInvoice=new Invoice__c();       
        objInvoice.Name='testinvoice';             
        objInvoice.musqot__supplier__c='testsupplier';        
        objInvoice.musqot__Total_spent__c = 2000;
        insert objInvoice;      
        System.assertEquals('testinvoice', objInvoice.Name);
        ApexPages.StandardController sc = new ApexPages.standardController(objInvoice);
        InvoiceController invcont = new InvoiceController(sc);
        invcont.seeData='invoice';
        objpo= new Purchase_order__c();
        Purchase_order__c poc =[Select  Id ,musqot__total_Invoice_cost__c,musqot__Purchase_order_cloesed__c,musqot__Total_cost__c  from Purchase_order__c 
                            where Project__c=:prj.id AND musqot__subproject__c=:subPrj.id AND musqot__Marketing_activity__c=:objMarketingact.id];                        
        invcont.closePO=true;
        objpo.musqot__Purchase_order_cloesed__c=invcont.closePO;
        try{
            invcont .insertinvoic();
        }catch(Exception e){}                    
       }
    static testMethod void Invoicewild(){
       Project__c prj = new Project__c ();
        prj.Name='ITC';
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
        
        Purchase_order__c objpo = new Purchase_order__c();
        objpo.Name = 'testname';       
        objpo.total_Invoice_cost__c = 100;
        objpo.Supplier__c = 'test';
        objpo.Project__c = prj.Id;
        objpo.subproject__c = subprj.Id;
        objpo.Marketing_activity__c = objMarketingact.Id;
        insert objpo; 
        System.assertEquals('testname', objpo .Name);
        
        Invoice__c  objInvoice=new Invoice__c();       
        objInvoice.Name='testinvoice';             
        objInvoice.supplier__c='testsupplier';        
        objInvoice.Total_spent__c = 2000;
        insert objInvoice;      
        System.assertEquals('testinvoice', objInvoice.Name);
        ApexPages.StandardController sc = new ApexPages.standardController(objInvoice);
        InvoiceController invcont = new InvoiceController(sc);
        invcont.seeData='testddata';
        invcont.closePO=true;
        invcont.insertinvoic();
    }
  }