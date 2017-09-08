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
}