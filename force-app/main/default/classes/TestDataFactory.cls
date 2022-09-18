@isTest
public with sharing class TestDataFactory {
    public static RestRequest createMockRequest(Boolean isPositive) {
        // Set up a test request
        RestRequest request = new RestRequest();
        // Set request properties
        request.requestUri = 'https://yourInstance.my.salesforce.com/services/apexrest/Sensors/';
        request.httpMethod = 'POST';
        if (isPositive) {
            request.requestBody = Blob.valueOf(
                '\'{‘sensorid’: \'1\',‘vectors’: [{‘x’: 22,’y’: 17,’z’: 197}, {‘x’: 23, ‘y’: 45,’z’: 14}, { ‘x’: 22, ‘y’: 43,’z’: 196}, {‘x’: 24,‘y’: 42,‘z’: 198} ] }\''
            );
        } else {
            request.requestBody = Blob.valueOf(
                '\'{‘sensorid’: \'1\',‘vectors’: [‘x: 22,’y’: 17,’z’: 197}, {x’: 23, ‘y’: 45,’z’: 14}, { ‘x’: 22, ‘y’: 43,’z’: 196}, x’: 24,‘y’: 42,‘z’: 198} ] }\''
            );
        }
        return request;
    }
}
