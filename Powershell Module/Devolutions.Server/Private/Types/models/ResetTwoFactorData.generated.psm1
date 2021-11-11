using module '..\models\RDMOLoginParameters.generated.psm1'

class ResetTwoFactorData
{
	[RDMOLoginParameters]$RDMOLoginParameters = [RDMOLoginParameters]::new()
	[String]$UserName = ''
}
