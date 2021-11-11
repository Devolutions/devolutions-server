using module '..\models\BaseConnection.generated.psm1'
using module '..\enums\JumpType.generated.psm1'

class JumpConnection : BaseConnection 
{
	[String]$ConnectionID = ''
	[boolean]$FilterIsJumpHost = $true
	[JumpType]$JumpType = [JumpType]::new()
}
