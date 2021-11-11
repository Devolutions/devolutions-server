using module '..\enums\ImagePaletteType.generated.psm1'

class GroupInfoEntity
{
	[boolean]$Add = $false
	[boolean]$Delete = $false
	[boolean]$Edit = $false
	[String]$SvgName = ''
	[ImagePaletteType]$ImagePaletteType = [ImagePaletteType]::new()
	[String]$Name = ''
	[String]$OriginalName = ''
	[boolean]$View = $false
	[String]$CreatedByLoggedUserName = ''
	[String]$CreatedByUserName = ''
	[String]$CreationDate = $null
	[String]$Description = ''
	[String]$ID = $null
	[String]$ModifiedDate = $null
	[String]$ModifiedLoggedUserName = ''
	[String]$ModifiedUserName = ''
}
