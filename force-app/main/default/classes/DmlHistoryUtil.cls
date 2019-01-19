global class DmlHistoryUtil {

    global static final String DELETE_OPERATION_TITLE = 'delete';

    global static final String DELETE_TYPE = 'delete';

    global static final String INFERRED_PERMISSION_SHARE_TYPE = 'I';

    global static final String JSON_FILE_EXTENSION = '.json';

    global static final String JSON_FILE_TYPE = 'application/json';

    global static String getSobjectName(SObject record) {
        return record.getSObjectType().getDescribe().getName();
    }

    global static String getSobjectName(List<SObject> records) {
        return getSobjectName(records.get(0));
    }

    global static ContentDocumentLink newContentDocumentLink(
        Id contentDocumentId,
        Id linkedEntityId
    ) {
        return new ContentDocumentLink(
            ContentDocumentId = contentDocumentId,
            LinkedEntityId = linkedEntityId,
            ShareType = INFERRED_PERMISSION_SHARE_TYPE
        );
    }

    global static ContentVersion newContentVersion(
        String title,
        List<SObject> records
    ) {
        
        // Transform the data
        String recordsJson = JSON.serializePretty(records);
        String recordsData =
                EncodingUtil.base64Encode(Blob.valueOf(recordsJson));

        // Return a newly constructed record with the data
        return new ContentVersion(
            PathOnClient = title + JSON_FILE_EXTENSION,
            Title = title,
            VersionData = Blob.valueOf(recordsData)
        );
    }
}
