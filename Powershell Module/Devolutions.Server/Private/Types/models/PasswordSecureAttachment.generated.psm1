using module '..\models\PasswordMessageContent.generated.psm1'
using module '..\models\SecureAttachment.generated.psm1'

class PasswordSecureAttachment : SecureAttachment 
{
	[PasswordMessageContent]$Content = [PasswordMessageContent]::new()
}
