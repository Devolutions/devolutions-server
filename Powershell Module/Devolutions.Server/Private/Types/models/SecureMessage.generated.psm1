using module '..\models\SecureBase.generated.psm1'

class SecureMessage : SecureBase 
{
	[String]$CreationDate = $null
	[String]$ExpiresDate = $null
	[String]$ReadDate = $null
	[String]$RecipientUserId = $null
	[String]$SenderUserId = $null
	[String]$Subject = ''
}
