using module '..\enums\SecurityRoleDataSourceRight.generated.psm1'
using module '..\enums\SecurityRoleOverride.generated.psm1'

class DataSourcePermission
{
	[boolean]$DataSourcePermissionDefaultValue = $false
	[SecurityRoleOverride]$DataSourcePermissionValue = [SecurityRoleOverride]::new()
	[boolean]$IsEmpty = $false
	[SecurityRoleOverride]$Override = [SecurityRoleOverride]::new()
	[SecurityRoleDataSourceRight]$Right = [SecurityRoleDataSourceRight]::new()
	[string[]]$Roles = @()
}
