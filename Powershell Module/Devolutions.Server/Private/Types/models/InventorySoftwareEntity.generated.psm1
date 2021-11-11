using module '..\models\InventoryGenericEntity.generated.psm1'

class InventorySoftwareEntity : InventoryGenericEntity 
{
	[String]$IDFieldName = ''
	[String]$TableName = ''
	[int]$AssignmentType = 0
	[String]$Caption = ''
	[String]$Description = ''
	[String]$DeviceID = $null
	[String]$HelpLink = ''
	[String]$HelpTelephone = ''
	[String]$ID = $null
	[String]$IdentifyingNumber = ''
	[String]$InstallDate2 = ''
	[String]$InstallDateTime = $null
	[String]$InstallLocation = ''
	[String]$InstallSource = ''
	[String]$InstallState = ''
	[String]$Language = ''
	[String]$LocalPackage = ''
	[String]$Name = ''
	[String]$PackageCache = ''
	[String]$PackageCode = ''
	[String]$PackageName = ''
	[String]$ProductIdentifier = ''
	[String]$RegCompany = ''
	[String]$RegOwner = ''
	[String]$ScanID = $null
	[int]$Size = 0
	[String]$SKUNumber = ''
	[String]$Transforms = ''
	[String]$URLInfoAbout = ''
	[String]$Vendor = ''
	[String]$Version = ''
	[int]$WordCount = 0
}
