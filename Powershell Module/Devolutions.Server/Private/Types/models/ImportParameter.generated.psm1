using module '..\enums\DuplicateAction.generated.psm1'

class ImportParameter
{
	[DuplicateAction]$DuplicationAction = [DuplicateAction]::new()
}
