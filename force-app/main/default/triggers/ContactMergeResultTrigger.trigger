trigger ContactMergeResultTrigger on Contact (after delete) {
    
    // Look for the custom setting that controls merge result tracking
    MergeResultTrigger__c setting = MergeResultTrigger__c.getInstance(
        Schema.SobjectType.Contact.name
    );

    if (setting != null && setting.IsActive__c) {

        // Initialize the list of merge results to create
        List<MergeResult__c> results = new List<MergeResult__c>();

        // Get the merge result service for the correct object
        MergeResultService service =
                MergeResultService.getInstance(Contact.sobjectType);

        for (Sobject eachRecord : Trigger.old) {
            if (String.isNotBlank((Id)eachRecord.get('MasterRecordId'))) {
                results.add(service.getMergeResult(eachRecord));
            }
        }

        // Create the merge results
        insert results;
    }
}