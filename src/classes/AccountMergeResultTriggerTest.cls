@isTest
private class AccountMergeResultTriggerTest {

    @isTest
    private static void mergeAccounts() {

        // Given
        Account acme = [
            SELECT Id
            FROM Account
            WHERE Name = 'Acme Corporation (TEST)'
        ];

        Account marvel = [
            SELECT Id
            FROM Account
            WHERE Name = 'Marvel Universe (TEST)'
        ];

        // When
        Test.startTest();

        merge acme marvel;

        // Then
        Test.stopTest();

        MergeResult__c result = [
            SELECT Id, MasterRecordId__c, MergedRecordId__c
            FROM MergeResult__c
            WHERE MergedRecordId__c = :marvel.Id
        ];

        System.assertEquals(acme.Id, result.MasterRecordId__c,
                Schema.MergeResult__c.fields.MasterRecordId__c.getDescribe().label);
    }

    @testSetup
    private static void setup() {

        // Create accounts
        Account acme = new Account(
                Name = 'Acme Corporation (TEST)');

        Account marvel = new Account(
                Name = 'Marvel Universe (TEST)');

        insert new List<Account> { acme, marvel };
    }
}