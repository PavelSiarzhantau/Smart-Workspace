/** 
*
*   Class Name   : SensorsController
*   Author Email : pavel.siarzhantau@gmail.com 
*   Purpose      : primary purpose - recieve list of sensor to JS controller in appWrapper lwc.
                   SensorRestService class
*   Revisions    : 30/09/2022 - Original
*      
*
**/
public with sharing class SensorsController {
    @auraEnabled(cacheable=true)
    public static List<Sensor__c> getSensorsRecords() {
        return [
            SELECT Name, 
                   Max_Vectors_Length__c, 
                   CreatedDate, 
                   OwnerId, 
                   Owner.Name
            FROM Sensor__c
            WITH SECURITY_ENFORCED
            ORDER BY CreatedDate DESC
        ];
    }
}