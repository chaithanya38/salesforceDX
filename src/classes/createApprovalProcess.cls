/******©2013 Musqot marketing technology Pvt ltd *******/
public with sharing class createApprovalProcess{
    public boolean hide{get;set;}
    //@future(callout=true)
    public createApprovalProcess(){
        hide = false;
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,Label.btn_Create_Approval_Process);
        ApexPages.addMessage(myMsg); 
    }
    public void cretaeAproval(/*String ssId*/){
       
        Post_Install__c pi = Post_Install__c.getInstance('Amount Approval');
        if(!pi.Is_Approval_Crated__c){
            MetadataService.MetadataPort service = new MetadataService.MetadataPort();
            service.SessionHeader = new MetadataService.SessionHeader_element();
            service.SessionHeader.sessionId = UserInfo.getSessionId();
            String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
            
            //MetadataService.MetadataPort service = MetadataService.createService();
            /**** Approval Process Creation *****/
            
            MetadataService.ApprovalProcess approvalProcess = new MetadataService.ApprovalProcess();
            approvalProcess.fullName = 'musqot__Allocation_amount__c.Approval';
            approvalProcess.label = 'Approval';
            approvalProcess.active = true;
            approvalProcess.allowRecall = true;
            approvalProcess.showApprovalHistory = false;
            approvalProcess.recordEditability = 'AdminOrCurrentApprover';
            approvalProcess.finalApprovalRecordLock = false;
            approvalProcess.finalRejectionRecordLock = false;
            approvalProcess.emailTemplate = 'musqot__Approval_Templates/musqot__Amount_Request';
            
            MetadataService.FilterItem filterItm = new MetadataService.FilterItem();
            filterItm.field = 'musqot__Allocation_amount__c.musqot__Allocated__c';
            filterItm.operation = 'notEqual';
            filterItm.value= null;
            
            MetadataService.ApprovalEntryCriteria entryCriteria = new MetadataService.ApprovalEntryCriteria();
            entryCriteria.criteriaItems = new List<MetadataService.FilterItem> { filterItm };
                
                MetadataService.Approver appvr = new MetadataService.Approver ();
            appvr.type_x = 'adhoc';
            
            
            MetadataService.ApprovalStepApprover stepApr = new MetadataService.ApprovalStepApprover ();
            stepApr.approver = new List<MetadataService.Approver> { appvr };
                            
            MetadataService.ApprovalStep aprStep = new MetadataService.ApprovalStep();
            aprStep.allowDelegate = true;
            aprStep.name = 'Step_1';
            aprStep.label= 'Step 1';
            //aprStep.entryCriteria = stepentryCriteria;
            aprStep.assignedApprover = stepApr;
            //aprStep.ifCriteriaNotMet = 'RejectRecord';       
            
            
            MetadataService.ApprovalSubmitter submitter = new MetadataService.ApprovalSubmitter();
            submitter.type_x = 'user';
            submitter.submitter = UserInfo.getUserName();
            approvalProcess.allowedSubmitters = new List<MetadataService.ApprovalSubmitter> { submitter };
                approvalProcess.entryCriteria = entryCriteria;
            // approvalProcess.nextAutomatedApprover = nxtApr;
            approvalProcess.approvalStep = new List<MetadataService.approvalStep> { aprStep };
                //MetadataService.AsyncResult[] Apprrovalresults = service.create(new List<MetadataService.Metadata> { approvalProcess }); 
                List<MetadataService.SaveResult> results =   service.createMetadata(new MetadataService.Metadata[] { approvalProcess });
            /**** End of Approval Process Creation *****/ 
            
            /**** Remote Site Setting Creation
                MetadataService.RemoteSiteSetting rss = new MetadataService.RemoteSiteSetting();            
                rss.fullName = 'InstanceURL';
                rss.url = baseUrl;
                rss.isActive= true;
                rss.disableProtocolSecurity = true;
                MetadataService.AsyncResult[] rssResults = service.create(new List<MetadataService.Metadata> { rss});  
            End of Remote Site Setting Creation ***/
            
            
            if( pi.Is_Approval_Crated__c = true)
            {
                if (Post_Install__c.sObjectType.getDescribe().isUpdateable())
                {
                    //update pi; 
                }
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,Label.appr_Approval_Process_created_successfully);
                ApexPages.addMessage(myMsg);             
            } 
            else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,Label.appr_Approval_Process_already_created);
                ApexPages.addMessage(myMsg); 
                //hide=false;         
            }
        }
        if(!pi.musqot__Is_Hoursapproval_Crated__c){
            MetadataService.MetadataPort service = new MetadataService.MetadataPort();
            service.SessionHeader = new MetadataService.SessionHeader_element();
            service.SessionHeader.sessionId = UserInfo.getSessionId();
            String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
            
            //MetadataService.MetadataPort service = MetadataService.createService();
            /**** Approval Process Creation *****/
            
            MetadataService.ApprovalProcess approvalProcess = new MetadataService.ApprovalProcess();
            approvalProcess.fullName = 'musqot__Allocation_resources__c.Approvalhours';
            approvalProcess.label = 'Approvalhours';
            approvalProcess.active = true;
            approvalProcess.allowRecall = true;
            approvalProcess.showApprovalHistory = false;
            approvalProcess.recordEditability = 'AdminOrCurrentApprover';
            approvalProcess.finalApprovalRecordLock = false;
            approvalProcess.finalRejectionRecordLock = false;
            approvalProcess.emailTemplate = 'musqot__Approval_Templates/musqot__Hours_Request';
            
            MetadataService.FilterItem filterItm = new MetadataService.FilterItem();
            filterItm.field = 'musqot__Allocation_resources__c.musqot__Requested_hours__c';
            filterItm.operation = 'notEqual';
            filterItm.value= null;
            
            MetadataService.ApprovalEntryCriteria entryCriteria = new MetadataService.ApprovalEntryCriteria();
            entryCriteria.criteriaItems = new List<MetadataService.FilterItem> { filterItm };
                
                MetadataService.Approver appvr = new MetadataService.Approver ();
            appvr.type_x = 'adhoc';
            
            
            MetadataService.ApprovalStepApprover stepApr = new MetadataService.ApprovalStepApprover ();
            stepApr.approver = new List<MetadataService.Approver> { appvr };
              
                //MetadataService.ApprovalEntryCriteria stepentryCriteria = new MetadataService.ApprovalEntryCriteria();
                // stepentryCriteria.criteriaItems = new List<MetadataService.FilterItem> { stepfilterItm };
                
            MetadataService.ApprovalStep aprStep = new MetadataService.ApprovalStep();
            aprStep.allowDelegate = true;
            aprStep.name = 'Step_1';
            aprStep.label= 'Step 1';
            //aprStep.entryCriteria = stepentryCriteria;
            aprStep.assignedApprover = stepApr;
            //aprStep.ifCriteriaNotMet = 'RejectRecord';       
            
            
            MetadataService.ApprovalSubmitter submitter = new MetadataService.ApprovalSubmitter();
            submitter.type_x = 'user';
            submitter.submitter = UserInfo.getUserName();
            approvalProcess.allowedSubmitters = new List<MetadataService.ApprovalSubmitter> { submitter };
                approvalProcess.entryCriteria = entryCriteria;
            // approvalProcess.nextAutomatedApprover = nxtApr;
            approvalProcess.approvalStep = new List<MetadataService.approvalStep> { aprStep };
                //MetadataService.AsyncResult[] Apprrovalresults = service.create(new List<MetadataService.Metadata> { approvalProcess }); 
                List<MetadataService.SaveResult> results =   service.createMetadata(new MetadataService.Metadata[] { approvalProcess });
            /**** End of Approval Process Creation *****/ 
            
            /**** Remote Site Setting Creation
                MetadataService.RemoteSiteSetting rss = new MetadataService.RemoteSiteSetting();            
                rss.fullName = 'InstanceURL';
                rss.url = baseUrl;
                rss.isActive= true;
                rss.disableProtocolSecurity = true;
                MetadataService.AsyncResult[] rssResults = service.create(new List<MetadataService.Metadata> { rss});  
                
            End of Remote Site Setting Creation ***/            
           
            pi.musqot__Is_Hoursapproval_Crated__c = true;
            pi.Is_Approval_Crated__c = true;
            hide = true;
            
                if (Post_Install__c.sObjectType.getDescribe().isUpdateable())
                {
                    update pi; 
                }
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,Label.appr_Approval_Process_created_successfully);
                ApexPages.addMessage(myMsg);             
       }
            else{
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,Label.appr_Approval_Process_already_created);
                ApexPages.addMessage(myMsg); 
                //hide=false;         
            }
        }
    
}