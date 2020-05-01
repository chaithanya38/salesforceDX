/******************************************************************
Class Name: ProjectTypeClass 
Author: chaithanya daggumati       Last modified by: Janardhan reddy
Date : 6/7/2014                    Date : 20/03/2015                    
********©2013 Musqot marketing technology Pvt ltd ******************/

public with sharing class ProjectTypeClass {
    Public List<Project_type__c> projectType{get;set;}
    public ProjectTypeClass(ApexPages.StandardController controller) {
        projectType=[SELECT id,Name,Color__c, Plantype__c 
                     from Project_type__c order by Name LIMIT 250];
    }
    /********************************************
	NewPrtype(): redirect to  NewProjectType page
	*********************************************/
    public PageReference NewPrtype()
    {
        PageReference pg=new PageReference ('/apex/NewProjectType');
        pg.setredirect(true); 
        return pg;
    } 
    
    public PageReference NewPrtyp()
    {
        PageReference pg=new PageReference ('https://eu2.salesforce.com?id='+EncodingUtil.urlEncode(projectType[0].id,'UTF-8'));
        pg.setredirect(true); 
        return pg;
    } 
    
}