trigger MergeResultTrigger on MergeResult__c (
        before insert, after insert) {

    // Before insert, populate the Effective IDs if there are any to populate
    if (Trigger.isBefore && Trigger.isInsert) {
        for (MergeResult__c eachResult : Trigger.new) {

            // Get the merge result service
            MergeResultService service = MergeResultService.getInstance(
                    eachResult.SobjectName__c);

            // Populate the effective master record fields
            for (MergeResultFieldMapping__mdt eachMapping
                    : service.getFieldMappings()) {

                // Figure out the correct field names
                String effectiveMasterFieldName =
                        MergeResultUtil.EFFECTIVE_MASTER_RECORD_PREFIX
                                + eachMapping.ResultFieldEnding__c;

                String masterFieldName =
                        MergeResultUtil.MASTER_RECORD_PREFIX
                                + eachMapping.ResultFieldEnding__c;

                // Populate the effective master record fields
                eachResult.put(effectiveMasterFieldName,
                        eachResult.get(masterFieldName));
            }
        }
    }

    // After insert, update the Effective IDs if there are any to update
    // based on what was merged
    else if (Trigger.isAfter && Trigger.isInsert) {

        // Construct a map of the master record IDs using the merged record IDs 
        // as the key, so we can look for affected merge results from previous
        // merges where the Effective Master Record fields need to be updated.
        Map<Id, MergeResult__c> resultMap = new Map<Id, MergeResult__c>();

        for (MergeResult__c eachResult : Trigger.new) {
            resultMap.put(eachResult.MergedRecordId__c, eachResult);
        }

        // Find the affected results
        List<MergeResult__c> affectedResults = [
            SELECT Id, EffectiveMasterRecordId__c, SobjectName__c
            FROM MergeResult__c
            WHERE EffectiveMasterRecordId__c IN :resultMap.keySet()
        ];

        // Loop through all found results that need to be updated
        for (MergeResult__c eachResult : affectedResults) {

            // Grab the new merge result causing the retroactive update
            MergeResult__c newResult = resultMap.get(eachResult.EffectiveMasterRecordId__c);

            // Get the merge result service
            MergeResultService service = MergeResultService.getInstance(
                    eachResult.SobjectName__c);

            // Update the affected results' Effective Master Record fields
            for (MergeResultFieldMapping__mdt eachMapping : service.getFieldMappings()) {

                // Figure out the correct field names
                String effectiveMasterFieldName =
                        MergeResultUtil.EFFECTIVE_MASTER_RECORD_PREFIX
                                + eachMapping.ResultFieldEnding__c;

                // Populate the Effective Master Record fields
                eachResult.put(effectiveMasterFieldName,
                        newResult.get(effectiveMasterFieldName));
            }
        }

        // Update the affected results
        update affectedResults;
    }
}