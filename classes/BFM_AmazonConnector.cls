global with sharing class BFM_AmazonConnector {
    public string formattedDateString;
    public string bucketname;
    public String host;
    public static boolean pdffl;
    public static String bucketname;
    public static String host;
    public static boolean podpresign;
    public static boolean presign;
    public static String communityURL {get;set;}
    public String attachmentBody;
    
    public string sendFile(attachment attach,string cnpj,string filename,string objname){
        
        BFM_Mulesoft_Endpoint__mdt customSettingEndpoint = [SELECT BFM_Host_Amazon__c,BFM_AmazonBucketName__c,BFM_Amzon_Key__c,BFM_Amazon_Secret__c 
                                                            FROM BFM_Mulesoft_Endpoint__mdt 
                                                            WHERE QualifiedAPIName = 'BFM_Amazon_S3' LIMIT 1];
        
        bucketname = customSettingEndpoint.BFM_AmazonBucketName__c;
        String host = customSettingEndpoint.BFM_Host_Amazon__c;
        
        String key = customSettingEndpoint.BFM_Amzon_Key__c;
        String secret = customSettingEndpoint.BFM_Amazon_Secret__c;
               
        attachmentBody = EncodingUtil.base64Encode(attach.Body);
        formattedDateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');

        String method = 'PUT';
        filename = attach.Name;   
        Integer currentYear = System.Today().year();  
        system.debug('File name is'+filename);
        string endpoint1='';
        string https = 'https://';
        
        if(objname=='DebitNote') {
            endpoint1 = https + bucketname + '.' + host + '/' + currentYear+'/'+'DebitNote'+'/'+filename;
        }
        if(objname=='PODReceipt') {
            endpoint1 = https + bucketname + '.' + host + '/' + currentYear+'/'+'PodReceipt'+'/'+filename;
        }
        if(objname=='gnre') {
            endpoint1 = https + bucketname + '.' + host + '/' + currentYear+'/'+'GNRE'+'/'+cnpj+'/'+filename;
        }

        Url endpoint = new Url(endpoint1);
        
        Map<String,String> headers = new Map<String,String>();
        presign=null;
        system.debug('BFM_AmazonConnector sendFile method'+method);
        system.debug('BFM_AmazonConnector sendFile endpoint'+endpoint);
        system.debug('BFM_AmazonConnector sendFile headers'+headers);
        system.debug('BFM_AmazonConnector sendFile attach.body'+attach.body);
        system.debug('BFM_AmazonConnector sendFile presign'+presign);
        HttpRequest request = new HttpRequest();
        BFM_FileConnector fileConnector = new BFM_FileConnector(key,secret);       
        
        system.debug('BFM_AmazonConnector sendFile fileConnector' + fileConnector);
        
        request = fileConnector.signedRequest(method,endpoint,headers,attach.body,presign);
        
        system.debug('BFM_AmazonConnector sendFile request' + request);
        
        Http http = new Http();
        try {
            HTTPResponse response = http.send(request);
            System.debug('BFM_AmazonConnector sendFile response' + String.ValueOF(response.getBody()));
            
            system.debug('BFM_AmazonConnector sendFile request.getStatusCode()' + response.getStatusCode());
            
            if(response.getStatusCode() == 200 || response.getStatus()=='OK'){
                return endpoint1;
            } else {
                return '';
            }
        } catch(Exception ex) {
            System.debug(ex.getStackTraceString());
            return '';
        }
    }
    
    
    webservice static String getFile(string amazonlink){
        
        //String formattedDateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
        
       BFM_Mulesoft_Endpoint__mdt customSettingEndpoint = [SELECT BFM_Host_Amazon__c,BFM_AmazonBucketName__c,BFM_Amzon_Key__c,BFM_Amazon_Secret__c 
                                                                FROM BFM_Mulesoft_Endpoint__mdt 
                                                                    WHERE QualifiedAPIName = 'BFM_Amazon_S3' LIMIT 1];
      
        bucketname = customSettingEndpoint.BFM_AmazonBucketName__c;
        host = customSettingEndpoint.BFM_Host_Amazon__c;
        
        String key = customSettingEndpoint.BFM_Amzon_Key__c;
        String secret = customSettingEndpoint.BFM_Amazon_Secret__c;

        String method = 'GET';          
        string endpoint1=amazonlink;
        Url endpoint = new Url(endpoint1);
        Blob b = blob.valueof('');
        Map<String,String> headers = new Map<String,String>();
        //boolean presign;
        
        HttpRequest req = new HttpRequest();
        BFM_FileConnector c = new BFM_FileConnector(key,secret);        
        req = c.signedRequest(method,endpoint,headers,b,presign);
        
        Http http = new Http();
        try{
            HTTPResponse res = http.send(req);
            if(res.getStatusCode()==200 || res.getStatus()=='OK'){
               return res.getBody();
             //   Blob contentData = res.getBodyAsBlob();
               // return 'data:application/pdf;base64,' + EncodingUtil.base64Encode(contentData);  
            }
            else{
                return '';
            }
        } catch(Exception ex){
            System.debug(ex.getStackTraceString());
           return '';
        }
    }
    
    webservice static Blob getBlobFile(string amazonlink){
        
        //String formattedDateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
        
        
         BFM_Mulesoft_Endpoint__mdt customSettingEndpoint = [SELECT BFM_Host_Amazon__c,BFM_AmazonBucketName__c,BFM_Amzon_Key__c,BFM_Amazon_Secret__c 
                                                                FROM BFM_Mulesoft_Endpoint__mdt 
                                                                    WHERE QualifiedAPIName = 'BFM_Amazon_S3' LIMIT 1];
      
        bucketname = customSettingEndpoint.BFM_AmazonBucketName__c;
        host = customSettingEndpoint.BFM_Host_Amazon__c;
        
        String key = customSettingEndpoint.BFM_Amzon_Key__c;
        String secret = customSettingEndpoint.BFM_Amazon_Secret__c;

        
       String aURL = 'https://' + bucketname + '.' + host+'/'; 
        
        String method = 'GET';          
        string endpoint1=aURL+amazonlink;
        Url endpoint = new Url(endpoint1);
        Blob b = blob.valueof('');
        Map<String,String> headers = new Map<String,String>();
        //boolean presign;
        
        HttpRequest req = new HttpRequest();
        BFM_FileConnector c = new BFM_FileConnector(key,secret);        
        req = c.signedRequest(method,endpoint,headers,b,presign);
        
        Http http = new Http();
        try{
            HTTPResponse res = http.send(req);
            if(res.getStatusCode()==200 || res.getStatus()=='OK'){
               return res.getBodyAsBlob();
                //Blob contentData = res.getBodyAsBlob();
               // return 'data:application/pdf;base64,' + EncodingUtil.base64Encode(contentData);  
            }
            else{
                return Blob.valueof('');
            }
        } catch(Exception ex){
            System.debug(ex.getStackTraceString());
            
           return Blob.valueof('');
        }
    }
    
    webservice static String getPDFFile(string amazonlink,String pId,String pdffileName){
        
        //String formattedDateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
        
       BFM_Mulesoft_Endpoint__mdt customSettingEndpoint = [SELECT BFM_Host_Amazon__c,BFM_AmazonBucketName__c,BFM_Amzon_Key__c,BFM_Amazon_Secret__c 
                                                                FROM BFM_Mulesoft_Endpoint__mdt 
                                                                    WHERE QualifiedAPIName = 'BFM_Amazon_S3' LIMIT 1];
      
        bucketname = customSettingEndpoint.BFM_AmazonBucketName__c;
        host = customSettingEndpoint.BFM_Host_Amazon__c;
        
        String key = customSettingEndpoint.BFM_Amzon_Key__c;
        String secret = customSettingEndpoint.BFM_Amazon_Secret__c;

        
        String method = 'GET';          
        string endpoint1=amazonlink;
        Url endpoint = new Url(endpoint1);
        Blob b = blob.valueof('');
        Map<String,String> headers = new Map<String,String>();
        
        HttpRequest req = new HttpRequest();
        BFM_FileConnector c = new BFM_FileConnector(key,secret);        
        req = c.signedRequest(method,endpoint,headers,b,pdffl);
        
        Http http = new Http();
        try{
           /* HTTPResponse res = http.send(req);
            if(res.getStatusCode()==200 || res.getStatus()=='OK'){
             //  return res.getBody();
                Blob contentData = res.getBodyAsBlob();
                return 'data:application/pdf;base64,' + EncodingUtil.base64Encode(contentData);  */
            
              HTTPResponse res = http.send(req);
            if(res.getStatusCode()==200 || res.getStatus()=='OK'){
              //return res.getBody();
              // Blob contentData = res.getBodyAsBlob();
               //return 'data:application/pdf;base64,' + EncodingUtil.base64Encode(contentData);
                Attachment attach = new Attachment(); //Make an attachment
                attach.Name =pdffileName;  
                attach.Body = res.getBodyAsBlob();
                attach.ContentType= 'application/octet-stream'; //Signal what the file's MIME type is
                attach.ParentID = pID;
                insert attach;
                if(String.ValueOf(URL.getCurrentRequestUrl()).contains('BrazilFreightCollaborationTool')){
                    communityURL= '/BrazilFreightCollaborationTool';               
                }
                else{
                    communityURL='';
                } 
                
             String fullURL;
            String imageURL ='/servlet/servlet.FileDownload?file=';
   
            fullURL = communityURL +  imageURL + attach.Id;    
             return  fullURL; 
            
            
            
            }
            else{
                return '';
            }
        } catch(Exception ex){
            System.debug(ex.getStackTraceString());
           return '';
        }
    } 
    
  
    webservice static String getPODFile(string amazonlink,String pId,String fileName){
    system.debug('------------amazonlink----------------------'+amazonlink);
        
        //String formattedDateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
        
        BFM_Mulesoft_Endpoint__mdt customSettingEndpoint = [SELECT BFM_Host_Amazon__c,BFM_AmazonBucketName__c,BFM_Amzon_Key__c,BFM_Amazon_Secret__c 
                                                            FROM BFM_Mulesoft_Endpoint__mdt 
                                                            WHERE QualifiedAPIName = 'BFM_Amazon_S3' LIMIT 1];
        
        bucketname = customSettingEndpoint.BFM_AmazonBucketName__c;
        host = customSettingEndpoint.BFM_Host_Amazon__c;
        
        String key = customSettingEndpoint.BFM_Amzon_Key__c;
        String secret = customSettingEndpoint.BFM_Amazon_Secret__c;
        
        String aURL = 'https://' + bucketname + '.' + host+'/'; 
        
        
        
        String method = 'GET';   
        
        string endpoint1=amazonlink;
        String finalURL = aURL+endpoint1;
        String encodedString = finalURL.replace(' ', '+');
        
        Url endpoint = new Url(encodedString);
        Blob b = blob.valueof('');
        Map<String,String> headers = new Map<String,String>();        
        
        HttpRequest req = new HttpRequest();
        BFM_FileConnector c = new BFM_FileConnector(key,secret);        
        req = c.signedRequest(method,endpoint,headers,b,podpresign);
        
        system.debug(req.toString());
        
        Http http = new Http();
        try{
            HTTPResponse res = http.send(req);
            if(res.getStatusCode()==200 || res.getStatus()=='OK'){
              //return res.getBody();
              // Blob contentData = res.getBodyAsBlob();
               //return 'data:application/pdf;base64,' + EncodingUtil.base64Encode(contentData);
               Attachment attach = new Attachment(); //Make an attachment
                attach.Name =fileName;  
                attach.Body = res.getBodyAsBlob();
                attach.ContentType= 'application/octet-stream'; //Signal what the file's MIME type is
                attach.ParentID = pID;
                insert attach;
                system.debug('URL.getCurrentRequestUrl()'+URL.getCurrentRequestUrl());
            if(String.ValueOf(URL.getCurrentRequestUrl()).contains('BrazilFreightCollaborationTool')){
                communityURL= '/BrazilFreightCollaborationTool';               
            }
            else{
                communityURL='';
            }    
            String fullURL;
            String imageURL =communityURL+'/servlet/servlet.FileDownload?file=';
   
            fullURL = URL.getSalesforceBaseUrl().toExternalForm() +  imageURL + attach.Id;    
             return  fullURL; 
                
                //return String.valueOf(req.getEndpoint()); 
            }
            else{
                return '';
            }
        } catch(Exception ex){
            System.debug(ex.getStackTraceString());
           return '';
        }
    } 
    
    
    webservice static String getNFSFile(string amazonlink,String pId,String fileName){
    system.debug('------------amazonlink----------------------'+amazonlink);
        
        //String formattedDateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
        
        BFM_Mulesoft_Endpoint__mdt customSettingEndpoint = [SELECT BFM_Host_Amazon__c,BFM_AmazonBucketName__c,BFM_Amzon_Key__c,BFM_Amazon_Secret__c 
                                                            FROM BFM_Mulesoft_Endpoint__mdt 
                                                            WHERE QualifiedAPIName = 'BFM_Amazon_S3' LIMIT 1];
        
        bucketname = customSettingEndpoint.BFM_AmazonBucketName__c;
        host = customSettingEndpoint.BFM_Host_Amazon__c;
        
        String key = customSettingEndpoint.BFM_Amzon_Key__c;
        String secret = customSettingEndpoint.BFM_Amazon_Secret__c;
        
        String aURL = 'https://' + bucketname + '.' + host+'/'; 
        
        
        
        String method = 'GET';   
        
        string endpoint1=amazonlink;
        String finalURL = aURL+endpoint1;
        String encodedString = finalURL.replace(' ', '+');
        
        Url endpoint = new Url(encodedString);
        Blob b = blob.valueof('');
        Map<String,String> headers = new Map<String,String>();        
        
        HttpRequest req = new HttpRequest();
        BFM_FileConnector c = new BFM_FileConnector(key,secret);        
        req = c.signedRequest(method,endpoint,headers,b,podpresign);
        
        Http http = new Http();
        try{
            HTTPResponse res = http.send(req);
            if(res.getStatusCode()==200 || res.getStatus()=='OK'){
                String attid = insertAttachment(res.getBodyAsBlob(),pId,fileName);
                system.debug('URL.getCurrentRequestUrl()'+URL.getCurrentRequestUrl());
             return  attid; 
                
                //return String.valueOf(req.getEndpoint()); 
            }
            else{
                return '';
            }
        } catch(Exception ex){
            System.debug(ex.getStackTraceString());
           return '';
        }
    } 
    
    
    public static String insertAttachment(Blob res,String pID,String fileName)
    {
        
        Attachment attach = new Attachment(); //Make an attachment
        attach.Name =fileName;  
        attach.Body = res;
        attach.ContentType= 'application/octet-stream'; //Signal what the file's MIME type is
        attach.ParentID = pID;
        insert attach;
        return attach.id;
    }
    
    
    @future
    webservice static void deleteAttachment(String attId){
        
        Attachment delAttach = new Attachment(id=attId);
        delete delAttach;
        
    }
}