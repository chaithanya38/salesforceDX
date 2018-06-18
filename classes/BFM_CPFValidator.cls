public with sharing class BFM_CPFValidator {
    private String cpf;
    private String errorMessage;
    
    
    public BFM_CPFValidator(string cpf){
        this.cpf = cpf;
    }
    
    public String getErrorMessage(){
        return this.errorMessage;
    }
    
    public String getCPF(){
        return this.cpf;
    }
    // 400 070 468 04 lenght = 11
    // 51 692 206 0001 60
    public boolean validateCPF(){
        
        if(cpf.length()<11 || !cpf.isnumeric()){
            errorMessage = Label.BFM_Invalid_CPF_Format;
            return false;
        }
        
        List<BFM_UserCreationRequest__c> duplicateContacts = [SELECt CPF__c 
                                  FROM BFM_UserCreationRequest__c 
                                  WHERE CPF__c = :cpf
                                    AND
                                    created_user__c IN (SELECT 
                                     id 
                                     FROM User 
                                     WHERE isActive = true AND ContactId != null)];
        if(!duplicateContacts.isEmpty()){
            errorMEssage = Label.BFM_CPF_Already_in_Use;
            return false;
        }
        
        //Integer totalValue = 0;
        Integer verifyingDigit1 = calculateVerifyingDigit1();
        Integer verifyingDigit2 = calculateVerifyingDigit2();
        
        if(Integer.valueOf(cpf.substring(9,10)) == verifyingDigit1 
           && Integer.valueOf(cpf.substring(10,11)) == verifyingDigit2){
            return true;
        } else{
            errorMessage = Label.BFM_Invalid_CPF_Format;
            return false;
        }
    }
    
    private Integer calculateVerifyingDigit1(){
        Integer verifyingDigit1;
        Integer totalValue = 0;
        for(Integer i = 0; i< cpf.length()-2; i++ ){
            String currentChar = cpf.substring(i, i+1);
            Integer currentDigit = Integer.valueOf(currentChar);
            totalValue += currentDigit*(10-i);
        }
        Integer modulum = Math.mod(totalValue, 11);
        
        if(modulum < 2){
            verifyingDigit1 = 0;
        } else{
            verifyingDigit1 = 11-modulum;
        }
        return verifyingDigit1;
    }
    
    private Integer calculateVerifyingDigit2(){
        Integer totalValue = 0;
        Integer verifyingDigit2;
        for(Integer i = 0; i< cpf.length()-1; i++ ){
            String currentChar = cpf.substring(i, i+1);
            Integer currentDigit = Integer.valueOf(currentChar);
            totalValue += currentDigit*(11-i);
        }
        Integer modulum = Math.mod(totalValue, 11);
        if(modulum < 2){
            verifyingDigit2 = 0;
        } else{
            verifyingDigit2 = 11-modulum;
        }
        return verifyingDigit2;
    }
    
}