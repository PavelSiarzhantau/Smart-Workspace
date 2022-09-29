public with sharing class SensorPlatformEventHelper {
    public class SensorPaltformEventException extends Exception {
    }
    @TestVisible
    public static Boolean isTest = false;
    public static Boolean isInsert = false;
    public static List<Sensor_Tracking_Event__e> events = new List<Sensor_Tracking_Event__e>();
    public static final String TEST_EXCEPTION_MESSAGE = 'Test Error';
    //Publish event after insert, after update, after delete on Sensor__c and Sensor_Event__c object
    public static void publishEvent(List<SObject> sensorList, String context) {
        Sensor_Tracking_Event__e event = new Sensor_Tracking_Event__e();
        List<String> namesOfSensors = new List<String>();
        String objectName = sensorList[0]
            .getSObjectType()
            .getDescribe()
            .getLabel();
        for (SObject sensor : sensorList) {
            if (sensor.getSObjectType() == Sensor__c.getSObjectType()) {
                Sensor__c sen = (Sensor__c) sensor;
                namesOfSensors.add(objectName + ': ' + sen.Name + '\n');
            } else if (
                sensor.getSObjectType() == Sensor_Event__c.getSObjectType()
            ) {
                Sensor_Event__c evt = (Sensor_Event__c) sensor;
                namesOfSensors.add(objectName + ': ' + evt.Name + '\n');
            }
        }
        event.Sensors_names__c = String.join(namesOfSensors, '');
        switch on context {
            when 'BEFORE_INSERT' {
                isInsert = true;
                System.debug('isInsert::: ' + isInsert);
            }
            when 'AFTER_INSERT' {
                event.message__c = objectName + '(s) were inserted.';
                events.add(event);
                sendEventToEventBus(event);
                System.debug(objectName + '(s) was inserted');
            }
            when 'AFTER_UPDATE' {
                if (!isInsert) {
                    event.message__c = objectName + '(s) were updated.';
                    events.add(event);
                    sendEventToEventBus(event);
                    System.debug(objectName + '(s) were updated');
                }
            }
            when 'AFTER_DELETE' {
                event.message__c = objectName + '(s) were deleted.';
                events.add(event);
                sendEventToEventBus(event);
                System.debug(objectName + '(s) were deleted');
            }
        }
    }
    @TestVisible
    private static void sendEventToEventBus(Sensor_Tracking_Event__e event) {
        try {
            if (isTest && Test.isRunningTest()) {
                throw new SensorPaltformEventException(TEST_EXCEPTION_MESSAGE);
            }
            EventBus.publish(event);
        } catch (Exception e) {
            throw new SensorPaltformEventException(
                'Some error occured, when publishing event: ' + e.getMessage()
            );
        }
    }
}
