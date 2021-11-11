using module '..\enums\ApplicationPlatform.generated.psm1'
using module '..\enums\ApplicationSource.generated.psm1'

class ClientApplicationInfo
{
	[String]$ApplicationName = ''
	[ApplicationPlatform]$ApplicationPlatform = [ApplicationPlatform]::new()
	[ApplicationSource]$ApplicationSource = [ApplicationSource]::new()
	[String]$PlatformName = ''
	[String]$Version = ''
}
