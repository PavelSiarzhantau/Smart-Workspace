/** 
*
*   Class Name   : SensorEventTrigger
*   Author Email : pavel.siarzhantau@gmail.com 
*   Purpose      : primary purpose - process dml events on Sensor_Event__c object such us:
                   -after insert, 
                   -after update, 
                   -before insert, 
                   -after delete,
                   and call method which publish paltform event
*   Revisions    : 30/09/2022 - Original
*      
*
**/
trigger SensorEventTrigger on Sensor_Event__c(
    after insert,
    after update,
    before insert,
    after delete
) {
    new SensorsEventsTriggerHandler().run();
}