global with sharing class DmlHistoryService {

    global DmlHistoryService() {
        /* Nothin' to see here */
    }

    global static DmlHistoryService getInstance() {
        return new DmlHistoryService();
    }

    global Id trackDelete(List<SObject> records) {
        return this.trackDelete(records, false);
    }

    /**
     * Track a `delete` operation, with the additional option to track
     * record ID values for the deleted operations in a separate
     * DML Operation Subject object.
     *
     * If `trackRecordIds` is true, this method will create one record
     * in the DML Operation Subject object for every record in `records`.
     *
     * @param records The deleted records to track
     *
     * @param trackRecordIds
     *            Whether to also track the record IDs for the deleted records
     *
     * @return the DML Operation ID of the history entry
     */
    global Id trackDelete(List<SObject> records, Boolean trackRecordIds) {

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

        // Log the deleted record IDs if asked to do so
        if (trackRecordIds) {
            this.trackRecordIds(op, records);
        }

        // Return the Delete Operation ID
        return op.Id;
    }

    @testVisible
    private void trackRecordIds(DmlOperation__c op, List<SObject> records) {

        // Initialize the list of DML Operation Subject records
        List<DmlOperationSubject__c> subjects =
                new List<DmlOperationSubject__c>();
        
        // Loop through the records and compile the subjects
        for (SObject eachRecord : records) {
            subjects.add(
                new DmlOperationSubject__c(
                    DmlOperation__c = op.Id,
                    DmlOperationType__c = op.Type__c,
                    SobjectName__c = op.SobjectName__c,
                    SubjectId__c = eachRecord.Id
                )
            );
        }

        // Create the records
        insert subjects;
    }
}
