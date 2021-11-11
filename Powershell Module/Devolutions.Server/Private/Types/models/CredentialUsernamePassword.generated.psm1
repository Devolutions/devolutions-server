using module '..\enums\CredentialSourceMode.generated.psm1'
using module '..\enums\OTPCodeSize.generated.psm1'
using module '..\enums\OTPHashAlgorithm.generated.psm1'
using module '..\models\PartialConnectionCredentials.generated.psm1'
using module '..\models\RecoveryCodeItem.generated.psm1'
using module '..\models\SensitiveItem.generated.psm1'

class CredentialUsernamePassword
{
	[boolean]$AllowClipboard = $false
	[String]$CredentialConnectionId = ''
	[CredentialSourceMode]$CredentialMode = [CredentialSourceMode]::new()
	[PartialConnectionCredentials]$Credentials = [PartialConnectionCredentials]::new()
	[String]$Domain = ''
	[String]$MnemonicPassword = ''
	[SensitiveItem]$PasswordItem = [SensitiveItem]::new()
	[boolean]$PromptForPassword = $false
	[String]$UserName = ''
	[RecoveryCodeItem]$OtpRecoveryCodes = [RecoveryCodeItem]::new()
	[SensitiveItem]$OTPKeyItem = [SensitiveItem]::new()
	[OTPCodeSize]$OTPCodeSize = [OTPCodeSize]::new()
	[OTPHashAlgorithm]$OTPHashAlgorithm = [OTPHashAlgorithm]::new()
	[String]$OTPQrCodeAccountName = ''
	[String]$OTPQrCodeApplicationName = ''
	[int]$OTPTimeStep = 30
}
