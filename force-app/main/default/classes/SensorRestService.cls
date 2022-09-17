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
        SensorRestService.SensorWrapper response = new SensorRestService.SensorWrapper(
            false,
            '::::NO ERROR::::'
        );
        response.createdAndUpdatedSensors = sensorsToUpdate;
        return response;
    }
}
