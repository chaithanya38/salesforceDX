/*******************************************************
Class Name: MetadataService 
Author:Hussain peera              Last modified by: Chaithanya daggumati
Date: 20/8/2014                    Date: 19/3/2015  
********©2013 Musqot marketing technology Pvt ltd *******/

global class MetadataService {
    global virtual class Metadata {
        global String fullName;
        private String[] fullName_type_info = new String[]{'fullName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
            private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
                private String[] field_order_type_info = new String[]{'fullName'};
                    }     
    
    global class create_element {
        global MetadataService.Metadata[] metadata;
        private String[] metadata_type_info = new String[]{'metadata','http://soap.sforce.com/2006/04/metadata','Metadata','0','-1','false'};
            private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
                private String[] field_order_type_info = new String[]{'metadata'};
                    }
    global class SessionHeader_element {
        global String sessionId;
        private String[] sessionId_type_info = new String[]{'sessionId','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
            private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
                private String[] field_order_type_info = new String[]{'sessionId'};
                    }
    
    
    global class createResponse_element {
        global MetadataService.AsyncResult[] result;
        private String[] result_type_info = new String[]{'result','http://soap.sforce.com/2006/04/metadata','AsyncResult','0','-1','false'};
            private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
                private String[] field_order_type_info = new String[]{'result'};
                    }
    
    
    global class FilterItem {
        global String field;
        global String operation;
        global String value;
        global String valueField;
        private String[] field_type_info = new String[]{'field','http://www.w3.org/2001/XMLSchema','string','1','1','false'};
            private String[] operation_type_info = new String[]{'operation','http://soap.sforce.com/2006/04/metadata','FilterOperation','1','1','false'};
                private String[] value_type_info = new String[]{'value','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
                    private String[] valueField_type_info = new String[]{'valueField','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
                        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
                            private String[] field_order_type_info = new String[]{'field','operation','value','valueField'};
                                }
    global class AsyncResult {
        global Boolean checkOnly;
        global Boolean done;
        global String id;
        global String message;
        global Integer numberComponentErrors;
        global Integer numberComponentsDeployed;
        global Integer numberComponentsTotal;
        global Integer numberTestErrors;
        global Integer numberTestsCompleted;
        global Integer numberTestsTotal;
        global String state;
        global String stateDetail;
        global DateTime stateDetailLastModifiedDate;
        global String statusCode;
        private String[] checkOnly_type_info = new String[]{'checkOnly','http://www.w3.org/2001/XMLSchema','boolean','0','1','false'};
            private String[] done_type_info = new String[]{'done','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
                private String[] id_type_info = new String[]{'id','http://soap.sforce.com/2006/04/metadata','ID','1','1','false'};
                    private String[] message_type_info = new String[]{'message','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
                        private String[] numberComponentErrors_type_info = new String[]{'numberComponentErrors','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
                            private String[] numberComponentsDeployed_type_info = new String[]{'numberComponentsDeployed','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
                                private String[] numberComponentsTotal_type_info = new String[]{'numberComponentsTotal','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
                                    private String[] numberTestErrors_type_info = new String[]{'numberTestErrors','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
                                        private String[] numberTestsCompleted_type_info = new String[]{'numberTestsCompleted','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
                                            private String[] numberTestsTotal_type_info = new String[]{'numberTestsTotal','http://www.w3.org/2001/XMLSchema','int','0','1','false'};
                                                private String[] state_type_info = new String[]{'state','http://soap.sforce.com/2006/04/metadata','AsyncRequestState','1','1','false'};
                                                    private String[] stateDetail_type_info = new String[]{'stateDetail','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
                                                        private String[] stateDetailLastModifiedDate_type_info = new String[]{'stateDetailLastModifiedDate','http://www.w3.org/2001/XMLSchema','dateTime','0','1','false'};
                                                            private String[] statusCode_type_info = new String[]{'statusCode','http://soap.sforce.com/2006/04/metadata','StatusCode','0','1','false'};
                                                                private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
                                                                    private String[] field_order_type_info = new String[]{'checkOnly','done','id','message','numberComponentErrors','numberComponentsDeployed','numberComponentsTotal','numberTestErrors','numberTestsCompleted','numberTestsTotal','state','stateDetail','stateDetailLastModifiedDate','statusCode'};
                                                                        }
    
    global static MetadataService.MetadataPort createService()
    { 
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;     
    }
    
    global class MetadataPort {
        global String endpoint_x;
        {
            URL baseUrl = URL.getSalesforceBaseUrl();
            endpoint_x = baseUrl.toExternalForm() + '/services/Soap/m/28.0';
           // endpoint_x = URL.getSalesforceBaseUrl().toExternalForm() + '/services/Soap/m/35.0';
        }
        global Map<String,String> inputHttpHeaders_x;
        global Map<String,String> outputHttpHeaders_x;
        global String clientCertName_x;
        global String clientCert_x;
        global String clientCertPasswd_x;
        global Integer timeout_x;
        global MetadataService.SessionHeader_element SessionHeader;       
        //public String endpoint_x = URL.getSalesforceBaseUrl().toExternalForm() + '/services/Soap/m/35.0';
        private String SessionHeader_hns = 'SessionHeader=http://soap.sforce.com/2006/04/metadata';
        private String DebuggingInfo_hns = 'DebuggingInfo=http://soap.sforce.com/2006/04/metadata';
        private String CallOptions_hns = 'CallOptions=http://soap.sforce.com/2006/04/metadata';
        private String DebuggingHeader_hns = 'DebuggingHeader=http://soap.sforce.com/2006/04/metadata';
        private String[] ns_map_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata', 'MetadataService'};
            
            global MetadataService.AsyncResult[] create(MetadataService.Metadata[] metadata) {
                MetadataService.create_element request_x = new MetadataService.create_element();
                MetadataService.createResponse_element response_x;
                request_x.metadata = metadata;
                Map<String, MetadataService.createResponse_element> response_map_x = new Map<String, MetadataService.createResponse_element>();
                response_map_x.put('response_x', response_x);
                WebServiceCallout.invoke(
                    this,
                    request_x,
                    response_map_x,
                    new String[]{endpoint_x,
                        '',
                        'http://soap.sforce.com/2006/04/metadata',
                        'create',
                        'http://soap.sforce.com/2006/04/metadata',
                        'createResponse',
                        'MetadataService.createResponse_element'}
                );
                response_x = response_map_x.get('response_x');
                system.debug('-------response_x-------'+response_x);
                return response_x.result;
            }
        
        
        global MetadataService.AsyncResult[] checkStatus(String[] asyncProcessId) {
            MetadataService.checkStatus_element request_x = new MetadataService.checkStatus_element();
            MetadataService.checkStatusResponse_element response_x;
            request_x.asyncProcessId = asyncProcessId;
            Map<String, MetadataService.checkStatusResponse_element> response_map_x = new Map<String, MetadataService.checkStatusResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                    '',
                    'http://soap.sforce.com/2006/04/metadata',
                    'checkStatus',
                    'http://soap.sforce.com/2006/04/metadata',
                    'checkStatusResponse',
                    'MetadataService.checkStatusResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }
        
       
        public MetadataService.SaveResult[] createMetadata(MetadataService.Metadata[] metadata) {
            MetadataService.createMetadata_element request_x = new MetadataService.createMetadata_element();
            request_x.metadata = metadata;
            MetadataService.createMetadataResponse_element response_x;
            Map<String, MetadataService.createMetadataResponse_element> response_map_x = new Map<String, MetadataService.createMetadataResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
                this,
                request_x,
                response_map_x,
                new String[]{endpoint_x,
                    '',
                    'http://soap.sforce.com/2006/04/metadata',
                    'createMetadata',
                    'http://soap.sforce.com/2006/04/metadata',
                    'createMetadataResponse',
                    'MetadataService.createMetadataResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.result;
        }  
        
    }   
    
    global class RetrieveRequest {
        global Double apiVersion;
        global String[] packageNames;
        global Boolean singlePackage;
        global String[] specificFiles;        
        private String[] apiVersion_type_info = new String[]{'apiVersion','http://www.w3.org/2001/XMLSchema','double','1','1','false'};
            private String[] packageNames_type_info = new String[]{'packageNames','http://www.w3.org/2001/XMLSchema','string','0','-1','false'};
                private String[] singlePackage_type_info = new String[]{'singlePackage','http://www.w3.org/2001/XMLSchema','boolean','1','1','false'};
                    private String[] specificFiles_type_info = new String[]{'specificFiles','http://www.w3.org/2001/XMLSchema','string','0','-1','false'};
                        private String[] unpackaged_type_info = new String[]{'unpackaged','http://soap.sforce.com/2006/04/metadata','Package','0','1','false'};
                            private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
                                private String[] field_order_type_info = new String[]{'apiVersion','packageNames','singlePackage','specificFiles','unpackaged'};
                                    }
    
    global class checkStatus_element {
        global String[] asyncProcessId;
        private String[] asyncProcessId_type_info = new String[]{'asyncProcessId','http://soap.sforce.com/2006/04/metadata','ID','0','-1','false'};
            private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
                private String[] field_order_type_info = new String[]{'asyncProcessId'};
                    }
    
    
    global class checkStatusResponse_element {
        global MetadataService.AsyncResult[] result;
        private String[] result_type_info = new String[]{'result','http://soap.sforce.com/2006/04/metadata','AsyncResult','0','-1','false'};
            private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
                private String[] field_order_type_info = new String[]{'result'};
                    }
    global class ApprovalSubmitter {
        global String submitter;
        global String type_x;
        private String[] submitter_type_info = new String[]{'submitter','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
            private String[] type_x_type_info = new String[]{'type','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
                private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
                    private String[] field_order_type_info = new String[]{'submitter','type_x'};
                        }
    global class ApprovalProcess extends Metadata {
        global String type = 'ApprovalProcess';
        global String fullName;
        global Boolean active;
        global Boolean allowRecall;
        global MetadataService.ApprovalSubmitter[] allowedSubmitters;
        global MetadataService.ApprovalPageField approvalPageFields;
        global MetadataService.ApprovalStep[] approvalStep;
        global String description;
        global String emailTemplate;
        global Boolean enableMobileDeviceAccess;
        global MetadataService.ApprovalEntryCriteria entryCriteria;
        global MetadataService.ApprovalAction finalApprovalActions;
        global Boolean finalApprovalRecordLock;
        global MetadataService.ApprovalAction finalRejectionActions;
        global Boolean finalRejectionRecordLock;
        global MetadataService.ApprovalAction initialSubmissionActions;
        global String label;
        global MetadataService.NextAutomatedApprover nextAutomatedApprover;
        global String postTemplate;
        global MetadataService.ApprovalAction recallActions;
        global String recordEditability;
        global Boolean showApprovalHistory;
        private String[] active_type_info = new String[]{'active','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
            private String[] allowRecall_type_info = new String[]{'allowRecall','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
                private String[] allowedSubmitters_type_info = new String[]{'allowedSubmitters','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
                    private String[] approvalPageFields_type_info = new String[]{'approvalPageFields','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
                        private String[] approvalStep_type_info = new String[]{'approvalStep','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
                            private String[] description_type_info = new String[]{'description','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
                                private String[] emailTemplate_type_info = new String[]{'emailTemplate','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
                                    private String[] enableMobileDeviceAccess_type_info = new String[]{'enableMobileDeviceAccess','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
                                        private String[] entryCriteria_type_info = new String[]{'entryCriteria','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
                                            private String[] finalApprovalActions_type_info = new String[]{'finalApprovalActions','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
                                                private String[] finalApprovalRecordLock_type_info = new String[]{'finalApprovalRecordLock','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
                                                    private String[] finalRejectionActions_type_info = new String[]{'finalRejectionActions','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
                                                        private String[] finalRejectionRecordLock_type_info = new String[]{'finalRejectionRecordLock','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
                                                            private String[] initialSubmissionActions_type_info = new String[]{'initialSubmissionActions','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
                                                                private String[] label_type_info = new String[]{'label','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
                                                                    private String[] nextAutomatedApprover_type_info = new String[]{'nextAutomatedApprover','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
                                                                        private String[] postTemplate_type_info = new String[]{'postTemplate','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
                                                                            private String[] recallActions_type_info = new String[]{'recallActions','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
                                                                                private String[] recordEditability_type_info = new String[]{'recordEditability','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
                                                                                    private String[] showApprovalHistory_type_info = new String[]{'showApprovalHistory','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
                                                                                        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
                                                                                            private String[] type_att_info = new String[]{'xsi:type'};
                                                                                                private String[] fullName_type_info = new String[]{'fullName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
                                                                                                    private String[] field_order_type_info = new String[]{'fullName', 'active','allowRecall','allowedSubmitters','approvalPageFields','approvalStep','description','emailTemplate','enableMobileDeviceAccess','entryCriteria','finalApprovalActions','finalApprovalRecordLock','finalRejectionActions','finalRejectionRecordLock','initialSubmissionActions','label','nextAutomatedApprover','postTemplate','recallActions','recordEditability','showApprovalHistory'};
                                                                                                        }
    global interface IReadResult {
        MetadataService.Metadata[] getRecords();
    }
    global interface IReadResponseElement {
        IReadResult getResult();
    }
    global class Approver {
        global String name;
        global String type_x;
        private String[] name_type_info = new String[]{'name','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
            private String[] type_x_type_info = new String[]{'type','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
                private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
                    private String[] field_order_type_info = new String[]{'name','type_x'};
                        }
    global class WorkflowActionReference {
        global String name;
        global String type_x;
        private String[] name_type_info = new String[]{'name','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
            private String[] type_x_type_info = new String[]{'type','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
                private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
                    private String[] field_order_type_info = new String[]{'name','type_x'};
                        }
    global class NextAutomatedApprover {
        global Boolean useApproverFieldOfRecordOwner;
        global String userHierarchyField;
        private String[] useApproverFieldOfRecordOwner_type_info = new String[]{'useApproverFieldOfRecordOwner','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
            private String[] userHierarchyField_type_info = new String[]{'userHierarchyField','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
                private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
                    private String[] field_order_type_info = new String[]{'useApproverFieldOfRecordOwner','userHierarchyField'};
                        }
    global class ApprovalStepRejectBehavior {
        global String type_x;
        private String[] type_x_type_info = new String[]{'type','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
            private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
                private String[] field_order_type_info = new String[]{'type_x'};
                    }
    global class ApprovalStep {
        global Boolean allowDelegate;
        global MetadataService.ApprovalAction approvalActions;
        global MetadataService.ApprovalStepApprover assignedApprover;
        global String description;
        global MetadataService.ApprovalEntryCriteria entryCriteria;
        global String ifCriteriaNotMet;
        global String label;
        global String name;
        global MetadataService.ApprovalStepRejectBehavior rejectBehavior;
        global MetadataService.ApprovalAction rejectionActions;
        private String[] allowDelegate_type_info = new String[]{'allowDelegate','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
            private String[] approvalActions_type_info = new String[]{'approvalActions','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
                private String[] assignedApprover_type_info = new String[]{'assignedApprover','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
                    private String[] description_type_info = new String[]{'description','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
                        private String[] entryCriteria_type_info = new String[]{'entryCriteria','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
                            private String[] ifCriteriaNotMet_type_info = new String[]{'ifCriteriaNotMet','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
                                private String[] label_type_info = new String[]{'label','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
                                    private String[] name_type_info = new String[]{'name','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
                                        private String[] rejectBehavior_type_info = new String[]{'rejectBehavior','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
                                            private String[] rejectionActions_type_info = new String[]{'rejectionActions','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
                                                private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
                                                    private String[] field_order_type_info = new String[]{'allowDelegate','approvalActions','assignedApprover','description','entryCriteria','ifCriteriaNotMet','label','name','rejectBehavior','rejectionActions'};
                                                        }
    
    global class ApprovalAction {
        global MetadataService.WorkflowActionReference[] action;
        private String[] action_type_info = new String[]{'action','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
            private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
                private String[] field_order_type_info = new String[]{'action'};
                    }
    
    global class ReadApprovalProcessResult implements IReadResult {
        global MetadataService.ApprovalProcess[] records;
        global MetadataService.Metadata[] getRecords() { return records; }
        private String[] records_type_info = new String[]{'records','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
            private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
                private String[] field_order_type_info = new String[]{'records'};
                    }
    global class readApprovalProcessResponse_element implements IReadResponseElement {
        global MetadataService.ReadApprovalProcessResult result;
        global IReadResult getResult() { return result; }
        private String[] result_type_info = new String[]{'result','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
            private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
                private String[] field_order_type_info = new String[]{'result'};
                    }
    
    global class ApprovalPageField {
        global String[] field;
        private String[] field_type_info = new String[]{'field','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
            private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
                private String[] field_order_type_info = new String[]{'field'};
                    }
    global class ApprovalEntryCriteria {
        global String booleanFilter;
        global MetadataService.FilterItem[] criteriaItems;
        global String formula;
        private String[] booleanFilter_type_info = new String[]{'booleanFilter','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
            private String[] criteriaItems_type_info = new String[]{'criteriaItems','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
                private String[] formula_type_info = new String[]{'formula','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
                    private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
                        private String[] field_order_type_info = new String[]{'booleanFilter','criteriaItems','formula'};
                            }
    global class ApprovalStepApprover {
        global MetadataService.Approver[] approver;
        global String whenMultipleApprovers;
        private String[] approver_type_info = new String[]{'approver','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
            private String[] whenMultipleApprovers_type_info = new String[]{'whenMultipleApprovers','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
                private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
                    private String[] field_order_type_info = new String[]{'approver','whenMultipleApprovers'};
                        }
    
    global class RemoteSiteSetting extends Metadata {
        global String type = 'RemoteSiteSetting';
        global String fullName;
        global String description;
        global Boolean disableProtocolSecurity;
        global Boolean isActive;
        global String url;
        private String[] description_type_info = new String[]{'description','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
            private String[] disableProtocolSecurity_type_info = new String[]{'disableProtocolSecurity','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
                private String[] isActive_type_info = new String[]{'isActive','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
                    private String[] url_type_info = new String[]{'url','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
                        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
                            private String[] type_att_info = new String[]{'xsi:type'};
                                private String[] fullName_type_info = new String[]{'fullName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
                                    private String[] field_order_type_info = new String[]{'fullName', 'description','disableProtocolSecurity','isActive','url'};
                                        }
    
    public class Error {
        public String[] fields;
        public String message;
        public String statusCode;
        private String[] fields_type_info = new String[]{'fields','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
            private String[] message_type_info = new String[]{'message','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
                private String[] statusCode_type_info = new String[]{'statusCode','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
                    private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
                        private String[] field_order_type_info = new String[]{'fields','message','statusCode'};
                            }
    
    public class SaveResult {
        public MetadataService.Error[] errors;
        public String fullName;
        public Boolean success;
        private String[] errors_type_info = new String[]{'errors','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
            private String[] fullName_type_info = new String[]{'fullName','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
                private String[] success_type_info = new String[]{'success','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
                    private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
                        private String[] field_order_type_info = new String[]{'errors','fullName','success'};
                            }
    
    public class createMetadataResponse_element {
        public MetadataService.SaveResult[] result;
        private String[] result_type_info = new String[]{'result','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
            private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
                private String[] field_order_type_info = new String[]{'result'};
                    }
    public class createMetadata_element {
        public MetadataService.Metadata[] metadata;
        private String[] metadata_type_info = new String[]{'metadata','http://soap.sforce.com/2006/04/metadata',null,'0','-1','false'};
            private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
                private String[] field_order_type_info = new String[]{'metadata'};
                    }
      //--Raju Adding Metadata for Static Resource--
       global class StaticResource extends MetadataWithContent{
        public String type = 'StaticResource';
        public String fullName;
        public String content;
        public String cacheControl;
        public String contentType;
        public String description;
        public String nameSpaceprefix;
        private String[] cacheControl_type_info = new String[]{'cacheControl','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] contentType_type_info = new String[]{'contentType','http://soap.sforce.com/2006/04/metadata',null,'1','1','false'};
        private String[] description_type_info = new String[]{'description','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        //private String[] nameSpaceprefix_type_info = new String[]{'nameSpaceprefix','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] type_att_info = new String[]{'xsi:type'};
        private String[] fullName_type_info = new String[]{'fullName','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] content_type_info = new String[]{'content','http://www.w3.org/2001/XMLSchema','base64Binary','0','1','false'};
        private String[] field_order_type_info = new String[]{'fullName', 'content', 'cacheControl','contentType','description'};
    }
      global virtual class MetadataWithContent extends Metadata{
        public String content;
        private String[] content_type_info = new String[]{'content','http://soap.sforce.com/2006/04/metadata',null,'0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://soap.sforce.com/2006/04/metadata','true','false'};
        private String[] field_order_type_info = new String[]{'content'};
    }  
             
}