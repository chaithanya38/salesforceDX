/*****************************************************************
Class Name: HttpRequestandResponse 
Author:Chaithanya daggumati                   Last modified by: Chaithanya daggumati
Date:8/4/2015                                 Date:8/4/2015
Description: Class to support webservices callout invocations from the test classes.             
********©2013 Musqot marketing technology Pvt ltd ****************/


@isTest 
    global class HttpRequestandResponse implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
    
        //System.assertEquals('GET', req.getMethod());
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"campaignReqURL":"campaignId"}');
        res.setStatusCode(200);
        System.assertEquals(200,res.getStatusCode());
        return res;
        }
    }