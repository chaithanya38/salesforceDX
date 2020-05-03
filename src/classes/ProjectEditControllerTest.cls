/******************************************************
Class Name: ProjectEditControllerTest
Author:Nagaraju             Last modified by:chaithanya 
Date:19/7/2014              Date: 20/03/2015                    
********©2013 Musqot marketing technology Pvt ltd *****/

@isTest(seeAllData=true)
public class ProjectEditControllerTest{
    static testMethod void ProjectEditController(){
        Project_type__c prjType = new Project_type__c();
        prjType.Name = 'Business';
        prjType.Color__c = 'FFFF01';
        System.assertEquals('Business', prjType.name);
        insert prjType; 
        
        Project__c objproject = new Project__c ();
        objproject.Name='test';
        objproject.Starts_date__c= System.now().date();
        objproject.Ends_date__c= System.now().date();
        System.assertEquals('test', objproject.name);
        insert objproject;
        
        plantype__c objporojetype = new plantype__c ();
        objporojetype.name='test';
        objporojetype.Barcolor__c ='cccccc';
        System.assertEquals('test', objporojetype.name);
        insert objporojetype;
        
        Subproject__c subPrj = new Subproject__c();         
        subPrj.Name='ITC Project';
        subPrj.Parent_project__c = objproject.Id;
        subPrj.Ends_date__c = system.toDay().addDays(3);
        subPrj.Starts_date__c= system.toDay();
        subPrj.Status__c = 'In Progress'; 
        subPrj.Project_type__c = prjType.Id;
        System.assertEquals('ITC Project', subPrj.name);     
        insert subPrj;  
        
        ApexPages.currentPage().getParameters().put('id', prjType.id);
        String tabId = System.currentPageReference().getParameters().get('sfdc.tabName');
        ApexPages.StandardController sc = new ApexPages.standardController(prjType);
        test.startTest();
        ProjectEditController prjeditcon1 = new ProjectEditController (); 
        ProjectEditController prjeditcon = new ProjectEditController (sc);
        List<SelectOption> temp = prjeditcon.PlantypeList; 
        try{
            prjeditcon .ProjectEdit();
        }catch(Exception e){
            system.debug('');
        }
        prjeditcon .getPln();
        try{        
            prjeditcon .LoadData();
        }catch(Exception e){
            system.debug('');
        }
       
        prjeditcon .NewPrtype();
        //try{         
            prjeditcon .DeleteProject();
        //}catch(Exception e){}         
    }
    static testMethod void ProjectEditController1(){
        Project_type__c prjType = new Project_type__c();
        prjType.Name = 'Business';
        prjType.Color__c = 'FFFF01';
        System.assertEquals('Business', prjType.name);
        insert prjType; 
        Project__c objproject = new Project__c ();
        objproject.Name='test';
        objproject.Starts_date__c= System.now().date();
        objproject.Ends_date__c= System.now().date();
        System.assertEquals('test', objproject.name);
        insert objproject;
        plantype__c objporojetype = new plantype__c ();
        objporojetype.name='test';
        objporojetype.Barcolor__c ='cccccc';
        System.assertEquals('test', objporojetype.name);
        insert objporojetype;         
        Subproject__c subPrj = new Subproject__c();         
        subPrj.Name='ITC Project';
        subPrj.Parent_project__c = objproject.Id;
        subPrj.Ends_date__c = system.toDay().addDays(3);
        subPrj.Starts_date__c= system.toDay();
        subPrj.Status__c = 'In Progress'; 
        subPrj.Project_type__c = prjType.Id;
        System.assertEquals('ITC Project', subPrj.name);     
        insert subPrj;         
        Project_type__c objprt=[select id,name from Project_type__c where id=:prjType.id limit 1];
        delete objprt;
        test.startTest();
        PageReference pageRef = Page.ProjectType;
        Test.setCurrentPage(pageRef);       
        ApexPages.currentPage().getParameters().put('planid', prjType.id);
        String tabId = System.currentPageReference().getParameters().get('tabId');
        ApexPages.StandardController sc = new ApexPages.standardController(prjType);
        ProjectEditController prjeditcon1 = new ProjectEditController (); 
        ProjectEditController prjeditcon = new ProjectEditController (sc);
        List<SelectOption> temp = prjeditcon.PlantypeList; 
        //prjeditcon.SelectedPlanId='proj';
        prjeditcon.ProjectId='ProjectId';
        try{
            prjeditcon .ProjectEdit();
        }catch(Exception e){
            system.debug('');
        }
        prjeditcon .getPln();
        try{        
            prjeditcon .LoadData();
        }catch(Exception e){
            system.debug('');
        }
        
        prjeditcon .NewPrtype();
        try{         
            prjeditcon .DeleteProject();
        }catch(Exception e){}           
                 
    }
 static testMethod void projecteditdelete(){
        Project__c objproject = new Project__c ();
        objproject.Name='test';
        objproject.Starts_date__c= System.now().date();
        objproject.Ends_date__c= System.now().date();
        System.assertEquals('test', objproject.name);
        insert objproject;
                
        Subproject__c subPrj = new Subproject__c();         
        subPrj.Name='ITC Project';
        subPrj.Parent_project__c = objproject.Id;
        subPrj.Ends_date__c = system.toDay().addDays(3);
        subPrj.Starts_date__c= system.toDay();
        subPrj.Status__c = 'In Progress';         
        System.assertEquals('ITC Project', subPrj.name);     
        insert subPrj;  
        
        PageReference pageRef = Page.MusqotAdminPage;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('proj', subPrj.id);       
        ApexPages.StandardController sc = new ApexPages.standardController(subPrj);
        ProjectEditController projeditcot = new ProjectEditController();
        try{   
        projeditcot.DeleteProject();
        }catch(Exception e){}
         }
}