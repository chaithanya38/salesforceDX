/**********************************************************
Class Name: BudgetPlanEditclass
Author:Håkan Sjöberg       Last modified by:G Janardhanreddy
Date: 20/07/2014                        Date:18/03/2015
********©2013 Musqot marketing technology Pvt ltd *********/
public with sharing class BudgetPlanEditclass {
    public string planId{get;set;}
    public Budget__c getbudget {get;set;}
    public boolean Level1{get;set;}
    public boolean Level2{get;set;}
    public boolean Level3{get;set;}
    public integer planYear;
    public string fisyear;
    public integer planEndDate;
    public  project__c plan;
    public list<integer>planSpanYears=new list<integer>();
    public list<musqot__Activity__c> musAct{get;set;}
    public BudgetPlanEditclass(ApexPages.StandardController controller) {
        planId=ApexPages.currentPage().getParameters().get('planId');
        getbudget=new Budget__c();
        try{
       		plan =[SELECT Id,Name,OwnerId,musqot__Starts_date__c,musqot__Ends_date__c 
                   FROM project__c WHERE id =:planId limit 1];
            planYear=plan.musqot__Starts_date__c.year();
            planEndDate=plan.musqot__Ends_date__c.year();
            }catch(Exception e){}
            for(integer i=planYear;i<=planEndDate;i++){
                integer currentYear=system.today().year();
                if(i>=currentYear){
                    planSpanYears.add(i);
                }
            } 
        try{
        getbudget = [SELECT Id,OwnerId,Owner.Name,LastModifiedById,Approved__c,
                     LastModifiedDate,Approved_date__c, Budget__c,Budget_h__c, user__c,
                     Description__c, Project__c, Project__r.Name, subproject__c 
                     ,FiscalYear__c FROM Budget__c WHERE  subproject__c = NULL and 
                     Project__c = :planId order by CreatedDate desc LIMIT 1]; 
        }catch(Exception e){}    
        musAct=[SELECT id,Name,keycode__c,Use_Allocation__c,Use_Budget__c,
                Use_Finance1__c,Use_Forcasting__c,Use_milestones__c,Use_Resource__c 
                FROM musqot__Activity__c limit 1];   
        if(musAct[0].musqot__Use_Finance1__c==true){         
            level1=true;
            Level2=false;
            level3=false;
        } 
        
        if(musAct[0].Use_Resource__c ==true){         
            level2=true;
            Level1=false;
            level3=false;
        } 
        if(musAct[0].musqot__Use_Finance1__c==true&&musAct[0].Use_Resource__c ==true){ 
            
            Level3=true; 
            Level1=false;
            Level2=false;
        }  
    }
    
/****************************************************************
save():update budget  record and redirect to  ProjectDetails page
*****************************************************************/
    public void  Save(){ 
        //if (Budget__c.sObjectType.getDescribe().isUpsertable()){
            string s=getbudget.musqot__FiscalYear__c;
  
            Budget__c editBudget = [SELECT Id,Approved__c,Approved_date__c, Budget__c,Budget_h__c, user__c,
                                     Description__c, Project__c, Project__r.Name, subproject__c 
                                     ,FiscalYear__c FROM Budget__c WHERE  subproject__c = NULL and 
                                     Project__c = :planId AND FiscalYear__c=:s]; 
            //getbudget.Project__c = plan.id;
            editBudget.Budget_h__c = getbudget.Budget_h__c;
            editBudget.Budget__c =getbudget.Budget__c;
            editBudget.Approved_date__c=system.today();
            Upsert editBudget;
            PageReference pg;
            String tabId = System.currentPageReference().getParameters().get('tabId');
            pg=new Pagereference ('/apex/ProjectDetails?id='+EncodingUtil.urlEncode(planId,'UTF-8')+'&tab='+EncodingUtil.urlEncode('bud','UTF-8'));
      // }
    }  
    /***************************************************************
closebud():close the budget and redirect to  ProjectDetails page
****************************************************************/
    public void  closebud(){ 
        PageReference pg;
        String tabId = System.currentPageReference().getParameters().get('tabId');              
        pg=new Pagereference ('/apex/ProjectDetails?id='+EncodingUtil.urlEncode(planId,'UTF-8')+'&tab='+EncodingUtil.urlEncode('bud','UTF-8'));
    }
   //---Raju prepared fisical year dropdowen --- 
   public string fisYearCompare;
   public List<SelectOption> fisicalYearOptions
    {
        get
        {
            list<FiscalYearSettings>queryResult= [SELECT Id, Name FROM 
                                                  FiscalYearSettings order by SystemModstamp LIMIT 250];
                                                 
            fisicalYearOptions= new List<SelectOption>(); 
            for(FiscalYearSettings obj:queryResult)
            {  
               fisYearCompare=obj.Name;
               fisYearCompare=fisYearCompare.substring(0,4);
                for(integer i:planSpanYears){
                   if(fisYearCompare==string.valueof(i))
                   fisicalYearOptions.add(new SelectOption(obj.id, obj.Name));
                }
            }
            return fisicalYearOptions;
        }
        set;
    }
   //----End----   
}