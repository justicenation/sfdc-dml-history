@isTest
private class DmlHistoryServiceTest {

    @isTest
    private static void trackDeleteAsyncApexJob() {

        // Given
        AsyncApexJob record = new AsyncApexJob();

        DmlHistoryService dmlHistory = new DmlHistoryService();

        // When
        Test.startTest();

        Id dmlOperationId = dmlHistory.trackDelete(
            new List<SObject> { record }
        );

        // Then
        Test.stopTest();

        System.assertNotEquals(
            null,
            dmlOperationId,
            Schema.SObjectType.DmlOperation__c.fields.Id.label
        );
    }
}
