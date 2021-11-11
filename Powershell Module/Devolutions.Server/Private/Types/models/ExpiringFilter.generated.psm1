
class ExpiringFilter
{
	[String]$RepositoryId = $null
	[String]$RepositoriesId = $null
	[String]$ConnectionType = $null
	[String]$ConnectionSubType = $null
	[boolean]$IncludeExpired = $true
	[boolean]$IncludeStatusExpired = $false
	[int]$NumberOfDays = 0
}
