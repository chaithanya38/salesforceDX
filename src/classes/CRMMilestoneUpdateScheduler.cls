/*******************************************************
Class Name: CRMMilestoneUpdateScheduler
Author: Narendra K Jha        Last modified by: Narendra K Jha
Date: Oct 19, 2015            Date: Oct 21, 2015
********©2015 Musqot marketing technology Pvt ltd *******/
global class CRMMilestoneUpdateScheduler Implements Schedulable {
   	public List<Milestone__c > milestoneList;
   	public List<Milestone__c > updateMilestoneList=new List<Milestone__c>(); 
   	public String businessRegion;
   	public String businessArea;
   	public Date today=system.toDay();
   	public List<String> businessRegionList = new List<String> ();
   	public List<String> businessAreaList = new List<String> ();
    public List<String> ebusinessRegionList = new List<String> ();
    public List<String> ebusinessAreaList = new List<String> ();
   	public List<musqot__CRM_data__c> crmDataList = new List<musqot__CRM_data__c>();
    public date startDate = system.today();
    public date endDate;

    global void execute(SchedulableContext sc) {
        	updateMilestoneList=new List<Milestone__c >();
            milestoneList = [SELECT Id, Plan__c, Project__c, Marketing_activity__c,
                                   Plan__r.Starts_date__c, Project__r.Starts_date__c, Marketing_activity__r.Starts_date__c,
                                   Plan__r.Ends_date__c, Project__r.Ends_date__c, Marketing_activity__r.Ends_date__c,
                                   Status__c, Targetdate__c, Target_number__c, Target_number_outcome__c,
                                   Target_CRM_settings__c, Target_CRM_settings__r.Watch_type__c,                   
                                   Target_CRM_settings__r.musqot__Expression_business_region__c,
                             	   Target_CRM_settings__r.Expression_business_area__c
                             FROM  Milestone__c 
                             where Milestone_type__c=5 limit 1000];
        
        // to query out crm data
        for(Milestone__c ms : milestoneList) {
            If (ms.Marketing_activity__c <> null) {
                If (ms.Marketing_activity__r.Starts_date__c < startDate){
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
        crmDataList = [SELECT Id, Date__c, Business_area__c, Business_region__c, 
                       		No_Leads__c, 
                       		No_Opportunities__c, Value_Opportunities__c, Value_w_Opportunities__c, 
                       		Value_Deals__c
                      FROM  CRM_data__c 
                      where Date__c>=:startDate AND Date__c<=:TODAY];	
        // end -- to query out crm data
        // 
        	
        	Decimal TargetNumber_Leads;
            Decimal TargetNumber_Opportunities;
            Decimal TargetNumber_Amount;
            Decimal TargetNumber_Win;
            Decimal TargetNumber_Loose;
            Decimal TargetNumber_Weighted;
        
        for(Milestone__c updatemilestone : milestoneList) {
                 TargetNumber_Leads = 0;
                 TargetNumber_Opportunities = 0;
                 TargetNumber_Amount = 0;
                 TargetNumber_Win = 0;
                 TargetNumber_Loose = 0;
                 TargetNumber_Weighted = 0;
                 if(updatemilestone.Target_CRM_settings__r.Expression_business_region__c !=null){
                     businessRegion= updatemilestone.Target_CRM_settings__r.Expression_business_region__c;
                     businessRegionList.addAll(businessRegion.split('\\s*(=>|,|\\s)\\s*')); 
                 }
                 if(updatemilestone.Target_CRM_settings__r.Expression_business_area__c !=null){
                     businessArea= updatemilestone.Target_CRM_settings__r.Expression_business_area__c;
                     businessAreaList.addAll(businessArea.split('\\s*(=>|,|\\s)\\s*')); 
                 }

                 for(musqot__CRM_data__c crmData : crmDataList) {
					       if(updatemilestone.Marketing_activity__c <> null) {
                            	if (crmData.Date__c >= updatemilestone.Marketing_activity__r.Starts_date__c 
                                    && crmData.Date__c >= updatemilestone.Marketing_activity__r.Ends_date__c) {
                                        If(businessAreaList <> null) {
                                            for(String bal : businessAreaList) {
                                                if(bal == crmData.Business_area__c) {
                                                    if(businessRegionList <> null) {
                                                        for(String brl : businessRegionList) {
                                                            if(brl == crmData.Business_region__c) {
                                                                 TargetNumber_Leads += crmData.No_Leads__c;
                                                                 TargetNumber_Opportunities += crmData.Value_Opportunities__c;
                                                                 TargetNumber_Amount += crmData.Value_Opportunities__c;
                                                                 TargetNumber_Win += crmData.Value_Deals__c;
                                                                 TargetNumber_Weighted += crmData.Value_w_Opportunities__c;
                                                                 if(crmData.Value_Deals__c == 0) {
                                                                     TargetNumber_Loose += 1;
                                                                 }   
                                                            }
                                                        }
                                                    } else {
                                                        TargetNumber_Leads += crmData.No_Leads__c;
                                                        TargetNumber_Opportunities += crmData.Value_Opportunities__c;
                                                        TargetNumber_Amount += crmData.Value_Opportunities__c;
                                                        TargetNumber_Win += crmData.Value_Deals__c;
                                                        TargetNumber_Weighted += crmData.Value_w_Opportunities__c;
                                                        if(crmData.Value_Deals__c == 0) {
                                                            TargetNumber_Loose += 1;
                                                        }   
                                                    }
                                                }
                                            }
                                        } else {
                                            if(businessRegionList <> null) {
                                                for(String brl : businessRegionList) {
                                                    if(brl == crmData.Business_region__c) {
                                                        TargetNumber_Leads += crmData.No_Leads__c;
                                                        TargetNumber_Opportunities += crmData.Value_Opportunities__c;
                                                        TargetNumber_Amount += crmData.Value_Opportunities__c;
                                                        TargetNumber_Win += crmData.Value_Deals__c;
                                                        TargetNumber_Weighted += crmData.Value_w_Opportunities__c;
                                                        if(crmData.Value_Deals__c == 0) {
                                                            TargetNumber_Loose += 1;
                                                        }   
                                                    }
                                                }
                                            } else {
                                                TargetNumber_Leads += crmData.No_Leads__c;
                                                TargetNumber_Opportunities += crmData.Value_Opportunities__c;
                                                TargetNumber_Amount += crmData.Value_Opportunities__c;
                                                TargetNumber_Win += crmData.Value_Deals__c;
                                                TargetNumber_Weighted += crmData.Value_w_Opportunities__c;
                                                if(crmData.Value_Deals__c == 0) {
                                                    TargetNumber_Loose += 1;
                                                }   
                                            }
                                        }
                                    }
							} 
						   	else If (updatemilestone.Project__c <> null) {
								if (crmData.Date__c >= updatemilestone.Project__r.Starts_date__c 
                                    && crmData.Date__c >= updatemilestone.Project__r.Ends_date__c) {
                                        If(businessAreaList <> null) {
                                            for(String bal : businessAreaList) {
                                                if(bal == crmData.Business_area__c) {
                                                    if(businessRegionList <> null) {
                                                        for(String brl : businessRegionList) {
                                                            if(brl == crmData.Business_region__c) {
                                                                 TargetNumber_Leads += crmData.No_Leads__c;
                                                                 TargetNumber_Opportunities += crmData.Value_Opportunities__c;
                                                                 TargetNumber_Amount += crmData.Value_Opportunities__c;
                                                                 TargetNumber_Win += crmData.Value_Deals__c;
                                                                 TargetNumber_Weighted += crmData.Value_w_Opportunities__c;
                                                                 if(crmData.Value_Deals__c == 0) {
                                                                     TargetNumber_Loose += 1;
                                                                 }   
                                                            }
                                                        }
                                                    } else {
                                                        TargetNumber_Leads += crmData.No_Leads__c;
                                                        TargetNumber_Opportunities += crmData.Value_Opportunities__c;
                                                        TargetNumber_Amount += crmData.Value_Opportunities__c;
                                                        TargetNumber_Win += crmData.Value_Deals__c;
                                                        TargetNumber_Weighted += crmData.Value_w_Opportunities__c;
                                                        if(crmData.Value_Deals__c == 0) {
                                                            TargetNumber_Loose += 1;
                                                        }   
                                                    }
                                                }
                                            }
                                        } else {
                                            if(businessRegionList <> null) {
                                                for(String brl : businessRegionList) {
                                                    if(brl == crmData.Business_region__c) {
                                                        TargetNumber_Leads += crmData.No_Leads__c;
                                                        TargetNumber_Opportunities += crmData.Value_Opportunities__c;
                                                        TargetNumber_Amount += crmData.Value_Opportunities__c;
                                                        TargetNumber_Win += crmData.Value_Deals__c;
                                                        TargetNumber_Weighted += crmData.Value_w_Opportunities__c;
                                                        if(crmData.Value_Deals__c == 0) {
                                                            TargetNumber_Loose += 1;
                                                        }   
                                                    }
                                                }
                                            } else {
                                                TargetNumber_Leads += crmData.No_Leads__c;
                                                TargetNumber_Opportunities += crmData.Value_Opportunities__c;
                                                TargetNumber_Amount += crmData.Value_Opportunities__c;
                                                TargetNumber_Win += crmData.Value_Deals__c;
                                                TargetNumber_Weighted += crmData.Value_w_Opportunities__c;
                                                if(crmData.Value_Deals__c == 0) {
                                                    TargetNumber_Loose += 1;
                                                }   
                                            }
                                        }
                                    }
							}
						
							else If (updatemilestone.Plan__c <> null) {
								if (crmData.Date__c >= updatemilestone.Plan__r.Starts_date__c 
                                    && crmData.Date__c >= updatemilestone.Plan__r.Ends_date__c) {
                                       If(businessAreaList <> null) {
                                            for(String bal : businessAreaList) {
                                                if(bal == crmData.Business_area__c) {
                                                    if(businessRegionList <> null) {
                                                        for(String brl : businessRegionList) {
                                                            if(brl == crmData.Business_region__c) {
                                                                 TargetNumber_Leads += crmData.No_Leads__c;
                                                                 TargetNumber_Opportunities += crmData.Value_Opportunities__c;
                                                                 TargetNumber_Amount += crmData.Value_Opportunities__c;
                                                                 TargetNumber_Win += crmData.Value_Deals__c;
                                                                 TargetNumber_Weighted += crmData.Value_w_Opportunities__c;
                                                                 if(crmData.Value_Deals__c == 0) {
                                                                     TargetNumber_Loose += 1;
                                                                 }   
                                                            }
                                                        }
                                                    } else {
                                                        TargetNumber_Leads += crmData.No_Leads__c;
                                                        TargetNumber_Opportunities += crmData.Value_Opportunities__c;
                                                        TargetNumber_Amount += crmData.Value_Opportunities__c;
                                                        TargetNumber_Win += crmData.Value_Deals__c;
                                                        TargetNumber_Weighted += crmData.Value_w_Opportunities__c;
                                                        if(crmData.Value_Deals__c == 0) {
                                                            TargetNumber_Loose += 1;
                                                        }   
                                                    }
                                                }
                                            }
                                        } else {
                                            if(businessRegionList <> null) {
                                                for(String brl : businessRegionList) {
                                                    if(brl == crmData.Business_region__c) {
                                                        TargetNumber_Leads += crmData.No_Leads__c;
                                                        TargetNumber_Opportunities += crmData.Value_Opportunities__c;
                                                        TargetNumber_Amount += crmData.Value_Opportunities__c;
                                                        TargetNumber_Win += crmData.Value_Deals__c;
                                                        TargetNumber_Weighted += crmData.Value_w_Opportunities__c;
                                                        if(crmData.Value_Deals__c == 0) {
                                                            TargetNumber_Loose += 1;
                                                        }   
                                                    }
                                                }
                                            } else {
                                                TargetNumber_Leads += crmData.No_Leads__c;
                                                TargetNumber_Opportunities += crmData.Value_Opportunities__c;
                                                TargetNumber_Amount += crmData.Value_Opportunities__c;
                                                TargetNumber_Win += crmData.Value_Deals__c;
                                                TargetNumber_Weighted += crmData.Value_w_Opportunities__c;
                                                if(crmData.Value_Deals__c == 0) {
                                                    TargetNumber_Loose += 1;
                                                }   
                                            }
                                        } 
                                    }
							}

                         
                                   
                 }
                 
                 if(updatemilestone.Target_CRM_settings__r.Watch_type__c=='No Leads'){
                         updatemilestone.Status__c = getStatus(updatemilestone,TargetNumber_Leads);
                     	 updatemilestone.Target_number_outcome__c = TargetNumber_Leads;
                 } 
                 if(updatemilestone.Target_CRM_settings__r.Watch_type__c=='No Opportunities'){   
                     	 updatemilestone.Status__c = getStatus(updatemilestone,TargetNumber_Opportunities);
                     	 updatemilestone.Target_number_outcome__c = TargetNumber_Opportunities;
                 }
                 if(updatemilestone.Target_CRM_settings__r.Watch_type__c=='Amount Opportunities'){
                         updatemilestone.Status__c = getStatus(updatemilestone,TargetNumber_Amount);
                     	 updatemilestone.Target_number_outcome__c = TargetNumber_Amount;
                 }
                 if(updatemilestone.Target_CRM_settings__r.Watch_type__c=='No Wins'){
                         updatemilestone.Status__c = getStatus(updatemilestone,TargetNumber_Loose);
                     	 updatemilestone.Target_number_outcome__c = TargetNumber_Loose;
                 }
                 if(updatemilestone.Target_CRM_settings__r.Watch_type__c=='Amount Wins'){
                         updatemilestone.Status__c = getStatus(updatemilestone,TargetNumber_Win);
                     	 updatemilestone.Target_number_outcome__c = TargetNumber_Win;
                     
                 }
                 if(updatemilestone.Target_CRM_settings__r.Watch_type__c=='Amount (weighted) Opportunities'){
                      	 updatemilestone.Status__c = getStatus(updatemilestone,TargetNumber_Weighted);
                     	 updatemilestone.Target_number_outcome__c = TargetNumber_Weighted;
                 }
                
                updateMilestoneList.add(updatemilestone);
            }
            update updateMilestoneList;
        
           // reschediuling the job
           try{
                List<CRM_settings__c> cmrs = [SELECT Id, name from CRM_settings__c where CRM_performance_type__c= 'Milestone'];
                if(cmrs.size() > 0) {
                    // if milestone present
                    Date tomorrowsDate = System.today().addDays(1);
                    Integer day = tomorrowsDate.day();
                    Integer month = tomorrowsDate.month();
                    Integer year = tomorrowsDate.year();
                    String SchTimer='0 10 1 '+day+' '+month+' ? '+year;   //  next day 1:10 AM
                    System.schedule('CRMMilestoneUpdateSchedulerJob', SchTimer, new CRMMilestoneUpdateScheduler());
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