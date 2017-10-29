# Salesforce Merge History

Capture merge history for accounts, contacts and leads, enabling easy lookups
across multiple merge operations while also providing a means
to manually undo accidental merges.

## Installation

Zip up the **src** directory and deploy with [Workbench][1] or your favorite IDE.

[1]: https://workbench.developerforce.com

## Quick Start

Merge History captures history using **Merge Result** records. Every result
may have sets of fields that follow the same convention as the included
sample set.

Field Label | Field Name | Description
----------- | ---------- | -----------
Merged Record ID | `MergedRecordId__c` | The Salesforce ID of the merged record
Master Record ID | `MasterRecordId__c` | The Salesforce ID of the master record in the merge operation performed
Effective Master Record ID | `EffectiveMasterRecordId__c` | The Salesforce ID of the currently surviving master record, if the master record in this merge operation was later merged into another record. This field will always contain the ID of a surviving master record, unless that record was deleted by another non-merge process.

Merge History allows you to add custom fields such as external ID fields
to be included in merge results for easy crosswalks or lookups
in system integration or data migration use cases.

Let's say your Account object has a custom external ID field
named `NetsuiteCustomerId__c`, and you want to track this field value
in merge results.

1. On the Merge Result object, create a Merged Record field named `MergedRecordNetsuiteId__c`. Note that the field name _must_ start with `MergedRecord`.
2. On the Merge Result object, create a Master Record field named `MasterRecordNetsuiteId__c`. Note that the field name _must_ start with `MasterRecord`, and the rest of the name must match that of the Merged Record field.
3. On the Merge Result object, create an Effective Master Record field named `EffectiveMasterRecordNetsuiteId__c`. Note that the field name _must_ start with `EffectiveMasterRecord`, and the rest of the name must match that of the Merged Record field.
4. Add the record below to the Merge Result Field Mapping custom metadata type

Field | Value
----- | -----
Label | Account: NetSuite Customer ID
Merge Result Field Mapping Name | AccountNetsuiteCustomerId
Object | Account
Field Name | NetsuiteCustomerId__c
Result Field Ending | NetsuiteId__c

Remember to grant at least **Read** permission on all fields
on the Merge Result object to the System Administrator profile!
