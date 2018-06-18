public class BFM_AccessCNPJs {
public String accountAccessLevel;
public String opportunityAccessLevel;
public String caseAccessLevel;
public String teamMemberRole;
public User usr{get;set;}   
    public BFM_AccessCNPJs(){
		usr = new User();                
    }
     public BFM_AccessCNPJs(User paramUser){
		usr = paramUser;                
    }
    public void CNPJaccess(){
        List<RecordType> recordTypeList =[select Id, Name, DeveloperName from RecordType where SobjectType='Account' Limit 1];
		system.debug('==>'+recordTypeList);
        try{
    	usr = [select id,Name,Username from user where Username=:usr.username];
        system.debug('-->'+usr);
        
        teamMemberRole = 'Account Manager';
        accountAccessLevel = 'Edit';
        opportunityAccessLevel = 'Edit';
        caseAccessLevel = 'None';
        List<Account> accounts = [select id,RecordTypeId,RecordType.Name from account where RecordType.Name='Carrier' AND RecordType.Name='BFM Unilever Account' AND BFM_Vendor__c!=null];
        List<AccountTeamMember> members = new list<AccountTeamMember>();
        
        for(Account a : accounts) {
            members.add(New AccountTeamMember(AccountId = a.id, TeamMemberRole = teamMemberRole, UserId= usr.ID));
        }
        insert members;
        system.debug('--->members'+members);
        }catch(exception e){
        	system.debug('AccessCNPJ:');    
        }
    }
}