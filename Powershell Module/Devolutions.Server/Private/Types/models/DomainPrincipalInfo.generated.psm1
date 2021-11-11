using module '..\models\GroupPrincipal.generated.psm1'
using module '..\models\UserPrincipal.generated.psm1'

class DomainPrincipalInfo
{
	[GroupPrincipal]$GroupPrincipals = [GroupPrincipal]::new()
	[UserPrincipal]$UserPrincipal = [UserPrincipal]::new()
}
