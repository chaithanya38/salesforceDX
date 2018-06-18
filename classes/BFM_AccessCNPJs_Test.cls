@isTest
private class BFM_AccessCNPJs_Test {
    static testmethod void accessCNPJTestmethod(){
        
        
        List<RecordType> recordTypeList =[select Id, Name, DeveloperName from RecordType where SobjectType='Account' Limit 1];
        
        Profile myProf = [SELECT Id FROM Profile WHERE Name like '%Standard%' limit 1];
       
        User u = new User(LastName = 'Test', email = 'test@domain.com', Alias = 'myAlias', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_CA', TimeZoneSidKey = 'America/Los_Angeles', Username = 'test@br.com', profileId = myProf.Id );
        insert u;
        list<AccountTeamMember> atms = [Select Id From AccountTeamMember Limit 1];
        system.assertEquals(0, atms.size());
        
        Account a = new account(name='TOMBINI E CIA LTDA ', BillingCountry = 'United Kingdom', OwnerId = u.Id, RecordType = recordTypeList);
        insert a;
        
        atms = [Select Id From AccountTeamMember Limit 100];
        system.assertEquals(0, atms.size());
        
        try{
            AccountTeamMember atm = [Select UserId, AccountId, TeamMemberRole From AccountTeamMember Where AccountId =:a.Id And userId = :u.Id];
            system.assertEquals(atm.TeamMemberRole, 'Sales Assistant');
        }catch(exception e){
            system.debug('accesscnpj');    
        }
        Test.startTest();
        
        User testUser = new User(LastName = 'Test', email = 'test@domain.com', Alias = 'myAlias', EmailEncodingKey = 'UTF-8', 
                               LanguageLocaleKey = 'en_AU', LocaleSidKey = 'en_IN', TimeZoneSidKey = 'America/Los_Angeles', 
                               Username = 'test@br.com', profileId = myProf.Id );
       BFM_AccessCNPJs accCNPJ = New BFM_AccessCNPJs(testUser);
        accCNPJ.CNPJaccess();
        accCNPJ.teamMemberRole = 'Account Manager';
        Test.stopTest();        
    }
    
    
     static testmethod void accessCNPJTestmethod2(){
        
        
        List<RecordType> recordTypeList =[select Id, Name, DeveloperName from RecordType where SobjectType='Account' Limit 1];
        
        Profile myProf = [SELECT Id FROM Profile WHERE Name like '%Standard%' limit 1];
       
        User u = new User(LastName = 'Test', email = 'test@domain.com', Alias = 'myAlias', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'es_MX', LocaleSidKey = 'fr_CA', TimeZoneSidKey = 'America/Los_Angeles', Username = 'test@br.com', profileId = myProf.Id );
        insert u;
        list<AccountTeamMember> atms = [Select Id From AccountTeamMember Limit 100];
        system.assertEquals(0, atms.size());
        
        Account a = new account(name='TOMBINI E CIA LTDA ', BillingCountry = 'United Kingdom', OwnerId = u.Id, RecordType = recordTypeList);
        insert a;
        
        atms = [Select Id From AccountTeamMember Limit 100];
        system.assertEquals(0, atms.size());
        
        try{
            AccountTeamMember atm = [Select UserId, AccountId, TeamMemberRole From AccountTeamMember Where AccountId =:a.Id And userId = :u.Id];
            system.assertEquals(atm.TeamMemberRole, 'Sales Assistant');
        }catch(exception e){
            system.debug('accesscnpj');    
        }
        Test.startTest();
        
       BFM_AccessCNPJs accCNPJ = New BFM_AccessCNPJs();
        accCNPJ.CNPJaccess();
        accCNPJ.teamMemberRole = 'Account Manager';
        Test.stopTest();        
    }
}