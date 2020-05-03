public with sharing class NewActivityDatesClass {
    public Marketing_activity_dates__c activityDate{get;set;}
    public String mrkId{get;set;}
    public String activityDatId{get;set;}
    public Marketing_activity_dates__c activityDateList{get;set;}
    public Marketing_activity__c parentActivity{get;set;}
    public NewActivityDatesClass(ApexPages.StandardController controller) {
        mrkId = ApexPages.currentPage().getParameters().get('marktid');
        activityDatId = ApexPages.currentPage().getParameters().get('pdateid');
        activityDate=new Marketing_activity_dates__c();
        activityDateList=new Marketing_activity_dates__c();
        try{
        parentActivity=[SELECT Id, Name,Ends_date__c,Starts_date__c 
                        FROM Marketing_activity__c WHERE id=:mrkId];
                        
        activityDate.Name=parentActivity.Name;
        activityDateList=[SELECT Id, Name,Start_date__c,End_date__c,
                          Marketing_activity__c FROM Marketing_activity_dates__c
                          WHERE id=:activityDatId];
         }catch(Exception e){}           
                          
    }
    Public Pagereference saveOccasion(){
        Pagereference PR;
        try{
        if(activityDate.Start_date__c <date.valueOf(parentActivity.Starts_date__c )){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Start date with in the span of Marketing activity startdate ('+ date.valueOf(parentActivity.Starts_date__c)+ ') and enddate ('+ date.valueOf(parentActivity.Ends_date__c)+ ')'));
            return null;
        }
        else if(activityDate.End_date__c>date.valueOf(parentActivity.Ends_date__c)){
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'End date with in the span of Marketing activity startdate ('+ date.valueOf(parentActivity.Starts_date__c)+ ') and enddate ('+ date.valueOf(parentActivity.Ends_date__c)+ ')'));
             return null;
        }
        
        else{
                activityDate.Marketing_activity__c=mrkId;
                insert activityDate;
                String tabId = System.currentPageReference().getParameters().get('tabId');
                string pageRef='/apex/Marketingactivity?id='+EncodingUtil.urlEncode(mrkId,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb2','UTF-8');
                pr=new Pagereference (pageRef);
           }
        }catch(exception e){}
         return pr;   
    }
    Public Pagereference cancel(){
        Pagereference PR;
        if(mrkId<>null){
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/Marketingactivity?id='+EncodingUtil.urlEncode(mrkId,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb2','UTF-8');
            pr=new Pagereference (pageRef);
        }
        return pr;
    }
     Public Pagereference updateActivityDateRec(){
         Pagereference PR;
         try{
            if(activityDateList.Start_date__c < date.valueOf(parentActivity.Starts_date__c )){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Start date with in the span of Marketing activity startdate ('+ date.valueOf(parentActivity.Starts_date__c)+ ') and enddate ('+ date.valueOf(parentActivity.Ends_date__c)+ ')'));
                 return null;
            } 
            else if(activityDateList.End_date__c >date.valueOf(parentActivity.Ends_date__c)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'End date with in the span of Marketing activity startdate ('+ date.valueOf(parentActivity.Starts_date__c)+ ') and enddate ('+ date.valueOf(parentActivity.Ends_date__c)+ ')'));
                 return null;
            } 
            else{
                 Update activityDateList;
                // if(mrkId<>null){
                    String tabId = System.currentPageReference().getParameters().get('tabId');
                    string pageRef='/apex/Marketingactivity?id='+EncodingUtil.urlEncode(mrkId,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb2','UTF-8');
                    pr=new Pagereference (pageRef);
                //}
            }
            }catch(exception e){}
            return pr;
    }
    Public Pagereference deletActivityDateRec(){
        try{
            delete activityDateList;
        }
        catch(exception e){}
        Pagereference PR;
       // if(mrkId<>null){
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/Marketingactivity?id='+EncodingUtil.urlEncode(mrkId,'UTF-8')+'&tab='+EncodingUtil.urlEncode('tb2','UTF-8');
            pr=new Pagereference (pageRef);
        //}
        return pr;
    }
    
}