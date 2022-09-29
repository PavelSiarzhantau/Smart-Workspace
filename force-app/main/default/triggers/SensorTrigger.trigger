trigger SensorTrigger on Sensor__c(
    before insert,
    after insert,
    after update,
    after delete
) {
    new SensorTriggerHandler().run();
}
