/** 
*
*   Class Name   : SensorTrigger
*   Author Email : pavel.siarzhantau@gmail.com 
*   Purpose      : primary purpose - process dml events on Sensor__c object such us:
                   -after insert, 
                   -after update, 
                   -before insert, 
                   -after delete,
                   and call method which publish paltform event
*   Revisions    : 30/09/2022 - Original
*      
*
**/
trigger SensorTrigger on Sensor__c(
    before insert,
    after insert,
    after update,
    after delete
) {
    new SensorTriggerHandler().run();
}