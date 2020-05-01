/*****************************************************************
Class Name: subprojectClassTest
Author: chaithanya daggumati    Last modified by: G Janardhanreddy
Date: 22/7/2014                 Date:  20/03/2015
********©2013 Musqot marketing technology Pvt ltd ****************/
@isTest(seeAllData=true)
    public class subprojectClassTest{    
    static testMethod void subproject(){
    
    Project_type__c objprojtype = new Project_type__c();
    objprojtype.Name = 'testname'; 
    objprojtype.Color__c = 'red'; 
    objprojtype.musqot__Fieldset__c='testFieldset';
    objprojtype.Plantype__c='co branding';
    objprojtype.sort__c=10;
    System.assertEquals('testname', objprojtype .name);
    insert objprojtype ;
    
    Project__c objproj = new Project__c();
    objproj .name = 'testname';
    objproj .Starts_date__c = System.now().date();
    objproj .Ends_date__c =  System.now().date(); 
    objproj .Description__c = 'sampdesc';
    objproj.Status__c='In Progress';
    System.assertEquals('testname', objproj .name);
    insert objproj;
                       
    Subproject__c objsp = new Subproject__c ();
    objsp .name = 'testname';            
    objsp .Description__c = 'sampdesc';
    objsp .Project_del__c = objsp.Id;
    objsp .Parent_project__c= objproj.Id;
    objsp.Starts_date__c =  System.now().date();
    objsp .Ends_date__c =  System.now().date();
    objsp.Status__c='In Progress';
    System.assertEquals('testname', objsp .name);
    objsp.Project_type__c = objprojtype.id;   
    insert objsp;
        
    test.startTest();
    PageReference pageRef = Page.projectpage;
    Test.setCurrentPage(pageRef);      
    ApexPages.currentPage().getParameters().put('planId', objproj.id);
    ApexPages.currentPage().getParameters().put('subPrjId', objsp.id);
    ApexPages.CurrentPage().getParameters().put('prjId',objsp.id);
    //ApexPages.currentPage().getParameters().put('retURL','rb0000000E6daasd=asdassd');
    //ApexPages.currentPage().getParameters().put('mainStr','rb0000000E6daasd=asdassd');
    ApexPages.StandardController sc = new ApexPages.standardController(objsp);            
    subprojectClass subpcls = new subprojectClass (sc); 
   // subprojectClass subpcls1 = new subprojectClass (); 
    List<SelectOption> temp=subpcls.PROTList;   
    subpcls.fieldSetName='testFieldSet';      
    subpcls.save();
    subpcls.cancel(); 
    subpcls.getFields();
    test.stoptest();                    
    }
   static testMethod void subproject1(){
   
    Project__c objproj = new Project__c();
    objproj .name = 'testname';
    objproj .Starts_date__c = System.now().date();
    objproj .Ends_date__c =  System.now().date(); 
    objproj .Description__c = 'sampdesc';
    objproj.Status__c='In Progress';
    System.assertEquals('testname', objproj .name);
    insert objproj ;
    
    Project_type__c objprojtype = new Project_type__c();
    objprojtype .Name = 'testname'; 
    objprojtype .Color__c = 'red';
    objprojtype.Plantype__c='co branding';
    objprojtype.sort__c=10;
    System.assertEquals('testname', objprojtype .name);
    insert objprojtype ;
    
    Subproject__c objsp = new Subproject__c ();
    objsp .name = 'testname';            
    objsp .Description__c = 'sampdesc';
    objsp .Parent_project__c= objproj.Id;
    objsp .Starts_date__c =  System.now().date();
    objsp .Ends_date__c =  System.now().date();
    objsp.Status__c='In Progress';
    System.assertEquals('testname', objsp .name);
    objsp.Project_type__c = objprojtype.id;
    insert objsp ;
        
    test.startTest();
    PageReference pageRef = Page.projectpage;
    Test.setCurrentPage(pageRef);      
    ApexPages.currentPage().getParameters().put('planId', objproj.id);
    ApexPages.currentPage().getParameters().put('subPrjId', objsp.id);

    ApexPages.StandardController sc = new ApexPages.standardController(objsp);            
    subprojectClass subpcls = new subprojectClass (sc); 
    
    List<SelectOption> temp=subpcls.PROTList;         
    subpcls.save();
    subpcls.cancel(); 
    subpcls.getFields();
    test.stoptest();
    }
   static testMethod void subproject2(){  
    Project__c objproj = new Project__c();
    objproj .name = 'testname';
    objproj .Starts_date__c = System.now().date();
    objproj .Ends_date__c =  System.now().date(); 
    objproj .Description__c = 'sampdesc';
    objproj.Status__c='In Progress';
    System.assertEquals('testname', objproj .name);
    insert objproj ;
    
    Subproject__c objsp = new Subproject__c ();
    objsp .name = 'testname';            
    objsp .Description__c = 'sampdesc';
    objsp .Parent_project__c= objproj.Id;
    objsp .Starts_date__c =  System.now().date()+2;
    objsp .Ends_date__c =  System.now().date()+5;
    objsp.Status__c='In Progress';
    System.assertEquals('testname', objsp .name);
    //objsp.Project_type__c = objprojtype.id;
    insert objsp ;
        
    test.startTest();
    PageReference pageRef = Page.projectpage;
    Test.setCurrentPage(pageRef);      
    ApexPages.currentPage().getParameters().put('planId', objproj.id);
    ApexPages.currentPage().getParameters().put('subPrjId', objsp.id);

    ApexPages.StandardController sc = new ApexPages.standardController(objsp);            
    subprojectClass subpcls = new subprojectClass (sc);     
    List<SelectOption> temp=subpcls.PROTList;         
    subpcls.save();
    subpcls.cancel(); 
    subpcls.getFields();
    test.stoptest();
    }
 }