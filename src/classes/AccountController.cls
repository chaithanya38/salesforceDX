public class AccountController{
    @AuraEnabled
    public static List <Account> fetchAccounts() {
        List<Account> accList = [SELECT Id, Name,Website, Phone, Industry, Type from Account LIMIT 100];
        system.debug('accountlist-->'+accList);
        return accList;
    }
}