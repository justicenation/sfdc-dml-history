trigger AccountMergeResultTrigger on Account (after delete) {

    // Initialize the list of merge results to create
    List<MergeResult__c> results = new List<MergeResult__c>();

    // Get the merge result service for the Account object
    MergeResultService service =
            MergeResultService.getInstance(Account.sobjectType);

    for (Sobject eachAccount : Trigger.old) {
        results.add(service.getMergeResult(eachAccount));
    }

    // Create the merge results
    insert results;
}