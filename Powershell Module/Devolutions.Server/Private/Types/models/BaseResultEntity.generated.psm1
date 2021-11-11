using module '..\enums\SaveResult.generated.psm1'

class BaseResultEntity
{
	[int]$DetailedErrorID = $null
	[String]$DetailedErrorMessage = ''
	[String]$ErrorMessage = ''
	[boolean]$Exists = $null
	[boolean]$IsWarning = $false
	[SaveResult]$Result = [SaveResult]::new()
}
