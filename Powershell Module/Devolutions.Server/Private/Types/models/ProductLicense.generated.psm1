using module '..\enums\ProductNames.generated.psm1'
using module '..\enums\ProductTypes.generated.psm1'

class ProductLicense
{
	[String]$Name = ''
	[ProductNames]$Product = [ProductNames]::new()
	[ProductTypes]$Type = [ProductTypes]::new()
	[String]$Version = ''
}
