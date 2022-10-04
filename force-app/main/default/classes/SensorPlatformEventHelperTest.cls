/**
 *
 *   Class Name   : SensorPlatformEventHelperTest
 *   Author Email : pavel.siarzhantau@gmail.com
 *   Purpose      : primary purpose - test all scenario in SensorPlatformEventHelper class
 *   Revisions    : 30/09/2022 - Original
 *
 *
 **/
@isTest
public with sharing class SensorPlatformEventHelperTest {
    @testSetup
    static void makeData() {
        List<Sensor__c> createdSensors = TestDataFactory.insertListOfSensors(
            200,
            true
        );
    }

    @isTest
    static void testPublishEvent() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        Sensor_Tracking_Event__e event = new Sensor_Tracking_Event__e();
        event.message__c = 'Test message';
        event.Sensors_names__c = 'Test names';
        Database.SaveResult result;
        System.runAs(user) {
            Test.startTest();
            result = EventBus.publish(event);
            Test.stopTest();
        }
        System.assertEquals(
            true,
            result.isSuccess(),
            'Test: testPublishEvent() method if failed.'
        );
    }
    @isTest
    static void testPublishEventBeforeInsert() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        List<Sensor__c> listofSensors = TestDataFactory.insertListOfSensors(
            200,
            false
        );

        System.runAs(user) {
            Test.startTest();
            SensorPlatformEventHelper.publishEvent(
                listofSensors,
                'BEFORE_INSERT'
            );
            Test.stopTest();
        }
        System.assertEquals(
            true,
            SensorPlatformEventHelper.isInsert,
            'Test: testPublishEventBeforeInsert() method failed'
        );
    }
    @isTest
    static void testPublishEventAfterInsert() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        List<Sensor__c> listofSensors = TestDataFactory.insertListOfSensors(
            200,
            false
        );
        System.runAs(user) {
            Test.startTest();
            SensorPlatformEventHelper.publishEvent(
                listofSensors,
                'AFTER_INSERT'
            );
            Test.stopTest();
        }
        System.assertEquals(
            1,
            SensorPlatformEventHelper.events.size(),
            'Test: testPublishEventAfterInsert() method failed'
        );
        System.assertEquals(
            5,
            SensorPlatformEventHelper.events[0]
                .Sensors_names__c.split('\n')
                .size(),
            'Test: testPublishEventAfterInsert() method failed'
        );
        System.assertEquals(
            'Sensor(s) successfully inserted.',
            SensorPlatformEventHelper.events[0].message__c,
            'Test: testPublishEventAfterInsert() is failed'
        );
    }
    @isTest
    static void testPublishEventAfterUpdate() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        List<Sensor__c> listofSensors = TestDataFactory.insertListOfSensors(
            200,
            false
        );
        System.runAs(user) {
            Test.startTest();
            SensorPlatformEventHelper.publishEvent(
                listofSensors,
                'AFTER_UPDATE'
            );
            Test.stopTest();
        }
        System.assertEquals(
            1,
            SensorPlatformEventHelper.events.size(),
            'Test: testPublishEventAfterInsert() method failed'
        );
        System.assertEquals(
            5,
            SensorPlatformEventHelper.events[0]
                .Sensors_names__c.split('\n')
                .size(),
            'Test: testPublishEventAfterInsert() method failed'
        );
        System.assertEquals(
            'Sensor(s) successfully updated.',
            SensorPlatformEventHelper.events[0].message__c,
            'Test: testPublishEventAfterInsert() failed'
        );
    }
    @isTest
    static void testPublishEventAvoidAfterUdpateEvent() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        List<Sensor__c> listofSensors = TestDataFactory.insertListOfSensors(
            200,
            false
        );
        System.runAs(user) {
            Test.startTest();
            SensorPlatformEventHelper.publishEvent(
                listofSensors,
                'BEFORE_INSERT'
            );
            SensorPlatformEventHelper.publishEvent(
                listofSensors,
                'AFTER_UPDATE'
            );
            Test.stopTest();
        }
        System.assertEquals(
            0,
            SensorPlatformEventHelper.events.size(),
            'Test: testPublishEventAfterInsert() method failed'
        );
    }
    @isTest
    static void testPublishEventWithInsertTest() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        List<Sensor__c> listofSensors = TestDataFactory.createListOfSensors(
            200
        );
        System.runAs(user) {
            Test.startTest();
            insert listofSensors;
            Test.stopTest();
        }
        System.assertEquals(
            1,
            SensorPlatformEventHelper.events.size(),
            'Test: testPublishEventWithDmlTest() failed.'
        );
        System.assertEquals(
            'Sensor(s) successfully inserted.',
            SensorPlatformEventHelper.events[0].message__c,
            'Test: testPublishEventWithDmlTest() failed.'
        );
    }
    @isTest
    static void testPublishEventWithUpdateTest() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        List<Sensor__c> listofSensors = new List<Sensor__c>();
        System.runAs(user) {
            Test.startTest();
            listofSensors = [SELECT Id, Name FROM Sensor__c];
            for (Sensor__c sensor : listofSensors) {
                sensor.Name += ' updated';
            }
            update listofSensors;
            Test.stopTest();
        }
        System.assertEquals(
            1,
            SensorPlatformEventHelper.events.size(),
            'Test: testPublishEventWithUpdateTest() failed.'
        );
        System.assertEquals(
            'Sensor(s) successfully updated.',
            SensorPlatformEventHelper.events[0].message__c,
            'Test: testPublishEventWithUpdateTest() failed.'
        );
    }
    @isTest
    static void testPublishEventWithDeleteTest() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        List<Sensor__c> listofSensors = new List<Sensor__c>();
        System.runAs(user) {
            Test.startTest();
            listofSensors = [SELECT Name FROM Sensor__c];
            delete listofSensors;
            Test.stopTest();
        }
        System.assertEquals(
            1,
            SensorPlatformEventHelper.events.size(),
            'Test: testPublishEventWithDeleteTest() failed'
        );
        System.assertEquals(
            'Sensor(s) successfully deleted.',
            SensorPlatformEventHelper.events[0].message__c,
            'Test: testPublishEventWithDeleteTest() failed'
        );
    }
    @isTest
    static void testPublisEvenWithtDeleteEventsTest() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        List<Sensor_Event__c> listOfSensorEvents = new List<Sensor_Event__c>();
        List<Sensor__c> listOfSensors;
        System.runAs(user) {
            Test.startTest();
            listOfSensors = [SELECT Id, Name FROM Sensor__c];
            for (Sensor__c sensor : listOfSensors) {
                List<Sensor_Event__c> events = TestDataFactory.createListofEvents(
                    4
                );
                for (Sensor_Event__c event : events) {
                    event.Sensor__c = sensor.Id;
                    listOfSensorEvents.add(event);
                }
            }
            insert listOfSensorEvents;
            List<Sensor_Event__c> events = [SELECT Id FROM Sensor_Event__c];
            delete events;
            Test.stopTest();
        }

        System.assertEquals(
            0,
            [SELECT Id, Name FROM Sensor_Event__c].size(),
            'Test: testPublisEventDeleteEventsTest() method failed'
        );
    }
    @isTest
    static void testPublisEventNegative() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        Sensor_Tracking_Event__e event = new Sensor_Tracking_Event__e();
        List<Sensor__c> listofSensors = TestDataFactory.createListOfSensors(
            200
        );
        List<String> namesOfSensors = new List<String>();
        Database.SaveResult result;
        for (Sensor__c sensor : listofSensors) {
            namesOfSensors.add('Sensor: ' + sensor.Name + '\r\n');
        }
        event.Sensors_names__c = String.join(namesOfSensors, ',');
        System.runAs(user) {
            Test.startTest();
            result = Eventbus.publish(event);
            Test.stopTest();
        }
        System.assertEquals(
            false,
            result.isSuccess(),
            'Test: testPublisEventNegative() failed'
        );
    }
    @isTest
    static void testSendEventToEventBus() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        Sensor_Tracking_Event__e event = new Sensor_Tracking_Event__e();
        List<Sensor__c> listofSensors = TestDataFactory.createListOfSensors(
            200
        );
        String exceptedString = 'Some error occured, when publishing event: ';
        event.message__c = 'Test message';
        event.Sensors_names__c = 'Test names';
        SensorPlatformEventHelper.isTest = true;

        System.runAs(user) {
            Test.startTest();
            try {
                SensorPlatformEventHelper.publishEvent(
                    listofSensors,
                    'AFTER_INSERT'
                );
            } catch (SensorPlatformEventHelper.SensorPaltformEventException e) {
                System.assertEquals(
                    true,
                    e.getMessage().contains(exceptedString),
                    'Test: testSendEventToEventBus() failed'
                );
            }
            Test.stopTest();
        }
    }
}
