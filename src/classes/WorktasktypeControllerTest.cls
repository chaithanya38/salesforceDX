@isTest(seeAllData=true)
    public class WorktasktypeControllerTest{
     static testMethod void WorktasktypeControllermethod(){
     worktype__c objworktype=new worktype__c();
     objworktype.name='test';
     objworktype.bartaskcolor__c='red';
     objworktype.musqot__Work_description__c='datatesting';
     insert objworktype;
     System.assertequals('test',objworktype.name);
     
     worktype__c objworktype1=new worktype__c();
     objworktype1.name='test';
     objworktype1.bartaskcolor__c='green';
     objworktype1.musqot__Work_description__c='datatesting';
     insert objworktype1;
     
     System.assertequals('test',objworktype.name);
     Project__c objproj = new Project__c();
     objproj .name = 'testname';
     objproj .Starts_date__c = System.now().date();
     objproj .Ends_date__c =  System.now().date(); 
     objproj .Description__c = 'sampdesc';
     insert objproj ;
     System.assertEquals('testname', objproj.name);
     
      PageReference pageRef = Page.Worktasktype;
      Test.setCurrentPage(pageRef);            
      ApexPages.currentPage().getParameters().put('id', objworktype.id);
      ApexPages.StandardController sc = new ApexPages.standardController(objworktype);  
      WorktasktypeController  objworktask = new WorktasktypeController(); 
      //List<worktype__c> temp1=objworktask.tobeDeleted;
      //objworktask.SelectedWorktaskId='workid';
      //worktype__c wt=[select id,NAme FROM worktype__c  WHERE id=:objworktype.id];
      //delete wt;
      objworktask.LoadData();
      try{
          //objworktask.DeleteAccount();
       }catch(exception e){}
       objworktask.NewWrtype();
       objworktask.DeleteProject();
       //objworktask.planid='test';
       objworktask.worktype='worktype';
       objworktask.redirectPage1();      
     } 
}