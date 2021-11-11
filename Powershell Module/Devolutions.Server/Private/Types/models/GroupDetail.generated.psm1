using module '..\models\BaseSessionEntry.generated.psm1'
using module '..\enums\GroupConnectionType.generated.psm1'
using module '..\models\SensitiveItem.generated.psm1'

class GroupDetail : BaseSessionEntry 
{
	[boolean]$AllowAddEntryInGroup = $true
	[String]$ConnectionString = ''
	[String]$ConsoleHost = ''
	[SensitiveItem]$ConsolePasswordItem = [SensitiveItem]::new()
	[String]$ConsoleUserName = ''
	[String]$Domain = ''
	[GroupConnectionType]$GroupType = [GroupConnectionType]::new()
	[String]$Host = ''
	[String]$IP = ''
	[SensitiveItem]$PasswordItem = [SensitiveItem]::new()
	[boolean]$ShowComputersOnDashboard = $false
	[boolean]$ShowGroupsOnDashboard = $false
	[boolean]$ShowUsersOnDashboard = $false
	[String]$UserName = ''
}
