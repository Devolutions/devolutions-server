using module '..\models\BaseExternalUserId.generated.psm1'
using module '..\enums\ServerUserType.generated.psm1'

class ADUserId : BaseExternalUserId 
{
	[String]$DomainName = ''
	[ServerUserType]$ServerUserType = [ServerUserType]::new()
	[String]$Sid = ''
}
