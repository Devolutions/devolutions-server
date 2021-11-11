using module '..\models\BaseConnectionInfo.generated.psm1'
using module '..\models\ValidationErrorEntity.generated.psm1'

class ImportAnalyzeResult
{
	[BaseConnectionInfo]$BaseConnectionInfo = [BaseConnectionInfo]::new()
	[boolean]$CanAdd = $false
	[boolean]$CanEdit = $false
	[boolean]$IsDuplicate = $false
	[boolean]$Supported = $true
	[boolean]$Valid = $false
	[ValidationErrorEntity]$ValidationErrors = [ValidationErrorEntity]::new()
}
