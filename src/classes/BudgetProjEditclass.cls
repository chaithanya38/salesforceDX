/*******************************************************
Class Name: BudgetProjEditclass
Author:Håkan Sjöberg     Last modified by:Raju gn
Date: 21/7/2014            Date:18/03/2015
Dsc:Adding fiscal year ..
********©2013 Musqot marketing technology Pvt ltd *******/
public with sharing class BudgetProjEditclass {
    public string PrjId{get;set;}
    public Budget__c getbudget {get;set;}
    public boolean Level1{get;set;}
    public list<musqot__Activity__c> musAct{get;set;}
    public boolean Level2{get;set;}
    public boolean Level3{get;set;}
    //public integer planYear;
    public string fisyear;
    //public integer planEndDate;
    public integer projectStartYear;
    //public string fisyear;
    public integer projectEndDate;
    public list<integer>projectSpanYears=new list<integer>();
    public BudgetProjEditclass(ApexPages.StandardController controller) {
        PrjId=ApexPages.currentPage().getParameters().get('prjId');
        try{
        Subproject__c  pro =[SELECT Id,Name, Starts_date__c,
                                      Ends_date__c FROM  Subproject__c
                                     WHERE id =:PrjId limit 1];
        
            projectStartYear=pro.Starts_date__c.year();
            projectEndDate=pro.Ends_date__c.year();
            for(integer i=projectStartYear;i<=projectEndDate;i++){
                integer currentYear=system.today().year();
                if(i>=currentYear){
                     projectSpanYears.add(i);
                }     
            } 
        }catch(exception e){}
        getbudget = [SELECT  Approved__c,FiscalYear__c,Approved_date__c , 
                         Budget__c , Budget_h__c, user__c , Description__c,Project__c,
                         subproject__c, subproject__r.Name 
                     FROM Budget__c
                     WHERE subproject__c  = :PrjId LIMIT : 1];   
        //try{
        musAct=[SELECT id,Name,keycode__c,Use_Allocation__c,Use_Budget__c,
                musqot__Use_Finance1__c,Use_Forcasting__c,Use_milestones__c,
                Use_Resource__c  
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
      //  }catch(exception e){}
    }
    
    /*** save():This method   update the budget record***/
    public void Save(){ 
        if (Budget__c.sObjectType.getDescribe().isUpdateable())
        { 
            string s=getbudget.musqot__FiscalYear__c;
           
            Budget__c editBudget = [SELECT Id,Approved__c,Approved_date__c, Budget__c,Budget_h__c, user__c,
                                     Description__c, subproject__c  ,FiscalYear__c FROM Budget__c WHERE 
                                     subproject__c =:PrjId AND (FiscalYear__c=:s or FiscalYear__c='')]; 
            editBudget.Budget_h__c = getbudget.Budget_h__c;
            editBudget.Budget__c =getbudget.Budget__c;
            editBudget.Approved_date__c=system.today();
            Upsert editBudget;
           
        }
    }
   //---Raju prepared fisical year dropdowen --- 
   public string fisYearCompare;
   public List<SelectOption> fisicalYearOptions
    {
        get
        {
            list<FiscalYearSettings>queryResult= [SELECT Id, Name 
                                                  FROM FiscalYearSettings order by SystemModstamp limit 200];
            fisicalYearOptions= new List<SelectOption>(); 
            for(FiscalYearSettings obj:queryResult)
            {  
               fisYearCompare=obj.Name;
               fisYearCompare=fisYearCompare.substring(0,4);
               for(integer i:projectSpanYears){
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