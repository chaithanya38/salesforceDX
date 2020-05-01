/*******************************************************
Class Name: copyMusqotAdminDataTest
Author:Nagaraju G      Last modified by:G Janarhanreddy
Date:  12/8/2014       Date:19/03/2015
********©2013 Musqot marketing technology Pvt ltd *******/
@isTest
global class copyMusqotAdminDataTest{
    @isTest
    public static void testInstallScript() {
        copyMusqotAdminData poinstallscript = new copyMusqotAdminData();
        Test.testInstall(poinstallscript,null);
        Test.testInstall(poinstallscript,new Version(1,0), true);
        List<musqot__plantype__c> pt = [SELECT Id, Name, musqot__Barcolor__c, musqot__sort__c
                                        FROM musqot__plantype__c where Name ='APAC'];
        System.assertEquals(pt.size(), 1, 'plantype');
     }
 }