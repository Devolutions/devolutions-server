using module '..\enums\OTPCodeSize.generated.psm1'
using module '..\enums\OTPHashAlgorithm.generated.psm1'
using module '..\models\RecoveryCodeItem.generated.psm1'
using module '..\models\SensitiveItem.generated.psm1'

class CredentialOTP
{
	[OTPCodeSize]$OTPCodeSize = [OTPCodeSize]::new()
	[OTPHashAlgorithm]$OTPHashAlgorithm = [OTPHashAlgorithm]::new()
	[SensitiveItem]$OTPKeyItem = [SensitiveItem]::new()
	[int]$OTPTimeStep = 30
	[boolean]$AllowClipboard = $false
	[boolean]$AllowViewPasswordAction = $false
	[String]$OTPQrCodeAccountName = ''
	[String]$OTPQrCodeApplicationName = ''
	[RecoveryCodeItem]$OTPRecoveryCodes = [RecoveryCodeItem]::new()
}
