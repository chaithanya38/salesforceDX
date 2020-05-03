@isTest 
    global class Httpmulticallout implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
    
        System.assertEquals('GET', req.getMethod());
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"adReqURL":"campaignReqURL"}');
        res.setStatusCode(100);
        return res;
        }
    }