using module '..\models\WebCredentialCustomAutoFillHtmlItem.generated.psm1'

class WebCredentials
{
	[String]$CustomJavascript = ''
	[String]$Domain = ''
	[String]$DomainHtmlElementName = ''
	[String]$Icon = ''
	[boolean]$IsPrivate = $false
	[String]$Login = ''
	[boolean]$MustRetrievePassword = $false
	[String]$Name = ''
	[String]$Otp = ''
	[String]$OtpHtmlElementName = ''
	[String]$Password = ''
	[String]$PasswordHtmlElementName = ''
	[String]$SubmitHtmlElementName = ''
	[String]$UsernameHtmlElementName = ''
	[String]$Uuid = ''
	[WebCredentialCustomAutoFillHtmlItem]$WebCustomAutoFillHtmlItem = [WebCredentialCustomAutoFillHtmlItem]::new()
}
