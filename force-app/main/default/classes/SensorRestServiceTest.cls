/** 
*
*   Class Name   : SensorRestServiceTest
*   Author Email : pavel.siarzhantau@gmail.com 
*   Purpose      : primary purpose - test all methods with different scenarious in 
                   SensorRestService class
*   Revisions    : 30/09/2022 - Original
*      
*
**/
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
            SELECT Id, 
                   Name, 
                   (SELECT Id, 
                           Name 
                    FROM Sensor_Events__r)
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
            SELECT Id, 
                   Name, 
                   (SELECT Id, 
                           Name 
                    FROM Sensor_Events__r)
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
    @isTest
    static void testExceptionSensorsCreate() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        RestRequest request = TestDataFactory.createMockRequest(true);
        SensorRestService.SensorWrapper requestToUser = new SensorRestService.SensorWrapper();
        RestContext.request = request;
        SensorRestService.throwExceptionSensorsCreate = true;
        String message = 'Test Error';
        Integer statusCode = 500;
        Boolean isError = true;
        System.runAs(user) {
            Test.startTest();
            try {
                requestToUser = SensorRestService.createOrUpdateSensorWithEvents();
            } catch (SensorRestService.SensorException e) {
                System.assertEquals(
                    message,
                    e.getMessage(),
                    'Test: createSensorPositive() is failed'
                );
            }
            Test.stopTest();
        }
    }
    @isTest
    static void testExceptionSensorsEventsCreate() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        RestRequest request = TestDataFactory.createMockRequest(true);
        SensorRestService.SensorWrapper requestToUser = new SensorRestService.SensorWrapper();
        RestContext.request = request;
        SensorRestService.throwExceptionSensorsEventsCreate = true;
        String message = 'Test Error';
        Integer statusCode = 500;
        Boolean isError = true;
        System.runAs(user) {
            Test.startTest();
            try {
                requestToUser = SensorRestService.createOrUpdateSensorWithEvents();
            } catch (SensorRestService.SensorException e) {
                System.assertEquals(
                    message,
                    e.getMessage(),
                    'Test: createSensorPositive() is failed'
                );
            }
            Test.stopTest();
        }
    }
    @isTest
    static void testExceptionSensorsEventsUpdate() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        RestRequest request = TestDataFactory.createMockRequest(true);
        SensorRestService.SensorWrapper requestToUser = new SensorRestService.SensorWrapper();
        RestContext.request = request;
        SensorRestService.throwExceptionSensorsEventsUpdate = true;
        String message = 'Test Error';
        Integer statusCode = 500;
        Boolean isError = true;
        System.runAs(user) {
            Test.startTest();
            try {
                requestToUser = SensorRestService.createOrUpdateSensorWithEvents();
            } catch (SensorRestService.SensorException e) {
                System.assertEquals(
                    message,
                    e.getMessage(),
                    'Test: createSensorPositive() is failed'
                );
            }
            Test.stopTest();
        }
    }
}