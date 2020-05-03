/*******************************************************
Class Name: ERPMilestoneUpdateScheduler
Author: Narendra K Jha        Last modified by: Narendra K Jha
Date: Oct 19, 2015            Date: Oct 21, 2015
********©2015 Musqot marketing technology Pvt ltd *******/
global class ERPMilestoneUpdateScheduler Implements Schedulable {
    public List<Milestone__c > milestoneList;
    public List<Milestone__c > updateMilestoneList=new List<Milestone__c>(); 
    public String businessRegion;
    public String businessArea;
    public Date today=system.toDay();
    public List<String> businessRegionList = new List<String> ();
    public List<String> businessAreaList = new List<String> ();
    public List<String> ebusinessRegionList = new List<String> ();
    public List<String> ebusinessAreaList = new List<String> ();
    public List<ERP_sales_obj__c> erpDataList = new List<ERP_sales_obj__c>();
    public date startDate = system.today();
    public date endDate;

    global void execute(SchedulableContext sc) {
            updateMilestoneList=new List<Milestone__c >();
            milestoneList = [SELECT Id, Plan__c, Project__c, Marketing_activity__c,
                                   Plan__r.Starts_date__c, Project__r.Starts_date__c, Marketing_activity__r.Starts_date__c,
                                   Plan__r.Ends_date__c, Project__r.Ends_date__c, Marketing_activity__r.Ends_date__c,
                                   Status__c, Targetdate__c, Target_number__c, Target_number_outcome__c,
                                   Target_ERP_sales__c,                 
                                   Target_ERP_sales__r.Expression_business_region__c,
                                   Target_ERP_sales__r.Expression_business_area__c
                             FROM  Milestone__c 
                             where Milestone_type__c=4 limit 1000];
        
        // to query out erp data
        for(Milestone__c ms : milestoneList) {
            If (ms.Marketing_activity__c <> null) {
                If (ms.Marketing_activity__r.Starts_date__c < startDate ){
                    startDate = ms.Project__r.Starts_date__c;
                }
            }
            else If (ms.Project__c <> null) {
                If (ms.Project__r.Starts_date__c < startDate){
                    startDate = ms.Project__r.Starts_date__c;
                }
            }
            else If (ms.Plan__c <> null) {
                If (ms.Plan__r.Starts_date__c < startDate){
                    startDate = ms.Plan__r.Starts_date__c;
                }
            }
        }

        erpDataList = [SELECT Id, Sales__c, Business_area__c, Business_region__c,Sales_date__c
                      FROM  ERP_sales_obj__c 
                      where Sales_date__c>=:startDate AND Sales_date__c<=:TODAY];   
            
        Decimal TargetNumber_Sales;
        
        for(Milestone__c updatemilestone : milestoneList) {
                 TargetNumber_Sales = 0;
                 if(updatemilestone.Target_ERP_sales__r.Expression_business_region__c !=null){
                     businessRegion= updatemilestone.Target_ERP_sales__r.Expression_business_region__c;
                     businessRegionList.addAll(businessRegion.split('\\s*(=>|,|\\s)\\s*')); 
                 }
                 if(updatemilestone.Target_ERP_sales__r.Expression_business_area__c !=null){
                     businessArea= updatemilestone.Target_ERP_sales__r.Expression_business_area__c;
                     businessAreaList.addAll(businessArea.split('\\s*(=>|,|\\s)\\s*')); 
                 }

                 for(ERP_sales_obj__c erpData : erpDataList) {
                           if(updatemilestone.Marketing_activity__c <> null) {
                                if (erpData.Sales_date__c >= updatemilestone.Marketing_activity__r.Starts_date__c 
                                    && erpData.Sales_date__c >= updatemilestone.Marketing_activity__r.Ends_date__c) {
                                        If(businessAreaList <> null){
                                            for(String bal : businessAreaList) {
                                                if(bal == erpData.Business_area__c) {
                                                    if(businessRegionList <> null) {
                                                        for(String brl : businessRegionList) {
                                                            if(brl == erpData.Business_region__c) {
                                                                 TargetNumber_Sales += erpData.Sales__c;
                                                            }
                                                        }
                                                    } else {
                                                        TargetNumber_Sales += erpData.Sales__c; 
                                                    }
                                                }
                                            }
                                        } else {
                                            if(businessRegionList <> null) {
                                                for(String brl : businessRegionList) {
                                                    if(brl == erpData.Business_region__c) {
                                                        TargetNumber_Sales += erpData.Sales__c;  
                                                    }
                                                }
                                            } else {
                                                TargetNumber_Sales += erpData.Sales__c;
                                            }
                                        }
                                    }
                            } 
                            else If (updatemilestone.Project__c <> null) {
                                if (erpData.Sales_date__c >= updatemilestone.Project__r.Starts_date__c 
                                    && erpData.Sales_date__c >= updatemilestone.Project__r.Ends_date__c) {
                                        If(businessAreaList <> null) {
                                            for(String bal : businessAreaList) {
                                                if(bal == erpData.Business_area__c) {
                                                    if(businessRegionList <> null) {
                                                        for(String brl : businessRegionList) {
                                                            if(brl == erpData.Business_region__c) {
                                                                 TargetNumber_Sales += erpData.Sales__c;  
                                                            }
                                                        }
                                                    } else {
                                                        TargetNumber_Sales += erpData.Sales__c;   
                                                    }
                                                }
                                            }
                                        } else {
                                            if(businessRegionList <> null) {
                                                for(String brl : businessRegionList) {
                                                    if(brl == erpData.Business_region__c) {
                                                        TargetNumber_Sales += erpData.Sales__c;  
                                                    }
                                                }
                                            } else {
                                                TargetNumber_Sales += erpData.Sales__c; 
                                            }
                                        }
                                    }
                            }
                        
                            else If (updatemilestone.Plan__c <> null) {
                                if (erpData.Sales_date__c >= updatemilestone.Plan__r.Starts_date__c 
                                    && erpData.Sales_date__c >= updatemilestone.Plan__r.Ends_date__c) {
                                       If(businessAreaList <> null) {
                                            for(String bal : businessAreaList) {
                                                if(bal == erpData.Business_area__c) {
                                                    if(businessRegionList <> null) {
                                                        for(String brl : businessRegionList) {
                                                            if(brl == erpData.Business_region__c) {
                                                                 TargetNumber_Sales += erpData.Sales__c; 
                                                            }
                                                        }
                                                    } else {
                                                        TargetNumber_Sales += erpData.Sales__c;  
                                                    }
                                                }
                                            }
                                        } else {
                                            if(businessRegionList <> null) {
                                                for(String brl : businessRegionList) {
                                                    if(brl == erpData.Business_region__c) {
                                                        TargetNumber_Sales += erpData.Sales__c;  
                                                    }
                                                }
                                            } else {
                                                TargetNumber_Sales += erpData.Sales__c; 
                                            }
                                        } 
                                    }
                            }

                         
                                   
                 }
                 
                 updatemilestone.Status__c = getStatus(updatemilestone,TargetNumber_Sales);
                 updatemilestone.Target_number_outcome__c = TargetNumber_Sales;
                
                 updateMilestoneList.add(updatemilestone);
            }
            update updateMilestoneList;
        
        
           // reschediuling the job
           try{
                List<ERP_Settings__c> erps = [SELECT Name, Id FROM ERP_Settings__c where ERP_performance_type__c = 'Milestone'];
                if(erps.size() > 0) {
                    // if milestone present
                    Date tomorrowsDate = System.today().addDays(1);
                    Integer day = tomorrowsDate.day();
                    Integer month = tomorrowsDate.month();
                    Integer year = tomorrowsDate.year();
                    String SchTimer='0 5 1 '+day+' '+month+' ? '+year;   //  next day 1:05 AM
                    System.schedule('ERPMilestoneUpdateSchedulerJob', SchTimer, new ERPMilestoneUpdateScheduler());
                }
            }catch(Exception e){
                System.debug('Exception : ' + e.getMessage());
            }
    }
    
    public String getStatus(Milestone__c updatemilestone, Decimal TargetNumber_outcome) {
        // Update Status      
        If( updatemilestone.Target_number__c > 0||updatemilestone.Target_number__c <> null){
            if(updatemilestone.Targetdate__c > toDay && updatemilestone.Target_number__c < TargetNumber_outcome){
                updatemilestone.Status__c= 'Open';                
            }
            else if(updatemilestone.Targetdate__c >= toDay && updatemilestone.Target_number__c >= TargetNumber_outcome && updatemilestone.Status__c <> 'Reach Delayed' ){
                updatemilestone.Status__c= 'Reach on time';        
            }
            else if(updatemilestone.Targetdate__c <= toDay && updatemilestone.Target_number__c >= TargetNumber_outcome){
                updatemilestone.Status__c= 'Not Reach';          
            }
            else if(updatemilestone.Targetdate__c < toDay && updatemilestone.Target_number__c < TargetNumber_outcome){
                updatemilestone.Status__c= 'Reach Delayed'; 
            }          
        }
        else{
            updatemilestone.Status__c= '?';
        }  
        return updatemilestone.Status__c;
        // status end
    }
}