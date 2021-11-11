using module '..\enums\BrowserExtensionLinkerCompareType.generated.psm1'

class EquivalentUrlItem
{
	[BrowserExtensionLinkerCompareType]$CompareType = [BrowserExtensionLinkerCompareType]::new()
	[String]$Url = ''
}
