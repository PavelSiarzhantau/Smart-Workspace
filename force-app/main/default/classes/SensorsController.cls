public with sharing class SensorsController {
    @auraEnabled(cacheable=true)
    public static List<Sensor__c> getSensorsRecords() {
        return [
            SELECT Name, Max_Vectors_Length__c, CreatedDate, OwnerId, Owner.Name
            FROM Sensor__c
            WITH SECURITY_ENFORCED
            ORDER BY CreatedDate DESC
        ];
    }
}
