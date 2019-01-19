@isTest
private class ContactMergeResultTriggerTest {

    @isTest
    private static void mergeContacts() {

        // Given
        Contact bugs = [
            SELECT Id
            FROM Contact
            WHERE LastName = 'Bunny (TEST)'
        ];

        Contact daffy = [
            SELECT Id
            FROM Contact
            WHERE LastName = 'Duck (TEST)'
        ];

        // When
        Test.startTest();

        merge bugs daffy;

        // Then
        Test.stopTest();

        MergeResult__c result = [
            SELECT Id,
                EffectiveMasterRecordId__c,
                MasterRecordId__c, MergedRecordId__c
            FROM MergeResult__c
            WHERE MergedRecordId__c = :daffy.Id
        ];

        System.assertEquals(bugs.Id, result.EffectiveMasterRecordId__c,
                Schema.MergeResult__c.fields.EffectiveMasterRecordId__c.getDescribe().label);

        System.assertEquals(bugs.Id, result.MasterRecordId__c,
                Schema.MergeResult__c.fields.MasterRecordId__c.getDescribe().label);
    }

    @isTest
    private static void mergeContactsTwice() {

        // Given
        Contact bugs = [
            SELECT Id
            FROM Contact
            WHERE LastName = 'Bunny (TEST)'
        ];

        Contact daffy = [
            SELECT Id
            FROM Contact
            WHERE LastName = 'Duck (TEST)'
        ];

        Contact elmer = [
            SELECT Id
            FROM Contact
            WHERE LastName = 'Fudd (TEST)'
        ];

        // When
        Test.startTest();

        merge daffy elmer;
        merge bugs daffy;

        // Then
        Test.stopTest();

        MergeResult__c firstMergeResult = [
            SELECT Id,
                EffectiveMasterRecordId__c
            FROM MergeResult__c
            WHERE MasterRecordId__c = :daffy.Id
            AND MergedRecordId__c = :elmer.Id
        ];

        System.assertEquals(bugs.Id, firstMergeResult.EffectiveMasterRecordId__c,
                Schema.MergeResult__c.fields.EffectiveMasterRecordId__c.getDescribe().label);

        MergeResult__c secondMergeResult = [
            SELECT Id,
                EffectiveMasterRecordId__c
            FROM MergeResult__c
            WHERE MasterRecordId__c = :bugs.Id
            AND MergedRecordId__c = :daffy.Id
        ];

        System.assertEquals(bugs.Id, secondMergeResult.EffectiveMasterRecordId__c,
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

        // Create contacts
        Contact bugs = new Contact(
                AccountId = acme.Id,
                FirstName = 'Bugs',
                LastName = 'Bunny (TEST)');

        Contact daffy = new Contact(
                AccountId = acme.Id,
                FirstName = 'Daffy',
                LastName = 'Duck (TEST)');

        Contact elmer = new Contact(
                AccountId = acme.Id,
                FirstName = 'Elmer',
                LastName = 'Fudd (TEST)');

        insert new List<Contact> { bugs, daffy, elmer };
    }
}