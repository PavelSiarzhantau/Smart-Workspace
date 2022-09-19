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
    public static List<Sensor__c> insertListOfSensors(
        Integer countOfSensors,
        Boolean ifInsert
    ) {
        List<Sensor__c> listOfSensorsToAdd = new List<Sensor__c>();
        for (Integer i = 0; i < countOfSensors; i++) {
            Sensor__c sensor = new Sensor__c(Name = 'sensor-' + i);
            listOfSensorsToAdd.add(sensor);
        }
        if (ifInsert) {
            insert listOfSensorsToAdd;
        }

        return listOfSensorsToAdd;
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
    public static Map<String, Sensor__c> createDuplicateRecords(
        Integer countOfSensors,
        Integer countOfEvents
    ) {
        // 1 create and insert Sensors with events in  database
        Integer counter = 0;
        List<Sensor__c> listOfSensors = insertListOfSensors(
            countOfSensors,
            true
        );
        List<Sensor_Event__c> listWithSensorsEventsToCreate = new List<Sensor_Event__c>();
        for (Sensor__c sensor : listOfSensors) {
            List<Sensor_Event__c> listOfEvents = createListofEvents(
                countOfEvents
            );
            for (Sensor_Event__c event : listOfEvents) {
                event.Sensor__c = sensor.Id;
                listWithSensorsEventsToCreate.add(event);
            }
        }
        insert listWithSensorsEventsToCreate;
        List<Sensor__c> listofSensorsFromDatabase = [
            SELECT Id, Name, (SELECT Id, Name FROM Sensor_Events__r)
            FROM Sensor__c
        ];
        List<Sensor_Event__c> listToUpdateRelationshipsOnEvent = new List<Sensor_Event__c>();
        for (Sensor__c sensor : listofSensorsFromDatabase) {
            counter = 0;
            for (Sensor_Event__c event : sensor.Sensor_Events__r) {
                if (counter != 0) {
                    event.Sensor_Event__c = sensor.Sensor_Events__r[counter - 1]
                        .Id;
                    listToUpdateRelationshipsOnEvent.add(event);
                    counter++;
                } else {
                    counter++;
                }
            }
        }
        update listToUpdateRelationshipsOnEvent;
        //2 Retrieve duplicate sensors from database
        List<Sensor__c> listOfSensorFromDatabase = [
            SELECT
                Id,
                Name,
                (
                    SELECT Id, Name
                    FROM Sensor_Events__r
                    ORDER BY Name DESC
                    LIMIT 1
                )
            FROM Sensor__c
            WHERE Id IN :listOfSensors
            WITH SECURITY_ENFORCED
        ];
        //3 Return map of duplicate sensors
        Map<String, Sensor__c> mapOfDuplicatedSensors = new Map<String, Sensor__c>();
        for (Sensor__c sensor : listOfSensorFromDatabase) {
            mapOfDuplicatedSensors.put(sensor.Name, sensor);
        }
        return mapOfDuplicatedSensors;
    }
    public static List<Sensor__c> getDataToTestUpdatingSensorsEvents(
        Integer countOfSensors,
        Integer countOfEvents
    ) {
        //1 Retrieve duplicate sensors from database
        List<Sensor__c> listOfSensorsFromDatabase = [
            SELECT Id, Name
            FROM Sensor__c
        ];
        Set<String> setOfNameSensorsFromDatabase = new Set<String>();
        //2 Create Sensors Events
        List<Sensor_Event__c> listOfSensorsEventsToCreate = new List<Sensor_Event__c>();
        for (Sensor__c sensor : listOfSensorsFromDatabase) {
            setOfNameSensorsFromDatabase.add(sensor.Name);
            List<Sensor_Event__c> listOfEvents = createListofEvents(
                countOfEvents
            );
            for (Sensor_Event__c event : listOfEvents) {
                event.Sensor__c = sensor.Id;
                listOfSensorsEventsToCreate.add(event);
            }
        }
        List<Sensor__c> listOfSensorsToCreatewithOutDuplicateNames = createListOfSensors(
            countOfSensors
        );
        Set<String> setOfNameSensorsToCreatewithOutDuplicateNames = new Set<String>();
        for (Sensor__c sensor : listOfSensorsToCreatewithOutDuplicateNames) {
            setOfNameSensorsToCreatewithOutDuplicateNames.add(sensor.Name);
        }
        insert listOfSensorsToCreatewithOutDuplicateNames;
        for (Sensor__c sensor : [
            SELECT Id, Name
            FROM Sensor__c
            WHERE Name IN :setOfNameSensorsToCreatewithOutDuplicateNames
        ]) {
            List<Sensor_Event__c> listOfEvents = createListofEvents(
                countOfEvents
            );
            for (Sensor_Event__c event : listOfEvents) {
                event.Sensor__c = sensor.Id;
                listOfSensorsEventsToCreate.add(event);
            }
        }
        insert listOfSensorsEventsToCreate;
        Set<String> setOfNamesOfSensorsToCreate = new Set<String>();
        setOfNamesOfSensorsToCreate.addAll(setOfNameSensorsFromDatabase);
        setOfNamesOfSensorsToCreate.addAll(
            setOfNameSensorsToCreatewithOutDuplicateNames
        );
        List<Sensor__c> listOfSensorsToReturn = [
            SELECT
                Id,
                Name,
                (
                    SELECT Id, Name, Sensor_Event__c, Sensor__r.Name
                    FROM Sensor_Events__r
                    WHERE Id IN :listOfSensorsEventsToCreate
                    ORDER BY Name ASC
                )
            FROM Sensor__c
            WHERE Name IN :setOfNamesOfSensorsToCreate
            WITH SECURITY_ENFORCED
        ];
        return listOfSensorsToReturn;
    }
}
