/*******************************************************
Trigger Name: milestonestatus 
Author:G Janardhanreddy               Last modified by: Chaithanya Daggumati
Date: 26/9/2014                       Date: 19/3/2015 
********©2013 Musqot marketing technology Pvt ltd *******/

trigger milestonestatus on Milestone__c (after insert ,after update) {
    date startDate;
    date endDate;
    List<Id> mileids = new List<Id>();
    date toDay=system.today();
    set<string>erpRegionId=new  set<string>();
    list<AggregateResult>results =new list<AggregateResult>();
    decimal iProgress_value ;
    decimal total;
    for(Milestone__c mil :Trigger.new){
        if(mil.Milestone_type__c ==4){
            mileids.add(mil.id);
          }
    }
    string milId1;
   
       
          //update mileupdate;
   }