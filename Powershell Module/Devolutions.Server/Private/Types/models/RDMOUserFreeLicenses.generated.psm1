using module '..\models\RDMOUserLicense.generated.psm1'

class RDMOUserFreeLicenses
{
	[RDMOUserLicense]$RemoteDesktopManager = [RDMOUserLicense]::new()
}
