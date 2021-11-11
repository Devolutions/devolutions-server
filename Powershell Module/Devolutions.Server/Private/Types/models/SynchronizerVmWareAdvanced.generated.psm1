using module '..\enums\ActiveDirectoryDuplicateCheck.generated.psm1'
using module '..\enums\SyncActionEntryMismatch.generated.psm1'

class SynchronizerVmWareAdvanced
{
	[ActiveDirectoryDuplicateCheck]$DuplicateCheck = [ActiveDirectoryDuplicateCheck]::new()
	[SyncActionEntryMismatch]$EntryMismatchAction = [SyncActionEntryMismatch]::new()
	[String]$EntryMismatchDestinationGroup = ''
	[String]$EntryMismatchExpirationMessage = ''
	[boolean]$IgnoreEntryTypeOnDuplicateCheck = $false
	[String]$SessionNamePrefix = ''
	[String]$SessionNameSuffix = ''
	[boolean]$SilentMode = $false
}
