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
            SELECT Id,
                EffectiveMasterRecordId__c,
                MasterRecordId__c, MergedRecordId__c
            FROM MergeResult__c
            WHERE MergedRecordId__c = :marvel.Id
        ];

        System.assertEquals(acme.Id, result.EffectiveMasterRecordId__c,
                Schema.MergeResult__c.fields.EffectiveMasterRecordId__c.getDescribe().label);

        System.assertEquals(acme.Id, result.MasterRecordId__c,
                Schema.MergeResult__c.fields.MasterRecordId__c.getDescribe().label);
    }

    @isTest
    private static void mergeAccountsTwice() {

        // Given
        Account acme = [
            SELECT Id
            FROM Account
            WHERE Name = 'Acme Corporation (TEST)'
        ];

        Account dc = [
            SELECT Id
            FROM Account
            WHERE Name = 'DC Universe (TEST)'
        ];

        Account marvel = [
            SELECT Id
            FROM Account
            WHERE Name = 'Marvel Universe (TEST)'
        ];

        // When
        Test.startTest();

        merge dc acme;
        merge marvel dc;

        // Then
        Test.stopTest();

        MergeResult__c firstMergeResult = [
            SELECT Id,
                EffectiveMasterRecordId__c
            FROM MergeResult__c
            WHERE MasterRecordId__c = :dc.Id
            AND MergedRecordId__c = :acme.Id
        ];

        System.assertEquals(marvel.Id, firstMergeResult.EffectiveMasterRecordId__c,
                Schema.MergeResult__c.fields.EffectiveMasterRecordId__c.getDescribe().label);

        MergeResult__c secondMergeResult = [
            SELECT Id,
                EffectiveMasterRecordId__c
            FROM MergeResult__c
            WHERE MasterRecordId__c = :marvel.Id
            AND MergedRecordId__c = :dc.Id
        ];

        System.assertEquals(marvel.Id, secondMergeResult.EffectiveMasterRecordId__c,
                Schema.MergeResult__c.fields.EffectiveMasterRecordId__c.getDescribe().label);
    }

    @testSetup
    private static void setup() {

        // Create accounts
        Account acme = new Account(
                Name = 'Acme Corporation (TEST)');

        Account dc = new Account(
                Name = 'DC Universe (TEST)');

        Account marvel = new Account(
                Name = 'Marvel Universe (TEST)');

        insert new List<Account> { acme, dc, marvel };
    }
}