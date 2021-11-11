using module '..\models\SecureAttachmentInfo.generated.psm1'

class SecureMessageContent
{
	[String]$Message = ''
	[SecureAttachmentInfo]$AttachmentInfos = [SecureAttachmentInfo]::new()
}
