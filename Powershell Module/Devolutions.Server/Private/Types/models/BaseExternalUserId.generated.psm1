using module '..\enums\ServerUserType.generated.psm1'

class BaseExternalUserId
{
	[ServerUserType]$ServerUserType = [ServerUserType]::new()
}
