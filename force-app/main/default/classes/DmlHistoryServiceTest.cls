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

    @isTest
    private static void trackDeleteAccountsWithRecordIds() {

        // Given
        Account one = new Account(Name = 'One (Test)');

        Account two = new Account(Name = 'Two (Test)');

        List<Account> accounts = new List<Account> {
            one,
            two
        };

        insert accounts;

        // When
        Test.startTest();

        Id dmlOperationId = DmlHistoryService.getInstance().trackDelete(
            accounts,
            true
        );

        // Then
        Test.stopTest();

        List<DmlOperationSubject__c> subjects = [
            SELECT
                DmlOperationType__c,
                Id,
                SobjectName__c,
                SubjectId__c
            FROM DmlOperationSubject__c
            WHERE DmlOperation__c = :dmlOperationId
        ];

        // Assert expected subject values while compiling set of subject IDs
        Set<Id> subjectIdSet = new Set<Id>();

        for (DmlOperationSubject__c eachSubject : subjects) {
            subjectIdSet.add(eachSubject.SubjectId__c);

            System.assertEquals(
                'delete',
                eachSubject.DmlOperationType__c,
                Schema.SObjectType.DmlOperationSubject__c.fields.DmlOperationType__c.label
            );

            System.assertEquals(
                'Account',
                eachSubject.SobjectName__c,
                Schema.SObjectType.DmlOperationSubject__c.fields.SobjectName__c.label
            );
        }

        // Assert all expected accounts are captured in the tracked subjects
        System.assertEquals(
            accounts.size(),
            subjectIdSet.size(),
            'number of accounts and number of subjects should match'
        );

        for (Account eachAccount : accounts) {
            System.assert(
                subjectIdSet.contains(eachAccount.Id),
                'Subjects must contain Account ID ' + eachAccount.Id
            );
        }
    }
}
