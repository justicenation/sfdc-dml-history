@isTest
private class MergeResultServiceTest {

    @isTest
    private static void getAccountFieldMappings() {

        // Given
        MergeResultService service =
                MergeResultService.getInstance(Account.sobjectType);

        // When
        Test.startTest();

        List<MergeResultFieldMapping__mdt> mappings =
                service.getFieldMappings();

        // Then
        Test.stopTest();

        // Look through the mappings for one that maps the native `Id`
        // field to the `Id__c` field ending
        MergeResultFieldMapping__mdt idMapping = null;

        for (MergeResultFieldMapping__mdt eachMapping : mappings) {
            if (eachMapping.FieldName__c == 'Id'
                    && eachMapping.ResultFieldEnding__c == 'Id__c') {
                idMapping = eachMapping;
            }
        }

        System.assert(idMapping != null, 'Account ID mapping not found!');
    }

    @isTest
    private static void getContactFieldMappings() {

        // Given
        MergeResultService service =
                MergeResultService.getInstance(Contact.sobjectType);

        // When
        Test.startTest();

        List<MergeResultFieldMapping__mdt> mappings =
                service.getFieldMappings();

        // Then
        Test.stopTest();

        // Look through the mappings for one that maps the native `Id`
        // field to the `Id__c` field ending
        MergeResultFieldMapping__mdt idMapping = null;

        for (MergeResultFieldMapping__mdt eachMapping : mappings) {
            if (eachMapping.FieldName__c == 'Id'
                    && eachMapping.ResultFieldEnding__c == 'Id__c') {
                idMapping = eachMapping;
            }
        }

        System.assert(idMapping != null, 'Contact ID mapping not found!');
    }
}