
class BrowserExtensionMetaData {
	[boolean]$Enabled
	[boolean]$UseRegularExpression
	[String]$RegularExpression
	[BrowserExtensionLinkerCompareType]$CompareType

	BrowserExtensionMetaData() {
		$this.CompareType = [BrowserExtensionLinkerCompareType]::Default
	}
}
