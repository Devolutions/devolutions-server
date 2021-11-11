using module '..\enums\ActiveDirectoryDuplicateCheck.generated.psm1'
using module '..\enums\ActiveDirectorySearchScope.generated.psm1'

class SynchronizerActiveDirectorySearch
{
	[ActiveDirectorySearchScope]$SearchScope = [ActiveDirectorySearchScope]::new()
	[ActiveDirectoryDuplicateCheck]$DuplicateCheck = [ActiveDirectoryDuplicateCheck]::new()
}
