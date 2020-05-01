/*******************************************************
Class Name: CreatehoursApprovalURL
Author:Chaithanya daggumati     Last modified by:Chaithanya daggumati
Date:09/04/2015                 Date:09/04/2015
********©2013 Musqot marketing technology Pvt ltd *******/
public with sharing class CreatehoursApprovalURL {  
    public static String generateApprovalURL(String recordID){  
        String url='';  
        system.debug('=======RecordId----'+recordID); 
        List<ProcessInstanceWorkitem> workItemLst =  [ SELECT Id,ProcessInstanceId  FROM ProcessInstanceWorkitem WHERE processInstance.TargetObjectId =:recordID];   
        List<musqot__Allocation_resources__c> ars= new List<musqot__Allocation_resources__c>();  
        ars= [select Id,musqot__Requested_hours__c from musqot__Allocation_resources__c where Id =:recordID];
        if(workItemLst.size() > 0 && ars.size()>0){  
            url='https://'+ System.URL.getSalesforceBaseUrl().getHost() + '/apex/Approvalhourdetail?id=' + EncodingUtil.urlEncode(workItemLst[0].ProcessInstanceId,'UTF-8')+'&arsId='+EncodingUtil.urlEncode(ars[0].Id,'UTF-8');      
        }  
        return url;  
    }  
}