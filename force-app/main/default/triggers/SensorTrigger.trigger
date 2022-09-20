trigger SensorTrigger on Sensor__c(after insert, after update, after delete) {
    new SensorTriggerHandler().run();
}
