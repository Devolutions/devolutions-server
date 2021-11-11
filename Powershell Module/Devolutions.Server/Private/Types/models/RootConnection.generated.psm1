using module '..\models\BaseConnection.generated.psm1'
using module '..\models\DataSourcePermission.generated.psm1'
using module '..\models\HandbookStyleSheet.generated.psm1'
using module '..\models\HandbookTemplate.generated.psm1'
using module '..\enums\HandbookTemplateType.generated.psm1'

class RootConnection : BaseConnection 
{
	[boolean]$AllowClearPasswordHistory = $true
	[boolean]$AllowDataEntryMultiSelect = $false
	[boolean]$AllowInformationNote = $false
	[boolean]$AllowRTF = $false
	[boolean]$AllowVPNChaining = $false
	[int]$DataVersion = 0
	[String]$Domain = ''
	[String]$HandbookDefaultCustomTemplateID = ''
	[HandbookStyleSheet]$HandbookStyleSheets = [HandbookStyleSheet]::new()
	[HandbookTemplate]$HandbookTemplates = [HandbookTemplate]::new()
	[HandbookTemplateType]$HandbookTemplateType = [HandbookTemplateType]::new()
	[String]$Password = ''
	[DataSourcePermission]$Permissions = [DataSourcePermission]::new()
	[String]$SafePassword = ''
	[String]$TreeViewCustomField1ColumnLabel = ''
	[String]$TreeViewCustomField2ColumnLabel = ''
	[String]$TreeViewCustomField3ColumnLabel = ''
	[String]$TreeViewCustomField4ColumnLabel = ''
	[String]$TreeViewCustomField5ColumnLabel = ''
	[String]$UserName = ''
}
