public class BFM_AccountMoreDetailsController {
    public String cpf {get;set;}
    public String firstName {get;set;}
    public String lastName {get;set;}
    public String email {get;set;}
    public Boolean hasInformation {get;set;}
    public List<BFM_UserCreationRequest__c> bfmUserCreationList {get;set;}
    
    public BFM_AccountMoreDetailsController(ApexPages.StandardController stdCtr){
        bfmUserCreationList = [SELECT CPF__c, CNPJ__c, Email__c, Username__c, FirstName__c, LastName__c
                               FROM BFM_UserCreationRequest__c
                               WHERE Email__c =: UserInfo.getUserEmail() AND Created_User__c =: UserInfo.getUserId()] ;
        
        if(bfmUserCreationList.size() > 0) { 
            hasInformation = true;
            cpf = bfmUserCreationList.get(0).CPF__c;
            firstName = bfmUserCreationList.get(0).FirstName__c;
            lastName = bfmUserCreationList.get(0).LastName__c;
            email = bfmUserCreationList.get(0).Email__c;
        } else {
            hasInformation = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Essa conta não possui informações adicionais a serem exibidas')); // TODO : ADD CUSTOM LABEL
        }
    }    
}