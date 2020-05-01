/***********************************************************
Trigger Name: Trigger_Task_Email
Author:Raju GN          Last modified by:Raju 
Date: 14/7/2014             Date:1/10/2015
Description:Changed task email template (adding two new values on template & change the sequence of labels in template)
********©2013 Musqot marketing technology Pvt ltd ***********/
trigger Trigger_Task_Email on Task (after insert){
    Set<Id> ownerIds = new Set<Id>();
    Set<Id> creteIds = new Set<Id>();
    Set<Id> parentIds = new Set<Id>();
    string sObjName1;
    List<Messaging.SingleEmailMessage> mails=  new List<Messaging.SingleEmailMessage>();
    for(Task tsk: Trigger.New){
        ownerIds.add(tsk.ownerId);
        creteIds.add(tsk.CreatedById);
        parentIds.add(tsk.whatId);
        if(tsk.WhatId!= null)
        sObjName1 = tsk.WhatId.getSObjectType().getDescribe().getName();
    }
    Map<Id, User> userMap = new Map<Id,User>([select Name, Email from User where Id in :ownerIds]);
    Map<Id, User> creuserMap = new Map<Id,User>([select Name from User where Id in:creteIds]);
    Map<Id, musqot__Project__c> palntRec = new Map<Id, musqot__Project__c>();
    Map<Id, musqot__Subproject__c> subRec = new Map<Id, musqot__Subproject__c>();
    Map<Id, musqot__Marketing_activity__c>mrkRec = new Map<Id, musqot__Marketing_activity__c>();
    Map<Id,Account>acc= new Map<Id,Account>();
    if(sObjName1=='musqot__Project__c'){
        Map<Id, musqot__Project__c> parentRec1= new Map<Id, musqot__Project__c>([SELECT Name FROM musqot__Project__c WHERE Id IN :parentIds]);
        palntRec.putAll(parentRec1);
             
    }
    else if(sObjName1=='musqot__Subproject__c'){
      Map<Id, musqot__Subproject__c> subparentRec= new Map<Id, musqot__Subproject__c>([SELECT Name FROM musqot__Subproject__c WHERE Id IN :parentIds]);
      subRec.putAll(subparentRec);
    }
    else if(sObjName1=='musqot__Marketing_activity__c'){
       Map<Id, musqot__Marketing_activity__c> mrkName= new Map<Id, musqot__Marketing_activity__c>([SELECT Name FROM musqot__Marketing_activity__c WHERE Id IN :parentIds]);
       mrkRec.putAll(mrkName);
    }
             
    if(sObjName1=='musqot__Project__c' || sObjName1=='musqot__Subproject__c' || sObjName1=='musqot__Marketing_activity__c'){          
        for(Task tsk:Trigger.New){
           if( tsk.musqot__sendEmail__c==true){ 
                User theUser = userMap.get(tsk.ownerId);
                User creUser = creuserMap.get(tsk.CreatedById);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {theUser.Email};
                String[] cUser = new String[] {creUser.Name};
                string userid=userinfo.getuserid();  
                mail.setToAddresses(toAddresses);    
                
                string sObjName;
                if(tsk.WhatId<>null){
                    sObjName = tsk.WhatId.getSObjectType().getDescribe().getName();
                }
                string emailUrl;
                String sUrlRewrite = System.URL.getSalesforceBaseUrl().getHost();
                String temp = 'https://'+sUrlRewrite+'/apex/TaskEditpage?';
                String parentName;
                if(sObjName=='musqot__Project__c'){
                     emailUrl=temp+'planid=';
                     musqot__Project__c parentRec = palntRec.get(tsk.WhatId);
                     parentName=String.valueOf(parentRec.Name);
                }
                else if(sObjName=='musqot__Subproject__c'){
                     emailUrl=temp+'subpid=';
                     musqot__Subproject__c parentRec = subRec.get(tsk.WhatId);
                     parentName=String.valueOf(parentRec.Name);
                }
                else if(sObjName=='musqot__Marketing_activity__c'){
                     emailUrl=temp+'markid=';
                     musqot__Marketing_activity__c parentRec = mrkRec.get(tsk.WhatId);
                     parentName=String.valueOf(parentRec.Name);
                }
                mail.setSubject(label.pt_New_task +', '+ parentName);
                String recurl;
                recurl=emailUrl+tsk.WhatId+'&taskId='+tsk.Id;
                //--Raju changed task email template--
                String Template = '<html><body>';
                template+= '<p style="color:#ff9933;font-size:20px;"><b>'+label.pt_New_task+'</b></p>';
                template+= '<p style="color:#000;font-size:12px;">';
                template+= '<b>'+label.tsk_Subject +'</b>'+': {0} <br/>';//subject
                template+= '<b>'+label.tsk_Task_name+'</b>'+': {1}<br/>';//tskname
                template+= '<b>'+label.inv_Description+'</b>'+': {2}<br/>';//descrption
                template+= '<b>'+label.task_Related_To+'</b>'+': {3}<br/>';//Related to
                template+= '<b>'+label.tsk_Assigned_To+'</b>'+': {4}<br/>';//Assign to
                template+= '<b>'+label.tsk_Due_Date+'</b>'+': {5}<br/>';//duedate
                template+= '<b>'+label.tsk_Priority+'</b>'+': {6}<br/>';//priorty
                template+= '<b>'+label.taskcreatedby+'</b>'+': {7}<br/><br/>';//Creadted by
                
                template+= label.task_template+':<br/>';
                template+= '<a href="' + recurl +'">'+label.btn_View +' ' +label.tsk_Task.toLowerCase() +'</a><br/>';
                template += '</p></body></html>';
                String duedate = '';
                if (tsk.ActivityDate==null){
                    duedate = '';    
                }       
                else{
                    duedate = tsk.ActivityDate.format();
                }   
                List<String> args = new List<String>();
                args.add(tsk.Subject);
                args.add(tsk.Task_name__c);
                args.add(tsk.Task_description__c);
                args.add(parentName);
                args.add(theUser.Name);
                args.add(duedate);
                args.add(tsk.Priority);
                args.add(creUser.Name);
                // Make the switch
                String formattedHtml = String.format(template, args);
                mail.setHtmlBody(formattedHtml);
                mails.add(mail);
               //--End the template---
            }
             Messaging.SendEmail(mails);
        }
    }
}