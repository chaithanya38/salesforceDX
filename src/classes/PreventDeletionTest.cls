/***************************************************************
Class Name: PreventDeletionTest
Author:Janardhan reddy        Last modified by: Janardhan reddy
Date:25/7/2014                Date:   20/03/2015                  
********©2013 Musqot marketing technology Pvt ltd *************/
@isTest
private class PreventDeletionTest{
    static testMethod void testMe()    {
        Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
        User u2 =new User( Alias = 'newUser1' ,Email ='newuser123@testorg.com',EmailEncodingKey = 'UTF-8',LastName = 'Testing',
        LanguageLocaleKey='en_US',LocaleSidKey='en_US', UserName='newuser1234@testorg.com',ProfileId=p.Id,TimeZoneSidKey = 'America/Los_Angeles');
        insert u2; 
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=u2.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c);
        Project__c objproject=new Project__c ();
        objproject.Name='testpro';
        objproject.ownerid = plm.userid__c;
        System.assertEquals('testpro', objproject.name);
        insert objproject;
        Subproject__c objsubprojct=new Subproject__c();
        objsubprojct.name='testsubpro';
        System.assertEquals('testsubpro', objsubprojct.name);
        insert objsubprojct;     
    }
}