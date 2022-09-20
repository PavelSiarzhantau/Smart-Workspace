public with sharing class SensorPlatformEvent {
    public static void publishEvent() {
        Sensor_Tracking_Event__e event = new Sensor_Tracking_Event__e();
        EventBus.publish(event);
        switch on Trigger.OperationType {
            when AFTER_INSERT {
                System.debug('Sensor was created');
            }
            when AFTER_UPDATE {
                System.debug('Sensor was updated');
            }
        }
    }
}
