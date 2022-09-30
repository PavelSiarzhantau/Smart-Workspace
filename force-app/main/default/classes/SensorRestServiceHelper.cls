/** 
*
*   Class Name   : SensorRestServiceHelper
*   Author Email : pavel.siarzhantau@gmail.com 
*   Purpose      : primary purpose - perform different logic to prepare sensors and
                   sensor events to save or update in database:
                   -parse request body 
                   -prevent duplicate sensors in database
                   -assign sensors to sensor events
                   -assign previous event to current event  in the right sequence 
*   Revisions    : 30/09/2022 - Original
*      
*
**/
public with sharing class SensorRestServiceHelper {
    public static Map<String, List<Sensor_Event__c>> getParametersFromRequest(
        RestRequest request
    ) {
        Map<String, List<Sensor_Event__c>> sensorsWithEvents = new Map<String, List<Sensor_Event__c>>();
        Map<String, Object> sensorWithEvent = new Map<String, Object>();
        List<Object> params;
        try {
            params = (List<Object>) JSON.deserializeUntyped(
                request.requestBody.toString()
                .replaceAll('[\'‘’"]', '"')
                .replaceAll('^(.*?)(")', '[')
                .replaceAll('(?:.(?!"))+$', ']')
            );
        } catch (Exception e) {
            throw new SensorRestService.SensorException(
                '::::INVALID INPUT::::, Please enter valid string'
            );
        }
        for (Object obj : params) {
            List<Object> listOfVectors;
            List<Sensor_Event__c> listOfEvents;
            sensorWithEvent = (Map<String, Object>) obj;
            if (sensorWithEvent.containsKey('vectors')) {
                listOfVectors = (List<Object>) sensorWithEvent.get('vectors');
                Map<String, Object> vector;
                listOfEvents = new List<Sensor_Event__c>();
                for (Object vc : listOfVectors) {
                    vector = (Map<String, Object>) vc;
                    Sensor_Event__c event = new Sensor_Event__c();
                    event.x__c = (Integer) vector.get('x');
                    event.y__c = (Integer) vector.get('y');
                    event.z__c = (Integer) vector.get('z');
                    listOfEvents.add(event);
                }
            } else {
                listOfEvents = new List<Sensor_Event__c>();
            }
            sensorsWithEvents.put(
                (String) sensorWithEvent.get('sensorid'),
                listOfEvents
            );
        }
        return sensorsWithEvents;
    }
    public static Map<String, Sensor__c> getduplicateSensorsMap(
        List<Sensor__c> duplicateSensors
    ) {
        Map<String, Sensor__c> duplicateSensorsMap = new Map<String, Sensor__c>();
        for (Sensor__c sensor : duplicateSensors) {
            duplicateSensorsMap.put(sensor.Name, sensor);
        }
        return duplicateSensorsMap;
    }
    public static Map<String, List<SObject>> separateSensors(
        Map<String, Sensor__c> duplicateSensorsMap,
        Map<String, List<Sensor_Event__c>> sensorsWithEvents
    ) {
        Map<String, List<SObject>> returnedResults = new Map<String, List<SObject>>();
        List<Sensor_Event__c> sensorEventsToCrearte = new List<Sensor_Event__c>();
        List<Sensor__c> sensorsToCreate = new List<Sensor__c>();
        for (String sensorName : sensorsWithEvents.keySet()) {
            if (duplicateSensorsMap.containsKey(sensorName)) {
                for (
                    Sensor_Event__c event : sensorsWithEvents.get(sensorName)
                ) {
                    event.Sensor__c = duplicateSensorsMap.get(sensorName).Id;
                    sensorEventsToCrearte.add(event);
                }
            } else {
                Sensor__c sensor = new Sensor__c();
                sensor.Name = sensorName;
                sensorsToCreate.add(sensor);
            }
        }
        returnedResults.put('sensorEventsToCrearte', sensorEventsToCrearte);
        returnedResults.put('sensorsToCreate', sensorsToCreate);
        return returnedResults;
    }
    public static List<Sensor_Event__c> assignSensorToSensorEvent(
        List<Sensor__c> createdSensors,
        Map<String, List<Sensor_Event__c>> sensorsWithEvents
    ) {
        List<Sensor_Event__c> sensorEventsToCrearte = new List<Sensor_Event__c>();
        for (Sensor__c sensor : createdSensors) {
            for (Sensor_Event__c event : sensorsWithEvents.get(sensor.Name)) {
                event.Sensor__c = sensor.Id;
                sensorEventsToCrearte.add(event);
            }
        }
        return sensorEventsToCrearte;
    }
    public static List<Sensor_Event__c> prepareSensorsEventsToUpdate(
        List<Sensor__c> updatedSensors,
        Map<String, Sensor__c> duplicateSensorsMap
    ) {
        Integer counter = 0;
        List<Sensor_Event__c> sensorsEventsToUpdate = new List<Sensor_Event__c>();
        for (Sensor__c sensor : updatedSensors) {
            counter = 0;
            for (Sensor_Event__c event : sensor.Sensor_Events__r) {
                if (!duplicateSensorsMap.containsKey((sensor.Name))) {
                    if (counter == 0) {
                        counter++;
                    } else {
                        event.Sensor_Event__c = sensor.Sensor_Events__r[
                                counter - 1
                            ]
                            .Id;
                        counter++;
                    }
                } else {
                    if (counter == 0) {
                        if (
                            duplicateSensorsMap.get(event.Sensor__r.Name)
                                .Sensor_Events__r.size() != 0
                        ) {
                            event.Sensor_Event__c = duplicateSensorsMap.get(
                                    event.Sensor__r.Name
                                )
                                .Sensor_Events__r[counter]
                                .Id;
                        }
                        counter++;
                    } else {
                        event.Sensor_Event__c = sensor.Sensor_Events__r[
                                counter - 1
                            ]
                            .Id;
                        counter++;
                    }
                }
                sensorsEventsToUpdate.add(event);
            }
        }
        return sensorsEventsToUpdate;
    }
}