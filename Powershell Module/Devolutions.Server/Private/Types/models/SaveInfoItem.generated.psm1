using module '..\enums\SaveMode.generated.psm1'
using module '..\enums\SaveResult.generated.psm1'

class SaveInfoItem
{
	[String]$ID = $null
	[SaveResult]$Result = [SaveResult]::new()
	[SaveMode]$SaveMode = [SaveMode]::new()
}
