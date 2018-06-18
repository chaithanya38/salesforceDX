/**
 * Queueable class to isolate User creation from other DML, since it will give an error if ran synchronously. 
 * After user creation, this class enqueues the Account Sharing creation for the needed Accounts
 * 

 * @author Zanquini, Vinicius
 * @date 2016/08/02
 * */

public with sharing class BFM_CreateUserQueueable implements Queueable {
    Id userRequestId;
    public BFM_CreateUserQueueable(Id userRequestId){
        this.userRequestId = userRequestId;    
        system.debug('sssssssssss');
    }
    public void execute(QueueableContext SC){
    system.debug('sssssssssss1111');
        BFM_UserCreationRequest__c userRequest = [SELECT userName__c, email__c,firstName__c,cnpj__c,Operational_User__c,
                                                   lastName__c, communityNickname__c, (SELECT Account__c,Account__r.parentid FROM BFM_Access_Requests__r)
                                                   FROM BFM_UserCreationRequest__c WHERE Id = :userRequestId];
       
        
        
        User usr = createUser(userRequest);
        //Creates the user as a Portal User for the first Carrier Account he requested access to
        if(!userRequest.BFM_Access_Requests__r.isEmpty()){
            String errorMessage = '';
            try{
                insert usr;
                
                if(usr.id!=null){
                    BFM_LoginuserPermissions.assignPermissionset(usr.id, userRequestId);
                }
            } 

           
            catch(DMLException e){
                errorMessage = e.getDmlMessage(0);
                if(usr.contactId != null){
                    Contact contactToDelete = new Contact(Id = usr.ContactId);
                    delete contactToDelete;
                }

                System.debug('eeee'+errorMessage);
                insert new BFM_User_Creation_Request_Error__c(BFM_User_Creation_Request__c = userRequest.Id, 

                                                       Error_Message__c = errorMessage );
            }

            
            
            // Enqueues the sharing of accounts. This has to be enqueued because Site.createPortalUser is already performing DML on User, 
            // therefore we can't perform AccountShare DML on this transaction anymore
            if(usr.Id != null){
                Set<Id> accountsIds = new Set<Id>();
                for(BFM_AccountAccessRequest__c accessRequest : [SELECT Account__c

                                                                    FROM BFM_AccountAccessRequest__c 
                                                                    WHERE UserCreationRequest__c =:userRequestId]){


                    accountsIds.add(accessRequest.Account__c);                                                
                }
                if(!Test.isRunningTest()){
                    System.enqueueJob(new BFM_UserCreationPostProcessing(usr.Id, userRequestId, accountsIds));
                }
            } 
        }
    }

        
    /**
     * Private instance method that creates one User based on a userRequest. 
     * Doesn't commit the user to the database yet
     * */
    private User createUser(BFM_UserCreationRequest__c userRequest){
        
        Profile carrierProfile = [SELECT Id FROM Profile WHERE Name ='BFM Partner Community User' LIMIT 1];
        Account acc = new Account();
        
        contact con = new contact();
        for(BFM_AccountAccessRequest__c ar: userrequest.BFM_Access_Requests__r){
            if(ar.account__r.parentid!=null){
                acc.parentid = ar.account__r.parentid;
            } 
            acc.id = ar.account__c;     
        }
        if(acc.id!=null){
            con.lastname = userRequest.lastName__c;
            con.FirstName = userRequest.firstName__c;
            if(acc.parentid!=null){
                con.accountid = acc.parentid;

            }
            else{
                con.accountid = acc.id;
            }
            insert con;
        }
        
        
        User u = new User();
        u.Username = userRequest.userName__c;
        u.Email = userRequest.email__c;
        u.FirstName = userRequest.firstName__c;
        u.LastName = userRequest.lastName__c;
        u.CommunityNickname = userRequest.communityNickname__c;

        u.ProfileId = carrierProfile.Id;
        u.alias = u.username.left(4);
        u.LocaleSidKey = 'pt_BR';

        u.LanguageLocaleKey = 'pt_BR';
        u.TimeZoneSidKey = 'America/Sao_Paulo';
        u.EmailEncodingKey = 'ISO-8859-1';
        if(con!=null){
            u.contactid = con.id;
        }
        
        return u;
    }


}