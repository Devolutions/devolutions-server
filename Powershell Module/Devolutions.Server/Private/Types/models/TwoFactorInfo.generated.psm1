using module '..\enums\AlternateTwoFactorType.generated.psm1'
using module '..\enums\AzureMFAMode.generated.psm1'
using module '..\enums\DuoCapability.generated.psm1'
using module '..\enums\TwoFactorAuthenticationType.generated.psm1'

class TwoFactorInfo
{
	[String]$AccountName = ''
	[String]$AlternateBackupCodesSalt = ''
	[AlternateTwoFactorType]$AlternateTwoFactorType = [AlternateTwoFactorType]::new()
	[TwoFactorAuthenticationType]$AuthenticationType = [TwoFactorAuthenticationType]::new()
	[String]$CountryCode = ''
	[DuoCapability]$DuoSelectedCapability = [DuoCapability]::new()
	[String]$DuoSelectedDeviceID = ''
	[String]$DuoTrustedDevicesToken = ''
	[DuoCapability]$DuoAutoCapability = [DuoCapability]::new()
	[boolean]$IsAvailable = $false
	[boolean]$IsConfigured = $false
	[boolean]$IsDPSTwoFactor = $false
	[boolean]$IsDuoTrustedDevices = $false
	[boolean]$IsPreConfigured = $false
	[boolean]$IsPreConfiguredByUser = $false
	[boolean]$IsTwilio = $false
	[String]$Key = ''
	[AzureMFAMode]$MfaMode = [AzureMFAMode]::new()
	[String]$Phone = ''
	[String]$PhoneExt = ''
	[string[]]$SafeAlternateBackupCodes = [string[]]::new()
	[String]$ValidationCode = ''
}
