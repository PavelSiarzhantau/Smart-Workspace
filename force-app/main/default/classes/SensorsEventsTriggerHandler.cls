public with sharing class SensorsEventsTriggerHandler extends TriggerHandler {
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
        SensorPlatformEventHelper.publishEvent(
            Trigger.old,
            String.valueOf(Trigger.OperationType)
        );
    }
}
