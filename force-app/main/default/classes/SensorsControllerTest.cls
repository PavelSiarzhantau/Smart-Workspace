/** 
*
*   Class Name   : SensorsControllerTest
*   Author Email : pavel.siarzhantau@gmail.com 
*   Purpose      : primary purpose - test all methods with different scenarious in
                   SensorsController class
*   Revisions    : 30/09/2022 - Original
*      
*
**/
@isTest
public with sharing class SensorsControllerTest {
    @isTest
    static void getSensorsRecordsTest() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        Map<String, Sensor__c> mapOfSensorsWithEvents = new Map<String, Sensor__c>();
        List<Sensor__c> actualListOfSensorsEvents = new List<Sensor__c>();
        System.runAs(user) {
            mapOfSensorsWithEvents = TestDataFactory.createDuplicateRecords(
                250,
                1
            );
            Test.startTest();
            actualListOfSensorsEvents = SensorsController.getSensorsRecords();
            Test.stopTest();
            System.assertEquals(
                250,
                actualListOfSensorsEvents.size(),
                'Test: getSensorsRecordsTest() is failed'
            );
        }
    }
}