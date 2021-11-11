using module '..\enums\ReportType.generated.psm1'
using module '..\models\Scheduling.generated.psm1'

class ScheduledReportEntity
{
	[String]$CreatedBy = ''
	[String]$CreatedUtc = $null
	[String]$EmailAddresses = ''
	[boolean]$SendAsAdministrator = $false
	[boolean]$SendEmpty = $false
	[String]$Filter = ''
	[String]$ID = $null
	[String]$LastRun = $null
	[String]$ModifiedBy = ''
	[String]$ModifiedUtc = $null
	[String]$Name = ''
	[String]$NextRun = $null
	[String]$Recipients = ''
	[ReportType]$ReportType = [ReportType]::new()
	[Scheduling]$Scheduling = [Scheduling]::new()
}
