/** 
*
*   Class Name   : SensorRestServiceModelTest
*   Author Email : pavel.siarzhantau@gmail.com 
*   Purpose      : primary purpose - test all methods with different scenarious in 
                   SensorRestServiceModel class
*   Revisions    : 30/09/2022 - Original
*      
*
**/
@isTest
public with sharing class SensorRestServiceModelTest {
    @isTest
    static void testGetduplicateSensors() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        List<Sensor__c> listofSensors;
        Map<String, Sensor__c> mapOfSensorsWithEvents = new Map<String, Sensor__c>();
        Set<String> setOfSensorsNames = new Set<String>();
        List<Sensor__c> actualListOfSensors;
        Map<Id, Sensor__c> mapOfSensorsFromDatabase;

        System.runAs(user) {
            mapOfSensorsWithEvents = TestDataFactory.createDuplicateRecords(250,2);
            for (Sensor__c sensor : mapOfSensorsWithEvents.values()) {
                setOfSensorsNames.add(sensor.Name);
            }
            Test.startTest();
            actualListOfSensors = SensorRestServiceModel.getduplicateSensors(
                setOfSensorsNames
            );
            Test.stopTest();
            mapOfSensorsFromDatabase = new Map<Id, Sensor__c>(
                [
                    SELECT Id,
                           Name,
                           (SELECT Id,
                                   Name
                            FROM Sensor_Events__r
                            ORDER BY Name DESC
                            LIMIT 1
                        )
                    FROM Sensor__c
                ]
            );
            System.assertEquals(
                mapOfSensorsFromDatabase.size(),
                actualListOfSensors.size(),
                'Test: testGetduplicateSensors() is failed'
            );
            for (Sensor__c sensor : actualListOfSensors) {
                System.assertEquals(
                    true,
                    mapOfSensorsFromDatabase.containsKey(sensor.Id),
                    'Test: testGetduplicateSensors() is failed'
                );
                System.assertEquals(
                    mapOfSensorsFromDatabase.get(sensor.Id)
                        .Sensor_Events__r[0]
                        .Id,
                    sensor.Sensor_Events__r[0].Id,
                    'Test: testGetduplicateSensors() is failed'
                );
            }
        }
    }
    @isTest
    static void testGetSensorsToUpdate() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        Map<String, Sensor__c> mapOfSensorsWithEvents = new Map<String, Sensor__c>();
        Set<String> setOfNames = new Set<String>();
        List<Sensor_Event__c> listOfSensorsEvents = new List<Sensor_Event__c>();
        List<Sensor_Event__c> listofSensorseventsFromDatabase = new List<Sensor_Event__c>();
        List<Sensor__c> actualListOfSensors;
        Map<Id, Sensor__c> mapOfSensorsFromDatabase;
        System.runAs(user) {
            mapOfSensorsWithEvents = TestDataFactory.createDuplicateRecords(250,3);
            for (Sensor__c sensor : mapOfSensorsWithEvents.values()) {
                setOfNames.add(sensor.Name);
            }
            listofSensorseventsFromDatabase = [
                SELECT Id, 
                       Name, 
                       Sensor_Event__c, 
                       Sensor__r.Name
                FROM Sensor_Event__c
            ];
            for (Sensor_Event__c event : listofSensorseventsFromDatabase) {
                listOfSensorsEvents.add(event);
            }
            Test.startTest();
            actualListOfSensors = SensorRestServiceModel.getSensorsToUpdate(
                listOfSensorsEvents,
                setOfNames
            );
            Test.stopTest();
            mapOfSensorsFromDatabase = new Map<Id, Sensor__c>(
                [
                    SELECT Id,
                           Name,
                           (SELECT Id, 
                                   Name, 
                                   Sensor_Event__c, 
                                   Sensor__r.Name
                            FROM Sensor_Events__r
                            ORDER BY Name ASC
                        )
                    FROM Sensor__c
                ]
            );
            System.assertEquals(
                mapOfSensorsFromDatabase.size(),
                actualListOfSensors.size(),
                'Test: testGetSensorsToUpdate() is failed'
            );
            for (Sensor__c sensor : actualListOfSensors) {
                System.assertEquals(
                    true,
                    mapOfSensorsFromDatabase.containsKey(sensor.Id),
                    'Test: testGetSensorsToUpdate() is failed'
                );
                System.assertEquals(
                    mapOfSensorsFromDatabase.get(sensor.Id)
                        .Sensor_Events__r.size(),
                    sensor.Sensor_Events__r.size(),
                    'Test: testGetSensorsToUpdate() is failed'
                );
                for (Sensor_Event__c event : sensor.Sensor_Events__r) {
                    System.assertEquals(
                        true,
                        mapOfSensorsFromDatabase.get(sensor.Id)
                            .Sensor_Events__r.contains(event),
                        'Test: testGetSensorsToUpdate() is failed'
                    );
                }
            }
        }
    }
}