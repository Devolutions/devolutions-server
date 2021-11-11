using module '..\enums\DefaultBoolean.generated.psm1'

class DataEntrySoftware
{
	[String]$Software = ''
	[String]$SoftwareBuild = ''
	[String]$SoftwareEmail = ''
	[String]$SoftwareExpiration = $null
	[boolean]$SoftwareIsAutomaticRenewal = $false
	[boolean]$SoftwareIsSubscription = $false
	[String]$SoftwareLanguage = ''
	[int]$SoftwareLicenseCount = 1
	[String]$SoftwareManufacturer = ''
	[String]$SoftwarePurchase = $null
	[String]$SoftwareSerials = ''
	[String]$SoftwareSupplier = ''
	[String]$SoftwareUserName = ''
	[String]$SoftwareVersion = ''
	[String]$Url = ''
	[DefaultBoolean]$IsHidden = [DefaultBoolean]::new()
}
