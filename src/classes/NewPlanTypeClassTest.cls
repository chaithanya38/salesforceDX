/************************************************************
Class Name: NewPlanTypeClassTest
Author:Nagaraju        Last modified by: Chaithanya daggumati
Date :22/7/2014        Date : 19/3/2015                    
********©2013 Musqot marketing technology Pvt ltd ***********/

@isTest
private class NewPlanTypeClassTest{
    static testMethod void insertplanty(){
        plantype__c objPlantype=new plantype__c ();
        objPlantype.Name='test';
        objPlantype.Barcolor__c ='FF4FA1';
        System.assertEquals('test', objPlantype.name);
        ApexPages.CurrentPage().getparameters().put('Id', objPlantype.id); 
        ApexPages.StandardController sc = new ApexPages.standardController(objPlantype);
        NewPlanTypeClass objplanty= new NewPlanTypeClass(sc );
        objplanty.plans = objPlantype;   
        objplanty.Save();
        objplanty.Cancel();
        
    }
}