/*******************************************************
Class Name: cls_createApprovalURL
Author:Hussain Peera     Last modified by:G Janarhanreddy
Date:  20/08/2014        Date:19/03/2015
********©2013 Musqot marketing technology Pvt ltd *******/
public with sharing class cls_createApprovalURL {  
    public static String generateApprovalURL(String recordID){  
        String url='';           
        List<ProcessInstanceWorkitem> workItemLst =  [ SELECT Id,ProcessInstanceId  FROM ProcessInstanceWorkitem WHERE processInstance.TargetObjectId =:recordID];   
        List<musqot__Allocation_amount__c> amt = new List<musqot__Allocation_amount__c>();  
        amt = [select Id,musqot__Allocated__c from musqot__Allocation_amount__c where Id =:recordID];
        if(workItemLst.size() > 0 && amt.size()>0){  
            url='https://'+ System.URL.getSalesforceBaseUrl().getHost() + '/apex/approvalDetailPage?id=' + EncodingUtil.urlEncode(workItemLst[0].ProcessInstanceId,'UTF-8')+'&amtId='+EncodingUtil.urlEncode(amt[0].Id,'UTF-8');      
        }  
        return url;  
    }  
}