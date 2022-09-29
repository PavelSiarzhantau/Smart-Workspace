trigger SensorEventTrigger on Sensor_Event__c(
    after insert,
    after update,
    before insert,
    after delete
) {
    new SensorsEventsTriggerHandler().run();
}
