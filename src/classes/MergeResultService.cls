global with sharing class MergeResultService {

    private static Map<String, MergeResultService> instanceMap =
            new Map<String, MergeResultService>();

    private String objectName;

    global MergeResultService(String objectName) {
        this.objectName = objectName;
    }

    global List<MergeResultFieldMapping__mdt> getFieldMappings() {
        return [
            SELECT FieldName__c, ResultFieldEnding__c
            FROM MergeResultFieldMapping__mdt
            WHERE SobjectName__c = :this.objectName
        ];
    }

    global static MergeResultService getInstance(SObjectType objectType) {
        return getInstance(objectType.getDescribe().getName());
    }

    global static MergeResultService getInstance(String objectName) {
        if (!instanceMap.containsKey(objectName)) {
            instanceMap.put(objectName, new MergeResultService(objectName));
        }

        return instanceMap.get(objectName);
    }

    global String getMasterRecordQuery(List<String> fieldNames) {
        List<String> queryParts = new List<String> {
            'SELECT ' + String.join(fieldNames, ', '),
            'FROM ' + this.objectName,
            'WHERE Id = :recordId'
        };

        return String.join(queryParts, ' ');
    }

    global Sobject getMasterRecord(Sobject mergedRecord) {

        // Get the record ID for the master record
        Id recordId = (Id)mergedRecord.get('MasterRecordId');

        // Return the result of the dynamic query for the master record,
        // a query which is assumed to always succeed
        List<String> fieldNames = new List<String>(
                mergedRecord.getSObjectType().getDescribe().fields.getMap().keySet());

        fieldNames.sort();

        return Database.query(getMasterRecordQuery(fieldNames));
    }

    global MergeResult__c getMergeResult(Sobject mergedRecord) {

        // Get the master record
        Sobject masterRecord = this.getMasterRecord(mergedRecord);

        // Construct the merge result
        MergeResult__c result = MergeResultUtil.newMergeResult(
                masterRecord, mergedRecord, this.getFieldMappings());

        // Return the contructed merge result
        return result;
    }
}