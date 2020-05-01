/*******************************************************
Class Name: cls_CmpApprovalURL
Author:Hussain Peera     Last modified by:G Janardhanreddy 
Date:20/8/2014           Date:18/03/2015
********©2013 Musqot marketing technology Pvt ltd *******/
public with sharing class cls_CmpApprovalURL{  
    public String amtId{get; set;}  
    public String urlStr{  
        get{  
            return cls_createApprovalURL.generateApprovalURL(amtId);  
        }
    }  
}