using module '..\models\ConnectionAttachmentContent.generated.psm1'
using module '..\models\SecureAttachment.generated.psm1'

class ConnectionSecureAttachment : SecureAttachment 
{
	[ConnectionAttachmentContent]$Content = [ConnectionAttachmentContent]::new()
}
