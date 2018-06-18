/**
* An apex page controller that supports self registration of users in communities that allow self registration
*/
public without sharing class BFM_CommunitiesSelfRegController_CC {
    
    public String firstName {get; set;}
    public String lastName {get; set;}
    public String email {get; set;}
    public string cnpj {get; set;}
    public String cpf{get;set;}
    public String communityNickname {get; set { communityNickname = value == null ? value : value.trim(); } }
    public boolean submitEnabled{get;set;}
    public boolean allDone{get;set;}
    public boolean operationalUser{get;set;}
    public boolean financialUser{get;set;}
    public String supportEmail{get;set;}
    public string sendEmail {get;set;}
    
    public boolean readOnlyForm{get;set;}
    public BFM_UserCreationRequest__c newCarrierUserRequest;
    public BFM_CommunitiesSelfRegController_CC() {
        submitEnabled = false;
        allDone = false;
        firstName = '';
        lastName = '';
        readOnlyForm = false;
        supportEmail = system.label.BFM_Support_Email;
        sendEmail = 'mailto:'+supportEmail ;
    }
    
    public class RequestLine{
        
        public boolean isSelected{get;set;}
        public Account branch{get;set;}
        
        public RequestLine(boolean isSelected, Account branch) {
            this.isSelected = isSelected;
            this.branch = branch;
        }
    }
    
    public Map<Id,RequestLine> requestLines{get;set;}

    public void fetchBranches() {
        
        newCarrierUserRequest = new BFM_UserCreationRequest__c();
        newCarrierUserRequest.Username__c = email + '.carrier';
        newCarrierUserRequest.Email__c = email;
        newCarrierUserRequest.FirstName__c = firstName;
        newCarrierUserRequest.LastName__c = lastName;
        newCarrierUserRequest.CommunityNickname__c = communityNickname;
        newCarrierUserRequest.cnpj__c = cnpj;
        newCarrierUserRequest.cpf__c = cpf;
        newCarrierUserRequest.Operational_User__c = operationalUser;
        newCarrierUserRequest.Finance_User__c = financialUser;
        newCarrierUserRequest.CurrencyIsoCode = 'BRL';
        
        if(validateCarrierRequest(newCarrierUserRequest)) {
            if(newCarrierUserRequest.cnpj__c.length() != 8) { // If the length is different than 8, thrown an error message
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.BFM_CNPJ_Length_Error_Message);
                ApexPages.addMessage(msg);
            }
            List<Account> branches = BFM_AccountDAO.getAccountsWithCNPJPrefix(cnpj);
            if(branches.isEmpty()) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.BFM_Self_Service_CNPJ_Not_Found);
                ApexPages.addMessage(msg);
            } else {
                if(requestLines == null || requestLines.isEmpty()) {
                    requestLines = new Map<Id,RequestLine>();
                }
                for(Account branch: branches) {
                    if(!requestLines.containsKey(branch.Id)) {
                        requestLines.put(branch.Id,new RequestLine(false, branch));
                    }
                }
                submitEnabled = true;
                //Changed value to readOnlyForm=false as it should allow the user to update the entry made by user.
                readOnlyForm = false;
            }
        } 
    }
    
    public void submitNewUserRequest() {
        if(validateCarrierRequest(newCarrierUserRequest)) {
            try{
                List<Account> desiredCarriers = getDesiredCarriers();
                if(desiredCarriers.isEmpty()) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                                               Label.BFM_Self_Service_Select_Company));
                } else {
                    
                    insert newCarrierUserRequest;
                    new BFM_CreateAccessRequest(newCarrierUserRequest, desiredCarriers).createAccessRequests();
                    
                    BFM_SendEmailToCarrierApprover emailSender = new BFM_SendEmailToCarrierApprover(newCarrierUserRequest,desiredCarriers);
                    
                    String carrierEmail = emailSender.sendEmail();
                    if(!emailSender.isSuccess()) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,emailSender.getError().replace('&email',supportEmail)));
                        allDone = true;
                        readOnlyForm = false;
                        resetVF();
                    } else {                        
               
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Label.BFM_Self_Service_Request_Created 
                                                                   + ' ' +carrierEmail)) ;
                        allDone = true;
                        readOnlyForm = false;
                        resetVF();
                    }
                }
            }catch (DMLException e) {
                if(StatusCode.DUPLICATE_VALUE ==  e.getDmlType(0)) {
                    
                    
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                               Label.BFM_Error_Creating_Access_Request + ' '+
                                                               'Duplicated value on field e-mail'));
                } 
            }
            catch(Exception e) {
                
                System.debug(Label.BFM_Error_Creating_Access_Request + ' ' + e.getMessage() +' ' +e.getStackTraceString());
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                           Label.BFM_Error_Creating_Access_Request + ' ' + e.getMessage() +' ' +e.getStackTraceString() +e.getTypeName()));
            }
        }
        
    }
    
    public boolean validateCarrierRequest( BFM_UserCreationRequest__c newCarrierUserRequest ) {
        boolean isValid = true;
        if(!financialUser && !operationalUser) {
            isValid = false;
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.BFM_At_Least_one_Permission);
            ApexPages.addMessage(msg);
            return isValid;
        }
        
        //validates if CPF is valid and not duplicated
        BFM_CPFValidator cpfValidator = new BFM_CPFValidator(newCarrierUserRequest.cpf__c);
        if(!cpfValidator.validateCPF()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, cpfValidator.getErrorMessage());
            ApexPages.addMessage(msg);
            isValid = false;
        }
        // validates duplicated nicknames
        List<User> duplicatedNicknames = [SELECT Id FROM User WHERE CommunityNickname =:newCarrierUserRequest.CommunityNickname__c 
                                          LIMIT 1];
        
        if(!duplicatedNicknames.isEmpty()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                       Label.BFM_Self_Service_Nickname_Already_Used ));
            isValid = false;
        }
        
        // validates duplicated email
        List<BFM_UserCreationRequest__c> duplicateUsernames = [SELECT Id FROM 
                                                               BFM_UserCreationRequest__c 
                                                               WHERE email__c = :newCarrierUserRequest.Email__c LIMIT 1];
        List<User> duplicatedUsernamesOnUsers = [SELECT Id FROM User WHERE username = :newCarrierUserRequest.Email__c + '.carrier' LIMIT 1];
        
        if(!duplicateUsernames.isEmpty() || !duplicatedUsernamesOnUsers.isEmpty()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                       Label.BFM_Self_Service_Duplicated_Email ));
            isValid = false;
        }
        // validates email format
        if(!validateEmail(newCarrierUserRequest.Email__c)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                       Label.BFM_Self_Service_Invalid_Email));
            isValid = false;
        }
        return isValid;
    }
    
    public Boolean validateEmail(String email) {
        Boolean res = true;
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; // source: <a href="http://www.regular-expressions.info/email.html" target="_blank" rel="nofollow">http://www.regular-expressions.info/email.html</a>
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(email);
        
        if (!MyMatcher.matches()) { 
            res = false;
        }
        return res; 
    }
    
    public list<Account> getDesiredCarriers() {
        list<Account> desiredCarriers = new List<Account>();
        for(RequestLine reqLine: this.requestLines.values()) {
            if(reqLine.isSelected) {
                desiredCarriers.add(reqLine.branch);
            }
        }
        system.debug('--->'+desiredCarriers);
        return desiredCarriers;
    }    
    
    // VF clearing methods
    public void clearBranchSelection() {
        this.requestLines = new Map<Id, RequestLine>();
    }
    
    public void resetVF() {
        submitEnabled = false;
        allDone = false;
        firstName = '';
        lastName = '';
        email = '';
        cpf = '';
        cnpj = '';
        communityNickname = '';
        financialUser = false;
        operationalUser = false;
        
        requestLines = null;
    }
    
}