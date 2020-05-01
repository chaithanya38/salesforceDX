/**************************************************************
Class Name: Hoursmarketingpopupcls 
Author:chaithanya daggumati    Last modified by:Raju GN
Date: 09/04/2015                Date:16/10/2015
Dec:Adding fiscal year functionality
********©2013 Musqot marketing technology Pvt ltd *************/

public with sharing class Hoursmarketingpopupcls {
    public Allocation_resources__c hrs{get;set;}
    private ApexPages.standardController controller;
    public Marketing_activity__c market{get;set;}
    private List<Reciver> rev;
    String mark;
    public integer markStartYear;
    public integer markEndDate;
    public list<integer>markSpanYears=new list<integer>();
    public string fisYearCompare;
    public string defaultFiscalYearId{get;set;} 
    public Hoursmarketingpopupcls(ApexPages.StandardController controller) { 
        hrs = new Allocation_resources__c ();     
        Mark = ApexPages.currentPage().getParameters().get('mark');
        try {        
            market= [select ID, Name, Project__c, Project__r.Name,Project__r.Starts_date__c,Project__r.Ends_date__c from musqot__Marketing_activity__c where Id =:Mark];
            //----Raju To get Parent Plan Span Years---
            markStartYear=market.Project__r.Starts_date__c.year();
            markEndDate=market.Project__r.Ends_date__c.year();
            for(integer i=markStartYear;i<=markEndDate;i++){
               integer currentYear=system.today().year();
               if(i>=currentYear){
                 markSpanYears.add(i);
               }
            }  
            //----------End----  
        }
        catch(exception e){}                         
    }
    public void saveHrs()
    {
        if (Allocation_resources__c.sObjectType.getDescribe().isCreateable())
        {
            hrs.project__c = market.Project__c ;
            hrs.To_Marketing_activity__c = Mark;
            hrs.name = market.name;
            insert hrs;
        }
    }
    public class Reciver {
        //public string Sendto{get;set;}
    }
    //---Raju prepared fisical year dropdowen --- 
    
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
                if(fisYearCompare==string.valueof(system.now().year())){
                    defaultFiscalYearId=obj.Name;
                }  
                for(integer i:markSpanYears){
                    if(fisYearCompare==string.valueof(i))
                        fisicalYearOptions.add(new SelectOption(obj.id,obj.Name));
                }
            }
            return fisicalYearOptions;
        }
        set;
    }
    //----End----
}