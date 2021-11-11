using module '..\enums\CredentialSourceMode.generated.psm1'
using module '..\models\PartialConnectionCredentials.generated.psm1'
using module '..\models\SensitiveItem.generated.psm1'
using module '..\enums\WifiSecurity.generated.psm1'

class DataEntryWifi
{
	[String]$AirPortId = ''
	[SensitiveItem]$AttachedStoragePasswordItem = [SensitiveItem]::new()
	[String]$BaseStationName = ''
	[SensitiveItem]$BaseStationPasswordItem = [SensitiveItem]::new()
	[String]$CredentialConnectionId = ''
	[CredentialSourceMode]$CredentialMode = [CredentialSourceMode]::new()
	[PartialConnectionCredentials]$Credentials = [PartialConnectionCredentials]::new()
	[String]$NetworkName = ''
	[String]$ServerIpAddress = ''
	[String]$SupportPhoneNumber = ''
	[String]$Url = ''
	[SensitiveItem]$WirelessNetworkPasswordItem = [SensitiveItem]::new()
	[WifiSecurity]$WirelessSecurity = [WifiSecurity]::new()
}
