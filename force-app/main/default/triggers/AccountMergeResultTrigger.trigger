trigger AccountMergeResultTrigger on Account (after delete) {
    
    // Look for the custom setting that controls merge result tracking
    MergeResultTrigger__c setting = MergeResultTrigger__c.getInstance(
        Schema.SobjectType.Account.name
    );

    if (setting != null && setting.IsActive__c) {
        
        // Initialize the list of merge results to create
        List<MergeResult__c> results = new List<MergeResult__c>();

        // Get the merge result service for the Account object
        MergeResultService service =
                MergeResultService.getInstance(Account.sobjectType);

        for (Sobject eachRecord : Trigger.old) {
            if (String.isNotBlank((Id)eachRecord.get('MasterRecordId'))) {
                results.add(service.getMergeResult(eachRecord));
            }
        }

        // Create the merge results
        insert results;
    }
}