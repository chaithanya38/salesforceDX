/**
 * BFM_AccountSharer_Test
 * Class for Apex testing and code coverage of the BFM_Account_Sharer class
 * Creation Date: 2016/07/28
 * Author: Zanquini, Vinicius
 */
@isTest
private class BFM_AccountSharer_Test{
    public static String orgId = UserInfo.getOrganizationId();
    public static String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
    public static Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
    public static String uniqueName = orgId + dateString + randomInt;
private static testMethod void passwordresettest(){
    
    UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
    system.debug('portalRole is ' + portalRole);
    
    Profile profile1 = [Select Id from Profile where name = 'System Administrator' LIMIT 1];
    User portalAccountOwner1 = new User(
    UserRoleId = portalRole.Id,
    ProfileId = profile1.Id,
    Username = System.now().millisecond() + 'test2@test.com',
    Alias = 'batman',
    Email='bruces.wayne@wayneenterprises.com',
    EmailEncodingKey='UTF-8',
    Firstname='Bruce',
    Lastname='Wayne',
    LanguageLocaleKey='en_US',
    LocaleSidKey='en_US',
    TimeZoneSidKey='America/Chicago'
    );
    Database.insert(portalAccountOwner1);

        //User u1 = [Select ID From User Where Id =: portalAccountOwner1.Id];
        
        System.runAs ( portalAccountOwner1 ) {
        //Create account
        Account portalAccount1 = new Account(
        Name = 'TestAccount',
        OwnerId = portalAccountOwner1.Id
        );
        Database.insert(portalAccount1);
        
        //Create contact
        Contact contact1 = new Contact(
        FirstName = 'Test',
        Lastname = 'McTesty',
        AccountId = portalAccount1.Id,
        Email = System.now().millisecond() + 'test@test.com'
        );
        Database.insert(contact1);
        
        //Create user
        Profile portalProfile = [SELECT Id FROM Profile where Name = 'BFM Partner Community User' Limit 1];
        User user1 = new User(
        Username = uniqueName + '@test' + orgId + '.org',
        //Username = System.now().millisecond() + 'test12345@test.com',
        ContactId = contact1.Id,
        ProfileId = portalProfile.Id,
        Alias = 'test123',
        Email = 'test12345@test.com',
        EmailEncodingKey = 'UTF-8',
        LastName = 'McTesty',
        CommunityNickname = 'test12345',
        TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey = 'en_US',
        LanguageLocaleKey = 'en_US'
        );
        Database.insert(user1);
        BFM_AccountSharer accshare  = new BFM_AccountSharer();
        accshare.shareAccountsReadOnly(user1.Id, new Set<Id>{portalAccount1.Id});
        }
        
    }
}