@isTest
public with sharing class SensorRestServiceHelperTest {
    @isTest
    static void testGetParametersFromRequestPositive() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        RestRequest request = TestDataFactory.createMockRequest(true);
        Map<String, List<Sensor_Event__c>> expexted = TestDataFactory.createMapWithSensorsAndEvents();
        Map<String, List<Sensor_Event__c>> actual;
        Sensor_Event__c actualEvent;
        Integer count = 0;
        RestContext.request = request;
        System.runAs(user) {
            Test.startTest();
            actual = SensorRestServiceHelper.getParametersFromRequest(request);
            Test.stopTest();
        }
        System.assert(
            actual.size() != 0,
            'Test: actual returned list is Empty'
        );
        for (String sensor : expexted.keySet()) {
            count = 0;
            for (Sensor_Event__c event : expexted.get(sensor)) {
                actualEvent = new Sensor_Event__c();
                actualEvent = actual.get(sensor)[count];
                System.debug('EVENT ' + event + ' ACTUAL ' + actualEvent);
                System.assertEquals(
                    event,
                    actualEvent,
                    'TEST: equls events test is failed'
                );
                count++;
            }
        }
    }
    @isTest
    static void testGetParametersFromRequestNegative() {
        User user = TestDataFactory.createTestUser('Integration Profile');
        RestRequest request = TestDataFactory.createMockRequest(false);
        Map<String, List<Sensor_Event__c>> actual;
        String actualMessage;
        String expectedMessage = '::::INVALID INPUT::::, Please enter valid string';
        System.runAs(user) {
            Test.startTest();
            try {
                actual = SensorRestServiceHelper.getParametersFromRequest(
                    request
                );
            } catch (SensorRestService.SensorException e) {
                actualMessage = e.getMessage();
                System.assertEquals(
                    expectedMessage,
                    actualMessage,
                    'Test: testGetParametersFromRequestNegative() method is failed message don\'t meet'
                );
            }
            Test.stopTest();
        }
    }
}
