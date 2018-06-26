public class AccountContactController {
    public List<AccountWrapper> wraplist{get;set;}
    public AccountContactController(){
        wraplist = new List<AccountWrapper>();
        List<Account> acc = [select id,phone,name,(select id ,name, phone from contacts) from account];
        system.debug('acc-->' +acc);
        for(Account acct : acc){
            system.debug('entered');
            wraplist.add(new AccountWrapper(acct,acct.contacts));
        }
    }
    public class AccountWrapper{
        public Account acc{get;set;}
            public List<Contact> cons{get;set;}
        public AccountWrapper(Account a,List<Contact> con){
            acc = a;
            cons = con;
        }
    }
}