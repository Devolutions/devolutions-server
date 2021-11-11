
class BaseCustomSecurity
{
	[boolean]$AllowDragAndDrop = $true
	[boolean]$CanExport = $true
	[boolean]$CanImport = $true
	[boolean]$CanMove = $true
	[boolean]$CanSaveRecordings = $false
	[boolean]$CanViewDetails = $true
	[boolean]$CanViewGlobalLogs = $true
	[boolean]$CanViewInformations = $true
	[string[]]$CustomRoles = [string[]]::new()
	[string[]]$DenyAdd = [string[]]::new()
	[boolean]$DenyAddInRoot = $false
	[string[]]$DenyDelete = [string[]]::new()
	[string[]]$DenyEdit = [string[]]::new()
	[string[]]$DenyReveal = [string[]]::new()
	[boolean]$IntegratedSecurity = $false
	[String]$SubDataSource = ''
	[String]$UserSettingsValue = ''
}
