/*******************************************************
Class Name: Resourcehourssumbit 
Author:G Janardhanreddy              Last modified by:G janardhanreddy 
Date: 09/04/2015                     Date:09/04/2015 
********©2013 Musqot marketing technology Pvt ltd *******/


trigger Resourcehourssumbit on musqot__Allocation_resources__c(after insert)
{
    List<musqot__Allocation_resources__c> resList = new List<musqot__Allocation_resources__c>();
    resList = [select Id,Name,musqot__To_marketing_activity__c,musqot__To_marketing_activity__r.Project__r.OwnerId,
               Cost_center__r.OwnerId,musqot__Cost_center__c,musqot__Plan__c,musqot__Plan__r.OwnerId,musqot__Project__c,musqot__Project__r.OwnerId 
               from musqot__Allocation_resources__c where Id In :trigger.new];   
                 
    for (musqot__Allocation_resources__c rs : resList ) 
    {
              
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('Submitted for approval. Please approve.');
        req.setObjectId(rs .Id);
        if(rs .Cost_center__c<>null) {
       
             req.setNextApproverIds(new List<Id>{rs .musqot__Cost_center__r.OwnerId});
           
        }
        else if(rs.To_marketing_activity__c<>null)
        {
            req.setNextApproverIds(new List<Id>{rs .musqot__To_marketing_activity__r.Project__r.OwnerId});
        }
        else if(rs.Plan__c<>null)
        {
            req.setNextApproverIds(new List<Id>{rs .musqot__Plan__r.OwnerId});
        } 
        
        else if(rs.Project__c<>null)
        {
            req.setNextApproverIds(new List<Id>{rs .musqot__Project__r.OwnerId});
        } 
        try
        {
            Approval.ProcessResult result = Approval.process(req);
          
            System.debug('Submitted for approval successfully: '+result.isSuccess());                       
        }
        catch(Exception e)
        {
            System.debug('Submitted for approval successfully: '+e.getMessage());
        }
    }  
}