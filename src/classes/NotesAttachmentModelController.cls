/****************************************************************
Class Name: NotesAttachmentModelController
Author:G Janardhanreddy      Last modified by:chaithanya daggumati
Date:19/6/2014               Date: 18/2/2015
********©2013 Musqot marketing technology Pvt ltd ****************/
public with sharing class NotesAttachmentModelController {
    public  ApexPages.standardController sc;
    public List<NoteAndAttachMent> modelList{get;set;}
    public Integer srNo{get;set;}
    public ID accid,parentid;
    public NotesAttachmentModelController(ApexPages.StandardController sc){
        this.sc = sc;
        accid = sc.getRecord().id;
        workspace__c Act;
        try{
            Act = [select id,(select Title,lastmodifieddate,createdbyId From NotesAndAttachments) From workspace__c where id =:'a0Nb0000008INwz'];
            ModelList = Act.NotesAndAttachments;
        }catch (exception e){}
        srNo=0;
    }
}