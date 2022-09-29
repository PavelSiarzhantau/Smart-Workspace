public with sharing class SensorRestServiceModel {
    public static List<Sensor__c> getduplicateSensors(Set<String> sensorNamesFromRequest) {
        return [
            SELECT Id, 
                   Name, 
                   (SELECT Id, 
                           Name 
                    FROM Sensor_Events__r 
                    ORDER BY Name 
                    DESC LIMIT 1)
            FROM Sensor__c
            WHERE Name IN :sensorNamesFromRequest
            WITH SECURITY_ENFORCED
        ];
    }
    public static List<Sensor__c> getSensorsToUpdate(
        List<Sensor_Event__c> sensorEventsToCrearte,
        Set<String> sensorNamesFromRequest
    ) {
        return [
            SELECT Id,
                   Name,
                   (SELECT Id, 
                           Name, 
                           Sensor_Event__c, 
                           Sensor__r.Name
                    FROM Sensor_Events__r
                    WHERE Id IN :sensorEventsToCrearte
                    ORDER BY Name ASC
                )
            FROM Sensor__c
            WHERE Name IN :sensorNamesFromRequest
            WITH SECURITY_ENFORCED
        ];
    }
}
