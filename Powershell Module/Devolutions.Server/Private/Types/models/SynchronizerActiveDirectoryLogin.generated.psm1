using module '..\models\SensitiveItem.generated.psm1'

class SynchronizerActiveDirectoryLogin
{
	[String]$Username = ''
	[String]$Domain = ''
	[SensitiveItem]$Password = [SensitiveItem]::new()
	[boolean]$MergeUsernameAndDomain = $false
}
