/************************************************************
Class Name: AttachmenEditController
Author:G Janardhanreddy      Last modified by:G Janardhanreddy
Date:  13/1/2015             Date:18/03/2015
********©2013 Musqot marketing technology Pvt ltd ***********/
public with sharing class AttachmenEditController{
    public String planid{get;set;}
    public String markId{get;set;}
    public String subpid{get;set;}
    public String attid{get;set;}
    public String atmid{get;set;}  
    Public Attachment att{get;set;}
    public string taskid{get;set;}
    public boolean showRec{get;set;}
    public boolean showEdt{get;set;}
    public Transient list<Attachment> atts{get;set;}
    public Decimal fileSize {get;set;}
    public String fileSize2 {get;set;}
    public String fileType {get;set;}
    public WrapperClass wrCls{get;set;}
    public AttachmenEditController(ApexPages.StandardController controller){
        taskid= ApexPages.currentPage().getParameters().get('taskid');
        planid= ApexPages.currentPage().getParameters().get('planid');
        subpid= ApexPages.currentPage().getParameters().get('subpid');
        markId= ApexPages.currentPage().getParameters().get('markId');
        atmid= ApexPages.currentPage().getParameters().get('attsid');
        try{
            att = [Select id,Name, Description,contentType FROM Attachment WHERE id=:atmid and Parent.id =:taskid limit 1];
            FileSizeFunc();
        }
        catch(exception e){} 
    } 
    /*******************************************************
	FileSizeFunc():convert attachment BodyLength to GB,MB,kB
	*********************************************************/
    public void FileSizeFunc(){
        Decimal tempfilesize;
        atts = [Select id,Name, Description, Body,BodyLength, OwnerID, CreatedByID, IsPrivate,contentType FROM Attachment WHERE id=:atmid and Parent.id =:taskid  limit 1];
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
            if(atts[0].contentType == 'application/msword'){fileType = '.doc';} 
            else if(atts[0].contentType == 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'){fileType = '.docx';}  
            else if(atts[0].contentType == 'text/calendar'){fileType = '.ics';} 
            else if(atts[0].contentType == 'application/x-indesign'){fileType = '.indd';} 
            else if(atts[0].contentType == 'application/vnd.oasis.opendocument.database'){fileType = '.odb';} 
            else if(atts[0].contentType == 'application/vnd.oasis.opendocument.chart'){fileType = '.odc';} 
            else if(atts[0].contentType == 'application/vnd.oasis.opendocument.formula'){fileType = '.odf';} 
            else if(atts[0].contentType == 'application/vnd.oasis.opendocument.graphics'){fileType = '.odg';} 
            else if(atts[0].contentType == 'application/vnd.oasis.opendocument.image'){fileType = '.odi';} 
            else if(atts[0].contentType == 'application/vnd.oasis.opendocument.presentation'){fileType = '.odp';} 
            else if(atts[0].contentType == 'application/vnd.oasis.opendocument.spreadsheet'){fileType = '.ods';}        
            else if(atts[0].contentType == 'application/vnd.oasis.opendocument.text'){fileType = '.odt';} 
            else if(atts[0].contentType == 'application/pdf'){fileType = 'PDF';} 
            else if(atts[0].contentType == 'application/vnd.openxmlformats-officedocument.presentationml.slideshow'){fileType = '.ppsx';} 
            else if(atts[0].contentType == 'application/vnd.ms-powerpoint'){fileType = '.ppt';}     
            else if(atts[0].contentType == 'application/vnd.openxmlformats-officedocument.presentationml.presentation'){fileType = '.pptx';} 
            else if(atts[0].contentType == 'application/x-mspublisher'){fileType = '.pub';}        
            else if(atts[0].contentType.startsWith('application/vnd.quark')){fileType = '.qxp';} 
            else if(atts[0].contentType == 'application/x-rar-compressed'){fileType = '.rar';} 
            else if(atts[0].contentType == 'application/vnd.stardivision.draw'){fileType = '.sda';} 
            else if(atts[0].contentType == 'application/vnd.stardivision.calc'){fileType = '.sdc';}  
            else if(atts[0].contentType == 'application/vnd.stardivision.impress'){fileType = '.sdd';} 
            else if(atts[0].contentType == 'application/vnd.stardivision.writer'){fileType = '.sdw';}        
            else if(atts[0].contentType == 'application/x-stuffit'){fileType = '.sit';} 
            else if(atts[0].contentType == 'application/vnd.openxmlformats-officedocument.presentationml.slide'){fileType = '.sldx';} 
            else if(atts[0].contentType == 'application/vnd.stardivision.math'){fileType = '.smf';} 
            else if(atts[0].contentType == 'application/x-shockwave-flash'){fileType = '.swf';}  
            else if(atts[0].contentType == 'application/vnd.sun.xml.calc'){fileType = '.sxc';} 
            else if(atts[0].contentType == 'application/vnd.sun.xml.draw'){fileType = '.sxd';} 
            else if(atts[0].contentType == 'application/vnd.sun.xml.impress'){fileType = '.sxi';} 
            else if(atts[0].contentType == 'application/vnd.sun.xml.math'){fileType = '.sxm';} 
            else if(atts[0].contentType == 'application/vnd.sun.xml.writer'){fileType = '.sxw';} 
            else if(atts[0].contentType == 'text/plain'){fileType = 'Text';} 
            else if(atts[0].contentType == 'application/vnd.ms-wpl'){fileType = '.wpl';} 
            else if(atts[0].contentType == 'application/vnd.ms-works'){fileType = '.wps';} 
            else if(atts[0].contentType == 'application/x-mswrite'){fileType = '.wri';} 
            else if(atts[0].contentType == 'application/vnd.ms-excel'){fileType = '.xls';} 
            else if(atts[0].contentType == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'){fileType = '.xlsx';} 
            else if(atts[0].contentType == 'application/vnd.ms-xpsdocument'){fileType = '.xps';}
            else if(atts[0].contentType == 'application/zip'){fileType = '.zip';}
            else if(atts[0].contentType.startsWith('audio/')){fileType = 'Audio';}
            else if(atts[0].contentType.startsWith('image/')){fileType = 'Image';}
            else if(atts[0].contentType.startsWith('video/')){fileType = 'Video';}
            else {fileType = 'Other';}
        }
    }
    /*************************************************************************
	save():update the attachment  records and redirect to  related parent page
	**************************************************************************/
    public Pagereference save(){ 
        if (Attachment.sObjectType.getDescribe().isUpdateable())
        {
            update att;
        }
        Pagereference pg;
        if(planid<>null){
            pg=new Pagereference('/apex/TaskEditpage?planid='+EncodingUtil.urlEncode(planid,'UTF-8')+'&taskId='+EncodingUtil.urlEncode(taskid,'UTF-8'));
        } 
        else if(subpid<>null){
            pg=new Pagereference('/apex/TaskEditpage?subpid='+EncodingUtil.urlEncode(subpid,'UTF-8')+'&taskId='+EncodingUtil.urlEncode(taskid,'UTF-8'));
        }
        else if(markId<>null){
            pg=new Pagereference('/apex/TaskEditpage?markId='+EncodingUtil.urlEncode(markId,'UTF-8')+'&taskId='+EncodingUtil.urlEncode(taskid,'UTF-8'));   
        }
        return pg;
    }  
   /*****************************************
	Cancel() redirect to  related parent page
	*****************************************/
    public Pagereference Cancel(){
        Pagereference pg;
        if(planid<>null){
            pg=new Pagereference('/apex/TaskEditpage?planid='+EncodingUtil.urlEncode(planid,'UTF-8')+'&taskId='+EncodingUtil.urlEncode(taskid,'UTF-8'));
        }
        else if(subpid<>null){
            pg=new Pagereference('/apex/TaskEditpage?subpid='+EncodingUtil.urlEncode(subpid,'UTF-8')+'&taskId='+EncodingUtil.urlEncode(taskid,'UTF-8'));
        }
        else if(markId<>null){
            pg=new Pagereference('/apex/TaskEditpage?markId='+EncodingUtil.urlEncode(markId,'UTF-8')+'&taskId='+EncodingUtil.urlEncode(taskid,'UTF-8'));
        }
        return pg;
    } 
    public class WrapperClass{
        public Id Id {get;set;}
        public string Description {get;set;}
        public string Name {get;set;}
        public String Size {get;set;}
        public String contentType {get;set;}
    }
    
}