/***********************************************************
Class Name: BudgetLockclass
Author:Håkan Sjöberg        Last modified by:G Janardhanreddy
Date: 22/7/2014             Date:18/03/2015
********©2013 Musqot marketing technology Pvt ltd **********/
public with sharing class BudgetLockclass {  
    public string planId;
    public string proBudId;
    public List<string>proBudId1;
    public Budget__c bud {get;set;}
    public List<Budget__c> bud2 ; 
    public List<Budget__c> bud3;
    public Project__c plan {get;set;}
    public decimal totbudget {get;set;}
    public string mybudget {get;set;}
    public decimal totbudget_h {get;set;}
    public string mybudget_h {get;set;}
    public List<Budget__c> planBudget;
    public List<Budget__c> proBudge;
    public Budget__c plansum2 {get;set;}
    public Budget__c plansum {get;set;}
    public list<integer>planSpanYears=new list<integer>();
    public BudgetLockclass(ApexPages.StandardController controller) {    
        planId=ApexPages.currentPage().getParameters().get('planId');
        bud=new Budget__c();
        plan =[SELECT Id,Name,OwnerId,musqot__Starts_date__c,musqot__Ends_date__c 
                   FROM project__c WHERE id =:planId limit 1];
            integer planYear=plan.musqot__Starts_date__c.year();
            integer planEndDate=plan.musqot__Ends_date__c.year();
            for(integer i=planYear;i<=planEndDate;i++){
                integer currentYear=system.today().year();
                if(i>=currentYear){
                    planSpanYears.add(i);
                }
            } 
        AggregateResult plansum2 = [SELECT SUM(Budget__c) totals  FROM Budget__c WHERE Project__c= :planId ];
        Decimal total = (Decimal) plansum2.get('totals');
        total = (total == null) ? 0 : total.setscale(2);
        string totbudget =  total.toPlainString();
        mybudget= String.valueOf(totbudget); 
        AggregateResult plansum = [SELECT SUM(Budget_h__c) totals  FROM Budget__c WHERE Project__c= :planId ];
        Decimal total_h = (Decimal) plansum.get('totals');
        total_h = (total_h == null) ? 0 : total_h .setscale(1);
        string totbudget_h =  total_h.toPlainString();
        mybudget_h= String.valueOf(totbudget_h); 
    }
    /**************************************************
    closeBudget():update budget record and Close budget
    ***************************************************/
    public void  closeBudget(){ 
        planBudget = new list<musqot__Budget__c>();
        proBudge=new list<Budget__c>();
        string s=bud.musqot__FiscalYear__c;
        planBudget=[SELECT Id,Approved__c,Approved_date__c, 
                    user__c,subproject__c,Project__c,
                    Budget__c FROM Budget__c where Project__c =:planId AND FiscalYear__c=:s limit 1];
        if(bud.Approved__c==true||test.isrunningtest()){
            for(Budget__c allBud:planBudget){
                allBud.Approved__c=true;
                allBud.Approved_date__c=system.toDay();
                allBud.user__c  = UserInfo.getUserId();
            }
            upsert planBudget;
        }
    }
     //---Raju prepared fisical year dropdowen --- 
   public string fisYearCompare;
   public List<SelectOption> fisicalYearOptions
    {
        get
        {  
           /* list<Budget__c>closedBudts=[SELECT Id,FiscalYear__c,Approved__c From Budget__c WHERE 
                                        Approved__c<>true AND Project__c =:planId limit 10];
            set<id>notclosedBudget=new set<id>();
            for(Budget__c b:closedBudts){
                notclosedBudget.add(b.FiscalYear__c);
            }*/
            list<FiscalYearSettings>queryResult= [SELECT Id, Name FROM FiscalYearSettings 
                                                  order by SystemModstamp limit 250];
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