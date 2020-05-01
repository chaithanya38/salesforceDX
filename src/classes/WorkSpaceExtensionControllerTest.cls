/****************************************************************
Class Name: WorkSpaceExtensionControllerTest 
Author:Chaithanya daggumati     Last modified by: G Janardhanreddy
Date: 21/7/2014                 Date: 19/3/2015  
********©2013 Musqot marketing technology Pvt ltd ****************/
@isTest
public class WorkSpaceExtensionControllerTest{
    static testMethod void WorkSpaceExtension(){       
        Project__c objProj = new Project__c();
        objProj.Name='Plan';
        objProj.Starts_Date__c=Date.Today();
        objProj.Ends_Date__c=Date.Today();
        System.assertEquals('Plan',objProj.Name);
        insert objProj ;
        
        Subproject__c sb=new Subproject__c();
        sb.Name='sub';
        sb.musqot__Parent_project__c=objProj.id;
        System.assertEquals('sub',sb.Name);
        insert sb; 
        
        Marketing_activity__c objmarkact = new Marketing_activity__c();
        objmarkact .Name = 'test';
        objmarkact .Starts_date__c = Date.Today();
        objmarkact .Ends_date__c = Date.Today();
        objmarkact .Description__c = 'testarea';
        System.assertEquals('test',objmarkact .Name);
        insert objmarkact ;
        
        Workspace__c objwsp = new Workspace__c();
        objwsp.Name = 'test';
        objwsp.ProjectName__c =objProj.id;
        objwsp.subproject__c =sb.id;
        objwsp.musqot__Marketing_activity__c=objmarkact.id;
        objwsp.Description__c = 'desc';
        objwsp.musqot__Marketing_activity__c=objmarkact.id;
        objwsp.html_description__c = 'htdesc';
        System.assertEquals('test',objwsp.Name);
        insert objwsp;
        
        //PageReference pageRef = Page.SubProject;
        //Test.setCurrentPage(pageRef);  
        //ApexPages.currentPage().getParameters().put('projectid',sb.id);
        ApexPages.currentPage().getParameters().put('plnId', objProj.id);
       // ApexPages.currentPage().getParameters().put('markId', objmarkact.id);
        ApexPages.currentPage().getParameters().put('Id', objwsp.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objwsp);
        test.startTest();
        WorkSpaceExtensionController wspec = new WorkSpaceExtensionController(sc); 
        wspec.Save();
        wspec.cancel();
        wspec.getRedirectToTemplate();        
        wspec.redirectToTemplate();
        test.stopTest();
    }
    static testMethod void WorkSpaceExtension1(){       
        Project__c p = new Project__c();
        p.Name='Plan';
        p.Starts_Date__c=Date.Today();
        P.Ends_Date__c=Date.Today();
        System.assertEquals('Plan',p.Name);
        insert p;
        
        Subproject__c objsb=new Subproject__c();
        objsb.Name='sub';
        objsb.musqot__Parent_project__c=p.id;
        System.assertEquals('sub',objsb.Name);
        insert objsb;
        
        Marketing_activity__c objmarkact = new Marketing_activity__c();
        objmarkact .Name = 'test';
        objmarkact .Starts_date__c = Date.Today();
        objmarkact .Ends_date__c = Date.Today();
        objmarkact .Description__c = 'testarea';
        System.assertEquals('test',objmarkact .Name);
        insert objmarkact ;
        
        Workspace__c objwsp = new Workspace__c();
        objwsp.Name = 'test';
       // objwsp.ProjectName__c =p.id;
        objwsp.subproject__c =objsb.id;
        objwsp.musqot__Marketing_activity__c=objmarkact.id;
        objwsp.Description__c = 'desc';
        objwsp.html_description__c = 'htdesc';
        System.assertEquals('test',objwsp.Name);
        insert objwsp; 
     
        ApexPages.currentPage().getParameters().put('projectid',objsb.id);
        ApexPages.currentPage().getParameters().put('Id', objwsp.id);
        ApexPages.StandardController sc = new ApexPages.standardController(p);
        test.startTest();
        WorkSpaceExtensionController wspec1 = new WorkSpaceExtensionController();
        WorkSpaceExtensionController wspec = new WorkSpaceExtensionController(sc);
        PageReference pageRef = Page.ProjectDetails;
        Test.setCurrentPage(pageRef);  
        try{
            wspec.Save();
        }catch(Exception e){}
        wspec.cancel();
        wspec.getRedirectToTemplate();        
        wspec.redirectToTemplate();
        test.stopTest();
    }
    static testMethod void WorkSpaceExtension2(){       
        Project__c p = new Project__c();
        p.Name='Plan';
        p.Starts_Date__c=Date.Today();
        P.Ends_Date__c=Date.Today();
        System.assertEquals('Plan',p.Name);
        insert p;
        Subproject__c sb=new Subproject__c();
        sb.Name='sub';
        System.assertEquals('sub',sb.Name);
        insert sb;
         
        Marketing_activity__c objmarkact = new Marketing_activity__c();
        objmarkact .Name = 'test';
        objmarkact .Starts_date__c = Date.Today();
        objmarkact .Ends_date__c = Date.Today();
        objmarkact .Description__c = 'testarea';
        System.assertEquals('test',objmarkact .Name);
        insert objmarkact ;
        Workspace__c objwsp = new Workspace__c();
        objwsp.Name = 'test';
        objwsp.ProjectName__c =p.id;
        objwsp.subproject__c =sb.id;
        objwsp.Description__c = 'desc';
        objwsp.html_description__c = 'htdesc';
        System.assertEquals('test',objwsp.Name);
        insert objwsp;
        //ApexPages.currentPage().getParameters().put('plnId',p.id);
        ApexPages.currentPage().getParameters().put('markId', objmarkact.id);
        //ApexPages.currentPage().getParameters().put('SubProjectid', sb.id);
        ApexPages.currentPage().getParameters().put('Id', objwsp.id);
        ApexPages.StandardController sc = new ApexPages.standardController(sb);
        test.startTest();
        WorkSpaceExtensionController wspec1 = new WorkSpaceExtensionController();
        WorkSpaceExtensionController wspec = new WorkSpaceExtensionController(sc);
        PageReference pageRef = Page.Marketingactivity;
        Test.setCurrentPage(pageRef);  
        try{
            wspec.Save();
        }catch(Exception e){}
        wspec.cancel();
        wspec.getRedirectToTemplate();        
        wspec.redirectToTemplate();
        test.stopTest();
   
    } 
    static testMethod void WorkSpaceExtension3(){       
        Project__c p = new Project__c();
        p.Name='Plan';
        p.Starts_Date__c=Date.Today();
        P.Ends_Date__c=Date.Today();
        System.assertEquals('Plan',p.Name);
        insert p;
        Subproject__c sb=new Subproject__c();
        sb.Name='sub';
        System.assertEquals('sub',sb.Name);
        insert sb;
         
        Marketing_activity__c objmarkact = new Marketing_activity__c();
        objmarkact .Name = 'test';
        objmarkact .Starts_date__c = Date.Today();
        objmarkact .Ends_date__c = Date.Today();
        objmarkact .Description__c = 'testarea';
        System.assertEquals('test',objmarkact .Name);
        insert objmarkact ;
        Workspace__c objwsp = new Workspace__c();
        objwsp.Name = 'test';
        objwsp.ProjectName__c =p.id;
        objwsp.subproject__c =sb.id;
        objwsp.musqot__Marketing_activity__c=objmarkact.id;
        objwsp.Description__c = 'desc';
        objwsp.html_description__c = 'htdesc';
        System.assertEquals('test',objwsp.Name);
        insert objwsp;
        //ApexPages.currentPage().getParameters().put('plnId',p.id);
        ApexPages.currentPage().getParameters().put('marktingid', objmarkact.id);
        ApexPages.currentPage().getParameters().put('SubProjectid', sb.id);
        ApexPages.currentPage().getParameters().put('Id', objwsp.id);
        ApexPages.StandardController sc = new ApexPages.standardController(sb);
        test.startTest();
        WorkSpaceExtensionController wspec1 = new WorkSpaceExtensionController();
        WorkSpaceExtensionController wspec = new WorkSpaceExtensionController(sc);
        PageReference pageRef = Page.Marketingactivity;
        Test.setCurrentPage(pageRef);  
        try{
            wspec.Save();
        }catch(Exception e){}
        wspec.cancel();
        wspec.getRedirectToTemplate();        
        wspec.redirectToTemplate();
        wspec.Save2();
        wspec.cancel2();
        test.stopTest();
        
    } 
 }