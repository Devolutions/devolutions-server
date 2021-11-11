using module '..\enums\BrowserExtensionLinkerCompareType.generated.psm1'
using module '..\enums\CredentialSourceMode.generated.psm1'
using module '..\models\EquivalentUrlItem.generated.psm1'
using module '..\models\PartialConnectionCredentials.generated.psm1'
using module '..\models\SensitiveItem.generated.psm1'

class DataEntryAccount
{
	[PartialConnectionCredentials]$Credentials = [PartialConnectionCredentials]::new()
	[String]$CredentialConnectionId = ''
	[CredentialSourceMode]$CredentialMode = [CredentialSourceMode]::new()
	[String]$Domain = ''
	[SensitiveItem]$PasswordItem = [SensitiveItem]::new()
	[String]$Url = ''
	[BrowserExtensionLinkerCompareType]$UrlCompareType = [BrowserExtensionLinkerCompareType]::new()
	[String]$UserName = ''
	[EquivalentUrlItem]$EquivalentUrls = [EquivalentUrlItem]::new()
	[boolean]$EnableWebBrowserExtension = $true
	[String]$RegularExpression = ''
}
