public with sharing class SensorRestServiceHelper {
    public static Map<String, List<Sensor_Event__c>> getParametersFromRequest(
        RestRequest request
    ) {
        System.debug('TEST ' + request.requestBody.toString());
        Map<String, List<Sensor_Event__c>> sensorsWithEvents = new Map<String, List<Sensor_Event__c>>();
        Map<String, Object> sensorWithEvent = new Map<String, Object>();
        List<Object> params;
        try {
            params = (List<Object>) JSON.deserializeUntyped(
                request.requestBody.toString()
                    .replaceAll('[\'‘’]', '"')
                    .replaceAll('^.', '[')
                    .replaceAll('.$', ']')
            );
        } catch (Exception e) {
            throw new SensorRestService.SensorException(
                '::::INVALID INPUT::::, Please enter valid string'
            );
        }
        System.debug('params' + params);
        for (Object obj : params) {
            sensorWithEvent = (Map<String, Object>) obj;
            List<Object> listOfVectors = (List<Object>) sensorWithEvent.get(
                'vectors'
            );
            Map<String, Object> vector;
            List<Sensor_Event__c> listOfEvents = new List<Sensor_Event__c>();
            for (Object vc : listOfVectors) {
                vector = (Map<String, Object>) vc;
                Sensor_Event__c event = new Sensor_Event__c();
                event.x__c = (Integer) vector.get('x');
                event.y__c = (Integer) vector.get('y');
                event.z__c = (Integer) vector.get('z');
                listOfEvents.add(event);
            }
            sensorsWithEvents.put(
                (String) sensorWithEvent.get('sensorid'),
                listOfEvents
            );
        }
        System.debug('sensorsWithEvents' + sensorsWithEvents);
        return sensorsWithEvents;
    }
}
