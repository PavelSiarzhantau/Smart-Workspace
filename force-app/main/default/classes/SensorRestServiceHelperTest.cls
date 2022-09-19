@isTest
public with sharing class SensorRestServiceHelperTest {
    @isTest
    static void testGetParametersFromRequestPositive() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        RestRequest request = TestDataFactory.createMockRequest(true);
        Map<String, List<Sensor_Event__c>> expexted = TestDataFactory.createMapWithSensorsAndEvents();
        Map<String, List<Sensor_Event__c>> actual;
        Sensor_Event__c actualEvent;
        Integer count = 0;
        RestContext.request = request;
        System.runAs(user) {
            Test.startTest();
            actual = SensorRestServiceHelper.getParametersFromRequest(request);
            Test.stopTest();
        }
        System.assert(
            actual.size() != 0,
            'Test: actual returned list is Empty'
        );
        for (String sensor : expexted.keySet()) {
            count = 0;
            for (Sensor_Event__c event : expexted.get(sensor)) {
                actualEvent = new Sensor_Event__c();
                actualEvent = actual.get(sensor)[count];
                System.debug('EVENT ' + event + ' ACTUAL ' + actualEvent);
                System.assertEquals(
                    event,
                    actualEvent,
                    'TEST: equls events test is failed'
                );
                count++;
            }
        }
    }
    @isTest
    static void testGetParametersFromRequestNegative() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        RestRequest request = TestDataFactory.createMockRequest(false);
        Map<String, List<Sensor_Event__c>> actual;
        String actualMessage;
        String expectedMessage = '::::INVALID INPUT::::, Please enter valid string';
        System.runAs(user) {
            Test.startTest();
            try {
                actual = SensorRestServiceHelper.getParametersFromRequest(
                    request
                );
            } catch (SensorRestService.SensorException e) {
                actualMessage = e.getMessage();
                System.assertEquals(
                    expectedMessage,
                    actualMessage,
                    'Test: testGetParametersFromRequestNegative() method is failed message don\'t meet'
                );
            }
            Test.stopTest();
        }
    }
    @isTest
    static void testGetduplicateSensorsMapPositive() {
        User user;
        System.runAs(new User(Id = UserInfo.getUserId())) {
            user = TestDataFactory.createTestUser('Integration Profile');
        }
        List<Sensor__c> listOfSensors = TestDataFactory.createListOfSensors(
            201
        );
        Map<String, Sensor__c> expected = TestDataFactory.createMapOfSensors(
            201,
            false
        );
        Map<String, Sensor__c> actual;
        System.runAs(user) {
            Test.startTest();
            actual = SensorRestServiceHelper.getduplicateSensorsMap(
                listOfSensors
            );
            Test.stopTest();
        }
        for (Sensor__c sensor : expected.values()) {
            System.assertEquals(
                sensor,
                actual.get(sensor.Name),
                'Test: testGetduplicateSensorsMap() is failed'
            );
        }
    }
    @isTest
    static void testGetduplicateSensorsMapNegative() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        List<Sensor__c> listOfSensors = new List<Sensor__c>();
        System.runAs(user) {
            Test.startTest();
            Map<String, Sensor__c> actual = SensorRestServiceHelper.getduplicateSensorsMap(
                listOfSensors
            );
            System.assertEquals(
                0,
                actual.size(),
                'Test: testGetduplicateSensorsMapNegative() is failed '
            );
            Test.stopTest();
        }
    }
    @isTest
    static void testSepareteSensorsPositive() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        Map<String, List<SObject>> returnedResults;
        System.runAs(user) {
            Map<String, Sensor__c> sensorsFromDatabase = TestDataFactory.getDuplicateSensorsMap(
                201
            );
            Map<String, List<Sensor_Event__c>> createdTestOfEvents = TestDataFactory.createSensorsWithEvents(
                4,
                201
            );
            Test.startTest();
            returnedResults = SensorRestServiceHelper.separateSensors(
                sensorsFromDatabase,
                createdTestOfEvents
            );
            Test.stopTest();
        }
        System.assert(
            returnedResults.containsKey('sensorEventsToCrearte'),
            'Test: testSepareteSensorsPositive() is failed'
        );
        System.assert(
            returnedResults.containsKey('sensorsToCreate'),
            'Test: testSepareteSensorsPositive() is failed'
        );
        System.assertEquals(
            804,
            returnedResults.get('sensorEventsToCrearte').size(),
            'Test  testSepareteSensors() is Failed'
        );
        System.assertEquals(
            201,
            returnedResults.get('sensorsToCreate').size(),
            'Test: testSepareteSensors() is Failed'
        );
        for (
            Sensor_Event__c event : (List<Sensor_Event__c>) returnedResults.get(
                'sensorEventsToCrearte'
            )
        ) {
            System.assertEquals(
                true,
                event.Sensor__c != null,
                'Test: testSepareteSensors() is failed'
            );
        }
        for (
            Sensor__c sensor : (List<Sensor__c>) returnedResults.get(
                'sensorsToCreate'
            )
        ) {
            System.assertEquals(
                true,
                sensor.Id == null,
                'Test: testSepareteSensors() is failed'
            );
        }
    }
    @isTest
    static void testSepareteSensorsNegative() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        Map<String, List<SObject>> returnedResults;
        System.runAs(user) {
            Map<String, Sensor__c> sensorsFromDatabase = TestDataFactory.getDuplicateSensorsMap(
                0
            );
            Map<String, List<Sensor_Event__c>> createdTestOfEvents = TestDataFactory.createSensorsWithEvents(
                4,
                201
            );
            Test.startTest();
            returnedResults = SensorRestServiceHelper.separateSensors(
                sensorsFromDatabase,
                createdTestOfEvents
            );
            Test.stopTest();
        }
        System.assert(
            returnedResults.containsKey('sensorEventsToCrearte'),
            'Test: testSepareteSensorsPositive() is failed'
        );
        System.assert(
            returnedResults.containsKey('sensorsToCreate'),
            'Test: testSepareteSensorsPositive() is failed'
        );
        System.assertEquals(
            0,
            returnedResults.get('sensorEventsToCrearte').size(),
            'Test  testSepareteSensors() is Failed'
        );
        System.assertEquals(
            201,
            returnedResults.get('sensorsToCreate').size(),
            'Test: testSepareteSensors() is Failed'
        );
        for (
            Sensor_Event__c event : (List<Sensor_Event__c>) returnedResults.get(
                'sensorEventsToCrearte'
            )
        ) {
            System.assertEquals(
                true,
                event.Sensor__c == null,
                'Test: testSepareteSensors() is failed'
            );
        }
    }
    @isTest
    static void testAssignSensorToSensorEvent() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        List<Sensor__c> listofSensorsFromDatabase;
        Map<String, List<Sensor_Event__c>> sensorsWithEvents;
        List<Sensor_Event__c> sensorEventsToCrearte;

        System.runAs(user) {
            listofSensorsFromDatabase = TestDataFactory.insertListOfSensors(
                201,
                true
            );
            sensorsWithEvents = TestDataFactory.createSensorsWithEvents(4, 201);
            Test.startTest();
            sensorEventsToCrearte = SensorRestServiceHelper.assignSensorToSensorEvent(
                listofSensorsFromDatabase,
                sensorsWithEvents
            );
            Test.stopTest();
        }
        System.assertEquals(
            804,
            sensorEventsToCrearte.size(),
            'Test: testAssignSensorToSensorEvent() is faliled'
        );
        for (Sensor_Event__c event : sensorEventsToCrearte) {
            System.assertEquals(
                true,
                event.Sensor__c != null,
                'Test: testAssignSensorToSensorEvent() is faliled'
            );
        }
    }
    @isTest
    static void testprepareSensorsEventsToUpdate() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        List<Sensor_Event__c> actual;
        Map<String, Sensor__c> duplicateSensors;
        List<Sensor__c> sensorsWithEvents;
        List<Sensor__c> sensorsFromDatabase;
        Integer counter = 0;
        Integer counter2 = 0;
        System.runAs(user) {
            duplicateSensors = TestDataFactory.createDuplicateRecords(1, 2);
            sensorsWithEvents = TestDataFactory.getDataToTestUpdatingSensorsEvents(
                5,
                2
            );
            Test.startTest();
            actual = SensorRestServiceHelper.prepareSensorsEventsToUpdate(
                sensorsWithEvents,
                duplicateSensors
            );
            Test.stopTest();
            update actual;
            System.debug('SIZE:::: ' + actual.size());
            for (Sensor_Event__c event : actual) {
                if (event.Sensor_Event__c == null) {
                    counter++;
                }
            }
            sensorsFromDatabase = [
                SELECT
                    Id,
                    Name,
                    (
                        SELECT Id, Name, Sensor_Event__r.Id
                        FROM Sensor_Events__r
                        ORDER BY Name ASC
                    )
                FROM Sensor__c
            ];
            for (Sensor__c sensor : sensorsFromDatabase) {
                counter2 = 0;
                for (Sensor_Event__c event : sensor.Sensor_Events__r) {
                    System.debug('event:::: ' + event);
                    if (counter2 != 0) {
                        System.assertEquals(
                            true,
                            event.Sensor_Event__c ==
                            sensor.Sensor_Events__r[counter2 - 1].Id,
                            'Test: testprepareSensorsEventsToUpdate() is failed'
                        );
                        counter2++;
                    } else {
                        counter2++;
                    }
                }
            }
            System.assertEquals(
                5,
                counter,
                'Test: testprepareSensorsEventsToUpdate() is failed'
            );
        }
    }
}
