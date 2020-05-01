/**************************************************************
Class Name: FRMarketingPopupCtrl 
Author:G Janardhanreddy       Last modified by:Raju GN
Date: 19/7/2014                Date: 16/10/2015
Description:Addidng fiscal year in Marketing activity
********©2013 Musqot marketing technology Pvt ltd *************/

public with sharing class FRMarketingPopupCtrl {
    public Allocation_amount__c amt{get;set;}
    private ApexPages.standardController controller;
    public Marketing_activity__c subpro {get;set;}
    public boolean selfApp{get;set;}
    public boolean ccApp{get;set;}
    private List<Reciver> rev;
    String mark;
    public integer markStartYear;
    public integer markEndDate;
    public list<integer>markSpanYears=new list<integer>();
    public string fisYearCompare;
    public string defaultFiscalYearId{get;set;} 
    public FRMarketingPopupCtrl(ApexPages.StandardController controller) { 
        amt = new Allocation_amount__c ();     
        mark = ApexPages.currentPage().getParameters().get('mark');        
        try{
        subpro = [select ID, Name, Project__c, Project__r.Name,Project__r.Starts_date__c,Project__r.Ends_date__c 
                  from musqot__Marketing_activity__c where Id =:mark]; 
         //----Raju To get Parent Project Span Years---
            markStartYear=subpro.Project__r.Starts_date__c.year();
            markEndDate=subpro.Project__r.Ends_date__c.year();
            }catch(Exception e){}
               for(integer i=markStartYear;i<=markEndDate;i++){
                integer curntYear=system.today().year();
                if(i>=curntYear){ 
                   markSpanYears.add(i);
                }
               }  
        //----------End----                      
    }
    /**********************************************
    saveAmt()insert Allocationamount
    ***********************************************/
    public void saveAmt()
    {
        if (Allocation_amount__c.sObjectType.getDescribe().isCreateable())
        {
            amt.project__c = subpro.Project__c ;
            amt.To_Marketing_activity__c = mark;
            amt.name = subpro.name;
            insert amt;
        }
    }
    public class Reciver {
    }
   //---Raju prepared fisical year dropdowen Hoursmarketingpopup Page--- 
   public List<SelectOption> fisicalYearOptions
    {
        get
        {
            list<FiscalYearSettings>queryResult= [SELECT Id, Name
                                                  FROM FiscalYearSettings order by SystemModstamp LIMIT 250];
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