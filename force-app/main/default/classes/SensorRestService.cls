@RestResource(urlMapping='/Sensors/*')
global with sharing class SensorRestService {
    global with sharing class SensorWrapper {
        global SensorWrapper() {
            System.debug('init constructor');
        }
        global SensorWrapper(Boolean isError, String message) {
            this.createdAndUpdatedSensors = new List<Sensor__c>();
            if (isError) {
                this.statusCode = 500;
                this.isError = true;
                this.errorMessage = message;
            } else {
                this.statusCode = 200;
                this.isError = false;
                this.errorMessage = '::::NO ERROR::::';
            }
        }
        global List<Sensor__c> createdAndUpdatedSensors { get; set; }
        global Boolean isError { get; set; }
        global String errorMessage { get; set; }
        global Integer statusCode { get; set; }
    }
    global class SensorException extends Exception {
    }
    @HttpPost
    global static SensorRestService.SensorWrapper createOrUpdateSensorWithEvents() {
        Map<String, List<Sensor_Event__c>> sensorsWithEvents = new Map<String, List<Sensor_Event__c>>();
        Set<String> sensorNamesFromRequest = new Set<String>();
        List<Sensor__c> duplicateSensors = new List<Sensor__c>();
        Map<String, Sensor__c> duplicateSensorsMap = new Map<String, Sensor__c>();
        Map<String, List<SObject>> separetedSensors = new Map<String, List<SObject>>();
        List<Sensor_Event__c> sensorEventsToCrearte = new List<Sensor_Event__c>();
        List<Sensor__c> sensorsToCreate = new List<Sensor__c>();
        List<Sensor_Event__c> additionSensorsEventsToCreate = new List<Sensor_Event__c>();
        List<Sensor__c> sensorsToUpdate = new List<Sensor__c>();
        List<Sensor_Event__c> sensorsEventsToUpdate = new List<Sensor_Event__c>();
        Integer counter = 0;

        //CREATE sensors and events
        try {
            sensorsWithEvents = SensorRestServiceHelper.getParametersFromRequest(
                RestContext.request
            );
        } catch (SensorException e) {
            return new SensorRestService.SensorWrapper(true, e.getMessage());
        }
        sensorNamesFromRequest = sensorsWithEvents.keySet();
        duplicateSensors = SensorRestServiceModel.getduplicateSensors(
            sensorNamesFromRequest
        );
        duplicateSensorsMap = SensorRestServiceHelper.getduplicateSensorsMap(
            duplicateSensors
        );
        separetedSensors = SensorRestServiceHelper.separateSensors(
            duplicateSensorsMap,
            sensorsWithEvents
        );
        sensorEventsToCrearte = separetedSensors.get('sensorEventsToCrearte');
        sensorsToCreate = separetedSensors.get('sensorsToCreate');
        if (Schema.sObjectType.Sensor__c.isCreateable()) {
            try {
                if (throwExceptionSensorsCreate && Test.isRunningTest()) {
                    throw new SensorException(TEST_EXCEPTION_MESSAGE);
                }
                insert sensorsToCreate;
            } catch (Exception e) {
                return new SensorRestService.SensorWrapper(
                    true,
                    e.getMessage()
                );
            }
        }
        additionSensorsEventsToCreate = SensorRestServiceHelper.assignSensorToSensorEvent(
            sensorsToCreate,
            sensorsWithEvents
        );
        sensorEventsToCrearte.addAll(additionSensorsEventsToCreate);
        if (Schema.sObjectType.Sensor_Event__c.isCreateable()) {
            try {
                if (throwExceptionSensorsEventsCreate && Test.isRunningTest()) {
                    throw new SensorException(TEST_EXCEPTION_MESSAGE);
                }
                insert sensorEventsToCrearte;
            } catch (Exception e) {
                return new SensorRestService.SensorWrapper(
                    true,
                    e.getMessage()
                );
            }
        }

        //UPDATE Sensor Events
        sensorsToUpdate = SensorRestServiceModel.getSensorsToUpdate(
            sensorEventsToCrearte,
            sensorNamesFromRequest
        );
        SensorRestService.SensorWrapper response = new SensorRestService.SensorWrapper(
            false,
            '::::NO ERROR::::'
        );
        response.createdAndUpdatedSensors = sensorsToUpdate;
        return response;
    }
}
