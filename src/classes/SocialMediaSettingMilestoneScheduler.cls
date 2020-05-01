/*******************************************************
Class Name: SocialMediaSettingMilestoneScheduler
Author: Narendra K Jha        Last modified by: Narendra K Jha
Date: Oct 15, 2015            Date: Oct 15, 2015
********©2015 Musqot marketing technology Pvt ltd *******/

global class SocialMediaSettingMilestoneScheduler Implements Schedulable {
   global void execute(SchedulableContext sc) {
         // do your logic here
         System.debug('scheduler test');
         List<socialmedia_settings__c> socialMediaList = new List<socialmedia_settings__c>();
         Set<socialmedia_settings__c> socialIds = new Set<socialmedia_settings__c>();
         List<musqot__Milestone__c> milstoneList = new List<musqot__Milestone__c>();
         date startdate ;
         date enddate;
         decimal total;
         decimal iProgress_value ;
         date toDay = system.today();
         List<id> connectionId = new List<id>();
         List<musqot__Milestone__c> updateMilestoneList = new List<musqot__Milestone__c>();
         id conId;
         AggregateResult[]  results; 
     
     
        List<Social_media_data__c> allSMsWithIds = [SELECT connection__c from Social_media_data__c limit 100000];
        for(Social_media_data__c s : allSMsWithIds){
            connectionId.add(s.connection__c);//to get update/insert record connection id from social data;
        }
        //to get social media setting records; 
        socialMediaList=[SELECT id, Socialmedia__c 
                         from socialmedia_settings__c 
                         where Socialmedia__c=:connectionId];
        for(socialmedia_settings__c soc:socialMediaList){
            socialIds.add(soc); //prepare list of social media setting ids;
        } 
        milstoneList=[SELECT Id, Name, Plan__c, Status__c, Milestone_type__c ,Target_Socialmedia__c,Target_Socialmedia__r.Socialmedia__c,Target_number__c,musqot__Targetdate__c ,Plan__r.Starts_date__c,Plan__r.Ends_date__c,Project__c,Project__r.Starts_date__c,Project__r.Ends_date__c
                     		,Target_Socialmedia__r.Watch_type__c 
                      FROM Milestone__c  
                      WHERE  Target_Socialmedia__c IN:socialIds and Milestone_type__c=3 limit 100];     
      
        for(musqot__Milestone__c m:milstoneList){
            if(m.Project__c==null){ 
                 startdate =m.Plan__r.Starts_date__c;
                 enddate=m.plan__r.Ends_date__c;
          
            }else{
                startdate =m.Project__r.Starts_date__c;
                enddate=m.Project__r.Ends_date__c;
           }
              conId=m.Target_Socialmedia__r.Socialmedia__c;
          }
        results=[SELECT sum(Number_of_likes__c) no_likes, sum(Number_of_unik_visitor__c) no_visitor,   Sum(Number_of_member__c)no_mem FROM Social_media_data__c 
                                WHERE  musqot__Connection__c=:conId AND  Date__c >=:startdate AND Date__c <=:enddate];
        for(musqot__Milestone__c m:milstoneList){
          for( AggregateResult ag:results){
               If (m.Target_Socialmedia__r.Watch_type__c=='Unique visitors'){
                    total=(Decimal)ag.get('no_visitor');
               }
               else if(m.Target_Socialmedia__r.Watch_type__c=='Likes / click'){
                    total+=(Decimal)ag.get('no_likes');
               } 
               else if(m.Target_Socialmedia__r.Watch_type__c=='Members'){
                   total+=(Decimal)ag.get('no_mem');  
               }
           }
           If(total >0 && m.Target_number__c > 0){
                iProgress_value = (total /m.Target_number__c)*100; //here calclute the iProgress_value 
                if(m.Targetdate__c>toDay && iProgress_value<100){
                    m.Status__c= 'Open'; 
                }
                else if(m.Targetdate__c>=toDay && iProgress_value>=100){
                    m.Status__c= 'Reach on time';  
                }
                else if(m.Targetdate__c<=toDay && iProgress_value<100){
                    m.Status__c= 'Not Reach';          
                }
                else if(m.Targetdate__c<=toDay && iProgress_value>=100){
                    m.Status__c= 'Reach Delayed'; 
                }          
   
          }
          else if(m.musqot__Targetdate__c<=toDay){
               m.Status__c='Not Reach';
          }
          else{
                m.Status__c= 'Open';
         }
             updateMilestoneList.add(m);
         update updateMilestoneList;//here update the list of milestone
     }
       
       
       // rescheduling job
       try{
           List<OAuthService__c> oAuths = [SELECT Id FROM OAuthService__c where auto_import__c = true and end_date__c > TODAY];
           List<socialmedia_settings__c> sms = [select id, name from socialmedia_settings__c 
                                                where Type__c = :'Milestone' and Socialmedia__c in :oAuths];
           if(sms.size() != 0) {
               Date tomorrowsDate = System.today().addDays(1);
               Integer day = tomorrowsDate.day();
               Integer month = tomorrowsDate.month();
               Integer year = tomorrowsDate.year();
               String SchTimer='0 0 1 '+day+' '+month+' ? '+year;   //  next day 1:00 AM
               System.schedule('SocialMediaSettingMilestoneSchedulerJob', SchTimer, new SocialMediaSettingMilestoneScheduler());
           }
       }catch(Exception e){
           System.debug('Exception : ' + e.getMessage());
       }
    }
}