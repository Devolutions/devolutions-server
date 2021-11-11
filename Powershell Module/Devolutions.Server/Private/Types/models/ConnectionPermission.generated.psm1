using module '..\enums\SecurityRoleOverride.generated.psm1'
using module '..\enums\SecurityRoleRight.generated.psm1'

class ConnectionPermission
{
	[boolean]$IsEmpty = $false
	[SecurityRoleOverride]$Override = [SecurityRoleOverride]::new()
	[SecurityRoleRight]$Right = [SecurityRoleRight]::new()
	[string[]]$Roles = @()
}
