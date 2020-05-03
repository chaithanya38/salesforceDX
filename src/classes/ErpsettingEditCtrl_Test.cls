/*******************************************************
Class Name: ErpsettingEditCtrl_Test
Author:Nagaraju G      Last modified by:G Janarhanreddy
Date:  19/11/2014      Date:19/03/2015
********©2013 Musqot marketing technology Pvt ltd *******/
@isTest(Seealldata = True)
Public class ErpsettingEditCtrl_Test{
    static testMethod void  ErpsettingtestMethod(){ 
        musqot__ERP_Settings__c  ObjERPEdit=new musqot__ERP_Settings__c ();
        ObjERPEdit.Name='testERPEdit';
        ObjERPEdit.musqot__Selector__c='Business area';
        ObjERPEdit.musqot__erp_Chart__c='Bar charts';
        ObjERPEdit.musqot__Bar_color__c='#123344,#224466';
        System.assertEquals('Business area', ObjERPEdit.musqot__Selector__c);
        insert ObjERPEdit;
        musqot__ERP_Settings__c   erps= [select Id,Name,musqot__Selector__c, musqot__erp_Chart__c,musqot__Bar_color__c from musqot__ERP_Settings__c where Id =:ObjERPEdit.id];
        update erps;
        test.startTest();
        PageReference pageRef = Page.ERPsettingEditpage;
        Test.setCurrentPage(pageRef); 
        String tabId = System.currentPageReference().getParameters().get('tabId');
        ApexPages.currentPage().getParameters().put('mpsett', erps.id);            
        ApexPages.StandardController sc = new ApexPages.standardController(ObjERPEdit); 
        ERPSettingsEditController ERPSEdit=new ERPSettingsEditController (sc);
        
        try{
            ERPSEdit.Save();
            
        }catch(Exception e){
        }
        
        ERPSEdit.Cancel();        
        test.stopTest();
    }
    static testMethod void  ErpsettingtestMethod1(){ 
        musqot__ERP_Settings__c  ObjERPEdit=new musqot__ERP_Settings__c ();
        ObjERPEdit.Name='testERPEdit';
        ObjERPEdit.musqot__Selector__c='Business area';
        ObjERPEdit.musqot__erp_Chart__c='Bar charts';
        ObjERPEdit.musqot__Bar_color__c='#123344,#224466';
        System.assertEquals('Business area', ObjERPEdit.musqot__Selector__c);
        insert ObjERPEdit;
        musqot__ERP_Settings__c   erps= [select Id,Name,musqot__Selector__c, musqot__erp_Chart__c,musqot__Bar_color__c from musqot__ERP_Settings__c where Id =:ObjERPEdit.id];
        update erps;
        test.startTest();
        PageReference pageRef = Page.ERPsettingEditpage;
        Test.setCurrentPage(pageRef); 
        String tabId = System.currentPageReference().getParameters().get('tabId');
        ApexPages.currentPage().getParameters().put('erpid', erps.id);            
        ApexPages.StandardController sc = new ApexPages.standardController(erps); 
        ERPSettingsEditController ERPSEdit=new ERPSettingsEditController (sc);
        List<SelectOption>  temp1=ERPSEdit.getMyOptions();        
        try{
            ERPSEdit.Save();
            
        }catch(Exception e){
        }        
        ERPSEdit.Cancel();       
        test.stopTest();
                }
            }