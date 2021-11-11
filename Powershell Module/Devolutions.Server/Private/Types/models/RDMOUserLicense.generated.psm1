using module '..\enums\UserLicenseType.generated.psm1'

class RDMOUserLicense
{
	[String]$CreationDate = $null
	[String]$Description = ''
	[String]$ID = $null
	[String]$LicenseExpiration = $null
	[String]$LicenseName = ''
	[String]$LicenseSerial = ''
	[UserLicenseType]$LicenseType = [UserLicenseType]::new()
	[String]$ProductName = ''
	[String]$ProductVersion = ''
}
