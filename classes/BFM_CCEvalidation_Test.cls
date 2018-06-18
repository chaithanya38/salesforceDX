@istest
public class BFM_CCEvalidation_Test {
    
    private static testMethod void BFM_CCeHandler_TestMethod(){      
        Test.startTest();
        Account acc = new Account();
        Id AccRecordTypeId = [Select Id, Name from RecordType where Name = 'Carrier'].Id;
        acc.name = 'TestAccount';
        acc.RecordTypeId = AccRecordTypeId;
        insert acc;
        
        BFM_TriggerHelper.disableTrigger();
        
        BFM_CC_e__c cce = new BFM_CC_e__c();
        cce.CC_e_Key__c = '35161210449909000509570030002300021034523213';
        cce.Carrier_Account__c = acc.Id;
        insert cce;
        
        BFM_TriggerHelper.enableTrigger();
        
        BFM_CC_e__c cce1 = new BFM_CC_e__c();
        cce1.CC_e_Key__c = '65161210449909000509570330002300021034523213';
        cce1.Carrier_Account__c = acc.Id;
        insert cce1;
        
        BFM_CCeHandler ccehanlder = new BFM_CCeHandler();
        ccehanlder.beforeInsert(cce);
        ccehanlder.beforeUpdate(cce,cce);
        ccehanlder.beforeDelete(cce);
        //ccehanlder.bulkBefore();
        ccehanlder.afterInsert(cce);
        ccehanlder.afterUpdate(cce, cce);
        ccehanlder.afterDelete(cce);
        delete cce;
        Test.stopTest();
    }
    
}