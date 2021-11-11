using module '..\enums\ConnectionLogGridDateKind.generated.psm1'

class LogAdministrationFilter
{
	[ConnectionLogGridDateKind]$DateKind = [ConnectionLogGridDateKind]::new()
	[String]$EndDate = $null
	[String]$EndDateUTC = $null
	[String]$FilterName = ''
	[String]$LoggedUserName = ''
	[String]$MachineName = ''
	[String]$Message = ''
	[String]$StartDate = $null
	[String]$StartDateUTC = $null
	[String]$TicketNumber = ''
	[String]$UserName = ''
}
