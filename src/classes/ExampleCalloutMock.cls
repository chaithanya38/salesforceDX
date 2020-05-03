/*****************************************************************
Class Name: ExampleCalloutMock 
Author:Hussain                   Last modified by: Hussain
Date:4/27/2015                  Date:4/30/2015
Description: Class to support webservices callout invocations from the test classes.
             This is class is used in SocailMedia_Edit_Ctrl_Test
********©2013 Musqot marketing technology Pvt ltd ****************/


@isTest
global class ExampleCalloutMock implements HttpCalloutMock{
    global HttpResponse respond(HTTPRequest req){
        HttpResponse res = new HttpResponse();
        res.setStatus('OK');
        res.setStatusCode(200);
        res.setBody('GREAT SCOTT');
        System.assertEquals('OK', res.getStatus());
        return res;
    }
}