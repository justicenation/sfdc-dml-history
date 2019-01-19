global class DmlHistoryService {

    global DmlHistoryService() {
        /* Nothin' to see here */
    }

    global static DmlHistoryService getInstance() {
        return new DmlHistoryService();
    }

    global Id trackDelete(List<SObject> records) {

        // Initialize the Delete Operation record
        DmlOperation__c op = new DmlOperation__c(
            NumberOfRecords__c = records.size(),
            SobjectName__c = DmlHistoryUtil.getSobjectName(records),
            Type__c = DmlHistoryUtil.DELETE_TYPE
        );

        // Create the record and remember the ID
        insert op;

        // Create the Salesforce File version
        ContentVersion version = DmlHistoryUtil.newContentVersion(
            DmlHistoryUtil.DELETE_OPERATION_TITLE,
            records
        );

        insert version;

        // Link the content document to the record
        insert DmlHistoryUtil.newContentDocumentLink(
            [
                SELECT
                    ContentDocumentId,
                    Id
                FROM ContentVersion
                WHERE Id = :version.Id
            ].ContentDocumentId,
            op.Id
        );

        // Return the Delete Operation ID
        return op.Id;
    }
}
