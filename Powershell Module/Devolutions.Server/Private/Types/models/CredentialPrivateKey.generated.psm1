using module '..\models\PartialConnectionCredentials.generated.psm1'
using module '..\enums\PrivateKeyType.generated.psm1'
using module '..\models\SensitiveItem.generated.psm1'

class CredentialPrivateKey
{
	[boolean]$AllowClipboard = $false
	[boolean]$AllowViewPasswordAction = $false
	[boolean]$PrivateKeyAutomaticallyLoadToKeyAgent = $false
	[SensitiveItem]$PrivateKeyData = [SensitiveItem]::new()
	[String]$PrivateKeyFileName = ''
	[SensitiveItem]$PrivateKeyOverridePasswordItem = [SensitiveItem]::new()
	[String]$PrivateKeyOverrideUsername = ''
	[SensitiveItem]$PrivateKeyPassPhraseItem = [SensitiveItem]::new()
	[boolean]$PrivateKeyPromptForPassPhrase = $false
	[PrivateKeyType]$PrivateKeyType = [PrivateKeyType]::new()
	[PartialConnectionCredentials]$Credentials = [PartialConnectionCredentials]::new()
}
