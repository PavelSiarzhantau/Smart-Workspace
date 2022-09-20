@isTest
public with sharing class SensorRestServiceTest {
    @isTest
    static void testCreateOrUpdateSensorSensorPositiveInput() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        RestRequest request = TestDataFactory.createMockRequest(true);
        RestContext.request = request;
        String message = '::::NO ERROR::::';
        Integer statusCode = 200;
        Boolean isError = false;
        SensorRestService.SensorWrapper requestToUser = new SensorRestService.SensorWrapper();
        List<Sensor__c> listOfSensors = new List<Sensor__c>();
        System.runAs(user) {
            Test.startTest();
            requestToUser = SensorRestService.createOrUpdateSensorWithEvents();
            Test.stopTest();
        }
        System.debug('request:::: ' + requestToUser);
        listOfSensors = [
            SELECT Id, Name, (SELECT Id, Name FROM Sensor_Events__r)
            FROM Sensor__c
        ];
        System.assertEquals(
            listOfSensors.size(),
            requestToUser.createdAndUpdatedSensors.size(),
            'Test: createSensorPositive() is failed'
        );
        System.assertEquals(
            message,
            requestToUser.errorMessage,
            'Test: createSensorPositive() is failed'
        );
        System.assertEquals(
            statusCode,
            requestToUser.statusCode,
            'Test: createSensorPositive() is failed'
        );
        System.assertEquals(
            isError,
            requestToUser.isError,
            'Test: createSensorPositive() is failed'
        );
    }
    @isTest
    static void testCreateOrUpdateSensorrNegativeWrongInput() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        RestRequest request = TestDataFactory.createMockRequest(false);
        RestContext.request = request;
        String message = '::::INVALID INPUT::::, Please enter valid string';
        Integer statusCode = 500;
        Boolean isError = true;
        SensorRestService.SensorWrapper requestToUser = new SensorRestService.SensorWrapper();
        List<Sensor__c> listOfSensors = new List<Sensor__c>();
        System.runAs(user) {
            Test.startTest();
            requestToUser = SensorRestService.createOrUpdateSensorWithEvents();
            Test.stopTest();
        }
        System.debug('request:::: ' + requestToUser);
        listOfSensors = [
            SELECT Id, Name, (SELECT Id, Name FROM Sensor_Events__r)
            FROM Sensor__c
        ];
        System.AssertEquals(
            listOfSensors.size(),
            requestToUser.createdAndUpdatedSensors.size(),
            'Test: createSensorPositive() is failed'
        );
        System.assertEquals(
            message,
            requestToUser.errorMessage,
            'Test: createSensorPositive() is failed'
        );
        System.assertEquals(
            statusCode,
            requestToUser.statusCode,
            'Test: createSensorPositive() is failed'
        );
        System.assertEquals(
            isError,
            requestToUser.isError,
            'Test: createSensorPositive() is failed'
        );
    }
}
