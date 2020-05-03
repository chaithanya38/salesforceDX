/********************************************************
Class Name: NewProjectTypeClass_Test
Author:Nagaraju         Last modified by: janardhan reddy
Date :22/7/2014         Date : 19/3/2015                    
********©2013 Musqot marketing technology Pvt ltd *******/

@isTest(SeeAllData=true)
public class NewProjectTypeClass_Test{
    static testMethod void NewProjectTypeClassmethod(){
        Project_type__c objprojec = new Project_type__c();
        objprojec.Name='test';
        System.assertEquals('test', objprojec.name);
        objprojec.Color__c='blue';
        System.assertEquals('blue', objprojec.Color__c);
        ApexPages.currentPage().getParameters().put('id', objprojec.id);
        ApexPages.StandardController sc = new ApexPages.standardController(objprojec);
        test.startTest(); 
        NewProjectTypeClass objpro= new NewProjectTypeClass(sc );
        List<SelectOption> selOpts=objpro.Fieldsetlist;
        objpro.NewprType=objprojec;
        objpro.Newrec();
        objpro.Cancel();
        List<SelectOption>plantypetemp=objpro.planTypeOptions;
        String[] plantype=objpro.selectedPlanTypes;
        List<String> stringList = new List<String>{'string1','string2','string3'};
        objpro.selectedPlanTypes= stringList;
    }
}