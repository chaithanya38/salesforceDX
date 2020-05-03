@isTest(seeAllData=true)
public class Costcenter_Ctrl_Test{
    static testMethod void myCostCenterTest(){  
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
      objCC.musqot__Headline__c ='present';
      insert objCC;
      System.assertEquals('test', objCC.name);  
      
       musqot__Activity__c objAct=new musqot__Activity__c ();
       objAct.Name='test';
       objAct.musqot__Use_Allocation__c=true;
       objAct.musqot__Use_Forcasting__c=true;
       objAct.musqot__Use_milestones__c=true;
       insert objAct;
      
        Allocation_amount__c  objAllocationamount=new Allocation_amount__c ();
        objAllocationamount.Name='testAllocation';
        objAllocationamount.musqot__Approved__c=true;
        objAllocationamount.Approved_Amount__c=1000;
        objAllocationamount.musqot__Costcentre__c=objCC.id;
        objAllocationamount.Approvedate__c=System.today();
        objAllocationamount.Description__c='testDescription';
        objAllocationamount.Allocated__c=1000;
        try{
        insert objAllocationamount; 
        }catch(exception e){}        
        System.assertEquals('testAllocation', objAllocationamount.name);
        list<Allocation_amount__c> allocat=[Select Id,musqot__Costcentre__c from  musqot__Allocation_amount__c where musqot__Approved__c=true and musqot__Costcentre__c=:objCC.id];      
        
        delete objCC;
        PageReference pageRef = Page.CostcentersPage;  
        Test.setCurrentPage(pageRef);

        ApexPages.currentPage().getParameters().put('id',objCC.id); 
        ApexPages.currentPage().getParameters().put('cosId',objCC.id); 
        ApexPages.StandardController sc = new ApexPages.standardController(objCC);
        Costcenter_Ctrl objCost= new Costcenter_Ctrl();
        objCost.newCostcenter();
        List<musqot__Costcentre__c> temp=objCost.getCostcenters();
      try{
       objCost.editCostcen();             
       }catch(Exception e){} 
       objCost.DeleteCostcen(); 
       objCost.ccRec=true;  
       objCost.gotoccDetail();
     }
 static testMethod void myCostCenterTest1(){  
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
      objCC.musqot__Headline__c ='present';
      insert objCC;
      System.assertEquals('test', objCC.name); 
       
       musqot__Activity__c objAct=new musqot__Activity__c ();
       objAct.Name='test';
       objAct.musqot__Use_Allocation__c=false;
       objAct.musqot__Use_Forcasting__c=false;
       objAct.musqot__Use_milestones__c=false;
       insert objAct;
       
        Allocation_amount__c  objAllocationamount=new Allocation_amount__c ();
        objAllocationamount.Name='testAllocation';
        objAllocationamount.musqot__Approved__c=true;
        objAllocationamount.Approved_Amount__c=1000;
        //objAllocationamount.musqot__Costcentre__c=objCC.id;
        objAllocationamount.Approvedate__c=System.today();
        objAllocationamount.Description__c='testDescription';
        objAllocationamount.Allocated__c=1000;
       // try{
        insert objAllocationamount; 
       // }catch(exception e){}        
       System.assertEquals('testAllocation', objAllocationamount.name);
        
       list<Allocation_amount__c> allocat=[Select Id,musqot__Costcentre__c from  musqot__Allocation_amount__c where musqot__Approved__c=true and musqot__Costcentre__c=:objCC.id];
     
      ApexPages.currentPage().getParameters().put('id',objCC.id); 
      ApexPages.currentPage().getParameters().put('cosid',objCC.id); 
      ApexPages.StandardController sc = new ApexPages.standardController(objCC);
      Costcenter_Ctrl objCost= new Costcenter_Ctrl();
      objCost.newCostcenter();
      List<musqot__Costcentre__c> temp=objCost.getCostcenters();
      try{
      objCost.editCostcen();
       }catch(Exception e){}
      try{
      musqot__Costcentre__c co=[SELECT id FROM musqot__Costcentre__c WHERE id=:objCC.id limit 1];
      delete co;
      //objCost.DeleteCostcen();             
      }catch(Exception e){}         
      objCost.ccRec=true;  
      List<Apexpages.Message> msgs = ApexPages.getMessages();        
      }
   }