/*******************************************************
Class Name: marketingClassTest
Author:Nagaraju         Last modified by: Janardhan reddy
Date :21/7/2014         Date : 19/3/2105                    
********©2013 Musqot marketing technology Pvt ltd *******/
@isTest(seeAllData=true)
    public class marketingClassTest{
    static testMethod void  marketingClassMethod(){
        Project__c objproject = new Project__c ();
        objproject.Name='test';
        //objproject.Project_type__c='test';
        objproject.Starts_date__c= System.now().date();
        objproject.Ends_date__c= System.now().date();
        System.assertEquals('test', objproject.name);
        insert objproject;
        Subproject__c objsubpro=new Subproject__c();
        objsubpro.Name='testsub';
        objsubpro.Starts_date__c=System.now().date();
        objsubpro.musqot__Parent_project__c=objproject.id;
        objsubpro.Ends_date__c=System.now().date();
        System.assertEquals('testsub', objsubpro.name);
        insert objsubpro;
         
        Activitytype__c objActiv = new Activitytype__c();
         objActiv.Name='musqot';
         objActiv.Icon__c='testicon';
         objActiv.Bar_color__c='blue';
         insert objActiv;
         
        /* List<StaticResource> resourceList = [
         SELECT Name, NamespacePrefix, SystemModStamp 
         FROM StaticResource ];*/
        
        System.assertEquals('musqot', objActiv.name);
        
        Marketing_activity__c objMarketingactivity=new Marketing_activity__c();
        objMarketingactivity.Name='test';
        //objMarketingactivity.Project__c=objproject.id;
        objMarketingactivity.Description__c='tdescriptionest';
        objMarketingactivity.Status__c='completed';
        objMarketingactivity.musqot__Activitytype__c=objActiv.id;
        objMarketingactivity.musqot__Plan__c=objproject .id;
        objMarketingactivity.musqot__Project__c=objsubpro.id;
        System.assertEquals('test', objMarketingactivity.name);
        insert objMarketingactivity;
         String tabId = System.currentPageReference().getParameters().get('tabId');
        ApexPages.currentPage().getParameters().put('id', objMarketingactivity.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objMarketingactivity);
        test.startTest(); 
        marketingClass objMarket1= new marketingClass();
        marketingClass objMarket = new marketingClass(sc);
        List<selectoption>temp=objMarket.ACTList;
        List<SelectOption> tempact = objMarket.getActivityColors();
        objMarket.save();
        objMarket.cancel();
 
        }
         static testMethod void  marketingClassMethod2(){
        Project__c objproject = new Project__c ();
        objproject.Name='test';
        //objproject.Project_type__c='test';
        objproject.Starts_date__c= System.now().date();
        objproject.Ends_date__c= System.now().date();
        System.assertEquals('test', objproject.name);
        insert objproject;
        Subproject__c objsubpro=new Subproject__c();
        objsubpro.Name='testsub';
        objsubpro.Starts_date__c=System.now().date();
        objsubpro.musqot__Parent_project__c=objproject.id;
        objsubpro.Ends_date__c=System.now().date();
        System.assertEquals('testsub', objsubpro.name);
        insert objsubpro;
         
        Activitytype__c objActiv = new Activitytype__c();
         objActiv.Name='musqot';
         objActiv.Icon__c='testicon';
         objActiv.Bar_color__c='blue';
         insert objActiv;
         
        /* List<StaticResource> resourceList = [
         SELECT Name, NamespacePrefix, SystemModStamp 
         FROM StaticResource ];*/
        
        System.assertEquals('musqot', objActiv.name);
        
        Marketing_activity__c objMarketingactivity=new Marketing_activity__c();
        objMarketingactivity.Name='test';
        //objMarketingactivity.Project__c=objproject.id;
        objMarketingactivity.Description__c='tdescriptionest';
        objMarketingactivity.Status__c='completed';
        objMarketingactivity.musqot__Activitytype__c=objActiv.id;
        objMarketingactivity.musqot__Plan__c=objproject .id;
        objMarketingactivity.musqot__Project__c=objsubpro.id;
        System.assertEquals('test', objMarketingactivity.name);
        insert objMarketingactivity;
         String tabId = System.currentPageReference().getParameters().get('tabId');
        ApexPages.currentPage().getParameters().put('subid', objsubpro.id);
       
        
        ApexPages.StandardController sc = new ApexPages.standardController(objMarketingactivity);
        test.startTest(); 
        marketingClass objMarket1= new marketingClass();
        marketingClass objMarket = new marketingClass(sc);
        List<selectoption>temp=objMarket.ACTList; 
         List<Schema.FieldSetMember>  temp1=objMarket .getFields();
         try{
         objMarket.getFieldsetList('String marketid');
         }catch(exception e){}
        objMarket.save();
        objMarket.cancel();
        }

    }