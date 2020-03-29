global with sharing class MergeResultUtil {

    global static final String EFFECTIVE_MASTER_RECORD_PREFIX =
            'EffectiveMasterRecord';

    global static final String MASTER_RECORD_PREFIX = 'MasterRecord';

    global static final String MERGED_RECORD_PREFIX = 'MergedRecord';

    global static MergeResult__c newMergeResult(
            Sobject masterRecord, Sobject mergedRecord,
            List<MergeResultFieldMapping__mdt> mappings) {

        // Initialize the result with the bodies of each record
        MergeResult__c result = new MergeResult__c(
                SobjectName__c = masterRecord.getSObjectType().getDescribe().getName(),
                MasterRecordBody__c = JSON.serialize(masterRecord),
                MergedRecordBody__c = JSON.serialize(mergedRecord));

        // Store the notable values of interest to track
        for (MergeResultFieldMapping__mdt eachMapping : mappings) {

            // Figure out the expected field names
            String masterRecordFieldName =
                    MASTER_RECORD_PREFIX
                            + eachMapping.ResultFieldEnding__c;

            // Figure out the expected field names
            String mergedRecordFieldName =
                    MERGED_RECORD_PREFIX
                            + eachMapping.ResultFieldEnding__c;

            // Store the field values
            result.put(masterRecordFieldName, String.valueOf(
                    masterRecord.get(eachMapping.FieldName__c)));

            result.put(mergedRecordFieldName, String.valueOf(
                    mergedRecord.get(eachMapping.FieldName__c)));
        }

        return result;
    }
}