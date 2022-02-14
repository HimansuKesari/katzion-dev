/*
    DeveloperName: Himansu Kesari
    CreatedDate : 13th Feb 2022
    Description: This Class is mock response for test class for the API Callout
*/
@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assertEquals('https://fakeendpoint.free.beeceptor.com/my/api/path', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"Response":"Successful"}');
        res.setStatusCode(200);
        return res;
    }
}
