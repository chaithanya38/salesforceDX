/*******************************************************
Class Name:CmphoursApprovalURL
Author:Chaithanya daggumati     Last modified by:Chaithanya daggumati
Date:09/04/2015                 Date:09/04/2015
********©2013 Musqot marketing technology Pvt ltd *******/
public with sharing class CmphoursApprovalURL{  
    public String arsId{get; set;}  
    public String urlStr{  
        get{  
            return CreatehoursApprovalURL.generateApprovalURL(arsId);  
        }
    }  
}