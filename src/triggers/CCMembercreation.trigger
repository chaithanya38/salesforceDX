/******************************************************************
Name: CCMemberautocreation for costcenter object
Author: chaithanya daggumati    Last modified by:chaithanya daggumati
Date:09/12/2015                 Date:09/12/2015 
Dec:when costcenter created memberautocreated on costcenter object
********©2013 Musqot marketing technology Pvt ltd ****************/
trigger CCMembercreation on Costcentre__c (After Insert) {
    List<Members__c> mbrs = new List<Members__c>();
    List<Costcentre__c> CCList = New List<Costcentre__c>();
    for(Costcentre__c cos : trigger.new){
       /*** costcenter object record creation ****/
       Costcentre__c CCsp = New Costcentre__c(); 
       CCsp.Name = cos.name;
       CCsp.Headline__c= cos.id;
       CCsp.Overveiw__c = cos.description__C;
       CCList.add(CCsp);
       
        /*** Member object record creation ****/ 
       Members__c mbr = new Members__c ();
       mbr.Cost_center__c = cos.id;
       mbr.ProjUsers__c  = cos.ownerid;
       mbr.Role__c = 'Owner'; 
       mbrs.add(mbr);      
    }
    insert mbrs;
}