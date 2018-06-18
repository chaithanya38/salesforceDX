@isTest

private class BFM_CPFValidator_Test{   
    private static testMethod void testCPF(){
        list<contact>con=new list<contact>();
        string cpf='12345678909';
        contact con1=new contact();
        con1.LastName='hari';
        con1.BFM_CPF__c=cpf;
        con.add(con1);
        
        string cpf1='123456789';
        contact con2=new contact();
        con2.LastName='harini';
        con2.BFM_CPF__c=cpf1;
        con.add(con2);
        
        contact con3=new contact();
        con3.LastName='harir';
        con3.BFM_CPF__c=cpf;
        con.add(con3);
        insert con;

        BFM_CPFValidator cpfvalidate=new BFM_CPFValidator(cpf);
        BFM_CPFValidator cpfvalidate1=new BFM_CPFValidator(cpf1);
        // BFM_CPFValidator cpfvalidate2=new BFM_CPFValidator(cpf);

        cpfvalidate.validateCPF();
        cpfvalidate1.validateCPF();
        //cpfvalidate2.validateCPF();
        cpfvalidate.getErrorMessage();
        cpfvalidate.getCPF();
    }
}