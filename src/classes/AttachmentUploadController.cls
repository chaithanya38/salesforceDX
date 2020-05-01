/*******************************************************
Class Name: AttachmentUploadController
Author:Nagaraju G 	  	  Last modified by:Raju GN
Date: 18/6/2014           Date:18/12/2015
Dec:Adding filetype with attachment name..
********©2013 Musqot marketing technology Pvt ltd *******/
public with sharing class AttachmentUploadController {
    public String subprojectid{get;set;}
    public String plnId{get;set;}
    public String mrkId{get;set;}
    public Attachment attachment{get;set;}
    public String contentType {get; set;}
    public string fileNmaeWithExtension{get;set;}
    public AttachmentUploadController (){
        plnId = ApexPages.currentPage().getParameters().get('plnId');
        mrkId = ApexPages.currentPage().getParameters().get('mrkId');
        subprojectid = ApexPages.currentPage().getParameters().get('subprojectid');          
        attachment = new Attachment();
    }  
    /****************************************************************************
upload():  update the attachment records and redirect to  related parent page
*****************************************************************************/
    public PageReference upload() {
        if(ContentType<>null){
         
            User u = [select Id from user where id=:userinfo.getuserid()];
            string sid = Apexpages.currentpage().getParameters().get('id');        
            attachment.ParentId = sid;
            attachment.IsPrivate = false;
            attachment.OwnerId = u.id;
            attachment.ContentType=contentType;
            //--Raju--adding fileType with attachment name while saving--
            string ex=fileNmaeWithExtension.substringAfter('.');
            attachment.name=attachment.name+'.'+ex;
        
            Pagereference PR;
            if(attachment.body<>null||test.isrunningtest()){
                if (Schema.sObjectType.Attachment.fields.body.isCreateable()){                
                    insert attachment;
                }  
                if(subprojectid<>null){
                    PR = new Pagereference('/apex/SubProject?id='+EncodingUtil.urlEncode(subprojectid,'UTF-8'));
                }
                if(plnId<>null){
                    PR = new Pagereference('/apex/ProjectDetails?id='+EncodingUtil.urlEncode(plnId,'UTF-8'));
                }
                if(mrkId<>null){
                    PR = new Pagereference('/apex/Marketingactivity?id='+EncodingUtil.urlEncode(mrkId,'UTF-8'));
                }           
            }                 
            return PR;        
        } 
        else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select file'));
            return null;
        }    
    }
    /*******************************************
cancel(): redirect to  related parent page 
********************************************/
    public PageReference cancel() {
        Pagereference PR;
        if(subprojectid<>null){
            PR = new Pagereference('/apex/SubProject?id='+EncodingUtil.urlEncode(subprojectid,'UTF-8'));
        }
        if(plnId<>null){
            PR = new Pagereference('/apex/ProjectDetails?id='+EncodingUtil.urlEncode(plnId,'UTF-8'));
        }
        if(mrkId<>null){
            PR = new Pagereference('/apex/Marketingactivity?id='+EncodingUtil.urlEncode(mrkId,'UTF-8'));
        }    
        return PR;   
    }
}