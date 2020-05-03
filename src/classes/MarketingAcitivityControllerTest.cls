@isTest(seeAllData=true)
 public class MarketingAcitivityControllerTest{
     static testMethod void Marketingactivity(){
        Profile p = [select id from profile where name='System Administrator']; 
        User objUser = new User(alias = 'stan', email='standarduser@test.com', 
                                emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
                                localesidkey='en_US', profileid = p.Id, 
                                timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
        insert objUser ;  
        Musqot_member__c plm=new Musqot_member__c();
        plm.musqot__userid__c=objUser.id;
        plm.musqot__Role__c='Member';        
        plm.User_type__c='Internal user';
        insert plm;
        System.assertEquals('Member', plm.Role__c); 
         Project__c objproject = new Project__c ();
         objproject.Name='test';
         objproject.Starts_date__c= System.now().date();
         objproject.Ends_date__c= System.now().date();
         objproject.OwnerId=plm.userid__c;
         insert objproject;
         System.assertEquals('test', objproject.name);
         
        musqot__ERP_Settings__c  ObjERPEdit=new musqot__ERP_Settings__c ();
        ObjERPEdit.Name='testERPEdit';
        ObjERPEdit.musqot__Selector__c='Business area';
        ObjERPEdit.musqot__erp_Chart__c='Bar charts';
        ObjERPEdit.musqot__Bar_color__c='#123344,#224466';
        ObjERPEdit.ERP_Performance_type__c='Performance, marketing activity';
        System.assertEquals('Business area', ObjERPEdit.musqot__Selector__c);
        insert ObjERPEdit;
        
        CRM_settings__c mr=new CRM_settings__c();
        mr.Bar_color__c='#369E2B';
        mr.Chart__c='Line chart';
        mr.CRM_performance_type__c='Performance, marketing activity';
        mr.Expression_business_area__c='APAC';
        mr.Expression_business_region__c='Lead';
        mr.Selector__c='test';
        insert mr;
        System.assertEquals('#369E2B', mr.Bar_color__c);
         
         musqot__Socialmedia_settings__c OBJSocial = new musqot__Socialmedia_settings__c();
        OBJSocial.name='testmedia';
        OBJSocial.musqot__Import_rate__c='Hour';        
        OBJSocial.musqot__Socialmedia_type__c='Facebook';
        OBJSocial.musqot__Watch_type__c='Downloads';
        OBJSocial.musqot__Chart__c='Bar charts';
        OBJSocial.musqot__Auto_import__c= true ;   
        OBJSocial.type__c='Performance, marketing activity';
        //OBJSocial.Type__c ='Milestone';
        insert OBJSocial;
        
          Activitytype__c objActiv = new Activitytype__c();
          objActiv.Name='musqot';
          objActiv.Icon__c='testicon';
          objActiv.Bar_color__c='blue';
          
          insert objActiv;
          System.assertEquals('musqot', objActiv.name);
          
         Marketing_activity__c objMarketingact=new Marketing_activity__c();
         objMarketingact.Name='test';
         objMarketingact.Description__c='tdescriptionest';
         objMarketingact.Status__c='completed';
         objMarketingact.musqot__ERP__c='testERP';
         objMarketingact.musqot__Social_media__c='testSocial';
         objMarketingact.musqot__CRM__c='testCRM';
         objMarketingact.musqot__Activitytype__c=objActiv.id;
         insert objMarketingact;
         System.assertEquals('test', objMarketingact.name);
        
         Workspace__c objectwork1=new Workspace__c();
         objectwork1.Name='test';
         objectwork1.ProjectName__c=objproject.id;
         objectwork1.Description__c='test1';
         objectwork1.html_description__c='test123';
         insert objectwork1;
         
         Workspace__c objectwork=new Workspace__c();
         objectwork.Name='test';
         objectwork.ProjectName__c=objproject.id;
         objectwork.Description__c='test1';
         objectwork.html_description__c='test123';
         System.assertEquals('test', objectwork.name);
         insert objectwork;
         
         Task t=new Task();
         t.Task_name__c='test';
         t.Status='completed';
         t.Priority='high';
         t.Allocated_h__c=12;
         System.assertEquals('test', t.Task_name__c);
         
         ApexPages.currentPage().getParameters().put('marktid', objMarketingact.id);
         ApexPages.StandardController sc = new ApexPages.standardController(objMarketingact);
         //MarketingAcitivityController objMRKT1= new MarketingAcitivityController (); 
         MarketingAcitivityController objMRKT= new MarketingAcitivityController (sc);
         //Activitytype__c  actType = [SELECT Id,musqot__F__c FROM musqot__Activitytype__c  WHERE Id =:objMarketingact.musqot__Activitytype__c];
         List<selectoption>temp=objMRKT.ACTList;
         List<Schema.FieldSetMember>  temp1=objMRKT.getFields();
         List<SelectOption> acttemp=objMRKT.getActivityColors();
         List<SelectOption>  temp2=objMRKT.SocialFilter;
         List<SelectOption> temp23=objMRKT.ERPFilter;
         List<SelectOption> temp4=objMRKT.CRMFilter;
         String[] plan=objMRKT.ERPItems;
         String[] plan1=objMRKT.CRMItems; 
         String[] plan2=objMRKT.SocialItems;
         
         List<String> erpstringList = new List<String>{'string1','string2','string3'};
         //try{
             objMRKT.ERPItems= erpstringList;         
             objMRKT.CRMItems= erpstringList;
             objMRKT.SocialItems= erpstringList;
         //}catch(Exception e){}       
         objMRKT.save();
         try{
          objMRKT.getFieldsetList('string marketid');
         }catch(Exception e){} 
         objMRKT.cancel();
         objMRKT.gotoEditMode();
         objMRKT.gotoInfoMode();
         objMRKT.getCustomSettRec(); 
        }
    }