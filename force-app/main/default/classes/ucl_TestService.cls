@isTest
public class ucl_TestService {
	public class ExampleCalloutMock1 implements HttpCalloutMock{
        public HttpResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('[\n' +
                        	'{\n' +
                                '"AccountNumber":"9afccdd3-e7c4-4789-a465-1734886633d2",\n' +
                                '"AccountName":"Centidel",\n' +
                                '"AccountStatus":"Enabled",\n' +
                                '"AsOfDate":"2/13/2019",\n' +
                                '"Clients":[\n' +
                                    ' {\n' +
                                        ' "FirstName":"Foster",\n' +
                                        ' "LastName":"Burn",\n' +
                                        ' "Email":"fburn0@nydailynews.com",\n' +
                                        ' "Phone":"425-154-5410",\n' +
                                        ' "Address":"49018 Bashford Road",\n' +
                                        ' "ClientNumber":"b4110a35-7ca3-4a53-8d94-ea78c5489052"\n' +
                                    '},\n'+
                                    '{\n' +
                                        ' "FirstName":"Minetta",\n' +
                                        ' "LastName":"Pol",\n' +
                                        ' "Email":"mpol1@thetimes.co.uk",\n' +
                                        ' "Phone":"704-528-1659",\n' +
                                        ' "Address":"21 Lukken Drive",\n' +
                                        ' "ClientNumber":"c0c93578-6bbf-4bcc-a786-4d1e45ea0c96"\n' +
                                    '}\n' +
                             	']\n' +
                           	'},\n' +
                        	'{\n'+
                        		'"AccountNumber":"a209ebbb-39c6-4852-8732-82237c0674fb",\n' +
                                '"AccountName":"Fadeo",\n' +
                                '"AccountStatus":"Disabled",\n' +
                                '"AsOfDate":"2/20/2019",\n' +
                                '"Clients":[\n' +
                                    ' {\n' +
                                        ' "FirstName":"Fran",\n' +
                                        ' "LastName":"Ruddick",\n' +
                                        ' "Email":"fruddick0@issuu.com",\n' +
                                        ' "Phone":"390-285-2477",\n' +
                                        ' "Address":"434 Maple Drive",\n' +
                                        ' "ClientNumber":"12afa152-8115-492b-bb49-87399ab49af8"\n' +
                                    '}\n'+
                             	']\n' +
                           	'}\n' +
                          ']\n');
            return res;
        }
    }
    
    public class ExampleCalloutMock2 implements HttpCalloutMock{
        public HttpResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            res.setStatus('OK');
            res.setStatusCode(200);
            res.setBody('[\n' +
                        	'{\n' +                              
                           	'}\n' +
                          ']\n');
            return res;
        }
    }
    
    @isTest static void testService1(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock1());
        ucl_service.executeService();
        Test.startTest();     
    }
    
    @isTest static void testService2(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ExampleCalloutMock2());
        ucl_service.executeService();
        Test.startTest();     
    }
}