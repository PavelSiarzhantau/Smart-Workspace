/** 
*
*   Class Name   : SensorsEventsTriggerHandler
*   Author Email : pavel.siarzhantau@gmail.com 
*   Purpose      : primary purpose - separate operation types from Trigger on
                   Sensor_Event__c objects.
*   Revisions    : 30/09/2022 - Original
*      
*
**/
public with sharing class SensorsEventsTriggerHandler extends TriggerHandler {
    public static boolean createArtificialError = false;
    public with sharing class ArtificialErrorException extends Exception{}
    public override void afterInsert() {
        SensorPlatformEventHelper.publishEvent(
            Trigger.new,
            String.valueOf(Trigger.OperationType)
        );
    }
    public override void afterUpdate() {
        SensorPlatformEventHelper.publishEvent(
            Trigger.new,
            String.valueOf(Trigger.OperationType)
        );
    }
    public override void beforeInsert() {
        SensorPlatformEventHelper.publishEvent(
            Trigger.new,
            String.valueOf(Trigger.OperationType)
        );
    }
    public override void afterDelete() {
        if(createArtificialError){
            throw new ArtificialErrorException('Artificially generated error');
        }
        SensorPlatformEventHelper.publishEvent(
            Trigger.old,
            String.valueOf(Trigger.OperationType)
        );
    }
}