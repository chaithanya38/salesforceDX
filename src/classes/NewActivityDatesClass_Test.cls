@isTest(Seealldata = True)
public class NewActivityDatesClass_Test{
      static testMethod void NewActivityDatesClass(){
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
         objMarketingact.Name='test';
         objMarketingact.Description__c='tdescriptionest';
         objMarketingact.Status__c='completed';
         objMarketingact.musqot__ERP__c='testERP';
         objMarketingact.musqot__Social_media__c='testSocial';
         objMarketingact.musqot__CRM__c='testCRM';
         objMarketingact.Starts_date__c =system.today();
         objMarketingact.Ends_date__c=system.today()+2;
         //objMarketingact.musqot__Activitytype__c=objActiv.id;
         insert objMarketingact;
         System.assertEquals('test', objMarketingact.name);
         
         
         Marketing_activity_dates__c mad=new Marketing_activity_dates__c();
         mad.Name='M1';
         mad.musqot__Start_date__c=system.today()+1;
         mad.musqot__End_date__c=system.today()+1;
         mad.musqot__Marketing_activity__c=objMarketingact.id;
         insert mad;
         System.assertEquals('M1', mad.name);
         
         ApexPages.currentPage().getParameters().put('marktid', objMarketingact.id);
         ApexPages.currentPage().getParameters().put('pdateid',mad.id);
         ApexPages.StandardController sc = new ApexPages.standardController(mad);
         NewActivityDatesClass objActiviyDate= new NewActivityDatesClass(sc);
        // try{
             objActiviyDate.saveOccasion();
             objActiviyDate.updateActivityDateRec();
             objActiviyDate.deletActivityDateRec();
        //  }catch(Exception e){}
          //   objActiviyDate.deletActivityDateRec();
             objActiviyDate.cancel();
  }   
   static testMethod void NewActivityDatesClass1(){
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
         objMarketingact.Name='test';
         objMarketingact.Description__c='tdescriptionest';
         objMarketingact.Status__c='completed';
         objMarketingact.musqot__ERP__c='testERP';
         objMarketingact.musqot__Social_media__c='testSocial';
         objMarketingact.musqot__CRM__c='testCRM';
         objMarketingact.Starts_date__c =system.today();
         objMarketingact.Ends_date__c=system.today()+1;
         //objMarketingact.musqot__Activitytype__c=objActiv.id;
         insert objMarketingact;
         System.assertEquals('test', objMarketingact.name);
         
         
         Marketing_activity_dates__c mad=new Marketing_activity_dates__c();
         mad.Name='M1';
         mad.musqot__Start_date__c=system.today()+1;
         mad.musqot__End_date__c=system.today()+3;
         mad.musqot__Marketing_activity__c=objMarketingact.id;
         insert mad;
         System.assertEquals('M1', mad.name);
         
         ApexPages.currentPage().getParameters().put('marktid', objMarketingact.id);
         ApexPages.currentPage().getParameters().put('pdateid',mad.id);
         ApexPages.StandardController sc = new ApexPages.standardController(mad);
         NewActivityDatesClass objActiviyDate= new NewActivityDatesClass(sc);
        // try{
             objActiviyDate.saveOccasion();
             objActiviyDate.updateActivityDateRec();
             objActiviyDate.deletActivityDateRec();
        //  }catch(Exception e){}
          //   objActiviyDate.deletActivityDateRec();
             objActiviyDate.cancel();
  }     
   static testMethod void NewActivityDatesClass2(){
        Marketing_activity__c objMarketingact=new Marketing_activity__c();
         objMarketingact.Name='test';
         objMarketingact.Description__c='tdescriptionest';
         objMarketingact.Status__c='completed';
         objMarketingact.musqot__ERP__c='testERP';
         objMarketingact.musqot__Social_media__c='testSocial';
         objMarketingact.musqot__CRM__c='testCRM';
        // objMarketingact.Starts_date__c =system.today();
        // objMarketingact.Ends_date__c=system.today()+1;
         //objMarketingact.musqot__Activitytype__c=objActiv.id;
         insert objMarketingact;
         System.assertEquals('test', objMarketingact.name);
         
         
         Marketing_activity_dates__c mad=new Marketing_activity_dates__c();
         mad.Name='M1';
         mad.musqot__Start_date__c=system.today()+1;
         mad.musqot__End_date__c=system.today()+3;
         mad.musqot__Marketing_activity__c=objMarketingact.id;
         insert mad;
         System.assertEquals('M1', mad.name);
         
         ApexPages.currentPage().getParameters().put('marktid', objMarketingact.id);
         ApexPages.currentPage().getParameters().put('pdateid',mad.id);
         ApexPages.StandardController sc = new ApexPages.standardController(mad);
         NewActivityDatesClass objActiviyDate= new NewActivityDatesClass(sc);
        // try{
             objActiviyDate.saveOccasion();
             objActiviyDate.updateActivityDateRec();
             objActiviyDate.deletActivityDateRec();
        //  }catch(Exception e){}
          //   objActiviyDate.deletActivityDateRec();
             objActiviyDate.cancel();
  }                 
}