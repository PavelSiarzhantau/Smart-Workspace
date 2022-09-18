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
}
