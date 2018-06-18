@isTest
public class BFM_AccountDAO_Test {
    private static testMethod void getAccountsWithCNPJPrefixtest(){
        String masterCNPJ1 = '42934489000208';
        BFM_AccountDAO.getAccountsWithCNPJPrefix(masterCNPJ1);
    }    
}