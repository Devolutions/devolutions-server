using module '..\enums\CredentialSourceMode.generated.psm1'
using module '..\models\PartialConnectionCredentials.generated.psm1'
using module '..\models\SensitiveItem.generated.psm1'

class PuttyEntry
{
	[String]$CredentialConnectionId = ''
	[CredentialSourceMode]$CredentialMode = [CredentialSourceMode]::new()
	[PartialConnectionCredentials]$Credentials = [PartialConnectionCredentials]::new()
	[String]$Domain = ''
	[String]$Host = ''
	[SensitiveItem]$PasswordItem = [SensitiveItem]::new()
	[String]$Username = ''
}
