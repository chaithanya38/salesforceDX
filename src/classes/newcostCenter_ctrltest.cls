@isTest
public class newcostCenter_ctrltest{
    static testMethod void myNewCostCenterTest(){  
      Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
      User u2 =new User( Alias = 'newUser1' ,
      Email ='newuser123@testorg.com',
      EmailEncodingKey = 'UTF-8',
      LastName = 'Testing',
      LanguageLocaleKey='en_US',
      LocaleSidKey='en_US', 
      UserName='newuser1234@testorg.com',
      ProfileId=p.Id,
      TimeZoneSidKey    = 'America/Los_Angeles');
      insert u2;    
         
      musqot__Costcentre__c objCC=new musqot__Costcentre__c(); 
      objCC.Name='test';
      objCC.musqot__cc_Owner__c=u2.id;
      objCC.musqot__Headline__c='musqotCostcenterdasdsadasd';
      insert objCC;
      System.assertEquals('test', objCC.name);   
      
      musqot__Activity__c objAct=new musqot__Activity__c ();
       objAct.Name='test';
       objAct.musqot__Use_Allocation__c=true;
       objAct.musqot__Use_Forcasting__c=true;
       objAct.musqot__Use_milestones__c=true;
       insert objAct;
           
    ApexPages.currentPage().getParameters().put('id', objCC.id); 
    ApexPages.StandardController sc = new ApexPages.standardController(objCC);
    newcostCenter_ctrl objCost= new newcostCenter_ctrl(sc);
    try{
        objCost.insertCosCenter();
     }catch(exception e){}
    objCost.cancel();
    objCost.updateCosCenter(); 
    objCost.hidCos=true;
    
   }
   static testMethod void myNewCostCenterTest1(){  
      Profile p=[SELECT Id From Profile WHERE Name='Standard User'];
      User u2 =new User( Alias = 'newUser1' ,
      Email ='newuser123@testorg.com',
      EmailEncodingKey = 'UTF-8',
      LastName = 'Testing',
      LanguageLocaleKey='en_US',
      LocaleSidKey='en_US', 
      UserName='newuser1234@testorg.com',
      ProfileId=p.Id,
      TimeZoneSidKey    = 'America/Los_Angeles');
      insert u2;    
         
      musqot__Costcentre__c objCC=new musqot__Costcentre__c(); 
      objCC.Name='test';
      objCC.musqot__cc_Owner__c=u2.id;
      objCC.musqot__Headline__c='musqotCostcenter';
      insert objCC;
      System.assertEquals('test', objCC.name);   
      
      musqot__Activity__c objAct=new musqot__Activity__c ();
       objAct.Name='test';
       objAct.musqot__Use_Allocation__c=true;
       objAct.musqot__Use_Forcasting__c=true;
       objAct.musqot__Use_milestones__c=true;
       insert objAct;
           
    ApexPages.currentPage().getParameters().put('id', objCC.id); 
    ApexPages.StandardController sc = new ApexPages.standardController(objCC);
    newcostCenter_ctrl objCost= new newcostCenter_ctrl(sc);
    try{
     objCost.insertCosCenter();
    }catch(exception e){}
    objCost.cancel();
    objCost.updateCosCenter(); 
    objCost.hidCos=false;
    
   }
     
   }