/** 
*
*   Class Name   : SensorEventTriggerTest
*   Author Email : pavel.siarzhantau@gmail.com 
*   Purpose      : primary purpose - validate triggers on Sensor_Event__c object
                   work correctly
*   Revisions    : 03/10/2022 - Original
*      
*
**/
@isTest
public with sharing class SensorEventTriggerTest {
    @TestSetup
    static void makeData() {
        List<Sensor__c> listofSensors = TestDataFactory.insertListOfSensors(
            300,
            true
        );
        List<Sensor_Event__c> listOfSensorEvents = new List<Sensor_Event__c>();
        for (Sensor__c sensor : listofSensors) {
            List<Sensor_Event__c> listOfEvents = TestDataFactory.createListofEvents(
                4
            );
            for (Sensor_Event__c event : listOfEvents) {
                event.Sensor__c = sensor.Id;
                listOfSensorEvents.add(event);
            }
        }
        insert listOfSensorEvents;
    }
    @isTest
    static void testCreateEvents() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        List<Sensor__c> listofSensors;
        List<Sensor_Event__c> listOfEventsToInsert = new List<Sensor_Event__c>();

        List<Database.SaveResult> result;
        System.runAs(user) {
            Test.startTest();
            listofSensors = TestDataFactory.createListOfSensors(300);
            insert listofSensors;
            for (Sensor__c sensor : listofSensors) {
                List<Sensor_Event__c> listOfEvents = TestDataFactory.createListofEvents(
                    4
                );
                for (Sensor_Event__c event : listOfEvents) {
                    event.Sensor__c = sensor.Id;
                    listOfEventsToInsert.add(event);
                }
            }
            result = Database.insert(listOfEventsToInsert, false);
            Test.stopTest();
        }
        for (Database.SaveResult res : result) {
            System.assertEquals(
                true,
                res.isSuccess(),
                'Test: testCreateEvents() failed'
            );
        }
    }
    @isTest
    static void testUpdateEvents() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        List<Sensor_Event__c> listOfSensorEvents = new List<Sensor_Event__c>();
        Integer counter = 0;
        List<Database.SaveResult> result;
        System.runAs(user) {
            Test.startTest();
            listOfSensorEvents = [SELECT Id, 
                                         Name 
                                  FROM Sensor_Event__c];
            for (Sensor_Event__c event : listOfSensorEvents) {
                event.x__c = counter;
                event.y__c = counter;
                event.z__c = counter;
                counter++;
            }
            result = Database.update(listOfSensorEvents, false);
            Test.stopTest();
            for (Database.SaveResult res : result) {
                System.assertEquals(
                    true,
                    res.isSuccess(),
                    'Test: testUpdateEvents() failed'
                );
            }
        }
    }
    @isTest
    static void testDeleteEvents() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        List<Sensor_Event__c> listOfSensorEvents = new List<Sensor_Event__c>();
        List<Database.DeleteResult> result;
        System.runAs(user) {
            Test.startTest();
            listOfSensorEvents = [SELECT Id, 
                                         Name 
                                  FROM Sensor_Event__c];
            result = Database.delete(listOfSensorEvents, false);
            Test.stopTest();
        }
        for (Database.DeleteResult res : result) {
            System.assertEquals(
                true,
                res.isSuccess(),
                'Test: testDeleteEvents() failed'
            );
        }
    }
    @isTest
    static void testInsertEventsNegative() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        List<Database.SaveResult> result;
        System.runAs(user) {
            Test.startTest();
            result = Database.insert(
                TestDataFactory.createListofEvents(300),
                false
            );
            Test.stopTest();
        }
        for (Database.SaveResult res : result) {
            System.assertEquals(
                true,
                res.getErrors().size() != 0,
                'Test: testInsertEventsNegative() failed'
            );
        }
    }
    @isTest
    static void testUpdateEventsNegative() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        List<Sensor_Event__c> listOfSensorEvents = new List<Sensor_Event__c>();
        List<Database.SaveResult> result;
        System.runAs(user) {
            Test.startTest();
            listOfSensorEvents = [SELECT Id, 
                                         Name 
                                  FROM Sensor_Event__c];
            for (Sensor_Event__c event : listOfSensorEvents) {
                event.x__c = null;
                event.y__c = null;
                event.z__c = null;
            }
            result = Database.update(listOfSensorEvents, false);
            Test.stopTest();
            for (Database.SaveResult res : result) {
                System.assertEquals(
                    true,
                    res.getErrors().size() != 0,
                    'Test: testUpdateEventsNegative() failed'
                );
            }
        }

    }
    @isTest
    static void testDeleteEventsNegative() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        List<Sensor_Event__c> listOfSensorEvents = new List<Sensor_Event__c>();
        String errorMessage = 'Artificially generated error';
        List<Database.DeleteResult> result;
        System.runAs(user) {
            Test.startTest();
            SensorsEventsTriggerHandler.createArtificialError = true;
            listOfSensorEvents = [SELECT Id, 
                                         Name 
                                  FROM Sensor_Event__c];
            result = Database.delete(listOfSensorEvents, false);
            Test.stopTest();
        }
        for (Database.DeleteResult res : result) {
            System.assertEquals(
                true,
                res.getErrors().size() != 0,
                'Test: testDeleteEventsNegative() failed'
            );
            System.assertEquals(
                true,
                res.getErrors()[0].getMessage().contains(errorMessage),
                'Test: testDeleteEventsNegative() failed'
            );
        }
    }
}