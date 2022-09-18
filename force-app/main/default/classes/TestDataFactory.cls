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
    public static Map<String, List<Sensor_Event__c>> createMapWithSensorsAndEvents() {
        Map<String, List<Sensor_Event__c>> mapWithSensorsAndEvents = new Map<String, List<Sensor_Event__c>>();
        List<Sensor_Event__c> listOfEvents = new List<Sensor_Event__c>();
        Sensor__c sensor = new Sensor__c(Name = '1');
        Sensor_Event__c event1 = new Sensor_Event__c(
            x__c = 22,
            y__c = 17,
            z__c = 197
        );
        Sensor_Event__c event2 = new Sensor_Event__c(
            x__c = 23,
            y__c = 45,
            z__c = 14
        );
        Sensor_Event__c event3 = new Sensor_Event__c(
            x__c = 22,
            y__c = 43,
            z__c = 196
        );
        Sensor_Event__c event4 = new Sensor_Event__c(
            x__c = 24,
            y__c = 42,
            z__c = 198
        );
        listOfEvents.add(event1);
        listOfEvents.add(event2);
        listOfEvents.add(event3);
        listOfEvents.add(event4);
        mapWithSensorsAndEvents.put(sensor.Name, listOfEvents);
        return mapWithSensorsAndEvents;
    }
    public static User createTestUser(String profile) {
        User user = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = :profile]
            .Id,
            LastName = 'last',
            Email = 'Cpt.Awesome@awesomesauce.com',
            UserName = 'Cpt.Awesome.' +
                DateTime.now().getTime() +
                '@awesomesauce.com',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        insert user;
        insert new PermissionSetAssignment(
            AssigneeId = user.Id,
            PermissionSetId = [
                SELECT Id
                FROM PermissionSet
                WHERE Name = 'Access_to_Sensor_and_sensor_events_access'
            ][0]
            .Id
        );
        return user;
    }
    public static List<Sensor__c> createListOfSensors(Integer countOfSensors) {
        List<Sensor__c> listOfSensors = new List<Sensor__c>();
        for (Integer i = 0; i < countOfSensors; i++) {
            Sensor__c sensor = new Sensor__c(Name = 'sensorTest-' + i);
            listOfSensors.add(sensor);
        }
        return listOfSensors;
    }
    public static Map<String, Sensor__c> createMapOfSensors(
        Integer countOfSensors,
        Boolean ifCreate
    ) {
        List<Sensor__c> listOfSensors = createListOfSensors(countOfSensors);
        if (ifCreate) {
            insert listOfSensors;
        }
        Map<String, Sensor__c> mapOfSensors = new Map<String, Sensor__c>();
        for (Sensor__c sensor : listOfSensors) {
            mapOfSensors.put(sensor.Name, sensor);
        }
        return mapOfSensors;
    }
    public static List<Sensor_Event__c> createListofEvents(
        Integer countOfEvents
    ) {
        List<Sensor_Event__c> listofSensorEvents = new List<Sensor_Event__c>();
        for (Integer i = 0; i < countOfEvents; i++) {
            Integer randomNumber1 = Integer.valueof((Math.random() * 100));
            Integer randomNumber2 = Integer.valueof((Math.random() * 100));
            Integer randomNumber3 = Integer.valueof((Math.random() * 100));
            Sensor_Event__c event = new Sensor_Event__c(
                x__c = randomNumber1,
                y__c = randomNumber2,
                z__c = randomNumber3
            );
            listofSensorEvents.add(event);
        }
        return listofSensorEvents;
    }
    public static Map<String, Sensor__c> getDuplicateSensorsMap(
        Integer countOfSensors
    ) {
        List<Sensor__c> listOfInsertedSensors = insertListOfSensors(
            countOfSensors,
            true
        );
        Map<String, Sensor__c> duplicateSensorsMap = new Map<String, Sensor__c>();
        for (Sensor__c sensor : listOfInsertedSensors) {
            duplicateSensorsMap.put(sensor.Name, sensor);
        }
        return duplicateSensorsMap;
    }
    public static Map<String, List<Sensor_Event__c>> createSensorsWithEvents(
        Integer countOfEvents,
        Integer countOfSensor
    ) {
        List<Sensor__c> listOfNamesOfSensorsFromDatabase = insertListOfSensors(
            countOfSensor,
            false
        );
        Set<String> setOfNamesOfSensorsFromDatabase = new Set<String>();
        for (Sensor__c sensor : listOfNamesOfSensorsFromDatabase) {
            setOfNamesOfSensorsFromDatabase.add(sensor.Name);
        }
        List<Sensor__c> listOfSensorsFromDatabase = [
            SELECT Id, Name
            FROM Sensor__c
            WHERE Name IN :setOfNamesOfSensorsFromDatabase
        ];
        List<Sensor__c> listOfSensors = createListOfSensors(countOfSensor);
        List<Sensor__c> finalLisrOfSensors = new List<Sensor__c>();
        Map<String, List<Sensor_Event__c>> mapSensorsWithEvents = new Map<String, List<Sensor_Event__c>>();
        finalLisrOfSensors.addAll(listOfSensorsFromDatabase);
        finalLisrOfSensors.addAll(listOfSensors);
        for (Sensor__c sensor : finalLisrOfSensors) {
            mapSensorsWithEvents.put(
                sensor.Name,
                createListofEvents(countOfEvents)
            );
        }
        return mapSensorsWithEvents;
    }
}
