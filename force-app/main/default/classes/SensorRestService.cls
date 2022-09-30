/** 
*
*   Class Name   : SensorRestService
*   Author Email : pavel.siarzhantau@gmail.com 
*   Purpose      : primary purpose - handle request from external apllication, 
                   and perform logic to save or update sensors and sensor events,
                   current api rest service is able to obtain single string, or list of
                   strings in the body of POST request.
*   Revisions    : 30/09/2022 - Original
*      
*
**/
@RestResource(urlMapping='/Sensors/*')
global with sharing class SensorRestService {
    @TestVisible
    global static Boolean throwExceptionSensorsCreate = false;
    @TestVisible
    global static Boolean throwExceptionSensorsEventsCreate = false;
    @TestVisible
    global static Boolean throwExceptionSensorsEventsUpdate = false;
    @TestVisible
    global static final String TEST_EXCEPTION_MESSAGE = 'Test Error';
    global with sharing class SensorWrapper {
        global SensorWrapper() {
            System.debug('::::Init constructor:::');
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
        Map<String, List<Sensor_Event__c>> sensorsWithEventsFromRequest = new Map<String, List<Sensor_Event__c>>();
        Set<String> sensorNamesFromRequest = new Set<String>();
        List<Sensor__c> duplicateSensorsFromRequest = new List<Sensor__c>();
        Map<String, Sensor__c> duplicateSensorsFromRequestMap = new Map<String, Sensor__c>();
        Map<String, List<SObject>> separetedSensors = new Map<String, List<SObject>>();
        List<Sensor_Event__c> sensorEventsToCrearte = new List<Sensor_Event__c>();
        List<Sensor__c> sensorsToCreate = new List<Sensor__c>();
        List<Sensor_Event__c> additionSensorsEventsToCreate = new List<Sensor_Event__c>();
        List<Sensor__c> processedSensors = new List<Sensor__c>();
        List<Sensor_Event__c> sensorsEventsToUpdate = new List<Sensor_Event__c>();

        //CREATE sensors and events
        try {
            sensorsWithEventsFromRequest = SensorRestServiceHelper.getParametersFromRequest(
                RestContext.request
            );
        } catch (SensorException e) {
            return new SensorRestService.SensorWrapper(true, e.getMessage());
        }
        sensorNamesFromRequest = sensorsWithEventsFromRequest.keySet();
        duplicateSensorsFromRequest = SensorRestServiceModel.getduplicateSensors(
            sensorNamesFromRequest
        );
        duplicateSensorsFromRequestMap = SensorRestServiceHelper.getduplicateSensorsMap(
            duplicateSensorsFromRequest
        );
        separetedSensors = SensorRestServiceHelper.separateSensors(
            duplicateSensorsFromRequestMap,
            sensorsWithEventsFromRequest
        );
        sensorEventsToCrearte = separetedSensors.get('sensorEventsToCrearte');
        sensorsToCreate = separetedSensors.get('sensorsToCreate');
        if (
            Schema.sObjectType.Sensor__c.isCreateable() &&
            sensorsToCreate.size() != 0
        ) {
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
            sensorsWithEventsFromRequest
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
        processedSensors = SensorRestServiceModel.getSensorsToUpdate(
            sensorEventsToCrearte,
            sensorNamesFromRequest
        );
        sensorsEventsToUpdate = SensorRestServiceHelper.prepareSensorsEventsToUpdate(
            processedSensors,
            duplicateSensorsFromRequestMap
        );
        if (Schema.SObjectType.Sensor_Event__c.isUpdateable()) {
            try {
                if (throwExceptionSensorsEventsUpdate && Test.isRunningTest()) {
                    throw new SensorException(TEST_EXCEPTION_MESSAGE);
                }
                update sensorsEventsToUpdate;
            } catch (Exception e) {
                return new SensorRestService.SensorWrapper(
                    true,
                    e.getMessage()
                );
            }
        }

        SensorRestService.SensorWrapper response = new SensorRestService.SensorWrapper(
            false,
            '::::NO ERROR::::'
        );
        response.createdAndUpdatedSensors = processedSensors;
        return response;
    }
}