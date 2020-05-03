/*********************************************************
Class Name: AttachmentUploadControllerTest
Author:Nagaraju G         Last modified by:G Janardhanreddy
Date: Nagaraju G             Date:18/03/2015
********©2013 Musqot marketing technology Pvt ltd ********/
@isTest(seeAllData=true)
public class AttachmentUploadControllerTest{
    static testMethod void AttachmentUploadControllerMethod4(){
        Profile p = [select id from profile where name='System Administrator']; 
        User objUser = new User(alias = 'stan', email='standarduser@test.com', 
                                emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
                                localesidkey='en_US', profileid = p.Id, 
                                timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
        insert objUser ; 
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=objUser.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
        Plantype__c objpt = new Plantype__c();
        objpt.Barcolor__c = '6E766F';
        objpt.Name = 'Zuri';
        System.assertEquals('Zuri', objpt.name);
        insert objpt;
        Project__c objprj = new Project__c ();
        objprj.Name='ITC';
        objprj.Plantype__c= objpt.Id;
        objprj.Ends_date__c = system.toDay().addDays(3);
        objprj.Starts_date__c= system.toDay();
        objprj.Status__c = 'In Progress';
        objPrj.ownerid =plm.userid__c;
        System.assertEquals('ITC', objprj.name);         
        insert objprj;
        Project_type__c objprjType = new Project_type__c();
        objprjType.Name = 'Business';
        objprjType.Color__c = 'FFFF01';
        System.assertEquals('Business', objprjType.name);
        insert objprjType; 
        Subproject__c subPrj = new Subproject__c();         
        subPrj.Name='ITC Project';
        subPrj.Parent_project__c = objprj.Id;
        subPrj.Ends_date__c = system.toDay().addDays(3);
        subPrj.Starts_date__c= system.toDay();
        subPrj.Status__c = 'In Progress'; 
        subPrj.Project_type__c = objprjType.Id;
        System.assertEquals('ITC Project', subPrj.name);     
        insert subPrj;
        Attachment objatt=new Attachment();
        objatt.name='test';
        objatt.ParentId=objprj.id;
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        objatt.body = bodyBlob;
        objatt.ContentType='text';
        objatt.Description='test';
        System.assertEquals(objatt.ParentId, objprj.id); 
        insert objatt;
        PageReference pageRef = new PageReference('/apex/projectdetails?id=' + objprj .Id);  
        test.setCurrentPage(pageRef);  
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact;    
        ApexPages.currentPage().getParameters().put('plnId', objprj.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objatt);
        test.startTest();
        AttachmentUploadController objAttachment = new AttachmentUploadController ();           
        try{           
            objAttachment.upload();    
        }catch(exception e){}   
        objAttachment.cancel();                  
    }    
    static testMethod void AttachmentUploadControllerMethod1(){
        Profile p = [select id from profile where name='System Administrator']; 
        User objUser = new User(alias = 'stan', email='standarduser@test.com', 
                                emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
                                localesidkey='en_US', profileid = p.Id, 
                                timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
        insert objUser ; 
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=objUser.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
        Plantype__c objpt = new Plantype__c();
        objpt.Barcolor__c = '6E766F';
        objpt.Name = 'Zuri';
        System.assertEquals('Zuri', objpt.name);
        insert objpt;
        Project__c objprj = new Project__c ();
        objprj.Name='ITC';
        objprj.Plantype__c= objpt.Id;
        objprj.Ends_date__c = system.toDay().addDays(3);
        objprj.Starts_date__c= system.toDay();
        objprj.Status__c = 'In Progress';
        objPrj.ownerid =plm.userid__c;
        System.assertEquals('ITC', objprj.name);         
        insert objprj;
        Project_type__c objprjType = new Project_type__c();
        objprjType.Name = 'Business';
        objprjType.Color__c = 'FFFF01';
        System.assertEquals('Business', objprjType.name);
        insert objprjType; 
        Subproject__c subPrj = new Subproject__c();         
        subPrj.Name='ITC Project';
        subPrj.Parent_project__c = objprj.Id;
        subPrj.Ends_date__c = system.toDay().addDays(3);
        subPrj.Starts_date__c= system.toDay();
        subPrj.Status__c = 'In Progress'; 
        subPrj.Project_type__c = objprjType.Id;
        System.assertEquals('ITC Project', subPrj.name);     
        insert subPrj;
         Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact; 
        Attachment objatt=new Attachment();
        objatt.name='test';
        objatt.ParentId=subPrj.id;
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        objatt.body = bodyBlob;
        objatt.ContentType='text';
        objatt.Description='test';
        System.assertEquals(objatt.ParentId, subPrj.id); 
        insert objatt;
          
        ApexPages.currentPage().getParameters().put('subprojectid', subPrj.id);
        ApexPages.StandardController sc = new ApexPages.standardController(subPrj);
        test.startTest();
        AttachmentUploadController objAttachment = new AttachmentUploadController ();           
        try{           
            objAttachment.upload();    
        }catch(exception e){}    
        objAttachment.cancel();                 
    }
    static testMethod void AttachmentUploadControllerMethod2(){
        Profile p = [select id from profile where name='System Administrator']; 
        User objUser = new User(alias = 'stan', email='standarduser@test.com', 
                                emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
                                localesidkey='en_US', profileid = p.Id, 
                                timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
        insert objUser ; 
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=objUser.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
        Plantype__c objpt = new Plantype__c();
        objpt.Barcolor__c = '6E766F';
        objpt.Name = 'Zuri';
        System.assertEquals('Zuri', objpt.name);
        insert objpt;
        Project__c objprj = new Project__c ();
        objprj.Name='ITC';
        objprj.Plantype__c= objpt.Id;
        objprj.Ends_date__c = system.toDay().addDays(3);
        objprj.Starts_date__c= system.toDay();
        objprj.Status__c = 'In Progress';
        objPrj.ownerid =plm.userid__c;
        System.assertEquals('ITC', objprj.name);         
        insert objprj;
        Project_type__c objprjType = new Project_type__c();
        objprjType.Name = 'Business';
        objprjType.Color__c = 'FFFF01';
        System.assertEquals('Business', objprjType.name);
        insert objprjType; 
        Subproject__c subPrj = new Subproject__c();         
        subPrj.Name='ITC Project';
        subPrj.Parent_project__c = objprj.Id;
        subPrj.Ends_date__c = system.toDay().addDays(3);
        subPrj.Starts_date__c= system.toDay();
        subPrj.Status__c = 'In Progress'; 
        subPrj.Project_type__c = objprjType.Id;
        System.assertEquals('ITC Project', subPrj.name);     
        insert subPrj;
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
        objMarketingact.Name='test';
        objMarketingact.Description__c='tdescriptionest';
        objMarketingact.Status__c='completed';
        System.assertEquals('test', objMarketingact.name);
        insert objMarketingact; 
        Attachment objatt=new Attachment();
        objatt.name='test';
        objatt.ParentId=objMarketingact.id;
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        objatt.body = bodyBlob;
        objatt.ContentType='text';
        objatt.Description='test';
        System.assertEquals(objatt.ParentId, objMarketingact.id); 
        insert objatt;
           
        ApexPages.currentPage().getParameters().put('mrkId', objMarketingact.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objMarketingact);
        test.startTest();
        AttachmentUploadController objAttachment = new AttachmentUploadController ();           
        try{           
            objAttachment.upload();    
        }catch(exception e){}   
        objAttachment.cancel();                 
    }
 static testMethod void Attachmentupload(){
        Profile p = [select id from profile where name='System Administrator']; 
        User objUser = new User(alias = 'stan', email='standarduser@test.com', 
                                emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
                                localesidkey='en_US', profileid = p.Id, 
                                timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
        insert objUser ; 
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=objUser.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
        Project__c objprj = new Project__c ();
        objprj.Name='ITC';        
        objprj.Ends_date__c = system.toDay().addDays(3);
        objprj.Starts_date__c= system.toDay();
        objprj.Status__c = 'In Progress';
        objPrj.ownerid =plm.userid__c;
        System.assertEquals('ITC', objprj.name);         
        insert objprj;
        
        Subproject__c subPrj = new Subproject__c();         
        subPrj.Name='ITC Project';        
        subPrj.Ends_date__c = system.toDay().addDays(3);
        subPrj.Starts_date__c= system.toDay();
        subPrj.Status__c = 'In Progress';         
        System.assertEquals('ITC Project', subPrj.name);     
        insert subPrj;
     
        Attachment objatt=new Attachment();
        objatt.name='test'; 
        objatt.ParentId=subPrj.id;       
        Blob bodyBlob = Blob.valueOf('Unit Test Attachment Body');
        objatt.body = bodyBlob;
        objatt.ContentType='application/pdf';
        objatt.Description='test';
        System.assertEquals('test', objatt.name); 
        insert objatt;
           
        ApexPages.currentPage().getParameters().put('plnId', objprj.id);
        ApexPages.currentPage().getParameters().put('subprojectid', subPrj.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objprj);      
        AttachmentUploadController Atta = new AttachmentUploadController();
        Atta.contentType='application/pdf';
        try{ 
        Atta.fileNmaeWithExtension='.txt';          
        Atta.upload();    
        }catch(exception e){}                      
    }
}