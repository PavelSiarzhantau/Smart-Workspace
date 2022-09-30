/** 
*
*   Class Name   : SensorEventsControllerTest
*   Author Email : pavel.siarzhantau@gmail.com 
*   Purpose      : primary purpose - test SensorEventsController class woth different scenario
*   Revisions    : 30/09/2022 - Original
*      
*
**/
@isTest
public with sharing class SensorEventsControllerTest {
    @isTest
    static void testGetSensorsEventsRecords() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        Map<String, Sensor__c> mapOfSensorsWithEvents = new Map<String, Sensor__c>();
        List<Sensor_Event__c> listofSensorseventsFromDatabase = new List<Sensor_Event__c>();
        List<Sensor_Event__c> actualListOfSensorsEvents = new List<Sensor_Event__c>();
        String recordId;
        System.runAs(user) {
            mapOfSensorsWithEvents = TestDataFactory.createDuplicateRecords(1, 30);
            recordId = mapOfSensorsWithEvents.values()[0].Id;
            Test.startTest();
            actualListOfSensorsEvents = SensorEvenstController.getSensorsEventsRecords(recordId);
            Test.stopTest();
            listofSensorseventsFromDatabase = [
                SELECT Name,
                       Modulus_Vector_Length__c,
                       x__c,
                       y__c,
                       z__c,
                       Sensor__r.Max_Vectors_Length__c,
                       Sensor_Event__r.Name,
                       Sensor__r.Name,
                       CreatedDate
                FROM Sensor_Event__c
            ];
            System.assertEquals(
                listofSensorseventsFromDatabase.size(),
                actualListOfSensorsEvents.size(),
                'Test: testGetSensorsEventsRecords() is failed'
            );
            for (Sensor_Event__c event : actualListOfSensorsEvents) {
                System.assertEquals(
                    true,
                    listofSensorseventsFromDatabase.contains(event),
                    'Test: testGetSensorsEventsRecords() is failed'
                );
                System.assertEquals(
                    listofSensorseventsFromDatabase[0].Sensor__c,
                    event.Sensor__c,
                    'Test: testGetSensorsEventsRecords() is failed'
                );
            }
        }
    }
}