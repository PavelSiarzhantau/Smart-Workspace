/** 
*
*   Class Name   : SensorTriggerTest
*   Author Email : pavel.siarzhantau@gmail.com 
*   Purpose      : primary purpose - validate triggers on Sensor__c object
                   work correctly
*   Revisions    : 03/10/2022 - Original
*      
*
**/
@isTest
public with sharing class SensorTriggerTest {
    @TestSetup
    static void makeData() {
        List<Sensor__c> listofSensors = TestDataFactory.insertListOfSensors(
            300,
            true
        );
    }
    @isTest
    static void testInsertSensors() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        List<Sensor__c> listOfSensors;
        List<Database.SaveResult> result;
        System.runAs(user) {
            Test.startTest();
            listOfSensors = TestDataFactory.createListOfSensors(300);
            result = Database.insert(listOfSensors, false);
            Test.stopTest();
        }
        for (Database.SaveResult res : result) {
            System.assertEquals(
                true,
                res.isSuccess(),
                'Test: testInsertSensors() failed'
            );
        }
    }
    @isTest
    static void testUpdateSensors() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        List<Sensor__c> listOfSensors;
        List<Database.SaveResult> result;
        Integer counter = 0;
        System.runAs(user) {
            Test.startTest();
            listOfSensors = [SELECT Id, Name FROM Sensor__c];
            for (Sensor__c sensor : listOfSensors) {
                sensor.Name = 'PS_TEST ' + counter;
                counter++;
            }
            result = Database.update(listOfSensors, false);
            Test.stopTest();
        }
        for (Database.SaveResult res : result) {
            System.assertEquals(
                true,
                res.isSuccess(),
                'Test: testUpdateSensors() failed'
            );
        }
    }
    @isTest
    static void testDeleteSensors() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        List<Sensor__c> listOfSensors;
        List<Database.DeleteResult> result;
        System.runAs(user) {
            Test.startTest();
            listOfSensors = [SELECT ID, Name FROM Sensor__c];
            result = Database.delete(listOfSensors, false);
            Test.stopTest();
        }
        for (Database.DeleteResult res : result) {
            System.assertEquals(
                true,
                res.isSuccess(),
                'Test: testDeleteSensors() failed'
            );
        }
    }
    @isTest
    static void testInsertSensorsNegative() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        List<Sensor__c> listOfSensors;
        List<Database.SaveResult> result;
        String errorMessage = 'Artificially generated error';
        System.runAs(user) {
            Test.startTest();
            SensorTriggerHandler.createArtificialError = true;
            listOfSensors = TestDataFactory.createListOfSensors(300);
            result = Database.insert(listOfSensors, false);
            Test.stopTest();
        }
        for (Database.SaveResult res : result) {
            System.assertEquals(
                true,
                res.getErrors().size() != 0,
                'Test: testInsertSensorsNegative() failed'
            );
            System.assertEquals(
                true,
                res.getErrors()[0].getMessage().contains(errorMessage),
                'Test: testInsertSensorsNegative() failed'
            );
        }
    }
    @isTest
    static void testUpdateSensorsNegative(){
        User user = TestDataFactory.createTestUser('Integration Profile');
        List<Sensor__c> listOfSensors;
        List<Database.SaveResult> result;
        Integer counter = 0;
        String errorMessage = 'Artificially generated error';
        System.runAs(user) {
            Test.startTest();
            SensorTriggerHandler.createArtificialError = true;
            listOfSensors = [SELECT Id,
                                    Name 
                             FROM Sensor__c];
            for(Sensor__c sensor : listOfSensors){
                sensor.Name = 'PS_TEST ' + counter;
                counter++;
            }
            result = Database.update(listOfSensors, false);
            Test.stopTest();
        }
        for (Database.SaveResult res : result) {
            System.assertEquals(
                true,
                res.getErrors().size() != 0,
                'Test: testUpdateSensorsNegative() failed'
            );
            System.assertEquals(
                true,
                res.getErrors()[0].getMessage().contains(errorMessage),
                'Test: testUpdateSensorsNegative() failed'
            );
        }
    }
    @isTest
    static void testDeleteSensorsNegative(){
        User user = TestDataFactory.createTestUser('Integration Profile');
        List<Sensor__c> listOfSensors;
        List<Database.DeleteResult> result;
        Integer counter = 0;
        String errorMessage = 'Artificially generated error';
        System.runAs(user) {
            Test.startTest();
            SensorTriggerHandler.createArtificialError = true;
            listOfSensors = [SELECT Id,
                                    Name 
                             FROM Sensor__c];
            result = Database.delete(listOfSensors, false);
            Test.stopTest();
        }
        for (Database.DeleteResult res : result) {
            System.assertEquals(
                true,
                res.getErrors().size() != 0,
                'Test: testDeleteSensorsNegative() failed'
            );
            System.assertEquals(
                true,
                res.getErrors()[0].getMessage().contains(errorMessage),
                'Test: testDeleteSensorsNegative() failed'
            );
        }
    }

}