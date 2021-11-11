using module '..\enums\ProductNames.generated.psm1'
using module '..\enums\ProductTypes.generated.psm1'

class DataSourceLicense
{
	[int]$Count = 0
	[String]$EndDate = $null
	[boolean]$ExpiringSoon = $false
	[String]$ID = $null
	[boolean]$IsAutoAssigned = $false
	[boolean]$IsEmpty = $false
	[boolean]$IsExpired = $false
	[boolean]$IsIncomplete = $false
	[boolean]$IsInfinit = $false
	[boolean]$IsRemoteDesktopManager = $false
	[boolean]$IsSubscription = $false
	[boolean]$IsValid = $false
	[object]$LargeImage = $null
	[String]$LicenseDescription = ''
	[int]$LicenseSort = 0
	[int]$MaximumUsers = $null
	[String]$MaximumUsersLabel = ''
	[String]$ProductDescription = ''
	[boolean]$IsModule = $false
	[ProductNames]$ProductName = [ProductNames]::new()
	[ProductTypes]$ProductType = [ProductTypes]::new()
	[String]$Serial = ''
	[object]$SmallImage = $null
	[String]$StartDate = $null
	[String]$SvgName = ''
}
