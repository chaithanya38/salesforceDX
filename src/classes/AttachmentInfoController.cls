/**************************************************************
Class Name: AttachmentInfoController
Author:Håkan Sjöberg            Last modified by:Raju GN
Date: 14/09/2014                Date:18/03/2015
********©2013 Musqot marketing technology Pvt ltd **************/
public with sharing class AttachmentInfoController{
    private String projectid;
    private String mrkId ;
    private String subprjid;
    public String attid;
    public String atmid;  
    public Attachment att{get;set;}    
    public boolean showRec{get;set;}
    public boolean showEdt{get;set;}
    public boolean showPreveiw{get;set;}
    public Transient List<Attachment>atts{get;set;}
    public Transient Decimal fileSize{get;set;}
    public Transient String fileSize2{get;set;}
    public String fileType {get;set;}
    private WrapperClass wrCls;
    public string contenttype{get;set;}
    public string parentId{ get; set; }
    public string fileNmaeWithExtension{get;set;}
    public string attachmentName{get;set;}
    public blob attBody{ get; set; }
    public string attContentType{ get; set; }    
    public string attOwnerID{ get; set; }
    public AttachmentInfoController(ApexPages.StandardController controller){
        projectid = ApexPages.currentPage().getParameters().get('planid');
        subprjid = ApexPages.currentPage().getParameters().get('subid');
        mrkId = ApexPages.currentPage().getParameters().get('mrkid');
        atmid= ApexPages.currentPage().getParameters().get('attid');
        att = new Attachment();
        try{
            FileSizeFunc();
        }catch(exception e){}
        showRec=true;
        showEdt=false;
        //showPreveiw= false;
        
    } 
    /*******************************************************
FileSizeFunc():convert attachment BodyLength to GB,MB,kB
********************************************************/
    public string ex;  
    public void FileSizeFunc(){
        Decimal tempfilesize;
        //if(atts.size() > 0) {
        atts = [Select id,Name, Description, Body,BodyLength, 
                OwnerID, CreatedByID, IsPrivate,contentType, 
                ParentId FROM Attachment 
                WHERE id =:atmid limit 1];
        parentId=atts[0].ParentId;
        attBody=atts[0].Body;
        attContentType=atts[0].contentType;       
        attOwnerID=atts[0].OwnerID;
        attachmentName=atts[0].Name.substringBefore('.');
        att.Description = atts[0].Description;        
        ex=atts[0].Name.substringAfter('.');
        if(atts[0].contentType == 'application/pdf' || atts[0].contentType == 'image/jpeg' || 
           atts[0].contentType == 'image/png' || atts[0].contentType == 'image/gif' || 
           atts[0].contentType == 'video/mp4' ){
               showPreveiw= true;
           }
        //}
        if(atts.size() > 0){
            tempfilesize = atts[0].BodyLength;
            if(atts[0].BodyLength > (1024*1024*524)){
                tempfilesize  = Decimal.valueOf(atts[0].BodyLength);
                fileSize=tempfilesize.divide(1024*1024*1024,1);
                fileSize2=' GB';
            }
            else if(atts[0].BodyLength > (1024*524)){
                tempfilesize  = Decimal.valueOf(atts[0].BodyLength);
                fileSize=tempfilesize.divide(1024*1024,1);
                fileSize2=' MB';
            }
            else if(atts[0].BodyLength > 1024){
                tempfilesize = Decimal.valueOf(atts[0].BodyLength);
                fileSize=tempfilesize.divide(1024,1);
                fileSize2=' KB';             
            }
            else {
                tempfilesize = Decimal.valueOf(atts[0].BodyLength);
                fileSize=tempfilesize.divide(1,0);
                fileSize2=' B';             
            }
            
            fileType='.'+ex;
        }
    }
    /****************************************************************************
savedoc():update the attachment  records and redirect to  related parent page 
*****************************************************************************/
    public Pagereference savedoc(){         
        if(ContentType<>null){                   
            User u = [select Id from user where id=:userinfo.getuserid()];  
            att.ParentId =parentId;   
            att.OwnerId = u.id;
            att.ContentType=contentType;
            string ex=fileNmaeWithExtension.substringAfter('.');
            att.name=attachmentName+'.'+ex;
            Pagereference pg; 
            if(att.body<>null){
                string delAttchId= Apexpages.currentpage().getParameters().get('attid');     
        		delete([select Id from Attachment where id=:delAttchId]);                
                if(Schema.sObjectType.Attachment.fields.body.isCreateable()){                   
                    insert att;
                    att.body=null;
                }  
            }
            if(projectid<>null){
                pg=new Pagereference('/apex/ProjectDetails?id='+EncodingUtil.urlEncode(projectid,'UTF-8'));
            }
            if(subprjid<>null){
                Pg = new Pagereference('/apex/SubProject?id='+EncodingUtil.urlEncode(subprjid,'UTF-8'));
            }
            if(mrkId<>null){
                Pg = new Pagereference('/apex/Marketingactivity?id='+EncodingUtil.urlEncode(mrkId,'UTF-8'));
            }            
            return pg;
        }
        else{
            Pagereference pg; 
            string ex=fileNmaeWithExtension.substringAfter('.');
            att.name=attachmentName+'.'+ex;		              
            att.ParentId =parentId;   
            att.Body=attBody;
        	att.ContentType=attContentType;        	
        	att.OwnerID=attOwnerID;
            att.Id = atmid;
            update att;  
            att.body=null;              
            if(projectid<>null){
                pg=new Pagereference('/apex/ProjectDetails?id='+EncodingUtil.urlEncode(projectid,'UTF-8'));
            }
            if(subprjid<>null){
                Pg = new Pagereference('/apex/SubProject?id='+EncodingUtil.urlEncode(subprjid,'UTF-8'));
            }
            if(mrkId<>null){
                Pg = new Pagereference('/apex/Marketingactivity?id='+EncodingUtil.urlEncode(mrkId,'UTF-8'));
            }            
            return pg;
        }                 
    }   
    /***************************************************************************
delDoc():delete the attachment  records and redirect to  related parent page
****************************************************************************/
    public Pagereference delDoc(){
        if (Attachment.sObjectType.getDescribe().isDeletable())
        {
            try{
            Attachment at=[select id from Attachment where id=:atmid];
            delete at;
            }catch(exception e){}
        }
        Pagereference pg;
        if(projectid<>null){
            pg=new Pagereference('/apex/ProjectDetails?id='+EncodingUtil.urlEncode(projectid,'UTF-8'));
        }
        else if(subprjid<>null){
            Pg = new Pagereference('/apex/SubProject?id='+EncodingUtil.urlEncode(subprjid,'UTF-8'));
        }
        else if(mrkId<>null){
            Pg = new Pagereference('/apex/Marketingactivity?id='+EncodingUtil.urlEncode(mrkId,'UTF-8'));
        }
        return pg;
    } 
    /***********************************
EditAttachmentPage():show edit mode
************************************/
    public void EditAttachmentPage(){
        //try{
        //att= [Select id,Name, Description FROM Attachment WHERE id =:atmid limit 1];
        //}catch(exception e){}
        showRec=false;
        showEdt=true;
    }
    /*****************************************
Cancel():redirect to  related parent page
*****************************************/
    public Pagereference Cancel(){
        Pagereference pg;
        if(projectid<>null){
            pg=new Pagereference('/apex/ProjectDetails?id='+EncodingUtil.urlEncode(projectid,'UTF-8'));
        }
        else if(subprjid<>null){
            Pg = new Pagereference('/apex/SubProject?id='+EncodingUtil.urlEncode(subprjid,'UTF-8'));
        }
        else if(mrkId<>null){
            Pg = new Pagereference('/apex/Marketingactivity?id='+EncodingUtil.urlEncode(mrkId,'UTF-8'));
        }
        return pg;
    } 
    public void backtoAttinfo(){
        FileSizeFunc();
        showRec=true;
        showEdt=false;   
    } 
    public class WrapperClass{
        public Id Id {get;set;}
        public string Description {get;set;}
        public string Name {get;set;}
        public String Size {get;set;}
        public String contentType {get;set;}
    }
    
}