using module '..\enums\SecureAttachmentType.generated.psm1'
using module '..\models\SecureBase.generated.psm1'

class SecureAttachment : SecureBase 
{
	[SecureAttachmentType]$AttachmentType = [SecureAttachmentType]::new()
	[String]$RecipientUserId = $null
	[String]$SenderUserId = $null
	[String]$Title = ''
}
