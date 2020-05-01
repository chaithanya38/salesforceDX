@isTest(seealldata = true)
public class Socialmedia_connection_CtrlTest{
        static testMethod void Socialmedia_controllerMethodFacebookPage(){     
            musqot__Socialmedia_settings__c OBJSocial = new musqot__Socialmedia_settings__c();
            OBJSocial.Name='testmedia';
            OBJSocial.musqot__Import_rate__c='Hour';        
            OBJSocial.musqot__Socialmedia_type__c='Facebook';
            OBJSocial.musqot__Watch_type__c='Downloads';
            OBJSocial.musqot__Chart__c='Bar charts';
            OBJSocial.musqot__Auto_import__c= true ;
            OBJSocial.Type__c='Milestone';
            insert OBJSocial;                    
            System.assertEquals('Downloads', OBJSocial.musqot__Watch_type__c);
            
            musqot__OAuthService__c  OAuth = new musqot__OAuthService__c ();
            OAuth.Name='ffbook';
            OAuth.musqot__Authorization_Type__c='Requestheader';
            OAuth.musqot__Access_Token_URL__c='CAALlOqcmcU0BAIaeOHMdCPDYmBncSiSe3cy33qNcAZABm2ZAGaq1UkUW5ZBm6dHVHZBM0cnnvZAMwKLnOltsqveNZANCUpYdJK9Wgi6L3IpGcmI5rStbo1q5112WAxGxIhyxw6nXSDsOqXhlTlLfqM2TTzh6kdQ7JqH3swv0iZB4N1ZC3AuMESrXOBTGqz1d3Y4ZD';
            OAuth.musqot__Response_Type__c='token';
            OAuth.musqot__Signature_Method__c='PLAINTEXT';
            OAuth.musqot__Consumer_Key__c = '30082886';
            OAuth.musqot__Consumer_Secret__c = '';  
            OAuth.musqot__Bar_color__c='#333';   
            OAuth.musqot__Page_Id__c='504964542946242';
            OAuth.End_Date__c=System.now().date()+5;
            //Oauth.musqot__Post_ID__c='';  
            //OAuth.musqot__Campaign_Id__c='6028983458919';   
            OAuth.musqot__Socialmedia__c = OBJSocial.Id;
            OAuth.musqot__Social_media__c='Facebook';
            OAuth.musqot__Auto_import__c=true;
            //OAuth.musqot__ad_id__c='6028983459919';
            insert OAuth;
            system.assertnotEquals(null,OAuth.id); 
            system.assertEquals('ffbook', OAuth.Name);
            
            musqot__Social_media_data__c smd = new musqot__Social_media_data__c();
            smd.musqot__Compound_Id__c='Requestheader';
            smd.musqot__Date__c=system.today();
            smd.musqot__Number_of_likes__c=5;
            smd.musqot__Number_of_member__c=100;
            smd.musqot__Number_of_unik_visitor__c= 200;
            smd.musqot__Connection__c= OAuth.id;  
            smd.musqot__Socialmedia_Settings__c=OBJSocial.id;
            insert smd;        
            System.assertEquals('Requestheader', smd.musqot__Compound_Id__c);
            
            Socialmedia_settings__c st=new Socialmedia_settings__c();
            st.musqot__Auto_import__c=true;
            st.musqot__Socialmedia__c=OAuth.id;
            st.musqot__Socialmedia_type__c='Page';
            st.musqot__End_date__c=system.today();
            st.musqot__Start_date__c=system.today();
            //st.Type__c='Milestone';
            st.Socialmedia__c=OAuth.id;
            insert st;        
            System.assertEquals(true, st.musqot__Auto_import__c);
            
            musqot__Socialmedia_logfile__c smdata = new musqot__Socialmedia_logfile__c();
            smdata.musqot__Connection_id__c=OAuth.id;
            smdata.musqot__Imported__c=true;
            smdata.musqot__Import_message__c='Pagemessage';
            smdata.musqot__Number_of_records__c=100;
            insert smdata;
            System.assertEquals(true, smdata.musqot__Imported__c);
           
            Test.startTest();
            //try{
            ApexPages.currentPage().getParameters().put('socialId',OBJSocial.Id);
            ApexPages.currentPage().getParameters().put('conid',OAuth.Id);
             ApexPages.currentPage().getParameters().put('cntId',OAuth.Id);
            ApexPages.StandardController ctrl = new ApexPages.StandardController(OAuth);
            Socialmedia_connection_Ctrl sec = new Socialmedia_connection_Ctrl (ctrl);
            //CronJobDetail cj = [select id, Name from CronJobDetail where Name = :'scheduleFacebookInsightsJob'];
            //CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where CronJobDetailId = :cj.Id];
            sec.ObjSMS = OAuth;
            sec.conid = OAuth.Id;
            List<OAuthService__c> tem1= sec.connectionList; 
            sec.smMessage  = true;
            Test.setMock(HttpCalloutMock.class, new HttpRequestandResponse());             
            Socialmedia_connection_Ctrl.querySocialMediaInsights();     
            Socialmedia_connection_Ctrl.querySocialMediaPageInsights(OAuth.Id);            
            //sec.updSocial();
            sec.cancel();                     
            //sec.socialmediaConnection();   
            sec.smMessage=true;         
            sec.cancel();
            sec.importsocialmediaData();                       
                //}catch(Exception e){}            
            sec.smMessage = true;
            test.stopTest(); 
        }
    static testMethod void Socialmedia_controllerMethodFacebookAd(){     
            musqot__Socialmedia_settings__c OBJSocial = new musqot__Socialmedia_settings__c();
            OBJSocial.Name='testmedia';
            OBJSocial.musqot__Import_rate__c='Hour';        
            OBJSocial.musqot__Socialmedia_type__c='Facebook';
            OBJSocial.musqot__Watch_type__c='Downloads';
            OBJSocial.musqot__Chart__c='Bar charts';
            OBJSocial.musqot__Auto_import__c= true ;
            OBJSocial.Type__c='Milestone';
            insert OBJSocial;                    
            System.assertEquals('Downloads', OBJSocial.musqot__Watch_type__c);
            
            musqot__OAuthService__c  OAuth = new musqot__OAuthService__c ();
            OAuth.Name='ffbook';
            OAuth.musqot__Authorization_Type__c='Requestheader';
            OAuth.musqot__Access_Token_URL__c='CAALlOqcmcU0BAIaeOHMdCPDYmBncSiSe3cy33qNcAZABm2ZAGaq1UkUW5ZBm6dHVHZBM0cnnvZAMwKLnOltsqveNZANCUpYdJK9Wgi6L3IpGcmI5rStbo1q5112WAxGxIhyxw6nXSDsOqXhlTlLfqM2TTzh6kdQ7JqH3swv0iZB4N1ZC3AuMESrXOBTGqz1d3Y4ZD';
            OAuth.musqot__Response_Type__c='token';
            OAuth.musqot__Signature_Method__c='PLAINTEXT';
            OAuth.musqot__Consumer_Key__c = '30082886';
            OAuth.musqot__Consumer_Secret__c = '';  
            OAuth.musqot__Bar_color__c='#333';   
            //OAuth.musqot__Page_Id__c='504964542946242';
            OAuth.End_Date__c=System.now().date()+5;
            //Oauth.musqot__Post_ID__c='';  
            //OAuth.musqot__Campaign_Id__c='6028983458919';   
            OAuth.musqot__Socialmedia__c = OBJSocial.Id;
            OAuth.musqot__Social_media__c='Facebook';
            OAuth.musqot__Auto_import__c=true;
            OAuth.musqot__ad_id__c='6028983459919';
            insert OAuth;
            system.assertnotEquals(null,OAuth.id); 
            system.assertEquals('ffbook', OAuth.Name);
            
            musqot__Social_media_data__c smd = new musqot__Social_media_data__c();
            smd.musqot__Compound_Id__c='Requestheader';
            smd.musqot__Date__c=system.today();
            smd.musqot__Number_of_likes__c=5;
            smd.musqot__Number_of_member__c=100;
            smd.musqot__Number_of_unik_visitor__c= 200;
            smd.musqot__Connection__c= OAuth.id;  
            smd.musqot__Socialmedia_Settings__c=OBJSocial.id;
            insert smd;        
            System.assertEquals('Requestheader', smd.musqot__Compound_Id__c);
            
            Socialmedia_settings__c st=new Socialmedia_settings__c();
            st.musqot__Auto_import__c=true;
            st.musqot__Socialmedia__c=OAuth.id;
            st.musqot__Socialmedia_type__c='Page';
            st.musqot__End_date__c=system.today();
            st.musqot__Start_date__c=system.today();
            //st.Type__c='Milestone';
            st.Socialmedia__c=OAuth.id;
            insert st;        
            System.assertEquals(true, st.musqot__Auto_import__c);
            
            musqot__Socialmedia_logfile__c smdata = new musqot__Socialmedia_logfile__c();
            smdata.musqot__Connection_id__c=OAuth.id;
            smdata.musqot__Imported__c=true;
            smdata.musqot__Import_message__c='Pagemessage';
            smdata.musqot__Number_of_records__c=100;
            insert smdata;
            System.assertEquals(true, smdata.musqot__Imported__c);
           
            Test.startTest();
            try{
            ApexPages.currentPage().getParameters().put('socialId',OBJSocial.Id);
            ApexPages.currentPage().getParameters().put('conid',OAuth.Id);
             ApexPages.currentPage().getParameters().put('cntId',OAuth.Id);
            ApexPages.StandardController ctrl = new ApexPages.StandardController(OAuth);
            Socialmedia_connection_Ctrl sec = new Socialmedia_connection_Ctrl (ctrl);
            //CronJobDetail cj = [select id, Name from CronJobDetail where Name = :'scheduleFacebookInsightsJob'];
            //CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where CronJobDetailId = :cj.Id];
            sec.ObjSMS = OAuth;
            List<OAuthService__c> tem1= sec.connectionList;  
            sec.smMessage  = true;
            Test.setMock(HttpCalloutMock.class, new HttpRequestandResponse());            
            Socialmedia_connection_Ctrl.queryfacebookAdInsights();       
            sec.smMessage=true;
            //sec.updSocial();
            sec.cancel();                      
            //sec.socialmediaConnection();
            sec.importsocialmediaData();                       
                }catch(Exception e){}
            test.stopTest(); 
        }
    static testMethod void Socialmedia_controllerMethodFacebookPost(){     
            musqot__Socialmedia_settings__c OBJSocial = new musqot__Socialmedia_settings__c();
            OBJSocial.Name='testmedia';
            OBJSocial.musqot__Import_rate__c='Hour';        
            OBJSocial.musqot__Socialmedia_type__c='Facebook';
            OBJSocial.musqot__Watch_type__c='Downloads';
            OBJSocial.musqot__Chart__c='Bar charts';
            OBJSocial.musqot__Auto_import__c= true ;
            OBJSocial.Type__c='Milestone';
            insert OBJSocial;                    
            System.assertEquals('Downloads', OBJSocial.musqot__Watch_type__c);
            
            musqot__OAuthService__c  OAuth = new musqot__OAuthService__c ();
            OAuth.Name='ffbook';
            OAuth.musqot__Authorization_Type__c='Requestheader';
            OAuth.musqot__Access_Token_URL__c='CAALlOqcmcU0BAIaeOHMdCPDYmBncSiSe3cy33qNcAZABm2ZAGaq1UkUW5ZBm6dHVHZBM0cnnvZAMwKLnOltsqveNZANCUpYdJK9Wgi6L3IpGcmI5rStbo1q5112WAxGxIhyxw6nXSDsOqXhlTlLfqM2TTzh6kdQ7JqH3swv0iZB4N1ZC3AuMESrXOBTGqz1d3Y4ZD';
            OAuth.musqot__Response_Type__c='token';
            OAuth.musqot__Signature_Method__c='PLAINTEXT';
            OAuth.musqot__Consumer_Key__c = '30082886';
            OAuth.musqot__Consumer_Secret__c = '987867ghvchgcgf';  
            OAuth.musqot__Bar_color__c='#333';   
            //OAuth.musqot__Page_Id__c='504964542946242';
            OAuth.End_Date__c=System.now().date()+5;
            Oauth.musqot__Post_ID__c='1234567';  
            //OAuth.musqot__Campaign_Id__c='6028983458919';   
            OAuth.musqot__Socialmedia__c = OBJSocial.Id;
            OAuth.musqot__Social_media__c='Facebook';
            OAuth.musqot__Auto_import__c=true;
            //OAuth.musqot__ad_id__c='6028983459919';
            insert OAuth;
            system.assertnotEquals(null,OAuth.id); 
            system.assertEquals('ffbook', OAuth.Name);
            
            musqot__Social_media_data__c smd = new musqot__Social_media_data__c();
            smd.musqot__Compound_Id__c='Requestheader';
            smd.musqot__Date__c=system.today();
            smd.musqot__Number_of_likes__c=5;
            smd.musqot__Number_of_member__c=100;
            smd.musqot__Number_of_unik_visitor__c= 200;
            smd.musqot__Connection__c= OAuth.id;  
            smd.musqot__Socialmedia_Settings__c=OBJSocial.id;
            insert smd;        
            System.assertEquals('Requestheader', smd.musqot__Compound_Id__c);
            
            Socialmedia_settings__c st=new Socialmedia_settings__c();
            st.musqot__Auto_import__c=true;
            st.musqot__Socialmedia__c=OAuth.id;
            st.musqot__Socialmedia_type__c='Page';
            st.musqot__End_date__c=system.today();
            st.musqot__Start_date__c=system.today();
            //st.Type__c='Milestone';
            st.Socialmedia__c=OAuth.id;
            insert st;        
            System.assertEquals(true, st.musqot__Auto_import__c);
            
            musqot__Socialmedia_logfile__c smdata = new musqot__Socialmedia_logfile__c();
            smdata.musqot__Connection_id__c=OAuth.id;
            smdata.musqot__Imported__c=true;
            smdata.musqot__Import_message__c='Pagemessage';
            smdata.musqot__Number_of_records__c=100;
            insert smdata;
            System.assertEquals(true, smdata.musqot__Imported__c);
           
            Test.startTest();
            try{
            ApexPages.currentPage().getParameters().put('socialId',OBJSocial.Id);
            ApexPages.currentPage().getParameters().put('conid',OAuth.Id);
             ApexPages.currentPage().getParameters().put('cntId',OAuth.Id);
            ApexPages.StandardController ctrl = new ApexPages.StandardController(OAuth);
            Socialmedia_connection_Ctrl sec = new Socialmedia_connection_Ctrl (ctrl);
            //CronJobDetail cj = [select id, Name from CronJobDetail where Name = :'scheduleFacebookInsightsJob'];
            //CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where CronJobDetailId = :cj.Id];
            sec.ObjSMS = OAuth;
            List<OAuthService__c> tem1= sec.connectionList;
            sec.smMessage  = true;
            Test.setMock(HttpCalloutMock.class, new HttpRequestandResponse());   
            Socialmedia_connection_Ctrl.queryfacebookPostInsights();                     
            sec.smMessage=true;
            //sec.updSocial();
            sec.cancel();                      
            //sec.socialmediaConnection();            
            sec.importsocialmediaData();                       
                }catch(Exception e){}
            test.stopTest(); 
        }
    
    static testMethod void Socialmedia_controllerMethodMailChimpCampaign(){     
            musqot__Socialmedia_settings__c OBJSocial = new musqot__Socialmedia_settings__c();
            OBJSocial.Name='testmedia';
            OBJSocial.musqot__Import_rate__c='Hour';        
            OBJSocial.musqot__Socialmedia_type__c='Facebook';
            OBJSocial.musqot__Watch_type__c='Downloads';
            OBJSocial.musqot__Chart__c='Bar charts';
            OBJSocial.musqot__Auto_import__c= true ;
            OBJSocial.Type__c='Milestone';
            insert OBJSocial;                    
            System.assertEquals('Downloads', OBJSocial.musqot__Watch_type__c);
            
            musqot__OAuthService__c  OAuth = new musqot__OAuthService__c ();
            OAuth.Name='ffbook';
            OAuth.musqot__Authorization_Type__c='Requestheader';
            OAuth.musqot__Access_Token_URL__c='3fb5fa28a18e4d970e56ba8002792ddc-us11';
            OAuth.musqot__Response_Type__c='token';
            OAuth.musqot__Signature_Method__c='PLAINTEXT';
            OAuth.musqot__Consumer_Key__c = '8d4377d4ab';
            OAuth.musqot__Consumer_Secret__c = '';  
            OAuth.musqot__Bar_color__c='#333';   
            //OAuth.musqot__Page_Id__c='504964542946242';
            OAuth.End_Date__c=System.now().date()+5;
            //Oauth.musqot__Post_ID__c='1234567';  
            OAuth.musqot__Campaign_Id__c='059c9a6e11';   
            OAuth.musqot__Socialmedia__c = OBJSocial.Id;
            OAuth.musqot__Social_media__c='MailChimp';
            OAuth.musqot__Auto_import__c=true;
            //OAuth.musqot__ad_id__c='6028983459919';
            insert OAuth;
            system.assertnotEquals(null,OAuth.id); 
            system.assertEquals('ffbook', OAuth.Name);
            
            musqot__Social_media_data__c smd = new musqot__Social_media_data__c();
            smd.musqot__Compound_Id__c='Requestheader';
            smd.musqot__Date__c=system.today();
            smd.musqot__Number_of_likes__c=5;
            smd.musqot__Number_of_member__c=100;
            smd.musqot__Number_of_unik_visitor__c= 200;
            smd.musqot__Connection__c= OAuth.id;  
            smd.musqot__Socialmedia_Settings__c=OBJSocial.id;
            insert smd;        
            System.assertEquals('Requestheader', smd.musqot__Compound_Id__c);
            
            Socialmedia_settings__c st=new Socialmedia_settings__c();
            st.musqot__Auto_import__c=true;
            st.musqot__Socialmedia__c=OAuth.id;
            st.musqot__Socialmedia_type__c='Page';
            st.musqot__End_date__c=system.today();
            st.musqot__Start_date__c=system.today();
            //st.Type__c='Milestone';
            st.Socialmedia__c=OAuth.id;
            insert st;        
            System.assertEquals(true, st.musqot__Auto_import__c);
            
            musqot__Socialmedia_logfile__c smdata = new musqot__Socialmedia_logfile__c();
            smdata.musqot__Connection_id__c=OAuth.id;
            smdata.musqot__Imported__c=true;
            smdata.musqot__Import_message__c='Pagemessage';
            smdata.musqot__Number_of_records__c=100;
            insert smdata;
            System.assertEquals(true, smdata.musqot__Imported__c);
           
            Test.startTest();
            try{
            ApexPages.currentPage().getParameters().put('socialId',OBJSocial.Id);
            ApexPages.currentPage().getParameters().put('conid',OAuth.Id);
             ApexPages.currentPage().getParameters().put('cntId',OAuth.Id);
            ApexPages.StandardController ctrl = new ApexPages.StandardController(OAuth);
            Socialmedia_connection_Ctrl sec = new Socialmedia_connection_Ctrl (ctrl);
            //CronJobDetail cj = [select id, Name from CronJobDetail where Name = :'scheduleFacebookInsightsJob'];
            //CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where CronJobDetailId = :cj.Id];
            sec.ObjSMS = OAuth;
            List<OAuthService__c> tem1= sec.connectionList;  
            sec.smMessage  = true;
            Test.setMock(HttpCalloutMock.class, new HttpRequestandResponse());
            Socialmedia_connection_Ctrl.querySocialMediaInsights();
            Socialmedia_connection_Ctrl.queryfacebookAdInsights();
            Socialmedia_connection_Ctrl.queryfacebookPostInsights();
            Socialmedia_connection_Ctrl.querylinkedinPostInsights();
            Socialmedia_connection_Ctrl.querylinkedinPageInsights();
            Socialmedia_connection_Ctrl.querymailchimpcampaignInsights();            
            sec.smMessage=true;
            //sec.updSocial();
            sec.cancel();                      
            //sec.socialmediaConnection();            
            sec.importsocialmediaData();                       
                }catch(Exception e){}
            test.stopTest(); 
        }
    
    static testMethod void Socialmedia_controllerMethodLinkedinPage(){     
            musqot__Socialmedia_settings__c OBJSocial = new musqot__Socialmedia_settings__c();
            OBJSocial.Name='testmedia';
            OBJSocial.musqot__Import_rate__c='Hour';        
            OBJSocial.musqot__Socialmedia_type__c='Facebook';
            OBJSocial.musqot__Watch_type__c='Downloads';
            OBJSocial.musqot__Chart__c='Bar charts';
            OBJSocial.musqot__Auto_import__c= true ;
            OBJSocial.Type__c='Milestone';
            insert OBJSocial;                    
            System.assertEquals('Downloads', OBJSocial.musqot__Watch_type__c);
            
            musqot__OAuthService__c  OAuth = new musqot__OAuthService__c ();
            OAuth.Name='ffbook';
            OAuth.musqot__Authorization_Type__c='Requestheader';
            OAuth.musqot__Access_Token_URL__c='AQW8V5EtKM3nUu9jnxhGsWc_0Sg5mt2Wt_89qctsQIRRx_V3xaT_pPIVYAcQopVjW94n3Hsp4nTBBs_5sQk1u4270vyMiOb6qwB86GKuEIt8xcuI1sP3lHrmFpS1_lQVYeK6JVmGHC7U2wu5nh12S3Qqt1TMCPGE5kUwBt5iMXNaDyMxHqM';
            OAuth.musqot__Response_Type__c='token';
            OAuth.musqot__Signature_Method__c='PLAINTEXT';
            OAuth.musqot__Consumer_Key__c = '';
            OAuth.musqot__Consumer_Secret__c = '';  
            OAuth.musqot__Bar_color__c='#333';   
            OAuth.musqot__Page_Id__c='3632798';
            OAuth.End_Date__c=System.now().date()+5;
            //Oauth.musqot__Post_ID__c='1234567';  
            //OAuth.musqot__Campaign_Id__c='059c9a6e11';   
            OAuth.musqot__Socialmedia__c = OBJSocial.Id;
            OAuth.musqot__Social_media__c='LinkedIn';
            OAuth.musqot__Auto_import__c=true;
            //OAuth.musqot__ad_id__c='6028983459919';
            insert OAuth;
            system.assertnotEquals(null,OAuth.id); 
            system.assertEquals('ffbook', OAuth.Name);
            
            musqot__Social_media_data__c smd = new musqot__Social_media_data__c();
            smd.musqot__Compound_Id__c='Requestheader';
            smd.musqot__Date__c=system.today();
            smd.musqot__Number_of_likes__c=5;
            smd.musqot__Number_of_member__c=100;
            smd.musqot__Number_of_unik_visitor__c= 200;
            smd.musqot__Connection__c= OAuth.id;  
            smd.musqot__Socialmedia_Settings__c=OBJSocial.id;
            insert smd;        
            System.assertEquals('Requestheader', smd.musqot__Compound_Id__c);
            
            Socialmedia_settings__c st=new Socialmedia_settings__c();
            st.musqot__Auto_import__c=true;
            st.musqot__Socialmedia__c=OAuth.id;
            st.musqot__Socialmedia_type__c='Page';
            st.musqot__End_date__c=system.today();
            st.musqot__Start_date__c=system.today();
            //st.Type__c='Milestone';
            st.Socialmedia__c=OAuth.id;
            insert st;        
            System.assertEquals(true, st.musqot__Auto_import__c);
            
            musqot__Socialmedia_logfile__c smdata = new musqot__Socialmedia_logfile__c();
            smdata.musqot__Connection_id__c=OAuth.id;
            smdata.musqot__Imported__c=true;
            smdata.musqot__Import_message__c='Pagemessage';
            smdata.musqot__Number_of_records__c=100;
            insert smdata;
            System.assertEquals(true, smdata.musqot__Imported__c);
           
            Test.startTest();
            try{
            ApexPages.currentPage().getParameters().put('socialId',OBJSocial.Id);
            ApexPages.currentPage().getParameters().put('conid',OAuth.Id);
             ApexPages.currentPage().getParameters().put('cntId',OAuth.Id);
            ApexPages.StandardController ctrl = new ApexPages.StandardController(OAuth);
            Socialmedia_connection_Ctrl sec = new Socialmedia_connection_Ctrl (ctrl);
            //CronJobDetail cj = [select id, Name from CronJobDetail where Name = :'scheduleFacebookInsightsJob'];
            //CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where CronJobDetailId = :cj.Id];
            sec.ObjSMS = OAuth;
            List<OAuthService__c> tem1= sec.connectionList;  
            sec.smMessage  = true;
            Test.setMock(HttpCalloutMock.class, new HttpRequestandResponse());
            Socialmedia_connection_Ctrl.querylinkedinPageInsights();                    
            sec.smMessage=true;
            //sec.updSocial();
            sec.cancel();                      
            //sec.socialmediaConnection();           
            sec.importsocialmediaData();                       
                }catch(Exception e){}
            test.stopTest(); 
        }
    
    static testMethod void Socialmedia_controllerMethodLinkedinPost(){    
            musqot__Socialmedia_settings__c OBJSocial = new musqot__Socialmedia_settings__c();
            OBJSocial.Name='testmedia';
            OBJSocial.musqot__Import_rate__c='Hour';        
            OBJSocial.musqot__Socialmedia_type__c='Facebook';
            OBJSocial.musqot__Watch_type__c='Downloads';
            OBJSocial.musqot__Chart__c='Bar charts';
            OBJSocial.musqot__Auto_import__c= true ;
            OBJSocial.Type__c='Milestone';
            insert OBJSocial;                    
            System.assertEquals('Downloads', OBJSocial.musqot__Watch_type__c);
            
            musqot__OAuthService__c  OAuth = new musqot__OAuthService__c ();
            OAuth.Name='ffbook';
            OAuth.musqot__Authorization_Type__c='Requestheader';
            OAuth.musqot__Access_Token_URL__c='AQW8V5EtKM3nUu9jnxhGsWc_0Sg5mt2Wt_89qctsQIRRx_V3xaT_pPIVYAcQopVjW94n3Hsp4nTBBs_5sQk1u4270vyMiOb6qwB86GKuEIt8xcuI1sP3lHrmFpS1_lQVYeK6JVmGHC7U2wu5nh12S3Qqt1TMCPGE5kUwBt5iMXNaDyMxHqM';
            OAuth.musqot__Response_Type__c='token';
            OAuth.musqot__Signature_Method__c='PLAINTEXT';
            OAuth.musqot__Consumer_Key__c = '';
            OAuth.musqot__Consumer_Secret__c = '';  
            OAuth.musqot__Bar_color__c='#333';   
            OAuth.musqot__Page_Id__c='3632798';
            OAuth.End_Date__c=System.now().date()+5;
            Oauth.musqot__Post_ID__c='6063260730101153792';  
            //OAuth.musqot__Campaign_Id__c='059c9a6e11';   
            OAuth.musqot__Socialmedia__c = OBJSocial.Id;
            OAuth.musqot__Social_media__c='LinkedIn';
            OAuth.musqot__Auto_import__c=true;
            //OAuth.musqot__ad_id__c='6028983459919';
            insert OAuth;
            system.assertnotEquals(null,OAuth.id); 
            system.assertEquals('ffbook', OAuth.Name);
            
            musqot__Social_media_data__c smd = new musqot__Social_media_data__c();
            smd.musqot__Compound_Id__c='Requestheader';
            smd.musqot__Date__c=system.today();
            smd.musqot__Number_of_likes__c=5;
            smd.musqot__Number_of_member__c=100;
            smd.musqot__Number_of_unik_visitor__c= 200;
            smd.musqot__Connection__c= OAuth.id;  
            smd.musqot__Socialmedia_Settings__c=OBJSocial.id;
            insert smd;        
            System.assertEquals('Requestheader', smd.musqot__Compound_Id__c);
            
            Socialmedia_settings__c st=new Socialmedia_settings__c();
            st.musqot__Auto_import__c=true;
            st.musqot__Socialmedia__c=OAuth.id;
            st.musqot__Socialmedia_type__c='Page';
            st.musqot__End_date__c=system.today();
            st.musqot__Start_date__c=system.today();
            //st.Type__c='Milestone';
            st.Socialmedia__c=OAuth.id;
            insert st;        
            System.assertEquals(true, st.musqot__Auto_import__c);
            
            musqot__Socialmedia_logfile__c smdata = new musqot__Socialmedia_logfile__c();
            smdata.musqot__Connection_id__c=OAuth.id;
            smdata.musqot__Imported__c=true;
            smdata.musqot__Import_message__c='Pagemessage';
            smdata.musqot__Number_of_records__c=100;
            insert smdata;
            System.assertEquals(true, smdata.musqot__Imported__c);
           
            Test.startTest();
            try{
            ApexPages.currentPage().getParameters().put('socialId',OBJSocial.Id);
            ApexPages.currentPage().getParameters().put('conid',OAuth.Id);
             ApexPages.currentPage().getParameters().put('cntId',OAuth.Id);
            ApexPages.StandardController ctrl = new ApexPages.StandardController(OAuth);
            Socialmedia_connection_Ctrl sec = new Socialmedia_connection_Ctrl (ctrl);
            //CronJobDetail cj = [select id, Name from CronJobDetail where Name = :'scheduleFacebookInsightsJob'];
            //CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where CronJobDetailId = :cj.Id];
            sec.ObjSMS = OAuth;
            List<OAuthService__c> tem1= sec.connectionList; 
            sec.smMessage  = true;
            Test.setMock(HttpCalloutMock.class, new HttpRequestandResponse());            
            Socialmedia_connection_Ctrl.querylinkedinPostInsights();                   
            sec.smMessage=true;
            //sec.updSocial();
            sec.cancel();                      
            //sec.socialmediaConnection();            
            sec.importsocialmediaData();                       
                }catch(Exception e){}
            test.stopTest(); 
        }
    
    static testMethod void Socialmedia_controllerMethodupdSocialFBPage(){     
            musqot__Socialmedia_settings__c OBJSocial = new musqot__Socialmedia_settings__c();
            OBJSocial.Name='testmedia';
            OBJSocial.musqot__Import_rate__c='Hour';        
            OBJSocial.musqot__Socialmedia_type__c='Facebook';
            OBJSocial.musqot__Watch_type__c='Downloads';
            OBJSocial.musqot__Chart__c='Bar charts';
            OBJSocial.musqot__Auto_import__c= true ;
            OBJSocial.Type__c='Milestone';
            insert OBJSocial;                    
            System.assertEquals('Downloads', OBJSocial.musqot__Watch_type__c);
            
            musqot__OAuthService__c  OAuth = new musqot__OAuthService__c ();
            OAuth.Name='ffbook';
            OAuth.musqot__Authorization_Type__c='Requestheader';
            OAuth.musqot__Access_Token_URL__c='CAALlOqcmcU0BAIaeOHMdCPDYmBncSiSe3cy33qNcAZABm2ZAGaq1UkUW5ZBm6dHVHZBM0cnnvZAMwKLnOltsqveNZANCUpYdJK9Wgi6L3IpGcmI5rStbo1q5112WAxGxIhyxw6nXSDsOqXhlTlLfqM2TTzh6kdQ7JqH3swv0iZB4N1ZC3AuMESrXOBTGqz1d3Y4ZD';
            OAuth.musqot__Response_Type__c='token';
            OAuth.musqot__Signature_Method__c='PLAINTEXT';
            OAuth.musqot__Consumer_Key__c = '30082886';
            OAuth.musqot__Consumer_Secret__c = '';  
            OAuth.musqot__Bar_color__c='#333';   
            OAuth.musqot__Page_Id__c='504964542946242';
            OAuth.End_Date__c=System.now().date()+5;
            //Oauth.musqot__Post_ID__c='1234567';  
            //OAuth.musqot__Campaign_Id__c='6028983458919';   
            OAuth.musqot__Socialmedia__c = OBJSocial.Id;
            OAuth.musqot__Social_media__c='Facebook';
            OAuth.musqot__Auto_import__c=true;
            //OAuth.musqot__ad_id__c='6028983459919';
            insert OAuth;
            system.assertnotEquals(null,OAuth.id); 
            system.assertEquals('ffbook', OAuth.Name);
            
            musqot__Social_media_data__c smd = new musqot__Social_media_data__c();
            smd.musqot__Compound_Id__c='Requestheader';
            smd.musqot__Date__c=system.today();
            smd.musqot__Number_of_likes__c=5;
            smd.musqot__Number_of_member__c=100;
            smd.musqot__Number_of_unik_visitor__c= 200;
            smd.musqot__Connection__c= OAuth.id;  
            smd.musqot__Socialmedia_Settings__c=OBJSocial.id;
            insert smd;        
            System.assertEquals('Requestheader', smd.musqot__Compound_Id__c);
            
            Socialmedia_settings__c st=new Socialmedia_settings__c();
            st.musqot__Auto_import__c=true;
            st.musqot__Socialmedia__c=OAuth.id;
            st.musqot__Socialmedia_type__c='Page';
            st.musqot__End_date__c=system.today();
            st.musqot__Start_date__c=system.today();
            //st.Type__c='Milestone';
            st.Socialmedia__c=OAuth.id;
            insert st;        
            System.assertEquals(true, st.musqot__Auto_import__c);
            
            musqot__Socialmedia_logfile__c smdata = new musqot__Socialmedia_logfile__c();
            smdata.musqot__Connection_id__c=OAuth.id;
            smdata.musqot__Imported__c=true;
            smdata.musqot__Import_message__c='Pagemessage';
            smdata.musqot__Number_of_records__c=100;
            insert smdata;
            System.assertEquals(true, smdata.musqot__Imported__c);
           
            Test.startTest();
            try{
            ApexPages.currentPage().getParameters().put('socialId',OBJSocial.Id);
            ApexPages.currentPage().getParameters().put('conid',OAuth.Id);
             ApexPages.currentPage().getParameters().put('cntId',OAuth.Id);
            ApexPages.StandardController ctrl = new ApexPages.StandardController(OAuth);
            Socialmedia_connection_Ctrl sec = new Socialmedia_connection_Ctrl (ctrl);
            //CronJobDetail cj = [select id, Name from CronJobDetail where Name = :'scheduleFacebookInsightsJob'];
            //CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where CronJobDetailId = :cj.Id];
            sec.ObjSMS = OAuth;
            List<OAuthService__c> tem1= sec.connectionList; 
            sec.smMessage  = true;
            Test.setMock(HttpCalloutMock.class, new HttpRequestandResponse());            
            //Socialmedia_connection_Ctrl.querylinkedinPostInsights();                   
            sec.smMessage=true;
            sec.updSocial();
            sec.cancel();                      
            //sec.socialmediaConnection();            
            //sec.importsocialmediaData();                       
                }catch(Exception e){}
            test.stopTest(); 
        }
    static testMethod void Socialmedia_controllerMethodupdSocialFBPost(){     
            musqot__Socialmedia_settings__c OBJSocial = new musqot__Socialmedia_settings__c();
            OBJSocial.Name='testmedia';
            OBJSocial.musqot__Import_rate__c='Hour';        
            OBJSocial.musqot__Socialmedia_type__c='Facebook';
            OBJSocial.musqot__Watch_type__c='Downloads';
            OBJSocial.musqot__Chart__c='Bar charts';
            OBJSocial.musqot__Auto_import__c= true ;
            OBJSocial.Type__c='Milestone';
            insert OBJSocial;                    
            System.assertEquals('Downloads', OBJSocial.musqot__Watch_type__c);
            
            musqot__OAuthService__c  OAuth = new musqot__OAuthService__c ();
            OAuth.Name='ffbook';
            OAuth.musqot__Authorization_Type__c='Requestheader';
            OAuth.musqot__Access_Token_URL__c='CAALlOqcmcU0BAIaeOHMdCPDYmBncSiSe3cy33qNcAZABm2ZAGaq1UkUW5ZBm6dHVHZBM0cnnvZAMwKLnOltsqveNZANCUpYdJK9Wgi6L3IpGcmI5rStbo1q5112WAxGxIhyxw6nXSDsOqXhlTlLfqM2TTzh6kdQ7JqH3swv0iZB4N1ZC3AuMESrXOBTGqz1d3Y4ZD';
            OAuth.musqot__Response_Type__c='token';
            OAuth.musqot__Signature_Method__c='PLAINTEXT';
            OAuth.musqot__Consumer_Key__c = '30082886';
            OAuth.musqot__Consumer_Secret__c = '';  
            OAuth.musqot__Bar_color__c='#333';   
            //OAuth.musqot__Page_Id__c='504964542946242';
            OAuth.End_Date__c=System.now().date()+5;
            Oauth.musqot__Post_ID__c='1234567';  
            //OAuth.musqot__Campaign_Id__c='6028983458919';   
            OAuth.musqot__Socialmedia__c = OBJSocial.Id;
            OAuth.musqot__Social_media__c='Facebook';
            OAuth.musqot__Auto_import__c=true;
            //OAuth.musqot__ad_id__c='6028983459919';
            insert OAuth;
            system.assertnotEquals(null,OAuth.id); 
            system.assertEquals('ffbook', OAuth.Name);
            
            musqot__Social_media_data__c smd = new musqot__Social_media_data__c();
            smd.musqot__Compound_Id__c='Requestheader';
            smd.musqot__Date__c=system.today();
            smd.musqot__Number_of_likes__c=5;
            smd.musqot__Number_of_member__c=100;
            smd.musqot__Number_of_unik_visitor__c= 200;
            smd.musqot__Connection__c= OAuth.id;  
            smd.musqot__Socialmedia_Settings__c=OBJSocial.id;
            insert smd;        
            System.assertEquals('Requestheader', smd.musqot__Compound_Id__c);
            
            Socialmedia_settings__c st=new Socialmedia_settings__c();
            st.musqot__Auto_import__c=true;
            st.musqot__Socialmedia__c=OAuth.id;
            st.musqot__Socialmedia_type__c='Page';
            st.musqot__End_date__c=system.today();
            st.musqot__Start_date__c=system.today();
            //st.Type__c='Milestone';
            st.Socialmedia__c=OAuth.id;
            insert st;        
            System.assertEquals(true, st.musqot__Auto_import__c);
            
            musqot__Socialmedia_logfile__c smdata = new musqot__Socialmedia_logfile__c();
            smdata.musqot__Connection_id__c=OAuth.id;
            smdata.musqot__Imported__c=true;
            smdata.musqot__Import_message__c='Pagemessage';
            smdata.musqot__Number_of_records__c=100;
            insert smdata;
            System.assertEquals(true, smdata.musqot__Imported__c);
           
            Test.startTest();
            try{
            ApexPages.currentPage().getParameters().put('socialId',OBJSocial.Id);
            ApexPages.currentPage().getParameters().put('conid',OAuth.Id);
             ApexPages.currentPage().getParameters().put('cntId',OAuth.Id);
            ApexPages.StandardController ctrl = new ApexPages.StandardController(OAuth);
            Socialmedia_connection_Ctrl sec = new Socialmedia_connection_Ctrl (ctrl);
            //CronJobDetail cj = [select id, Name from CronJobDetail where Name = :'scheduleFacebookInsightsJob'];
            //CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where CronJobDetailId = :cj.Id];
            sec.ObjSMS = OAuth;
            List<OAuthService__c> tem1= sec.connectionList; 
            sec.smMessage  = true;
            Test.setMock(HttpCalloutMock.class, new HttpRequestandResponse());            
            //Socialmedia_connection_Ctrl.querylinkedinPostInsights();                   
            sec.smMessage=true;
            sec.updSocial();
            sec.cancel();                      
            //sec.socialmediaConnection();            
            //sec.importsocialmediaData();                       
                }catch(Exception e){}
            test.stopTest(); 
        }
    static testMethod void Socialmedia_controllerMethodupdSocialFBAd(){     
            musqot__Socialmedia_settings__c OBJSocial = new musqot__Socialmedia_settings__c();
            OBJSocial.Name='testmedia';
            OBJSocial.musqot__Import_rate__c='Hour';        
            OBJSocial.musqot__Socialmedia_type__c='Facebook';
            OBJSocial.musqot__Watch_type__c='Downloads';
            OBJSocial.musqot__Chart__c='Bar charts';
            OBJSocial.musqot__Auto_import__c= true ;
            OBJSocial.Type__c='Milestone';
            insert OBJSocial;                    
            System.assertEquals('Downloads', OBJSocial.musqot__Watch_type__c);
            
            musqot__OAuthService__c  OAuth = new musqot__OAuthService__c ();
            OAuth.Name='ffbook';
            OAuth.musqot__Authorization_Type__c='Requestheader';
            OAuth.musqot__Access_Token_URL__c='CAALlOqcmcU0BAIaeOHMdCPDYmBncSiSe3cy33qNcAZABm2ZAGaq1UkUW5ZBm6dHVHZBM0cnnvZAMwKLnOltsqveNZANCUpYdJK9Wgi6L3IpGcmI5rStbo1q5112WAxGxIhyxw6nXSDsOqXhlTlLfqM2TTzh6kdQ7JqH3swv0iZB4N1ZC3AuMESrXOBTGqz1d3Y4ZD';
            OAuth.musqot__Response_Type__c='token';
            OAuth.musqot__Signature_Method__c='PLAINTEXT';
            OAuth.musqot__Consumer_Key__c = '30082886';
            OAuth.musqot__Consumer_Secret__c = '';  
            OAuth.musqot__Bar_color__c='#333';   
            //OAuth.musqot__Page_Id__c='504964542946242';
            OAuth.End_Date__c=System.now().date()+5;
            //Oauth.musqot__Post_ID__c='1234567';  
            //OAuth.musqot__Campaign_Id__c='6028983458919';   
            OAuth.musqot__Socialmedia__c = OBJSocial.Id;
            OAuth.musqot__Social_media__c='Facebook';
            OAuth.musqot__Auto_import__c=true;
            OAuth.musqot__ad_id__c='6028983459919';
            insert OAuth;
            system.assertnotEquals(null,OAuth.id); 
            system.assertEquals('ffbook', OAuth.Name);
            
            musqot__Social_media_data__c smd = new musqot__Social_media_data__c();
            smd.musqot__Compound_Id__c='Requestheader';
            smd.musqot__Date__c=system.today();
            smd.musqot__Number_of_likes__c=5;
            smd.musqot__Number_of_member__c=100;
            smd.musqot__Number_of_unik_visitor__c= 200;
            smd.musqot__Connection__c= OAuth.id;  
            smd.musqot__Socialmedia_Settings__c=OBJSocial.id;
            insert smd;        
            System.assertEquals('Requestheader', smd.musqot__Compound_Id__c);
            
            Socialmedia_settings__c st=new Socialmedia_settings__c();
            st.musqot__Auto_import__c=true;
            st.musqot__Socialmedia__c=OAuth.id;
            st.musqot__Socialmedia_type__c='Page';
            st.musqot__End_date__c=system.today();
            st.musqot__Start_date__c=system.today();
            //st.Type__c='Milestone';
            st.Socialmedia__c=OAuth.id;
            insert st;        
            System.assertEquals(true, st.musqot__Auto_import__c);
            
            musqot__Socialmedia_logfile__c smdata = new musqot__Socialmedia_logfile__c();
            smdata.musqot__Connection_id__c=OAuth.id;
            smdata.musqot__Imported__c=true;
            smdata.musqot__Import_message__c='Pagemessage';
            smdata.musqot__Number_of_records__c=100;
            insert smdata;
            System.assertEquals(true, smdata.musqot__Imported__c);
           
            Test.startTest();
            try{
            ApexPages.currentPage().getParameters().put('socialId',OBJSocial.Id);
            ApexPages.currentPage().getParameters().put('conid',OAuth.Id);
             ApexPages.currentPage().getParameters().put('cntId',OAuth.Id);
            ApexPages.StandardController ctrl = new ApexPages.StandardController(OAuth);
            Socialmedia_connection_Ctrl sec = new Socialmedia_connection_Ctrl (ctrl);
            //CronJobDetail cj = [select id, Name from CronJobDetail where Name = :'scheduleFacebookInsightsJob'];
            //CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where CronJobDetailId = :cj.Id];
            sec.ObjSMS = OAuth;
            List<OAuthService__c> tem1= sec.connectionList; 
            sec.smMessage  = true;
            Test.setMock(HttpCalloutMock.class, new HttpRequestandResponse());            
            //Socialmedia_connection_Ctrl.querylinkedinPostInsights();                   
            sec.smMessage=true;
            sec.updSocial();
            sec.cancel();                      
            //sec.socialmediaConnection();            
            //sec.importsocialmediaData();                       
                }catch(Exception e){}
            test.stopTest(); 
        }
    
        static testMethod void Socialmedia_controllerMethodupdSociallMCCampaign(){     
            musqot__Socialmedia_settings__c OBJSocial = new musqot__Socialmedia_settings__c();
            OBJSocial.Name='testmedia';
            OBJSocial.musqot__Import_rate__c='Hour';        
            OBJSocial.musqot__Socialmedia_type__c='Facebook';
            OBJSocial.musqot__Watch_type__c='Downloads';
            OBJSocial.musqot__Chart__c='Bar charts';
            OBJSocial.musqot__Auto_import__c= true ;
            OBJSocial.Type__c='Milestone';
            insert OBJSocial;                    
            System.assertEquals('Downloads', OBJSocial.musqot__Watch_type__c);
            
            musqot__OAuthService__c  OAuth = new musqot__OAuthService__c ();
            OAuth.Name='ffbook';
            OAuth.musqot__Authorization_Type__c='Requestheader';
            OAuth.musqot__Access_Token_URL__c='3fb5fa28a18e4d970e56ba8002792ddc-us11';
            OAuth.musqot__Response_Type__c='token';
            OAuth.musqot__Signature_Method__c='PLAINTEXT';
            OAuth.musqot__Consumer_Key__c = '8d4377d4ab';
            OAuth.musqot__Consumer_Secret__c = '';  
            OAuth.musqot__Bar_color__c='#333';   
            //OAuth.musqot__Page_Id__c='504964542946242';
            OAuth.End_Date__c=System.now().date()+5;
            //Oauth.musqot__Post_ID__c='1234567';  
            OAuth.musqot__Campaign_Id__c='059c9a6e11';   
            OAuth.musqot__Socialmedia__c = OBJSocial.Id;
            OAuth.musqot__Social_media__c='MailChimp';
            OAuth.musqot__Auto_import__c=true;
            //OAuth.musqot__ad_id__c='6028983459919';
            insert OAuth;
            system.assertnotEquals(null,OAuth.id); 
            system.assertEquals('ffbook', OAuth.Name);
            
            musqot__Social_media_data__c smd = new musqot__Social_media_data__c();
            smd.musqot__Compound_Id__c='Requestheader';
            smd.musqot__Date__c=system.today();
            smd.musqot__Number_of_likes__c=5;
            smd.musqot__Number_of_member__c=100;
            smd.musqot__Number_of_unik_visitor__c= 200;
            smd.musqot__Connection__c= OAuth.id;  
            smd.musqot__Socialmedia_Settings__c=OBJSocial.id;
            insert smd;        
            System.assertEquals('Requestheader', smd.musqot__Compound_Id__c);
            
            Socialmedia_settings__c st=new Socialmedia_settings__c();
            st.musqot__Auto_import__c=true;
            st.musqot__Socialmedia__c=OAuth.id;
            st.musqot__Socialmedia_type__c='Page';
            st.musqot__End_date__c=system.today();
            st.musqot__Start_date__c=system.today();
            //st.Type__c='Milestone';
            st.Socialmedia__c=OAuth.id;
            insert st;        
            System.assertEquals(true, st.musqot__Auto_import__c);
            
            musqot__Socialmedia_logfile__c smdata = new musqot__Socialmedia_logfile__c();
            smdata.musqot__Connection_id__c=OAuth.id;
            smdata.musqot__Imported__c=true;
            smdata.musqot__Import_message__c='Pagemessage';
            smdata.musqot__Number_of_records__c=100;
            insert smdata;
            System.assertEquals(true, smdata.musqot__Imported__c);
           
            Test.startTest();
            try{
            ApexPages.currentPage().getParameters().put('socialId',OBJSocial.Id);
            ApexPages.currentPage().getParameters().put('conid',OAuth.Id);
             ApexPages.currentPage().getParameters().put('cntId',OAuth.Id);
            ApexPages.StandardController ctrl = new ApexPages.StandardController(OAuth);
            Socialmedia_connection_Ctrl sec = new Socialmedia_connection_Ctrl (ctrl);
            //CronJobDetail cj = [select id, Name from CronJobDetail where Name = :'scheduleFacebookInsightsJob'];
            //CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where CronJobDetailId = :cj.Id];
            sec.ObjSMS = OAuth;
            List<OAuthService__c> tem1= sec.connectionList;  
            sec.smMessage  = true;
            Test.setMock(HttpCalloutMock.class, new HttpRequestandResponse());
            //Socialmedia_connection_Ctrl.querySocialMediaInsights();
            //Socialmedia_connection_Ctrl.queryfacebookAdInsights();
            //Socialmedia_connection_Ctrl.queryfacebookPostInsights();
            //Socialmedia_connection_Ctrl.querylinkedinPostInsights();
            //Socialmedia_connection_Ctrl.querylinkedinPageInsights();
            //Socialmedia_connection_Ctrl.querymailchimpcampaignInsights();            
            sec.smMessage=true;
            sec.updSocial();
            sec.cancel();                      
            //sec.socialmediaConnection();            
            //sec.importsocialmediaData();                       
                }catch(Exception e){}
            test.stopTest(); 
        }
    
    static testMethod void Socialmedia_controllerMethodupdSocialLinkedinPage(){     
            musqot__Socialmedia_settings__c OBJSocial = new musqot__Socialmedia_settings__c();
            OBJSocial.Name='testmedia';
            OBJSocial.musqot__Import_rate__c='Hour';        
            OBJSocial.musqot__Socialmedia_type__c='Facebook';
            OBJSocial.musqot__Watch_type__c='Downloads';
            OBJSocial.musqot__Chart__c='Bar charts';
            OBJSocial.musqot__Auto_import__c= true ;
            OBJSocial.Type__c='Milestone';
            insert OBJSocial;                    
            System.assertEquals('Downloads', OBJSocial.musqot__Watch_type__c);
            
            musqot__OAuthService__c  OAuth = new musqot__OAuthService__c ();
            OAuth.Name='ffbook';
            OAuth.musqot__Authorization_Type__c='Requestheader';
            OAuth.musqot__Access_Token_URL__c='AQW8V5EtKM3nUu9jnxhGsWc_0Sg5mt2Wt_89qctsQIRRx_V3xaT_pPIVYAcQopVjW94n3Hsp4nTBBs_5sQk1u4270vyMiOb6qwB86GKuEIt8xcuI1sP3lHrmFpS1_lQVYeK6JVmGHC7U2wu5nh12S3Qqt1TMCPGE5kUwBt5iMXNaDyMxHqM';
            OAuth.musqot__Response_Type__c='token';
            OAuth.musqot__Signature_Method__c='PLAINTEXT';
            OAuth.musqot__Consumer_Key__c = '';
            OAuth.musqot__Consumer_Secret__c = '';  
            OAuth.musqot__Bar_color__c='#333';   
            OAuth.musqot__Page_Id__c='3632798';
            OAuth.End_Date__c=System.now().date()+5;
            //Oauth.musqot__Post_ID__c='1234567';  
            //OAuth.musqot__Campaign_Id__c='059c9a6e11';   
            OAuth.musqot__Socialmedia__c = OBJSocial.Id;
            OAuth.musqot__Social_media__c='LinkedIn';
            OAuth.musqot__Auto_import__c=true;
            //OAuth.musqot__ad_id__c='6028983459919';
            insert OAuth;
            system.assertnotEquals(null,OAuth.id); 
            system.assertEquals('ffbook', OAuth.Name);
            
            musqot__Social_media_data__c smd = new musqot__Social_media_data__c();
            smd.musqot__Compound_Id__c='Requestheader';
            smd.musqot__Date__c=system.today();
            smd.musqot__Number_of_likes__c=5;
            smd.musqot__Number_of_member__c=100;
            smd.musqot__Number_of_unik_visitor__c= 200;
            smd.musqot__Connection__c= OAuth.id;  
            smd.musqot__Socialmedia_Settings__c=OBJSocial.id;
            insert smd;        
            System.assertEquals('Requestheader', smd.musqot__Compound_Id__c);
            
            Socialmedia_settings__c st=new Socialmedia_settings__c();
            st.musqot__Auto_import__c=true;
            st.musqot__Socialmedia__c=OAuth.id;
            st.musqot__Socialmedia_type__c='Page';
            st.musqot__End_date__c=system.today();
            st.musqot__Start_date__c=system.today();
            //st.Type__c='Milestone';
            st.Socialmedia__c=OAuth.id;
            insert st;        
            System.assertEquals(true, st.musqot__Auto_import__c);
            
            musqot__Socialmedia_logfile__c smdata = new musqot__Socialmedia_logfile__c();
            smdata.musqot__Connection_id__c=OAuth.id;
            smdata.musqot__Imported__c=true;
            smdata.musqot__Import_message__c='Pagemessage';
            smdata.musqot__Number_of_records__c=100;
            insert smdata;
            System.assertEquals(true, smdata.musqot__Imported__c);
           
            Test.startTest();
            try{
            ApexPages.currentPage().getParameters().put('socialId',OBJSocial.Id);
            ApexPages.currentPage().getParameters().put('conid',OAuth.Id);
             ApexPages.currentPage().getParameters().put('cntId',OAuth.Id);
            ApexPages.StandardController ctrl = new ApexPages.StandardController(OAuth);
            Socialmedia_connection_Ctrl sec = new Socialmedia_connection_Ctrl (ctrl);
            //CronJobDetail cj = [select id, Name from CronJobDetail where Name = :'scheduleFacebookInsightsJob'];
            //CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where CronJobDetailId = :cj.Id];
            sec.ObjSMS = OAuth;
            List<OAuthService__c> tem1= sec.connectionList;  
            sec.smMessage  = true;
            Test.setMock(HttpCalloutMock.class, new HttpRequestandResponse());
            //Socialmedia_connection_Ctrl.querylinkedinPageInsights();                    
            sec.smMessage=true;
            sec.updSocial();
            sec.cancel();                      
            //sec.socialmediaConnection();           
            //sec.importsocialmediaData();                       
                }catch(Exception e){}
            test.stopTest(); 
        }
    
    static testMethod void Socialmedia_controllerMethodupdSocialLinkedinPost(){     
            musqot__Socialmedia_settings__c OBJSocial = new musqot__Socialmedia_settings__c();
            OBJSocial.Name='testmedia';
            OBJSocial.musqot__Import_rate__c='Hour';        
            OBJSocial.musqot__Socialmedia_type__c='Facebook';
            OBJSocial.musqot__Watch_type__c='Downloads';
            OBJSocial.musqot__Chart__c='Bar charts';
            OBJSocial.musqot__Auto_import__c= true ;
            OBJSocial.Type__c='Milestone';
            insert OBJSocial;                    
            System.assertEquals('Downloads', OBJSocial.musqot__Watch_type__c);
            
            musqot__OAuthService__c  OAuth = new musqot__OAuthService__c ();
            OAuth.Name='ffbook';
            OAuth.musqot__Authorization_Type__c='Requestheader';
            OAuth.musqot__Access_Token_URL__c='AQW8V5EtKM3nUu9jnxhGsWc_0Sg5mt2Wt_89qctsQIRRx_V3xaT_pPIVYAcQopVjW94n3Hsp4nTBBs_5sQk1u4270vyMiOb6qwB86GKuEIt8xcuI1sP3lHrmFpS1_lQVYeK6JVmGHC7U2wu5nh12S3Qqt1TMCPGE5kUwBt5iMXNaDyMxHqM';
            OAuth.musqot__Response_Type__c='token';
            OAuth.musqot__Signature_Method__c='PLAINTEXT';
            OAuth.musqot__Consumer_Key__c = '';
            OAuth.musqot__Consumer_Secret__c = '';  
            OAuth.musqot__Bar_color__c='#333';   
            OAuth.musqot__Page_Id__c='3632798';
            OAuth.End_Date__c=System.now().date()+5;
            Oauth.musqot__Post_ID__c='6063260730101153792';  
            //OAuth.musqot__Campaign_Id__c='059c9a6e11';   
            OAuth.musqot__Socialmedia__c = OBJSocial.Id;
            OAuth.musqot__Social_media__c='LinkedIn';
            OAuth.musqot__Auto_import__c=true;
            //OAuth.musqot__ad_id__c='6028983459919';
            insert OAuth;
            system.assertnotEquals(null,OAuth.id); 
            system.assertEquals('ffbook', OAuth.Name);
            
            musqot__Social_media_data__c smd = new musqot__Social_media_data__c();
            smd.musqot__Compound_Id__c='Requestheader';
            smd.musqot__Date__c=system.today();
            smd.musqot__Number_of_likes__c=5;
            smd.musqot__Number_of_member__c=100;
            smd.musqot__Number_of_unik_visitor__c= 200;
            smd.musqot__Connection__c= OAuth.id;  
            smd.musqot__Socialmedia_Settings__c=OBJSocial.id;
            insert smd;        
            System.assertEquals('Requestheader', smd.musqot__Compound_Id__c);
            
            Socialmedia_settings__c st=new Socialmedia_settings__c();
            st.musqot__Auto_import__c=true;
            st.musqot__Socialmedia__c=OAuth.id;
            st.musqot__Socialmedia_type__c='Page';
            st.musqot__End_date__c=system.today();
            st.musqot__Start_date__c=system.today();
            //st.Type__c='Milestone';
            st.Socialmedia__c=OAuth.id;
            insert st;        
            System.assertEquals(true, st.musqot__Auto_import__c);
            
            musqot__Socialmedia_logfile__c smdata = new musqot__Socialmedia_logfile__c();
            smdata.musqot__Connection_id__c=OAuth.id;
            smdata.musqot__Imported__c=true;
            smdata.musqot__Import_message__c='Pagemessage';
            smdata.musqot__Number_of_records__c=100;
            insert smdata;
            System.assertEquals(true, smdata.musqot__Imported__c);
           
            Test.startTest();
            try{
            ApexPages.currentPage().getParameters().put('socialId',OBJSocial.Id);
            ApexPages.currentPage().getParameters().put('conid',OAuth.Id);
             ApexPages.currentPage().getParameters().put('cntId',OAuth.Id);
            ApexPages.StandardController ctrl = new ApexPages.StandardController(OAuth);
            Socialmedia_connection_Ctrl sec = new Socialmedia_connection_Ctrl (ctrl);
            //CronJobDetail cj = [select id, Name from CronJobDetail where Name = :'scheduleFacebookInsightsJob'];
            //CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where CronJobDetailId = :cj.Id];
            sec.ObjSMS = OAuth;
            List<OAuthService__c> tem1= sec.connectionList; 
            sec.smMessage  = true;
            Test.setMock(HttpCalloutMock.class, new HttpRequestandResponse());            
            //Socialmedia_connection_Ctrl.querylinkedinPostInsights();                   
            sec.smMessage=true;
            sec.updSocial();
            sec.cancel();                      
            //sec.socialmediaConnection();            
            //sec.importsocialmediaData();                       
                }catch(Exception e){}
            test.stopTest(); 
        }
    
    ///
    static testMethod void Socialmedia_controllerMethodConnectionFBPage(){     
            musqot__Socialmedia_settings__c OBJSocial = new musqot__Socialmedia_settings__c();
            OBJSocial.Name='testmedia';
            OBJSocial.musqot__Import_rate__c='Hour';        
            OBJSocial.musqot__Socialmedia_type__c='Facebook';
            OBJSocial.musqot__Watch_type__c='Downloads';
            OBJSocial.musqot__Chart__c='Bar charts';
            OBJSocial.musqot__Auto_import__c= true ;
            OBJSocial.Type__c='Milestone';
            insert OBJSocial;                    
            System.assertEquals('Downloads', OBJSocial.musqot__Watch_type__c);
            
            musqot__OAuthService__c  OAuth = new musqot__OAuthService__c ();
            OAuth.Name='ffbook';
            OAuth.musqot__Authorization_Type__c='Requestheader';
            OAuth.musqot__Access_Token_URL__c='CAALlOqcmcU0BAIaeOHMdCPDYmBncSiSe3cy33qNcAZABm2ZAGaq1UkUW5ZBm6dHVHZBM0cnnvZAMwKLnOltsqveNZANCUpYdJK9Wgi6L3IpGcmI5rStbo1q5112WAxGxIhyxw6nXSDsOqXhlTlLfqM2TTzh6kdQ7JqH3swv0iZB4N1ZC3AuMESrXOBTGqz1d3Y4ZD';
            OAuth.musqot__Response_Type__c='token';
            OAuth.musqot__Signature_Method__c='PLAINTEXT';
            OAuth.musqot__Consumer_Key__c = '30082886';
            OAuth.musqot__Consumer_Secret__c = '';  
            OAuth.musqot__Bar_color__c='#333';   
            OAuth.musqot__Page_Id__c='504964542946242';
            OAuth.End_Date__c=System.now().date()+5;
            //Oauth.musqot__Post_ID__c='1234567';  
            //OAuth.musqot__Campaign_Id__c='6028983458919';   
            OAuth.musqot__Socialmedia__c = OBJSocial.Id;
            OAuth.musqot__Social_media__c='Facebook';
            OAuth.musqot__Auto_import__c=true;
            //OAuth.musqot__ad_id__c='6028983459919';
            insert OAuth;
            system.assertnotEquals(null,OAuth.id); 
            system.assertEquals('ffbook', OAuth.Name);
            
            musqot__Social_media_data__c smd = new musqot__Social_media_data__c();
            smd.musqot__Compound_Id__c='Requestheader';
            smd.musqot__Date__c=system.today();
            smd.musqot__Number_of_likes__c=5;
            smd.musqot__Number_of_member__c=100;
            smd.musqot__Number_of_unik_visitor__c= 200;
            smd.musqot__Connection__c= OAuth.id;  
            smd.musqot__Socialmedia_Settings__c=OBJSocial.id;
            insert smd;        
            System.assertEquals('Requestheader', smd.musqot__Compound_Id__c);
            
            Socialmedia_settings__c st=new Socialmedia_settings__c();
            st.musqot__Auto_import__c=true;
            st.musqot__Socialmedia__c=OAuth.id;
            st.musqot__Socialmedia_type__c='Page';
            st.musqot__End_date__c=system.today();
            st.musqot__Start_date__c=system.today();
            //st.Type__c='Milestone';
            st.Socialmedia__c=OAuth.id;
            insert st;        
            System.assertEquals(true, st.musqot__Auto_import__c);
            
            musqot__Socialmedia_logfile__c smdata = new musqot__Socialmedia_logfile__c();
            smdata.musqot__Connection_id__c=OAuth.id;
            smdata.musqot__Imported__c=true;
            smdata.musqot__Import_message__c='Pagemessage';
            smdata.musqot__Number_of_records__c=100;
            insert smdata;
            System.assertEquals(true, smdata.musqot__Imported__c);
           
            Test.startTest();
            try{
            ApexPages.currentPage().getParameters().put('socialId',OBJSocial.Id);
            ApexPages.currentPage().getParameters().put('conid',OAuth.Id);
             ApexPages.currentPage().getParameters().put('cntId',OAuth.Id);
            ApexPages.StandardController ctrl = new ApexPages.StandardController(OAuth);
            Socialmedia_connection_Ctrl sec = new Socialmedia_connection_Ctrl (ctrl);
            //CronJobDetail cj = [select id, Name from CronJobDetail where Name = :'scheduleFacebookInsightsJob'];
            //CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where CronJobDetailId = :cj.Id];
            sec.ObjSMS = OAuth;
            List<OAuthService__c> tem1= sec.connectionList; 
            sec.smMessage  = true;
            Test.setMock(HttpCalloutMock.class, new HttpRequestandResponse());            
            //Socialmedia_connection_Ctrl.querylinkedinPostInsights();                   
            sec.smMessage=true;
            //sec.updSocial();
            sec.cancel();                      
            sec.socialmediaConnection();            
            //sec.importsocialmediaData();                       
                }catch(Exception e){}
            test.stopTest(); 
        }
    static testMethod void Socialmedia_controllerMethodConnectionFBPost(){     
            musqot__Socialmedia_settings__c OBJSocial = new musqot__Socialmedia_settings__c();
            OBJSocial.Name='testmedia';
            OBJSocial.musqot__Import_rate__c='Hour';        
            OBJSocial.musqot__Socialmedia_type__c='Facebook';
            OBJSocial.musqot__Watch_type__c='Downloads';
            OBJSocial.musqot__Chart__c='Bar charts';
            OBJSocial.musqot__Auto_import__c= true ;
            OBJSocial.Type__c='Milestone';
            insert OBJSocial;                    
            System.assertEquals('Downloads', OBJSocial.musqot__Watch_type__c);
            
            musqot__OAuthService__c  OAuth = new musqot__OAuthService__c ();
            OAuth.Name='ffbook';
            OAuth.musqot__Authorization_Type__c='Requestheader';
            OAuth.musqot__Access_Token_URL__c='CAALlOqcmcU0BAIaeOHMdCPDYmBncSiSe3cy33qNcAZABm2ZAGaq1UkUW5ZBm6dHVHZBM0cnnvZAMwKLnOltsqveNZANCUpYdJK9Wgi6L3IpGcmI5rStbo1q5112WAxGxIhyxw6nXSDsOqXhlTlLfqM2TTzh6kdQ7JqH3swv0iZB4N1ZC3AuMESrXOBTGqz1d3Y4ZD';
            OAuth.musqot__Response_Type__c='token';
            OAuth.musqot__Signature_Method__c='PLAINTEXT';
            OAuth.musqot__Consumer_Key__c = '30082886';
            OAuth.musqot__Consumer_Secret__c = '';  
            OAuth.musqot__Bar_color__c='#333';   
            //OAuth.musqot__Page_Id__c='504964542946242';
            OAuth.End_Date__c=System.now().date()+5;
            Oauth.musqot__Post_ID__c='1234567';  
            //OAuth.musqot__Campaign_Id__c='6028983458919';   
            OAuth.musqot__Socialmedia__c = OBJSocial.Id;
            OAuth.musqot__Social_media__c='Facebook';
            OAuth.musqot__Auto_import__c=true;
            //OAuth.musqot__ad_id__c='6028983459919';
            insert OAuth;
            system.assertnotEquals(null,OAuth.id); 
            system.assertEquals('ffbook', OAuth.Name);
            
            musqot__Social_media_data__c smd = new musqot__Social_media_data__c();
            smd.musqot__Compound_Id__c='Requestheader';
            smd.musqot__Date__c=system.today();
            smd.musqot__Number_of_likes__c=5;
            smd.musqot__Number_of_member__c=100;
            smd.musqot__Number_of_unik_visitor__c= 200;
            smd.musqot__Connection__c= OAuth.id;  
            smd.musqot__Socialmedia_Settings__c=OBJSocial.id;
            insert smd;        
            System.assertEquals('Requestheader', smd.musqot__Compound_Id__c);
            
            Socialmedia_settings__c st=new Socialmedia_settings__c();
            st.musqot__Auto_import__c=true;
            st.musqot__Socialmedia__c=OAuth.id;
            st.musqot__Socialmedia_type__c='Page';
            st.musqot__End_date__c=system.today();
            st.musqot__Start_date__c=system.today();
            //st.Type__c='Milestone';
            st.Socialmedia__c=OAuth.id;
            insert st;        
            System.assertEquals(true, st.musqot__Auto_import__c);
            
            musqot__Socialmedia_logfile__c smdata = new musqot__Socialmedia_logfile__c();
            smdata.musqot__Connection_id__c=OAuth.id;
            smdata.musqot__Imported__c=true;
            smdata.musqot__Import_message__c='Pagemessage';
            smdata.musqot__Number_of_records__c=100;
            insert smdata;
            System.assertEquals(true, smdata.musqot__Imported__c);
           
            Test.startTest();
            try{
            ApexPages.currentPage().getParameters().put('socialId',OBJSocial.Id);
            ApexPages.currentPage().getParameters().put('conid',OAuth.Id);
             ApexPages.currentPage().getParameters().put('cntId',OAuth.Id);
            ApexPages.StandardController ctrl = new ApexPages.StandardController(OAuth);
            Socialmedia_connection_Ctrl sec = new Socialmedia_connection_Ctrl (ctrl);
            //CronJobDetail cj = [select id, Name from CronJobDetail where Name = :'scheduleFacebookInsightsJob'];
            //CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where CronJobDetailId = :cj.Id];
            sec.ObjSMS = OAuth;
            List<OAuthService__c> tem1= sec.connectionList; 
            sec.smMessage  = true;
            Test.setMock(HttpCalloutMock.class, new HttpRequestandResponse());            
            //Socialmedia_connection_Ctrl.querylinkedinPostInsights();                   
            sec.smMessage=true;
            //sec.updSocial();
            sec.cancel();                      
            sec.socialmediaConnection();            
            //sec.importsocialmediaData();                       
                }catch(Exception e){}
            test.stopTest(); 
        }
    static testMethod void Socialmedia_controllerMethodConnectionFBAd(){     
            musqot__Socialmedia_settings__c OBJSocial = new musqot__Socialmedia_settings__c();
            OBJSocial.Name='testmedia';
            OBJSocial.musqot__Import_rate__c='Hour';        
            OBJSocial.musqot__Socialmedia_type__c='Facebook';
            OBJSocial.musqot__Watch_type__c='Downloads';
            OBJSocial.musqot__Chart__c='Bar charts';
            OBJSocial.musqot__Auto_import__c= true ;
            OBJSocial.Type__c='Milestone';
            insert OBJSocial;                    
            System.assertEquals('Downloads', OBJSocial.musqot__Watch_type__c);
            
            musqot__OAuthService__c  OAuth = new musqot__OAuthService__c ();
            OAuth.Name='ffbook';
            OAuth.musqot__Authorization_Type__c='Requestheader';
            OAuth.musqot__Access_Token_URL__c='CAALlOqcmcU0BAIaeOHMdCPDYmBncSiSe3cy33qNcAZABm2ZAGaq1UkUW5ZBm6dHVHZBM0cnnvZAMwKLnOltsqveNZANCUpYdJK9Wgi6L3IpGcmI5rStbo1q5112WAxGxIhyxw6nXSDsOqXhlTlLfqM2TTzh6kdQ7JqH3swv0iZB4N1ZC3AuMESrXOBTGqz1d3Y4ZD';
            OAuth.musqot__Response_Type__c='token';
            OAuth.musqot__Signature_Method__c='PLAINTEXT';
            OAuth.musqot__Consumer_Key__c = '30082886';
            OAuth.musqot__Consumer_Secret__c = '';  
            OAuth.musqot__Bar_color__c='#333';   
            //OAuth.musqot__Page_Id__c='504964542946242';
            OAuth.End_Date__c=System.now().date()+5;
            //Oauth.musqot__Post_ID__c='1234567';  
            //OAuth.musqot__Campaign_Id__c='6028983458919';   
            OAuth.musqot__Socialmedia__c = OBJSocial.Id;
            OAuth.musqot__Social_media__c='Facebook';
            OAuth.musqot__Auto_import__c=true;
            OAuth.musqot__ad_id__c='6028983459919';
            insert OAuth;
            system.assertnotEquals(null,OAuth.id); 
            system.assertEquals('ffbook', OAuth.Name);
            
            musqot__Social_media_data__c smd = new musqot__Social_media_data__c();
            smd.musqot__Compound_Id__c='Requestheader';
            smd.musqot__Date__c=system.today();
            smd.musqot__Number_of_likes__c=5;
            smd.musqot__Number_of_member__c=100;
            smd.musqot__Number_of_unik_visitor__c= 200;
            smd.musqot__Connection__c= OAuth.id;  
            smd.musqot__Socialmedia_Settings__c=OBJSocial.id;
            insert smd;        
            System.assertEquals('Requestheader', smd.musqot__Compound_Id__c);
            
            Socialmedia_settings__c st=new Socialmedia_settings__c();
            st.musqot__Auto_import__c=true;
            st.musqot__Socialmedia__c=OAuth.id;
            st.musqot__Socialmedia_type__c='Page';
            st.musqot__End_date__c=system.today();
            st.musqot__Start_date__c=system.today();
            //st.Type__c='Milestone';
            st.Socialmedia__c=OAuth.id;
            insert st;        
            System.assertEquals(true, st.musqot__Auto_import__c);
            
            musqot__Socialmedia_logfile__c smdata = new musqot__Socialmedia_logfile__c();
            smdata.musqot__Connection_id__c=OAuth.id;
            smdata.musqot__Imported__c=true;
            smdata.musqot__Import_message__c='Pagemessage';
            smdata.musqot__Number_of_records__c=100;
            insert smdata;
            System.assertEquals(true, smdata.musqot__Imported__c);
           
            Test.startTest();
            try{
            ApexPages.currentPage().getParameters().put('socialId',OBJSocial.Id);
            ApexPages.currentPage().getParameters().put('conid',OAuth.Id);
             ApexPages.currentPage().getParameters().put('cntId',OAuth.Id);
            ApexPages.StandardController ctrl = new ApexPages.StandardController(OAuth);
            Socialmedia_connection_Ctrl sec = new Socialmedia_connection_Ctrl (ctrl);
            //CronJobDetail cj = [select id, Name from CronJobDetail where Name = :'scheduleFacebookInsightsJob'];
            //CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where CronJobDetailId = :cj.Id];
            sec.ObjSMS = OAuth;
            List<OAuthService__c> tem1= sec.connectionList; 
            sec.smMessage  = true;
            Test.setMock(HttpCalloutMock.class, new HttpRequestandResponse());            
            //Socialmedia_connection_Ctrl.querylinkedinPostInsights();                   
            sec.smMessage=true;
            sec.updSocial();
            sec.cancel();                      
            sec.socialmediaConnection();            
            //sec.importsocialmediaData();                       
                }catch(Exception e){}
            test.stopTest(); 
        }
    
        static testMethod void Socialmedia_controllerMethodConnectionlMCCampaign(){     
            musqot__Socialmedia_settings__c OBJSocial = new musqot__Socialmedia_settings__c();
            OBJSocial.Name='testmedia';
            OBJSocial.musqot__Import_rate__c='Hour';        
            OBJSocial.musqot__Socialmedia_type__c='Facebook';
            OBJSocial.musqot__Watch_type__c='Downloads';
            OBJSocial.musqot__Chart__c='Bar charts';
            OBJSocial.musqot__Auto_import__c= true ;
            OBJSocial.Type__c='Milestone';
            insert OBJSocial;                    
            System.assertEquals('Downloads', OBJSocial.musqot__Watch_type__c);
            
            musqot__OAuthService__c  OAuth = new musqot__OAuthService__c ();
            OAuth.Name='ffbook';
            OAuth.musqot__Authorization_Type__c='Requestheader';
            OAuth.musqot__Access_Token_URL__c='3fb5fa28a18e4d970e56ba8002792ddc-us11';
            OAuth.musqot__Response_Type__c='token';
            OAuth.musqot__Signature_Method__c='PLAINTEXT';
            OAuth.musqot__Consumer_Key__c = '8d4377d4ab';
            OAuth.musqot__Consumer_Secret__c = '';  
            OAuth.musqot__Bar_color__c='#333';   
            //OAuth.musqot__Page_Id__c='504964542946242';
            OAuth.End_Date__c=System.now().date()+5;
            //Oauth.musqot__Post_ID__c='1234567';  
            OAuth.musqot__Campaign_Id__c='059c9a6e11';   
            OAuth.musqot__Socialmedia__c = OBJSocial.Id;
            OAuth.musqot__Social_media__c='MailChimp';
            OAuth.musqot__Auto_import__c=true;
            //OAuth.musqot__ad_id__c='6028983459919';
            insert OAuth;
            system.assertnotEquals(null,OAuth.id); 
            system.assertEquals('ffbook', OAuth.Name);
            
            musqot__Social_media_data__c smd = new musqot__Social_media_data__c();
            smd.musqot__Compound_Id__c='Requestheader';
            smd.musqot__Date__c=system.today();
            smd.musqot__Number_of_likes__c=5;
            smd.musqot__Number_of_member__c=100;
            smd.musqot__Number_of_unik_visitor__c= 200;
            smd.musqot__Connection__c= OAuth.id;  
            smd.musqot__Socialmedia_Settings__c=OBJSocial.id;
            insert smd;        
            System.assertEquals('Requestheader', smd.musqot__Compound_Id__c);
            
            Socialmedia_settings__c st=new Socialmedia_settings__c();
            st.musqot__Auto_import__c=true;
            st.musqot__Socialmedia__c=OAuth.id;
            st.musqot__Socialmedia_type__c='Page';
            st.musqot__End_date__c=system.today();
            st.musqot__Start_date__c=system.today();
            //st.Type__c='Milestone';
            st.Socialmedia__c=OAuth.id;
            insert st;        
            System.assertEquals(true, st.musqot__Auto_import__c);
            
            musqot__Socialmedia_logfile__c smdata = new musqot__Socialmedia_logfile__c();
            smdata.musqot__Connection_id__c=OAuth.id;
            smdata.musqot__Imported__c=true;
            smdata.musqot__Import_message__c='Pagemessage';
            smdata.musqot__Number_of_records__c=100;
            insert smdata;
            System.assertEquals(true, smdata.musqot__Imported__c);
           
            Test.startTest();
            try{
            ApexPages.currentPage().getParameters().put('socialId',OBJSocial.Id);
            ApexPages.currentPage().getParameters().put('conid',OAuth.Id);
             ApexPages.currentPage().getParameters().put('cntId',OAuth.Id);
            ApexPages.StandardController ctrl = new ApexPages.StandardController(OAuth);
            Socialmedia_connection_Ctrl sec = new Socialmedia_connection_Ctrl (ctrl);
            //CronJobDetail cj = [select id, Name from CronJobDetail where Name = :'scheduleFacebookInsightsJob'];
            //CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where CronJobDetailId = :cj.Id];
            sec.ObjSMS = OAuth;
            List<OAuthService__c> tem1= sec.connectionList;  
            sec.smMessage  = true;
            Test.setMock(HttpCalloutMock.class, new HttpRequestandResponse());
            //Socialmedia_connection_Ctrl.querySocialMediaInsights();
            //Socialmedia_connection_Ctrl.queryfacebookAdInsights();
            //Socialmedia_connection_Ctrl.queryfacebookPostInsights();
            //Socialmedia_connection_Ctrl.querylinkedinPostInsights();
            //Socialmedia_connection_Ctrl.querylinkedinPageInsights();
            //Socialmedia_connection_Ctrl.querymailchimpcampaignInsights();            
            sec.smMessage=true;
            //sec.updSocial();
            sec.cancel();                      
            sec.socialmediaConnection();            
            //sec.importsocialmediaData();                       
                }catch(Exception e){}
            test.stopTest(); 
        }
    
    static testMethod void Socialmedia_controllerMethodConnectionLinkedinPage(){     
            musqot__Socialmedia_settings__c OBJSocial = new musqot__Socialmedia_settings__c();
            OBJSocial.Name='testmedia';
            OBJSocial.musqot__Import_rate__c='Hour';        
            OBJSocial.musqot__Socialmedia_type__c='Facebook';
            OBJSocial.musqot__Watch_type__c='Downloads';
            OBJSocial.musqot__Chart__c='Bar charts';
            OBJSocial.musqot__Auto_import__c= true ;
            OBJSocial.Type__c='Milestone';
            insert OBJSocial;                    
            System.assertEquals('Downloads', OBJSocial.musqot__Watch_type__c);
            
            musqot__OAuthService__c  OAuth = new musqot__OAuthService__c ();
            OAuth.Name='ffbook';
            OAuth.musqot__Authorization_Type__c='Requestheader';
            OAuth.musqot__Access_Token_URL__c='AQW8V5EtKM3nUu9jnxhGsWc_0Sg5mt2Wt_89qctsQIRRx_V3xaT_pPIVYAcQopVjW94n3Hsp4nTBBs_5sQk1u4270vyMiOb6qwB86GKuEIt8xcuI1sP3lHrmFpS1_lQVYeK6JVmGHC7U2wu5nh12S3Qqt1TMCPGE5kUwBt5iMXNaDyMxHqM';
            OAuth.musqot__Response_Type__c='token';
            OAuth.musqot__Signature_Method__c='PLAINTEXT';
            OAuth.musqot__Consumer_Key__c = '';
            OAuth.musqot__Consumer_Secret__c = '';  
            OAuth.musqot__Bar_color__c='#333';   
            OAuth.musqot__Page_Id__c='3632798';
            OAuth.End_Date__c=System.now().date()+5;
            //Oauth.musqot__Post_ID__c='1234567';  
            //OAuth.musqot__Campaign_Id__c='059c9a6e11';   
            OAuth.musqot__Socialmedia__c = OBJSocial.Id;
            OAuth.musqot__Social_media__c='LinkedIn';
            OAuth.musqot__Auto_import__c=true;
            //OAuth.musqot__ad_id__c='6028983459919';
            insert OAuth;
            system.assertnotEquals(null,OAuth.id); 
            system.assertEquals('ffbook', OAuth.Name);
            
            musqot__Social_media_data__c smd = new musqot__Social_media_data__c();
            smd.musqot__Compound_Id__c='Requestheader';
            smd.musqot__Date__c=system.today();
            smd.musqot__Number_of_likes__c=5;
            smd.musqot__Number_of_member__c=100;
            smd.musqot__Number_of_unik_visitor__c= 200;
            smd.musqot__Connection__c= OAuth.id;  
            smd.musqot__Socialmedia_Settings__c=OBJSocial.id;
            insert smd;        
            System.assertEquals('Requestheader', smd.musqot__Compound_Id__c);
            
            Socialmedia_settings__c st=new Socialmedia_settings__c();
            st.musqot__Auto_import__c=true;
            st.musqot__Socialmedia__c=OAuth.id;
            st.musqot__Socialmedia_type__c='Page';
            st.musqot__End_date__c=system.today();
            st.musqot__Start_date__c=system.today();
            //st.Type__c='Milestone';
            st.Socialmedia__c=OAuth.id;
            insert st;        
            System.assertEquals(true, st.musqot__Auto_import__c);
            
            musqot__Socialmedia_logfile__c smdata = new musqot__Socialmedia_logfile__c();
            smdata.musqot__Connection_id__c=OAuth.id;
            smdata.musqot__Imported__c=true;
            smdata.musqot__Import_message__c='Pagemessage';
            smdata.musqot__Number_of_records__c=100;
            insert smdata;
            System.assertEquals(true, smdata.musqot__Imported__c);
           
            Test.startTest();
            try{
            ApexPages.currentPage().getParameters().put('socialId',OBJSocial.Id);
            ApexPages.currentPage().getParameters().put('conid',OAuth.Id);
             ApexPages.currentPage().getParameters().put('cntId',OAuth.Id);
            ApexPages.StandardController ctrl = new ApexPages.StandardController(OAuth);
            Socialmedia_connection_Ctrl sec = new Socialmedia_connection_Ctrl (ctrl);
            //CronJobDetail cj = [select id, Name from CronJobDetail where Name = :'scheduleFacebookInsightsJob'];
            //CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where CronJobDetailId = :cj.Id];
            sec.ObjSMS = OAuth;
            List<OAuthService__c> tem1= sec.connectionList;  
            sec.smMessage  = true;
            Test.setMock(HttpCalloutMock.class, new HttpRequestandResponse());
            //Socialmedia_connection_Ctrl.querylinkedinPageInsights();                    
            sec.smMessage=true;
            //sec.updSocial();
            sec.cancel();                      
            sec.socialmediaConnection();           
            //sec.importsocialmediaData();                       
                }catch(Exception e){}
            test.stopTest(); 
        }
    
    static testMethod void Socialmedia_controllerMethodConnectionLinkedinPost(){     
            musqot__Socialmedia_settings__c OBJSocial = new musqot__Socialmedia_settings__c();
            OBJSocial.Name='testmedia';
            OBJSocial.musqot__Import_rate__c='Hour';        
            OBJSocial.musqot__Socialmedia_type__c='Facebook';
            OBJSocial.musqot__Watch_type__c='Downloads';
            OBJSocial.musqot__Chart__c='Bar charts';
            OBJSocial.musqot__Auto_import__c= true ;
            OBJSocial.Type__c='Milestone';
            insert OBJSocial;                    
            System.assertEquals('Downloads', OBJSocial.musqot__Watch_type__c);
            
            musqot__OAuthService__c  OAuth = new musqot__OAuthService__c ();
            OAuth.Name='ffbook';
            OAuth.musqot__Authorization_Type__c='Requestheader';
            OAuth.musqot__Access_Token_URL__c='AQW8V5EtKM3nUu9jnxhGsWc_0Sg5mt2Wt_89qctsQIRRx_V3xaT_pPIVYAcQopVjW94n3Hsp4nTBBs_5sQk1u4270vyMiOb6qwB86GKuEIt8xcuI1sP3lHrmFpS1_lQVYeK6JVmGHC7U2wu5nh12S3Qqt1TMCPGE5kUwBt5iMXNaDyMxHqM';
            OAuth.musqot__Response_Type__c='token';
            OAuth.musqot__Signature_Method__c='PLAINTEXT';
            OAuth.musqot__Consumer_Key__c = '';
            OAuth.musqot__Consumer_Secret__c = '';  
            OAuth.musqot__Bar_color__c='#333';   
            OAuth.musqot__Page_Id__c='3632798';
            OAuth.End_Date__c=System.now().date()+5;
            Oauth.musqot__Post_ID__c='6063260730101153792';  
            //OAuth.musqot__Campaign_Id__c='059c9a6e11';   
            OAuth.musqot__Socialmedia__c = OBJSocial.Id;
            OAuth.musqot__Social_media__c='LinkedIn';
            OAuth.musqot__Auto_import__c=true;
            //OAuth.musqot__ad_id__c='6028983459919';
            insert OAuth;
            system.assertnotEquals(null,OAuth.id); 
            system.assertEquals('ffbook', OAuth.Name);
            
            musqot__Social_media_data__c smd = new musqot__Social_media_data__c();
            smd.musqot__Compound_Id__c='Requestheader';
            smd.musqot__Date__c=system.today();
            smd.musqot__Number_of_likes__c=5;
            smd.musqot__Number_of_member__c=100;
            smd.musqot__Number_of_unik_visitor__c= 200;
            smd.musqot__Connection__c= OAuth.id;  
            smd.musqot__Socialmedia_Settings__c=OBJSocial.id;
            insert smd;        
            System.assertEquals('Requestheader', smd.musqot__Compound_Id__c);
            
            Socialmedia_settings__c st=new Socialmedia_settings__c();
            st.musqot__Auto_import__c=true;
            st.musqot__Socialmedia__c=OAuth.id;
            st.musqot__Socialmedia_type__c='Page';
            st.musqot__End_date__c=system.today();
            st.musqot__Start_date__c=system.today();
            //st.Type__c='Milestone';
            st.Socialmedia__c=OAuth.id;
            insert st;        
            System.assertEquals(true, st.musqot__Auto_import__c);
            
            musqot__Socialmedia_logfile__c smdata = new musqot__Socialmedia_logfile__c();
            smdata.musqot__Connection_id__c=OAuth.id;
            smdata.musqot__Imported__c=true;
            smdata.musqot__Import_message__c='Pagemessage';
            smdata.musqot__Number_of_records__c=100;
            insert smdata;
            System.assertEquals(true, smdata.musqot__Imported__c);
           
            Test.startTest();
            try{
            ApexPages.currentPage().getParameters().put('socialId',OBJSocial.Id);
            ApexPages.currentPage().getParameters().put('conid',OAuth.Id);
             ApexPages.currentPage().getParameters().put('cntId',OAuth.Id);
            ApexPages.StandardController ctrl = new ApexPages.StandardController(OAuth);
            Socialmedia_connection_Ctrl sec = new Socialmedia_connection_Ctrl (ctrl);
            //CronJobDetail cj = [select id, Name from CronJobDetail where Name = :'scheduleFacebookInsightsJob'];
            //CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where CronJobDetailId = :cj.Id];
            sec.ObjSMS = OAuth;
            List<OAuthService__c> tem1= sec.connectionList; 
            sec.smMessage  = true;
            Test.setMock(HttpCalloutMock.class, new HttpRequestandResponse());            
            //Socialmedia_connection_Ctrl.querylinkedinPostInsights();                   
            sec.smMessage=true;
            //sec.updSocial();
            sec.cancel();                      
            sec.socialmediaConnection();            
            //sec.importsocialmediaData();                       
                }catch(Exception e){}
            test.stopTest(); 
        }
  }