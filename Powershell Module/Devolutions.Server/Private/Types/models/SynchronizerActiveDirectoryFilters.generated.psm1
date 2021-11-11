using module '..\enums\ActiveDirectoryComputerType.generated.psm1'

class SynchronizerActiveDirectoryFilters
{
	[ActiveDirectoryComputerType]$ActiveDirectoryComputerType = [ActiveDirectoryComputerType]::new()
	[String]$Filter = ''
}
