/****************************************************************
Class Name: WorktasktypeController 
Author:Nagaraju G               Last modified by: Janardhan reddy
Date: 20/7/2014                 Date: 19/3/2015 
********©2013 Musqot marketing technology Pvt ltd ***************/

public with sharing class WorktasktypeController {
    Public String worktaskid{get;set;}
   // public string planid{get;set;}
    public String worktype {get;set;}
    public List<worktype__c> worktask{get;set;}
    //public List<worktype__c> tobeDeleted{get;set;}
    //public string SelectedWorktaskId { get; set;}
    public WorktasktypeController (){
        worktaskid=ApexPages.currentPage().getParameters().get('id');
        worktask = [Select id, name,bartaskcolor__c from worktype__c  where id=:worktaskid];
        LoadData();
    }
    /********************************
    LoadData(): load worktype records
    *********************************/
    public void LoadData() {
        worktask = [Select id, name,bartaskcolor__c from worktype__c limit 20];
    }
    /***************************************
    DeleteAccount(): delete worktype records
    ****************************************/
    /*public void DeleteAccount(){       
        if (SelectedWorktaskId== null){ 
            return;
        }
        worktype__c tobeDeleted= null;
        for(worktype__c wr : Worktask )
            if (wr.Id == SelectedWorktaskId) {
                tobeDeleted= Wr;
                break;
            }
        /*if (tobeDeleted != null) {
            if (worktype__c.sObjectType.getDescribe().isDeletable())
            {
              Delete tobeDeleted;
            }
        }    
     
       LoadData();
    } */
    /*******************************
    NewWrtype(): create new worktype
    ********************************/
    public PageReference NewWrtype()  {
  
        PageReference pg=new PageReference ('/apex/NewWorktasktype');
        pg.setredirect(true); 
        return pg;
    } 
    /***************************************
     DeleteProject():delete worktype records
     ***************************************/
    public PageReference DeleteProject(){
        LoadData();
        worktype__c work = [Select id, name,bartaskcolor__c from worktype__c  where id=:worktaskid];
        if (worktype__c.sObjectType.getDescribe().isDeletable())
        {
            delete work ;
        }
        pagereference ref =new pagereference('/apex/Worktasktype');
        ref.setredirect(true);
        return ref;
        //refresh the data
    }
    /*************************************************
    redirectPage1():  redirect to WorktasktypeeditPage
    **************************************************/
    public PageReference redirectPage1() {
        PageReference pgr=new PageReference ('/apex/WorktasktypeeditPage?id='+EncodingUtil.urlEncode(Worktaskid,'UTF-8'));
        return pgr;
    }    
}