using module '..\enums\SecureAttachmentType.generated.psm1'

class SecureAttachmentInfo
{
	[String]$Id = $null
	[SecureAttachmentType]$Type = [SecureAttachmentType]::new()
	[String]$Title = ''
}
