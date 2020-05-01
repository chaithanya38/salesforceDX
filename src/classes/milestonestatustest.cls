/**********************************************************************
Class Name: milestonestatus
Author:G Janardhanreddy           Last modified by:chaithanya daggumati  
Date:25/7/2014                    Date: 2/1/2015 
********©2013 Musqot marketing technology Pvt ltd *********************/
@isTest
private class milestonestatustest{

    static testmethod void MileStoneContrlloreMethod(){
        Project__c objproject = new Project__c ();
         objproject.Name='test';
         //objproject.Project_type__c='test';
         objproject.Starts_date__c= System.now().date();
         objproject.Ends_date__c= System.now().date();
         System.assertEquals('test', objproject.name);
         insert objproject;
         
         Milestone__c objmilestone = new  Milestone__c();
         objmilestone.Name = 'test';
         objmilestone.musqot__Plan__c=objproject.id;
         objmilestone.Description__c = 'testdesc';
         objmilestone.Targetdate__c = Date.Today();         
         objmilestone.Milestone_type__c =4;
         objmilestone.Status__c ='Open';
         objmilestone.Target_number__c=5;
         System.assertEquals('test', objmilestone.name);
         insert objmilestone;
         
         List<Milestone__c> mileupdate=[select Id,Name,Plan__c,Targetdate__c,Project__c,Status__c,Description__c, Target_Marketing_activity__c, Target_Marketing_activity__r.Name, Target_Project__c, Target_Project__r.Name, Milestone_type__c   from Milestone__c where id =:objmilestone.id ];
         mileupdate[0].Status__c ='Not reach';
         
          }
  }