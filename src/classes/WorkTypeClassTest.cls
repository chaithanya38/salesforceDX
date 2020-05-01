/***************************************************************
Class Name: WorkTypeClassTest 
Author:Chaithanya daggumati     Last modified by: G Janardhanreddy
Date: 18/7/2014                  Date: 19/3/2015 
********©2013 Musqot marketing technology Pvt ltd ***************/
@istest
Private class WorkTypeClassTest{
    private static testmethod void workType()    {
        worktype__C w=new worktype__C();
        w.Name='testWork';
        insert w;
        WorktypeClass w1=new WorktypeClass(New ApexPages.StandardController(w));
        PageReference pr = w1.NewRec();
        system.assertEquals(string.valueOf(pr),'System.PageReference[/apex/musqot__NewWorktasktype]');
        
    }
}