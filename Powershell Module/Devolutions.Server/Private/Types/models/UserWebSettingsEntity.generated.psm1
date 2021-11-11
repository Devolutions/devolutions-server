using module '..\enums\DateTimeFormatMode.generated.psm1'
using module '..\enums\LauncherConnection.generated.psm1'
using module '..\enums\WebHomePageType.generated.psm1'

class UserWebSettingsEntity
{
	[String]$CacheID = ''
	[String]$CustomDateFormat = ''
	[String]$CustomTimeFormat = ''
	[DateTimeFormatMode]$DateTimeFormatMode = [DateTimeFormatMode]::new()
	[int]$DefaultPageSize = 10
	[String]$DisplayDateFormat = ''
	[String]$DisplayTimeFormat = ''
	[LauncherConnection]$LauncherConnectionMode = [LauncherConnection]::new()
	[WebHomePageType]$NavigationPage = [WebHomePageType]::new()
	[String]$Theme = ''
	[boolean]$ShowRepositoryImageInTreeView = $false
	[boolean]$DisableVaultDashboardOverview = $false
}
