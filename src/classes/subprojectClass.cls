/*************************************************************
Class Name: subprojectClass
Author:G Janardhanreddy      Last modified by:Raju GN
Date: 27/6/2014              Date:  19/03/2015
Dec:Addin filter in Project types
********©2013 Musqot marketing technology Pvt ltd *************/
public with sharing class subprojectClass{
    public Subproject__c subprj{get;set;}
    public String fieldSetName;
    String planId; 
    Public String subPrjId;
    public Project__c prj;
    public List<SelectOption> PROTList{get;set;}
    public List<Project_type__c> PRO_Temp = new List<Project_type__c>();
    public string PlanType;
    public list<Project__c> parentPlantype;  
    public subprojectClass(ApexPages.StandardController sc){
        
        planId = ApexPages.CurrentPage().getParameters().get('planId');  
        string mainStr = ApexPages.CurrentPage().getParameters().get('retURL');
        parentPlantype=new list<Project__c>();  
        parentPlantype=[SELECT Id, Plantype__r.Name FROM Project__c where id=:planId limit 1];
        if(parentPlantype.size() > 0) {
        PlanType = parentPlantype[0].plantype__r.name;
        }
        prj= [SELECT Id,name, Starts_date__c, Ends_date__c from  Project__c where id=:planId];
        if(mainStr<>null){            
            List<String> str = mainStr.split('%');
            List<String> st = str[0].split('=');
            String ss = st[1];
            subPrjId = ss.subString(0,15);           
        }
        else{
            subPrjId= ApexPages.CurrentPage().getParameters().get('prjId');
        }
        
        PRO_Temp = [Select Name, Id, Plantype__c From Project_type__c limit  250];
        PROTList= new List<SelectOption>();
        string pt ='';
        
        for(Project_type__c objPROT : PRO_Temp )
            {
                pt = objPROT.plantype__c +'';              
                //if(pt.contains(PlanType)||pt.contains('null')){
                    if(PlanType!=null && (pt.contains(PlanType)||pt.contains('null'))){                    
                    PROTList.add(new SelectOption(objPROT.Id, objPROT.Name));
                }
            }
        subprj = new Subproject__c();
        if(!PRO_Temp.isEmpty()){
            subprj.Project_type__c= PRO_Temp[0].Id;
        }
       getCustomSettRec();
    }
     /**************************************
      getFields():it returns fieldset fields
    ****************************************/
    public List<schema.fieldsetmember> getFields() {
      if(!String.isBlank(fieldSetName)){
            Schema.FieldSet fldSet = Schema.SObjectType.Subproject__c.fieldSets.getMap().get(fieldSetName); 
            if(fldSet<>null){
                return fldSet.getFields();
            }
            else{
                return new List<schema.fieldsetmember>();
            }
      }
      else {
            return new List<schema.fieldsetmember>();
        }  
     } 
    public subprojectClass(){
        
    }
    /***************************************************************
    save():insert project records and redirect to related parent page
    ******************************************************************/ 
    public PageReference save(){
        string subPrjId1= ApexPages.CurrentPage().getParameters().get('prjId');
        List<Subproject__c> lstsub = [SELECT Id, name,Project_del__r.Starts_date__c,Project_del__r.Name,Parent_project__c,Starts_date__c,Ends_date__c 
                                      from Subproject__c where name=:subprj.name ];
        List<Project__c> lstprj = [SELECT Id, name,Starts_date__c,Ends_date__c 
                                   from Project__c where name=:prj.name];               
        List<Subproject__c> sbp =[SELECT Id,Name,Project_del__c,Project_del__r.Starts_date__c,Project_del__r.Name,Starts_date__c,Ends_date__c 
                                  from Subproject__c where Id=:subPrjId1 LIMIT 1];                
        if(subPrjId<>null){
            subprj.Project_del__c = subPrjId; 
        }
        else{
            subprj.Parent_project__c = planId; 
        }if(lstsub.size()>0){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.pt_Project_name_already_exist));
            return null;
        }              
        else if(prj.Ends_date__c<subprj.Starts_date__c){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.pt_Part_of_running_date_should_be_inside_parent_date_span));
            return null;
        }
        else if(subprj.Name==prj.Name){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Label.pt_Name_can_not_be_same_as_Parent));
            return null;
        }        
        else if(subprj.Ends_date__c<prj.Starts_date__c){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,subprj.Name + ' should not end before ' + prj.Name + ' startdate'));
            return null;
            }                     
        else if(subPrjId<>null){
            if(subprj.Ends_date__c<sbp[0].Starts_date__c){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, subprj.Name + ' should not end before ' + sbp[0].Name+ ' startdate'));
            return null;
            }
        else if(subprj.Ends_date__c<sbp[0].Project_del__r.Starts_date__c){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, subprj.Name + ' should not end before ' + sbp[0].Project_del__r.Name+ ' startdate'));
            return null;
        }
        else if (Subproject__c.sObjectType.getDescribe().isCreateable()){            
            insert subprj;           
            }                     
         }        
        else if (Subproject__c.sObjectType.getDescribe().isCreateable()){            
            insert subprj;           
            }               
        Pagereference PR;
        if(subPrjId<>null){ 
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/SubProject?id='+EncodingUtil.urlEncode(subPrjId,'UTF-8')+'&tab='+EncodingUtil.urlEncode('Projtab','UTF-8');
            pr=new Pagereference (pageRef);
            
        }
        else if(planId<>null){           
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/ProjectDetails?id='+EncodingUtil.urlEncode(planId,'UTF-8')+'&tab='+EncodingUtil.urlEncode('Projtab','UTF-8');
            pr=new Pagereference (pageRef);
            
        }                    
        return pr;
    }
    
    public PageReference cancel(){//redirect to related parent page
        Pagereference PR;
        if(subPrjId<>null){  
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/SubProject?id='+EncodingUtil.urlEncode(subPrjId,'UTF-8')+'&tab='+EncodingUtil.urlEncode('Projtab','UTF-8');
            pr=new Pagereference (pageRef);
            
        }
        else if(planId<>null){           
            String tabId = System.currentPageReference().getParameters().get('tabId');
            string pageRef='/apex/ProjectDetails?id='+EncodingUtil.urlEncode(planId,'UTF-8')+'&tab='+EncodingUtil.urlEncode('Projtab','UTF-8');
            pr=new Pagereference (pageRef);
            
        }                
        return pr;
    }
    public PageReference getCustomSettRec(){
        if(subprj.Project_type__c != null){
            Project_type__c  proType = [SELECT Id,Fieldset__c FROM Project_type__c  WHERE Id =:subprj.Project_type__c  ];
            if(proType.Fieldset__c<>null){
                if(!String.isBlank(proType.Fieldset__c)){
                    fieldSetName = 'musqot__' + proType.Fieldset__c;
                }
                else{
                   fieldSetName = ''; 
                }                
           } 
           else{
               fieldSetName = ''; 
            }
       }
        return null;
    }    
}