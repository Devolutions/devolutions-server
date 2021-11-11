using module '..\enums\SyncActionEntryMismatch.generated.psm1'

class SynchronizerActiveDirectoryAdvanced
{
	[boolean]$SilentMode = $false
	[boolean]$VerifyFolderOnMismatch = $false
	[boolean]$UpdateNonCriticalFieldsOnMismatch = $false
	[SyncActionEntryMismatch]$EntryMismatchAction = [SyncActionEntryMismatch]::new()
	[String]$EntryMismatchDestinationGroup = ''
	[String]$EntryMismatchExpirationMessage = ''
}
