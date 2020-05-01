/*******************************************************
Class Name: EmailUpdateByOwnerTest
Author:G Janarhanreddy     Last modified by:G Janarhanreddy
Date:  25/7/2014           Date:19/03/2015
********©2013 Musqot marketing technology Pvt ltd *******/
@isTest(Seealldata = True)
public class EmailUpdateByOwnerTest
{
    static testMethod void EmailUpdateByOwner()
    {
        Profile p = [select id from profile where name='System Administrator']; 
        User objUser = new User(alias = 'stan', email='standarduser123@test.com', 
                                emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
                                localesidkey='en_US', profileid = p.Id, 
                                timezonesidkey='America/Los_Angeles', username='standarduser123@test.com');
        insert objUser ;
        
        User u=[SELECT ID,alias FROM User where id=:objUser.id];
        u.alias ='ram';
        update u;
        
        Members__c objmember = new Members__c ();
        //objmember.Name = 'Ram';
        objmember.ProjUsers__c = objUser.Id;
        objmember.Role__c='Member';
        objmember.User_Email__c ='standarduser123@test.com';
        insert objmember; 
        System.assertEquals('Member', objmember.Role__c);
        
        Members__c   Mems = [Select id,Name, ProjMembers__c, ProjUsers__c,ProjUsers__r.name, musqot__Email_del__c,SubProjMembers__c, Role__c, Type__c, User_Email__c FROM Members__c  where id =:objmember.id];                       
        update Mems ;                         
    }          
}