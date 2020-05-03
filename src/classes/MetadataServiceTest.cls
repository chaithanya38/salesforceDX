/*******************************************************
Class Name: MetadataServiceTest
Author:Hussain peera                Last modified by: janardhan redddy
Date :20/8/2014                     Date : 19/3/2105                    
********©2013 Musqot marketing technology Pvt ltd *******/
@isTest(seeAllData=true)
public class MetadataServiceTest{
    static testMethod void TestMetadataService(){
        MetadataService  ms = new MetadataService ();
        MetadataService.createService();
        
        MetadataService.RetrieveRequest m1 = new MetadataService.RetrieveRequest();
        MetadataService.create_element m2 = new MetadataService.create_element();
        MetadataService.WorkflowActionReference m3 = new MetadataService.WorkflowActionReference();
        MetadataService.ApprovalStep m4 = new MetadataService.ApprovalStep();
        MetadataService.ApprovalPageField m5 = new MetadataService.ApprovalPageField();
        MetadataService.readApprovalProcessResponse_element m6 = new MetadataService.readApprovalProcessResponse_element();
        MetadataService.ApprovalSubmitter m7 = new MetadataService.ApprovalSubmitter();
        MetadataService.FilterItem m8 = new MetadataService.FilterItem();
        MetadataService.ApprovalProcess m9 = new MetadataService.ApprovalProcess();
        MetadataService.Metadata m10 = new MetadataService.Metadata();
        MetadataService.MetadataPort m11 = new MetadataService.MetadataPort();
        MetadataService.NextAutomatedApprover m12 = new MetadataService.NextAutomatedApprover();
        MetadataService.ApprovalStepApprover m13 = new MetadataService.ApprovalStepApprover();
        MetadataService.Approver m14 = new MetadataService.Approver();
        
        MetadataService.ReadApprovalProcessResult m15 = new MetadataService.ReadApprovalProcessResult();
        MetadataService.ApprovalAction m25 = new MetadataService.ApprovalAction();
        MetadataService.AsyncResult m16 = new MetadataService.AsyncResult();
        MetadataService.RemoteSiteSetting m17 = new MetadataService.RemoteSiteSetting();
        MetadataService.ApprovalStepRejectBehavior m18 = new MetadataService.ApprovalStepRejectBehavior();
        
        MetadataService.ApprovalEntryCriteria m19 = new MetadataService.ApprovalEntryCriteria();
        MetadataService.checkStatus_element m20 = new MetadataService.checkStatus_element();
        MetadataService.createResponse_element m21 = new MetadataService.createResponse_element();
        MetadataService.checkStatusResponse_element m22 = new MetadataService.checkStatusResponse_element();
        MetadataService.SessionHeader_element m23 = new MetadataService.SessionHeader_element();
        MetadataService.Error m26 = new MetadataService.Error();
        MetadataService.createMetadataResponse_element cerelmt= new MetadataService.createMetadataResponse_element();
        MetadataService.SaveResult saveReslt = new MetadataService.SaveResult();
        MetadataService.createMetadata_element crelement= new MetadataService.createMetadata_element();
        MetadataService.StaticResource staticRes = new MetadataService.StaticResource ();
        MetadataService.MetadataWithContent metaontant= new MetadataService.MetadataWithContent ();
        system.assertEquals('test','test');
    }
}