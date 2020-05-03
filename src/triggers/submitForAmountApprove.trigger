/*******************************************************
Class Name: submitForAmountApprove 
Author:G Janardhanreddy               Last modified by: Chaithanya daggumati 
Date: 15/7/2014                       Date: 19/3/2015 
********©2013 Musqot marketing technology Pvt ltd *******/

trigger submitForAmountApprove on Allocation_amount__c (after insert)
{
    List<Allocation_amount__c> amtList = new List<Allocation_amount__c>();
    amtList = [select Id,Name,To_Marketing_activity__c,To_Marketing_activity__r.Project__r.OwnerId,
               Costcentre__r.OwnerId, Costcentre__c, plan__c, plan__r.OwnerId,project__c,project__r.OwnerId 
               from Allocation_amount__c 
               where Id In :trigger.new];       
    for (Allocation_amount__c am : amtList) 
    {
        //if (Trigger.old[i].Probability < 30 && Trigger.new[i].Probability >= 30){
        // create the new approval request to submit
        
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('Submitted for approval. Please approve.');
        req.setObjectId(am.Id);
        if(am.Costcentre__c<>null)
        {
            req.setNextApproverIds(new List<Id>{am.Costcentre__r.OwnerId});
        }
        else if(am.To_Marketing_activity__c<>null)
        {
            req.setNextApproverIds(new List<Id>{am.To_Marketing_activity__r.Project__r.OwnerId});
        }
        else if(am.plan__c<>null)
        {
            req.setNextApproverIds(new List<Id>{am.plan__r.OwnerId});
        } 
        //{trigger.new[i].Costcentre__r.OwnerId});
        // submit the approval request for processing
        else if(am.project__c<>null)
        {
            req.setNextApproverIds(new List<Id>{am.project__r.OwnerId});
        } 
        try
        {
            Approval.ProcessResult result = Approval.process(req);
            // display if the reqeust was successful
            System.debug('Submitted for approval successfully: '+result.isSuccess());                       
        }
        catch(Exception e)
        {
            System.debug('Submitted for approval successfully: '+e.getMessage());
        }
    }  
}