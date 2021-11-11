using module '..\models\BaseSessionEntry.generated.psm1'
using module '..\enums\ProxyTunnelType.generated.psm1'
using module '..\models\SensitiveItem.generated.psm1'

class ProxyTunnelEntry : BaseSessionEntry 
{
	[String]$LocalHost = ''
	[int]$LocalPort = 1
	[SensitiveItem]$PasswordItem = [SensitiveItem]::new()
	[String]$ProxyHost = ''
	[int]$ProxyPort = 80
	[ProxyTunnelType]$ProxyType = [ProxyTunnelType]::new()
	[String]$RemoteHost = ''
	[int]$RemotePort = 1
	[String]$Username = ''
}
