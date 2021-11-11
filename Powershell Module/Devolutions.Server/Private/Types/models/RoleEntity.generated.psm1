using module '..\enums\RoleType.generated.psm1'
using module '..\models\UserEntity.generated.psm1'

class RoleEntity : UserEntity 
{
	[boolean]$IsFromActiveDirectory = $false
	[RoleType]$RoleType = [RoleType]::new()
}
