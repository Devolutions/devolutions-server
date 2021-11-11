using module '..\enums\BrowserExtensionLinkerCompareType.generated.psm1'

class BrowserExtensionMetaData
{
	[boolean]$Enabled = $false
	[boolean]$UseRegularExpression = $false
	[String]$RegularExpression = ''
	[BrowserExtensionLinkerCompareType]$CompareType = [BrowserExtensionLinkerCompareType]::new()
}
