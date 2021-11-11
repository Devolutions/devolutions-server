using module '..\models\DomainGroup.generated.psm1'

class DomainGroupExists : DomainGroup 
{
	[boolean]$AlreadyExists = $null
}
