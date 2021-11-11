using module '..\enums\CredentialSourceMode.generated.psm1'
using module '..\enums\OTPCodeSize.generated.psm1'
using module '..\enums\OTPCombineMode.generated.psm1'
using module '..\enums\OTPHashAlgorithm.generated.psm1'
using module '..\models\PartialConnectionCredentials.generated.psm1'
using module '..\models\RecoveryCodeItem.generated.psm1'
using module '..\models\SensitiveItem.generated.psm1'

class RootDetail
{
	[String]$CredentialConnectionId = ''
	[CredentialSourceMode]$CredentialMode = [CredentialSourceMode]::new()
	[PartialConnectionCredentials]$Credentials = [PartialConnectionCredentials]::new()
	[String]$Domain = ''
	[SensitiveItem]$PasswordItem = [SensitiveItem]::new()
	[String]$UserName = ''
	[String]$CredentialDynamicValue = ''
	[String]$CredentialDynamicDescription = ''
	[String]$PrivateVaultSearchString = ''
	[String]$PersonalCredentialConnectionId = ''
	[RecoveryCodeItem]$OtpRecoveryCodeItems = [RecoveryCodeItem]::new()
	[SensitiveItem]$OTPKeyItem = [SensitiveItem]::new()
	[OTPCodeSize]$OTPCodeSize = [OTPCodeSize]::new()
	[OTPCombineMode]$OTPCombineMode = [OTPCombineMode]::new()
	[String]$OTPConnectionID = ''
	[OTPHashAlgorithm]$OTPHashAlgorithm = [OTPHashAlgorithm]::new()
	[String]$OTPPrivateVaultSearchString = ''
	[String]$OTPQrCodeAccountName = ''
	[String]$OTPQrCodeApplicationName = ''
	[CredentialSourceMode]$OTPSourceMode = [CredentialSourceMode]::new()
	[int]$OTPTimeStep = 30
}
