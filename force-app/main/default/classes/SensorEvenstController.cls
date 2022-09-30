/** 
*
*   Class Name   : SensorEvenstController
*   Author Email : pavel.siarzhantau@gmail.com 
*   Purpose      : primary purpose - recieve list of sensor events to JS controller in appWrapper lwc.
*   Revisions    : 30/09/2022 - Original
*      
*
**/
public with sharing class SensorEvenstController {
    @auraEnabled(cacheable=true)
    public static List<Sensor_Event__c> getSensorsEventsRecords(String recordId) {
        return [
            SELECT Name,
                   Modulus_Vector_Length__c,
                   x__c,
                   y__c,
                   z__c,
                   Sensor__r.Max_Vectors_Length__c,
                   Sensor_Event__r.Name,
                   Sensor__r.Name,
                   CreatedDate
            FROM Sensor_Event__c
            WHERE Sensor__c = :recordId
            WITH SECURITY_ENFORCED
            ORDER BY Name DESC
        ];
    }
}